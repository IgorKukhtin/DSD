-- Function: gpSelect_Object_StickerGroup (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_StickerGroup (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_StickerGroup(
    IN inShowAll     Boolean,  
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , Comment TVarChar
             , isErased boolean
             ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_StickerGroup());
     vbUserId:= lpGetUserBySession (inSession);
     -- ������������ - ����� �� ���������� ������ ���� ����������
     --vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

     -- ���������
     RETURN QUERY 
       WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE)

       SELECT 
             Object_StickerGroup.Id          AS Id
           , Object_StickerGroup.ObjectCode  AS Code
           , Object_StickerGroup.ValueData   AS Name

           , ObjectString_Comment.ValueData AS Comment

           , Object_StickerGroup.isErased    AS isErased
           
       FROM tmpIsErased
            INNER JOIN Object AS Object_StickerGroup
                              ON Object_StickerGroup.isErased = tmpIsErased.isErased 
                             AND Object_StickerGroup.DescId = zc_Object_StickerGroup()

            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_StickerGroup.Id
                                  AND ObjectString_Comment.DescId = zc_ObjectString_StickerGroup_Comment()
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.10.17         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_StickerGroup (FALSE, zfCalc_UserAdmin())
