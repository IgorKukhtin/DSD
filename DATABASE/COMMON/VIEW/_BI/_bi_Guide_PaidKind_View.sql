-- View: _bi_Guide_PaidKind_View

 DROP VIEW IF EXISTS _bi_Guide_PaidKind_View;

-- Справочник Форма оплаты
CREATE OR REPLACE VIEW _bi_Guide_PaidKind_View
AS
       SELECT
             Object_PaidKind.Id         AS Id
           , Object_PaidKind.ObjectCode AS Code
           , Object_PaidKind.ValueData  AS Name
             -- Признак "Удален да/нет"
           , Object_PaidKind.isErased   AS isErased

       FROM Object AS Object_PaidKind
       WHERE Object_PaidKind.DescId = zc_Object_PaidKind()
      ;

ALTER TABLE _bi_Guide_PaidKind_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.05.25                                        *
*/

-- тест
-- SELECT * FROM _bi_Guide_PaidKind_View
