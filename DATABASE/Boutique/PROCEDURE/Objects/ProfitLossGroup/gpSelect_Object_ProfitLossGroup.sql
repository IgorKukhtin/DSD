-- Function: gpSelect_Object_ProfitLossGroup (TVarChar)

-- DROP FUNCTION gpSelect_Object_ProfitLossGroup (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProfitLossGroup(
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_ProfitLossGroup());

   RETURN QUERY 
   SELECT
         Object_ProfitLossGroup.Id         AS Id 
       , Object_ProfitLossGroup.ObjectCode AS Code
       , Object_ProfitLossGroup.ValueData  AS Name
       , Object_ProfitLossGroup.isErased   AS isErased
   FROM Object AS Object_ProfitLossGroup
   WHERE Object_ProfitLossGroup.DescId = zc_Object_ProfitLossGroup();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ProfitLossGroup (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.06.13          *

*/

-- ����
-- SELECT * FROM gpSelect_Object_ProfitLossGroup('2')
