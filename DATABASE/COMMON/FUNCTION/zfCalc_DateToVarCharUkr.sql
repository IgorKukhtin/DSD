-- Function: zfCalc_DateToVarCharUkr (TDateTime)

DROP FUNCTION IF EXISTS zfCalc_DateToVarCharUkr (TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_DateToVarCharUkr (inOperDate TDateTime)
RETURNS TVarChar AS
$BODY$
  DECLARE cResult TVarChar;
BEGIN
  cResult :=  '"'||to_char(inOperDate, 'dd')||'" ';
  cResult := cResult||
          (CASE EXTRACT (MONTH FROM inOperDate)
               WHEN 1 THEN 'Січеня'
               WHEN 2 THEN 'Лютого'
               WHEN 3 THEN 'Березеня'
               WHEN 4 THEN 'Квітеня'
               WHEN 5 THEN 'Травеня'
               WHEN 6 THEN 'Червеня'
               WHEN 7 THEN 'Липеня'
               WHEN 8 THEN 'Серпня'
               WHEN 9 THEN 'Вересеня'
               WHEN 10 THEN 'Жовтеня'
               WHEN 11 THEN 'Листопада'
               WHEN 12 THEN 'Груденя'
               ELSE '???'
          END);
  cResult := cResult||' '||EXTRACT (YEAR FROM inOperDate)||' р.' ;
          
  RETURN cResult;
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_DateToVarCharUkr (TDateTime) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.04.15                                        *  
*/

-- тест
-- SELECT zfCalc_DateToVarCharUkr (CURRENT_DATE)
