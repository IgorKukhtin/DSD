-- Function: gpGet_Object_ProvinceCity()

DROP FUNCTION IF EXISTS gpGet_Object_ProvinceCity(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ProvinceCity(
    IN inId          Integer,       -- ���� ������� <������>
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
           , lfGet_ObjectCode(0, zc_Object_ProvinceCity()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY
       SELECT
             Object_ProvinceCity.Id         AS Id
           , Object_ProvinceCity.ObjectCode AS Code
           , Object_ProvinceCity.ValueData  AS Name
           , Object_ProvinceCity.isErased   AS isErased

       FROM Object AS Object_ProvinceCity
       WHERE Object_ProvinceCity.Id = inId;
   END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 08.08.17         *

*/

-- ����
-- SELECT * FROM gpGet_Object_ProvinceCity (0, '2')