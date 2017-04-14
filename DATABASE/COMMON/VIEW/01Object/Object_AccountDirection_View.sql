-- View: Object_AccountDirection_View

-- DROP VIEW IF EXISTS Object_AccountDirection_View;

CREATE OR REPLACE VIEW Object_AccountDirection_View AS
  SELECT DISTINCT Object_Account_View.AccountGroupId
       , Object_Account_View.AccountGroupCode
       , Object_Account_View.AccountGroupName

       , Object_Account_View.AccountDirectionId
       , Object_Account_View.AccountDirectionCode
       , Object_Account_View.AccountDirectionName
  FROM Object_Account_View;

ALTER TABLE Object_AccountDirection_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.11.13                                        *
*/

-- тест
-- SELECT * FROM Object_AccountDirection_View