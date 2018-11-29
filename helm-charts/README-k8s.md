# Deployment on Kubernetes

MassBank can also be deployed as a cloud server, using docker containers and 
the https://kubernetes.io/ container orchestration framework. To simplify
the deployment, we are using Helm charts based on https://github.com/helm/charts

## MassBank container

We are automatically building a Docker container for the MassBank-web
`master` branch. This contains the `*.war` files, and the database 
initialisation from `MassBank-web/MassBank-Project/MassBank-lib`.
The container builds are available from 
https://hub.docker.com/r/sneumann/massbank-web-war

## Helm

```
helm init 
helm repo add massbank-helm-repo https://massbank.github.io/MassBank-web
```

### MariaDB database

We are using a the official helm chart for the MariaDB, 
and add the MassBank schema initialisation scripts. 

The resulting chart can be installed via:

```
helm install --name massbank-mariadb --set slave.replicas=0 massbank-helm-repo/mariadb
#helm install --name massbank-mariadb --set slave.replicas=0 mariadb-5.2.3.tgz
```

### Create configmap with stuff
kubectl create configmap massbank-conf --from-file=massbank.conf

### Database import

Once the database and the configMap are there, we populate 
the database with the records from
https://github.com/MassBank/MassBank-data.

```
kubectl create -f massbank-data.yaml
```

## Tomcat container

With that information, we can deploy the Tomcat8 web application server,
with the MassBank web application provided through the above
`massbank-web-war` container. Our modification of the Helm chart 
is only the injection of the `massbank.conf` file via the configMap.

```
helm install --name massbank-tomcat --set \
  image.webarchive.repository=sneumann/massbank-web-war,image.webarchive.tag=latest,image.tomcat.tag=8-jre8,service.type=ClusterIP,\
ingress.enabled=true,ingress.hosts[0]="massbank.134.176.27.229.nip.io",ingress.annotations=kubernetes.io/ingress.class="traefik"\
  massbank-helm-repo/tomcat
```
