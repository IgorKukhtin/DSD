DROP FUNCTION IF EXISTS lpComplete_Movement_ServiceItem (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_ServiceItem(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
RETURNS VOID
AS
$BODY$
  DECLARE vbId_mi_check Integer;
BEGIN
    -- Создаем временнве таблицы
    -- PERFORM lpComplete_Movement_ServiceItem_CreateTemp();


     -- нашли
     vbId_mi_check:= (WITH tmpMI AS (SELECT Movement.OperDate, MovementItem.ObjectId AS UnitId, MILinkObject_InfoMoney.ObjectId AS InfoMoneyId
                                     FROM Movement
                                          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                 AND MovementItem.DescId     = zc_MI_Master()
                                                                 AND MovementItem.isErased   = FALSE
                                          INNER JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                            ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                                           AND MILinkObject_InfoMoney.DescId         = zc_MILinkObject_InfoMoney()
                                     WHERE Movement.Id = inMovementId
                                    )
                      SELECT MovementItem.Id
                      FROM tmpMI
                           INNER JOIN Movement ON Movement.OperDate = tmpMI.OperDate
                                              AND Movement.DescId = zc_Movement_ServiceItem()
                                              AND Movement.Id <> inMovementId
                                              AND Movement.StatusId = zc_Enum_Status_Complete()
                           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                  AND MovementItem.DescId     = zc_MI_Master()
                                                  AND MovementItem.isErased   = FALSE
                                                  AND MovementItem.ObjectId   = tmpMI.UnitId
                           INNER JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_InfoMoney.DescId         = zc_MILinkObject_InfoMoney()
                                                            AND MILinkObject_InfoMoney.ObjectId       = tmpMI.InfoMoneyId
                     );

     -- проверка
     IF vbId_mi_check > 0
     THEN
         RAISE EXCEPTION 'Ошибка.Такое условие <%> <%> до <%> уже существует.Дублирование запрещено.'
                       , lfGet_Object_ValueData_sh ((SELECT MovementItem.ObjectId FROM MovementItem WHERE MovementItem.Id = vbId_mi_check))
                       , lfGet_Object_ValueData_sh ((SELECT MILO.ObjectId FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbId_mi_check AND MILO.DescId = zc_MILinkObject_InfoMoney()))
                       , zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId))
                        ;
     END IF;


     -- Заливаем данные в начисления
     PERFORM gpInsertUpdate_Movement_Service (ioId                := tmpMovement.MovementId_service
                                            , inInvNumber         := CASE WHEN tmpMovement.MovementId_service > 0
                                                                               THEN tmpMovement.InvNumber_service
                                                                          ELSE CAST (NEXTVAL ('movement_ServiceItem_seq') AS TVarChar)
                                                                     END
                                            , inOperDate          := tmpMovement.OperDate
                                            , inServiceDate       := tmpMovement.OperDate
                                            , inAmount            := tmpMovement.Amount
                                            , inUnitId            := tmpMovement.UnitId
                                            , inParent_InfoMoneyId:= tmpMovement.ParentId_InfoMoney
                                            , inInfoMoneyName     := tmpMovement.InfoMoneyName
                                            , inCommentInfoMoney  := tmpMovement.CommentInfoMoney
                                            , inSession           := inUserId :: TVarChar
                                             )
      FROM (WITH -- Базовое условие
                 tmpMI AS (SELECT DATE_TRUNC ('MONTH', Movement.OperDate) AS EndDate
                                , MovementItem.ObjectId                   AS UnitId
                                , MILinkObject_InfoMoney.ObjectId         AS InfoMoneyId
                                , MILinkObject_CommentInfoMoney.ObjectId  AS CommentInfoMoneyId
                                , MovementItem.Amount                     AS Amount
                           FROM Movement
                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId     = zc_MI_Master()
                                                       AND MovementItem.isErased   = FALSE
                                INNER JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                  ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_InfoMoney.DescId         = zc_MILinkObject_InfoMoney()
                                LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentInfoMoney
                                                                 ON MILinkObject_CommentInfoMoney.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_CommentInfoMoney.DescId = zc_MILinkObject_CommentInfoMoney()
                           WHERE Movement.Id = inMovementId
                          )
         -- поиск начальной даты для Базового условия
       , tmpMI_before AS (SELECT DATE_TRUNC ('MONTH', Movement.OperDate + INTERVAL '1 MONTH') AS StartDate
                          FROM tmpMI
                               INNER JOIN Movement ON Movement.OperDate < tmpMI.EndDate
                                                  AND Movement.DescId = zc_Movement_ServiceItem()
                                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                               INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                      AND MovementItem.DescId     = zc_MI_Master()
                                                      AND MovementItem.isErased   = FALSE
                                                      AND MovementItem.ObjectId   = tmpMI.UnitId
                               INNER JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                 ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_InfoMoney.DescId         = zc_MILinkObject_InfoMoney()
                                                                AND MILinkObject_InfoMoney.ObjectId       = tmpMI.InfoMoneyId
                          ORDER BY Movement.OperDate DESC
                          LIMIT 1
                         )
          -- список по месяцам
        , tmpListDate AS (SELECT GENERATE_SERIES (COALESCE ((SELECT tmpMI_before.StartDate FROM tmpMI_before), (SELECT tmpMI.EndDate FROM tmpMI))
                                                , (SELECT tmpMI.EndDate FROM tmpMI)
                                                , '1 MONTH' :: INTERVAL
                                                 ) AS OperDate
                         )
         -- находим существующие Начисления
       , tmpMovement_Service AS (SELECT Movement.Id                     AS MovementId
                                      , Movement.InvNumber              AS InvNumber
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
                                      INNER JOIN tmpMI ON tmpMI.UnitId      = MovementItem.ObjectId
                                                      AND tmpMI.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

                                 WHERE Movement.DescId = zc_Movement_Service()
                                   AND Movement.OperDate BETWEEN (SELECT MIN (tmpListDate.OperDate) FROM tmpListDate)
                                                             AND (SELECT MAX (tmpListDate.OperDate) FROM tmpListDate)
                                   AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                                )
            -- Список Начислений
            SELECT tmpListDate.OperDate              AS OperDate
                 , tmpMI.UnitId                      AS UnitId
                 , tmpMI.Amount                      AS Amount
                 , Object_InfoMoney.ValueData        AS InfoMoneyName
                 , Object_CommentInfoMoney.ValueData AS CommentInfoMoney
                 , ObjectLink_Parent.ChildObjectId   AS ParentId_InfoMoney
                 , tmpMovement_Service.MovementId    AS MovementId_service
                 , tmpMovement_Service.InvNumber     AS InvNumber_service
            FROM tmpListDate
                 INNER JOIN tmpMI ON 1=1
                 LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = tmpMI.InfoMoneyId
                 LEFT JOIN ObjectLink AS ObjectLink_Parent
                                      ON ObjectLink_Parent.ObjectId = Object_InfoMoney.Id
                                     AND ObjectLink_Parent.DescId = zc_ObjectLink_InfoMoney_Parent()
                 LEFT JOIN Object AS Object_CommentInfoMoney ON Object_CommentInfoMoney.Id = tmpMI.CommentInfoMoneyId
                 LEFT JOIN tmpMovement_Service ON tmpMovement_Service.OperDate    = tmpListDate.OperDate
                                              AND tmpMovement_Service.UnitId      = tmpMI.UnitId
                                              AND tmpMovement_Service.InfoMoneyId = tmpMI.InfoMoneyId
            ORDER BY tmpListDate.OperDate
           ) AS tmpMovement
    ;


    --
    -- RAISE EXCEPTION 'Ошибка. ok';


    -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_ServiceItem()
                               , inUserId     := inUserId
                                );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 01.06.22         *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_ServiceItem (inMovementId:= 40980, inUserId := zfCalc_UserAdmin() :: Integer);
