-- Function: gpGet_Object_User()

DROP FUNCTION IF EXISTS gpGet_Object_User (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_User(
    IN inId          Integer,       -- ������������ 
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Password TVarChar
             , UserSign TVarChar
             , UserSeal TVarChar
             , UserKey TVarChar
             , MemberId Integer, MemberName TVarChar
             , ProjectMobile TVarChar
             , isProjectMobile Boolean
             , isSite Boolean
             , PasswordWages TVarChar
             , isManagerPharmacy Boolean
             , isWorkingMultiple Boolean
             , isNewUser Boolean
             , isDismissedUser Boolean
             , isInternshipCompleted Boolean
             , InternshipConfirmation TVarChar
             , Language TVarChar
) AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Get_Object_User());


   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_User()) AS Code
           , CAST ('' as TVarChar)   AS NAME
           , CAST ('' as TVarChar)   AS Password
           , CAST ('' as TVarChar)   AS UserSign
           , CAST ('' as TVarChar)   AS UserSeal
           , CAST ('' as TVarChar)   AS UserKey
           , 0                       AS MemberId 
           , CAST ('' as TVarChar)   AS MemberName
           , CAST ('' as TVarChar)   AS ProjectMobile
           , FALSE                   AS isProjectMobile
           , FALSE                   AS isSite
           , CAST ('' as TVarChar)   AS PasswordWages
           , FALSE                   AS isManagerPharmacy
           , FALSE                   AS isWorkingMultiple
           , TRUE                    AS isNewUser
           , FALSE                   AS isDismissedUser
           , FALSE                   AS isInternshipCompleted
           , CAST ('' as TVarChar)   AS InternshipConfirmation
           , CAST ('RU' as TVarChar) AS Language
       ;
   ELSE
      RETURN QUERY 
      SELECT 
            Object_User.Id
          , Object_User.ObjectCode
          , Object_User.ValueData
          , ObjectString_UserPassword.ValueData

          , ObjectString_UserSign.ValueData  AS UserSign
          , ObjectString_UserSeal.ValueData  AS UserSeal
          , ObjectString_UserKey.ValueData   AS UserKey

          , Object_Member.Id AS MemberId
          , Object_Member.ValueData AS MemberName

          , ObjectString_ProjectMobile.ValueData  AS ProjectMobile
          , COALESCE (ObjectBoolean_ProjectMobile.ValueData, FALSE) :: Boolean  AS isProjectMobile
          , COALESCE (ObjectBoolean_Site.ValueData, FALSE)          :: Boolean  AS isSite

          , ObjectString_PasswordWages.ValueData
          , COALESCE (ObjectBoolean_ManagerPharmacy.ValueData, FALSE)::Boolean  AS isManagerPharmacy

          , COALESCE (ObjectBoolean_WorkingMultiple.ValueData, FALSE)::Boolean  AS isWorkingMultiple

          , COALESCE (ObjectBoolean_NewUser.ValueData, FALSE)::Boolean          AS isNewUser
          , COALESCE (ObjectBoolean_DismissedUser.ValueData, FALSE)::Boolean    AS isDismissedUser

          , COALESCE (ObjectBoolean_InternshipCompleted.ValueData, FALSE)::Boolean    AS isInternshipCompleted
          , CASE WHEN COALESCE (ObjectBoolean_InternshipCompleted.ValueData, FALSE) = FALSE THEN ''
                 WHEN COALESCE (ObjectFloat_InternshipConfirmation.ValueData, 0) = 0 THEN '�� ��������� ���������'
                 WHEN COALESCE (ObjectFloat_InternshipConfirmation.ValueData, 0) = 1 THEN '�� ������������ �����������'
                 ELSE '������������ �����������' END::TVarChar                        AS InternshipConfirmation
          , COALESCE (ObjectString_Language.ValueData, 'RU')::TVarChar                AS Language

      FROM Object AS Object_User
           LEFT JOIN ObjectString AS ObjectString_UserPassword 
                  ON ObjectString_UserPassword.DescId = zc_ObjectString_User_Password() 
                 AND ObjectString_UserPassword.ObjectId = Object_User.Id
        
           LEFT JOIN ObjectString AS ObjectString_UserSign
                  ON ObjectString_UserSign.DescId = zc_ObjectString_User_Sign() 
                 AND ObjectString_UserSign.ObjectId = Object_User.Id
        
           LEFT JOIN ObjectString AS ObjectString_UserSeal
                  ON ObjectString_UserSeal.DescId = zc_ObjectString_User_Seal() 
                 AND ObjectString_UserSeal.ObjectId = Object_User.Id
        
           LEFT JOIN ObjectString AS ObjectString_UserKey 
                  ON ObjectString_UserKey.DescId = zc_ObjectString_User_Key() 
                 AND ObjectString_UserKey.ObjectId = Object_User.Id
        
           LEFT JOIN ObjectString AS ObjectString_ProjectMobile
                  ON ObjectString_ProjectMobile.ObjectId = Object_User.Id
                 AND ObjectString_ProjectMobile.DescId = zc_ObjectString_User_ProjectMobile()
                 
           LEFT JOIN ObjectString AS ObjectString_Language
                  ON ObjectString_Language.ObjectId = Object_User.Id
                 AND ObjectString_Language.DescId = zc_ObjectString_User_Language()
                 
           LEFT JOIN ObjectBoolean AS ObjectBoolean_ProjectMobile
                  ON ObjectBoolean_ProjectMobile.ObjectId = Object_User.Id
                 AND ObjectBoolean_ProjectMobile.DescId = zc_ObjectBoolean_User_ProjectMobile()
           
           LEFT JOIN ObjectBoolean AS ObjectBoolean_Site
                  ON ObjectBoolean_Site.ObjectId = Object_User.Id
                 AND ObjectBoolean_Site.DescId = zc_ObjectBoolean_User_Site()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_WorkingMultiple
                                   ON ObjectBoolean_WorkingMultiple.ObjectId = Object_User.Id
                                  AND ObjectBoolean_WorkingMultiple.DescId = zc_ObjectBoolean_User_WorkingMultiple()
                 
           LEFT JOIN ObjectLink AS ObjectLink_User_Member
                  ON ObjectLink_User_Member.ObjectId = Object_User.Id
                 AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
           LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId
           
           LEFT JOIN ObjectString AS ObjectString_PasswordWages
                  ON ObjectString_PasswordWages.DescId = zc_ObjectString_User_PasswordWages() 
                 AND ObjectString_PasswordWages.ObjectId = Object_User.Id
           
           LEFT JOIN ObjectBoolean AS ObjectBoolean_ManagerPharmacy
                                   ON ObjectBoolean_ManagerPharmacy.ObjectId = ObjectLink_User_Member.ChildObjectId
                                  AND ObjectBoolean_ManagerPharmacy.DescId = zc_ObjectBoolean_Member_ManagerPharmacy()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_NewUser
                                   ON ObjectBoolean_NewUser.ObjectId = Object_User.Id
                                  AND ObjectBoolean_NewUser.DescId = zc_ObjectBoolean_User_NewUser()
           LEFT JOIN ObjectBoolean AS ObjectBoolean_DismissedUser
                                   ON ObjectBoolean_DismissedUser.ObjectId = Object_User.Id
                                  AND ObjectBoolean_DismissedUser.DescId = zc_ObjectBoolean_User_DismissedUser()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_InternshipCompleted
                                   ON ObjectBoolean_InternshipCompleted.ObjectId = Object_User.Id
                                  AND ObjectBoolean_InternshipCompleted.DescId = zc_ObjectBoolean_User_InternshipCompleted()
           LEFT JOIN ObjectFloat AS ObjectFloat_InternshipConfirmation
                                 ON ObjectFloat_InternshipConfirmation.ObjectId = Object_User.Id
                                AND ObjectFloat_InternshipConfirmation.DescId = zc_ObjectFloat_User_InternshipConfirmation()
      WHERE Object_User.Id = inId;
   END IF;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_User (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.08.19                                                       *
 06.11.17         *
 21.04.17         *
 12.09.16         *
 07.06.13                                        * lpCheckRight
 03.06.13         *
*/

-- ����
-- select * from gpGet_Object_User(inId := 3 ,  inSession := '3');