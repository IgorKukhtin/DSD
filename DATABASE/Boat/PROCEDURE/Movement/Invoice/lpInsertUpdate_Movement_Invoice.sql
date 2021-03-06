-- Function: lpInsertUpdate_Movement_Invoice()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Invoice (Integer, TVarChar, TDateTime, TDateTime, TFloat, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Invoice(
 INOUT ioId               Integer  ,  --
    IN inInvNumber        TVarChar ,  -- Номер документа
    IN inOperDate         TDateTime,  --
    IN inPlanDate         TDateTime,  -- Дата оплаты
    IN inAmount           TFloat   ,  -- 
    IN inInvNumberPartner TVarChar ,  -- 
    IN inReceiptNumber    TVarChar ,  -- 
    IN inComment          TVarChar ,  -- 
    IN inObjectId         Integer  ,  -- 
    IN inUnitId           Integer  ,  -- 
    IN inInfoMoneyId      Integer  ,  -- 
    IN inProductId        Integer  ,  -- 
    IN inPaidKindId       Integer  ,  -- 
    IN inUserId           Integer      -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- проверка
    inOperDate:= DATE_TRUNC ('DAY', inOperDate);
      
    -- определяем признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    --inReceiptNumber формируется только для Amount>0
    IF COALESCE (inAmount, 0) <= 0
    THEN
        inReceiptNumber := NULL;
    END IF;
     
    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Invoice(), inInvNumber, inOperDate, NULL, 0);
    
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Object(), ioId, inObjectId);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Product(), ioId, inProductId);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_InfoMoney(), ioId, inInfoMoneyId);
 
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Plan(), ioId, inPlanDate);

    -- Сохранили свойство <Итого Сумма>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Amount(), ioId, inAmount);

    -- Примечание
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);    
    -- Примечание
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_ReceiptNumber(), ioId, inReceiptNumber);
    -- Примечание
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);
  
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 02.02.21         *
*/