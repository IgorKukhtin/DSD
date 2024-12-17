-- Function: gpSelect_Object_SiteTag()

DROP FUNCTION IF EXISTS gpSelect_Object_SiteTag (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_SiteTag(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar, isErased boolean
) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);
   
   RETURN QUERY 
   SELECT 
     Object.Id                       AS Id 
   , Object.ObjectCode               AS Code
   , Object.ValueData                AS Name
   , ObjectString_Comment.ValueData  AS Comment
   , Object.isErased                 AS isErased
   FROM Object
        LEFT JOIN ObjectString AS ObjectString_Comment
                               ON ObjectString_Comment.ObjectId = Object.Id 
                              AND ObjectString_Comment.DescId = zc_ObjectString_SiteTag_Comment()
   WHERE Object.DescId = zc_Object_SiteTag();
  
END;
$BODY$


LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.12.24         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_SiteTag('2')