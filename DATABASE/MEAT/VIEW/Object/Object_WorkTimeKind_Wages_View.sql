-- View: Object_WorkTimeKind_Wages_View

-- DROP VIEW IF EXISTS Object_WorkTimeKind_Wages_View;

CREATE OR REPLACE VIEW Object_WorkTimeKind_Wages_View AS
    SELECT Object.Id
         , Object.ObjectCode
         , Object.ValueData
    FROM Object
    WHERE Object.DescId = zc_Object_WorkTimeKind()
      AND Object.Id IN (zc_Enum_WorkTimeKind_Work()       -- рабочие часы
                      , zc_Enum_WorkTimeKind_Trainee50()  -- Стажер50%+
                      , zc_Enum_WorkTimeKind_Trainee()    -- Увольнение+
                      , zc_Enum_WorkTimeKind_Trial()      -- пробная смена+
                      -- , zc_Enum_WorkTimeKind_Holiday()    -- отпуск
                       );

ALTER TABLE Object_WorkTimeKind_Wages_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 24.03.16                                        *
 09.11.15                                                         *
*/

-- тест
-- SELECT * FROM Object_WorkTimeKind_Wages_View
