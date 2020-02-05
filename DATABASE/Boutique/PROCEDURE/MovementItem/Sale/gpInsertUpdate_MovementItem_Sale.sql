-- Function: gpInsertUpdate_MovementItem_Sale()

-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Sale(
 INOUT ioId                   Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId           Integer   , -- Ключ объекта <Документ>
 INOUT ioGoodsId              Integer   , -- *** - Товар
    IN inPartionId            Integer   , -- Партия
 INOUT ioDiscountSaleKindId   Integer   , -- *** - Вид скидки при продаже
    IN inIsPay                Boolean   , -- добавить с оплатой
 INOUT ioAmount               TFloat    , -- Количество
 INOUT ioChangePercent        TFloat    , -- *** - % Скидки
 INOUT ioSummChangePercent    TFloat    , -- *** - Дополнительная скидка в продаже ГРН
   OUT outOperPrice           TFloat    , -- Цена вх. в валюте
   OUT outCountForPrice       TFloat    , -- Цена вх.за количество
   OUT outTotalSumm           TFloat    , -- +Сумма вх. в валюте
   OUT outTotalSummBalance    TFloat    , -- +Сумма вх. ГРН
 INOUT ioOperPriceList        TFloat    , -- *** - Цена по прайсу

   OUT outTotalSummPriceList  TFloat    , -- +Сумма по прайсу
   OUT outCurrencyValue         TFloat    , -- *Курс для перевода из валюты партии в ГРН
   OUT outParValue              TFloat    , -- *Номинал для перевода из валюты партии в ГРН
   OUT outTotalChangePercent    TFloat    , -- *+Итого скидка в продаже ГРН
   OUT outTotalChangePercentPay TFloat    , -- *Дополнительная скидка в расчетах ГРН
   OUT outTotalPay              TFloat    , -- *+Итого оплата в продаже ГРН
   OUT outTotalPayOth           TFloat    , -- *Итого оплата в расчетах ГРН
   OUT outTotalCountReturn      TFloat    , -- *Кол-во возврат
   OUT outTotalReturn           TFloat    , -- *Сумма возврата ГРН
   OUT outTotalPayReturn        TFloat    , -- *Сумма возврата оплаты ГРН
   OUT outTotalSummToPay        TFloat    , -- +Сумма к оплате ГРН
   OUT outTotalSummDebt         TFloat    , -- +Сумма долга в продаже ГРН

   OUT outDiscountSaleKindName  TVarChar  , -- *** - Вид скидки при продаже
   OUT outBarCode_partner       TVarChar  , -- Обнуляем Штрих-код поставщика для верхнего грида
    IN inBarCode_partner        TVarChar  , -- Штрих-код поставщика
    IN inBarCode_old            TVarChar  , -- Штрих-код из верхнего грида - old
    IN inComment                TVarChar  , -- примечание
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbOperDate      TDateTime;
   DECLARE vbCurrencyId    Integer;
   DECLARE vbCurrencyId_pl Integer;
   DECLARE vbUnitId        Integer;
   DECLARE vbUnitId_user   Integer;
   DECLARE vbClientId      Integer;
   DECLARE vbCashId        Integer;

   DECLARE vbCurrencyValue_pl  TFloat; -- *Курс для перевода из валюты прайса в ГРН
   DECLARE vbParValue_pl       TFloat; -- *Номинал для перевода из валюты прайса в ГРН
   DECLARE vbOperPriceList_pl  TFloat; -- *Цена из прайса
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale());
     vbUserId:= lpGetUserBySession (inSession);

     -- Получили для Пользователя - к какому Подразделению он привязан
     vbUnitId_user:= lpGetUnit_byUser (vbUserId);

     -- !!!временно - для Sybase!!!
     -- IF vbUserId = zc_User_Sybase() AND EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.Id = ioId AND MovementItem.isErased = TRUE)
     -- THEN
     --     RETURN;
     -- END IF;

     -- замена
     IF zc_Enum_GlobalConst_isTerry() = FALSE
     THEN inIsPay:= TRUE;
     END IF;

     -- замена Кол-во
     IF COALESCE (ioAmount, 0) = 0 AND COALESCE (ioId, 0) = 0 AND vbUserId <> zc_User_Sybase()
     THEN
         -- По умолчанию
         ioAmount:= 1;
     END IF;


     -- параметры из Документа
     SELECT Movement.OperDate
          , COALESCE (MovementLinkObject_From.ObjectId, 0)            AS UnitId
          , COALESCE (MovementLinkObject_To.ObjectId, 0)              AS ClientId
          , COALESCE (OL_currency.ChildObjectId, zc_Currency_Basis()) AS CurrencyId_pl -- Получили валюту для прайса
            INTO vbOperDate, vbUnitId, vbClientId, vbCurrencyId_pl
     FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN ObjectLink AS OL_pl ON OL_pl.ObjectId = MovementLinkObject_From.ObjectId
                                         AND OL_pl.DescId   = zc_ObjectLink_Unit_PriceList()
            LEFT JOIN ObjectLink AS OL_currency ON OL_currency.ObjectId = OL_pl.ChildObjectId
                                               AND OL_currency.DescId   = zc_ObjectLink_PriceList_Currency()
     WHERE Movement.Id = inMovementId;

     -- проверка - документ должен быть сохранен
     IF COALESCE (inMovementId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Документ не сохранен.';
     END IF;
     -- проверка - свойство должно быть установлено
     IF COALESCE (vbUnitId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Подразделение>.';
     END IF;
     -- проверка - Пользователя
     IF vbUnitId_user > 0 AND vbUnitId_user <> vbUnitId THEN
        RAISE EXCEPTION 'Ошибка.Нет прав проводить операцию для подразделения <%>.', lfGet_Object_ValueData_sh (vbUnitId);
     END IF;
     
     -- проверка - свойство должно быть установлено
     IF COALESCE (inPartionId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Партия>.';
     END IF;
     -- проверка - свойство должно быть установлено
     IF ioAmount < 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Кол-во>.';
     END IF;
     -- проверка - Уникальный inPartionId
     IF vbUserId <> zc_User_Sybase()
        AND EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.PartionId = inPartionId AND MI.Id <> COALESCE (ioId, 0)) THEN
        RAISE EXCEPTION 'Ошибка.В документе уже есть Товар <% %> р.<%>.Дублирование запрещено.'
                      , lfGet_Object_ValueData_sh ((SELECT Object_PartionGoods.LabelId     FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inPartionId))
                      , lfGet_Object_ValueData    ((SELECT Object_PartionGoods.GoodsId     FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inPartionId))
                      , lfGet_Object_ValueData_sh ((SELECT Object_PartionGoods.GoodsSizeId FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inPartionId))
                       ;
     END IF;


     -- данные из партии : GoodsId и OperPrice и CountForPrice и CurrencyId
     SELECT Object_PartionGoods.GoodsId                                    AS GoodsId
          , COALESCE (Object_PartionGoods.CountForPrice, 1)                AS CountForPrice
          , COALESCE (Object_PartionGoods.OperPrice, 0)                    AS OperPrice
          , COALESCE (Object_PartionGoods.CurrencyId, zc_Currency_Basis()) AS CurrencyId
            INTO ioGoodsId, outCountForPrice, outOperPrice, vbCurrencyId
     FROM Object_PartionGoods
     WHERE Object_PartionGoods.MovementItemId = inPartionId;

     -- проверка - свойство должно быть установлено
     IF COALESCE (ioGoodsId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Товар>.';
     END IF;


     -- Если Вх.цена НЕ в Базовой Валюте
     IF COALESCE (vbCurrencyId, 0) <> zc_Currency_Basis()
     THEN
         -- Определили курс на Дату документа
         SELECT COALESCE (tmp.Amount, 0), COALESCE (tmp.ParValue, 0)
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

     -- Если цена прайса НЕ в Базовой Валюте
     IF COALESCE (vbCurrencyId_pl, 0) <> zc_Currency_Basis()
     THEN
         -- Определили курс на Дату документа
         SELECT COALESCE (tmp.Amount, 0), COALESCE (tmp.ParValue, 0)
                INTO vbCurrencyValue_pl, vbParValue_pl
         FROM lfSelect_Movement_Currency_byDate (inOperDate      := vbOperDate
                                               , inCurrencyFromId:= zc_Currency_Basis()
                                               , inCurrencyToId  := vbCurrencyId_pl
                                                ) AS tmp;
         -- проверка
         IF COALESCE (vbCurrencyId_pl, 0) = 0 THEN
            RAISE EXCEPTION 'Ошибка.Не определено значение <Валюта прайса>.';
         END IF;
         -- проверка
         IF COALESCE (vbCurrencyValue_pl, 0) = 0 THEN
            RAISE EXCEPTION 'Ошибка.Не определено значение <Курс>.';
         END IF;
         -- проверка
         IF COALESCE (vbParValue_pl, 0) = 0 THEN
            RAISE EXCEPTION 'Ошибка.Не определено значение <Номинал>.';
         END IF;

     ELSE
         -- курс не нужен
         vbCurrencyValue_pl:= 0;
         vbParValue_pl     := 0;
     END IF;


     -- Если Штрих-код Поставщика - ОБЯЗАТЕЛЕН
     IF EXISTS (SELECT 1 FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = vbUnitId_user AND ObjectBoolean.DescId = zc_ObjectBoolean_Unit_PartnerBarCode() AND ObjectBoolean.ValueData = TRUE)
        AND vbUserId <> zc_User_Sybase()
     THEN
         -- при сканировании вызывается лишний раз
         IF COALESCE (inBarCode_partner, '') = '' AND (COALESCE (inBarCode_old, '') = '' OR COALESCE (inPartionId, 0) = 0) AND COALESCE (ioId, 0) = 0
         THEN
             RETURN; -- !!!Выход!!!
         END IF;

         -- если нужен ТОЛЬКО <Штрих-код поставщика> - вызывается лишний раз, т.к. ввод будет в нижнем гриде
         IF COALESCE (inBarCode_partner, '') <> '' AND COALESCE (inBarCode_old, '') = '' AND COALESCE (ioId, 0) = 0 AND COALESCE (inPartionId, 0) = 0
         THEN
             RETURN; -- !!!Выход!!!
         END IF;


         -- если уже был введен
         IF ioId > 0
         THEN
             -- !!!замена!!!
             inBarCode_partner:= (SELECT MIS.ValueData FROM MovementItemString AS MIS WHERE MIS.MovementItemId = ioId AND MIS.DescId = zc_MIString_BarCode());
         END IF;

         -- Проверка
         IF COALESCE (inBarCode_partner, '') = ''
         THEN
             RAISE EXCEPTION 'Ошибка.Не установлено значение <Штрих-код Поставщика>.';
         END IF;

     END IF;


     -- проверка: ОСТАТОК должен быть
     IF vbUserId <> zc_User_Sybase()
        AND ioAmount > COALESCE ((SELECT Container.Amount
                                  FROM Container
                                       LEFT JOIN ContainerLinkObject AS CLO_Client
                                                                     ON CLO_Client.ContainerId = Container.Id
                                                                    AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                                  WHERE Container.PartionId     = inPartionId
                                    AND Container.DescId        = zc_Container_Count()
                                    AND Container.WhereObjectId = vbUnitId
                                    AND Container.Amount        > 0
                                    AND CLO_Client.ContainerId IS NULL -- !!!отбросили Долги Покупателей!!!
                                 ), 0)
     THEN
        RAISE EXCEPTION 'Ошибка.Для товара <% %> р.<%> Остаток = <%>.'
                      , lfGet_Object_ValueData_sh ((SELECT Object_PartionGoods.LabelId     FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inPartionId))
                      , lfGet_Object_ValueData    ((SELECT Object_PartionGoods.GoodsId     FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inPartionId))
                      , lfGet_Object_ValueData_sh ((SELECT Object_PartionGoods.GoodsSizeId FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inPartionId))
                      , zfConvert_FloatToString (COALESCE ((SELECT Container.Amount
                                                            FROM Container
                                                                 LEFT JOIN ContainerLinkObject AS CLO_Client
                                                                                               ON CLO_Client.ContainerId = Container.Id
                                                                                              AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                                                            WHERE Container.PartionId     = inPartionId
                                                              AND Container.DescId        = zc_Container_Count()
                                                              AND Container.WhereObjectId = vbUnitId
                                                              AND Container.Amount        > 0
                                                              AND CLO_Client.ContainerId IS NULL -- !!!отбросили Долги Покупателей!!!
                                                           ), 0))
                       ;
     END IF;


     -- Цена (прайс)
     IF vbUserId = zc_User_Sybase()
     THEN
         -- !!!для SYBASE - потом убрать!!!
         IF 1=0 THEN RAISE EXCEPTION 'Ошибка.Параметр только для загрузки из Sybase.'; END IF;
     ELSE
         IF zc_Enum_GlobalConst_isTerry() = TRUE
         THEN
             -- из Истории
             ioOperPriceList := COALESCE ((SELECT tmp.ValuePrice FROM lpGet_ObjectHistory_PriceListItem (vbOperDate
                                                                                                       , zc_PriceList_Basis()
                                                                                                       , ioGoodsId
                                                                                                        ) AS tmp), 0);
             -- проверка - свойство должно быть установлено
             IF COALESCE (ioOperPriceList, 0) <= 0 THEN
                RAISE EXCEPTION 'Ошибка.Не найдено значение <Цена (прайс)>.';
             END IF;

         ELSE -- для Podium берется значение введенное в гриде   

              -- проверка - свойство должно быть установлено
              IF COALESCE (ioOperPriceList, 0) <= 0 THEN
                 RAISE EXCEPTION 'Ошибка.Не введено значение <Цена (прайс)>.';
              END IF;

              -- *Цена из прайса - для расчета суммы скидки
              vbOperPriceList_pl:= COALESCE ((SELECT zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (tmp.ValuePrice, vbCurrencyValue_pl, vbParValue_pl))
                                              FROM lpGet_ObjectHistory_PriceListItem (vbOperDate
                                                                                    , zc_PriceList_Basis()
                                                                                    , ioGoodsId
                                                                                     ) AS tmp), 0);
              -- проверка - свойство должно быть установлено
              IF COALESCE (vbOperPriceList_pl, 0) <= 0 THEN
                 RAISE EXCEPTION 'Ошибка.Не найдено значение <Цена (прайс)>.';
              END IF;
                                                                                                        
         
         END IF;

     END IF;

     -- Скидка
     IF vbUserId = zc_User_Sybase()
     THEN
         -- !!!для SYBASE - потом убрать!!!
         IF 1=0 THEN RAISE EXCEPTION 'Ошибка.Параметр только для загрузки из Sybase.'; END IF;
         -- !!!для SYBASE - потом убрать!!!
         IF EXISTS (SELECT 1 FROM Object WHERE Object.Id = vbUnitId AND Object.ValueData = 'магазин Chado-Outlet')
         THEN ioDiscountSaleKindId:= zc_Enum_DiscountSaleKind_Outlet();
         END IF;

     ELSE
         -- расчет
         SELECT tmp.ChangePercent, tmp.DiscountSaleKindId INTO ioChangePercent, ioDiscountSaleKindId
         FROM zfSelect_DiscountSaleKind (vbOperDate, vbUnitId, ioGoodsId, vbClientId, vbUserId) AS tmp;

         -- Дополнительная скидка в продаже ГРН
         IF (inIsPay = TRUE AND ioAmount <> COALESCE ((SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = ioId), 0))
            OR ioAmount = 0
         THEN
             IF zc_Enum_GlobalConst_isTerry() = TRUE OR ioAmount = 0
             THEN
                 -- !!!обнулили!!!
                 ioSummChangePercent:= 0;
             ELSE
                 -- !!!посчитали для ПОДИУМ!!!
                 IF inIsPay = FALSE
                 THEN -- !!!обнулили!!!
                      ioSummChangePercent:= 0;
                 ELSE
                      ioSummChangePercent:= zfCalc_SummPriceList (ioAmount, vbOperPriceList_pl)
                                          - zfCalc_SummPriceList (ioAmount, ioOperPriceList);
                 END IF;
             END IF;
         ELSE
             IF zc_Enum_GlobalConst_isTerry() = TRUE
             THEN
                 -- взяли ту что есть
                 ioSummChangePercent:= COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummChangePercent()), 0);
             ELSE
                 -- !!!посчитали для ПОДИУМ!!!
                 IF inIsPay = FALSE
                 THEN 
                      ioSummChangePercent:= COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummChangePercent()), 0);
                 ELSE
                      ioSummChangePercent:= zfCalc_SummPriceList (ioAmount, vbOperPriceList_pl)
                                          - zfCalc_SummPriceList (ioAmount, ioOperPriceList);
                 END IF;
             END IF;
         END IF;

     END IF;
     -- вернули название Скидки
     outDiscountSaleKindName := (SELECT Object.ValueData FROM Object WHERE Object.Id = ioDiscountSaleKindId);


     -- вернули Сумма вх. в валюте, для грида - Округлили до 2-х Знаков
     outTotalSumm := zfCalc_SummIn (ioAmount, outOperPrice, outCountForPrice);
     -- вернули сумму вх. в грн по элементу, для грида
     outTotalSummBalance := zfCalc_CurrencyFrom (outTotalSumm, outCurrencyValue, outParValue);
     -- расчитали Сумма по прайсу по элементу, для грида
     IF zc_Enum_GlobalConst_isTerry() = TRUE
     THEN outTotalSummPriceList := zfCalc_SummPriceList (ioAmount, ioOperPriceList);
     ELSE outTotalSummPriceList := zfCalc_SummPriceList (ioAmount, vbOperPriceList_pl);
     END IF;

     -- расчитали Итого скидка в продаже ГРН, для грида - !!!Округлили до НОЛЬ Знаков - только %, ВСЕ округлять - нельзя!!!
     IF zc_Enum_GlobalConst_isTerry() = TRUE OR inIsPay = FALSE
     THEN
         outTotalChangePercent := outTotalSummPriceList - zfCalc_SummChangePercent (ioAmount, ioOperPriceList, ioChangePercent) + COALESCE (ioSummChangePercent, 0);
     ELSE
         outTotalChangePercent := COALESCE (ioSummChangePercent, 0);
     END IF;

     -- вернули Итого оплата в продаже ГРН, для грида
     IF inIsPay = TRUE
     THEN
         outTotalPay := COALESCE (outTotalSummPriceList, 0) - COALESCE (outTotalChangePercent, 0) ;
     ELSE
         outTotalPay := COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalPay()), 0);
     END IF;


     -- вернули Сумма к оплате
     outTotalSummToPay := COALESCE (outTotalSummPriceList, 0) - COALESCE (outTotalChangePercent, 0) ;

     -- вернули Сумма долга в продаже ГРН
     outTotalSummDebt := COALESCE (outTotalSummToPay, 0) - COALESCE (outTotalPay, 0) ;


     -- !!!для SYBASE - потом убрать!!!
     /*IF vbUserId = zc_User_Sybase() AND ioId > 0 AND inIsPay = FALSE
     THEN PERFORM gpInsertUpdate_MI_Sale_Child(
                        inMovementId            := inMovementId
                      , inParentId              := ioId
                      , inAmountGRN             := 0
                      , inAmountUSD             := 0
                      , inAmountEUR             := 0
                      , inAmountCard            := 0
                      , inAmountDiscount        := 0
                      , inCurrencyValueUSD      := 0
                      , inParValueUSD           := 0
                      , inCurrencyValueEUR      := 0
                      , inParValueEUR           := 0
                      , inSession               := inSession
                  );
         -- в мастер записать - Дополнительная скидка в продаже ГРН - т.к. могли обнулить
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent(), ioId, COALESCE (ioSummChangePercent, 0));

         -- в мастер записать - Итого оплата в продаже ГРН
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPay(), ioId, 0);

         -- пересчитали Итоговые суммы по накладной
         PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     END IF;*/



     -- сохранили
     ioId:= lpInsertUpdate_MovementItem_Sale   (ioId                    := ioId
                                              , inMovementId            := inMovementId
                                              , inGoodsId               := ioGoodsId
                                              , inPartionId             := COALESCE (inPartionId, 0)
                                              , inDiscountSaleKindId    := ioDiscountSaleKindId
                                              , inAmount                := ioAmount
                                              , inChangePercent         := COALESCE (ioChangePercent, 0)
                                              -- , inSummChangePercent     := COALESCE (ioSummChangePercent, 0)
                                              , inOperPrice             := COALESCE (outOperPrice, 0)
                                              , inCountForPrice         := COALESCE (outCountForPrice, 0)
                                              , inOperPriceList         := CASE WHEN zc_Enum_GlobalConst_isTerry() = TRUE THEN ioOperPriceList ELSE vbOperPriceList_pl END
                                              , inCurrencyValue         := outCurrencyValue
                                              , inParValue              := outParValue
                                              , inTotalChangePercent    := COALESCE (outTotalChangePercent, 0)
                                              -- , inTotalChangePercentPay := COALESCE (outTotalChangePercentPay, 0)
                                              -- , inTotalPay              := COALESCE (outTotalPay, 0)
                                              -- , inTotalPayOth           := COALESCE (outTotalPayOth, 0)
                                              -- , inTotalCountReturn      := COALESCE (outTotalCountReturn, 0)
                                              -- , inTotalReturn           := COALESCE (outTotalReturn, 0)
                                              -- , inTotalPayReturn        := COALESCE (outTotalPayReturn, 0)
                                              , inBarCode               := inBarCode_partner
                                              , inComment               := -- !!!для SYBASE - потом убрать!!!
                                                                           CASE WHEN vbUserId = zc_User_Sybase() AND SUBSTRING (inComment FROM 1 FOR 5) = '*123*'
                                                                                     THEN -- убрали хардкод
                                                                                          SUBSTRING (inComment FROM 6 FOR CHAR_LENGTH (inComment) - 5)
                                                                                     ELSE inComment
                                                                           END
                                              , inUserId                := vbUserId
                                               );


     IF zc_Enum_GlobalConst_isTerry() = TRUE
     THEN
         -- записать - 
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceListReal(), ioId, ioOperPriceList);
     ELSE 
         -- записать - 
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceListReal(), ioId, CASE WHEN ioAmount <> 0 THEN (COALESCE (outTotalSummPriceList, 0) - COALESCE (outTotalChangePercent, 0)) / ioAmount ELSE 0 END);
     END IF;

     -- !!!для SYBASE - потом убрать!!!
     IF vbUserId = zc_User_Sybase() AND inIsPay = FALSE
     THEN
         -- в мастер записать - Дополнительная скидка в продаже ГРН - т.к. .....
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent(), ioId, COALESCE (ioSummChangePercent, 0));
     END IF;

     -- !!!для SYBASE - потом убрать!!!
     IF vbUserId = zc_User_Sybase() AND SUBSTRING (inComment FROM 1 FOR 5) = '*123*'
     THEN
         -- сохранили для проверки - в SYBASE это полностью оплаченная продажа -> надо формировать проводку
         PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Close(), ioId, TRUE);

     ELSEIF vbUserId = zc_User_Sybase() AND EXISTS (SELECT 1 FROM MovementItemBoolean AS MIB WHERE MIB.MovementItemId = ioId AND MIB.DescId = zc_MIBoolean_Close() AND MIB.ValueData = TRUE)
     THEN
         -- убрали для проверки - в SYBASE это НЕ полностью оплаченная продажа -> НЕ надо формировать проводку
         PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Close(), ioId, FALSE);

     END IF;


     -- Добавляем оплату в грн
     IF inIsPay = TRUE
     THEN
         -- находим кассу для Магазина, в которую попадет оплата
         vbCashId := (SELECT lpSelect.CashId
                      FROM lpSelect_Object_Cash (vbUnitId, vbUserId) AS lpSelect
                      WHERE lpSelect.isBankAccount = FALSE
                        AND lpSelect.CurrencyId    = zc_Currency_GRN()
                     );

         -- проверка - свойство должно быть установлено
         IF COALESCE (vbCashId, 0) = 0 THEN
           -- Для Sybase - ВРЕМЕННО
           IF vbUserId = zc_User_Sybase()
           THEN vbCashId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Cash() AND Object.ObjectCode = 1);
           ELSE RAISE EXCEPTION 'Ошибка.Для магазина <%> Не установлено значение <Касса> в грн. (%)', lfGet_Object_ValueData (vbUnitId), vbUnitId;
           END IF;
         END IF;


         -- сохранили
         PERFORM lpInsertUpdate_MI_Sale_Child (ioId                 := tmp.Id
                                             , inMovementId         := inMovementId
                                             , inParentId           := ioId
                                             , inCashId             := tmp.CashId
                                             , inCurrencyId         := tmp.CurrencyId
                                             , inCashId_Exc         := NULL
                                             , inAmount             := tmp.Amount
                                             , inCurrencyValue      := tmp.CurrencyValue
                                             , inParValue           := tmp.ParValue
                                             , inUserId             := vbUserId
                                              )
         FROM (WITH tmpMI AS (SELECT MovementItem.Id                 AS Id
                                   , MovementItem.ObjectId           AS CashId
                                   , MILinkObject_Currency.ObjectId  AS CurrencyId
                                   , MIFloat_CurrencyValue.ValueData AS CurrencyValue
                                   , MIFloat_ParValue.ValueData      AS ParValue
                              FROM MovementItem
                                   LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                                               ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                                              AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()
                                   LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                               ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                              AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                                    ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()
                              WHERE MovementItem.ParentId   = ioId
                                AND MovementItem.MovementId = inMovementId
                                AND MovementItem.DescId     = zc_MI_Child()
                                AND MovementItem.isErased   = FALSE
                             )
               SELECT tmpMI.Id                                                  AS Id
                    , COALESCE (_tmpCash.CashId, tmpMI.CashId)                  AS CashId
                    , COALESCE (_tmpCash.CurrencyId, tmpMI.CurrencyId)          AS CurrencyId
                    , CASE WHEN _tmpCash.CashId > 0 THEN outTotalPay ELSE 0 END AS Amount
                    , CASE WHEN zc_Enum_GlobalConst_isTerry() = TRUE THEN COALESCE (tmpMI.CurrencyValue, 0) ELSE vbCurrencyValue_pl END AS CurrencyValue
                    , CASE WHEN zc_Enum_GlobalConst_isTerry() = TRUE THEN COALESCE (tmpMI.CurrencyId, 0)    ELSE vbParValue_pl      END AS ParValue
               FROM (SELECT vbCashId AS CashId, zc_Currency_GRN() AS CurrencyId
                    ) AS _tmpCash
                    FULL JOIN tmpMI ON tmpMI.CashId = _tmpCash.CashId
              ) AS tmp
         ;

         -- в мастер записать - Дополнительная скидка в продаже ГРН - т.к. могли обнулить
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent(), ioId, COALESCE (ioSummChangePercent, 0));

         -- в мастер записать - Итого оплата в продаже ГРН
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPay(), ioId, outTotalPay);

         -- пересчитали Итоговые суммы по накладной
         PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     END IF;


     -- "сложно" пересчитали "итоговые" суммы по элементу
     PERFORM lpUpdate_MI_Sale_Total (ioId);


     -- вернули Дополнительная скидка в расчетах ГРН, для грида
     outTotalChangePercentPay:= COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalChangePercentPay()), 0);
     -- вернули Итого оплата в расчетах ГРН, для грида
     outTotalPayOth:= COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalPayOth()), 0);

     -- вернули Кол-во возврат, для грида
     outTotalCountReturn:= COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalCountReturn()), 0);
     -- вернули Сумма возврата ГРН, для грида
     outTotalReturn:= COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalReturn()), 0);
     -- вернули Сумма возврата оплаты ГРН, для грида
     outTotalPayReturn:= COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalPayReturn()), 0);

     -- Обнуляем Штрих-код поставщика для верхнего грида
     outBarCode_partner:= '';


     -- Обнуляем Цену вх. для грида - т.к. у пользователя Магазина НЕТ Прав
     IF vbUnitId_user > 0
     THEN
         outOperPrice         := 0; -- Цена вх. в валюте
         outCountForPrice     := 0; -- Цена вх.за количество
         outTotalSumm         := 0; -- Сумма вх. в валюте
         outTotalSummBalance  := 0; -- Сумма вх. ГРН
         outCurrencyValue     := 0; -- Курс для перевода из валюты партии в ГРН
         outParValue          := 0; -- Номинал для перевода из валюты партии в ГРН
     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.07.17         *
 28.06.17         *
 13.16.17         *
 09.05.17         *
 10.04.17         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Sale (ioId := 0 , inMovementId := 8 , ioGoodsId := 446 , inPartionId := 50 , inIsPay := False ,  ioAmount := 4 ,ioSummChangePercent:=0, ioOperPriceList := 1030 , inBarCode_partner := '1' ::TVarChar,  inSession := zfCalc_UserAdmin());
