-- Function: gpGet_Object_SiteTag()

DROP FUNCTION IF EXISTS gpGet_Object_SiteTag (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_SiteTag(
    IN inId          Integer,       -- ���� ������� <��� (�����, ��������>
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, Comment TVarChar, isErased boolean) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_SiteTag());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_SiteTag()) AS Code
           , CAST ('' as TVarChar)  AS Name
           , CAST ('' as TVarChar)  AS Comment
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT 
             Object.Id         AS Id
           , Object.ObjectCode AS Code
           , Object.ValueData  AS Name
           , ObjectString_Comment.ValueData  AS Comment
           , Object.isErased   AS isErased
       FROM Object
        LEFT JOIN ObjectString AS ObjectString_Comment
                               ON ObjectString_Comment.ObjectId = Object.Id 
                              AND ObjectString_Comment.DescId = zc_ObjectString_SiteTag_Comment()
       WHERE Object.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.12.24         *
*/

-- ����
-- SELECT * FROM gpGet_Object_SiteTag (0, '2')