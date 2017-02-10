-- Function: gpSelect_Object_Storage()

DROP FUNCTION IF EXISTS gpSelect_Object_Storage(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Storage(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , UnitId Integer, UnitName TVarChar
             , Address TVarChar, Comment TVarChar
             , isErased boolean
) AS
$BODY$BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Storage()());

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
   WHERE Object_Storage.DescId = zc_Object_Storage();
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Storage(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.07.16         *
 28.07.14         *

*/

-- ����
-- SELECT * FROM gpSelect_Object_Storage('2')