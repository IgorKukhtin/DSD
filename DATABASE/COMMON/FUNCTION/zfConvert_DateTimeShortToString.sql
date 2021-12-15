-- Function: zfConvert_TimeShortToString

DROP FUNCTION IF EXISTS zfConvert_TimeShortToString (TDateTime);

CREATE OR REPLACE FUNCTION zfConvert_TimeShortToString (Value TDateTime)
RETURNS TVarChar
AS
$BODY$
BEGIN
     RETURN (CASE WHEN EXTRACT (HOUR  FROM Value) < 10 THEN '0' ELSE '' END || EXTRACT (HOUR  FROM Value) :: TVarChar
   || ':' || CASE WHEN EXTRACT (MINUTE  FROM Value) < 10 THEN '0' ELSE '' END || EXTRACT (MINUTE  FROM Value) :: TVarChar
-- || ':' || CASE WHEN EXTRACT (SECOND  FROM DATE_TRUNC ('SECOND', Value)) < 10 THEN '0' ELSE '' END || EXTRACT (SECOND FROM DATE_TRUNC ('SECOND', Value)) :: TVarChar
            );

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 01.12.21                                        *
*/

-- òåñò
-- SELECT * FROM zfConvert_TimeShortToString (CURRENT_TIMESTAMP)
