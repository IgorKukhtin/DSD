-- Function: gpSelect_Object_GoodsKindWeighingGroup()

--DROP FUNCTION gpSelect_Object_GoodsKindWeighingGroup();

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsKindWeighingGroup(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, ParentId Integer) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

     RETURN QUERY
     SELECT
           Object.Id           AS Id
         , Object.ObjectCode   AS Code
         , Object.ValueData    AS Name
         , Object.isErased     AS isErased
         , CAST (0 as Integer) AS ParentId
     FROM Object
/*
LEFT JOIN ObjectLink
       ON ObjectLink.ObjectId = Object.Id
      AND ObjectLink.DescId = zc_ObjectLink_GoodsKindWeighingGroup_Parent()
*/
    WHERE Object.DescId = zc_Object_GoodsKindWeighingGroup();

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsKindWeighingGroup(TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.03.14                                                         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_GoodsKindWeighingGroup('2')