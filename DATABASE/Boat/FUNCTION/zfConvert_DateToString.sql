-- Function: zfConvert_DateToString

DROP FUNCTION IF EXISTS zfConvert_DateToString (TDateTime);

CREATE OR REPLACE FUNCTION zfConvert_DateToString (Value TDateTime)
RETURNS TVarChar
AS
$BODY$
BEGIN
  RETURN (CASE WHEN EXTRACT (DAY   FROM Value) < 10 THEN '0' ELSE '' END || EXTRACT (DAY   FROM Value) :: TVarChar
|| '.' || CASE WHEN EXTRACT (MONTH FROM Value) < 10 THEN '0' ELSE '' END || EXTRACT (MONTH FROM Value) :: TVarChar
|| '.' || CASE WHEN EXTRACT (YEAR  FROM Value) < 10 THEN '0' ELSE '' END || EXTRACT (YEAR  FROM Value) :: TVarChar
         );

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfConvert_DateToString (TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 30.11.15                                        *
*/

-- òåñò
-- SELECT * FROM zfConvert_DateToString (CURRENT_TIMESTAMP)
