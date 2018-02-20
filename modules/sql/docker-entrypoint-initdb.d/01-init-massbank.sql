DROP DATABASE IF EXISTS MassBank;
CREATE DATABASE MassBank CHARACTER SET = 'latin1';
USE MassBank;

--
-- Table structure for table `INSTRUMENT`
--
DROP TABLE IF EXISTS INSTRUMENT;
CREATE TABLE INSTRUMENT (
	INSTRUMENT_NO      TINYINT UNSIGNED NOT NULL,
	INSTRUMENT_TYPE    VARCHAR(50)      NOT NULL,
	INSTRUMENT_NAME    VARCHAR(200)     NOT NULL,
	PRIMARY KEY(INSTRUMENT_NO)
);

--
-- Table structure for table `RECORD`
--
DROP TABLE IF EXISTS RECORD;
CREATE TABLE RECORD (
	ID            CHAR(8) 			NOT NULL,
	-- general information
	RECORD_TITLE  VARCHAR(255) 		NOT NULL,	-- add
	DATE          DATE 				NOT NULL,
	AUTHORS       VARCHAR(255)		NOT NULL,	-- add
	LICENSE       VARCHAR(255)		NOT NULL,	-- add
	COPYRIGHT     VARCHAR(255),     			-- add
	PUBLICATION   VARCHAR(255),     			-- add
	-- structure information
	FORMULA       VARCHAR(255)		NOT NULL,	-- mod size
	EXACT_MASS    DOUBLE			NOT NULL,
	INSTRUMENT_NO TINYINT UNSIGNED	NOT NULL,
	-- miscellaneous
	PK_SPLASH     VARCHAR(255)		NOT NULL,	-- add
	SMILES        TEXT,
	IUPAC         TEXT,
	MS_TYPE       VARCHAR(8)		NOT NULL,
	-- table setup
	PRIMARY KEY(ID),
	FOREIGN KEY (INSTRUMENT_NO)					-- add
		REFERENCES INSTRUMENT(INSTRUMENT_NO)	-- add
		ON DELETE NO ACTION						-- add
		ON UPDATE CASCADE,						-- add
	INDEX(RECORD_TITLE, AUTHORS, FORMULA, EXACT_MASS, INSTRUMENT_NO, MS_TYPE) -- mod
);

--
-- Table structure for table `PEAK`
--
DROP TABLE IF EXISTS PEAK;
CREATE TABLE PEAK (					-- table can be removed it's info will be contained in table MS_FOCUSED_ION
	ID          CHAR(8)  NOT NULL,
	MZ          DOUBLE   NOT NULL,
	INTENSITY   FLOAT    NOT NULL,
	RELATIVE    SMALLINT NOT NULL,
	-- ANNOTATION: add ??? m/z	tentative_formula	formula_count	mass	error(ppm) / 57.0701	C4H9+	1	57.0699	4.61
	-- TENTATIVE_FORMULA VARCHAR(255), -- add
	-- FORMULA_COUNT     SMALLINT,     -- add
	-- THEORETICAL_MASS  FLOAT,        -- add
	-- ERROR_PPM         FLOAT         -- add
	PRIMARY KEY (ID,MZ),				-- modiefied form UNIQUE
	FOREIGN KEY (ID)					-- add
		REFERENCES RECORD(ID)			-- add
		ON DELETE CASCADE				-- add
		ON UPDATE CASCADE				-- add
);

--
-- View structure for view 'PK_NUM'
--
DROP VIEW IF EXISTS PK_NUM;					-- add
CREATE VIEW PK_NUM AS 						-- add
	SELECT ID, count(ID) AS PK$NUM_PEAK 	-- add
	FROM PEAK 								-- add
	GROUP BY ID;							-- add

--
-- Table structure for table `SPECTRUM`
--
DROP TABLE IF EXISTS SPECTRUM;
CREATE TABLE SPECTRUM (
	ID          CHAR(8)      NOT NULL,
	NAME        VARCHAR(255) NOT NULL,
	ION         TINYINT      NOT NULL,
	PRECURSOR_MZ SMALLINT UNSIGNED,
	PRIMARY KEY (ID),
	FOREIGN KEY (ID)						-- add
		REFERENCES RECORD(ID)				-- add
		ON DELETE CASCADE					-- add
		ON UPDATE CASCADE					-- add
);

