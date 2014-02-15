-- Function: gpSelect_Object_ContractKind()

-- DROP FUNCTION gpSelect_Object_ContractKind();

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractKind(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ContractKind());

   RETURN QUERY 
   SELECT 
        Object.Id         AS Id 
      , Object.ObjectCode AS Code
      , Object.ValueData  AS Name
      , Object.isErased   AS isErased
   FROM Object
   WHERE Object.DescId = zc_Object_ContractKind();
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ContractKind (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.12.13                                        * Cyr1251
 11.06.13          *
*/

-- ����
-- SELECT * FROM gpSelect_Object_ContractKind('2')