-- Function: gpInsertUpdate_Movement_Income()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Income 
    (Integer, TVarChar, TDateTime, Boolean, 
     Integer, Integer, Integer, Integer, Integer);

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Income 
    (Integer, TVarChar, TDateTime, Boolean, 
     Integer, Integer, Integer, Integer, TDateTime, Integer);

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Income 
    (Integer, TVarChar, TDateTime, Boolean, 
     Integer, Integer, Integer, Integer, TDateTime, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Income 
    (Integer, TVarChar, TDateTime, Boolean, 
     Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Income 
    (Integer, TVarChar, TDateTime, Boolean, 
     Integer, Integer, Integer, Integer, TDateTime, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Income (Integer, TVarChar, TDateTime, Boolean, Integer, Integer, Integer, Integer, Integer, TDateTime, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Income (Integer, TVarChar, TDateTime, Boolean, Integer, Integer, Integer, Integer, TDateTime, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Income (Integer, TVarChar, TDateTime, Boolean, Integer, Integer, Integer, Integer, TDateTime, Integer, Boolean, Boolean, TVarChar, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Income(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому
    IN inNDSKindId           Integer   , -- Типы НДС
    IN inContractId          Integer   , -- Договор
 -- IN inOrderId             Integer   , -- Сcылка на заявку поставщику 
    IN inPaymentDate         TDateTime , -- Дата платежа
    IN inJuridicalId         Integer   , -- Юрлицо покупатель
    IN inisDifferent         Boolean   , -- точка др. юр. лица
    IN inComment             TVarChar  , -- Примечание
    IN inisUseNDSKind        Boolean   , -- Использовать ставку НДС по приходу
    IN inUserId              Integer     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbInvNumberPoint Integer;
BEGIN

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Income(), inInvNumber, inOperDate, NULL);

     -- сохранили свойство <Цена с НДС (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), ioId, inPriceWithVAT);
     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);
     -- сохранили связь с <Типы НДС>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_NDSKind(), ioId, inNDSKindId);
     -- сохранили значение <НДС>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, (Select ValueData from ObjectFloat Where ObjectID = inNDSKindId AND DescId = zc_ObjectFloat_NDSKind_NDS()));

     -- сохранили связь с <Договор>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);
     -- 
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Payment(), ioId, inPaymentDate);

     -- сохранили связь с <Юрлицо покупатель>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), ioId, inJuridicalId);
     
     -- сохранили свойство <точка др. юр.лица>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Different(), ioId, inisDifferent);
     -- сохранили <Примечание>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);
     -- сохранили <Примечание>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_UseNDSKind(), ioId, inisUseNDSKind);

     -- сохранили связь с <документом заявка поставщику>
     --PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Order(), ioId, inOrderId);

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);


    -- !!!протокол через свойства конкретного объекта!!!
     IF vbIsInsert = FALSE
     THEN
         -- сохранили свойство <Дата корректировки>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- сохранили свойство <Пользователь (корректировка)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
     ELSE
         IF vbIsInsert = TRUE
         THEN
             -- сохранили свойство <Дата создания>
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
             -- сохранили свойство <Пользователь (создание)>
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
         END IF;
     END IF;


     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.  Шаблий О.В.
 14.04.20                                                                                    * UseNDSKind
 06.05.16         * del inOrderId
 22.04.16         *
 21.12.15                                                                       *
 07.12.15                                                                       *
 24.12.14                         *
 02.12.14                        *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Income (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inOperDateMark:= '01.01.2013', inInvNumberPartner:= 'xxx', inFromId:= 1, inPersonalId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
