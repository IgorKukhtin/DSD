-- Function: gpInsertUpdate_Movement_TaxCorrective()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TaxCorrective (Integer, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TaxCorrective (Integer, TVarChar, TVarChar, TVarChar, TDateTime, Boolean, Boolean, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TaxCorrective(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inInvNumberPartner    TVarChar  , -- Номер налогового документа
    IN inInvNumberBranch     TVarChar  , -- Номер филиала
    IN inOperDate            TDateTime , -- Дата документа
    IN inChecked             Boolean   , -- Проверен
    IN inDocument            Boolean   , -- Есть ли подписанный документ
    IN inPriceWithVAT        Boolean   , -- Цена с НДС (да/нет)
    IN inVATPercent          TFloat    , -- % НДС
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inPartnerId           Integer   , -- Контрагент
    IN inContractId          Integer   , -- Договора
    IN inDocumentTaxKindId   Integer   , -- Тип формирования налогового документа
    IN inComment             TVarChar  , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TaxCorrective());

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_TaxCorrective(ioId, inInvNumber, inInvNumberPartner, inInvNumberBranch, inOperDate
                                                 , inChecked, inDocument, inPriceWithVAT, inVATPercent
                                                 , inFromId, inToId, inPartnerId, inContractId, inDocumentTaxKindId, vbUserId);

     -- создаем "виртуальный элемент"
     IF inDocumentTaxKindId = zc_Enum_DocumentTaxKind_Prepay()
       AND NOT EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.isErased = FALSE) -- AND ObjectId = inDocumentTaxKindId
     THEN
         PERFORM lpInsertUpdate_MovementItem_TaxCorrective (ioId                 := 0
                                                          , inMovementId         := ioId
                                                          , inGoodsId            := 2117  -- inDocumentTaxKindId
                                                          , inAmount             := 0
                                                          , inPrice              := 0
                                                          , inPriceTax_calc      := 0
                                                          , ioCountForPrice      := 1
                                                          , inGoodsKindId        := zc_GoodsKind_Basis() -- NULL
                                                          , inUserId             := vbUserId
                                                           );

     END IF;

     -- Комментарий
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 10.07.14                                        * add zc_Enum_DocumentTaxKind_Prepay
 24.04.14                                                       * add inInvNumberBranch
 19.03.14                                        * add inPartnerId
 11.02.14                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_TaxCorrective (ioId:= 0, inInvNumber:= '-1',inInvNumberPartner:= '-1', inOperDate:= '01.01.2013', inChecked:= FALSE, inDocument:=FALSE, inPriceWithVAT:= true, inVATPercent:= 20, inFromId:= 1, inToId:= 2, inContractId:= 0, inDocumentTaxKindId:= 0, inSession:= '2')
