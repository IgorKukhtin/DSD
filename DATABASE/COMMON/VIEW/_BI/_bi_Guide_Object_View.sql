-- View: _bi_Guide_Object_View

 DROP VIEW IF EXISTS _bi_Guide_Object_View;

-- Справочник ВСЕ
/*
-- Названия
Id
Code
Name
-- Вид справочника
ItemName
-- Признак "Удален да/нет"
isErased
*/

CREATE OR REPLACE VIEW _bi_Guide_Object_View
AS
      SELECT Object.Id                AS Id
           , Object.ObjectCode        AS Code
           , Object.ValueData         AS Name
           , ObjectDesc.ItemName      AS ItemName
             -- Признак "Удален да/нет"
           , Object.isErased

       FROM Object
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object.DescId
      ;

ALTER TABLE _bi_Guide_Object_View  OWNER TO postgres;

GRANT ALL ON TABLE PUBLIC._bi_Guide_Object_View TO admin;
GRANT ALL ON TABLE PUBLIC._bi_Guide_Object_View TO project;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.10.25                                        *
*/

-- тест
-- SELECT * FROM _bi_Guide_Object_View ORDER BY 1 LIMIT 100