--
-- Table structure for table `TREE`
--
DROP TABLE IF EXISTS TREE;
CREATE TABLE TREE (
	NO          INT UNSIGNED      NOT NULL,
	PARENT      INT UNSIGNED      NOT NULL,
	POS         SMALLINT UNSIGNED NOT NULL,
	SON         SMALLINT          NOT NULL,
	INFO        VARCHAR(255)      NOT NULL, -- mod size
	ID          CHAR(8),
	INDEX(PARENT),
	INDEX(ID), 
	FOREIGN KEY (ID)						-- add
		REFERENCES RECORD(ID)				-- add
		ON DELETE CASCADE					-- add
		ON UPDATE CASCADE					-- add
);

--
-- Table structure for table `COMMENT`
--
DROP TABLE IF EXISTS COMMENT;               -- add
CREATE TABLE COMMENT (                      -- add
	ID              CHAR(8)      NOT NULL,  -- add
	NAME            VARCHAR(255) NOT NULL,  -- add
	PRIMARY KEY (ID, NAME),                 -- add, changed from INDEX -> PRIMARY KEY
	FOREIGN KEY (ID)						-- add
		REFERENCES RECORD(ID)				-- add
		ON DELETE CASCADE					-- add
		ON UPDATE CASCADE					-- add
);                                          -- add

--
-- Table structure for table `CH_COMPOUND_CLASS`
--
DROP TABLE IF EXISTS CH_COMPOUND_CLASS;     -- add
CREATE TABLE CH_COMPOUND_CLASS (            -- add
	ID              CHAR(8)       NOT NULL, -- add
	CLASS           VARCHAR(255),           -- add
	NAME            TEXT          NOT NULL, -- add
	PRIMARY KEY (ID, CLASS),                -- add, changed from INDEX -> PRIMARY KEY
	FOREIGN KEY (ID)						-- add
		REFERENCES RECORD(ID)				-- add
		ON DELETE CASCADE					-- add
		ON UPDATE CASCADE					-- add
);                                          -- add

--
-- Table structure for table `CH_NAME`
--
DROP TABLE IF EXISTS CH_NAME;
CREATE TABLE CH_NAME (
	ID              CHAR(8)      NOT NULL,
	NAME            VARCHAR(255) NOT NULL,  -- mod size
	PRIMARY KEY (ID, NAME),                 -- mod, changed from INDEX -> PRIMARY KEY
	FOREIGN KEY (ID)						-- add
		REFERENCES RECORD(ID)				-- add
		ON DELETE CASCADE					-- add
		ON UPDATE CASCADE					-- add
);

--
-- Table structure for table `CH_LINK`
--
DROP TABLE IF EXISTS CH_LINK;
CREATE TABLE CH_LINK (
	ID              CHAR(8)      NOT NULL,
	LINK_NAME       VARCHAR(100) NOT NULL,
	LINK_ID         VARCHAR(100) NOT NULL,
	UNIQUE(ID,LINK_NAME,LINK_ID),
	PRIMARY KEY (ID, LINK_NAME),			-- changed from INDEX (ID) -> PRIMARY KEY (ID, LINK_NAME) (recrod can have multiple links)
	FOREIGN KEY (ID)						-- add
		REFERENCES RECORD(ID)				-- add
		ON DELETE CASCADE					-- add
		ON UPDATE CASCADE					-- add
);

--
-- Table structure for table `AC_MASS_SPECTROMETRY`
--
DROP TABLE IF EXISTS AC_MASS_SPECTROMETRY;      	-- add
CREATE TABLE AC_MASS_SPECTROMETRY (             	-- add
	ID              		CHAR(8)      NOT NULL,  -- add
	NAME            		VARCHAR(255) NOT NULL,  -- add
	-- COLLISION_ENERGY 		VARCHAR(255),		-- add
	-- COLLISION_GAS 			VARCHAR(255),		-- add
	-- DATE 					VARCHAR(255),		-- add
	-- DESOLVATION_GAS_FLOW 	VARCHAR(255),		-- add
	-- DESOLVATION_TEMPERATURE VARCHAR(255),		-- add
	-- IONIZATION_ENERGY 		VARCHAR(255),		-- add
	-- LASER 					VARCHAR(255),		-- add
	-- MATRIX 					VARCHAR(255),		-- add
	-- MASS_ACCURACY 			VARCHAR(255),		-- add
	-- REAGENT_GAS 				VARCHAR(255),		-- add
	-- SCANNING 				VARCHAR(255),		-- add
	PRIMARY KEY (ID, NAME),							-- add, changed from INDEX -> PRIMARY KEY
	FOREIGN KEY (ID)								-- add
		REFERENCES RECORD(ID)						-- add
		ON DELETE CASCADE							-- add
		ON UPDATE CASCADE							-- add
);

