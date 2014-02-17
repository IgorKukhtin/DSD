-- Function: gpInsertUpdate_MovementItem_ProfitLossService()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ProfitLossService(integer, integer, integer, tfloat, tvarchar, integer, integer, integer, integer, integer, integer, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ProfitLossService(integer, integer, integer, tfloat, tvarchar, integer, integer, integer, integer, integer, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ProfitLossService(
 INOUT ioId                      Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId              Integer   , -- Ключ объекта <Документ Начисления по Юридическому лицу (расходы будущих периодов)>
    IN inObjectId                Integer   , -- Юридические лица, Физические лица
    IN inAmount                  TFloat    , -- Сумма
    IN inComment                 TVarChar  , -- Комментарий
    IN inContractId              Integer   , -- Договор
    IN inContractConditionKindId Integer   , -- Типы условий договоров
    IN inInfoMoneyId             Integer   , -- Статьи назначения
    IN inUnitId                  Integer   , -- Подразделение
    IN inPaidKindId              Integer   , -- Виды форм оплаты
   OUT outBranchName             TVarChar  , -- Филиал
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbBranchId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ProfitLossService());

     -- проверка - удаленный элемент документа не может корректироваться
     IF ioId <> 0 AND EXISTS (SELECT Id FROM MovementItem WHERE Id = ioId AND isErased = TRUE)
     THEN
         RAISE EXCEPTION 'Элемент не может корректироваться т.к. он <Удален>.';
     END IF;
--   определяем Филиал по подразделению
     SELECT Object_Branch.ValueData, Object_Branch.Id
     INTO outBranchName, vbBranchId
     FROM Object AS Object_Branch
     LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                          ON ObjectLink_Unit_Branch.ObjectId = inUnitId
                         AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()

     WHERE Object_Branch.Id =  ObjectLink_Unit_Branch.ChildObjectId
     ;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inObjectId, inMovementId, inAmount, NULL);

     -- сохранили свойство <Комментарий>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     -- сохранили связь с <Договор>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), ioId, inContractId);

     -- сохранили связь с <Типы условий договоров>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ContractConditionKind(), ioId, inContractConditionKindId);

     -- сохранили связь с <Статьи назначения>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioId, inInfoMoneyId);

     -- сохранили связь с <Подразделение>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);

     -- сохранили связь с <Виды форм оплаты>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PaidKind(), ioId, inPaidKindId);



     -- сохранили связь с <Филиал>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(), ioId, vbBranchId);

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);


     -- сохранили протокол
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 17.02.14                                                       *
*/


-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_ProfitLossService (ioId:= 0, inMovementId:= 10, inObjectId:= 1, inAmount:= 0, inComment:= 'test', inContractId:= 1, inContractConditionKindId:= 1, inInfoMoneyId:= 0, inUnitId:= 0, inPaidKindId:= 0, outBranchName:= '', inSession:= '2')