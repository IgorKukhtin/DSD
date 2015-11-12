DROP VIEW IF EXISTS Object_WorkTimeKind_Wages_View;

CREATE OR REPLACE VIEW Object_WorkTimeKind_Wages_View AS
    Select
        Object.Id
       ,Object.ObjectCode
       ,Object.ValueData
    FROM
        Object
    WHERE
        Object.DescId = zc_Object_WorkTimeKind()
        AND
        Object.Id in (zc_Enum_WorkTimeKind_Work(),
                      zc_Enum_WorkTimeKind_Trainee50(),
                      zc_Enum_WorkTimeKind_Trainee(),
                      zc_Enum_WorkTimeKind_Trial());
ALTER TABLE Object_WorkTimeKind_Wages_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 09.11.15                                                         *
*/

-- тест
-- SELECT * FROM Object_WorkTimeKind_Wages_View