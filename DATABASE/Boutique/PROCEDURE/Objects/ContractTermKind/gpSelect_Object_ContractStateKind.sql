-- Function: gpSelect_Object_ContractTermKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ContractTermKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractTermKind(
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_ContractTermKind());

   RETURN QUERY 
   SELECT
        Object_ContractTermKind.Id           AS Id 
      , Object_ContractTermKind.ObjectCode   AS Code
      , Object_ContractTermKind.ValueData    AS NAME
      
      , Object_ContractTermKind.isErased     AS isErased
      
   FROM OBJECT AS Object_ContractTermKind
                              
   WHERE Object_ContractTermKind.DescId = zc_Object_ContractTermKind();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ContractTermKind (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.01.16         *

*/

-- ����
-- SELECT * FROM gpSelect_Object_ContractTermKind('2')
