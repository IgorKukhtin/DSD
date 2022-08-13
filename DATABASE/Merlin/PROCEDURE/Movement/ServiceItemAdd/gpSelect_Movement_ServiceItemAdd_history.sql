-- Function: gpSelect_Movement_ServiceItemAdd_history()

DROP FUNCTION IF EXISTS gpSelect_Movement_ServiceItemAdd_history (TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ServiceItemAdd_history(
    IN inStartDate         TDateTime , --
    IN inUnitId            Integer , --
    IN inInfoMoneyId       Integer ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer
             , OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime 
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
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         --UNION
                         -- SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
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
           , Movement.DateStart   :: TDateTime    AS MonthNameStart
           , Movement.DateEnd     :: TDateTime    AS MonthNameEnd   
                
           , Movement.Amount               :: TFloat   
           , Movement.Comment
       FROM Movement_ServiceItemAdd_View AS Movement
            INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId
       WHERE Movement.UnitId = inUnitId
         AND Movement.InfoMoneyId = inInfoMoneyId
         AND Movement.isErased = FALSE
       --AND Movement.OperDate BETWEEN inStartDate AND inEndDate
         
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
-- SELECT * FROM gpSelect_Movement_ServiceItemAdd_history (inStartDate:= '30.01.2015', inUnitId:= 0, inInfoMoneyId:= 0, inSession:= zfCalc_UserAdmin())
