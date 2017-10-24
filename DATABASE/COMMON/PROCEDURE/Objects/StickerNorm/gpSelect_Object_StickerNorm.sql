-- Function: gpSelect_Object_StickerNorm(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_StickerNorm(Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_StickerNorm(
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
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_StickerNorm());
     vbUserId:= lpGetUserBySession (inSession);
     -- ������������ - ����� �� ���������� ������ ���� ����������
     --vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

     -- ���������
     RETURN QUERY 
       WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE)

       SELECT 
             Object_StickerNorm.Id          AS Id
           , Object_StickerNorm.ObjectCode  AS Code
           , Object_StickerNorm.ValueData   AS Name

           , ObjectString_Comment.ValueData AS Comment

           , Object_StickerNorm.isErased    AS isErased
           
       FROM tmpIsErased
            INNER JOIN Object AS Object_StickerNorm
                              ON Object_StickerNorm.isErased = tmpIsErased.isErased 
                             AND Object_StickerNorm.DescId = zc_Object_StickerNorm()

            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_StickerNorm.Id
                                  AND ObjectString_Comment.DescId = zc_ObjectString_StickerNorm_Comment()
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
-- SELECT * FROM gpSelect_Object_StickerNorm(FALSE, zfCalc_UserAdmin())
