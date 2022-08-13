-- Function: gpSelect_Movement_ServiceItemAdd_update()

DROP FUNCTION IF EXISTS gpSelect_Movement_ServiceItemAddChoice (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_ServiceItemAdd_update (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ServiceItemAdd_update(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsErased          Boolean ,
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
             , MonthNameEnd TDateTime
             , Amount TFloat
             , Comment TVarChar

             , DateStart_Main TDateTime, DateEnd_Main TDateTime
             , Amount_Main TFloat, Price_Main TFloat, Area_Main TFloat
             , MonthNameStart_before  TDateTime
             , MonthNameEnd_before TDateTime
             , Amount_before TFloat
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
            -- дополнения за период
          , tmpMI AS (SELECT Movement.*
                      FROM Movement_ServiceItemAdd_View AS Movement
                           INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId
                      WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                        AND (Movement.isErased = FALSE OR inIsErased = TRUE)
                     )
            -- поиск предыдущего дополнения
          , tmp_last AS (SELECT tmp.*
                         FROM (SELECT tmp_View.*
                                    , ROW_NUMBER() OVER (PARTITION BY tmp_View.UnitId, tmp_View.InfoMoneyId ORDER BY tmp_View.OperDate DESC, tmp_View.MovementId DESC) AS ord
                               FROM tmpMI
                                    INNER JOIN Movement_ServiceItemAdd_View AS tmp_View
                                                                            ON tmp_View.UnitId      = tmpMI.UnitId
                                                                           AND tmp_View.InfoMoneyId = tmpMI.InfoMoneyId
                                                                           AND tmp_View.isErased    = FALSE
                                                                           AND tmpMI.DateStart BETWEEN tmp_View.DateStart AND tmp_View.DateEnd
                                                                           AND tmp_View.OperDate    < tmpMI.OperDate
                               ) AS tmp
                         WHERE tmp.Ord = 1
                        )
       -- Результат
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

           , Movement.DateStart            :: TDateTime
           , Movement.DateEnd              :: TDateTime
           , Movement.DateStart            :: TDateTime AS MonthNameStart
           , Movement.DateEnd              :: TDateTime AS MonthNameEnd

           , Movement.Amount               :: TFloat
           , Movement.Comment

           , tmpMI_Main.DateStart       :: TDateTime AS DateStart_Main
           , tmpMI_Main.DateEnd         :: TDateTime AS DateEnd_Main
           , tmpMI_Main.Amount          :: TFloat    AS Amount_Main
           , tmpMI_Main.Price           :: TFloat    AS Price_Main
           , tmpMI_Main.Area            :: TFloat    AS Area_Main

           , tmp_last.DateStart       :: TDateTime AS MonthNameStart_before
           , tmp_last.DateEnd         :: TDateTime AS MonthNameEnd_before
           , tmp_last.Amount          :: TFloat    AS Amount_before

       FROM tmpMI AS Movement
            -- Базовые условия - на дату
            LEFT JOIN gpSelect_MovementItem_ServiceItem_onDate (inOperDate   := Movement.DateStart
                                                              , inUnitId     := Movement.UnitId
                                                              , inInfoMoneyId:= Movement.InfoMoneyId
                                                              , inSession    := inSession
                                                               ) AS tmpMI_Main
                                                                 ON Movement.DateStart BETWEEN tmpMI_Main.DateStart AND tmpMI_Main.DateEnd
                                                                AND tmpMI_Main.Amount > 0

            LEFT JOIN tmp_last ON tmp_last.UnitId = Movement.UnitId
                              AND tmp_last.InfoMoneyId = Movement.InfoMoneyId
                              AND tmp_last.DateStart <= Movement.OperDate
                              AND tmp_last.DateEnd   >= Movement.OperDate
       ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.08.22         *
 */

-- тест
-- SELECT * FROM gpSelect_Movement_ServiceItemAdd_update (inStartDate:= '30.01.2015', inEndDate:= '01.01.2023', inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
