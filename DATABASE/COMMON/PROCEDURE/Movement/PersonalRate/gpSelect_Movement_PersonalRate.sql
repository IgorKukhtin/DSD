-- Function: gpSelect_Movement_PersonalRate()

DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalRate (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PersonalRate(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inJuridicalBasisId  Integer   , -- гл. юр.лицо
    IN inIsErased          Boolean   ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , TotalSumm TFloat
             , Comment TVarChar
             , PersonalServiceListId Integer, PersonalServiceListName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PersonalRate());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         )
          , tmpRoleAccessKey AS (SELECT AccessKeyId 
                                 FROM Object_RoleAccessKey_View
                                 WHERE UserId = vbUserId 
                                 GROUP BY AccessKeyId
                                 )
       
 
       SELECT Movement.Id                        AS Id
            , Movement.InvNumber                 AS InvNumber
            , Movement.OperDate                  AS OperDate
            , Object_Status.ObjectCode           AS StatusCode
            , Object_Status.ValueData            AS StatusName
            , MovementFloat_TotalSumm.ValueData  AS TotalSumm
            , MovementString_Comment.ValueData   AS Comment
            , Object_PersonalServiceList.Id        AS PersonalServiceListId
            , Object_PersonalServiceList.ValueData AS PersonalServiceListName

       FROM tmpStatus
            INNER JOIN Movement ON Movement.DescId = zc_Movement_PersonalRate()
                               AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                               AND Movement.StatusId = tmpStatus.StatusId
 
            ---INNER JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

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
 ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.09.19         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_PersonalRate (inStartDate:= '30.01.2013', inEndDate:= '01.02.2013',inJuridicalBasisId:=0,  inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
