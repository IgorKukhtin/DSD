-- Function: lpInsertUpdate_Movement_ChangeIncomePayment()
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ChangeIncomePayment 
    (Integer, TVarChar, TDateTime, TFloat, 
     Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_ChangeIncomePayment 
    (Integer, TVarChar, TDateTime, TFloat, 
     Integer, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_ChangeIncomePayment(
 INOUT ioId                                 Integer   , -- Ключ объекта <Документ изменения долга по приходам>
    IN inInvNumber                          TVarChar  , -- Номер документа
    IN inOperDate                           TDateTime , -- Дата документа
    IN inTotalSumm                          TFloat    , -- Сумма изменения долга
    IN inFromId                             Integer   , -- От кого (в документе)
    IN inJuridicalId                        Integer   , -- Для какого юрлица
    IN inChangeIncomePaymentKindId          Integer   , -- Типы изменения суммы долга
    IN inComment                            TVarChar  , -- Комментарий
    IN inUserId                             Integer     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_ChangeIncomePayment(), inInvNumber, inOperDate, NULL);

     -- сохранили значение <Сумма изменения долга>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), ioId, inTotalSumm);
     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- сохранили связь с <Юрлицо покупатель>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), ioId, inJuridicalId);
     -- сохранили связь с <Тип изменения суммы долга>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ChangeIncomePaymentKind(), ioId, inChangeIncomePaymentKindId);
     -- сохранили <Комментарий>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);
     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 10.12.15                                                                       *
 
*/