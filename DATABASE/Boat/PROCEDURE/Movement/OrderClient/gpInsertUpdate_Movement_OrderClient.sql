-- Function: gpInsertUpdate_Movement_OrderClient()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderClient(Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderClient(Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderClient(Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderClient(Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderClient(Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderClient(Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat
                                                          , Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderClient(Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                          , Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderClient(Integer, TVarChar, TVarChar, TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                          , Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderClient(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inInvNumberPartner    TVarChar  , -- Номер документа (внешний)
    IN inOperDate            TDateTime , -- Дата документа
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent          TFloat    , --
    IN inDiscountTax         TFloat    , --
    IN inDiscountNextTax     TFloat    , -- 
 INOUT ioSummTax             TFloat    , -- Cумма откорректированной скидки, без НДС
 INOUT ioSummReal            TFloat    , -- ИТОГО откорректированная сумма, с учетом всех скидок, без Транспорта, Сумма продажи без НДС
    IN inTransportSumm_load  TFloat    , --транспорт
    --IN inNPP                 TFloat    , -- Очередность сборки
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому
    IN inPaidKindId          Integer   , -- ФО 
    IN inTaxKindId           Integer  ,  -- Тип НДС
    IN inProductId           Integer   , -- Лодка
    IN inMovementId_Invoice  Integer   , -- Счет
    IN inComment             TVarChar  , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderClient());
    vbUserId := lpGetUserBySession (inSession);

    --    
    SELECT tmp.ioId , tmp.ioSummTax, tmp.ioSummReal
           INTO ioId, ioSummTax, ioSummReal
    FROM lpInsertUpdate_Movement_OrderClient(ioId, inInvNumber, inInvNumberPartner
                                           , inOperDate
                                           , inPriceWithVAT
                                           , inVATPercent, inDiscountTax, inDiscountNextTax
                                           , ioSummTax, ioSummReal
                                           , inTransportSumm_load
                                           , inFromId, inToId
                                           , inPaidKindId
                                           , inProductId
                                           , inMovementId_Invoice
                                           , inComment
                                           , vbUserId
                                            ) AS tmp;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.04.24         * inTaxKindId
 01.06.23         * inTransportSumm_load
 15.02.21         *
*/

-- тест
--