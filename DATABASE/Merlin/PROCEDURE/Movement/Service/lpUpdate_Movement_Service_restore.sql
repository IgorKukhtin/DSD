-- Function: lpUpdate_Movement_Service_restore()

DROP FUNCTION IF EXISTS lpUpdate_Movement_Service_restore (Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Movement_Service_restore(
 INOUT inMovementId_sia       Integer   , -- Ключ объекта
    IN inUserId               Integer     -- Пользователь
)                              
RETURNS Integer
AS
$BODY$
BEGIN

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE '_tmpMovement_Service')
     THEN
         DELETE FROM _tmpMovement_Service;
     ELSE
         -- таблица - документы
         CREATE TEMP TABLE _tmpMovement_Service (OperDate TDateTime, UnitId Integer, InfoMoneyId Integer, CommentInfoMoneyId Integer, Amount TFloat, MovementId_service Integer) ON COMMIT DROP;
     END IF;


     -- Доп. условия - разложили по месяцам - восстановим инфу по ним
     INSERT INTO _tmpMovement_Service (OperDate, UnitId, InfoMoneyId, CommentInfoMoneyId, Amount, MovementId_service)
           WITH tmpMI AS (SELECT MIDate_DateStart.ValueData AS StartDate
                               , MIDate_DateEnd.ValueData   AS EndDate
                               , MovementItem.ObjectId                   AS UnitId
                               , MILinkObject_InfoMoney.ObjectId         AS InfoMoneyId
                          FROM Movement
                               INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                      AND MovementItem.DescId     = zc_MI_Master()
                                                      AND MovementItem.isErased   = FALSE
                               INNER JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                 ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                                AND MILinkObject_InfoMoney.DescId         = zc_MILinkObject_InfoMoney()
                               LEFT JOIN MovementItemDate AS MIDate_DateStart
                                                          ON MIDate_DateStart.MovementItemId = MovementItem.Id
                                                         AND MIDate_DateStart.DescId = zc_MIDate_DateStart()
                               LEFT JOIN MovementItemDate AS MIDate_DateEnd
                                                          ON MIDate_DateEnd.MovementItemId = MovementItem.Id
                                                         AND MIDate_DateEnd.DescId = zc_MIDate_DateEnd()
                          WHERE Movement.Id = inMovementId_sia
                         )
       , tmpListDate AS (SELECT GENERATE_SERIES ((SELECT MIN (tmpMI.StartDate) FROM tmpMI)
                                               , (SELECT MAX (tmpMI.EndDate)   FROM tmpMI)
                                               , '1 MONTH' :: INTERVAL
                                                ) AS OperDate
                        )
           -- Список Доп. условия - по месяцам
           SELECT tmpListDate.OperDate
                , tmpMI.UnitId
                , tmpMI.InfoMoneyId
                  -- потом найдем откуда восстанавливать
                , 0 AS CommentInfoMoneyId
                  -- потом найдем откуда восстанавливать
                , -1 AS Amount
                  -- потом найдем док. Начисления
                , 0 AS MovementId_service

           FROM tmpListDate
                INNER JOIN tmpMI ON tmpListDate.OperDate BETWEEN tmpMI.StartDate AND tmpMI.EndDate
           ORDER BY tmpListDate.OperDate;
           

     -- Сохранили что нашли
     UPDATE _tmpMovement_Service SET Amount             = tmpMI_find.Amount
                                   , CommentInfoMoneyId = tmpMI_find.CommentInfoMoneyId

     FROM (WITH -- для этих - нашли "дополнительные" условия
                tmpMI_sia AS (SELECT _tmpMovement_Service.OperDate
                                   , _tmpMovement_Service.UnitId
                                   , _tmpMovement_Service.InfoMoneyId
                                   , MILinkObject_CommentInfoMoney.ObjectId  AS CommentInfoMoneyId
                                   , MovementItem.Amount                     AS Amount
                                     -- № п/п
                                   , ROW_NUMBER() OVER (PARTITION BY _tmpMovement_Service.OperDate, _tmpMovement_Service.UnitId, _tmpMovement_Service.InfoMoneyId
                                                        ORDER BY Movement.OperDate DESC, Movement.Id DESC
                                                       ) AS Ord
                              FROM Movement
                                   INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                          AND MovementItem.DescId     = zc_MI_Master()
                                                          AND MovementItem.isErased   = FALSE
                                   INNER JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                     ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                                    AND MILinkObject_InfoMoney.DescId         = zc_MILinkObject_InfoMoney()
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentInfoMoney
                                                                    ON MILinkObject_CommentInfoMoney.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_CommentInfoMoney.DescId         = zc_MILinkObject_CommentInfoMoney()
                                   LEFT JOIN MovementItemDate AS MIDate_DateStart
                                                              ON MIDate_DateStart.MovementItemId = MovementItem.Id
                                                             AND MIDate_DateStart.DescId = zc_MIDate_DateStart()
                                   LEFT JOIN MovementItemDate AS MIDate_DateEnd
                                                              ON MIDate_DateEnd.MovementItemId = MovementItem.Id
                                                             AND MIDate_DateEnd.DescId = zc_MIDate_DateEnd()
                                   INNER JOIN _tmpMovement_Service ON _tmpMovement_Service.UnitId      = MovementItem.ObjectId
                                                                  AND _tmpMovement_Service.InfoMoneyId = MILinkObject_InfoMoney.ObjectId
                                                                  AND _tmpMovement_Service.OperDate    BETWEEN MIDate_DateStart.ValueData AND MIDate_DateEnd.ValueData
                              WHERE Movement.DescId    = zc_Movement_ServiceItemAdd()
                                AND Movement.StatusId  = zc_Enum_Status_Complete()
                                AND Movement.Id <> inMovementId_sia
                             )
               -- для этих - надо найти "базовые" условия
             , tmpMI_find AS (SELECT _tmpMovement_Service.OperDate
                                   , _tmpMovement_Service.UnitId
                                   , _tmpMovement_Service.InfoMoneyId
                              FROM _tmpMovement_Service
                                   LEFT JOIN tmpMI_sia ON tmpMI_sia.OperDate    = _tmpMovement_Service.OperDate
                                                      AND tmpMI_sia.UnitId      = _tmpMovement_Service.UnitId
                                                      AND tmpMI_sia.InfoMoneyId = _tmpMovement_Service.InfoMoneyId
                              -- если "дополнительные" условия не нашли
                              WHERE tmpMI_sia.UnitId IS NULL
                             )
                 -- для этих - найдем "базовые" условия
               , tmpMI_si AS (SELECT tmpMI_find.OperDate
                                   , tmpMI_find.UnitId
                                   , tmpMI_find.InfoMoneyId
                                     -- нашли
                                   , Movement.Id                             AS MovementId_si
                                   , Movement.OperDate                       AS OperDate_si
                                   , MILinkObject_CommentInfoMoney.ObjectId  AS CommentInfoMoneyId
                                   , MovementItem.Amount                     AS Amount
                                     -- находим первое
                                   , ROW_NUMBER() OVER (PARTITION BY tmpMI_find.OperDate, tmpMI_find.UnitId, tmpMI_find.InfoMoneyId
                                                        ORDER BY Movement.OperDate ASC
                                                       ) AS Ord
                              FROM tmpMI_find
                                   -- поиск "базовые" условия, если у них дата окончания позже ...
                                   INNER JOIN Movement ON Movement.OperDate  > tmpMI_find.OperDate
                                                      AND Movement.DescId    = zc_Movement_ServiceItem()
                                                      AND Movement.StatusId  = zc_Enum_Status_Complete()
                                   INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                          AND MovementItem.DescId     = zc_MI_Master()
                                                          AND MovementItem.isErased   = FALSE
                                                          AND MovementItem.ObjectId   = tmpMI_find.UnitId
                                   INNER JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                     ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                                    AND MILinkObject_InfoMoney.DescId         = zc_MILinkObject_InfoMoney()
                                                                    AND MILinkObject_InfoMoney.ObjectId       = tmpMI_find.InfoMoneyId
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentInfoMoney
                                                                    ON MILinkObject_CommentInfoMoney.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_CommentInfoMoney.DescId         = zc_MILinkObject_CommentInfoMoney()
                             )
          -- Результат - нашли данные, которые и будем "восстанавливать"
          SELECT _tmpMovement_Service.OperDate
               , _tmpMovement_Service.UnitId
               , _tmpMovement_Service.InfoMoneyId
               , COALESCE (tmpMI_sia.CommentInfoMoneyId, tmpMI_si.CommentInfoMoneyId, 0) AS CommentInfoMoneyId
               , COALESCE (tmpMI_sia.Amount, tmpMI_si.Amount, -2)                        AS Amount
          FROM _tmpMovement_Service
               -- нашли "дополнительные" условия
               LEFT JOIN tmpMI_sia ON tmpMI_sia.OperDate    = _tmpMovement_Service.OperDate
                                  AND tmpMI_sia.UnitId      = _tmpMovement_Service.UnitId
                                  AND tmpMI_sia.InfoMoneyId = _tmpMovement_Service.InfoMoneyId
                                  AND tmpMI_sia.Ord         = 1
               -- нашли "базовые" условия
               LEFT JOIN tmpMI_si ON tmpMI_si.OperDate      = _tmpMovement_Service.OperDate
                                 AND tmpMI_si.UnitId        = _tmpMovement_Service.UnitId
                                 AND tmpMI_si.InfoMoneyId   = _tmpMovement_Service.InfoMoneyId
                                 AND tmpMI_si.Ord           = 1
          WHERE tmpMI_sia.Amount >=0
             OR tmpMI_si.Amount  >=0

         ) AS tmpMI_find

     WHERE _tmpMovement_Service.OperDate    = tmpMI_find.OperDate
       AND _tmpMovement_Service.UnitId      = tmpMI_find.UnitId
       AND _tmpMovement_Service.InfoMoneyId = tmpMI_find.InfoMoneyId
    ;


     -- проверка
     IF EXISTS (SELECT 1 FROM _tmpMovement_Service WHERE _tmpMovement_Service.Amount < 0)
     THEN
         RAISE EXCEPTION 'Ошибка.Не найдены данные для восстановления <%> <%> за <%>. <%> Всего не найдено = <%>.'
                       , lfGet_Object_ValueData_sh ((SELECT tmp.UnitId FROM _tmpMovement_Service AS tmp WHERE tmp.Amount < 0 ORDER BY tmp.OperDate, tmp.UnitId, tmp.InfoMoneyId, tmp.CommentInfoMoneyId, tmp.Amount LIMIT 1))
                       , lfGet_Object_ValueData_sh ((SELECT tmp.InfoMoneyId FROM _tmpMovement_Service AS tmp WHERE tmp.Amount < 0 ORDER BY tmp.OperDate, tmp.UnitId, tmp.InfoMoneyId, tmp.CommentInfoMoneyId, tmp.Amount LIMIT 1))
                       , zfConvert_DateToString ((SELECT tmp.OperDate FROM _tmpMovement_Service AS tmp WHERE tmp.Amount < 0 ORDER BY tmp.OperDate, tmp.UnitId, tmp.InfoMoneyId, tmp.CommentInfoMoneyId, tmp.Amount LIMIT 1))
                       , (SELECT tmp.Amount FROM _tmpMovement_Service AS tmp WHERE tmp.Amount < 0 ORDER BY tmp.OperDate, tmp.UnitId, tmp.InfoMoneyId, tmp.CommentInfoMoneyId, tmp.Amount LIMIT 1)
                       , (SELECT COUNT(*) FROM _tmpMovement_Service AS tmp WHERE tmp.Amount < 0)
                        ;
     END IF;


     -- находим существующие
     UPDATE _tmpMovement_Service SET MovementId_service = tmp_find.MovementId_service

     FROM (-- находим существующие
           SELECT Movement.Id                     AS MovementId_service
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
                INNER JOIN _tmpMovement_Service ON _tmpMovement_Service.UnitId      = MovementItem.ObjectId
                                               AND _tmpMovement_Service.InfoMoneyId = MILinkObject_InfoMoney.ObjectId
                                               AND _tmpMovement_Service.OperDate    = Movement.OperDate
   
           WHERE Movement.DescId   = zc_Movement_Service()
             AND Movement.StatusId = zc_Enum_Status_Complete()
          ) AS tmp_find
     WHERE _tmpMovement_Service.UnitId      = tmp_find.UnitId
       AND _tmpMovement_Service.InfoMoneyId = tmp_find.InfoMoneyId
       AND _tmpMovement_Service.OperDate    = tmp_find.OperDate
      ;
        
     -- проверка
     IF EXISTS (SELECT 1 FROM _tmpMovement_Service WHERE _tmpMovement_Service.MovementId_service = 0)
     THEN
         RAISE EXCEPTION 'Ошибка.Не найдены начисления для <%> <%> за <%>.Нельзя провести дополнение.Всего не найдено = <%>.'
                       , lfGet_Object_ValueData_sh ((SELECT tmp.UnitId FROM _tmpMovement_Service AS tmp WHERE tmp.MovementId_service = 0 ORDER BY tmp.OperDate, tmp.UnitId, tmp.InfoMoneyId, tmp.CommentInfoMoneyId, tmp.Amount LIMIT 1))
                       , lfGet_Object_ValueData_sh ((SELECT tmp.InfoMoneyId FROM _tmpMovement_Service AS tmp WHERE tmp.MovementId_service = 0 ORDER BY tmp.OperDate, tmp.UnitId, tmp.InfoMoneyId, tmp.CommentInfoMoneyId, tmp.Amount LIMIT 1))
                       , zfConvert_DateToString ((SELECT tmp.OperDate FROM _tmpMovement_Service AS tmp WHERE tmp.MovementId_service = 0 ORDER BY tmp.OperDate, tmp.UnitId, tmp.InfoMoneyId, tmp.CommentInfoMoneyId, tmp.Amount LIMIT 1))
                       , (SELECT COUNT(*) FROM _tmpMovement_Service AS tmp WHERE tmp.MovementId_service = 0)
                        ;
     END IF;


     -- Заливаем данные в начисления
     PERFORM gpInsertUpdate_Movement_Service (ioId                := tmpMovement.MovementId_service
                                            , inInvNumber         := tmpMovement.InvNumber_service
                                            , inOperDate          := tmpMovement.OperDate
                                            , inServiceDate       := tmpMovement.OperDate
                                            , inAmount            := tmpMovement.Amount
                                            , inUnitId            := tmpMovement.UnitId
                                            , inParent_InfoMoneyId:= tmpMovement.ParentId_InfoMoney
                                            , inInfoMoneyName     := tmpMovement.InfoMoneyName
                                            , inCommentInfoMoney  := tmpMovement.CommentInfoMoney
                                            , inSession           := (-1 * inUserId) :: TVarChar
                                             ) AS MovementId
     FROM (-- Список Начислений
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
                INNER JOIN Movement ON Movement.Id = _tmpMovement_Service.MovementId_service
           ORDER BY _tmpMovement_Service.OperDate
          ) AS tmpMovement
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.08.22                                        *
 */

-- тест
-- SELECT * FROM lpUpdate_Movement_Service_restore (inMovementId_sia:= 291967, inUserId:= zfCalc_UserAdmin() :: Integer);
