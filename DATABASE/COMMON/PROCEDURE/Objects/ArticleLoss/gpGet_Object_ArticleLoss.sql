-- Function: gpGet_Object_ArticleLoss()

DROP FUNCTION IF EXISTS gpGet_Object_ArticleLoss(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ArticleLoss(
    IN inId          Integer,       -- ключ объекта <Статьи списания>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , ProfitLossDirectionId Integer, ProfitLossDirectionName TVarChar
             , BusinessId Integer, BusinessName TVarChar
             , BranchId Integer, BranchName TVarChar
             , Comment TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ArticleLoss());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_ArticleLoss()) AS Code
           , CAST ('' as TVarChar)  AS Name

           , CAST (0 as Integer)    AS InfoMoneyId
           , CAST ('' as TVarChar)  AS InfoMoneyName

           , CAST (0 as Integer)    AS ProfitLossDirectionId
           , CAST ('' as TVarChar)  AS ProfitLossDirectionName
           
           , CAST (0 as Integer)    AS BusinessId
           , CAST ('' as TVarChar)  AS BusinessName
           , CAST (0 as Integer)    AS BranchId
           , CAST ('' as TVarChar)  AS BranchName  
           , CAST ('' as TVarChar)  AS Comment

           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY
       SELECT
             Object_ArticleLoss.Id           AS Id
           , Object_ArticleLoss.ObjectCode   AS Code
           , Object_ArticleLoss.ValueData    AS Name
       
           , Object_InfoMoney.Id             AS InfoMoneyId
           , Object_InfoMoney.ValueData      AS InfoMoneyName 

           , Object_ProfitLossDirection.Id        AS ProfitLossDirectionId
           , Object_ProfitLossDirection.ValueData AS ProfitLossDirectionName

           , Object_Business.Id              AS BusinessId
           , Object_Business.ValueData       AS BusinessName  
           , Object_Branch.Id                AS BranchId
           , Object_Branch.ValueData         AS BranchName
           , ObjectString_Comment.ValueData  AS Comment

           , Object_ArticleLoss.isErased     AS isErased

       FROM Object AS Object_ArticleLoss
           
            LEFT JOIN ObjectLink AS ObjectLink_ArticleLoss_InfoMoney 
                                 ON ObjectLink_ArticleLoss_InfoMoney.ObjectId = Object_ArticleLoss.Id
                                AND ObjectLink_ArticleLoss_InfoMoney.DescId = zc_ObjectLink_ArticleLoss_InfoMoney()
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_ArticleLoss_InfoMoney.ChildObjectId
         
            LEFT JOIN ObjectLink AS ObjectLink_ArticleLoss_ProfitLossDirection
                                 ON ObjectLink_ArticleLoss_ProfitLossDirection.ObjectId = Object_ArticleLoss.Id
                                AND ObjectLink_ArticleLoss_ProfitLossDirection.DescId = zc_ObjectLink_ArticleLoss_ProfitLossDirection()
            LEFT JOIN Object AS Object_ProfitLossDirection ON Object_ProfitLossDirection.Id = ObjectLink_ArticleLoss_ProfitLossDirection.ChildObjectId

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
                                  
       WHERE Object_ArticleLoss.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_ArticleLoss (integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 16.11.20         * add Branch
 01.09.14         *
*/

-- тест
-- SELECT * FROM gpGet_Object_ArticleLoss (1, zfCalc_UserAdmin())
