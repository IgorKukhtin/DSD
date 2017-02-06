-- Function: zfConvert_DateShortToString

DROP FUNCTION IF EXISTS zfConvert_DateShortToString (TDateTime);

CREATE OR REPLACE FUNCTION zfConvert_DateShortToString (Value TDateTime)
RETURNS TVarChar
AS
$BODY$
BEGIN
  RETURN (CASE WHEN EXTRACT (DAY   FROM Value) < 10 THEN '0' ELSE '' END || EXTRACT (DAY   FROM Value) :: TVarChar
|| '.' || CASE WHEN EXTRACT (MONTH FROM Value) < 10 THEN '0' ELSE '' END || EXTRACT (MONTH FROM Value) :: TVarChar
|| '.' || (CASE WHEN EXTRACT (YEAR  FROM Value) - 2000 < 10 THEN '0' ELSE '' END || EXTRACT (YEAR  FROM Value) - 2000) :: TVarChar
         );

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfConvert_DateShortToString (TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 25.02.16                                        *
*/

-- òåñò
-- SELECT * FROM zfConvert_DateShortToString (CURRENT_TIMESTAMP)
