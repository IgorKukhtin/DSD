-- Function: gpInsertUpdate_MovementItem_SendPodium()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SendPodium (Integer, Integer, TVarChar, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SendPodium (Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_SendPodium(
 INOUT ioId                            Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId                    Integer   , -- Ключ объекта <Документ>
    IN inGoodsName                     TVarChar  , -- Товары
    IN inGoodsSizeName                 TVarChar  , -- Размер
 INOUT ioAmount                        TFloat    , -- Количество
   OUT outOperPrice                    TFloat    , -- Цена
   OUT outCountForPrice                TFloat    , -- Цена за количество
 INOUT ioOperPriceList                 TFloat    , -- Цена (прайс)
 INOUT ioOperPriceListTo_start         TFloat    , -- Цена печать ценников (прайс)(кому) --(для магазина получателя)
 INOUT ioOperPriceListTo               TFloat    , -- Цена (прайс)(кому) --(для магазина получателя)
   OUT outTotalSumm                    TFloat    , -- Сумма вх.
   OUT outTotalSummBalance             TFloat    , -- Сумма вх. (ГРН)
   OUT outTotalSummPriceList           TFloat    , -- Сумма по прайсу
   OUT outTotalSummPriceListTo         TFloat    , -- Сумма (Кому, прайс)
   OUT outTotalSummPriceListBalance    TFloat    , -- Сумма ГРН (От кого, прайс)
   OUT outTotalSummPriceListToBalance  TFloat    , -- Сумма ГРН (Кому, прайс)
   OUT outCurrencyValue                TFloat    , --
   OUT outParValue                     TFloat    , --
   OUT outGoodsSizeName                TVarChar  , --
    IN inSession                       TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbGoodsSizeId Integer;
   DECLARE vbPartionId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbOperDate TDateTime;
   DECLARE vbCurrencyId Integer;
   DECLARE vbCurrencyId_pl_to Integer;
   DECLARE vbFromId Integer;
   DECLARE vbToId Integer;
   DECLARE vbPriceListId_to Integer;
   DECLARE vbCurrencyValue_to TFloat;
   DECLARE vbParValue_to TFloat;

   DECLARE vbStartDate_plTo_find TDateTime;
   DECLARE vbOperPriceListTo_find TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());

     IF COALESCE (inGoodsName, '') = ''
     THEN 
         RETURN;
     END IF;
     
     -- проверка - документ должен быть сохранен
     IF COALESCE (inMovementId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Документ не сохранен.';
     END IF;
     -- проверка - свойство должно быть установлено
/*     IF COALESCE (inGoodsId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Товар>.';
     END IF;
     -- проверка - свойство должно быть установлено
     IF COALESCE (inPartionId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Партия>.';
     END IF;
*/
     -- проверка - свойство должно быть установлено
     IF COALESCE (ioAmount, 0) < 0 THEN
        RAISE EXCEPTION 'Ошибка.Кол-во не может быть меньше 0.';
     END IF;

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- !!!Замена!!!
     IF zc_Enum_GlobalConst_isTerry() = FALSE
     THEN
         IF vbIsInsert = TRUE AND ioAmount = 0 THEN ioAmount:= 1; END IF;
         --
         IF COALESCE (ioOperPriceListTo, 0) = 0 AND ioOperPriceListTo_start > 0
         THEN
             ioOperPriceListTo:= ioOperPriceListTo_start;
         END IF;
     END IF;

     -- определяем товар по inGoodsName
     SELECT MAX (Object.Id)
       INTO vbGoodsId
     FROM Object
     WHERE Object.DescId    = zc_Object_Goods()
       AND Object.ValueData = inGoodsName;
       
     IF COALESCE (vbGoodsId,0) = 0 
     THEN 
         RAISE EXCEPTION 'Ошибка.Не установлено значение <Товар>.';
     END IF;
       
     -- Дата документа, подразделение Кому, прайс для подразд. кому
     SELECT Movement.OperDate
          , MovementLinkObject_From.ObjectId AS FromId
          , MovementLinkObject_To.ObjectId   AS ToId
          , ObjectLink_Unit_PriceList_to.ChildObjectId AS PriceListId_to
          , COALESCE (ObjectLink_PriceList_Currency_to.ChildObjectId, zc_Currency_Basis()) AS CurrencyId_pl_to
            INTO vbOperDate, vbFromId, vbToId, vbPriceListId_to, vbCurrencyId_pl_to
     FROM Movement
         LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
         LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                      ON MovementLinkObject_To.MovementId = Movement.Id
                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
         LEFT JOIN ObjectLink AS ObjectLink_Unit_PriceList_to
                              ON ObjectLink_Unit_PriceList_to.ObjectId = MovementLinkObject_To.ObjectId
                             AND ObjectLink_Unit_PriceList_to.DescId = zc_ObjectLink_Unit_PriceList()

         LEFT JOIN ObjectLink AS ObjectLink_PriceList_Currency_to
                              ON ObjectLink_PriceList_Currency_to.ObjectId = ObjectLink_Unit_PriceList_to.ChildObjectId
                             AND ObjectLink_PriceList_Currency_to.DescId   = zc_ObjectLink_PriceList_Currency()
     WHERE Movement.Id = inMovementId;

     -- Цена (прайс)
     IF vbUserId = zc_User_Sybase()
     THEN
         -- !!!для SYBASE - потом убрать!!!
         IF 1=0 THEN RAISE EXCEPTION 'Ошибка.Параметр только для загрузки из Sybase.'; END IF;
     ELSE
         -- из Истории
         ioOperPriceList := COALESCE ((SELECT tmp.ValuePrice FROM lpGet_ObjectHistory_PriceListItem (vbOperDate
                                                                                                   , (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbFromId AND OL.DescId = zc_ObjectLink_Unit_PriceList())
                                                                                                   , vbGoodsId
                                                                                                    ) AS tmp), 0);
     END IF;

     -- проверка - свойство должно быть установлено
     IF COALESCE (ioOperPriceList, 0) <= 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Цена (прайс)>.';
     END IF;

     outGoodsSizeName :=inGoodsSizeName;
     
     -- Поиск Размера - ВСЕГДА
     vbGoodsSizeId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsSize() AND LOWER (Object.ValueData) = LOWER (inGoodsSizeName));
     --
     IF COALESCE (vbGoodsSizeId, 0) = 0
     THEN
         -- Создание
         vbGoodsSizeId := (SELECT tmp.ioId FROM gpInsertUpdate_Object_GoodsSize (ioId     := 0
                                                                               , ioCode   := 0
                                                                               , inName   := inGoodsSizeName
                                                                               , inSession:= vbUserId :: TVarChar
                                                                                 ) AS tmp);
     END IF;

     -- данные из партии : OperPrice и CountForPrice и CurrencyId
     SELECT COALESCE (Object_PartionGoods.CountForPrice, 1)                AS CountForPrice
          , COALESCE (Object_PartionGoods.OperPrice, 0)                    AS OperPrice
          , COALESCE (Object_PartionGoods.CurrencyId, zc_Currency_Basis()) AS CurrencyId
          , COALESCE (Object_PartionGoods.MovementItemId,0)                AS PartionId
    INTO outCountForPrice, outOperPrice, vbCurrencyId, vbPartionId
     FROM Object_PartionGoods
     WHERE Object_PartionGoods.GoodsId = vbGoodsId
       AND Object_PartionGoods.GoodsSizeId = vbGoodsSizeId; --Object_PartionGoods.MovementItemId = inPartionId;
     
     -- Если размер пусто и партия не найдена, тогда находим первый размер, что есть на остатке и подставляем его
     -- берем партию которая есть на остатке
     IF COALESCE (vbPartionId,0) = 0
     THEN
         SELECT COALESCE (Object_PartionGoods.CountForPrice, 1)                AS CountForPrice
              , COALESCE (Object_PartionGoods.OperPrice, 0)                    AS OperPrice
              , COALESCE (Object_PartionGoods.CurrencyId, zc_Currency_Basis()) AS CurrencyId
              , COALESCE (Object_PartionGoods.MovementItemId,0)                AS PartionId 
              , COALESCE (Object_GoodsSize.ValueData, '') ::TVarChar           AS GoodsSizeName
       INTO outCountForPrice, outOperPrice, vbCurrencyId, vbPartionId, outGoodsSizeName
         FROM (SELECT MIN ( Container.PartionId) AS PartionId
               FROM Container
                    LEFT JOIN ContainerLinkObject AS CLO_Client
                                                  ON CLO_Client.ContainerId = Container.Id
                                                 AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
               WHERE Container.WhereObjectId = vbFromId
                 AND Container.DescId = zc_Container_count()
                 AND COALESCE(Container.Amount, 0) <> 0
                 AND Container.ObjectId = vbGoodsId
                 AND COALESCE (Container.Amount,0) <> 0
                 AND CLO_Client.ContainerId IS NULL -- !!!отбросили Долги Покупателей!!!
               ) AS tmp
               LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = tmp.PartionId
               LEFT JOIN Object AS Object_GoodsSize ON Object_GoodsSize.Id = Object_PartionGoods.GoodsSizeId
         ;
     END IF; 

     -- если и после этого не найдена партия, то ошибка
     IF COALESCE (vbPartionId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не найдена партия товара.';
     END IF;
     
     
     -- Если НЕ Базовая Валюта
     IF vbCurrencyId <> zc_Currency_Basis()
     THEN
         -- Определили курс на Дату документа
         SELECT COALESCE (tmp.Amount, 1), COALESCE (tmp.ParValue, 0)
                INTO outCurrencyValue, outParValue
         FROM lfSelect_Movement_Currency_byDate (inOperDate      := vbOperDate
                                               , inCurrencyFromId:= zc_Currency_Basis()
                                               , inCurrencyToId  := vbCurrencyId
                                                ) AS tmp;
         -- проверка
         IF COALESCE (vbCurrencyId, 0) = 0 THEN
            RAISE EXCEPTION 'Ошибка.Не определено значение <Валюта>.';
         END IF;
         -- проверка
         IF COALESCE (outCurrencyValue, 0) = 0 THEN
            RAISE EXCEPTION 'Ошибка.Не определено значение <Курс>.';
         END IF;
         -- проверка
         IF COALESCE (outParValue, 0) = 0 THEN
            RAISE EXCEPTION 'Ошибка.Не определено значение <Номинал>.';
         END IF;

     ELSE
         -- курс не нужен
         outCurrencyValue:= 0;
         outParValue     := 0;
     END IF;


     -- !!!замена!!!
     IF EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.ObjectId = vbGoodsId AND MI.isErased = FALSE)
     AND 1=0
     THEN
         -- Цена печать ценников (прайс)(кому) --(для магазина получателя)
         ioOperPriceListTo_start:= (SELECT DISTINCT MIF.ValueData
                                    FROM MovementItem AS MI
                                         INNER JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MI.Id AND MIF.DescId = zc_MIFloat_OperPriceListTo_start()
                                    WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.ObjectId = vbGoodsId AND MI.isErased = FALSE
                                   );
         -- Цена (прайс)(кому) --(для магазина получателя)
         ioOperPriceListTo:= (SELECT DISTINCT MIF.ValueData
                              FROM MovementItem AS MI
                                   INNER JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MI.Id AND MIF.DescId = zc_MIFloat_OperPriceListTo()
                              WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.ObjectId = vbGoodsId AND MI.isErased = FALSE
                             );
     END IF;

     -- PriceListTo - start - если есть цена и прайс для подр. кому определен сохраняем цену
     IF COALESCE (vbPriceListId_to,0) <> 0 AND COALESCE (ioOperPriceListTo_start, 0) <> 0
     THEN
         -- найдем - из Истории
         SELECT COALESCE (lpGet.StartDate, zc_DateStart()) AS StartDate
              , COALESCE (lpGet.ValuePrice, 0 )            AS ValuePrice
                INTO vbStartDate_plTo_find, vbOperPriceListTo_find
         FROM (SELECT vbGoodsId AS GoodsId) AS tmp
              LEFT JOIN lpGet_ObjectHistory_PriceListItem (zc_DateStart()
                                                         , vbPriceListId_to
                                                         , vbGoodsId
                                                          ) AS lpGet ON 1=1;
         -- если нет цены или была такая же цена, т.е. её корректируют
         IF (COALESCE (vbOperPriceListTo_find, 0) = 0
             OR vbOperPriceListTo_find = (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_OperPriceListTo_start())
            )
            -- !!!временно
            AND vbToId = 6319 -- магазин Киев
         THEN
             PERFORM lpInsertUpdate_ObjectHistory_PriceListItem (ioId         := 0
                                                               , inPriceListId:= vbPriceListId_to
                                                               , inGoodsId    := vbGoodsId
                                                               , inOperDate   := vbStartDate_plTo_find
                                                               , inValue      := ioOperPriceListTo_start
                                                               , inUserId     := vbUserId
                                                                );
         ELSE
             -- иначе вернем ту что нашли
             ioOperPriceListTo_start:= vbOperPriceListTo_find;
         END IF;
     END IF;

     -- PriceListTo - если есть цена и прайс для подр. кому определен сохраняем цену
     IF COALESCE (vbPriceListId_to,0) <> 0 AND COALESCE (ioOperPriceListTo,0) <> 0
     THEN
         -- найдем - из Истории
         SELECT COALESCE (lpGet.StartDate, vbOperDate)     AS StartDate
              , COALESCE (lpGet.ValuePrice, 0 )            AS ValuePrice
                INTO vbStartDate_plTo_find, vbOperPriceListTo_find
         FROM (SELECT vbGoodsId AS GoodsId) AS tmp
              LEFT JOIN lpGet_ObjectHistory_PriceListItem (vbOperDate
                                                         , vbPriceListId_to
                                                         , vbGoodsId
                                                          ) AS lpGet ON 1=1;
         -- если нет цены или была такая же цена, т.е. её корректируют
         IF (vbOperPriceListTo_find = 0
          OR vbStartDate_plTo_find  = zc_DateStart()
          OR vbOperPriceListTo_find = (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_OperPriceListTo())
            )
          -- !!!временно
          AND vbToId = 6319 -- магазин Киев
         THEN
             PERFORM gpInsertUpdate_ObjectHistory_PriceListItemLast (ioId         := 0
                                                                   , inPriceListId:= vbPriceListId_to
                                                                   , inGoodsId    := vbGoodsId
                                                                   , inOperDate   := CASE WHEN vbStartDate_plTo_find = zc_DateStart() THEN vbOperDate ELSE vbStartDate_plTo_find END
                                                                   , inValue      := ioOperPriceListTo
                                                                   , inIsLast     := TRUE
                                                                   , inIsDiscountDelete:= FALSE
                                                                   , inSession    := inSession
                                                                    );
         ELSE
             -- иначе вернем ту что нашли
             ioOperPriceListTo:= vbOperPriceListTo_find;
         END IF;
     END IF;


     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), vbGoodsId, vbPartionId, inMovementId, ioAmount, NULL);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), ioId, outOperPrice);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), ioId, ioOperPriceList);

     IF zc_Enum_GlobalConst_isTerry() = FALSE
     THEN
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceListTo_start(), ioId, ioOperPriceListTo_start);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceListTo(), ioId, ioOperPriceListTo);
     END IF;


     -- сохранили свойство <Цена за количество>
     IF COALESCE (outCountForPrice, 0) = 0 THEN outCountForPrice := 1; END IF;
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, outCountForPrice);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CurrencyValue(), ioId, outCurrencyValue);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ParValue(), ioId, outParValue);

     -- расчитали сумму по элементу, для грида
     outTotalSumm := CASE WHEN outCountForPrice > 0
                               THEN CAST (ioAmount * outOperPrice / outCountForPrice AS NUMERIC (16, 2))
                          ELSE CAST (ioAmount * outOperPrice AS NUMERIC (16, 2))
                     END;

     -- определяем валюту для Кому из Прайс-листа - vbPriceListId_to
     vbCurrencyId_pl_to:= (SELECT COALESCE (OH_PriceListItem_Currency.ObjectId, vbCurrencyId_pl_to) AS CurrencyId
                           FROM ObjectLink AS OL_PriceListItem_Goods
                                INNER JOIN ObjectLink AS OL_PriceListItem_PriceList
                                                      ON OL_PriceListItem_PriceList.ObjectId      = OL_PriceListItem_Goods.ObjectId
                                                     AND OL_PriceListItem_PriceList.ChildObjectId = vbPriceListId_to
                                                     AND OL_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()
                                INNER JOIN ObjectHistory AS OH_PriceListItem
                                                         ON OH_PriceListItem.ObjectId = OL_PriceListItem_Goods.ObjectId
                                                        AND OH_PriceListItem.DescId   = zc_ObjectHistory_PriceListItem()
                                                        AND OH_PriceListItem.EndDate  = zc_DateEnd() -- !!!Последняя цена!!!
                                LEFT JOIN ObjectHistoryLink AS OH_PriceListItem_Currency
                                                            ON OH_PriceListItem_Currency.ObjectHistoryId = OH_PriceListItem.Id
                                                           AND OH_PriceListItem_Currency.DescId          = zc_ObjectHistoryLink_PriceListItem_Currency()
                                LEFT JOIN ObjectHistoryFloat AS OHF_Value
                                                             ON OHF_Value.ObjectHistoryId = OH_PriceListItem.Id
                                                            AND OHF_Value.DescId          = zc_ObjectHistoryFloat_PriceListItem_Value()
                           WHERE OL_PriceListItem_Goods.ChildObjectId = vbGoodsId
                             AND OL_PriceListItem_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
                          );

    -- получаем курс для Кому
    SELECT COALESCE (tmpCurrency.Amount, 1)   AS CurrencyValue
         , COALESCE (tmpCurrency.ParValue, 0) AS ParValue
           INTO vbCurrencyValue_to, vbParValue_to
    FROM lfSelect_Movement_Currency_byDate (inOperDate      := vbOperDate
                                          , inCurrencyFromId:= zc_Currency_Basis()
                                          , inCurrencyToId  := vbCurrencyId_pl_to
                                           ) AS tmpCurrency
                                            ;

     -- расчитали сумму вх. в грн по элементу, для грида
     outTotalSummBalance := (CAST (outTotalSumm * outCurrencyValue / CASE WHEN outParValue <> 0 THEN outParValue ELSE 1 END AS NUMERIC (16, 2))) ;


     -- расчитали сумму по прайсу по элементу, для грида
     outTotalSummPriceList := CAST ((ioAmount * ioOperPriceList) AS NUMERIC (16, 2));

     -- расчитали Сумма (Кому, прайс)
     outTotalSummPriceListTo := CAST ((ioAmount * ioOperPriceListTo) AS NUMERIC (16, 2));

     -- Сумма ГРН (От кого, прайс)
     outTotalSummPriceListBalance   := (CAST (outTotalSummPriceList * CASE WHEN vbCurrencyId = zc_Currency_Basis()
                                                                           THEN 1
                                                                           ELSE outCurrencyValue / CASE WHEN outParValue <> 0 THEN outParValue ELSE 1 END
                                                                      END AS NUMERIC (16, 2))) ;
     -- Сумма ГРН (Кому, прайс)
     outTotalSummPriceListToBalance := (CAST (outTotalSummPriceListTo * CASE WHEN vbCurrencyId_pl_to = zc_Currency_Basis()
                                                                             THEN 1
                                                                             ELSE vbCurrencyValue_to / CASE WHEN vbParValue_to <> 0 THEN vbParValue_to ELSE 1 END
                                                                        END AS NUMERIC (16, 2))) ;


     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.05.20         *
*/

-- тест
-- select * from gpInsertUpdate_MovementItem_SendPodium(ioId := 0 , inMovementId := 6540 , inGoodsName := '13801'::TVarChar , inGoodsSizeName := ''::TVarChar , ioAmount := 1::TFloat , ioOperPriceList := 250::TFloat , ioOperPriceListTo_start := 7525::TFloat , ioOperPriceListTo := 7525 ::TFloat,  inSession := '2'::TVarChar);
