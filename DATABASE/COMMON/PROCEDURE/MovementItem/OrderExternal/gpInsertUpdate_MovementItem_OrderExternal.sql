-- Function: gpInsertUpdate_MovementItem_OrderExternal()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderExternal (Integer, Integer, Integer, TFloat, TFloat, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_OrderExternal(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inAmountSecond        TFloat    , -- Количество дозаказ
    IN inGoodsKindId         Integer   , -- Виды товаров
 INOUT ioPrice               TFloat    , -- Цена
 INOUT ioCountForPrice       TFloat    , -- Цена за количество
   OUT outAmountSumm         TFloat    , -- Сумма расчетная
   OUT outMovementPromo      TVarChar  , --
   OUT outPricePromo         TFloat    , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId_Promo Integer;
   DECLARE vbOperDate_StartBegin TDateTime;
   DECLARE vbPartnerId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     IF EXISTS (SELECT 1
                FROM MovementLinkObject AS MLO
                     JOIN Object ON Object.Id = MLO.ObjectId AND Object.DescId = zc_Object_Unit()
                WHERE MLO.MovementId = inMovementId
                  AND MLO.DescId     = zc_MovementLinkObject_From()
               )
     THEN
         -- так для zc_Object_Unit
         vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderExternalUnit());
     ELSE
         -- для остальных
         vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderExternal());
     END IF;


     -- сразу запомнили время начала выполнения Проц.
     vbOperDate_StartBegin:= CLOCK_TIMESTAMP();


      --
      vbPartnerId:= (SELECT CASE WHEN Object.DescId = zc_Object_Unit() THEN 0 ELSE MLO.ObjectId END FROM MovementLinkObject AS MLO LEFT JOIN Object ON Object.Id = MLO.ObjectId WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From());

     -- Проверка zc_ObjectBoolean_GoodsByGoodsKind_Order
     IF EXISTS (SELECT 1
                FROM MovementLinkObject AS MLO
                WHERE MLO.MovementId = inMovementId
                  AND MLO.DescId = zc_MovementLinkObject_To()
                  AND MLO.ObjectId IN (SELECT tt.UnitId FROM Object_Unit_check_isOrder_View_two AS tt)
               )
AND NOT EXISTS (SELECT 1
                FROM MovementLinkObject AS MLO
                     INNER JOIN ObjectString AS ObjectString_GLNCode
                                             ON ObjectString_GLNCode.ObjectId  = MLO.ObjectId
                                            AND ObjectString_GLNCode.DescId    IN (zc_ObjectString_Partner_GLNCode(), zc_ObjectString_Partner_GLNCodeJuridical())
                                            AND ObjectString_GLNCode.ValueData <> ''
                WHERE MLO.MovementId = inMovementId
                  AND MLO.DescId = zc_MovementLinkObject_From()
               )
AND (NOT EXISTS (SELECT 1
                 FROM ObjectLink AS OL
                      INNER JOIN ObjectLink AS OL_Juridical_Retail
                                            ON OL_Juridical_Retail.ObjectId = OL.ChildObjectId 
                                           AND OL_Juridical_Retail.DescId   =  zc_ObjectLink_Juridical_Retail()
                                           AND OL_Juridical_Retail.ChildObjectId = 310854 -- Фоззі
                 WHERE OL.ObjectId   = vbPartnerId
                   AND OL.DescId     = zc_ObjectLink_Partner_Juridical()
                   AND inGoodsId     = 9505524 -- 457 - Сосиски ФІЛЕЙКИ вар 1 ґ ТМ Наші Ковбаси
                   AND inGoodsKindId = 8344    -- Б/В 0,5кг
                )
     OR (vbPartnerId = 0
     AND inGoodsId     = 9505524 -- 457 - Сосиски ФІЛЕЙКИ вар 1 ґ ТМ Наші Ковбаси
     AND inGoodsKindId = 8344    -- Б/В 0,5кг
        )
    )
-- AND vbUserId = 5
     THEN
         -- если товара и вид товара нет в zc_ObjectBoolean_GoodsByGoodsKind_Order - тогда ошиибка
          IF NOT EXISTS (SELECT 1
                         FROM ObjectBoolean AS ObjectBoolean_Order
                              INNER JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.Id = ObjectBoolean_Order.ObjectId
                         WHERE ObjectBoolean_Order.ValueData = TRUE
                           AND ObjectBoolean_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                           AND Object_GoodsByGoodsKind_View.GoodsId = inGoodsId
                           AND COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) = COALESCE (inGoodsKindId,0)
                        )  
               AND EXISTS (SELECT 1 FROM ObjectLink AS OL
                                    WHERE OL.ObjectId = inGoodsId
                                      AND OL.DescId   = zc_ObjectLink_Goods_InfoMoney()
                                      AND OL.ChildObjectId IN (zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                           --, zc_Enum_InfoMoney_30102() -- Тушенка
                                                             , zc_Enum_InfoMoney_20901() -- Ирна
                                                              )
                          )
         THEN
              RAISE EXCEPTION 'Ошибка.У товара <%>%<%>%не установлено свойство <Используется в заявках>=Да.% % № % от % % %'
                             , lfGet_Object_ValueData (inGoodsId)
                             , CHR (13)
                             , lfGet_Object_ValueData_sh (inGoodsKindId)
                             , CHR (13)
                             , CHR (13)
                             , (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_OrderExternal())
                             , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                             , zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId))
                             , CHR (13)
                             , (SELECT lfGet_Object_ValueData_sh (MLO.ObjectId) FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To())
                              ;
         END IF;
     END IF;


     -- сохранили
     SELECT tmp.ioId, tmp.ioPrice, tmp.ioCountForPrice, tmp.outAmountSumm
          , zfCalc_PromoMovementName (tmp.outMovementId_Promo, NULL, NULL, NULL, NULL)
          , tmp.outPricePromo
            INTO ioId, ioPrice, ioCountForPrice, outAmountSumm, outMovementPromo, outPricePromo
     FROM lpInsertUpdate_MovementItem_OrderExternal (ioId                 := ioId
                                                   , inMovementId         := inMovementId
                                                   , inGoodsId            := inGoodsId
                                                   , inAmount             := inAmount
                                                   , inAmountSecond       := inAmountSecond
                                                   , inGoodsKindId        := inGoodsKindId
                                                   , ioPrice              := ioPrice
                                                   , ioCountForPrice      := ioCountForPrice
                                                   , inUserId             := vbUserId
                                                    ) AS tmp;

     -- дописали св-во <Протокол Дата/время начало>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_StartBegin(), ioId, vbOperDate_StartBegin);
     -- дописали св-во <Протокол Дата/время завершение>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_EndBegin(), ioId, CLOCK_TIMESTAMP());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.10.14                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_OrderExternal (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
