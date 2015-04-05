-- Function: gpSelect_Object_InfoMoneyDestination (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_InfoMoneyDestination (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_InfoMoneyDestination(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               InfoMoneyGroupId Integer, InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar, 
               isErased Boolean
              )
AS
$BODY$
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_InfoMoneyDestination());

   RETURN QUERY 
       WITH tmpInfoMoneyDestination AS (SELECT Object_InfoMoney_View.InfoMoneyGroupId, Object_InfoMoney_View.InfoMoneyGroupCode, Object_InfoMoney_View.InfoMoneyGroupName, Object_InfoMoney_View.InfoMoneyDestinationId
                                        FROM Object_InfoMoney_View
                                        GROUP BY Object_InfoMoney_View.InfoMoneyGroupId, Object_InfoMoney_View.InfoMoneyGroupCode, Object_InfoMoney_View.InfoMoneyGroupName, Object_InfoMoney_View.InfoMoneyDestinationId
                                       )
   SELECT
         Object_InfoMoneyDestination.Id         AS Id
       , Object_InfoMoneyDestination.ObjectCode AS Code
       , Object_InfoMoneyDestination.ValueData  AS Name
	   
       , tmpInfoMoneyDestination.InfoMoneyGroupId   AS InfoMoneyGroupId
       , tmpInfoMoneyDestination.InfoMoneyGroupCode AS InfoMoneyGroupCode
       , tmpInfoMoneyDestination.InfoMoneyGroupName AS InfoMoneyGroupName
	   
	   , Object_InfoMoneyDestination.isErased   AS isErased
    FROM Object AS Object_InfoMoneyDestination
         LEFT JOIN tmpInfoMoneyDestination ON tmpInfoMoneyDestination.InfoMoneyDestinationId = Object_InfoMoneyDestination.Id
    WHERE Object_InfoMoneyDestination.DescId = zc_Object_InfoMoneyDestination();
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_InfoMoneyDestination (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.04.15                                        * all
 29.06.13          * InfoMoneyGroup               
 21.06.13          * zc_Enum_Process_Select_Object_InfoMoneyDestination()
 17.06.13          *
*/

-- ����
-- SELECT * FROM gpSelect_Object_InfoMoneyDestination (zfCalc_UserAdmin()) ORDER BY Code
