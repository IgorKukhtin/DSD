-- Function: gpInsert_Movement_TransferDebtOutMask()

DROP FUNCTION IF EXISTS gpInsert_Movement_TransferDebtOut_Mask (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_TransferDebtOut_Mask(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ >
    IN inOperDate            TDateTime , -- Дата документа
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbMovementId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbPriceListId Integer;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TransferDebtOut());

     -- определим прайс-лист документа
     vbPriceListId := (SELECT tmp.PriceListId FROM gpGet_Movement_TransferDebtOut (ioId, 'False', inOperDate, inSession) AS tmp );
      
     -- сохранили <Документ>
     select lpInsertUpdate_Movement_TransferDebtOut (ioId               := 0
                                                   , inInvNumber        := CAST (NEXTVAL ('movement_TransferDebtOut_seq') AS TVarChar)
                                                   , inInvNumberPartner := '' ::TVarChar
                                                   , inInvNumberOrder   := '' ::TVarChar
                                                   , inOperDate         := inOperDate
                                                   , inChecked          := False
                                                   , ioPriceWithVAT     := tmp.PriceWithVAT
                                                   , ioVATPercent       := tmp.VATPercent
                                                   , inChangePercent    := COALESCE(tmp.ChangePercent, 0) ::TFloat
                                                   , inFromId           := tmp.FromId
                                                   , inToId             := tmp.ToId
                                                   , inPaidKindFromId   := tmp.PaidKindFromId
                                                   , inPaidKindToId     := tmp.PaidKindToId
                                                   , inContractFromId   := tmp.ContractFromId
                                                   , inContractToId     := tmp.ContractToId
                                                   , inPartnerId        := tmp.PartnerId
                                                   , inPartnerFromId    := tmp.PartnerFromId
                                                   , inUserId           := vbUserId
                                                    )
     INTO vbMovementId
     FROM gpGet_Movement_TransferDebtOut (ioId, 'False', inOperDate, inSession) AS tmp;

   -- записываем строки документа
   PERFORM lpInsertUpdate_MovementItem_TransferDebtOut  (ioId    := 0
                                          , inMovementId         := vbMovementId
                                          , inGoodsId            := tmp.GoodsId
                                          , inAmount             := COALESCE (tmp.Amount,0) ::TFloat
                                          , inPrice              := COALESCE (tmp.Price,0) ::TFloat
                                          , ioCountForPrice      := COALESCE (tmp.CountForPrice,0) ::TFloat
                                          , inBoxCount           := COALESCE (tmp.BoxCount,0) ::TFloat
                                          , inGoodsKindId        := tmp.GoodsKindId
                                          , inBoxId              := COALESCE (tmp.BoxId,0) ::integer
                                          , inUserId             := vbUserId
                                           )
   FROM gpSelect_MovementItem_TransferDebtOut (ioId, vbPriceListId, inOperDate, 'False', 'False', inSession)  AS tmp;
   
   -- записываем строки документа
   ioid := vbMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
  13.01.16        *
*/

-- тест
-- SELECT * FROM gpInsert_Movement_TransferDebtOut_Mask (ioId:= 0, ioInvNumber:= '-1',ioInvNumberPartner:= '-1', inOperDate:= '01.01.2013', inChecked:= FALSE, inDocument:=FALSE, inPriceWithVAT:= true, inVATPercent:= 20, inFromId:= 1, inToId:= 2, inContractId:= 0, inDocumentTransferDebtOutKind:= 0, inSession:= '2')
