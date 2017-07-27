-- Function: gpGet_Object_ArticleLoss()

DROP FUNCTION IF EXISTS gpGet_Object_ArticleLoss(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ArticleLoss(
    IN inId          Integer,       -- ���� ������� <������ ��������>
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , ProfitLossDirectionId Integer, ProfitLossDirectionName TVarChar
             , BusinessId Integer, BusinessName TVarChar
             , Comment TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
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
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 01.09.14         *
*/

-- ����
-- SELECT * FROM gpGet_Object_ArticleLoss (1, zfCalc_UserAdmin())
