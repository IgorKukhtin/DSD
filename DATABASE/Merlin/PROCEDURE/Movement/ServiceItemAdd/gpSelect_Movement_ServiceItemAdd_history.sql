-- Function: gpSelect_Movement_ServiceItemAdd_history()

DROP FUNCTION IF EXISTS gpSelect_Movement_ServiceItemAdd_history (TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_ServiceItemAdd_history (TDateTime, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_ServiceItemAdd_history (TDateTime, Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ServiceItemAdd_history(
    IN inStartDate         TDateTime , --
    IN inUnitId            Integer , --
    IN inInfoMoneyId       Integer ,
    IN inIsErased          Boolean ,
    IN inIsAll             Boolean ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer
             , OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             , InsertName_mi TVarChar, InsertDate_mi TDateTime
             , UpdateName_mi TVarChar, UpdateDate_mi TDateTime
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , UnitGroupNameFull TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , CommentInfoMoneyId Integer, CommentInfoMoneyCode Integer, CommentInfoMoneyName TVarChar
             , DateStart TDateTime, DateEnd TDateTime  
             , MonthNameStart  TDateTime
             , MonthNameEnd    TDateTime
             , Amount TFloat 
             , Comment TVarChar
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
                          SELECT zc_Enum_Status_UnComplete() AS StatusId WHERE inIsErased = TRUE
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         )
       SELECT
             Movement.MovementId AS Id
           , Movement.InvNumber
           , Movement.OperDate
           , Movement.StatusCode
           , Movement.StatusName
           , Movement.InsertName
           , Movement.InsertDate
           , Movement.UpdateName
           , Movement.UpdateDate
           , Object_Insert.ValueData    AS InsertName_mi
           , MIDate_Insert.ValueData    AS InsertDate_mi
           , Object_Update.ValueData    AS UpdateName_mi
           , MIDate_Update.ValueData    AS UpdateDate_mi
           , Movement.UnitId
           , Movement.UnitCode
           , Movement.UnitName
           , Movement.UnitGroupNameFull
           
           , Movement.InfoMoneyId
           , Movement.InfoMoneyCode
           , Movement.InfoMoneyName
 
           , Movement.CommentInfoMoneyId
           , Movement.CommentInfoMoneyCode
           , Movement.CommentInfoMoneyName
 
           , Movement.DateStart   :: TDateTime
           , Movement.DateEnd     :: TDateTime   
           , zfCalc_Month_start (Movement.DateStart) AS MonthNameStart
           , zfCalc_Month_end (Movement.DateEnd)     AS MonthNameEnd   
                
           , Movement.Amount               :: TFloat   
           , Movement.Comment
       FROM Movement_ServiceItemAdd_View AS Movement
            INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId

            LEFT JOIN MovementItemDate AS MIDate_Insert
                                       ON MIDate_Insert.MovementItemId = Movement.MovementItemId
                                      AND MIDate_Insert.DescId = zc_MIDate_Insert()
            LEFT JOIN MovementItemDate AS MIDate_Update
                                       ON MIDate_Update.MovementItemId = Movement.MovementItemId
                                      AND MIDate_Update.DescId = zc_MIDate_Update()

            LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                             ON MILO_Insert.MovementItemId = Movement.MovementItemId
                                            AND MILO_Insert.DescId = zc_MILinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILO_Update
                                             ON MILO_Update.MovementItemId = Movement.MovementItemId
                                            AND MILO_Update.DescId = zc_MILinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MILO_Update.ObjectId

       WHERE Movement.UnitId = inUnitId
         AND (Movement.InfoMoneyId = inInfoMoneyId OR inInfoMoneyId = 0)
         AND Movement.isErased = FALSE
         AND ((inStartDate BETWEEN Movement.DateStart AND Movement.DateEnd) OR inIsAll = TRUE)
         
       ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.08.22         *
 */

-- тест
-- SELECT * FROM gpSelect_Movement_ServiceItemAdd_history (inStartDate:= '30.01.2015', inUnitId:= 0, inInfoMoneyId:= 0, inIsErased:= FALSE, inIsAll:= FALSE, inSession:= zfCalc_UserAdmin())
