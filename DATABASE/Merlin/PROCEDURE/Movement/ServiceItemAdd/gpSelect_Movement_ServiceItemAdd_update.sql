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
             , UnitId Integer, UnitCode Integer, UnitName TVarChar, UnitName_Full TVarChar
             , UnitGroupNameFull TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , CommentInfoMoneyId Integer, CommentInfoMoneyCode Integer, CommentInfoMoneyName TVarChar
             , DateStart TDateTime, DateEnd TDateTime
             , MonthNameStart  TDateTime
             , MonthNameEnd TDateTime
             , Month_diff Integer
             , Amount TFloat
             , Comment TVarChar

             , DateStart_Main TDateTime, DateEnd_Main TDateTime, Month_diff_Main Integer
             , Amount_Main TFloat, Price_Main TFloat, Area_Main TFloat
             , MonthNameStart_before  TDateTime
             , MonthNameEnd_before TDateTime
             , Month_diff_before Integer
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
           , TRIM (COALESCE (Movement.UnitGroupNameFull,'')||' '|| Movement.UnitName) ::TVarChar AS UnitName_Full
           , Movement.UnitGroupNameFull

           , Movement.InfoMoneyId
           , Movement.InfoMoneyCode
           , Movement.InfoMoneyName

           , Movement.CommentInfoMoneyId
           , Movement.CommentInfoMoneyCode
           , Movement.CommentInfoMoneyName

           , Movement.DateStart         :: TDateTime AS DateStart
           , Movement.DateEnd           :: TDateTime AS DateEnd
           , zfCalc_Month_start (Movement.DateStart) AS MonthNameStart
           , zfCalc_Month_end (Movement.DateEnd)     AS MonthNameEnd
           , zfCalc_Month_diff (Movement.DateStart, Movement.DateEnd) :: Integer AS Month_diff

           , Movement.Amount               :: TFloat
           , Movement.Comment

           , zfCalc_Month_start (tmpMI_Main.DateStart) AS DateStart_Main
           , zfCalc_Month_end (tmpMI_Main.DateEnd)     AS DateEnd_Main
           , zfCalc_Month_diff (tmpMI_Main.DateStart, tmpMI_Main.DateEnd) :: Integer AS Month_diff_Main
           , tmpMI_Main.Amount               :: TFloat AS Amount_Main
           , tmpMI_Main.Price                :: TFloat AS Price_Main
           , tmpMI_Main.Area                 :: TFloat AS Area_Main
                                                       
           , zfCalc_Month_start (tmp_last.DateStart)   AS MonthNameStart_before
           , zfCalc_Month_end (tmp_last.DateEnd)       AS MonthNameEnd_before
           , zfCalc_Month_diff (tmp_last.DateStart, tmp_last.DateEnd) :: Integer AS Month_diff_before
           , tmp_last.Amount                 :: TFloat AS Amount_before

       FROM tmpMI AS Movement
            -- Базовые условия - на дату
            LEFT JOIN gpSelect_MovementItem_ServiceItem_onDate (inOperDate   := Movement.DateStart
                                                              , inUnitId     := Movement.UnitId
                                                              , inInfoMoneyId:= Movement.InfoMoneyId
                                                              , inSession    := inSession
                                                               ) AS tmpMI_Main
                                                                 ON Movement.DateStart BETWEEN COALESCE (tmpMI_Main.DateStart, zc_DateStart()) AND tmpMI_Main.DateEnd
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
