DROP FUNCTION IF EXISTS gpInsert_Movement_Service_byServiceItem (TDateTime, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_Movement_Service_byServiceItem (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Service_byServiceItem(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inSession           TVarChar    --  сессия пользователя
)
RETURNS VOID
AS
$BODY$
BEGIN

     -- таблица - документы начисления
     CREATE TEMP TABLE _tmpMovement_Service (OperDate TDateTime, UnitId Integer, InfoMoneyId Integer, CommentInfoMoneyId Integer, Amount TFloat, MovementId_service Integer) ON COMMIT DROP;

     -- документы начисления
     INSERT INTO _tmpMovement_Service (OperDate, UnitId, InfoMoneyId, CommentInfoMoneyId, Amount, MovementId_service)
           WITH -- ServiceItem за период
                tmpServiceItem AS (SELECT tmp.DateStart AS StartDate
                                        , tmp.DateEnd   AS EndDate
                                        , tmp.UnitId
                                        , tmp.InfoMoneyId
                                        , tmp.CommentInfoMoneyId
                                        , tmp.Amount
                                   FROM  gpSelect_Movement_ServiceItem(inStartDate := inStartDate
                                                                     , inEndDate   := inEndDate
                                                                     , inIsErased  := FALSE
                                                                     , inSession   := inSession) AS tmp
                                   WHERE tmp.StatusId = zc_Enum_Status_Complete()
                                  )
         -- список по месяцам
       , tmpListDate AS (SELECT GENERATE_SERIES (inStartDate
                                               , inEndDate
                                               , '1 MONTH' :: INTERVAL
                                                ) AS OperDate
                        )
                        /*(SELECT GENERATE_SERIES ((SELECT MIN (tmpServiceItemAdd.StartDate) FROM tmpServiceItemAdd)
                                               , (SELECT MAX (tmpServiceItemAdd.EndDate)   FROM tmpServiceItemAdd)
                                               , '1 MONTH' :: INTERVAL
                                                ) AS OperDate
                        )*/
        -- находим существующие Начисления
      , tmpMovement_Service AS (SELECT Movement.Id                     AS MovementId
                                     , Movement.OperDate               AS OperDate
                                     , MovementItem.ObjectId           AS UnitId
                                     , MILinkObject_InfoMoney.ObjectId AS InfoMoneyId
                                FROM Movement
                                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                            AND MovementItem.DescId     = zc_MI_Master()
                                                            AND MovementItem.isErased   = FALSE
                                     LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                      ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_InfoMoney.DescId         = zc_MILinkObject_InfoMoney()
                                     INNER JOIN tmpListDate ON tmpListDate.OperDate = Movement.OperDate
                                     INNER JOIN tmpServiceItem ON tmpServiceItem.UnitId      = MovementItem.ObjectId
                                                              AND tmpServiceItem.InfoMoneyId = MILinkObject_InfoMoney.ObjectId
                                                              AND tmpListDate.OperDate BETWEEN tmpServiceItem.StartDate AND tmpServiceItem.EndDate
                                WHERE Movement.DescId   = zc_Movement_Service()
                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                                  AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                               )

           -- Список Начислений
           SELECT tmpListDate.OperDate
                , tmpServiceItem.UnitId
                , tmpServiceItem.InfoMoneyId
                , tmpServiceItem.CommentInfoMoneyId
                , tmpServiceItem.Amount
                , COALESCE (tmpMovement_Service.MovementId, 0) AS MovementId_service
           FROM tmpListDate
                INNER JOIN tmpServiceItem ON tmpListDate.OperDate BETWEEN tmpServiceItem.StartDate AND tmpServiceItem.EndDate
                LEFT JOIN tmpMovement_Service ON tmpMovement_Service.OperDate    = tmpListDate.OperDate
                                             AND tmpMovement_Service.UnitId      = tmpServiceItem.UnitId
                                             AND tmpMovement_Service.InfoMoneyId = tmpServiceItem.InfoMoneyId
           ORDER BY tmpListDate.OperDate;


     -- Заливаем данные в начисления
     PERFORM gpInsertUpdate_Movement_Service (ioId                := COALESCE (tmpMovement.MovementId_service,0)
                                            , inInvNumber         := CASE WHEN COALESCE (tmpMovement.MovementId_service,0) = 0 THEN  CAST (NEXTVAL ('movement_service_seq') AS TVarChar)  ELSE tmpMovement.InvNumber_service END
                                            , inOperDate          := tmpMovement.OperDate
                                            , inServiceDate       := tmpMovement.OperDate
                                            , inAmount            := tmpMovement.Amount
                                            , inUnitId            := tmpMovement.UnitId
                                            , inParent_InfoMoneyId:= tmpMovement.ParentId_InfoMoney
                                            , inInfoMoneyName     := tmpMovement.InfoMoneyName
                                            , inCommentInfoMoney  := tmpMovement.CommentInfoMoney
                                            , inSession           := inSession :: TVarChar
                                             ) AS MovementId
     FROM (
           -- Список Начислений
           SELECT _tmpMovement_Service.MovementId_service
                , _tmpMovement_Service.OperDate
                , _tmpMovement_Service.UnitId
                , _tmpMovement_Service.Amount
                , Object_InfoMoney.ValueData        AS InfoMoneyName
                , Object_CommentInfoMoney.ValueData AS CommentInfoMoney
                , ObjectLink_Parent.ChildObjectId   AS ParentId_InfoMoney
                , Movement.InvNumber                AS InvNumber_service
           FROM _tmpMovement_Service
                LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = _tmpMovement_Service.InfoMoneyId
                LEFT JOIN ObjectLink AS ObjectLink_Parent
                                     ON ObjectLink_Parent.ObjectId = Object_InfoMoney.Id
                                    AND ObjectLink_Parent.DescId   = zc_ObjectLink_InfoMoney_Parent()
                LEFT JOIN Object AS Object_CommentInfoMoney ON Object_CommentInfoMoney.Id = _tmpMovement_Service.CommentInfoMoneyId
                LEFT JOIN Movement ON Movement.Id = _tmpMovement_Service.MovementId_service
           WHERE COALESCE (_tmpMovement_Service.MovementId_service,0) <> 0
              OR (COALESCE (_tmpMovement_Service.MovementId_service,0) = 0 AND _tmpMovement_Service.Amount <> 0)
           ORDER BY _tmpMovement_Service.OperDate
          ) AS tmpMovement
    ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.08.22         *
*/

-- тест
-- 