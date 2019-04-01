-- Function: gpSelect_Object_GoodsAnalog()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsAnalog(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsAnalog(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsAnalog()());

   RETURN QUERY
   SELECT
          Object_GoodsAnalog.Id         AS Id
        , Object_GoodsAnalog.ObjectCode AS Code
        , Object_GoodsAnalog.ValueData  AS Name

        , Object_GoodsAnalog.isErased   AS isErased
   FROM Object AS Object_GoodsAnalog
   WHERE Object_GoodsAnalog.DescId = zc_Object_GoodsAnalog();

END;$BODY$


LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������ �.�.
 01.04.19         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_GoodsAnalog('3')