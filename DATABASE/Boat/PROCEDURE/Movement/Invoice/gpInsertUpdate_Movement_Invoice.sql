-- Function: gpInsert_Movement_Invoice()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Invoice (Integer, TVarChar, TDateTime, TDateTime, TFloat, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Invoice(
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
    IN inSession          TVarChar     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;

    -- сохранили <Документ>
    PERFORM lpInsertUpdate_Movement_Invoice (ioId              := ioId
                                           , inInvNumber       := inInvNumber
                                           , inOperDate        := inOperDate
                                           , inPlanDate        := inPlanDate
                                           , inAmount          := inAmount :: Tfloat
                                           , inInvNumberPartner := inInvNumberPartner
                                           , inReceiptNumber   := inReceiptNumber
                                           , inComment         := inComment
                                           , inObjectId        := inObjectId
                                           , inUnitId          := inUnitId
                                           , inInfoMoneyId     := inInfoMoneyId
                                           , inProductId       := inProductId
                                           , inPaidKindId      := inPaidKindId
                                           , inUserId          := vbUserId
                                           );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.02.21         *

*/