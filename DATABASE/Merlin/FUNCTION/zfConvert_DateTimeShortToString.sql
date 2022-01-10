-- Function: zfConvert_DateTimeShortToString

DROP FUNCTION IF EXISTS zfConvert_DateTimeShortToString (TDateTime);

CREATE OR REPLACE FUNCTION zfConvert_DateTimeShortToString (Value TDateTime)
RETURNS TVarChar
AS
$BODY$
BEGIN
  RETURN (zfConvert_DateShortToString (Value)
|| ' ' || CASE WHEN EXTRACT (HOUR  FROM Value) < 10 THEN '0' ELSE '' END || EXTRACT (HOUR  FROM Value) :: TVarChar
|| ':' || CASE WHEN EXTRACT (MINUTE  FROM Value) < 10 THEN '0' ELSE '' END || EXTRACT (MINUTE  FROM Value) :: TVarChar
|| ':' || CASE WHEN EXTRACT (SECOND  FROM DATE_TRUNC ('SECOND', Value)) < 10 THEN '0' ELSE '' END || EXTRACT (SECOND FROM DATE_TRUNC ('SECOND', Value)) :: TVarChar
         );

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfConvert_DateTimeShortToString (TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 07.03.18                                        *
*/

-- òåñò
-- SELECT * FROM zfConvert_DateTimeShortToString (CURRENT_TIMESTAMP)
