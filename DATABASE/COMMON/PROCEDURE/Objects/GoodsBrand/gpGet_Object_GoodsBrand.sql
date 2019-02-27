-- Function: gpGet_Object_GoodsBrand()

DROP FUNCTION IF EXISTS gpGet_Object_GoodsBrand (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsBrand(
    IN inId          Integer,       -- ���� ������� <�������>
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_GoodsBrand());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_GoodsBrand()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_GoodsBrand.Id         AS Id
            , Object_GoodsBrand.ObjectCode AS Code
            , Object_GoodsBrand.ValueData  AS Name
            , Object_GoodsBrand.isErased   AS isErased
       FROM Object AS Object_GoodsBrand
       WHERE Object_GoodsBrand.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.02.19         *
*/

-- ����
-- SELECT * FROM gpGet_Object_GoodsBrand (0, '2')