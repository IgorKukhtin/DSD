-- Function: gpGet_Object_GoodsGroupStat()

DROP FUNCTION IF EXISTS gpGet_Object_GoodsGroupStat(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsGroupStat(
    IN inId          Integer,       -- ���� ������� <����������>
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroupStat());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_GoodsGroupStat()) AS Code
           , CAST ('' as TVarChar)  AS Name
          
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY
       SELECT
             Object_GoodsGroupStat.Id         AS Id
           , Object_GoodsGroupStat.ObjectCode AS Code
           , Object_GoodsGroupStat.ValueData  AS Name

           , Object_GoodsGroupStat.isErased   AS isErased

       FROM Object AS Object_GoodsGroupStat
       WHERE Object_GoodsGroupStat.Id = inId;
   END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_GoodsGroupStat(integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 03.09.14         *

*/

-- ����
-- SELECT * FROM gpGet_Object_GoodsGroupStat (0, '2')