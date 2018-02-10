-- Function: zfCalc_MonthYearName_cross (TDateTime)

DROP FUNCTION IF EXISTS zfCalc_MonthYearName_cross (TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_MonthYearName_cross (inOperDate TDateTime)
RETURNS TVarChar AS
$BODY$
BEGIN

  RETURN (zfCalc_MonthName_cross (inOperDate)
   || '-' || CASE WHEN EXTRACT (YEAR FROM inOperDate) = 2000
                       THEN '00' 
                  WHEN EXTRACT (YEAR FROM inOperDate) < 2000
                       THEN (EXTRACT (YEAR FROM inOperDate) - 1900) :: TVarChar
                  WHEN EXTRACT (YEAR FROM inOperDate) < 2010
                       THEN '0' || (EXTRACT (YEAR FROM inOperDate) - 2000) :: TVarChar
                  ELSE (EXTRACT (YEAR FROM inOperDate) - 2000) :: TVarChar
             END
         );

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_MonthYearName_cross (TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 08.02.18                                        *  
*/

-- òåñò
-- SELECT zfCalc_MonthYearName_cross (CURRENT_DATE)
