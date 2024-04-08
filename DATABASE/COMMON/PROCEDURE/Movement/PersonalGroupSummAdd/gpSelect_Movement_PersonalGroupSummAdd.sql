-- Function: gpSelect_Movement_PersonalGroupSummAdd()

DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalGroupSummAdd (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PersonalGroupSummAdd(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inJuridicalBasisId  Integer   , -- гл. юр.лицо
    IN inIsErased          Boolean   ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , NormHour TFloat , TotalSumm TFloat
             , Comment TVarChar
             , PersonalServiceListId Integer, PersonalServiceListName TVarChar
             , UnitId Integer, UnitName TVarChar
             , PersonalGroupId Integer, PersonalGroupName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PersonalGroupSummAdd());
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!Проверка прав роль - Ограничение просмотра данных ЗП!!!
     PERFORM lpCheck_UserRole_8813637 (vbUserId);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- Результат
     RETURN QUERY
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         )
         , tmpUserAll AS (SELECT UserId FROM Constant_User_LevelMax01_View WHERE UserId = vbUserId /*AND UserId <> 9464*/) -- Документы-меню (управленцы) AND <> Рудик Н.В. + ЗП просмотр ВСЕ 
         , tmpMemberPersonalServiceList
                      AS (SELECT Object_PersonalServiceList.Id AS PersonalServiceListId
                          FROM ObjectLink AS ObjectLink_User_Member
                               INNER JOIN ObjectLink AS ObjectLink_MemberPersonalServiceList
                                                     ON ObjectLink_MemberPersonalServiceList.ChildObjectId = ObjectLink_User_Member.ChildObjectId
                                                    AND ObjectLink_MemberPersonalServiceList.DescId        = zc_ObjectLink_MemberPersonalServiceList_Member()
                               INNER JOIN Object AS Object_MemberPersonalServiceList
                                                 ON Object_MemberPersonalServiceList.Id       = ObjectLink_MemberPersonalServiceList.ObjectId
                                                AND Object_MemberPersonalServiceList.isErased = FALSE
                               LEFT JOIN ObjectBoolean ON ObjectBoolean.ObjectId = ObjectLink_MemberPersonalServiceList.ObjectId
                                                      AND ObjectBoolean.DescId   = zc_ObjectBoolean_MemberPersonalServiceList_All()
                               LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList
                                                    ON ObjectLink_PersonalServiceList.ObjectId = ObjectLink_MemberPersonalServiceList.ObjectId
                                                   AND ObjectLink_PersonalServiceList.DescId   = zc_ObjectLink_MemberPersonalServiceList_PersonalServiceList()
                               LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
                                                                             AND (Object_PersonalServiceList.Id    = ObjectLink_PersonalServiceList.ChildObjectId
                                                                               OR ObjectBoolean.ValueData          = TRUE)
                          WHERE ObjectLink_User_Member.ObjectId = vbUserId
                            AND ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()
                         UNION
                          SELECT Object_PersonalServiceList.Id AS PersonalServiceListId
                          FROM ObjectLink AS ObjectLink_User_Member
                               INNER JOIN ObjectLink AS ObjectLink_PersonalServiceList_Member
                                                     ON ObjectLink_PersonalServiceList_Member.ChildObjectId = ObjectLink_User_Member.ChildObjectId
                                                    AND ObjectLink_PersonalServiceList_Member.DescId        = zc_ObjectLink_PersonalServiceList_Member()
                               LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
                                                                             AND Object_PersonalServiceList.Id     = ObjectLink_PersonalServiceList_Member.ObjectId
                          WHERE ObjectLink_User_Member.ObjectId = vbUserId
                            AND ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()
                         UNION
                          -- Админ и другие видят ВСЕХ
                          SELECT Object_PersonalServiceList.Id AS PersonalServiceListId
                          FROM Object AS Object_PersonalServiceList
                          WHERE Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
                            AND EXISTS (SELECT 1 FROM tmpUserAll)
                         UNION
                          -- Админ и другие видят ВСЕХ
                          SELECT Object_PersonalServiceList.Id AS PersonalServiceListId
                          FROM Object AS Object_PersonalServiceList
                          WHERE Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
                            AND EXISTS (SELECT 1 FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND AccessKeyId_PersonalService = zc_Enum_Process_AccessKey_PersonalServiceAdmin())
                         )
       -- 
       SELECT Movement.Id                        AS Id
            , Movement.InvNumber                 AS InvNumber
            , Movement.OperDate                  AS OperDate
            , Object_Status.ObjectCode           AS StatusCode
            , Object_Status.ValueData            AS StatusName
            , MovementFloat_NormHour.ValueData   AS NormHour
            , MovementFloat_TotalSumm.ValueData  AS TotalSumm 
            
            , MovementString_Comment.ValueData   AS Comment

            , Object_PersonalServiceList.Id        AS PersonalServiceListId
            , Object_PersonalServiceList.ValueData AS PersonalServiceListName

            , Object_Unit.Id                       AS UnitId
            , Object_Unit.ValueData                AS UnitName

            , Object_PersonalGroup.Id              AS PersonalGroupId
            , Object_PersonalGroup.ValueData       AS PersonalGroupName
       FROM tmpStatus
            INNER JOIN Movement ON Movement.DescId = zc_Movement_PersonalGroupSummAdd()
                               AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                               AND Movement.StatusId = tmpStatus.StatusId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_NormHour
                                    ON MovementFloat_NormHour.MovementId =  Movement.Id
                                   AND MovementFloat_NormHour.DescId = zc_MovementFloat_NormHour()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            
            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                         ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
            LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = MovementLinkObject_PersonalServiceList.ObjectId
            --INNER JOIN tmpMemberPersonalServiceList ON tmpMemberPersonalServiceList.PersonalServiceListId = MovementLinkObject_PersonalServiceList.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalGroup
                                         ON MovementLinkObject_PersonalGroup.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalGroup.DescId = zc_MovementLinkObject_PersonalGroup()
            LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = MovementLinkObject_PersonalGroup.ObjectId

       ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.02.24         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_PersonalGroupSummAdd (inStartDate:= '30.01.2013', inEndDate:= '01.02.2013',inJuridicalBasisId:=0,  inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
