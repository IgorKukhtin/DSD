-- Function: gpSelect_Object_InfoMoney(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_InfoMoney (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_InfoMoney(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, NameAll TVarChar,
               InfoMoneyGroupId Integer, InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar,
               InfoMoneyDestinationId Integer, InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar,
               isProfitLoss Boolean,
               isErased Boolean
)
AS
$BODY$
BEGIN
     
     -- �������� ���� ������������ �� ����� ��������� 
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
         
         , COALESCE (ObjectBoolean_ProfitLoss.ValueData, False)  AS isProfitLoss

         , Object_InfoMoney_View.isErased
      FROM Object_InfoMoney_View
            LEFT JOIN ObjectBoolean AS ObjectBoolean_ProfitLoss
                                    ON ObjectBoolean_ProfitLoss.ObjectId = Object_InfoMoney_View.InfoMoneyId
                                   AND ObjectBoolean_ProfitLoss.DescId = zc_ObjectBoolean_InfoMoney_ProfitLoss()
    UNION ALL
      SELECT 0 AS Id
           , NULL :: Integer AS Code
           , '�������' :: TVarChar AS Name
           , '' :: TVarChar AS NameAll
    
           , 0 AS InfoMoneyGroupId
           , 0 AS InfoMoneyGroupCode
           , '' :: TVarChar as InfoMoneyGroupName
        
           , 0 AS InfoMoneyDestinationId
           , 0 AS InfoMoneyDestinationCode
           , '' :: TVarChar as InfoMoneyDestinationName
           , FALSE  AS isProfitLoss
           , FALSE  AS isErased
;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_InfoMoney (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.08.15         * add isProfitLoss
 17.04.13                                        * add UNION ALL
 26.12.13                                        * add NameAll
 30.09.13                                        * Object_InfoMoney_View
 21.06.13          *    + ��� ����          
*/

-- ����
-- SELECT * FROM gpSelect_Object_InfoMoney('2')