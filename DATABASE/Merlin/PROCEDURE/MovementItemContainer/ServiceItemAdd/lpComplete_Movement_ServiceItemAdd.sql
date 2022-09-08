DROP FUNCTION IF EXISTS lpComplete_Movement_ServiceItemAdd (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_ServiceItemAdd(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
RETURNS VOID
AS
$BODY$
BEGIN

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE '_tmpMovement_Service')
     THEN
         DELETE FROM _tmpMovement_Service;
     ELSE
         -- таблица - документы начисления
         CREATE TEMP TABLE _tmpMovement_Service (OperDate TDateTime, UnitId Integer, InfoMoneyId Integer, CommentInfoMoneyId Integer, Amount TFloat, MovementId_service Integer) ON COMMIT DROP;
     END IF;


     -- документы начисления
     INSERT INTO _tmpMovement_Service (OperDate, UnitId, InfoMoneyId, CommentInfoMoneyId, Amount, MovementId_service)
           WITH -- Дополнения к условиям
                tmpMI AS (SELECT MIDate_DateStart.ValueData AS StartDate
                               , MIDate_DateEnd.ValueData   AS EndDate
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
                               LEFT JOIN MovementItemDate AS MIDate_DateStart
                                                          ON MIDate_DateStart.MovementItemId = MovementItem.Id
                                                         AND MIDate_DateStart.DescId = zc_MIDate_DateStart()
                               LEFT JOIN MovementItemDate AS MIDate_DateEnd
                                                          ON MIDate_DateEnd.MovementItemId = MovementItem.Id
                                                         AND MIDate_DateEnd.DescId = zc_MIDate_DateEnd()
                          WHERE Movement.Id = inMovementId
                         )
         -- список по месяцам
       , tmpListDate AS (SELECT GENERATE_SERIES ((SELECT MIN (tmpMI.StartDate) FROM tmpMI)
                                               , (SELECT MAX (tmpMI.EndDate)   FROM tmpMI)
                                               , '1 MONTH' :: INTERVAL
                                                ) AS OperDate
                        )
        -- находим существующие Начисления
      , tmpMovement_Service AS (SELECT Movement.Id                     AS MovementId
                                     , MIDate_ServiceDate.ValueData    AS OperDate
                                     , MovementItem.ObjectId           AS UnitId
                                     , MILinkObject_InfoMoney.ObjectId AS InfoMoneyId
                                FROM Movement
                                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                            AND MovementItem.DescId     = zc_MI_Master()
                                                            AND MovementItem.isErased   = FALSE
                                     LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                      ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_InfoMoney.DescId         = zc_MILinkObject_InfoMoney()
                                     LEFT JOIN MovementItemDate AS MIDate_ServiceDate
                                                                ON MIDate_ServiceDate.MovementItemId = MovementItem.Id
                                                               AND MIDate_ServiceDate.DescId         = zc_MIDate_ServiceDate()
                                     INNER JOIN tmpListDate ON tmpListDate.OperDate = MIDate_ServiceDate.ValueData
                                     INNER JOIN tmpMI ON tmpMI.UnitId      = MovementItem.ObjectId
                                                     AND tmpMI.InfoMoneyId = MILinkObject_InfoMoney.ObjectId
                                                     AND tmpListDate.OperDate BETWEEN tmpMI.StartDate AND tmpMI.EndDate

                                WHERE Movement.DescId   = zc_Movement_Service()
                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                               )
           -- Список Начислений
           SELECT tmpListDate.OperDate
                , tmpMI.UnitId
                , tmpMI.InfoMoneyId
                , tmpMI.CommentInfoMoneyId
                , tmpMI.Amount
                , COALESCE (tmpMovement_Service.MovementId, 0) AS MovementId_service
           FROM tmpListDate
                INNER JOIN tmpMI ON tmpListDate.OperDate BETWEEN tmpMI.StartDate AND tmpMI.EndDate
                LEFT JOIN tmpMovement_Service ON tmpMovement_Service.OperDate    = tmpListDate.OperDate
                                             AND tmpMovement_Service.UnitId      = tmpMI.UnitId
                                             AND tmpMovement_Service.InfoMoneyId = tmpMI.InfoMoneyId
           ORDER BY tmpListDate.OperDate;


     -- проверка
     IF EXISTS (SELECT 1 FROM _tmpMovement_Service WHERE _tmpMovement_Service.MovementId_service = 0)
     THEN
         RAISE EXCEPTION 'Ошибка.Не найдены начисления для <%> <%> за <%>.Нельзя провести дополнение.Всего не найдено = <%>.'
                       , (SELECT OS.ValueData FROM _tmpMovement_Service AS tmp JOIN ObjectString AS OS ON OS.ObjectId = tmp.UnitId AND OS.DescId = zc_ObjectString_Unit_GroupNameFull() WHERE tmp.MovementId_service = 0 ORDER BY tmp.OperDate, tmp.UnitId, tmp.InfoMoneyId, tmp.CommentInfoMoneyId, tmp.Amount LIMIT 1)
               || '' ||  lfGet_Object_ValueData_sh ((SELECT tmp.UnitId FROM _tmpMovement_Service AS tmp WHERE tmp.MovementId_service = 0 ORDER BY tmp.OperDate, tmp.UnitId, tmp.InfoMoneyId, tmp.CommentInfoMoneyId, tmp.Amount LIMIT 1))
                       , lfGet_Object_ValueData_sh ((SELECT tmp.InfoMoneyId FROM _tmpMovement_Service AS tmp WHERE tmp.MovementId_service = 0 ORDER BY tmp.OperDate, tmp.UnitId, tmp.InfoMoneyId, tmp.CommentInfoMoneyId, tmp.Amount LIMIT 1))
                       , zfConvert_DateToString ((SELECT tmp.OperDate FROM _tmpMovement_Service AS tmp WHERE tmp.MovementId_service = 0 ORDER BY tmp.OperDate, tmp.UnitId, tmp.InfoMoneyId, tmp.CommentInfoMoneyId, tmp.Amount LIMIT 1))
                       , (SELECT COUNT(*) FROM _tmpMovement_Service AS tmp WHERE tmp.MovementId_service = 0)
                        ;
     END IF;

     -- проверка
     IF EXISTS (SELECT 1 FROM _tmpMovement_Service GROUP BY _tmpMovement_Service.OperDate, _tmpMovement_Service.UnitId, _tmpMovement_Service.InfoMoneyId HAVING COUNT(*) > 1)
     THEN
         RAISE EXCEPTION 'Ошибка.Нельзя ввести несколько дополнений за 1 месяц.%Найдено несколько для%Отдел = <%>%Месяц = <%>%Статья = <%>.'
                       , CHR (13)
                       , CHR (13)
                       , lfGet_Object_ValueData_sh ((SELECT tmp.UnitId FROM (SELECT tmp.OperDate, tmp.UnitId, tmp.InfoMoneyId FROM _tmpMovement_Service AS tmp GROUP BY tmp.OperDate, tmp.UnitId, tmp.InfoMoneyId HAVING COUNT(*) > 1) AS tmp
                                                     ORDER BY tmp.OperDate, tmp.UnitId, tmp.InfoMoneyId LIMIT 1))
                       , CHR (13)
                       , zfConvert_DateToString ((SELECT tmp.OperDate FROM (SELECT tmp.OperDate, tmp.UnitId, tmp.InfoMoneyId FROM _tmpMovement_Service AS tmp GROUP BY tmp.OperDate, tmp.UnitId, tmp.InfoMoneyId HAVING COUNT(*) > 1) AS tmp
                                                     ORDER BY tmp.OperDate, tmp.UnitId, tmp.InfoMoneyId LIMIT 1))
                       , CHR (13)
                       , lfGet_Object_ValueData_sh ((SELECT tmp.InfoMoneyId FROM (SELECT tmp.OperDate, tmp.UnitId, tmp.InfoMoneyId FROM _tmpMovement_Service AS tmp GROUP BY tmp.OperDate, tmp.UnitId, tmp.InfoMoneyId HAVING COUNT(*) > 1) AS tmp
                                                     ORDER BY tmp.OperDate, tmp.UnitId, tmp.InfoMoneyId LIMIT 1))
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
                INNER JOIN Movement ON Movement.Id = _tmpMovement_Service.MovementId_service
           ORDER BY _tmpMovement_Service.OperDate
          ) AS tmpMovement
    ;


     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_ServiceItemAdd()
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