--
-- Table structure for table `AC_CHROMATOGRAPHY`
--
DROP TABLE IF EXISTS AC_CHROMATOGRAPHY;         -- add
CREATE TABLE AC_CHROMATOGRAPHY (                -- add
	ID              	CHAR(8)      NOT NULL,  -- add
	NAME            	VARCHAR(255) NOT NULL,  -- add
	-- CAPILLARY_VOLTAGE	VARCHAR(255),		-- add
	-- COLUMN_NAME			VARCHAR(255),		-- add
	-- COLUMN_TEMPERATURE	VARCHAR(255),		-- add
	-- FLOW_GRADIENT		VARCHAR(255),		-- add
	-- FLOW_RATE			VARCHAR(255),		-- add
	-- RETENTION_TIME		VARCHAR(255),		-- add
	-- SOLVENT				VARCHAR(255),		-- add
	-- NAPS_RTI			VARCHAR(255), 			-- add
	PRIMARY KEY (ID, NAME),						-- add, changed from INDEX -> PRIMARY KEY
	FOREIGN KEY (ID)							-- add
		REFERENCES RECORD(ID)					-- add
		ON DELETE CASCADE						-- add
		ON UPDATE CASCADE						-- add
);

--
-- Table structure for table `MS_FOCUSED_ION`
--
DROP TABLE IF EXISTS MS_FOCUSED_ION;        -- add
CREATE TABLE MS_FOCUSED_ION (               -- add
	ID              CHAR(8)      NOT NULL,  -- add
	NAME            VARCHAR(255) NOT NULL,  -- add
	-- BASE_PEAK		VARCHAR(255),		-- add
	-- DERIVATIVE_FORM	VARCHAR(255),		-- add
	-- DERIVATIVE_MASS	VARCHAR(255),		-- add
	-- DERIVATIVE_TYPE	VARCHAR(255),		-- add
	-- ION_TYPE		VARCHAR(255),			-- add
	-- PRECURSOR_MZ	VARCHAR(255),			-- add
	-- PRECURSOR_TYPE	VARCHAR(255),		-- add
	PRIMARY KEY (ID, NAME),					-- add, changed from INDEX -> PRIMARY KEY
	FOREIGN KEY (ID)						-- add
		REFERENCES RECORD(ID)				-- add
		ON DELETE CASCADE					-- add
		ON UPDATE CASCADE					-- add
);

--
-- Table structure for table `MS_DATA_PROCESSING`
--
DROP TABLE IF EXISTS MS_DATA_PROCESSING;    -- add
CREATE TABLE MS_DATA_PROCESSING (           -- add
	ID              CHAR(8)      NOT NULL,  -- add
	NAME            VARCHAR(255) NOT NULL,  -- add
	-- FIND_PEAK		VARCHAR(255),		-- add
	-- WHOLE			VARCHAR(255),		-- add
	PRIMARY KEY (ID, NAME),					-- add, changed from INDEX -> PRIMARY KEY
	FOREIGN KEY (ID)						-- add
		REFERENCES RECORD(ID)				-- add
		ON DELETE CASCADE					-- add
		ON UPDATE CASCADE					-- add
);

-- 
-- Table structure for table `MOLFILE`
-- 
-- DROP TABLE IF EXISTS MOLFILE;
-- CREATE TABLE MOLFILE (
-- 	FILE              VARCHAR(8)        NOT NULL,
-- 	NAME              VARCHAR(100)      NOT NULL,
-- 	UNIQUE(NAME,FILE)
-- );

--
-- Table structure for table `BIOLOGICAL_SAMPLE`
--
DROP TABLE IF EXISTS BIOLOGICAL_SAMPLE;		-- add
CREATE TABLE BIOLOGICAL_SAMPLE (			-- add
	ID              CHAR(8)      NOT NULL,	-- add
	SCIENTIFIC_NAME VARCHAR(255),			-- add
	LINEAGE			VARCHAR(255),			-- add
	SAMPLE 			VARCHAR(255),			-- add
	INDEX(ID),								-- add
	PRIMARY KEY (ID),						-- add						
	FOREIGN KEY (ID)						-- add
		REFERENCES RECORD(ID)				-- add
		ON DELETE CASCADE					-- add
		ON UPDATE CASCADE					-- add
);											-- add

