-- Function: lpComplete_Movement_BankAccount_Recalc (Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_BankAccount_Recalc (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_BankAccount_Recalc(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbMovementId_PersonalServiceBN Integer;
   DECLARE vbServiceDate TDateTime;
   DECLARE vbOperDate TDateTime;
   DECLARE vbPersonalServiceListId Integer;
   DECLARE vbIsOut Boolean;
BEGIN
     -- таблица - элементы
     CREATE TEMP TABLE _tmpItem_PersonalService (MovementId_serviceBN Integer, PersonalServiceListId_from Integer, PersonalServiceListId Integer, PersonalId Integer, UnitId Integer, PositionId Integer, InfoMoneyId Integer, SummCard TFloat, SummCardRecalc TFloat) ON COMMIT DROP;

     -- дата выплаты по банку
     vbOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);

     -- нашли ведомость
     vbPersonalServiceListId:= (SELECT MILinkObject_MoneyPlace.ObjectId
                                FROM MovementItem
                                     INNER JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                                                       ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                                                      AND MILinkObject_MoneyPlace.DescId         = zc_MILinkObject_MoneyPlace()
                                WHERE MovementItem.MovementId = inMovementId
                                  AND MovementItem.DescId     = zc_MI_Master()
                               );

     -- это ведомость для уволенных - тогда по дате
     vbIsOut:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = vbPersonalServiceListId AND ObjectBoolean.DescId = zc_ObjectBoolean_PersonalServiceList_BankOut());


     -- 
     WITH -- из zc_Movement_BankAccount - Получили одну Ведомость - БН
          tmpParams AS (SELECT MILinkObject_MoneyPlace.ObjectId AS MoneyPlaceId, MovementDate_ServiceDate.ValueData AS ServiceDate
                        FROM MovementItem
                             INNER JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                                               ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
                             INNER JOIN MovementDate AS MovementDate_ServiceDate
                                                     ON MovementDate_ServiceDate.MovementId = inMovementId
                                                    AND MovementDate_ServiceDate.DescId     = zc_MovementDate_ServiceDate()
                        WHERE MovementItem.MovementId = inMovementId
                          AND MovementItem.DescId     = zc_MI_Master()
                       )
      -- данные zc_Movement_PersonalService + установленные в ней ведомости zc_MIFloat_SummCardRecalc - начисления (реальные)
    , tmpMI_service AS (SELECT Movement.Id                                          AS MovementId
                             -- , MovementLinkObject_PersonalServiceList.ObjectId      AS PersonalServiceListId
                             , CASE WHEN COALESCE (MIFloat_SummCardRecalc.ValueData, 0) = 0
                                         THEN tmpParams.MoneyPlaceId
                                         ELSE MILinkObject_PersonalServiceList.ObjectId
                               END AS PersonalServiceListId_to
                             , MovementItem.ObjectId                                AS PersonalId
                             , MILinkObject_Unit.ObjectId                           AS UnitId
                             , MILinkObject_Position.ObjectId                       AS PositionId
                             , MILinkObject_InfoMoney.ObjectId                      AS InfoMoneyId
                               -- Карточка (БН) ввод + "Сумма начислено"
                             , SUM (CASE WHEN vbIsOut = TRUE
                                         THEN CASE WHEN MID_BankOut.ValueData = vbOperDate
                                                        THEN CASE WHEN MIFloat_SummCardRecalc.ValueData <> 0
                                                                  THEN MIFloat_SummCardRecalc.ValueData
                                                                  ELSE COALESCE (MIFloat_SummHosp.ValueData, 0)
                                                             END
                                                   ELSE 0
                                              END
                                         ELSE
                                              CASE WHEN MIFloat_SummCardRecalc.ValueData <> 0
                                                   THEN MIFloat_SummCardRecalc.ValueData
                                                   ELSE COALESCE (MIFloat_SummHosp.ValueData, 0)
                                              END
                                    END
                                   ) AS SummCardRecalc
                        FROM tmpParams
                             -- ведомость за этот месяц
                             INNER JOIN MovementDate AS MovementDate_ServiceDate
                                                     ON MovementDate_ServiceDate.ValueData = tmpParams.ServiceDate
                                                    AND MovementDate_ServiceDate.DescId    = zc_MovementDate_ServiceDate()
                             -- проведен
                             INNER JOIN Movement ON Movement.Id       = MovementDate_ServiceDate.MovementId
                                                AND Movement.DescId   = zc_Movement_PersonalService()
                                                AND Movement.StatusId = zc_Enum_Status_Complete()
                                                
                             -- именно эта ведомость
                             INNER JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                                           ON MovementLinkObject_PersonalServiceList.MovementId = MovementDate_ServiceDate.MovementId
                                                          AND MovementLinkObject_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
                                                          AND MovementLinkObject_PersonalServiceList.ObjectId   = tmpParams.MoneyPlaceId
                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.isErased   = FALSE
                             LEFT JOIN MovementItemDate AS MID_BankOut
                                                        ON MID_BankOut.MovementItemId = MovementItem.Id
                                                       AND MID_BankOut.DescId         = zc_MIDate_BankOut()
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_PersonalServiceList
                                                              ON MILinkObject_PersonalServiceList.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_PersonalServiceList.DescId = zc_MILinkObject_PersonalServiceList() 
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                              ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                              ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                              ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
                             /*LEFT JOIN MovementItemFloat AS MIFloat_SummCard
                                                         ON MIFloat_SummCard.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummCard.DescId = zc_MIFloat_SummCard()*/
                             -- Карта БН (ввод) - 1ф. 
                             LEFT JOIN MovementItemFloat AS MIFloat_SummCardRecalc
                                                         ON MIFloat_SummCardRecalc.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummCardRecalc.DescId         = zc_MIFloat_SummCardRecalc()
                             -- или "Сумма начислено "
                             LEFT JOIN MovementItemFloat AS MIFloat_SummHosp
                                                         ON MIFloat_SummHosp.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummHosp.DescId         = zc_MIFloat_SummHosp()
                             LEFT JOIN ObjectLink AS OL_PersonalServiceList_PaidKind
                                                  ON OL_PersonalServiceList_PaidKind.ObjectId = tmpParams.MoneyPlaceId
                                                 AND OL_PersonalServiceList_PaidKind.DescId   = zc_ObjectLink_PersonalServiceList_PaidKind()
                        WHERE (MIFloat_SummCardRecalc.ValueData <> 0
                            OR (MIFloat_SummHosp.ValueData   <> 0 /*AND OL_PersonalServiceList_PaidKind.ChildObjectId = zc_Enum_PaidKind_FirstForm()*/)
                         -- OR MIFloat_SummCard.ValueData        <> 0
                              )
                        GROUP BY Movement.Id
                               , CASE WHEN COALESCE (MIFloat_SummCardRecalc.ValueData, 0) = 0
                                           THEN tmpParams.MoneyPlaceId
                                           ELSE MILinkObject_PersonalServiceList.ObjectId
                                 END
                               , MovementItem.ObjectId
                               , MILinkObject_Unit.ObjectId
                               , MILinkObject_Position.ObjectId
                               , MILinkObject_InfoMoney.ObjectId
                               , MILinkObject_PersonalServiceList.ObjectId
                        HAVING SUM (CASE WHEN vbIsOut = TRUE
                                         THEN CASE WHEN MID_BankOut.ValueData = vbOperDate
                                                        THEN CASE WHEN MIFloat_SummCardRecalc.ValueData <> 0
                                                                  THEN MIFloat_SummCardRecalc.ValueData
                                                                  ELSE COALESCE (MIFloat_SummHosp.ValueData, 0)
                                                             END
                                                   ELSE 0
                                              END
                                         ELSE
                                              CASE WHEN MIFloat_SummCardRecalc.ValueData <> 0
                                                   THEN MIFloat_SummCardRecalc.ValueData
                                                   ELSE COALESCE (MIFloat_SummHosp.ValueData, 0)
                                              END
                                    END
                                   ) <> 0
                       )
     -- Результат
     INSERT INTO _tmpItem_PersonalService (MovementId_serviceBN, PersonalServiceListId_from, PersonalServiceListId, PersonalId, UnitId, PositionId, InfoMoneyId, SummCard, SummCardRecalc)
        SELECT tmpMI_find.MovementId
             , tmpParams.MoneyPlaceId
             , tmpMI_find.PersonalServiceListId_to
             , tmpMI_find.PersonalId
             , tmpMI_find.UnitId
             , tmpMI_find.PositionId
             , tmpMI_find.InfoMoneyId
             , COALESCE (tmpMI_find.SummCardRecalc, 0) -- COALESCE (tmpMI_find.SummCard, 0)
             , COALESCE (tmpMI_find.SummCardRecalc, 0) -- COALESCE (tmpMI_service.SummCard, 0)
        FROM tmpParams
             INNER JOIN tmpMI_service AS tmpMI_find ON tmpMI_find.PersonalServiceListId_to <> 0
             /*LEFT JOIN tmpMI_service ON tmpMI_service.PersonalServiceListId = tmpParams.MoneyPlaceId
             LEFT JOIN tmpMI_service AS tmpMI_find ON tmpMI_find.PersonalId  = tmpMI_service.PersonalId
                                                  AND tmpMI_find.UnitId      = tmpMI_service.UnitId
                                                  AND tmpMI_find.PositionId  = tmpMI_service.PositionId
                                                  AND tmpMI_find.InfoMoneyId = tmpMI_service.InfoMoneyId
                                                  AND tmpMI_find.SummCard    = tmpMI_service.SummCardRecalc*/
                                                  ;
     -- определили <Месяц начислений>
     vbServiceDate:= (SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId AND MovementDate.DescId = zc_MovementDate_ServiceDate());
     -- определили <документ>
     vbMovementId_PersonalServiceBN:= (SELECT DISTINCT _tmpItem_PersonalService.MovementId_serviceBN FROM _tmpItem_PersonalService);

     IF vbIsOut = TRUE
     THEN
        -- проверка
        IF NOT EXISTS (SELECT 1 FROM _tmpItem_PersonalService WHERE _tmpItem_PersonalService.SummCardRecalc <> 0)
        THEN
            RAISE EXCEPTION 'Ошибка.В документе начисления для <%> за <%> не найдены сотрудники с <Дата выплаты по банку> = %.'
                           , lfGet_Object_ValueData_sh ((SELECT DISTINCT MILinkObject_MoneyPlace.ObjectId AS MoneyPlaceId
                                                         FROM MovementItem
                                                              INNER JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                                                                                ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                                                                               AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
                                                              INNER JOIN MovementDate AS MovementDate_ServiceDate
                                                                                      ON MovementDate_ServiceDate.MovementId = inMovementId
                                                                                     AND MovementDate_ServiceDate.DescId     = zc_MovementDate_ServiceDate()
                                                         WHERE MovementItem.MovementId = inMovementId
                                                           AND MovementItem.DescId     = zc_MI_Master()
                                                        ))
                          , zfCalc_MonthYearName (vbServiceDate)
                          , zfConvert_DateToString (vbOperDate)
                           ;
        END IF;
     ELSE
        -- проверка
        IF NOT EXISTS (SELECT 1 FROM _tmpItem_PersonalService WHERE _tmpItem_PersonalService.SummCardRecalc <> 0)
        THEN
            RAISE EXCEPTION 'Ошибка.Не найден документ начисления для <%> за <%>.'
                           , lfGet_Object_ValueData_sh ((SELECT DISTINCT MILinkObject_MoneyPlace.ObjectId AS MoneyPlaceId
                                                         FROM MovementItem
                                                              INNER JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                                                                                ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                                                                               AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
                                                              INNER JOIN MovementDate AS MovementDate_ServiceDate
                                                                                      ON MovementDate_ServiceDate.MovementId = inMovementId
                                                                                     AND MovementDate_ServiceDate.DescId     = zc_MovementDate_ServiceDate()
                                                         WHERE MovementItem.MovementId = inMovementId
                                                           AND MovementItem.DescId     = zc_MI_Master()
                                                        ))
                          , zfCalc_MonthYearName (vbServiceDate)
                           ;
        END IF;
     END IF;

     -- проверка - суммы должны соответствовать
     IF COALESCE ((SELECT SUM (_tmpItem_PersonalService.SummCardRecalc) FROM _tmpItem_PersonalService), 0)
     <> -1 * COALESCE ((SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master()) , 0)
     THEN
         RAISE EXCEPTION 'Ошибка.Сумма по банку <%> не соответствует сумме в начислениях <%>.(%)(%)'
                , zfConvert_FloatToString (-1 * (SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master()))
                , zfConvert_FloatToString ((SELECT SUM (_tmpItem_PersonalService.SummCardRecalc) FROM _tmpItem_PersonalService))
                , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = vbMovementId_PersonalServiceBN)
                , zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_PersonalServiceBN))
                 ;
     END IF;
     -- проверка - распределенная сумма должны соответствовать
     IF EXISTS (SELECT 1 FROM _tmpItem_PersonalService HAVING SUM (_tmpItem_PersonalService.SummCard) <> SUM (_tmpItem_PersonalService.SummCardRecalc))
     THEN
         RAISE EXCEPTION 'Ошибка распределения.Сумма карточка (БН) ввод <%> не соответствует сумме карточка (БН) <%>.'
                , (SELECT SUM (_tmpItem_PersonalService.SummCardRecalc) FROM _tmpItem_PersonalService)
                , (SELECT SUM (_tmpItem_PersonalService.SummCard) FROM _tmpItem_PersonalService)
                 ;
     END IF;


     -- удаляем предыдущие данные по ЗП в <Расчетный счет, приход/расход>
     PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id
                                     , inUserId        := inUserId
                                      )
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId = zc_MI_Child()
       AND MovementItem.isErased = FALSE;


     -- формируются новые данные по ЗП в <Расчетный счет, приход/расход> - из документа <Начисление зарплаты>
     PERFORM lpInsertUpdate_MovementItem_BankAccount_Personal (ioId                 := NULL
                                                             , inMovementId         := inMovementId
                                                             , inPersonalId         := _tmpItem_PersonalService.PersonalId
                                                             , inAmount             := 1 * _tmpItem_PersonalService.SummCardRecalc
                                                             , inServiceDate        := vbServiceDate
                                                             , inComment            := ''
                                                             , inInfoMoneyId        := _tmpItem_PersonalService.InfoMoneyId
                                                             , inUnitId             := _tmpItem_PersonalService.UnitId
                                                             , inPositionId         := _tmpItem_PersonalService.PositionId
                                                             , inPersonalServiceListId := _tmpItem_PersonalService.PersonalServiceListId -- !!!все Ведомости начисления с заполненным <Карточка (БН)>
                                                             , inUserId             := inUserId
                                                              )
     FROM _tmpItem_PersonalService;

    -- сохранили связь с документом <Начисление зарплаты> !!!один документ с заполненным <Карточка (БН) ввод>!!!
    PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Child(), inMovementId, vbMovementId_PersonalServiceBN);


if inUserId = 5 AND 1=1
then
    RAISE EXCEPTION 'Admin - Errr _end   ';
    -- 'Повторите действие через 3 мин.'
end if;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.04.15                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_BankAccount_Recalc (inMovementId:= 429713, inUserId:= zfCalc_UserAdmin() :: Integer)
