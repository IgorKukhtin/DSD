-- Function: gpInsert_Movement_Sale_Mask()

DROP FUNCTION IF EXISTS gpInsert_Movement_Sale_Mask (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Sale_Mask(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ >
    IN inOperDate            TDateTime , -- Дата документа
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbMovementId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbInvNumber TVarChar;
   DECLARE vbAccessKeyId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Insert_Movement_Sale_mask());

     -- определяем ключ доступа !!!то что захардкоженно - временно!!!
     vbAccessKeyId:= zfGet_AccessKey_onUnit ((SELECT MLO.ObjectId
                                              FROM MovementLinkObject AS MLO
                                              WHERE MLO.MovementId = ioId
                                               AND MLO.DescId = zc_MovementLinkObject_From()) 
                                            , zc_Enum_Process_InsertUpdate_Movement_Sale_Partner()
                                            , vbUserId);
    
     -- сохранили <Документ>
     vbInvNumber := CAST (NEXTVAL ('movement_Sale_seq') AS TVarChar);
     vbMovementId := lpInsertUpdate_Movement (0, zc_Movement_Sale(), vbInvNumber, inOperDate, NULL, vbAccessKeyId, vbUserId);
         
     
   --  RAISE EXCEPTION 'Тест.Ок.<%> <%>',  vbInvNumber, vbMovementId;
     
    
     --Сохраняем документ
     PERFORM lpInsertUpdate_Movement_Sale (ioId                   := vbMovementId
                                         , inInvNumber            := vbInvNumber
                                         , inInvNumberPartner     := tmp.InvNumberPartner
                                         , inInvNumberOrder       := tmp.InvNumberOrder
                                         , inOperDate             := inOperDate
                                         , inOperDatePartner      := tmp.OperDatePartner
                                         , inChecked              := tmp.Checked
                                         , ioChangePercent        := tmp.ChangePercent
                                         , inFromId               := tmp.FromId
                                         , inToId                 := tmp.ToId
                                         , inPaidKindId           := tmp.PaidKindId
                                         , inContractId           := tmp.ContractId
                                         , inRouteSortingId       := tmp.RouteSortingId
                                         , inCurrencyDocumentId   := tmp.CurrencyDocumentId
                                         , inCurrencyPartnerId    := tmp.CurrencyPartnerId
                                         , inMovementId_Order     := tmp.MovementId_Order
                                         , inMovementId_ReturnIn  := tmp.MovementId_ReturnIn
                                         , ioPriceListId          := tmp.PriceListId
                                         , ioCurrencyPartnerValue := tmp.CurrencyPartnerValue
                                         , ioParPartnerValue      := tmp.ParPartnerValue
                                         , inUserId               := vbUserId
                                          )
     FROM gpGet_Movement_Sale (ioId, inOperDate, 0, inSession) AS tmp;
     --RAISE EXCEPTION 'Тест.Ок.<%> <%>',  vbInvNumber, vbMovementId;

     -- записываем строки SaleGoods документа
     PERFORM lpInsertUpdate_MovementItem_Sale (ioId                 := 0
                                             , inMovementId         := vbMovementId
                                             , inGoodsId            := tmp.GoodsId
                                             , inAmount             := COALESCE (tmp.Amount,0)::TFloat
                                             , inAmountPartner      := COALESCE (tmp.AmountPartner,0)::TFloat
                                             , inAmountChangePercent:= COALESCE (tmp.AmountChangePercent,0)::TFloat
                                             , inChangePercentAmount:= COALESCE (tmp.ChangePercentAmount,0)::TFloat
                                             , ioPrice              := COALESCE (tmp.Price,0)::TFloat
                                             , ioCountForPrice      := COALESCE (tmp.CountForPrice,0)::TFloat
                                             , inCount              := COALESCE (tmp.Count,0)::TFloat 
                                             , inHeadCount          := COALESCE (tmp.HeadCount,0)::TFloat
                                             , inBoxCount           := COALESCE (tmp.BoxCount,0)::TFloat
                                             , inPartionGoods       := tmp.PartionGoods
                                             , inGoodsKindId        := tmp.GoodsKindId
                                             , inAssetId            := tmp.AssetId
                                             , inBoxId              := tmp.BoxId
                                             , inCountPack          := COALESCE (tmp.CountPack,0)::TFloat
                                             , inWeightTotal        := COALESCE (tmp.WeightTotal,0)::TFloat
                                             , inWeightPack         := COALESCE (tmp.WeightPack,0)::TFloat
                                             , inIsBarCode          := tmp.IsBarCode
                                             , inUserId             := vbUserId
                                              )
      FROM gpSelect_MovementItem_Sale(inMovementId := ioId
                                    , inPriceListId := (SELECT MLO.ObjectId
                                                        FROM MovementLinkObject AS MLO
                                                        WHERE MLO.MovementId = ioId
                                                         AND MLO.DescId = zc_MovementLinkObject_PriceList())  
                                    , inOperDate := inOperDate ::TDateTime
                                    , inShowAll := False
                                    , inIsErased := False
                                    , inSession := inSession
                                    ) AS tmp;
 
 ioid := vbMovementId; 
   --if vbUserId = 9457 then RAISE EXCEPTION 'Тест.Ок.'; end if;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
  28.08.26        *
*/

-- тест
--
