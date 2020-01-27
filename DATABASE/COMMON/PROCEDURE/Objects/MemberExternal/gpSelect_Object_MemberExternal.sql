-- Function: gpSelect_Object_MemberExternal (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_MemberExternal (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MemberExternal(
    IN inIsShowAll        Boolean,       --
    IN inSession          TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , DriverCertificate TVarChar
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_MemberExternal());
   vbUserId:= lpGetUserBySession (inSession);


   -- ���������
   RETURN QUERY 
     SELECT 
           Object_MemberExternal.Id         AS Id
         , Object_MemberExternal.ObjectCode AS Code
         , Object_MemberExternal.ValueData  AS Name
         , ObjectString_DriverCertificate.ValueData :: TVarChar AS DriverCertificate

         , Object_MemberExternal.isErased                   AS isErased

     FROM Object AS Object_MemberExternal
           LEFT JOIN ObjectString AS ObjectString_DriverCertificate
                                  ON ObjectString_DriverCertificate.ObjectId = Object_MemberExternal.Id 
                                 AND ObjectString_DriverCertificate.DescId = zc_ObjectString_MemberExternal_DriverCertificate()
     WHERE Object_MemberExternal.DescId = zc_Object_MemberExternal()
       AND (Object_MemberExternal.isErased = FALSE
            OR (Object_MemberExternal.isErased = TRUE AND inIsShowAll = TRUE)
           )
    ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_MemberExternal (Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.01.20         * add DriverCertificate
 28.03.15                                        *
*/
-- ����
-- SELECT * FROM gpSelect_Object_MemberExternal (FALSE, zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Object_MemberExternal (TRUE, zfCalc_UserAdmin())
