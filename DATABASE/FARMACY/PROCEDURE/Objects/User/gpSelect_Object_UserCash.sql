-- Function: gpSelect_Object_UserCash (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_UserCash (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_UserCash(
    IN inIsShowAll   Boolean  ,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean
             , MemberId Integer, MemberName TVarChar
             , UserSign TVarChar, UserSeal TVarChar, UserKey TVarChar
             , BranchCode Integer, BranchName TVarChar
             , UnitCode Integer, UnitName TVarChar
             , PositionName TVarChar
             , ProjectMobile TVarChar
             , Foto TVarChar
             , BillNumberMobile Integer
             , isProjectMobile Boolean
             , isSite Boolean
             , UpdateMobileFrom TDateTime, UpdateMobileTo TDateTime
             , InDate TDateTime, FarmacyCashDate TDateTime
             , isWorkingMultiple Boolean
             , isNewUser Boolean
             , isDismissedUser Boolean
             , isInternshipCompleted Boolean
             , DateInternshipCompleted TDateTime
             , InternshipConfirmation TVarChar
             , DateInternshipConfirmation TDateTime
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);

   -- Результат
   RETURN QUERY 
   WITH tmpPersonal AS (SELECT View_Personal.MemberId
                             , MAX (View_Personal.UnitId) AS UnitId
                             , MAX (View_Personal.PositionId) AS PositionId
                        FROM Object_Personal_View AS View_Personal
                        WHERE View_Personal.isErased = FALSE
                        GROUP BY View_Personal.MemberId
                       )
   SELECT 
         Object_User.Id                             AS Id
       , Object_User.ObjectCode                     AS Code
       , Object_User.ValueData                      AS Name
       , Object_User.isErased                       AS isErased
       , Object_Member.Id                           AS MemberId
       , Object_Member.ValueData                    AS MemberName
                                                    
       , ObjectString_UserSign.ValueData            AS UserSign
       , ObjectString_UserSeal.ValueData            AS UserSeal
       , ObjectString_UserKey.ValueData             AS UserKey
                                                    
       , Object_Branch.ObjectCode                   AS BranchCode
       , Object_Branch.ValueData                    AS BranchName
       , Object_Unit.ObjectCode                     AS UnitCode
       , Object_Unit.ValueData                      AS UnitName
       , Object_Position.ValueData                  AS PositionName

       , ObjectString_ProjectMobile.ValueData       AS ProjectMobile
       , ObjectString_Foto.ValueData                AS Foto
       , ObjectFloat_BillNumberMobile.ValueData :: Integer AS BillNumberMobile
       , COALESCE (ObjectBoolean_ProjectMobile.ValueData, FALSE) :: Boolean  AS isProjectMobile
       
       , COALESCE (ObjectBoolean_Site.ValueData, FALSE)          :: Boolean  AS isSite

       , ObjectDate_User_UpdateMobileFrom.ValueData AS UpdateMobileFrom
       , ObjectDate_User_UpdateMobileTo.ValueData   AS UpdateMobileTo
       
       , ObjectDate_User_In.ValueData               AS InDate
       , ObjectDate_User_FarmacyCash.ValueData      AS FarmacyCashDate
 
       , COALESCE (ObjectBoolean_WorkingMultiple.ValueData, FALSE)::Boolean  AS isWorkingMultiple

       , COALESCE (ObjectBoolean_NewUser.ValueData, FALSE)::Boolean          AS isNewUser
       , COALESCE (ObjectBoolean_DismissedUser.ValueData, FALSE)::Boolean    AS isDismissedUser

       , COALESCE (ObjectBoolean_InternshipCompleted.ValueData, FALSE)::Boolean    AS isInternshipCompleted
       , ObjectDate_User_InternshipCompleted.ValueData                             AS DateInternshipCompleted
       , CASE WHEN  COALESCE (ObjectBoolean_InternshipCompleted.ValueData, FALSE) = FALSE THEN ''
              WHEN COALESCE (ObjectFloat_InternshipConfirmation.ValueData, 0) = 0 THEN 'Не обработал сотрудник'
              WHEN COALESCE (ObjectFloat_InternshipConfirmation.ValueData, 0) = 1 THEN 'Не подтверждено сотрудником'
              ELSE 'Подтверждено сотрудником' END::TVarChar                        AS InternshipConfirmation
       , ObjectDate_User_InternshipConfirmation.ValueData                          AS DateInternshipConfirmation
       
   FROM Object AS Object_User
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
              
   WHERE Object_User.DescId = zc_Object_User()
     AND Object_Position.ObjectCode in (1, 2)
     AND (Object_User.isErased = False OR inIsShowAll = True);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_User (TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.09.22                                                       *
*/

-- тест
--
 SELECT * FROM gpSelect_Object_UserCash (False, '3')