-- Function: gpSelect_Movement_ServiceItem()

DROP FUNCTION IF EXISTS gpSelect_Movement_ServiceItem (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ServiceItem(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsErased          Boolean ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, DescId Integer, InvNumber Integer
             , OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime 
             --, isAdd Boolean
             --
             , MovementItemId Integer
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , UnitGroupNameFull TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , CommentInfoMoneyId Integer, CommentInfoMoneyCode Integer, CommentInfoMoneyName TVarChar
             
             , DateStart TDateTime, DateEnd TDateTime
             , Amount TFloat, Price TFloat, Area TFloat
             
             , Amount_before TFloat, Price_before TFloat, Area_before TFloat
             , Amount_after TFloat, Price_after TFloat, Area_after TFloat
              )
AS
$BODY$
   DECLARE vbUserId   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ServiceItem());
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
                               JOIN Movement ON Movement.DescId IN (zc_Movement_ServiceItem())        --, zc_Movement_ServiceItemAdd()
                                            AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                            AND Movement.StatusId = tmpStatus.StatusId
                           )

       SELECT
             Movement.Id
           , Movement.DescId
           , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode             AS StatusCode
           , Object_Status.ValueData              AS StatusName
           , Object_Insert.ValueData              AS InsertName
           , MovementDate_Insert.ValueData        AS InsertDate
           , Object_Update.ValueData              AS UpdateName
           , MovementDate_Update.ValueData        AS UpdateDate
           --, CASE WHEN Movement.DescId = zc_Movement_ServiceItemAdd() THEN TRUE ELSE FALSE END :: Boolean AS isAdd
            --
           , tmpMI.Id                      AS MovementItemId
           , tmpMI.UnitId
           , tmpMI.UnitCode
           , tmpMI.UnitName
           , tmpMI.UnitGroupNameFull
           
           , tmpMI.InfoMoneyId
           , tmpMI.InfoMoneyCode
           , tmpMI.InfoMoneyName

           , tmpMI.CommentInfoMoneyId
           , tmpMI.CommentInfoMoneyCode
           , tmpMI.CommentInfoMoneyName

           , tmpMI.DateStart :: TDateTime AS DateStart
           , tmpMI.DateEnd              :: TDateTime AS DateEnd
           , tmpMI.Amount               :: TFloat    AS Amount
           , tmpMI.Price                :: TFloat    AS Price
           , tmpMI.Area                 :: TFloat    AS Area   

           , tmpMI.Amount_before        :: TFloat    AS Amount_before
           , tmpMI.Price_before         :: TFloat    AS Price_before
           , tmpMI.Area_before          :: TFloat    AS Area_before

           , tmpMI.Amount_after         :: TFloat    AS Amount_after
           , tmpMI.Price_after          :: TFloat    AS Price_after
           , tmpMI.Area_after           :: TFloat    AS Area_after

       FROM tmpMovement AS Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

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
            
            LEFT JOIN gpSelect_MovementItem_ServiceItem(Movement.Id, FALSE, FALSE, inSession) AS tmpMI ON tmpMI.MovementId = Movement.Id 
       ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.05.22         *
 */

-- тест
-- SELECT * FROM gpSelect_Movement_ServiceItem (inStartDate:= '30.01.2015', inEndDate:= '01.01.2015', inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
