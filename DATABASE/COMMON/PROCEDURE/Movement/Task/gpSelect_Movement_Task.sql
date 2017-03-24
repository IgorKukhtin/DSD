-- Function: gpSelect_Movement_Task()

DROP FUNCTION IF EXISTS gpSelect_Movement_Task (TDateTime, TDateTime, Boolean, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Task(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inIsErased           Boolean   ,
    IN inMemberId           Integer   ,
    IN inJuridicalBasisId   Integer   ,
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , BranchName TVarChar, UnitName TVarChar, PositionName TVarChar
             , PersonalTradeId Integer, PersonalTradeCode Integer, PersonalTradeName TVarChar
             , InsertId Integer, InsertCode Integer, InsertName TVarChar
             , InsertDate TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbMemberId Integer;
   DECLARE vbPersonalId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Task());
     vbUserId:= lpGetUserBySession (inSession);


     SELECT tmp.MemberId, tmp.PersonalId
     INTO vbMemberId, vbPersonalId     
     FROM gpGetMobile_Object_Const (inSession) AS tmp;

     IF (COALESCE(inMemberId,0) <> 0 AND COALESCE(vbMemberId,0) <> inMemberId)
        THEN
            RAISE EXCEPTION 'Ошибка.Не достаточно прав доступа.'; 
     END IF;


     -- Результат
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

        , tmpMovement AS (SELECT tmp.Id, MovementLinkObject_From.ObjectId  AS FromId
                          FROM
                             (SELECT Movement.id
                              FROM tmpStatus
                                   JOIN Movement ON Movement.StatusId = tmpStatus.StatusId
                                                AND Movement.DescId = zc_Movement_Task()
                                                AND Movement.OperDate BETWEEN inStartDate AND inEndDate  
                              ) AS tmp
                               /* INNER JOIN MovementLinkObject AS MovementLinkObject_Personal
                                       ON MovementLinkObject_Personal.MovementId = tmp.Id
                                      AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
                                      AND (MovementLinkObject_Personal.ObjectId = inMemberId OR inMemberId = 0)*/
                          )

       SELECT
             Movement.Id                               AS Id
           , Movement.InvNumber                        AS InvNumber
           , Movement.OperDate                         AS OperDate
           , Object_Status.ObjectCode                  AS StatusCode
           , Object_Status.ValueData                   AS StatusName
           , 'филиал'        ::TVarChar     AS BranchName
           , 'Подразделение' ::TVarChar     AS UnitName
           , 'Должность'     ::TVarChar     AS PositionName
           , Object_PersonalTrade.Id                   AS PersonalTradeId
           , Object_PersonalTrade.ObjectCode           AS PersonalTradeCode
           , Object_PersonalTrade.ValueData            AS PersonalTradeName
           , Object_Insert.Id                          AS InsertId
           , Object_Insert.ObjectCode                  AS InsertCode
           , Object_Insert.ValueData                   AS InsertName
           , MovementDate_Insert.ValueData             AS InsertDate
           , MovementString_Comment.ValueData          AS Comment

       FROM tmpMovement
            LEFT JOIN Movement ON Movement.id = tmpMovement.id
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementBoolean AS MovementBoolean_Closed
                                      ON MovementBoolean_Closed.MovementId = Movement.Id
                                     AND MovementBoolean_Closed.DescId = zc_MovementBoolean_Closed()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalTrade
                                         ON MovementLinkObject_PersonalTrade.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalTrade.DescId = zc_MovementLinkObject_PersonalTrade()
            LEFT JOIN Object AS Object_PersonalTrade ON Object_PersonalTrade.Id = MovementLinkObject_PersonalTrade.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                         ON MovementLinkObject_Insert.MovementId = Movement.Id
                                        AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.InsertId = MovementLinkObject_Insert.ObjectId
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 24.03.17         *
*/

-- тест
-- SELECT * PersonalTrade gpSelect_Movement_Task (inStartDate:= '01.12.2015', inEndDate:= '01.12.2015', inIsPartnerDate:=FALSE, inIsErased :=TRUE, inJuridicalBasisId:= 0, inSession:= zfCalc_UserAdmin())
