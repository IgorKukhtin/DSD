-- Function: gpSelect_Movement_ServiceItemAddChoice()

DROP FUNCTION IF EXISTS gpSelect_Movement_ServiceItemAddChoice (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ServiceItemAddChoice(
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
             , NumYearStart Integer            --год старт
             , NumYearEnd  Integer            --год енд
             , MonthNameStart  TVarChar
             , MonthNameEnd TVarChar
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
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         )     
          , tmpMI AS (SELECT *
                      FROM Movement_ServiceItemAdd_View AS Movement
                           INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId
                      WHERE Movement.OperDate Between inStartDate AND inEndDate
                        AND (Movement.isErased = False OR inIsErased = TRUE)
                      )
           --предыдущее значение дополнения  для всех отделов
          , tmp_last AS (SELECT tmp.*
                         FROM (SELECT tmp_View.*
                                    , ROW_NUMBER() OVER (PARTITION BY tmp_View.UnitId, tmp_View.InfoMoneyId ORDER BY tmp_View.DateEnd DESC) AS ord
                               FROM tmpMI
                                   INNER JOIN Movement_ServiceItemAdd_View AS tmp_View
                                                                           ON tmp_View.DateEnd <= tmpMI.OperDate
                                                                          AND tmp_View.isErased = FALSE
                                                                          AND tmp_View.Id <> tmpMI.Id
                                                                          AND tmp_View.UnitId = tmpMI.UnitId
                                                                          AND tmp_View.InfoMoneyId = tmpMI.InfoMoneyId
                               ) AS tmp
                         --WHERE tmp.Ord = 1
                         )
   
          , tmpMI_Main AS (SELECT MovementItem.UnitId
                                , MovementItem.InfoMoneyId
                                , MovementItem.CommentInfoMoneyId
                                , MovementItem.Amount 
                                , MovementItem.Price
                                , MovementItem.Area
                                , MovementItem.DateStart
                                , MovementItem.DateEnd
                            FROM Movement
                                 INNER JOIN gpSelect_MovementItem_ServiceItem(Movement.Id, FALSE, FALSE, inSession) AS MovementItem
                                                                                                                    ON MovementItem.MovementId = Movement.Id
                            WHERE Movement.DescId = zc_Movement_ServiceItem() 
                              AND Movement.StatusId = zc_Enum_Status_Complete()
                            )
                               
       SELECT
             Movement.Id
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
           , EXTRACT (Year FROM Movement.DateStart)  ::Integer  AS NumYearStart            --год старт
           , EXTRACT (Year FROM Movement.DateEnd)    ::Integer  AS NumYearEnd              --год енд
           , zfCalc_MonthName (Movement.DateStart)   ::TVarChar AS MonthNameStart
           , zfCalc_MonthName (Movement.DateEnd)     ::TVarChar AS MonthNameEnd   
                
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
            LEFT JOIN tmpMI_Main ON tmpMI_Main.UnitId = Movement.UnitId
                                AND tmpMI_Main.InfoMoneyId = Movement.InfoMoneyId
                                AND tmpMI_Main.DateStart <= Movement.DateStart
                                AND tmpMI_Main.DateEnd   >= Movement.DateStart

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
-- SELECT * FROM gpSelect_Movement_ServiceItemAddChoice (inStartDate:= '30.01.2015', inEndDate:= '01.01.2023', inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
