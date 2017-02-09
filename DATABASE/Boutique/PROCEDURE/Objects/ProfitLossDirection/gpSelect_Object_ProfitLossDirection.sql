-- Function: gpSelect_Object_ProfitLossDirection (TVarChar)

-- DROP FUNCTION gpSelect_Object_ProfitLossDirection (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProfitLossDirection(
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               ProfitLossGroupId Integer, ProfitLossGroupCode Integer, ProfitLossGroupName TVarChar,
               isErased Boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_ProfitLossDirection());

   RETURN QUERY 
   SELECT
         Object_ProfitLossDirection.Id         AS Id 
       , Object_ProfitLossDirection.ObjectCode AS Code
       , Object_ProfitLossDirection.ValueData  AS NAME
       
	   , lfObject_ProfitLossDirection.ProfitLossGroupId   AS ProfitLossGroupId
	   , lfObject_ProfitLossDirection.ProfitLossGroupCode AS ProfitLossGroupCode
	   , lfObject_ProfitLossDirection.ProfitLossGroupName AS ProfitLossGroupName

       , Object_ProfitLossDirection.isErased   AS isErased
   FROM Object AS Object_ProfitLossDirection
   LEFT JOIN lfSelect_Object_ProfitLossDirection() AS lfObject_ProfitLossDirection on lfObject_ProfitLossDirection.ProfitLossDirectionId = Object_ProfitLossDirection.Id
   WHERE Object_ProfitLossDirection.DescId = zc_Object_ProfitLossDirection();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ProfitLossDirection (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.06.13          *               
 18.06.13          *

*/
-- ����
-- SELECT * FROM gpSelect_Object_ProfitLossDirection('2')
