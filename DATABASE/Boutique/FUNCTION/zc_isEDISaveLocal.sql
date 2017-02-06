-- Function: zfGet_ViewWorkHour

DROP FUNCTION IF EXISTS zc_isEDISaveLocal ();

CREATE OR REPLACE FUNCTION zc_isEDISaveLocal()
RETURNS boolean AS
$BODY$
BEGIN
  RETURN (true);
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zc_isEDISaveLocal () OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.07.15                        *  
*/

-- тест
/*
SELECT zfCalc_ViewWorkHour (3.5, 'TVarChar'), zfCalc_ViewWorkHour (4, 'TVarChar'), zfCalc_ViewWorkHour (0, 'TVarChar')
*/