-- Function: gpGet_Object_GoodsAnalog()

DROP FUNCTION IF EXISTS gpGet_Object_GoodsAnalog(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsAnalog(
    IN inId          Integer,       -- ���� ������� <>
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_GoodsAnalog()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY
       SELECT
             Object_GoodsAnalog.Id                       AS Id
           , Object_GoodsAnalog.ObjectCode               AS Code
           , Object_GoodsAnalog.ValueData                AS Name
           , Object_GoodsAnalog.isErased                 AS isErased

       FROM Object AS Object_GoodsAnalog
       WHERE Object_GoodsAnalog.Id = inId;
   END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������ �.�.
 01.04.19         *

*/

-- ����
-- SELECT * FROM gpGet_Object_GoodsAnalog (1, '3')