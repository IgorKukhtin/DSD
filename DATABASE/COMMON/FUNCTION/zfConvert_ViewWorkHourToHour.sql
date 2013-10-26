-- Function: zfConvert_ViewWorkHourToHour

DROP FUNCTION IF EXISTS  zfConvert_ViewWorkHourToHour(TVarChar);

CREATE OR REPLACE FUNCTION zfConvert_ViewWorkHourToHour(Number TVarChar)
RETURNS TFloat AS
$BODY$
BEGIN
  RETURN (SUBSTRING (Number, '([0-9.]*)'))::TFloat;
EXCEPTION
  WHEN OTHERS THEN	
     RETURN 0;
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfConvert_ViewWorkHourToHour (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.10.13                        *  
*/

-- тест
/*
SELECT zfConvert_ViewWorkHourToHour ('3/TVarChar'), zfConvert_ViewWorkHourToHour ('10/TVarChar'), 
 zfConvert_ViewWorkHourToHour ('3.5/TVarChar'), zfConvert_ViewWorkHourToHour (''),
 zfConvert_ViewWorkHourToHour ('3'), zfConvert_ViewWorkHourToHour ('6')
*/