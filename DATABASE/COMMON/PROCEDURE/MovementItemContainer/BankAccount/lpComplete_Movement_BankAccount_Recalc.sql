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
     -- поиск документа
     vbMovementId_PersonalService:= (SELECT Movement_find.Id
                                     FROM MovementItem
                                          INNER JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                                                            ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                                                           AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
                                          INNER JOIN MovementDate AS MovementDate_ServiceDate
                                                                  ON MovementDate_ServiceDate.MovementId = inMovementId
                                                                 AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()

                                          INNER JOIN MovementDate AS MovementDate_ServiceDate_find
                                                                  ON MovementDate_ServiceDate_find.ValueData = MovementDate_ServiceDate.ValueData
                                                                 AND MovementDate_ServiceDate_find.DescId = zc_MovementDate_ServiceDate()
                                          INNER JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                                                        ON MovementLinkObject_PersonalServiceList.MovementId = MovementDate_ServiceDate_find.MovementId
                                                                       AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
                                                                       AND MovementLinkObject_PersonalServiceList.ObjectId = MILinkObject_MoneyPlace.ObjectId
                                          INNER JOIN Movement AS Movement_find ON Movement_find.Id = MovementDate_ServiceDate_find.MovementId
                                                                              AND Movement_find.StatusId = zc_Enum_Status_Complete()
                                     WHERE MovementItem.MovementId = inMovementId
                                       AND MovementItem.DescId = zc_MI_Master()
                                    );
     -- определили <Месяц начислений:
     vbServiceDate:= (SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId AND MovementDate.DescId = zc_MovementDate_ServiceDate());

     -- проверка
     IF COALESCE (vbMovementId_PersonalService, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не найден документ начисления для <%> за <%>.', lfGet_Object_ValueData ((SELECT MI_LO.ObjectId FROM MovementItem AS MI INNER JOIN MovementItemLinkObject AS MI_LO ON MI_LO.MovementItemId = MI.Id AND MI_LO.DescId = zc_MILinkObject_MoneyPlace() WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master()))
                                                                               , zfCalc_MonthYearName ((SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId AND MovementDate.DescId = zc_MovementDate_ServiceDate()))
                                                                                ;
     END IF;

     -- проверка - суммы должны соответствовать
     IF COALESCE ((SELECT SUM (COALESCE (MIFloat_SummCardRecalc.ValueData, 0)) 
                   FROM MovementItem
                        INNER JOIN MovementItemFloat AS MIFloat_SummCardRecalc
                                                     ON MIFloat_SummCardRecalc.MovementItemId = MovementItem.Id
                                                    AND MIFloat_SummCardRecalc.DescId = zc_MIFloat_SummCardRecalc()
                   WHERE MovementItem.MovementId = vbMovementId_PersonalService
                     AND MovementItem.DescId = zc_MI_Master()
                  ) , 0)
     <> -1 * COALESCE ((SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master()) , 0)
     THEN
         RAISE EXCEPTION 'Ошибка.Сумма бо банку <%> не соответствует сумме в начислениях <%>.'
                , -1 * (SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master())
                , (SELECT SUM (COALESCE (MIFloat_SummCardRecalc.ValueData, 0)) 
                   FROM MovementItem
                        INNER JOIN MovementItemFloat AS MIFloat_SummCardRecalc
                                                     ON MIFloat_SummCardRecalc.MovementItemId = MovementItem.Id
                                                    AND MIFloat_SummCardRecalc.DescId = zc_MIFloat_SummCardRecalc()
                   WHERE MovementItem.MovementId = vbMovementId_PersonalService
                     AND MovementItem.DescId = zc_MI_Master()
                  )
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
                                                             , inPersonalId         := tmp.PersonalId
                                                             , inAmount             := 1 * COALESCE (tmp.Amount, 0)
                                                             , inServiceDate        := vbServiceDate
                                                             , inComment            := ''
                                                             , inInfoMoneyId        := tmp.InfoMoneyId
                                                             , inUnitId             := tmp.UnitId
                                                             , inPositionId         := tmp.PositionId
                                                             , inUserId             := inUserId
                                                              )
     FROM (SELECT MovementItem.ObjectId            AS PersonalId
                , MILinkObject_Unit.ObjectId       AS UnitId
                , MILinkObject_Position.ObjectId   AS PositionId
                , MILinkObject_InfoMoney.ObjectId  AS InfoMoneyId
                , MIFloat_SummCardRecalc.ValueData AS Amount
           FROM MovementItem
                LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                 ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                 ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                 ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
                LEFT JOIN MovementItemFloat AS MIFloat_SummCardRecalc
                                            ON MIFloat_SummCardRecalc.MovementItemId = MovementItem.Id
                                           AND MIFloat_SummCardRecalc.DescId = zc_MIFloat_SummCardRecalc()
           WHERE MovementItem.MovementId = vbMovementId_PersonalService
             AND MovementItem.DescId = zc_MI_Master()
             AND MovementItem.isErased = FALSE
          ) AS tmp;

    -- сохранили связь с документом <Начисление зарплаты>
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
