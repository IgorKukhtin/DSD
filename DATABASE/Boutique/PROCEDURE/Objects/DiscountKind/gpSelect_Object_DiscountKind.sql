-- Function: gpSelect_Object_DiscountKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_DiscountKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_DiscountKind(
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean)
AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_DiscountKind());

   RETURN QUERY 
   SELECT
        Object_DiscountKind.Id           AS Id 
      , Object_DiscountKind.ObjectCode   AS Code
      , Object_DiscountKind.ValueData    AS Name      
      , Object_DiscountKind.isErased     AS isErased
      
   FROM Object AS Object_DiscountKind
                              
   WHERE Object_DiscountKind.DescId = zc_Object_DiscountKind();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
06.03.17                                                         *

*/

-- ����
-- SELECT * FROM gpSelect_Object_DiscountKind('2')
