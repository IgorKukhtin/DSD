-- Function: lfSelect_Object_Account_byAccountGroup (Integer)

-- DROP FUNCTION lfSelect_Object_Account_byAccountGroup (Integer);

CREATE OR REPLACE FUNCTION lfSelect_Object_Account_byAccountGroup (IN inAccountGroupId Integer)
RETURNS TABLE  (AccountId Integer)  
AS
$BODY$
BEGIN

     -- Выбираем данные для справочника счетов (на самом деле это три справочника)
     RETURN QUERY
     SELECT ObjectId AS AccountId FROM ObjectLink WHERE ChildObjectId = inAccountGroupId AND DescId = zc_ObjectLink_Account_AccountGroup();

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lfSelect_Object_Account_byAccountGroup (Integer) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.09.13         *
*/

-- тест
-- SELECT * FROM lfSelect_Object_Account_byAccountGroup (zc_Enum_AccountGroup_20000())
