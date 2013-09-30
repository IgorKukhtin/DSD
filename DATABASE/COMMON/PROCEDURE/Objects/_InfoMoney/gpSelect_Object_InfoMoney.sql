-- Function: gpSelect_Object_InfoMoney(TVarChar)

--DROP FUNCTION gpSelect_Object_InfoMoney (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_InfoMoney(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               InfoMoneyGroupId Integer, InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar,
               InfoMoneyDestinationId Integer, InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar,
               isErased boolean) AS
$BODY$BEGIN
     
     -- проверка прав пользователя на вызов процедуры 
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_InfoMoney());
     RETURN QUERY 
     SELECT 
           InfoMoney_View.InfoMoneyId             AS Id
         , InfoMoney_View.InfoMoneyCode           AS Code
         , InfoMoney_View.InfoMoneyName           AS Name
    
         , InfoMoney_View.InfoMoneyGroupId
         , InfoMoney_View.InfoMoneyGroupCode
         , InfoMoney_View.InfoMoneyGroupName
        
         , InfoMoney_View.InfoMoneyDestinationId
         , InfoMoney_View.InfoMoneyDestinationCode
         , InfoMoney_View.InfoMoneyDestinationName
         
         , InfoMoney_View.isErased
      FROM InfoMoney_View;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_InfoMoney (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.09.13                                        * InfoMoney_View
 21.06.13          *    + все поля          
 00.05.13                                        

*/

-- тест
-- SELECT * FROM gpSelect_Object_InfoMoney('2')