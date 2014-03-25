-- Function: gpSelect_Object_GoodsKindWeighing()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsKindWeighing(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsKindWeighing(
    IN inSession     TVarChar            -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, GoodsKindId Integer, GoodsKindName TVarChar) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsKindWeighing());

   RETURN QUERY
   SELECT
         Object.Id                  AS Id
       , Object.ObjectCode          AS Code
       , Object.ValueData           AS Name
       , Object.isErased            AS isErased
       , Object_GoodsKind.Id        AS GoodsKindId
       , Object_GoodsKind.ValueData AS GoodsKindName

   FROM Object

   LEFT JOIN ObjectLink AS ObjectLink_GoodsKindWeighing_GoodsKind
                        ON ObjectLink_GoodsKindWeighing_GoodsKind.ObjectId = Object.Id
                       AND ObjectLink_GoodsKindWeighing_GoodsKind.DescId = zc_ObjectLink_GoodsKindWeighing_GoodsKind()
   LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_Goods_Measure.ChildObjectId
                                     AND Object_GoodsKind.DescId = zc_Object_GoodsKind()
   WHERE Object.DescId = zc_Object_GoodsKindWeighing();



END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsKindWeighing(TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.03.14                                                         *

*/

-- ����
-- SELECT * FROM gpSelect_Object_GoodsKindWeighing('2')