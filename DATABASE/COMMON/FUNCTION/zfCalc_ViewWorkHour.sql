-- Function: zfCalc_ViewWorkHour

DROP FUNCTION IF EXISTS zfCalc_ViewWorkHour (TFloat, TVarChar);

CREATE OR REPLACE FUNCTION zfCalc_ViewWorkHour(WorkHour TFloat, WorkTimeKindName TVarChar)
RETURNS TVarChar AS
$BODY$
BEGIN
  WorkTimeKindName := COALESCE(WorkTimeKindName, '');
  IF WorkHour > 0 THEN
     RETURN (rtrim(to_char(WorkHour, 'fm9999999999999990.9999'),'.')||'/'||WorkTimeKindName)::TVarChar;
  ELSE
     RETURN ('')::TVarChar;
  END IF;
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_ViewWorkHour (TFloat, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.10.13                        *  
*/

-- тест
/*
SELECT zfCalc_ViewWorkHour (3.5, 'TVarChar'), zfCalc_ViewWorkHour (4, 'TVarChar'), zfCalc_ViewWorkHour (0, 'TVarChar')
*/