/*
-- Нельзя ввести несколько дополнений за 1 месяц
with tmpListDate AS (SELECT GENERATE_SERIES ('01.01.2010'
                                               , '01.01.2025'
                                               , '1 MONTH' :: INTERVAL
                                                ) AS OperDate
                        )
      , tmpMovement AS (SELECT *
                                FROM Movement_ServiceItemAdd_View as Movement
                                WHERE Movement.StatusId = zc_Enum_Status_Complete()
                                  and Movement.isErased = false
                               )
, tmp1 as (select tmpListDate.OperDate, UnitId, UnitName, UnitGroupNameFull, InfoMoneyId, InfoMoneyName, MovementId, InvNumber, tmpMovement.OperDate AS OperDate_mov, MovementItemId
from tmpListDate
join tmpMovement on tmpListDate.OperDate between tmpMovement.DateStart and tmpMovement.DateEnd
)

, t as (
select tmp1 .OperDate, tmp1 .UnitId, tmp1 .UnitName, tmp1 .UnitGroupNameFull, tmp1 .InfoMoneyId, tmp1 .InfoMoneyName, tmp1 .MovementId, tmp1 .InvNumber, tmp1 .OperDate_mov, min (tmp1 .MovementItemId), max (tmp1 .MovementItemId)
, tmp11.OperDate_mov as a2 , tmp1.OperDate_mov as a1
from tmp1 
left join tmp1  as tmp11 ON tmp11.OperDate = tmp1.OperDate
                        and tmp11.UnitId = tmp1.UnitId
                        and tmp11.InfoMoneyId = tmp1.InfoMoneyId
                        and tmp11.OperDate_mov > tmp1.OperDate_mov
-- and 1=0
-- where tmp11.UnitId is not null
 where tmp11.UnitId is  null
--and tmp1 .MovementId = 294334 
group by tmp1 .OperDate, tmp1 .UnitId, tmp1 .UnitName, tmp1 .UnitGroupNameFull, tmp1 .InfoMoneyId, tmp1 .InfoMoneyName, tmp1 .MovementId, tmp1 .InvNumber, tmp1 .OperDate_mov
, tmp11.OperDate_mov  , tmp1.OperDate_mov 
having count(*) > 1
)

 -- select * from tmp1 where MovementId = 294443 and UnitId = 52569 order by 1
  select * from t order by 1
*/
-- тест
-- SELECT * FROM lpComplete_Movement_ServiceItemAdd (inMovementId:= 40980, inUserId := zfCalc_UserAdmin() :: Integer);
