-- Function: gpSelect_Object_ContractTagGroup()

DROP FUNCTION IF EXISTS gpSelect_Object_ContractTagGroup(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractTagGroup(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ContractTagGroup()());

   RETURN QUERY 
   SELECT 
     Object_ContractTagGroup.Id         AS Id 
   , Object_ContractTagGroup.ObjectCode AS Code
   , Object_ContractTagGroup.ValueData  AS NAME
   
   , Object_ContractTagGroup.isErased   AS isErased
   
   FROM Object AS Object_ContractTagGroup
   WHERE Object_ContractTagGroup.DescId = zc_Object_ContractTagGroup();
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ContractTagGroup(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.01.15         * 

*/

-- ����
-- SELECT * FROM gpSelect_Object_ContractTagGroup('2')