--
-- Table structure for table `SP_LINK`
--
DROP TABLE IF EXISTS SP_LINK;				-- add
CREATE TABLE SP_LINK (						-- add
	ID              CHAR(8)      NOT NULL,	-- add
	LINK_NAME       VARCHAR(100) NOT NULL,	-- add
	LINK_ID         VARCHAR(100) NOT NULL,	-- add
	UNIQUE(ID,LINK_NAME,LINK_ID),			-- add
	PRIMARY KEY(ID),						-- add, changed from INDEX -> PRIMARY KEY
	FOREIGN KEY (ID)						-- add
		REFERENCES RECORD(ID)				-- add
		ON DELETE CASCADE					-- add
		ON UPDATE CASCADE					-- add
);											-- add

-- INSTRUMENT Table Data
INSERT INTO `INSTRUMENT` VALUES (1,'LC-ESI-QQ','API3000, Applied Biosystems');

-- RECORD Table Data
INSERT INTO `RECORD` VALUES (
	'XXX00001','GABA; LC-ESI-QQ; MS2; CE:10 V; [M-H]- (1)','2011.12.20 (Created 2007.07.07)','Kakazu Y, Horai H, Institute for Advanced Biosciences, Keio Univ.','CC BY-NC-SA',NULL,NULL,
	'C4H9NO2',103.06333,1,
	'splash10-0udi-0900000000-1d00adad47e42c60c340', 'NCCCC(O)=O','InChI=1S/C4H9NO2/c5-3-1-2-4(6)7/h1-3,5H2,(H,6,7)','MS2'
);

-- SPECTRUM Table Data
INSERT INTO `SPECTRUM` VALUES ('XXX00001','GABA; LC-ESI-QQ; MS2; CE:10 V; [M-H]-',-1,102);

-- PEAK Table Data
INSERT INTO `PEAK` VALUES ('XXX00001',58.5,39604,1),('XXX00001',73.2,14851.5,1),('XXX00001',83.9,975248,16),('XXX00001',101.3,103960,2),('XXX00001',102,5.93961e+07,999);

-- COMMENT Table Data
INSERT INTO `COMMENT` VALUES ('XXX00001','KEIO_ID A002');

-- CH_COMPOUND_CLASS Table Data
INSERT INTO `CH_COMPOUND_CLASS` VALUES ('XXX00001','ChemOnt','Organic compounds; Organic acids and derivatives; Carboxylic acids and derivatives; Amino acids, peptides, and analogues; Amino acids and derivatives; Gamma amino acids and derivatives');

-- CH_NAME Table Data
INSERT INTO `CH_NAME` VALUES ('XXX00001','4-Aminobutanoate'),('XXX00001','4-Aminobutanoic acid'),('XXX00001','4-Aminobutylate'),('XXX00001','4-Aminobutyrate'),('XXX00001','4-Aminobutyric acid'),('XXX00001','GABA'),('XXX00001','gamma-Aminobutyric acid');

-- CH_LINK Table Data
INSERT INTO `CH_LINK` VALUES ('XXX00001','CAS','56-12-2'),('XXX00001','CHEBI','30566'),('XXX00001','KEGG','C00334'),('XXX00001','NIKKAJI','J1.375G'),('XXX00001','PUBCHEM','SID:3628');

-- AC_MASS_SPECTROMETRY Table Data
INSERT INTO `AC_MASS_SPECTROMETRY` VALUES ('XXX00001','MS_TYPE MS2'),('XXX00001','IONIZATION ESI'),('XXX00001','ION_MODE NEGATIVE'),('XXX00001','FRAGMENTATION_MODE CID'),('XXX00001','COLLISION_ENERGY 10 V'),('XXX00001','RESOLUTION 17500');

