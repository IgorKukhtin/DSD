-- Function: gpSelect_Object_ArticleLoss()

DROP FUNCTION IF EXISTS gpSelect_Object_ArticleLoss(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ArticleLoss(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar

             , ProfitLossGroupId Integer, ProfitLossGroupCode Integer, ProfitLossGroupName TVarChar
             , ProfitLossDirectionId Integer, ProfitLossDirectionCode Integer, ProfitLossDirectionName TVarChar

             , isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ArticleLoss());

   RETURN QUERY
   SELECT
          Object_ArticleLoss.Id         AS Id
        , Object_ArticleLoss.ObjectCode AS Code
        , Object_ArticleLoss.ValueData  AS Name

          
        , Object_InfoMoney_View.InfoMoneyGroupName

        , Object_InfoMoney_View.InfoMoneyDestinationName

        , Object_InfoMoney_View.InfoMoneyId
        , Object_InfoMoney_View.InfoMoneyCode
        , Object_InfoMoney_View.InfoMoneyName
           
          
        , View_ProfitLossDirection.ProfitLossGroupId
        , View_ProfitLossDirection.ProfitLossGroupCode
        , View_ProfitLossDirection.ProfitLossGroupName

        , View_ProfitLossDirection.ProfitLossDirectionId
        , View_ProfitLossDirection.ProfitLossDirectionCode
        , View_ProfitLossDirection.ProfitLossDirectionName       

        , Object_ArticleLoss.isErased    AS isErased
   FROM Object AS Object_ArticleLoss
          
        LEFT JOIN ObjectLink AS ObjectLink_ArticleLoss_InfoMoney 
                             ON ObjectLink_ArticleLoss_InfoMoney.ObjectId = Object_ArticleLoss.Id
                            AND ObjectLink_ArticleLoss_InfoMoney.DescId = zc_ObjectLink_ArticleLoss_InfoMoney()
        LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_ArticleLoss_InfoMoney.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_ArticleLoss_ProfitLossDirection
                             ON ObjectLink_ArticleLoss_ProfitLossDirection.ObjectId = Object_ArticleLoss.Id
                            AND ObjectLink_ArticleLoss_ProfitLossDirection.DescId = zc_ObjectLink_ArticleLoss_ProfitLossDirection()
        LEFT JOIN Object_ProfitLossDirection_View AS View_ProfitLossDirection ON View_ProfitLossDirection.ProfitLossDirectionId = ObjectLink_ArticleLoss_ProfitLossDirection.ChildObjectId


   WHERE Object_ArticleLoss.DescId = zc_Object_ArticleLoss();

END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ArticleLoss(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Манько Д.А.
 01.09.14         * 

*/

-- тест
-- SELECT * FROM gpSelect_Object_ArticleLoss('2')

