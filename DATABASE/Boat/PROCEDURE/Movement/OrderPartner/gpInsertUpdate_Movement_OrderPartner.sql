-- Function: gpInsertUpdate_Movement_OrderPartner()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderPartner(Integer, TVarChar, TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, TFloat
                                                           , Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderPartner(Integer, TVarChar, TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, TFloat
                                                           , Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderPartner(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inInvNumberPartner    TVarChar  , -- Номер документа (внешний)
    IN inOperDate            TDateTime , -- Дата документа
    IN inOperDatePartner     TDateTime , -- Дата поставки
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent          TFloat    , --
    IN inDiscountTax         TFloat    , --
    IN inDiscountNextTax     TFloat    , --
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому
    IN inPaidKindId          Integer   , -- ФО
    IN inMovementId_Invoice  Integer   , -- Счет
    IN inComment             TVarChar  , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOldContractId Integer;
   DECLARE vbDeferment Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderPartner());
    vbUserId := lpGetUserBySession (inSession);

    --    
    ioId := lpInsertUpdate_Movement_OrderPartner(ioId
                                               , inInvNumber, inInvNumberPartner
                                               , inOperDate, inOperDatePartner
                                               , inPriceWithVAT
                                               , inVATPercent
                                               , inDiscountTax, inDiscountNextTax
                                               , inFromId, inToId
                                               , inPaidKindId
                                               , inMovementId_Invoice
                                               , inComment
                                               , vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.06.21         *
 12.04.21         *
*/

-- тест
--