CREATE EXTERNAL TABLE ext_tpch.region
(R_REGIONKEY INTEGER, 
R_NAME CHAR(25),
R_COMMENT VARCHAR(152),
dummy text)
LOCATION (:LOCATION)
FORMAT 'TEXT' (DELIMITER '|' NULL AS '' ESCAPE AS E'\\');
