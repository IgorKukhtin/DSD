-- Function: lpInsertUpdate_MovementItem_ReturnIn()

-- DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, Integer, Integer);
-- DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, Integer, Integer, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, Integer, Integer, TFloat, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_ReturnIn(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ Возврат покупателя>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inAmountPartner       TFloat    , -- Количество у контрагента
 INOUT ioPrice               TFloat    , -- Цена
 INOUT ioCountForPrice       TFloat    , -- Цена за количество
   OUT outAmountSumm         TFloat    , -- Сумма расчетная
    IN inHeadCount           TFloat    , -- Количество голов
    IN inMovementId_Partion  Integer   , -- Id документа продажи
    IN inPartionGoods        TVarChar  , -- Партия товара
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inAssetId             Integer   , -- Основные средства (для которых закупается ТМЦ)
 INOUT ioMovementId_Promo    Integer   ,
 INOUT ioChangePercent       TFloat    , -- (-)% Скидки (+)% Наценки
   OUT outPricePromo         TFloat    ,
    IN inIsCheckPrice        Boolean   , -- 
    IN inUserId              Integer     -- сессия пользователя
)
RETURNS RECORD AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка
     IF COALESCE (inGoodsId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Товар не определен.';
     END IF;


     -- параметры акции - на "Дата накладной у контрагента"
     SELECT tmp.MovementId
          , CASE WHEN tmp.isChangePercent = TRUE
                      THEN COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_ChangePercent()), 0)
                 ELSE 0
            END
          , ioPrice
            INTO ioMovementId_Promo, ioChangePercent, outPricePromo
     FROM lpGet_Movement_Promo_Data_all (inOperDate     := (SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId AND MovementDate.DescId = zc_MovementDate_OperDatePartner())
                                       , inPartnerId    := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From())
                                       , inContractId   := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                       , inUnitId       := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To())
                                       , inGoodsId      := inGoodsId
                                       , inGoodsKindId  := inGoodsKindId
                                       , inIsReturn     := TRUE
                                        ) AS tmp
     -- !!!только если соответствует цена!!!
     WHERE ioPrice = CASE WHEN TRUE = (SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_PriceWithVAT())
                               THEN tmp.PriceWithVAT
                          WHEN 1=1
                               THEN tmp.PriceWithOutVAT
                          ELSE 0 -- ???может надо будет взять из прайса когда была акция ИЛИ любой продажи под эту акцию???
                     END
    ;
     -- !!!в этом случае - всегда из документа!!!
     IF zc_isReturnInNAL_bySale() > (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId)
        OR COALESCE (ioMovementId_Promo, 0) = 0
     THEN ioChangePercent:= COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_ChangePercent()), 0); END IF;
     

     -- 
   /*IF COALESCE (ioMovementId_Promo, 0) = 0 AND inIsCheckPrice = TRUE
     THEN
          -- !!!замена!!!
          ioPrice:= lpGet_ObjectHistory_Price_check (inMovementId            := inMovementId
                                                   , inMovementItemId        := ioId
                                                   , inContractId            := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                                   , inPartnerId             := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From())
                                                   , inMovementDescId        := zc_Movement_ReturnIn()
                                                   , inOperDate_order        := NULL
                                                   , inOperDatePartner       := (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_OperDatePartner()) 
                                                   , inDayPrior_PriceReturn  := 14
                                                   , inIsPrior               := FALSE -- !!!отказались от старых цен!!!
                                                   , inOperDatePartner_order := NULL
                                                   , inGoodsId               := inGoodsId
                                                   , inGoodsKindId           := inGoodsKindId
                                                   , inPrice                 := ioPrice
                                                   , inCountForPrice         := 1
                                                   , inUserId                := inUserId
                                                    );
     END IF;*/


     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- сохранили свойство <Количество у контрагента>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), ioId, inAmountPartner);

     -- сохранили свойство <Цена>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, ioPrice);
     -- сохранили свойство <Цена за количество>
     IF COALESCE (ioCountForPrice, 0) = 0 THEN ioCountForPrice := 1; END IF;
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, ioCountForPrice);

     -- сохранили свойство <Количество голов>
     -- PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_HeadCount(), ioId, inHeadCount);

     -- сохранили свойство <id документа продажи>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), ioId, inMovementId_Partion);



     -- !!!запуск новой схемы - НАЛ с привязкой к продажам!!!
     -- сохранили свойство <(-)% Скидки (+)% Наценки> 
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), ioId, ioChangePercent);
     -- сохранили свойство <MovementId-Акция>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PromoMovementId(), ioId, COALESCE (ioMovementId_Promo, 0));



     -- сохранили свойство <Партия товара>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), ioId, inPartionGoods);

     -- сохранили связь с <Виды товаров>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);

     -- сохранили связь с <Основные средства (для которых закупается ТМЦ)>
     -- PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Asset(), ioId, inAssetId);

     /*IF inGoodsId <> 0
     THEN
         -- создали объект <Связи Товары и Виды товаров>
         PERFORM lpInsert_Object_GoodsByGoodsKind (inGoodsId, inGoodsKindId, inUserId);
     END IF;*/

     -- расчитали сумму по элементу, для грида
     outAmountSumm := CASE WHEN ioCountForPrice > 0
                                THEN CAST (inAmountPartner * ioPrice / ioCountForPrice AS NUMERIC (16, 2))
                           ELSE CAST (inAmountPartner * ioPrice AS NUMERIC (16, 2))
                      END;

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     IF 1 = 1 -- NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
         -- сохранили протокол
         PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Манько Д.А.
 27.04.15         * add inMovementId
 11.05.14                                        * change ioCountForPrice
 07.05.14                                        * add lpInsert_MovementItemProtocol
 08.04.14                                        * rem создали объект <Связи Товары и Виды товаров>
 14.02.14                                                         * add ioCountForPrice
 13.02.14                         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItem_ReturnIn (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, ioPrice:= 1, ioCountForPrice:= 1, outAmountSumm:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
