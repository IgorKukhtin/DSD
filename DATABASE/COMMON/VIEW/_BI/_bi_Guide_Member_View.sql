-- View: _bi_Guide_Member_View

 DROP VIEW IF EXISTS _bi_Guide_Member_View;

-- Справочник Фмз.лица
CREATE OR REPLACE VIEW _bi_Guide_Member_View
AS
       SELECT
             Object_Member.Id         AS Id
           , Object_Member.ObjectCode AS Code
           , Object_Member.ValueData  AS Name
             -- Признак "Удален да/нет"
           , Object_Member.isErased   AS isErased

       FROM Object AS Object_Member
       WHERE Object_Member.DescId = zc_Object_Member()
      ;

ALTER TABLE _bi_Guide_Member_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.05.25                                        *
*/

-- тест
-- SELECT * FROM _bi_Guide_Member_View
