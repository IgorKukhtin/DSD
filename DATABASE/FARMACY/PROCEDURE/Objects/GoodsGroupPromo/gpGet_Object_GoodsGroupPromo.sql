-- Function: gpGet_Object_GoodsGroupPromo (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_GoodsGroupPromo (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsGroupPromo(
    IN inId          Integer,       -- ������ ������� 
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar)
AS
$BODY$
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   --   PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_GoodsGroupPromo()) AS Code
           , CAST ('' as TVarChar)  AS Name;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_GoodsGroupPromo.Id            AS Id
           , Object_GoodsGroupPromo.ObjectCode    AS Code
           , Object_GoodsGroupPromo.ValueData     AS Name
       FROM OBJECT AS Object_GoodsGroupPromo
       WHERE Object_GoodsGroupPromo.Id = inId;
   END IF;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_GoodsGroupPromo (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.07.19                                                       *

*/

-- ����
-- SELECT * FROM gpGet_Object_GoodsGroupPromo(0,'3')