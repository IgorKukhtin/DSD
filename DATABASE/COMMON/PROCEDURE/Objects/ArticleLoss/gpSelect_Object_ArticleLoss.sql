-- Function: gpSelect_Object_ArticleLoss()

DROP FUNCTION IF EXISTS gpSelect_Object_ArticleLoss(TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ArticleLoss(Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ArticleLoss(
    IN inShowAll     Boolean, 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar

             , ProfitLossGroupId Integer, ProfitLossGroupCode Integer, ProfitLossGroupName TVarChar
             , ProfitLossDirectionId Integer, ProfitLossDirectionCode Integer, ProfitLossDirectionName TVarChar
             , BusinessId Integer, BusinessName TVarChar
             , BranchId Integer, BranchName TVarChar
             , Comment TVarChar
             , isIrna Boolean
             , isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ArticleLoss());

   RETURN QUERY
   SELECT
          Object_ArticleLoss.Id           AS Id
        , Object_ArticleLoss.ObjectCode   AS Code
        , Object_ArticleLoss.ValueData    AS Name

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
        
        , Object_Business.Id              AS BusinessId
        , Object_Business.ValueData       AS BusinessName        
        , Object_Branch.Id                AS BranchId
        , Object_Branch.ValueData         AS BranchName
        
        , ObjectString_Comment.ValueData  AS Comment       

        , COALESCE (ObjectBoolean_Guide_Irna.ValueData, FALSE)   :: Boolean AS isIrna
        , Object_ArticleLoss.isErased     AS isErased
   FROM Object AS Object_ArticleLoss
          
        LEFT JOIN ObjectLink AS ObjectLink_ArticleLoss_InfoMoney 
                             ON ObjectLink_ArticleLoss_InfoMoney.ObjectId = Object_ArticleLoss.Id
                            AND ObjectLink_ArticleLoss_InfoMoney.DescId = zc_ObjectLink_ArticleLoss_InfoMoney()
        LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_ArticleLoss_InfoMoney.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_ArticleLoss_ProfitLossDirection
                             ON ObjectLink_ArticleLoss_ProfitLossDirection.ObjectId = Object_ArticleLoss.Id
                            AND ObjectLink_ArticleLoss_ProfitLossDirection.DescId = zc_ObjectLink_ArticleLoss_ProfitLossDirection()
        LEFT JOIN Object_ProfitLossDirection_View AS View_ProfitLossDirection ON View_ProfitLossDirection.ProfitLossDirectionId = ObjectLink_ArticleLoss_ProfitLossDirection.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_ArticleLoss_Business
                             ON ObjectLink_ArticleLoss_Business.ObjectId = Object_ArticleLoss.Id
                            AND ObjectLink_ArticleLoss_Business.DescId = zc_ObjectLink_ArticleLoss_Business()
        LEFT JOIN Object AS Object_Business ON Object_Business.Id = ObjectLink_ArticleLoss_Business.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_ArticleLoss_Branch
                             ON ObjectLink_ArticleLoss_Branch.ObjectId = Object_ArticleLoss.Id
                            AND ObjectLink_ArticleLoss_Branch.DescId = zc_ObjectLink_ArticleLoss_Branch()
        LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_ArticleLoss_Branch.ChildObjectId
        
        LEFT JOIN ObjectString AS ObjectString_Comment
                               ON ObjectString_Comment.ObjectId = Object_ArticleLoss.Id
                              AND ObjectString_Comment.DescId = zc_ObjectString_ArticleLoss_Comment() 

        LEFT JOIN ObjectBoolean AS ObjectBoolean_Guide_Irna
                                ON ObjectBoolean_Guide_Irna.ObjectId = Object_ArticleLoss.Id
                               AND ObjectBoolean_Guide_Irna.DescId = zc_ObjectBoolean_Guide_Irna()

   WHERE Object_ArticleLoss.DescId = zc_Object_ArticleLoss()
     AND (Object_ArticleLoss.isErased = inShowAll OR inShowAll = TRUE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Манько Д.А.
 04.05.22         *
 16.11.20         * add Branch
 27.07.17         * add Business
 05.07.17         *
 01.09.14         * 
*/

-- тест
-- SELECT * FROM gpSelect_Object_ArticleLoss (inShowAll:= TRUE, inSession:= zfCalc_UserAdmin())
