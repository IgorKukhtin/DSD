-- Function: gpSelect_Object_StickerSkin (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_StickerSkin (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_StickerSkin(
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
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_StickerSkin());
     vbUserId:= lpGetUserBySession (inSession);
     -- ������������ - ����� �� ���������� ������ ���� ����������
     --vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

     -- ���������
     RETURN QUERY 
       WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE)

       SELECT 
             Object_StickerSkin.Id          AS Id
           , Object_StickerSkin.ObjectCode  AS Code
           , Object_StickerSkin.ValueData   AS Name

           , ObjectString_Comment.ValueData AS Comment

           , Object_StickerSkin.isErased    AS isErased
           
       FROM tmpIsErased
            INNER JOIN Object AS Object_StickerSkin
                              ON Object_StickerSkin.isErased = tmpIsErased.isErased 
                             AND Object_StickerSkin.DescId = zc_Object_StickerSkin()

            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_StickerSkin.Id
                                  AND ObjectString_Comment.DescId = zc_ObjectString_StickerSkin_Comment()
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
-- SELECT * FROM gpSelect_Object_StickerSkin (FALSE, zfCalc_UserAdmin())
