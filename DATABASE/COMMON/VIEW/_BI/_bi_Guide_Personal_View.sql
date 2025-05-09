-- View: _bi_Guide_Personal_View

 DROP VIEW IF EXISTS _bi_Guide_Personal_View;

-- Справочник Сотрудники
CREATE OR REPLACE VIEW _bi_Guide_Personal_View
AS
       SELECT
             Object_Personal.Id         AS Id
           , Object_Personal.ObjectCode AS Code
           , Object_Personal.ValueData  AS Name
             -- Признак "Удален да/нет"
           , Object_Personal.isErased   AS isErased

       FROM Object AS Object_Personal
       WHERE Object_Personal.DescId = zc_Object_Personal()
      ;

ALTER TABLE _bi_Guide_Personal_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.05.25                                        *
*/

-- тест
-- SELECT * FROM _bi_Guide_Personal_View
