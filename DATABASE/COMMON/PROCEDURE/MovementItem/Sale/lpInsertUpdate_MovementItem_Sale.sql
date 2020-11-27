-- Function: gpInsertUpdate_MovementItem_Sale()

-- DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale_BBB(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TFloat, TFloat, TFloat, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TFloat, TFloat, TFloat, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Sale(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inAmountPartner       TFloat    , -- Количество у контрагента
    IN inAmountChangePercent TFloat    , -- Количество c учетом % скидки
    IN inChangePercentAmount TFloat    , -- % скидки для кол-ва
 INOUT ioPrice               TFloat    , -- Цена
 INOUT ioCountForPrice       TFloat    , -- Цена за количество
   OUT outAmountSumm         TFloat    , -- Сумма расчетная
    IN inHeadCount           TFloat    , -- Количество голов
    IN inBoxCount            TFloat    , -- Количество ящиков
    IN inPartionGoods        TVarChar  , -- Партия товара
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inAssetId             Integer   , -- Основные средства (для которых закупается ТМЦ)
    IN inBoxId               Integer   , -- Ящики
    IN inCountPack           TFloat    , -- Количество упаковок (расчет)
    IN inWeightTotal         TFloat    , -- Вес 1 ед. продукции + упаковка
    IN inWeightPack          TFloat    , -- Вес упаковки для 1-ой ед. продукции
    IN inIsBarCode           Boolean   , -- По сканеру,  т.е. был рассчет скидки вес (на упаковку), при этом Amount - всегда расчетное
   OUT outMovementId_Promo   Integer   ,
   OUT outPricePromo         TFloat    ,
   IN inUserId              Integer     -- пользователь
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbPriceWithVAT Boolean;
   DECLARE vbChangePercent TFloat;
   DECLARE vbIsChangePercent_Promo Boolean;
   DECLARE vbTaxPromo TFloat;
   DECLARE vbCountForPricePromo TFloat;
   DECLARE vbPartnerId Integer;
   DECLARE vbMovementId_Order Integer;
BEGIN
     -- Заявка
     vbMovementId_Order:= (SELECT MLM.MovementChildId FROM MovementLinkMovement AS MLM WHERE MLM.MovementId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Order());
     -- Контрагент
     vbPartnerId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To());
     -- Цены с НДС
     vbPriceWithVAT:= (SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_PriceWithVAT());
     -- параметры акции
     SELECT tmp.MovementId, CASE WHEN tmp.TaxPromo <> 0 AND vbPriceWithVAT = TRUE THEN tmp.PriceWithVAT_orig
                                 WHEN tmp.TaxPromo <> 0 THEN tmp.PriceWithOutVAT_orig
                                 ELSE 0
                            END
          , tmp.CountForPrice
          , tmp.TaxPromo
          , tmp.isChangePercent
            INTO outMovementId_Promo, outPricePromo, vbCountForPricePromo, vbTaxPromo, vbIsChangePercent_Promo
     FROM lpGet_Movement_Promo_Data (inOperDate   := CASE WHEN vbMovementId_Order <> 0
                                                           AND TRUE = (SELECT ObjectBoolean_OperDateOrder.ValueData
                                                                       FROM ObjectLink AS ObjectLink_Juridical
                                                                            INNER JOIN ObjectLink AS ObjectLink_Retail
                                                                                                  ON ObjectLink_Retail.ObjectId = ObjectLink_Juridical.ChildObjectId
                                                                                                 AND ObjectLink_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                                            INNER JOIN ObjectBoolean AS ObjectBoolean_OperDateOrder
                                                                                                     ON ObjectBoolean_OperDateOrder.ObjectId = ObjectLink_Retail.ChildObjectId
                                                                                                    AND ObjectBoolean_OperDateOrder.DescId = zc_ObjectBoolean_Retail_OperDateOrder()
                                                                       WHERE ObjectLink_Juridical.ObjectId = vbPartnerId
                                                                         AND ObjectLink_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                                                      )
                                                                THEN (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_Order)
                                                          ELSE (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_OperDatePartner())
                                                     END
                                   , inPartnerId  := vbPartnerId
                                   , inContractId := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                   , inUnitId     := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From())
                                   , inGoodsId    := inGoodsId
                                   , inGoodsKindId:= inGoodsKindId) AS tmp;

     -- (-)% Скидки (+)% Наценки
     vbChangePercent:= CASE WHEN COALESCE (vbIsChangePercent_Promo, TRUE) = TRUE THEN COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_ChangePercent()), 0) ELSE 0 END;
     

     -- !!!замена для акции!!
     IF outMovementId_Promo > 0
     THEN
        IF NOT EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = outMovementId_Promo AND MB.DescId = zc_MovementBoolean_Promo() AND MB.ValueData = TRUE)
        THEN
              -- меняется значение - для Тенедер
             ioPrice:= outPricePromo;

        ELSEIF COALESCE (ioId, 0) = 0 AND vbTaxPromo <> 0
        THEN
              -- меняется значение
             ioPrice:= outPricePromo;
             ioCountForPrice:= vbCountForPricePromo;

        ELSE -- только проверка
             IF ioId <> 0 AND (ioPrice + 0.06) < outPricePromo AND vbTaxPromo <> 0
             THEN
                 RAISE EXCEPTION 'Ошибка.Для товара = <%> <%> необходимо ввести акционную цену = <%>.', lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData_sh (inGoodsKindId), zfConvert_FloatToString (outPricePromo);
             END IF;
        END IF;

     -- ELSE !!!обратно из прайса пока не реализовал!!!!
     END IF;

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- сохранили свойство <MovementId-Акция>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PromoMovementId(), ioId, COALESCE (outMovementId_Promo, 0));

     -- сохранили свойство <Количество у контрагента>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), ioId, inAmountPartner);
     -- сохранили свойство <Количество c учетом % скидки>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountChangePercent(), ioId, inAmountChangePercent);
     -- сохранили свойство <% скидки для кол-ва>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercentAmount(), ioId, inChangePercentAmount);
     -- сохранили свойство <(-)% Скидки (+)% Наценки>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), ioId, vbChangePercent);

     -- сохранили свойство <Цена>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, ioPrice);

     -- сохранили свойство <Цена за количество>
     IF COALESCE (ioCountForPrice, 0) = 0 THEN ioCountForPrice := 1; END IF;
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, ioCountForPrice);

     -- сохранили свойство <Количество голов>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_HeadCount(), ioId, inHeadCount);

     -- сохранили свойство <Количество ящиков>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_BoxCount(), ioId, inBoxCount);

     -- сохранили свойство <Партия товара>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), ioId, inPartionGoods);

     -- сохранили свойство <Количество упаковок (расчет)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountPack(), ioId, inCountPack);
     -- сохранили свойство <Вес 1 ед. продукции + упаковка>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTotal(), ioId, inWeightTotal);
     -- сохранили свойство <Вес упаковки для 1-ой ед. продукции>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightPack(), ioId, inWeightPack);

     -- сохранили свойство <По сканеру>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_BarCode(), ioId, inIsBarCode);


     -- сохранили связь с <Виды товаров>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);

     -- сохранили связь с <Основные средства (для которых закупается ТМЦ)>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Asset(), ioId, inAssetId);

     -- сохранили связь с <Ящики>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box(), ioId, inBoxId);

     IF inGoodsId <> 0
     THEN
         -- создали объект <Связи Товары и Виды товаров>
         PERFORM lpInsert_Object_GoodsByGoodsKind (inGoodsId, inGoodsKindId, inUserId);
     END IF;

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovemenTFloat_TotalSumm (inMovementId);

     -- расчитали сумму по элементу, для грида
     outAmountSumm := CASE WHEN ioCountForPrice > 0
                                THEN CAST (inAmountPartner * ioPrice / ioCountForPrice AS NUMERIC (16, 2))
                           ELSE CAST (inAmountPartner * ioPrice AS NUMERIC (16, 2))
                      END;

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 13.11.15                                        *
 10.10.14                                                       * add box
 07.05.14                                        * add lpInsert_MovementItemProtocol
 08.02.14                                        *
 04.02.14                         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItem_Sale (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, ioPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
