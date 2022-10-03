-- Function: gpInsertUpdate_MovementItem_ReturnIn_Partner()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ReturnIn_Partner (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ReturnIn_Partner (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ReturnIn_Partner(
 INOUT ioId                     Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId             Integer   , -- Ключ объекта <Документ Возврат покупателя>
    IN inGoodsId                Integer   , -- Товары
    IN inAmountPartner          TFloat    , -- Количество у контрагента
 INOUT ioPrice                  TFloat    , -- Цена
 INOUT ioCountForPrice          TFloat    , -- Цена за количество
   OUT outAmountSumm            TFloat    , -- Сумма расчетная
   OUT outAmountSummVat         TFloat    , -- Сумма с НДС расчетная  
    IN inCount                  TFloat    , -- Количество батонов или упаковок
    IN inHeadCount              TFloat    , -- Количество голов
    IN inPartionGoods           TVarChar  , -- Партия товара
    IN inGoodsKindId            Integer   , -- Виды товаров
    IN inAssetId                Integer   , -- Основные средства (для которых закупается ТМЦ)
    IN inMovementId_PartionTop  Integer   , -- Id документа продажи из шапки
    IN inMovementId_PartionMI   Integer   , -- Id документа продажи строчная часть
   OUT outMovementId_Partion    Integer   , --
   OUT outPartionMovementName   TVarChar  , --
   OUT outMovementPromo         TVarChar  , --
   OUT outMemberExpName         TVarChar  , -- Экспедитор из Заявки стронней
   OUT outChangePercent         TFloat    , -- (-)% Скидки (+)% Наценки
   OUT outPricePromo            TFloat    , --
   OUT outGoodsRealCode         Integer  , -- Товар (факт отгрузка)
   OUT outGoodsRealName         TVarChar  , -- Товар (факт отгрузка)
   OUT outGoodsKindRealName     TVarChar  , -- Вид товара (факт отгрузка)
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPriceWithVAT Boolean;
   DECLARE vbVATPercent TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ReturnIn_Partner());

     -- !!!меняется параметр!!!
     IF COALESCE (inMovementId_PartionMI, 0) = 0
     THEN
         inMovementId_PartionMI := COALESCE (inMovementId_PartionTop, 0);
     END IF;
     -- параметры документа inMovementId_PartionMI
     SELECT Movement_PartionMovement.Id AS MovementId_Partion
          , zfCalc_PartionMovementName (Movement_PartionMovement.DescId, MovementDesc_PartionMovement.ItemName, Movement_PartionMovement.InvNumber, MovementDate_OperDatePartner_PartionMovement.ValueData) AS PartionMovementName
            INTO outMovementId_Partion, outPartionMovementName
     FROM Movement AS Movement_PartionMovement
          LEFT JOIN MovementDesc AS MovementDesc_PartionMovement ON MovementDesc_PartionMovement.Id = Movement_PartionMovement.DescId
          LEFT JOIN MovementDate AS MovementDate_OperDatePartner_PartionMovement
                                 ON MovementDate_OperDatePartner_PartionMovement.MovementId =  Movement_PartionMovement.Id
                                AND MovementDate_OperDatePartner_PartionMovement.DescId = zc_MovementDate_OperDatePartner()
     WHERE Movement_PartionMovement.Id = inMovementId_PartionMI;



     -- Цена с НДС, % НДС
     SELECT MB_PriceWithVAT.ValueData , MF_VATPercent.ValueData
    INTO vbPriceWithVAT, vbVATPercent
     FROM MovementBoolean AS MB_PriceWithVAT
         LEFT JOIN MovementFloat AS MF_VATPercent
                                 ON MF_VATPercent.MovementId = MB_PriceWithVAT.MovementId
                                AND MF_VATPercent.DescId = zc_MovementFloat_VATPercent()
     WHERE MB_PriceWithVAT.MovementId = inMovementId
       AND MB_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT();


     -- сохранили <Элемент документа>
     SELECT tmp.ioId, tmp.ioPrice, tmp.ioCountForPrice, tmp.outAmountSumm
          , zfCalc_PromoMovementName (tmp.ioMovementId_Promo, NULL, NULL, NULL, NULL)
          , tmp.ioChangePercent
          , tmp.outPricePromo     
          , tmp.outGoodsRealCode, tmp.outGoodsRealName
          , tmp.outGoodsKindRealName
            INTO ioId, ioPrice, ioCountForPrice, outAmountSumm, outMovementPromo, outChangePercent, outPricePromo, outGoodsRealCode, outGoodsRealName, outGoodsKindRealName
     FROM lpInsertUpdate_MovementItem_ReturnIn (ioId                 := ioId
                                              , inMovementId         := inMovementId
                                              , inGoodsId            := inGoodsId
                                              , inAmount             := COALESCE ((SELECT Amount FROM MovementItem WHERE Id = ioId AND DescId = zc_MI_Master()), 0)
                                              , inAmountPartner      := inAmountPartner
                                              , ioPrice              := ioPrice
                                              , ioCountForPrice      := ioCountForPrice
                                              , inCount              := inCount
                                              , inHeadCount          := inHeadCount
                                              , inMovementId_Partion := inMovementId_PartionMI   --COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = ioId AND DescId = zc_MIFloat_MovementId()), 0) :: Integer
                                              , inPartionGoods       := inPartionGoods
                                              , inGoodsKindId        := inGoodsKindId
                                              , inAssetId            := inAssetId
                                              , ioMovementId_Promo   := NULL
                                              , ioChangePercent      := NULL
                                              , inIsCheckPrice       := TRUE
                                              , inUserId             := vbUserId
                                               ) AS tmp;

    -- Вернули - Сумма с НДС расчетная
    outAmountSummVat:= CASE WHEN ioCountForPrice > 0
                            THEN CASE WHEN vbPriceWithVAT = TRUE THEN CAST(ioPrice * inAmountPartner/ioCountForPrice AS NUMERIC (16, 2))
                                                                 ELSE CAST( (( (1 + vbVATPercent / 100)* ioPrice) * inAmountPartner/ioCountForPrice) AS NUMERIC (16, 2))
                                 END
                            ELSE CASE WHEN vbPriceWithVAT = TRUE THEN CAST(ioPrice * inAmountPartner AS NUMERIC (16, 2))
                                                                 ELSE CAST( (((1 + vbVATPercent / 100)* ioPrice) * inAmountPartner) AS NUMERIC (16, 2) )
                                 END
                        END;


    -- формируется - Экспедитор из "Заявка сторонняя от покупателя"
    IF inMovementId_PartionMI > 0 AND NOT EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_MemberExp() AND MLO.ObjectId > 0)
    THEN
        PERFORM lpUpdate_Movement_ReturnIn_MemberExp (inMovementId := inMovementId
                                                    , inUserId     := vbUserId
                                                      );
    END IF;

    -- Вернули "Экспедитор из Заявки стронней"
    outMemberExpName := COALESCE((SELECT Object_MemberExp.ValueData AS MemberExpName
                                  FROM MovementLinkObject AS MovementLinkObject_MemberExp
                                       LEFT JOIN Object AS Object_MemberExp ON Object_MemberExp.Id = MovementLinkObject_MemberExp.ObjectId
                                  WHERE MovementLinkObject_MemberExp.MovementId = inMovementId
                                    AND MovementLinkObject_MemberExp.DescId     = zc_MovementLinkObject_MemberExp()
                                  ), '') :: TVarChar;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Манько Д.А.
 22.04.16         *
 05.11.14                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_ReturnIn_Partner (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, ioPrice:= 1, ioCountForPrice:= 1 , inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
