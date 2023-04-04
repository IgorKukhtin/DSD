-- Function: gpInsertUpdate_MovementItem_Inventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat,TFloat,TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat,TFloat,TFloat, TFloat,TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat,TFloat,TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Inventory(
 INOUT ioId                                 Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId                         Integer   , -- Ключ объекта <Документ>
    IN inGoodsId                            Integer   , -- Товары
    IN inPartionId                          Integer   , -- Партия
    IN inAmount                             TFloat    , -- Количество магазин - факт. остаток
    IN inAmountSecond                       TFloat    , -- Количество склад - факт. остаток
   OUT outAmountRemains                     TFloat    , -- Количество магазин - Расчетный остаток
   OUT outAmountSecondRemains               TFloat    , -- Количество склад - Расчетный остаток
   OUT outCountForPrice                     TFloat    , -- Цена за количество
   OUT outOperPrice                         TFloat    , -- Цена
   OUT outAmountSumm                        TFloat    , -- Сумма расчетная
   OUT outAmountSecondSumm                  TFloat    , -- Сумма расчетная (склад)
   OUT outAmountSummRemains                 TFloat    , -- Сумма расчетная остатка
   OUT outAmountSecondRemainsSumm           TFloat    , -- Сумма расчетная остатка (склад)
   OUT outOperPriceList                     TFloat    , -- Цена по прайсу
   OUT outAmountPriceListSumm               TFloat    , -- Сумма по прайсу
   OUT outAmountSecondPriceListSumm         TFloat    , -- Сумма по прайсу
   OUT outAmountPriceListSummRemains        TFloat    , -- Сумма по прайсу остатка
   OUT outAmountSecondRemainsPLSumm         TFloat    , -- Сумма по прайсу остатка

   OUT outAmountClient                      TFloat    , -- Количество у покупателя - Расчетный остаток
   OUT outAmountClientSumm                  TFloat    , -- сумма у покупателя - Расчетный остаток
   OUT outAmountClientPriceListSumm         TFloat    , -- сумма по прайсу у покупателя - Расчетный остаток

    IN inComment                            TVarChar  , -- примечание
   OUT outMessageText                       Text      ,
    IN inSession                            TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsInsert Boolean;
   DECLARE vbOperDate TDateTime;
   DECLARE vbFromId Integer;
   DECLARE vbToId Integer;
   DECLARE vbPartionId_find Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());


     --
     outMessageText:= 'Ошибка.';

     -- определяются параметры из документа
     SELECT Movement.OperDate
          , MovementLinkObject_From.ObjectId
          , MovementLinkObject_To.ObjectId
            INTO vbOperDate, vbFromId, vbToId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
     WHERE Movement.Id = inMovementId;



     -- данные из партии : OperPrice + CountForPrice + OperPriceList
     SELECT Object_PartionGoods.CountForPrice
          , Object_PartionGoods.OperPrice
          , Object_PartionGoods.OperPriceList
            INTO outCountForPrice, outOperPrice, outOperPriceList
     FROM Object_PartionGoods
     WHERE Object_PartionGoods.MovementItemId = inPartionId;


     outAmountRemains := 0;        -- вставить расчет
     outAmountSecondRemains := 0;  -- вставить расчет
     outAmountClient := 0;         -- вставить расчет


     -- нужен ПОИСК
     IF ioId < 0
     THEN
         -- нашли
         ioId:= (SELECT MI.Id FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.PartionId = inPartionId AND MI.isErased = FALSE);
         -- 
         inAmount:= inAmount + COALESCE ((SELECT MI.Amount FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.PartionId = inPartionId AND MI.isErased = FALSE), 0);

     END IF;
     

     -- проверка - Уникальный vbGoodsItemId
     IF EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.PartionId = inPartionId AND MI.Id <> COALESCE (ioId, 0) AND MI.isErased = FALSE) THEN
        RAISE EXCEPTION 'Ошибка.В документе уже есть Товар <% %> р.<%>.Дублирование запрещено.'
                      , lfGet_Object_ValueData_sh ((SELECT Object_PartionGoods.LabelId     FROM Object_PartionGoods WHERE Object_PartionGoods.GoodsId = inGoodsId AND Object_PartionGoods.MovementItemId = inPartionId))
                      , lfGet_Object_ValueData    ((SELECT Object_PartionGoods.GoodsId     FROM Object_PartionGoods WHERE Object_PartionGoods.GoodsId = inGoodsId AND Object_PartionGoods.MovementItemId = inPartionId))
                      , lfGet_Object_ValueData_sh ((SELECT Object_PartionGoods.GoodsSizeId FROM Object_PartionGoods WHERE Object_PartionGoods.GoodsId = inGoodsId AND Object_PartionGoods.MovementItemId = inPartionId))
                       ;
     END IF;

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа> - здесь <Остаток факт магазин>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inPartionId, inMovementId, inAmount, NULL);

     -- сохранили свойство <Остаток факт cклад>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSecond(), ioId, inAmountSecond);

     -- сохранили свойство <Цена>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), ioId, outOperPrice);
     -- сохранили свойство <Цена за количество>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, outCountForPrice);
     -- сохранили свойство <Цена (прайс)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), ioId, outOperPriceList);

     -- сохранили свойство <Остаток магазин>
     -- PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountRemains(), ioId, outAmountRemains);
     -- сохранили свойство <Остаток склад>
     -- PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSecondRemains(), ioId, outAmountSecondRemains);
     -- сохранили свойство <Остаток Покупатель>
     -- PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountClient(), ioId, outAmountClient);

     -- Остаток магазин
     outAmountRemains:= (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_AmountRemains());
     -- Остаток склад
     outAmountSecondRemains:= (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_AmountSecondRemains());
     -- Остаток Покупатель
     outAmountClient:= (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_AmountClient());

     -- сохранили свойство <примечание>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);


     -- расчитали сумму по элементу, для грида
     outAmountSumm := CASE WHEN outCountForPrice > 0
                                THEN CAST (inAmount * outOperPrice / outCountForPrice AS NUMERIC (16, 2))
                           ELSE CAST (inAmount * outOperPrice AS NUMERIC (16, 2))
                      END;
     outAmountSecondSumm := CASE WHEN outCountForPrice > 0
                                     THEN CAST (inAmountSecond * outOperPrice / outCountForPrice AS NUMERIC (16, 2))
                                 ELSE CAST (inAmountSecond * outOperPrice AS NUMERIC (16, 2))
                            END;
     outAmountSummRemains := CASE WHEN outCountForPrice > 0
                                      THEN CAST (outAmountRemains * outOperPrice / outCountForPrice AS NUMERIC (16, 2))
                                  ELSE CAST (outAmountRemains * outOperPrice AS NUMERIC (16, 2))
                             END;
     outAmountSecondRemainsSumm := CASE WHEN outCountForPrice > 0
                                            THEN CAST (outAmountSecondRemains * outOperPrice / outCountForPrice AS NUMERIC (16, 2))
                                        ELSE CAST (outAmountSecondRemains * outOperPrice AS NUMERIC (16, 2))
                                   END;
     outAmountClientSumm := CASE WHEN outCountForPrice > 0
                                      THEN CAST (outAmountClient * outOperPrice / outCountForPrice AS NUMERIC (16, 2))
                                 ELSE CAST (outAmountClient * outOperPrice AS NUMERIC (16, 2))
                            END;
     -- расчитали сумму по прайсу по элементу, для грида
     outAmountPriceListSumm := CASE WHEN outCountForPrice > 0
                                         THEN CAST (inAmount * outOperPriceList / outCountForPrice AS NUMERIC (16, 2))
                                    ELSE CAST (inAmount * outOperPriceList AS NUMERIC (16, 2))
                               END;
     outAmountSecondPriceListSumm := CASE WHEN outCountForPrice > 0
                                               THEN CAST (inAmountSecond * outOperPriceList / outCountForPrice AS NUMERIC (16, 2))
                                          ELSE CAST (inAmountSecond * outOperPriceList AS NUMERIC (16, 2))
                                     END;
     outAmountPriceListSummRemains := CASE WHEN outCountForPrice > 0
                                                THEN CAST (outAmountRemains * outOperPriceList / outCountForPrice AS NUMERIC (16, 2))
                                           ELSE CAST (outAmountRemains * outOperPriceList AS NUMERIC (16, 2))
                                      END;
     outAmountSecondRemainsPLSumm := CASE WHEN outCountForPrice > 0
                                               THEN CAST (outAmountSecondRemains * outOperPriceList / outCountForPrice AS NUMERIC (16, 2))
                                          ELSE CAST (outAmountSecondRemains * outOperPriceList AS NUMERIC (16, 2))
                                     END;
     outAmountClientPriceListSumm := CASE WHEN outCountForPrice > 0
                                               THEN CAST (outAmountClient * outOperPriceList / outCountForPrice AS NUMERIC (16, 2))
                                          ELSE CAST (outAmountClient * outOperPriceList AS NUMERIC (16, 2))
                                     END;
     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);
     
     --
     vbPartionId_find:= (SELECT MovementItem.PartionId FROM MovementItem WHERE MovementItem.Id = ioId);
     --
     outMessageText:= 'Элемент сохранен.'
                    || CHR (13)
                    || COALESCE ((SELECT 'Код : ' || zfConvert_FloatToString (Object_Goods.ObjectCode)
                                       || CHR (13)
                                       || lfGet_Object_ValueData_sh (Object_PartionGoods.LabelId)
                                       || CHR (13)
                                       || 'размер : ' || lfGet_Object_ValueData_sh (Object_PartionGoods.GoodsSizeId)
                                       || CHR (13)
                                       || lfGet_Object_ValueData_sh (Object_PartionGoods.PartnerId)
                                       || CHR (13)
                                       || 'Цена : ' || zfConvert_FloatToString (Object_PartionGoods.OperPriceList)
                                       || CHR (13)
                                       || 'Факт остаток : ' || zfConvert_FloatToString ((SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = ioId))
                                       || CHR (13)
                                       || 'Расч. остаток : ' || zfConvert_FloatToString (COALESCE (Container.Amount,0))
                                  FROM Object_PartionGoods
                                       LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = Object_PartionGoods.GoodsId
                                       LEFT JOIN Container ON Container.PartionId     = vbPartionId_find
                                                          AND Container.WhereObjectId = vbFromId
                                                          AND Container.DescId        = zc_Container_Count()
                                       LEFT JOIN ContainerLinkObject AS CLO_Client
                                                                     ON CLO_Client.ContainerId = Container.Id
                                                                    AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                                  WHERE Object_PartionGoods.MovementItemId = vbPartionId_find
                                    AND CLO_Client.ContainerId IS NULL
                                 ) , 'ОШИБКА!')
                    ;

    -- RAISE EXCEPTION 'Ошибка.', outMessageText;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.05.17         *
 02.05.17         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Inventory(ioId := 52 , inMovementId := 23 , inGoodsId := 406 , inPartionId := 49 , inAmount := 2 , inAmountSecond := 3 , inComment := '' ,  inSession := '2');
