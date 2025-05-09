-- View: _bi_Guide_Account_View

 DROP VIEW IF EXISTS _bi_Guide_Account_View;

-- Справочник Счета
CREATE OR REPLACE VIEW _bi_Guide_Account_View
AS
       SELECT
             Object_Account.Id         AS Id
           , Object_Account.ObjectCode AS Code
           , Object_Account.ValueData  AS Name
             -- Признак "Удален да/нет"
           , Object_Account.isErased   AS isErased

       FROM Object AS Object_Account
       WHERE Object_Account.DescId = zc_Object_Account()
      ;

ALTER TABLE _bi_Guide_Account_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.05.25                                        *
*/

-- тест
-- SELECT * FROM _bi_Guide_Account_View
