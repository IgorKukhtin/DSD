-- Function: lpComplete_Movement_BankAccount_Recalc (Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_BankAccount_Recalc (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_BankAccount_Recalc(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbMovementId_PersonalService Integer;
   DECLARE vbServiceDate TDateTime;
BEGIN
     -- таблица - элементы
     CREATE TEMP TABLE _tmpItem_PersonalService (MovementId_service Integer, PersonalServiceListId_from Integer, PersonalServiceListId Integer, PersonalId Integer, UnitId Integer, PositionId Integer, InfoMoneyId Integer, SummCard TFloat, SummCardRecalc TFloat) ON COMMIT DROP;

     -- поиск данных
     WITH tmpParams AS (SELECT MILinkObject_MoneyPlace.ObjectId AS MoneyPlaceId, MovementDate_ServiceDate.ValueData AS ServiceDate
                        FROM MovementItem
                             INNER JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                                               ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
                             INNER JOIN MovementDate AS MovementDate_ServiceDate
                                                     ON MovementDate_ServiceDate.MovementId = inMovementId
                                                    AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()
                        WHERE MovementItem.MovementId = inMovementId
                          AND MovementItem.DescId = zc_MI_Master()
                       )
    , tmpMI_service AS (SELECT Movement.Id                                          AS MovementId
                             , MovementLinkObject_PersonalServiceList.ObjectId      AS PersonalServiceListId
                             , MovementItem.ObjectId                                AS PersonalId
                             , MILinkObject_Unit.ObjectId                           AS UnitId
                             , MILinkObject_Position.ObjectId                       AS PositionId
                             , MILinkObject_InfoMoney.ObjectId                      AS InfoMoneyId
                             , SUM (COALESCE (MIFloat_SummCard.ValueData, 0))       AS SummCard
                             , SUM (COALESCE (MIFloat_SummCardRecalc.ValueData, 0)) AS SummCardRecalc
                        FROM tmpParams
                             INNER JOIN MovementDate AS MovementDate_ServiceDate
                                                     ON MovementDate_ServiceDate.ValueData = tmpParams.ServiceDate
                                                    AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()
                             INNER JOIN Movement ON Movement.Id = MovementDate_ServiceDate.MovementId
                                                AND Movement.DescId = zc_Movement_PersonalService()
                                                AND Movement.StatusId = zc_Enum_Status_Complete()
                             INNER JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                                           ON MovementLinkObject_PersonalServiceList.MovementId = MovementDate_ServiceDate.MovementId
                                                          AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.isErased = FALSE
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                              ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                              ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                              ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
                             LEFT JOIN MovementItemFloat AS MIFloat_SummCard
                                                         ON MIFloat_SummCard.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummCard.DescId = zc_MIFloat_SummCard()
                             LEFT JOIN MovementItemFloat AS MIFloat_SummCardRecalc
                                                         ON MIFloat_SummCardRecalc.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummCardRecalc.DescId = zc_MIFloat_SummCardRecalc()
                        WHERE (MIFloat_SummCard.ValueData <> 0 OR MIFloat_SummCardRecalc.ValueData <> 0)
                        GROUP BY Movement.Id
                               , MovementLinkObject_PersonalServiceList.ObjectId
                               , MovementItem.ObjectId
                               , MILinkObject_Unit.ObjectId
                               , MILinkObject_Position.ObjectId
                               , MILinkObject_InfoMoney.ObjectId
                       )
     INSERT INTO _tmpItem_PersonalService (MovementId_service, PersonalServiceListId_from, PersonalServiceListId, PersonalId, UnitId, PositionId, InfoMoneyId, SummCard, SummCardRecalc)
        SELECT tmpMI_service.MovementId
             , tmpParams.MoneyPlaceId
             , tmpMI_find.PersonalServiceListId
             , tmpMI_find.PersonalId
             , tmpMI_find.UnitId
             , tmpMI_find.PositionId
             , tmpMI_find.InfoMoneyId
             , COALESCE (tmpMI_find.SummCard, 0)
             , COALESCE (tmpMI_service.SummCardRecalc, 0)
        FROM tmpParams
             LEFT JOIN tmpMI_service ON tmpMI_service.PersonalServiceListId = tmpParams.MoneyPlaceId
             LEFT JOIN tmpMI_service AS tmpMI_find ON tmpMI_find.PersonalId  = tmpMI_service.PersonalId
                                                  AND tmpMI_find.UnitId      = tmpMI_service.UnitId
                                                  AND tmpMI_find.PositionId  = tmpMI_service.PositionId
                                                  AND tmpMI_find.InfoMoneyId = tmpMI_service.InfoMoneyId
                                                  AND tmpMI_find.SummCard    = tmpMI_service.SummCardRecalc;
     -- определили <Месяц начислений>
     vbServiceDate:= (SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId AND MovementDate.DescId = zc_MovementDate_ServiceDate());
     -- определили <документ>
     vbMovementId_PersonalService:= (SELECT _tmpItem_PersonalService.MovementId_service FROM _tmpItem_PersonalService GROUP BY _tmpItem_PersonalService.MovementId_service);

     -- проверка
     IF NOT EXISTS (SELECT 1 FROM _tmpItem_PersonalService WHERE _tmpItem_PersonalService.SummCardRecalc <> 0)
     THEN
         RAISE EXCEPTION 'Ошибка.Не найден документ начисления для <%> за <%>.', lfGet_Object_ValueData ((SELECT _tmpItem_PersonalService.PersonalServiceListId_from FROM _tmpItem_PersonalService))
                                                                               , zfCalc_MonthYearName (vbServiceDate)
                                                                                ;
     END IF;

     -- проверка - суммы должны соответствовать
     IF COALESCE ((SELECT SUM (_tmpItem_PersonalService.SummCardRecalc) FROM _tmpItem_PersonalService), 0)
     <> -1 * COALESCE ((SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master()) , 0)
     THEN
         RAISE EXCEPTION 'Ошибка.Сумма бо банку <%> не соответствует сумме в начислениях <%>.'
                , -1 * (SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master())
                , (SELECT SUM (_tmpItem_PersonalService.SummCardRecalc) FROM _tmpItem_PersonalService)
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
                                                             , inAmount             := 1 * _tmpItem_PersonalService.SummCard
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
    PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Child(), inMovementId, vbMovementId_PersonalService);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.04.15                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_BankAccount_Recalc (inMovementId:= 429713, inUserId:= zfCalc_UserAdmin() :: Integer)
