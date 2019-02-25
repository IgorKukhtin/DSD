-- Function: gpSelect_Object_GoodsTypeKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsTypeKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsTypeKind(
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_GoodsTypeKind());

   RETURN QUERY 
   SELECT
        Object_GoodsTypeKind.Id           AS Id 
      , Object_GoodsTypeKind.ObjectCode   AS Code
      , Object_GoodsTypeKind.ValueData    AS Name
      
      , Object_GoodsTypeKind.isErased     AS isErased
      
   FROM OBJECT AS Object_GoodsTypeKind
   WHERE Object_GoodsTypeKind.DescId = zc_Object_GoodsTypeKind();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.02.19         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_GoodsTypeKind('2')
