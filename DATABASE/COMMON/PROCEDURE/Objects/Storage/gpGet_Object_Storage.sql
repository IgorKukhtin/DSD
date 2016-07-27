-- Function: gpGet_Object_Storage()

DROP FUNCTION IF EXISTS gpGet_Object_Storage(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Storage(
    IN inId          Integer,       -- ���� ������� <����� ��������>
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , UnitId Integer, UnitName TVarChar
             , Address TVarChar, Comment TVarChar
             , isErased boolean
) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_Storage()) AS Code
           , CAST ('' as TVarChar)  AS Name

           , CAST (0 as Integer)    AS UnitId
           , CAST ('' as TVarChar)  AS UnitName

           , CAST ('' as TVarChar)  AS Address
           , CAST ('' as TVarChar)  AS Comment

           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_Storage.Id         AS Id
           , Object_Storage.ObjectCode AS Code
           , Object_Storage.ValueData  AS Name

           , Object_Unit.Id            AS UnitId
           , Object_Unit.ValueData     AS UnitName

           , ObjectString_Storage_Address.ValueData   AS Address
           , ObjectString_Storage_Comment.ValueData   AS Comment

           , Object_Storage.isErased   AS isErased

       FROM Object AS Object_Storage
            LEFT JOIN ObjectString AS ObjectString_Storage_Address
                                   ON ObjectString_Storage_Address.ObjectId = Object_Storage.Id 
                                  AND ObjectString_Storage_Address.DescId = zc_ObjectString_Storage_Address()
            LEFT JOIN ObjectString AS ObjectString_Storage_Comment
                                   ON ObjectString_Storage_Comment.ObjectId = Object_Storage.Id 
                                  AND ObjectString_Storage_Comment.DescId = zc_ObjectString_Storage_Comment()
            LEFT JOIN ObjectLink AS ObjectLink_Storage_Unit
                                 ON ObjectLink_Storage_Unit.ObjectId = Object_Storage.Id 
                                AND ObjectLink_Storage_Unit.DescId = zc_ObjectLink_Storage_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Storage_Unit.ChildObjectId
       WHERE Object_Storage.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Storage(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.07.16         *
 28.07.14         *

*/

-- ����
-- SELECT * FROM gpGet_Object_Storage (0, '2')