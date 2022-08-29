DROP FUNCTION IF EXISTS gpInsert_Movement_Service_byServiceItem (TDateTime, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_Movement_Service_byServiceItem (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_Movement_Service_byServiceItem (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Service_byServiceItem(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inInfoMoneyId       Integer ,
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
           WITH -- список по месяцам
                tmpListDate AS (SELECT GENERATE_SERIES (zfCalc_Month_start (inStartDate)
                                                      , zfCalc_Month_end (inEndDate)
                                                      , '1 MONTH' :: INTERVAL
                                                       ) AS OperDate
                               )
                -- ServiceItem на дату
              , tmpServiceItem AS (SELECT tmpListDate.OperDate
                                        , gpSelect.UnitId
                                        , gpSelect.InfoMoneyId
                                        , gpSelect.CommentInfoMoneyId
                                        , gpSelect.Amount 
                                   FROM tmpListDate
                                        CROSS JOIN gpSelect_MovementItem_ServiceItem_onDate (inOperDate    := tmpListDate.OperDate
                                                                                           , inUnitId      := 0
                                                                                           , inInfoMoneyId := inInfoMoneyId --76878 -- _Аренда
                                                                                           , inSession     := inSession
                                                                                            ) AS gpSelect
                                   WHERE gpSelect.Amount > 0
                                  )
        -- находим существующие Начисления
      , tmpMovement_Service AS (SELECT Movement.Id                            AS MovementId
                                     , zfCalc_Month_start (Movement.OperDate) AS OperDate
                                     , MovementItem.ObjectId                  AS UnitId
                                     , MILinkObject_InfoMoney.ObjectId        AS InfoMoneyId
                                     , MILinkObject_CommentInfoMoney.ObjectId AS CommentInfoMoneyId
                                FROM Movement
                                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                            AND MovementItem.DescId     = zc_MI_Master()
                                                            AND MovementItem.isErased   = FALSE
                                     LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                      ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_InfoMoney.DescId         = zc_MILinkObject_InfoMoney()
                                     LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentInfoMoney
                                                                      ON MILinkObject_CommentInfoMoney.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_CommentInfoMoney.DescId = zc_MILinkObject_CommentInfoMoney()
                                     INNER JOIN MovementLinkObject AS MLO_Insert
                                                                   ON MLO_Insert.MovementId = Movement.Id
                                                                  AND MLO_Insert.DescId     = zc_MovementLinkObject_Insert()
                                                                  AND MLO_Insert.ObjectId   = 2020
                                WHERE Movement.DescId   = zc_Movement_Service()
                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                                  AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                  AND (COALESCE (inInfoMoneyId,0) = 0 OR MILinkObject_InfoMoney.ObjectId = inInfoMoneyId)
                               )

           -- Список Начислений
           SELECT COALESCE (tmpServiceItem.OperDate, tmpServiceItem.OperDate)                     AS OperDate
                , COALESCE (tmpServiceItem.UnitId, tmpServiceItem.UnitId)                         AS UnitId
                , COALESCE (tmpServiceItem.InfoMoneyId, tmpServiceItem.InfoMoneyId)               AS InfoMoneyId
                , COALESCE (tmpServiceItem.CommentInfoMoneyId, tmpServiceItem.CommentInfoMoneyId) AS CommentInfoMoneyId
                , COALESCE (tmpServiceItem.Amount, 0)                                             AS Amount
                , COALESCE (tmpMovement_Service.MovementId, 0)                                    AS MovementId_service
           FROM tmpServiceItem
                FULL JOIN tmpMovement_Service ON tmpMovement_Service.OperDate    = tmpServiceItem.OperDate
                                             AND tmpMovement_Service.UnitId      = tmpServiceItem.UnitId
                                             AND tmpMovement_Service.InfoMoneyId = tmpServiceItem.InfoMoneyId
         --WHERE tmpMovement_Service.MovementId IS NULL
          ;


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
                                            , inSession           := '2020' -- inSession :: TVarChar
                                             ) AS MovementId
     FROM (SELECT _tmpMovement_Service.MovementId_service
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

           WHERE _tmpMovement_Service.MovementId_service <> 0
              OR (_tmpMovement_Service.MovementId_service = 0 AND _tmpMovement_Service.Amount <> 0)
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