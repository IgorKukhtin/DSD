-- Function: gpSelect_Movement_Service()

DROP FUNCTION IF EXISTS gpSelect_Movement_Service (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Service (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Service(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , -- 
    IN inInfoMoneyId       Integer ,
    IN inIsErased          Boolean ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer
             , OperDate TDateTime
             , ServiceDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , Amount TFloat
             , UnitId Integer, UnitCode Integer, UnitName TVarChar, UnitName_Full TVarChar
             , UnitGroupNameFull TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , CommentInfoMoneyId Integer, CommentInfoMoneyCode Integer, CommentInfoMoneyName TVarChar       
             , isAuto Boolean
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
              )
AS
$BODY$
   DECLARE vbUserId   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Service());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         )
         , tmpMovement AS (SELECT Movement.*
                           FROM tmpStatus
                               JOIN Movement ON Movement.DescId = zc_Movement_Service()
                                            AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                            AND Movement.StatusId = tmpStatus.StatusId
                           )

         , tmpMI AS (SELECT MovementItem.*
                          , MILinkObject_InfoMoney.ObjectId AS InfoMoneyId
                     FROM MovementItem 
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                           ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()             
                     WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                       AND MovementItem.DescId = zc_MI_Master()
                       AND (COALESCE (inInfoMoneyId,0) = 0 OR MILinkObject_InfoMoney.ObjectId = inInfoMoneyId)
                     )


       SELECT
             Movement.Id
           , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
           , Movement.OperDate
           , DATE_TRUNC ('Month', MIDate_ServiceDate.ValueData) ::TDateTime AS ServiceDate
           , Object_Status.ObjectCode           AS StatusCode
           , Object_Status.ValueData            AS StatusName
           , MovementItem.Amount  ::TFloat      AS Amount
           , Object_Unit.Id                     AS UnitId
           , Object_Unit.ObjectCode             AS UnitCode
           , Object_Unit.ValueData              AS UnitName
           , TRIM (COALESCE (ObjectString_Unit_GroupNameFull.ValueData,'')||' '||Object_Unit.ValueData) ::TVarChar AS UnitName_Full
           , ObjectString_Unit_GroupNameFull.ValueData AS UnitGroupNameFull
           , Object_InfoMoney.Id                AS InfoMoneyId
           , Object_InfoMoney.ObjectCode        AS InfoMoneyCode
           , Object_InfoMoney.ValueData         AS InfoMoneyName
           , Object_CommentInfoMoney.Id         AS CommentInfoMoneyId
           , Object_CommentInfoMoney.ObjectCode AS CommentInfoMoneyCode
           , Object_CommentInfoMoney.ValueData  AS CommentInfoMoneyName

           , COALESCE (MovementBoolean_isAuto.ValueData, FALSE) ::Boolean AS isAuto
           , Object_Insert.ValueData              AS InsertName
           , MovementDate_Insert.ValueData        AS InsertDate
           , Object_Update.ValueData              AS UpdateName
           , MovementDate_Update.ValueData        AS UpdateDate

       FROM tmpMovement AS Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                      ON MovementBoolean_isAuto.MovementId = Movement.Id
                                     AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
            --
            LEFT JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementItem.ObjectId
            LEFT JOIN ObjectString AS ObjectString_Unit_GroupNameFull
                                   ON ObjectString_Unit_GroupNameFull.ObjectId = Object_Unit.Id
                                  AND ObjectString_Unit_GroupNameFull.DescId   = zc_ObjectString_Unit_GroupNameFull()
            
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = MovementItem.InfoMoneyId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentInfoMoney
                                             ON MILinkObject_CommentInfoMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_CommentInfoMoney.DescId         = zc_MILinkObject_CommentInfoMoney()
            LEFT JOIN Object AS Object_CommentInfoMoney ON Object_CommentInfoMoney.Id = MILinkObject_CommentInfoMoney.ObjectId

            LEFT JOIN MovementItemDate AS MIDate_ServiceDate
                                       ON MIDate_ServiceDate.MovementItemId = MovementItem.Id
                                      AND MIDate_ServiceDate.DescId = zc_MIDate_ServiceDate()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()
            LEFT JOIN MovementLinkObject AS MLO_Update
                                         ON MLO_Update.MovementId = Movement.Id
                                        AND MLO_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId
       ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.01.22         *
 */

-- тест
--SELECT * FROM gpSelect_Movement_Service (inStartDate:= '30.01.2015', inEndDate:= '01.01.2015', inInfoMoneyId:= 0, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
