-- View: _bi_Guide_Unit_View

 DROP VIEW IF EXISTS _bi_Guide_Unit_View;

-- Справочник Подразделения
CREATE OR REPLACE VIEW _bi_Guide_Unit_View
AS
       SELECT
             Object_Unit.Id         AS Id
           , Object_Unit.ObjectCode AS Code
           , Object_Unit.ValueData  AS Name
             -- Признак "Удален да/нет"
           , Object_Unit.isErased   AS isErased

       FROM Object AS Object_Unit
       WHERE Object_Unit.DescId = zc_Object_Unit()
      ;

ALTER TABLE _bi_Guide_Unit_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.05.25                                        *
*/

-- тест
-- SELECT * FROM _bi_Guide_Unit_View
