-- Function: gpSelect_Object_GoodsTag()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsTag(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsTag(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsTag()());

   RETURN QUERY 
   SELECT Object_GoodsTag.Id         AS Id 
        , Object_GoodsTag.ObjectCode AS Code
        , Object_GoodsTag.ValueData  AS Name
        , Object_GoodsTag.isErased   AS isErased
   
   FROM Object AS Object_GoodsTag
   WHERE Object_GoodsTag.DescId = zc_Object_GoodsTag();
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.05.20         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_GoodsTag('2')