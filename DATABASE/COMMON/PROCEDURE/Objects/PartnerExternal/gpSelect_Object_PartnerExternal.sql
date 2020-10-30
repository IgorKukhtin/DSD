-- Function: gpSelect_Object_PartnerExternal (Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_PartnerExternal (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PartnerExternal(
    IN inShowAll     Boolean  ,
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , ObjectCode TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , isErased boolean
             ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_PartnerExternal());
     vbUserId:= lpGetUserBySession (inSession);
     -- ������������ - ����� �� ���������� ������ ���� ����������
     vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

     -- ���������
     RETURN QUERY 
       SELECT 
             Object_PartnerExternal.Id          AS Id
           , Object_PartnerExternal.ObjectCode  AS Code
           , Object_PartnerExternal.ValueData   AS Name
           
           , ObjectString_ObjectCode.ValueData  AS ObjectCode

           , Object_Partner.Id                  AS PartnerId
           , Object_Partner.ValueData           AS PartnerName 
           
           , Object_PartnerExternal.isErased    AS isErased
           
       FROM Object AS Object_PartnerExternal
           -- LEFT JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON NOT vbAccessKeyAll AND tmpRoleAccessKey.AccessKeyId = Object_PartnerExternal.AccessKeyId
       
            LEFT JOIN ObjectString AS ObjectString_ObjectCode
                                   ON ObjectString_ObjectCode.ObjectId = Object_PartnerExternal.Id 
                                  AND ObjectString_ObjectCode.DescId = zc_ObjectString_PartnerExternal_ObjectCode()

            LEFT JOIN ObjectLink AS ObjectLink_Partner
                                 ON ObjectLink_Partner.ObjectId = Object_PartnerExternal.Id 
                                AND ObjectLink_Partner.DescId = zc_ObjectLink_PartnerExternal_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Partner.ChildObjectId

     WHERE Object_PartnerExternal.DescId = zc_Object_PartnerExternal()
       AND (Object_PartnerExternal.isErased = inShowAll OR inShowAll = TRUE)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.10.20         *       
*/

-- ����
-- SELECT * FROM gpSelect_Object_PartnerExternal (False, zfCalc_UserAdmin())
