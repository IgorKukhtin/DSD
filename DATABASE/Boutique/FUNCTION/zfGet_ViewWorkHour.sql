-- Function: zfGet_ViewWorkHour

DROP FUNCTION IF EXISTS zfGet_ViewWorkHour (TFloat, Integer);

CREATE OR REPLACE FUNCTION zfGet_ViewWorkHour(inWorkHour TFloat, inWorkTimeKindId Integer)
RETURNS TVarChar AS
$BODY$
  DECLARE vbWorkTimeKindName TVarChar;
BEGIN
  SELECT ObjectString_WorkTimeKind_ShortName.ValueData 
            INTO vbWorkTimeKindName 
    FROM ObjectString AS ObjectString_WorkTimeKind_ShortName 
   WHERE ObjectString_WorkTimeKind_ShortName.ObjectId = inWorkTimeKindId  
     AND ObjectString_WorkTimeKind_ShortName.DescId = zc_ObjectString_WorkTimeKind_ShortName();       

  RETURN (zfCalc_ViewWorkHour(inWorkHour, vbWorkTimeKindName));
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfGet_ViewWorkHour (TFloat, Integer) OWNER TO postgres;


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