-- Function: gpSelect_Object_InfoMoney(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_InfoMoney (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_InfoMoney(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, NameAll TVarChar,
               InfoMoneyGroupId Integer, InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar,
               InfoMoneyDestinationId Integer, InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar,
               isErased boolean) AS
$BODY$BEGIN
     
     -- проверка прав пользователя на вызов процедуры 
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_InfoMoney());
     RETURN QUERY 
     SELECT 
           Object_InfoMoney_View.InfoMoneyId             AS Id
         , Object_InfoMoney_View.InfoMoneyCode           AS Code
         , Object_InfoMoney_View.InfoMoneyName           AS Name
         , Object_InfoMoney_View.InfoMoneyName_all       AS NameAll
    
         , Object_InfoMoney_View.InfoMoneyGroupId
         , Object_InfoMoney_View.InfoMoneyGroupCode
         , Object_InfoMoney_View.InfoMoneyGroupName
        
         , Object_InfoMoney_View.InfoMoneyDestinationId
         , Object_InfoMoney_View.InfoMoneyDestinationCode
         , Object_InfoMoney_View.InfoMoneyDestinationName
         
         , Object_InfoMoney_View.isErased
      FROM Object_InfoMoney_View;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_InfoMoney (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.12.13                                        * add NameAll
 30.09.13                                        * Object_InfoMoney_View
 21.06.13          *    + все поля          
*/

-- тест
-- SELECT * FROM gpSelect_Object_InfoMoney('2')