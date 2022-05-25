-- Function: gpUpdate_Movement_Cash_Child()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Cash_Child (Integer, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Cash_Child(
    IN inMI_Id                Integer   , -- идентификатор строки
    IN inServiceDate          TDateTime , -- Дата начисления
    IN inUnitId               Integer   , -- отдел
    IN inInfoMoneyId          Integer   , -- Статьи
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbMovementItemId Integer;
BEGIN

     -- проверка
     IF COALESCE (inInfoMoneyId, 0) = 0
     THEN
        RAISE EXCEPTION 'Ошибка.<Статья> не выбрана.';
     END IF;

     -- расчет - 1-ое число месяца
     inServiceDate:= DATE_TRUNC ('MONTH', inServiceDate);
     /*
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), inMI_Id, inUnitId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), inMI_Id, inInfoMoneyId);

     -- сохранили свойство <Дата начисления>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ServiceDate(), inMI_Id, inServiceDate);

 
     -- сохранили свойство <Дата корректировки>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), inMI_Id, CURRENT_TIMESTAMP);
     -- сохранили свойство <Пользователь (корректировка)>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), inMI_Id, inUserId);
    
     
     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inMI_Id, inUserId, vbIsInsert);
    */
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.05.22         *
 */

-- тест
--