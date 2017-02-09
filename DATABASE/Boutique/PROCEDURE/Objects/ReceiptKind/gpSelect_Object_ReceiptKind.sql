-- Function: gpSelect_Object_ReceiptKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptKind(
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean
             ) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_ReceiptKind());

   RETURN QUERY 
   SELECT
        Object_ReceiptKind.Id           AS Id 
      , Object_ReceiptKind.ObjectCode   AS Code
      , Object_ReceiptKind.ValueData    AS NAME
      
      , Object_ReceiptKind.isErased     AS isErased
      
   FROM Object AS Object_ReceiptKind
                              
   WHERE Object_ReceiptKind.DescId = zc_Object_ReceiptKind();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ReceiptKind (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.12.14         *

*/

-- ����
-- SELECT * FROM gpSelect_Object_ReceiptKind('2')