-- AC_CHROMATOGRAPHY Table Data
INSERT INTO `AC_CHROMATOGRAPHY` VALUES ('XXX00001','COLUMN_NAME XBridge C18 3.5um, 2.1x50mm, Waters'),('XXX00001','FLOW_GRADIENT 90/10 at 0 min, 50/50 at 4 min, 5/95 at 17 min, 5/95 at 25 min, 90/10 at 25.1 min, 90/10 at 30 min'),('XXX00001','FLOW_RATE 200 ul/min'),('XXX00001','RETENTION_TIME 7.6 min'),('XXX00001','SOLVENT A water with 0.1% formic acid'),('XXX00001','SOLVENT B methanol with 0.1% formic acid');

-- MS_FOCUSED_ION Table Data
INSERT INTO `MS_FOCUSED_ION` VALUES ('XXX00001','BASE_PEAK 102'),('XXX00001','PRECURSOR_M/Z 102'),('XXX00001','PRECURSOR_TYPE [M-H]-');

-- MS_DATA_PROCESSING Table Data
INSERT INTO `MS_DATA_PROCESSING` VALUES ('XXX00001','DEPROFILE Spline'),('XXX00001','RECALIBRATE loess on assigned fragments and MS1'),('XXX00001','REANALYZE Peaks with additional N2/O included'),('XXX00001','WHOLE RMassBank 1.3.1');

-- TREE Table Data
INSERT INTO `TREE` VALUES (1,0,1,1,'MassBank',NULL),(619,1,1,1,'LC-ESI-QQ',NULL),(1071,619,1,1,'MW 103',NULL),(1072,1071,1,1,'C4H9NO2',NULL),(1096,1072,1,1,'GABA',NULL),(1103,1096,1,1,'[M-H]-',NULL),(1104,1103,1,-1,'MS2  /  10 V','XXX00001');

-- MOLFILE Table Data
-- INSERT INTO `MOLFILE` VALUES ('XX000001','GABA');


DROP DATABASE IF EXISTS MassBank_General;
CREATE DATABASE MassBank_General;
USE MassBank_General;

--
-- Table structure for table `JOB_INFO`
--
DROP TABLE IF EXISTS JOB_INFO;
CREATE TABLE JOB_INFO (
	JOB_ID            VARCHAR(36)       NOT NULL,
	STATUS            VARCHAR(20)       NOT NULL,
	TIME_STAMP        VARCHAR(19)       NOT NULL,
	SESSION_ID        VARCHAR(32),
	IP_ADDR           VARCHAR(15),
	MAIL_ADDR         VARCHAR(50),
	QUERY_FILE_NAME   TEXT,
	QUERY_FILE_SIZE   INT(10) UNSIGNED,
	TEMP_FILE_NAME    TEXT,
	SEARCH_PARAM      TEXT,
	RESULT            LONGTEXT,
	PRIMARY KEY(JOB_ID)
);


DROP DATABASE IF EXISTS MassBankNew;
CREATE DATABASE MassBankNew CHARACTER SET = 'latin1' COLLATE = 'latin1_general_cs';
USE MassBankNew;

CREATE TABLE COMPOUND_CLASS (
	ID					INT	UNSIGNED	NOT NULL	AUTO_INCREMENT,
	DATABASE_NAME		VARCHAR(600),
	DATABASE_ID			VARCHAR(600),
	CH_COMPOUND_CLASS 	VARCHAR(600)	NOT NULL,
	PRIMARY KEY (ID),
	UNIQUE (DATABASE_NAME, DATABASE_ID, CH_COMPOUND_CLASS)
);

CREATE TABLE NAME (
	ID 			INT UNSIGNED	NOT NULL	AUTO_INCREMENT,
	CH_NAME		VARCHAR(600)	NOT NULL,
	PRIMARY KEY (ID),
	UNIQUE (CH_NAME)
);

CREATE TABLE COMPOUND (
	ID									INT	UNSIGNED	NOT NULL	AUTO_INCREMENT,
	CH_FORMULA							VARCHAR(600)	NOT NULL,
	CH_EXACT_MASS						DOUBLE			NOT NULL,
	CH_SMILES							VARCHAR(600)	NOT NULL,
	CH_IUPAC							VARCHAR(1200)	NOT NULL,
	CH_CDK_DEPICT_SMILES 				VARCHAR(600),
	CH_CDK_DEPICT_GENERIC_SMILES		VARCHAR(600),
	CH_CDK_DEPICT_STRUCTURE_SMILES		VARCHAR(600),
	PRIMARY KEY (ID)
);

