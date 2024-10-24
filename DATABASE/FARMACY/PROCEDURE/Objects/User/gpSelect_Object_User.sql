-- Function: gpSelect_Object_User (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_User (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_User(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean
             , MemberId Integer, MemberName TVarChar
             , User_ TVarChar, UserSign TVarChar, UserSeal TVarChar, UserKey TVarChar
             , BranchCode Integer, BranchName TVarChar
             , UnitCode Integer, UnitName TVarChar
             , PositionName TVarChar, EducationName TVarChar
             , ProjectMobile TVarChar
             , Foto TVarChar
             , BillNumberMobile Integer
             , isProjectMobile Boolean
             , isSite Boolean
             , UpdateMobileFrom TDateTime, UpdateMobileTo TDateTime
             , InDate TDateTime, FarmacyCashDate TDateTime
             , PasswordWages TVarChar
             , isWorkingMultiple Boolean
             , isNewUser Boolean
             , isDismissedUser Boolean
             , isInternshipCompleted Boolean
             , DateInternshipCompleted TDateTime
             , InternshipConfirmation TVarChar
             , DateInternshipConfirmation TDateTime
             , Language TVarChar
             , isPhotosOnSite Boolean
             , isActive Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
IF inSession = '9464' THEN vbUserId := 9464;
ELSE
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Object_User());
END IF;

     -- ��������� ��� ��������
     IF vbUserId = 9457 -- ���������� �.�.
     THEN
         vbUserId:= NULL;
         RETURN;
     END IF;

   -- ���������
   RETURN QUERY 
   WITH tmpPersonal AS (SELECT View_Personal.MemberId
                             , MAX (View_Personal.UnitId) AS UnitId
                             , MAX (View_Personal.PositionId) AS PositionId
                        FROM Object_Personal_View AS View_Personal
                        WHERE View_Personal.isErased = FALSE
                        GROUP BY View_Personal.MemberId
                       ),
         tmpEmployeeSchedule AS (SELECT DISTINCT
                                        MovementItemMaster.ObjectId              AS UserId
                                 FROM Movement

                                      INNER JOIN MovementItem AS MovementItemMaster
                                                              ON MovementItemMaster.MovementId = Movement.Id
                                                             AND MovementItemMaster.DescId = zc_MI_Master()

                                 WHERE Movement.OperDate > date_trunc('Month', CURRENT_DATE) - INTERVAL '3 MONTH'
                                   AND Movement.DescId = zc_Movement_EmployeeSchedule()
                                   AND Movement.StatusId <> zc_Enum_Status_Erased())
                                          
   SELECT 
         Object_User.Id                             AS Id
       , Object_User.ObjectCode                     AS Code
       , Object_User.ValueData                      AS Name
       , Object_User.isErased                       AS isErased
       , Object_Member.Id                           AS MemberId
       , Object_Member.ValueData                    AS MemberName
                                                    
       , ObjectString_User_.ValueData               AS User_
       , ObjectString_UserSign.ValueData            AS UserSign
       , ObjectString_UserSeal.ValueData            AS UserSeal
       , ObjectString_UserKey.ValueData             AS UserKey
                                                    
       , Object_Branch.ObjectCode                   AS BranchCode
       , Object_Branch.ValueData                    AS BranchName
       , Object_Unit.ObjectCode                     AS UnitCode
       , Object_Unit.ValueData                      AS UnitName
       , Object_Position.ValueData                  AS PositionName
       , Object_Education.ValueData                 AS EducationName

       , ObjectString_ProjectMobile.ValueData       AS ProjectMobile
       , ObjectString_Foto.ValueData                AS Foto
       , ObjectFloat_BillNumberMobile.ValueData :: Integer AS BillNumberMobile
       , COALESCE (ObjectBoolean_ProjectMobile.ValueData, FALSE) :: Boolean  AS isProjectMobile
       
       , COALESCE (ObjectBoolean_Site.ValueData, FALSE)          :: Boolean  AS isSite

       , ObjectDate_User_UpdateMobileFrom.ValueData AS UpdateMobileFrom
       , ObjectDate_User_UpdateMobileTo.ValueData   AS UpdateMobileTo
       
       , ObjectDate_User_In.ValueData               AS InDate
       , ObjectDate_User_FarmacyCash.ValueData      AS FarmacyCashDate
       , ObjectString_PasswordWages.ValueData
 
       , COALESCE (ObjectBoolean_WorkingMultiple.ValueData, FALSE)::Boolean  AS isWorkingMultiple

       , COALESCE (ObjectBoolean_NewUser.ValueData, FALSE)::Boolean          AS isNewUser
       , COALESCE (ObjectBoolean_DismissedUser.ValueData, FALSE)::Boolean    AS isDismissedUser

       , COALESCE (ObjectBoolean_InternshipCompleted.ValueData, FALSE)::Boolean    AS isInternshipCompleted
       , ObjectDate_User_InternshipCompleted.ValueData                             AS DateInternshipCompleted
       , CASE WHEN  COALESCE (ObjectBoolean_InternshipCompleted.ValueData, FALSE) = FALSE THEN ''
              WHEN COALESCE (ObjectFloat_InternshipConfirmation.ValueData, 0) = 0 THEN '�� ��������� ���������'
              WHEN COALESCE (ObjectFloat_InternshipConfirmation.ValueData, 0) = 1 THEN '�� ������������ �����������'
              ELSE '������������ �����������' END::TVarChar                        AS InternshipConfirmation
       , ObjectDate_User_InternshipConfirmation.ValueData                          AS DateInternshipConfirmation
       , COALESCE (ObjectString_Language.ValueData, 'RU')::TVarChar                AS Language
       
       , COALESCE (ObjectBoolean_PhotosOnSite.ValueData, FALSE)::Boolean           AS isPhotosOnSite
       
       , COALESCE (tmpEmployeeSchedule.UserId, 0) > 0                              AS isActive
       
   FROM Object AS Object_User
        LEFT JOIN ObjectString AS ObjectString_User_
                               ON ObjectString_User_.ObjectId = Object_User.Id
                              AND ObjectString_User_.DescId = zc_ObjectString_User_Password()
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
                              
        LEFT JOIN ObjectString AS ObjectString_Foto
                               ON ObjectString_Foto.ObjectId = Object_User.Id
                              AND ObjectString_Foto.DescId = zc_ObjectString_User_Foto()

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

        LEFT JOIN ObjectBoolean AS ObjectBoolean_NewUser
                                ON ObjectBoolean_NewUser.ObjectId = Object_User.Id
                               AND ObjectBoolean_NewUser.DescId = zc_ObjectBoolean_User_NewUser()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_DismissedUser
                                ON ObjectBoolean_DismissedUser.ObjectId = Object_User.Id
                               AND ObjectBoolean_DismissedUser.DescId = zc_ObjectBoolean_User_DismissedUser()

        LEFT JOIN ObjectFloat AS ObjectFloat_BillNumberMobile
                              ON ObjectFloat_BillNumberMobile.ObjectId = Object_User.Id
                             AND ObjectFloat_BillNumberMobile.DescId = zc_ObjectFloat_User_BillNumberMobile()

        LEFT JOIN ObjectLink AS ObjectLink_User_Member
                             ON ObjectLink_User_Member.ObjectId = Object_User.Id
                            AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
        LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Member_Education
                             ON ObjectLink_Member_Education.ObjectId = Object_Member.Id
                            AND ObjectLink_Member_Education.DescId = zc_ObjectLink_Member_Education()
        LEFT JOIN Object AS Object_Education ON Object_Education.Id = ObjectLink_Member_Education.ChildObjectId

        LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
        LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId
        LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                             ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
        LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId

        LEFT JOIN ObjectDate AS ObjectDate_User_UpdateMobileFrom
                             ON ObjectDate_User_UpdateMobileFrom.ObjectId = Object_User.Id
                            AND ObjectDate_User_UpdateMobileFrom.DescId = zc_ObjectDate_User_UpdateMobileFrom()
        LEFT JOIN ObjectDate AS ObjectDate_User_UpdateMobileTo
                             ON ObjectDate_User_UpdateMobileTo.ObjectId = Object_User.Id
                            AND ObjectDate_User_UpdateMobileTo.DescId = zc_ObjectDate_User_UpdateMobileTo()

        LEFT JOIN ObjectDate AS ObjectDate_User_In
                             ON ObjectDate_User_In.ObjectId = Object_User.Id
                            AND ObjectDate_User_In.DescId = zc_ObjectDate_User_In()  
        LEFT JOIN ObjectDate AS ObjectDate_User_FarmacyCash
                             ON ObjectDate_User_FarmacyCash.ObjectId = Object_User.Id
                            AND ObjectDate_User_FarmacyCash.DescId = zc_ObjectDate_User_FarmacyCash()

        LEFT JOIN ObjectString AS ObjectString_PasswordWages
               ON ObjectString_PasswordWages.DescId = zc_ObjectString_User_PasswordWages() 
              AND ObjectString_PasswordWages.ObjectId = Object_User.Id

        LEFT JOIN ObjectBoolean AS ObjectBoolean_InternshipCompleted
                                ON ObjectBoolean_InternshipCompleted.ObjectId = Object_User.Id
                               AND ObjectBoolean_InternshipCompleted.DescId = zc_ObjectBoolean_User_InternshipCompleted()
        LEFT JOIN ObjectDate AS ObjectDate_User_InternshipCompleted
                             ON ObjectDate_User_InternshipCompleted.ObjectId = Object_User.Id
                            AND ObjectDate_User_InternshipCompleted.DescId = zc_ObjectDate_User_InternshipCompleted()
        LEFT JOIN ObjectFloat AS ObjectFloat_InternshipConfirmation
                              ON ObjectFloat_InternshipConfirmation.ObjectId = Object_User.Id
                             AND ObjectFloat_InternshipConfirmation.DescId = zc_ObjectFloat_User_InternshipConfirmation()
        LEFT JOIN ObjectDate AS ObjectDate_User_InternshipConfirmation
                             ON ObjectDate_User_InternshipConfirmation.ObjectId = Object_User.Id
                            AND ObjectDate_User_InternshipConfirmation.DescId = zc_ObjectDate_User_InternshipConfirmation()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_PhotosOnSite
                                ON ObjectBoolean_PhotosOnSite.ObjectId = Object_User.Id
                               AND ObjectBoolean_PhotosOnSite.DescId = zc_ObjectBoolean_User_PhotosOnSite()
                               
        LEFT JOIN tmpEmployeeSchedule ON tmpEmployeeSchedule.UserId = Object_User.Id
              
   WHERE Object_User.DescId = zc_Object_User();
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_User (TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  �������� �.�.
 06.11.17         *
 02.05.17                                                       * zc_ObjectDate_User_UpdateMobileFrom, zc_ObjectDate_User_UpdateMobileTo
 21.04.17         *
 12.09.16         *
 07.06.13                                        * lpCheckRight
 25.09.13                                        *
*/

-- ����
-- SELECT * FROM gpSelect_Object_User ('3')