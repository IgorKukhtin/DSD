-- Function: lpInsertUpdate_Movement_Invoice()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Invoice (Integer, TVarChar, TDateTime, TDateTime, TFloat, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Invoice (Integer, TVarChar, TDateTime, TDateTime, TFloat, TFloat, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Invoice (Integer, TVarChar, TDateTime, TDateTime, TFloat, TFloat, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Invoice (Integer, Integer, TVarChar, TDateTime, TDateTime, TFloat, TFloat, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Invoice(
 INOUT ioId               Integer  ,  --
    IN inParentId         Integer  ,  --
    IN inInvNumber        TVarChar ,  -- Номер документа
    IN inOperDate         TDateTime,  --
    IN inPlanDate         TDateTime,  -- Плановая дата оплаты по Счету
    IN inVATPercent       TFloat   ,  --
    IN inAmount           TFloat   ,  -- 
    IN inInvNumberPartner TVarChar ,  -- 
    IN inReceiptNumber    TVarChar ,  -- 
    IN inComment          TVarChar ,  -- 
    IN inObjectId         Integer  ,  -- 
    IN inUnitId           Integer  ,  -- 
    IN inInfoMoneyId      Integer  ,  -- 
    IN inPaidKindId       Integer  ,  -- 
    IN inUserId           Integer      -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка - свойство должно быть установлено
     IF COALESCE (inObjectId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не определено значение <Lieferanten / Kunden>.';
     END IF;

     -- проверка - свойство должно быть установлено
     IF COALESCE (inInfoMoneyId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не определено значение <УП статья назначения>.';
     END IF;

      
    -- определяем признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    -- inReceiptNumber формируется только для Amount > 0
    IF COALESCE (inAmount, 0) <= 0
    THEN
        inReceiptNumber := NULL;
    END IF;
     
    -- сначала Parent
    IF inParentId > 0
    THEN
         -- если меняют на другой документ
         IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = ioId AND Movement.ParentId > 0 AND Movement.ParentId <> inParentId)
         THEN
             -- в док. ParentId - это Заказ или Заказ - Обнуляем связь со счетом
             PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Invoice(), (SELECT Movement.ParentId FROM Movement WHERE Movement.Id = ioId), NULL);
         END IF;

         -- в док. ParentId - это Заказ или Заказ сохраняеем связь со счетом
         PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Invoice(), inParentId, ioId);
 
    -- если был счет
    ELSEIF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = ioId AND Movement.ParentId > 0)
    THEN
         -- в док. ParentId - это Заказ или Заказ - Обнуляем связь со счетом
         PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Invoice(), (SELECT Movement.ParentId FROM Movement WHERE Movement.Id = ioId), NULL);
    END IF;


    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Invoice(), inInvNumber, inOperDate, inParentId, 0);
    
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Object(), ioId, inObjectId);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_InfoMoney(), ioId, inInfoMoneyId);
 
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Plan(), ioId, inPlanDate);

    -- Сохранили свойство <% НДС>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), ioId, inVATPercent);
    -- Сохранили свойство <Итого Сумма>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Amount(), ioId, inAmount);
    
    -- Примечание
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);    
    -- Примечание
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_ReceiptNumber(), ioId, inReceiptNumber);
    -- Примечание
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

    
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
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.02.21         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_Invoice