CREATE TABLE COMPOUND_COMPOUND_CLASS (
	COMPOUND 	INT UNSIGNED	NOT NULL,
	CLASS 		INT UNSIGNED 	NOT NULL,
	PRIMARY KEY (COMPOUND, CLASS),
	FOREIGN KEY (COMPOUND)
		REFERENCES COMPOUND(ID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY (CLASS)
		REFERENCES COMPOUND_CLASS(ID)
		ON UPDATE CASCADE
		ON DELETE NO ACTION
);

CREATE TABLE COMPOUND_NAME (
	COMPOUND	INT	UNSIGNED	NOT NULL,
	NAME 		INT UNSIGNED	NOT NULL,
	PRIMARY KEY (COMPOUND, NAME),
	FOREIGN KEY (COMPOUND)
		REFERENCES COMPOUND(ID)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY (NAME)
		REFERENCES NAME(ID)
		ON UPDATE CASCADE
		ON DELETE NO ACTION
);

CREATE TABLE CH_LINK (
	COMPOUND 		INT	UNSIGNED	NOT NULL,
	DATABASE_NAME	VARCHAR(600)	NOT NULL,
	DATABASE_ID		VARCHAR(600)	NOT NULL,
	PRIMARY KEY (COMPOUND, DATABASE_NAME, DATABASE_ID),
	FOREIGN KEY (COMPOUND)
		REFERENCES COMPOUND(ID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE SAMPLE (
	ID 						INT UNSIGNED	NOT NULL	AUTO_INCREMENT,
	SP_SCIENTIFIC_NAME 		VARCHAR(600),
	SP_LINEAGE 				VARCHAR(600),
	PRIMARY KEY (ID)
);

delimiter //
CREATE TRIGGER upd_check BEFORE INSERT ON SAMPLE
       FOR EACH ROW
       BEGIN
           IF ((NEW.SP_SCIENTIFIC_NAME IS NULL) AND (NEW.SP_LINEAGE IS NULL)) THEN
               SET NEW.ID = -1;
           END IF;
       END;//
delimiter ;

CREATE TABLE SP_LINK (
	SAMPLE 			INT UNSIGNED	NOT NULL,
	SP_LINK			VARCHAR(600),
	PRIMARY KEY (SAMPLE, SP_LINK),
	FOREIGN KEY (SAMPLE)
		REFERENCES SAMPLE(ID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE SP_SAMPLE (
	SAMPLE 			INT UNSIGNED		NOT NULL,
	SP_SAMPLE		VARCHAR(600)		NOT NULL,
	PRIMARY KEY (SAMPLE, SP_SAMPLE),
	FOREIGN KEY (SAMPLE)
		REFERENCES SAMPLE(ID)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE INSTRUMENT (
	ID					INT UNSIGNED 	NOT NULL	AUTO_INCREMENT,
	AC_INSTRUMENT 		VARCHAR(600)	NOT NULL,
	AC_INSTRUMENT_TYPE	VARCHAR(600)	NOT NULL,
	PRIMARY KEY (ID)
);

CREATE TABLE CONTRIBUTOR (
	ID				INT UNSIGNED 	NOT NULL	AUTO_INCREMENT,
	ACRONYM 		VARCHAR(255),
	SHORT_NAME		VARCHAR(255) 	NOT NULL,
	FULL_NAME		VARCHAR(255),
	PRIMARY KEY (ID),
	UNIQUE(ACRONYM),
	UNIQUE(SHORT_NAME),
	UNIQUE(FULL_NAME)
);

CREATE TABLE RECORD (
	ACCESSION										VARCHAR(255)	NOT NULL,
	RECORD_TITLE									VARCHAR(600)	NOT NULL,
	DATE											VARCHAR(600)	NOT NULL,
	AUTHORS											VARCHAR(600)	NOT NULL,
	LICENSE											VARCHAR(600)	NOT NULL,
	COPYRIGHT										VARCHAR(600),
	PUBLICATION										VARCHAR(600),
	CH												INT	UNSIGNED	NOT NULL,
	SP												INT UNSIGNED,
	AC_INSTRUMENT 									INT UNSIGNED	NOT NULL,
	AC_MASS_SPECTROMETRY_MS_TYPE					VARCHAR(600)	NOT NULL,
	AC_MASS_SPECTROMETRY_ION_MODE					VARCHAR(600)	NOT NULL,
	PK_SPLASH										VARCHAR(600)	NOT NULL,
	CONTRIBUTOR										INT UNSIGNED	NOT NULL,
	PRIMARY KEY (ACCESSION),
	FOREIGN KEY (CH)
		REFERENCES COMPOUND(ID)
		ON UPDATE CASCADE
		ON DELETE NO ACTION,
	FOREIGN KEY (SP)
		REFERENCES SAMPLE(ID)
		ON UPDATE CASCADE
		ON DELETE NO ACTION,
	FOREIGN KEY (AC_INSTRUMENT)
		REFERENCES INSTRUMENT(ID)
		ON UPDATE CASCADE
		ON DELETE NO ACTION,
	FOREIGN KEY (CONTRIBUTOR)
		REFERENCES CONTRIBUTOR(ID)
		ON UPDATE CASCADE
		ON DELETE NO ACTION
);

CREATE TABLE COMMENT (
	RECORD 		VARCHAR(255)		NOT NULL,
	COMMENT		VARCHAR(600)		NOT NULL,
	PRIMARY KEY (RECORD, COMMENT),
	FOREIGN KEY (RECORD)
		REFERENCES RECORD(ACCESSION)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE AC_MASS_SPECTROMETRY (
	RECORD 		VARCHAR(255)	NOT NULL,
	SUBTAG		VARCHAR(600)	NOT NULL,
	VALUE		VARCHAR(600)	NOT NULL,
	-- PRIMARY KEY (RECORD, SUBTAG),
	PRIMARY KEY (RECORD, SUBTAG, VALUE),
	FOREIGN KEY (RECORD)
		REFERENCES RECORD(ACCESSION)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE AC_CHROMATOGRAPHY (
	RECORD 		VARCHAR(255)	NOT NULL,
	SUBTAG		VARCHAR(600)	NOT NULL,
	VALUE		VARCHAR(600)	NOT NULL,
	-- PRIMARY KEY (RECORD, SUBTAG),
	PRIMARY KEY (RECORD, SUBTAG, VALUE),
	FOREIGN KEY (RECORD)
		REFERENCES RECORD(ACCESSION)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE MS_FOCUSED_ION (
	RECORD 		VARCHAR(255)	NOT NULL,
	SUBTAG		VARCHAR(600)	NOT NULL,
	VALUE		VARCHAR(600)	NOT NULL,
	-- PRIMARY KEY (RECORD, SUBTAG),
	PRIMARY KEY (RECORD, SUBTAG, VALUE),
	FOREIGN KEY (RECORD)
		REFERENCES RECORD(ACCESSION)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE MS_DATA_PROCESSING (
	RECORD 		VARCHAR(255)	NOT NULL,
	SUBTAG		VARCHAR(600)	NOT NULL,
	VALUE		VARCHAR(600)	NOT NULL,
	-- PRIMARY KEY (RECORD, SUBTAG),
	PRIMARY KEY (RECORD, SUBTAG, VALUE),
	FOREIGN KEY (RECORD)
		REFERENCES RECORD(ACCESSION)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE PEAK (
	RECORD 								VARCHAR(255)		NOT NULL,
	PK_PEAK_MZ 							DOUBLE 				NOT NULL,
	PK_PEAK_INTENSITY 					FLOAT 				NOT NULL,
	PK_PEAK_RELATIVE 					SMALLINT 			NOT NULL,
	-- PK_ANNOTATION_TENTATIVE_FORMULA 	VARCHAR(600),
	-- PK_ANNOTATION_FORMULA_COUNT 		SMALLINT,
	-- PK_ANNOTATION_THEORETICAL_MASS		FLOAT,
	-- PK_ANNTOATION_ERROR_PPM 			FLOAT,
	PK_ANNOTATION 						VARCHAR(600),
	PRIMARY KEY (RECORD,PK_PEAK_MZ),
	FOREIGN KEY (RECORD)
		REFERENCES RECORD(ACCESSION)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE ANNOTATION_HEADER (
	RECORD VARCHAR(255) NOT NULL,
	HEADER VARCHAR(600) NOT NULL,
	PRIMARY KEY (RECORD),
	FOREIGN KEY (RECORD)
		REFERENCES PEAK(RECORD)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE VIEW PK_NUM_PEAK AS 
	SELECT RECORD, COUNT(RECORD) AS PK_NUM_PEAK
	FROM PEAK
	GROUP BY RECORD;