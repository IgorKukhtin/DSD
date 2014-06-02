-- Function: gpSelect_Object_Street (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Street (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Street(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , PostalCode TVarChar
             , StreetKindId Integer, StreetKindCode Integer, StreetKindName TVarChar
             , CityId Integer, CityCode Integer, CityName TVarChar
             , ProvinceCityId Integer, ProvinceCityCode Integer, ProvinceCityName TVarChar
             , isErased boolean
             ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Street());
     vbUserId:= lpGetUserBySession (inSession);
     -- ������������ - ����� �� ���������� ������ ���� ����������
     vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

     -- ���������
     RETURN QUERY 
       SELECT 
             Object_Street.Id          AS Id
           , Object_Street.ObjectCode  AS Code
           , Object_Street.ValueData   AS Name
           
           , PostalCode.ValueData      AS PostalCode
           
           , Object_StreetKind.Id           AS StreetKindId
           , Object_StreetKind.ObjectCode   AS StreetKindCode
           , Object_StreetKind.ValueData    AS StreetKindName
         
           , Object_City.Id                 AS CityId
           , Object_City.ObjectCode         AS CityCode
           , Object_City.ValueData          AS CityName

           , View_ProvinceCity.PersonalId   AS ProvinceCityId
           , View_ProvinceCity.PersonalCode AS ProvinceCityCode
           , View_ProvinceCity.PersonalName AS ProvinceCityName
           
           , Object_Street.isErased    AS isErased
           
       FROM Object AS Object_Street
           -- LEFT JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON NOT vbAccessKeyAll AND tmpRoleAccessKey.AccessKeyId = Object_Street.AccessKeyId
       
            LEFT JOIN ObjectString AS PostalCode
                                   ON PostalCode.ObjectId = Object_Street.Id 
                                  AND PostalCode.DescId = zc_ObjectString_Street_PostalCode()
                                                             
            LEFT JOIN ObjectLink AS Street_StreetKind
                                 ON Street_StreetKind.ObjectId = Object_Street.Id
                                AND Street_StreetKind.DescId = zc_ObjectLink_Street_StreetKind()
            LEFT JOIN Object AS Object_StreetKind ON Object_StreetKind.Id = Street_StreetKind.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_Street_City 
                                 ON ObjectLink_Street_City.ObjectId = Object_Street.Id
                                AND ObjectLink_Street_City.DescId = zc_ObjectLink_Street_City()
            LEFT JOIN Object AS Object_City ON Object_City.Id = ObjectLink_Street_City.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_Street_ProvinceCity 
                                 ON ObjectLink_Street_ProvinceCity.ObjectId = Object_Street.Id
                                AND ObjectLink_Street_ProvinceCity.DescId = zc_ObjectLink_Street_ProvinceCity()
            LEFT JOIN Object_Personal_View AS View_ProvinceCity ON View_ProvinceCity.PersonalId = ObjectLink_Street_ProvinceCity.ChildObjectId
            
     WHERE Object_Street.DescId = zc_Object_Street()
      -- AND (tmpRoleAccessKey.AccessKeyId IS NOT NULL OR vbAccessKeyAll)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Street(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 31.05.14          * 
        
*/

-- ����
-- SELECT * FROM gpSelect_Object_Street (zfCalc_UserAdmin())