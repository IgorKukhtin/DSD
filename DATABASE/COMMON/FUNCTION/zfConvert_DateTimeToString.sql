-- Function: zfConvert_DateTimeToString

DROP FUNCTION IF EXISTS zfConvert_DateTimeToString (TDateTime);

CREATE OR REPLACE FUNCTION zfConvert_DateTimeToString (Value TDateTime)
RETURNS TVarChar
AS
$BODY$
BEGIN
  RETURN (zfConvert_DateToString (Value)
|| ' ' || CASE WHEN EXTRACT (HOUR  FROM Value) < 10 THEN '0' ELSE '' END || EXTRACT (HOUR  FROM Value) :: TVarChar
|| ':' || CASE WHEN EXTRACT (MINUTE  FROM Value) < 10 THEN '0' ELSE '' END || EXTRACT (MINUTE  FROM Value) :: TVarChar
|| ':' || CASE WHEN EXTRACT (SECOND  FROM DATE_TRUNC ('SECOND', Value)) < 10 THEN '0' ELSE '' END || EXTRACT (SECOND FROM DATE_TRUNC ('SECOND', Value)) :: TVarChar
         );

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfConvert_DateTimeToString (TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 28.01.18                                        *
*/

-- òåñò
-- SELECT * FROM zfConvert_DateTimeToString (CURRENT_TIMESTAMP)
