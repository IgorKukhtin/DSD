-- Function: gpSelect_Object_ArticleLoss()

DROP FUNCTION IF EXISTS gpSelect_Object_ArticleLoss(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ArticleLoss(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , isErased boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ArticleLoss()());

   RETURN QUERY
   SELECT
          Object_ArticleLoss.Id         AS Id
        , Object_ArticleLoss.ObjectCode AS Code
        , Object_ArticleLoss.ValueData  AS Name

        , Object_InfoMoney.Id            AS InfoMoneyId
        , Object_InfoMoney.ObjectCode    AS InfoMoneyCode
        , Object_InfoMoney.ValueData     AS InfoMoneyName        

        , Object_ArticleLoss.isErased    AS isErased
   FROM Object AS Object_ArticleLoss
          
        LEFT JOIN ObjectLink AS ObjectLink_ArticleLoss_InfoMoney 
                             ON ObjectLink_ArticleLoss_InfoMoney.ObjectId = Object_ArticleLoss.Id
                            AND ObjectLink_ArticleLoss_InfoMoney.DescId = zc_ObjectLink_ArticleLoss_InfoMoney()
        LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_ArticleLoss_InfoMoney.ChildObjectId

   WHERE Object_ArticleLoss.DescId = zc_Object_ArticleLoss();

END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ArticleLoss(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ������ �.�.
 01.09.14         * 

*/

-- ����
-- SELECT * FROM gpSelect_Object_ArticleLoss('2')