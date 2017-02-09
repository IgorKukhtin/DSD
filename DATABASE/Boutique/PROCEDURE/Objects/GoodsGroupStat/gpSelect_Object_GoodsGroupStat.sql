-- Function: gpSelect_Object_GoodsGroupStat()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsGroupStat(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsGroupStat(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsGroupStat());

   RETURN QUERY
   SELECT
          Object_GoodsGroupStat.Id         AS Id
        , Object_GoodsGroupStat.ObjectCode AS Code
        , Object_GoodsGroupStat.ValueData  AS Name

        , Object_GoodsGroupStat.isErased    AS isErased
   FROM Object AS Object_GoodsGroupStat
   WHERE Object_GoodsGroupStat.DescId = zc_Object_GoodsGroupStat();

END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsGroupStat(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ������ �.�.
 03.09.14         * 

*/

-- ����
-- SELECT * FROM gpSelect_Object_GoodsGroupStat('2')