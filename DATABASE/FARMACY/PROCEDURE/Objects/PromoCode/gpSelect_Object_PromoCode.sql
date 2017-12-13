-- Function: gpSelect_Object_PromoCode(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_PromoCode(Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PromoCode(
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
     vbUserId:= lpGetUserBySession (inSession);


     -- ���������
     RETURN QUERY 
       WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE)

       SELECT 
             Object_PromoCode.Id            AS Id
           , Object_PromoCode.ObjectCode    AS Code
           , Object_PromoCode.ValueData     AS Name

           , ObjectString_Comment.ValueData AS Comment

           , Object_PromoCode.isErased      AS isErased
           
       FROM tmpIsErased
            INNER JOIN Object AS Object_PromoCode
                              ON Object_PromoCode.isErased = tmpIsErased.isErased 
                             AND Object_PromoCode.DescId = zc_Object_PromoCode()

            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_PromoCode.Id
                                  AND ObjectString_Comment.DescId = zc_ObjectString_PromoCode_Comment()
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.12.17         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_PromoCode(FALSE, zfCalc_UserAdmin())
