-- Function: gpInsertUpdate_MovementItem_SalePodium()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SalePodium (Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SalePodium (Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_SalePodium(
 INOUT ioId                             Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId                     Integer   , -- Ключ объекта <Документ>
 INOUT ioGoodsId                        Integer   , -- *** - Товар
    IN inPartionId                      Integer   , -- Партия
 INOUT ioDiscountSaleKindId             Integer   , -- *** - Вид скидки при продаже
    IN inIsPay                          Boolean   , -- добавить с оплатой
 INOUT ioAmount                         TFloat    , -- Количество
 INOUT ioChangePercent                  TFloat    , -- *** - % Скидки

 INOUT ioSummChangePercent              TFloat    , -- *** - Дополнительная скидка в продаже ГРН
 INOUT ioSummChangePercent_curr         TFloat    , -- *** - Дополнительная скидка в продаже в валюте***

   OUT outOperPrice                     TFloat    , -- Цена вх. в валюте
   OUT outCountForPrice                 TFloat    , -- Цена вх.за количество
   OUT outTotalSumm                     TFloat    , -- +Сумма вх. в валюте
   OUT outTotalSummBalance              TFloat    , -- +Сумма вх. ГРН
 INOUT ioOperPriceList                  TFloat    , -- *** - Цена факт ГРН

   OUT outTotalSummPriceList            TFloat    , -- +Сумма по прайсу в ГРН
   OUT outTotalSummPriceList_curr       TFloat    , -- +Сумма по прайсу в валюте***

   OUT outCurrencyValue                 TFloat    , -- *Курс для перевода из валюты партии в ГРН
   OUT outParValue                      TFloat    , -- *Номинал для перевода из валюты партии в ГРН

   OUT outTotalChangePercent            TFloat    , -- *+Итого скидка в продаже ГРН
   OUT outTotalChangePercent_curr       TFloat    , -- *+Итого скидка в продаже в валюте***

   OUT outTotalChangePercentPay         TFloat    , -- *Дополнительная скидка в расчетах ГРН
   OUT outTotalChangePercentPay_curr    TFloat    , -- *Дополнительная скидка в валюте***

   OUT outTotalPay                      TFloat    , -- *+Итого оплата в продаже ГРН
   OUT outTotalPay_curr                 TFloat    , -- *+Итого оплата в продаже в валюте***

   OUT outTotalPayOth                   TFloat    , -- *Итого оплата в расчетах ГРН
   OUT outTotalPayOth_curr              TFloat    , -- *Итого оплата в расчетах в валюте***

   OUT outTotalCountReturn              TFloat    , -- *Кол-во возврат
   OUT outTotalReturn                   TFloat    , -- *Сумма возврата ГРН
   OUT outTotalPayReturn                TFloat    , -- *Сумма возврата оплаты ГРН

   OUT outTotalSummToPay                TFloat    , -- +Сумма к оплате ГРН
   OUT outTotalSummToPay_curr           TFloat    , -- +Сумма к оплате в валюте***

   OUT outTotalSummDebt                 TFloat    , -- +Сумма долга в продаже ГРН
   OUT outTotalSummDebt_curr            TFloat    , -- +Сумма долга в продаже в валюте***

   OUT outDiscountSaleKindName          TVarChar  , -- *** - Вид скидки при продаже
   OUT outBarCode_partner               TVarChar  , -- Обнуляем Штрих-код поставщика для верхнего грида
    IN inBarCode_partner                TVarChar  , -- Штрих-код поставщика
    IN inBarCode_old                    TVarChar  , -- Штрих-код из верхнего грида - old
    IN inComment                        TVarChar  , -- примечание
    IN inSession                        TVarChar    -- сессия пользователя
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

   DECLARE vbPriceListId        Integer; -- *Прайс магазина, может быть как в ГРН так и в ВАЛЮТЕ
   DECLARE vbCurrencyValue_pl   TFloat;  -- *Курс для перевода из валюты прайса в ГРН
   DECLARE vbParValue_pl        TFloat;  -- *Номинал для перевода из валюты прайса в ГРН
   DECLARE vbOperPriceList_pl   TFloat;  -- *Цена из прайса - переводим в ГРН
   DECLARE vbOperPriceList_curr TFloat;  -- *Цена из прайса - если в ГРН, тогда переводим в ту валюту что надо (временно zc_Currency_EUR)

   DECLARE vbCurrencyId_Client Integer;

   DECLARE vbIsOperPriceListReal Boolean; -- режим
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale());
     vbUserId:= lpGetUserBySession (inSession);

     -- Получили для Пользователя - к какому Подразделению он привязан
     vbUnitId_user:= lpGetUnit_byUser (vbUserId);


     -- проверка - магазин PODIUM
     IF EXISTS (SELECT 1 FROM MovementLinkObject AS MLO_From
                WHERE MLO_From.MovementId =  inMovementId
                  AND MLO_From.ObjectId   = 6318  -- магазин PODIUM
                  AND MLO_From.DescId     =  zc_MovementLinkObject_From()
               )
      --AND ioId > 0
        AND zfCalc_User_PriceListReal (vbUserId) = TRUE
     THEN
        RAISE EXCEPTION 'Ошибка.Нет прав изменять элементы.Корректировать можно только Дату документа.';
     END IF;

     -- режим
     vbIsOperPriceListReal:= zfCalc_User_PriceListReal (vbUserId) AND NOT EXISTS (SELECT 1 FROM MovementLinkObject AS MLO_From
                                                                                  WHERE MLO_From.MovementId =  inMovementId
                                                                                    AND MLO_From.ObjectId   = 6318  -- магазин PODIUM
                                                                                    AND MLO_From.DescId     =  zc_MovementLinkObject_From()
                                                                                 );

     -- замена
     IF vbIsOperPriceListReal = TRUE
     THEN inIsPay:= TRUE;
     END IF;

     -- замена Кол-во
     IF COALESCE (ioAmount, 0) = 0 AND COALESCE (ioId, 0) = 0 AND vbUserId <> zc_User_Sybase()
     THEN
         -- По умолчанию
         ioAmount:= 1;
     END IF;


     -- проверка - документ должен быть сохранен
     IF COALESCE (inMovementId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Документ не сохранен.';
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


     -- параметры из Документа
     SELECT Movement.OperDate
          , COALESCE (MLO_From.ObjectId, 0) AS UnitId
          , COALESCE (MLO_To.ObjectId, 0)   AS ClientId
            -- Валюта Покупателя
          , COALESCE (MLO_CurrencyClient.ObjectId, CASE WHEN zc_Enum_GlobalConst_isTerry() = TRUE THEN zc_Currency_GRN() ELSE zc_Currency_EUR() END) AS ClientId
            -- Прайс для Магазина, если установлен
          , COALESCE (OL_pl.ChildObjectId, zc_PriceList_Basis()) AS PriceListId
            INTO vbOperDate, vbUnitId, vbClientId, vbCurrencyId_Client, vbPriceListId
     FROM Movement
            LEFT JOIN MovementLinkObject AS MLO_From
                                         ON MLO_From.MovementId = Movement.Id
                                        AND MLO_From.DescId     = zc_MovementLinkObject_From()
            LEFT JOIN MovementLinkObject AS MLO_To
                                         ON MLO_To.MovementId = Movement.Id
                                        AND MLO_To.DescId     = zc_MovementLinkObject_To()
            LEFT JOIN MovementLinkObject AS MLO_CurrencyClient
                                         ON MLO_CurrencyClient.MovementId = Movement.Id
                                        AND MLO_CurrencyClient.DescId     = zc_MovementLinkObject_CurrencyClient()
            LEFT JOIN ObjectLink AS OL_pl ON OL_pl.ObjectId = MLO_From.ObjectId
                                         AND OL_pl.DescId   = zc_ObjectLink_Unit_PriceList()
     WHERE Movement.Id = inMovementId;


     -- проверка - свойство должно быть установлено
     IF COALESCE (vbUnitId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Подразделение>.';
     END IF;
     -- проверка - свойство должно быть установлено
     IF COALESCE (vbPriceListId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Прайс-лист>.';
     END IF;
     -- проверка - Пользователя
     IF vbUnitId_user > 0 AND vbUnitId_user <> vbUnitId THEN
        RAISE EXCEPTION 'Ошибка.Нет прав проводить операцию для подразделения <%>.', lfGet_Object_ValueData_sh (vbUnitId);
     END IF;


     -- из Истории - Цена и Валюта
     SELECT lpGet.ValuePrice, lpGet.CurrencyId
             INTO vbOperPriceList_curr, vbCurrencyId_pl
     FROM lpGet_ObjectHistory_PriceListItem (vbOperDate, vbPriceListId, ioGoodsId) AS lpGet;

     -- проверка - свойство должно быть установлено
     IF COALESCE (vbOperPriceList_curr, 0) <= 0 THEN
        RAISE EXCEPTION 'Ошибка.Не найдено значение <Цена (прайс)>.';
     END IF;
     -- проверка - свойство должно быть установлено
     IF COALESCE (vbCurrencyId_pl, 0) <= 0 THEN
        RAISE EXCEPTION 'Ошибка.Не найдено значение <Валюта (прайс)>.';
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

     -- Всегда, а не только - Если цена прайса НЕ в Базовой Валюте
     IF 1=1 -- OR COALESCE (vbCurrencyId_pl, 0) <> zc_Currency_Basis()
     THEN
         -- Определили курс - если вводили
         SELECT COALESCE (MAX (CASE WHEN Object.DescId = zc_Object_Cash() THEN COALESCE (MIFloat_CurrencyValue.ValueData, 0) ELSE 0 END), 0) AS CurrencyValue_EUR
              , COALESCE (MAX (CASE WHEN Object.DescId = zc_Object_Cash() THEN COALESCE (MIFloat_ParValue.ValueData, 1)      ELSE 0 END), 0) AS ParValue_EUR
                INTO vbCurrencyValue_pl, vbParValue_pl

         FROM MovementItem
               LEFT JOIN MovementItem AS MI_Master ON MI_Master.Id       = MovementItem.ParentId
                                                  AND MI_Master.isErased = FALSE
               LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
               INNER JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                               AND MILinkObject_Currency.DescId = zc_MILinkObject_Currency()
                                               AND MILinkObject_Currency.ObjectId = zc_Currency_EUR()
               LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                           ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                          AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()
               LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                           ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                          AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()

         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId     = zc_MI_Child()
           AND MovementItem.isErased   = FALSE
        ;

         -- если НЕ вводили
         IF COALESCE (vbCurrencyValue_pl, 0) = 0
         THEN
             -- Определили курс на Дату документа
             SELECT COALESCE (tmp.Amount, 0), COALESCE (tmp.ParValue, 0)
                    INTO vbCurrencyValue_pl, vbParValue_pl
             FROM lfSelect_Movement_Currency_byDate (inOperDate      := vbOperDate
                                                   , inCurrencyFromId:= zc_Currency_Basis()
                                                     -- !!! ВРЕМЕННО - zc_Currency_EUR !!!
                                                   , inCurrencyToId  := zc_Currency_EUR() -- vbCurrencyId_pl
                                                    ) AS tmp;
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


     -- Скидка
     IF zc_Enum_GlobalConst_isTerry() = TRUE
     THEN
         SELECT tmp.ChangePercent, tmp.DiscountSaleKindId INTO ioChangePercent, ioDiscountSaleKindId
         FROM zfSelect_DiscountSaleKind (vbOperDate, vbUnitId, ioGoodsId, vbClientId, vbUserId) AS tmp;

     ELSEIF EXISTS (SELECT 1
                    FROM Object_PartionGoods
                         LEFT JOIN ObjectLink AS ObjectLink_Partner_Period
                                              ON ObjectLink_Partner_Period.ObjectId      = Object_PartionGoods.PartnerId
                                             AND ObjectLink_Partner_Period.DescId        = zc_ObjectLink_Partner_Period()

                         LEFT JOIN ObjectFloat AS ObjectFloat_PeriodYear
                                               ON ObjectFloat_PeriodYear.ObjectId = Object_PartionGoods.PartnerId
                                              AND ObjectFloat_PeriodYear.DescId = zc_ObjectFloat_Partner_PeriodYear()
                    WHERE Object_PartionGoods.MovementItemId = inPartionId
                      AND ((ObjectLink_Partner_Period.ChildObjectId = 1074 -- Весна-Лето
                        AND ObjectFloat_PeriodYear.ValueData = 2020
                           )
                        -- !!! временно ?
                        OR ObjectFloat_PeriodYear.ValueData > 2020
                          )
                   )
         THEN
             SELECT tmp.ChangePercent, tmp.DiscountSaleKindId INTO ioChangePercent, ioDiscountSaleKindId
             FROM zfSelect_DiscountSaleKind (vbOperDate, vbUnitId, ioGoodsId, vbClientId, vbUserId) AS tmp;
     ELSE
         ioChangePercent     := 0;
         ioDiscountSaleKindId:= 9; -- Нет скидки
     END IF;


     -- Цена (прайс)
     IF zc_Enum_GlobalConst_isTerry() = TRUE
     THEN
         RAISE EXCEPTION 'Ошибка.zc_Enum_GlobalConst_isT... = TRUE';

     ELSE
          -- проверка - свойство должно быть установлено
          IF COALESCE (ioOperPriceList, 0) <= 0 THEN
             RAISE EXCEPTION 'Ошибка.Не введено значение <Цена факт ГРН>.';
          END IF;

          -- *Цена из прайса - для расчета суммы скидки
          -- если Цена в валюте
          IF vbCurrencyId_pl <> zc_Currency_Basis()
          THEN
              -- если у Покупателя в ГРН
              IF vbCurrencyId_Client = zc_Currency_GRN()
              THEN
                  -- переводим в ГРН, округление до 0 зн. - т.к. у покупателя в ГРН
                  vbOperPriceList_pl:= zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (vbOperPriceList_curr, vbCurrencyValue_pl, vbParValue_pl), 0);
              ELSE
                  -- переводим из валюты в ГРН, округление до 0 зн.
                  vbOperPriceList_pl:= zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (vbOperPriceList_curr, vbCurrencyValue_pl, vbParValue_pl), 0);
              END IF;
          ELSE
              -- в прайсе она в ГРН
              vbOperPriceList_pl:= vbOperPriceList_curr;
              --
              IF vbCurrencyId_Client = zc_Currency_GRN()
              THEN
                  -- !!! ВРЕМЕННО - а здесь надо в zc_Currency_EUR + округление до 0-х зн. - т.к. у покупателя в ГРН !!!
                  vbOperPriceList_curr:= zfCalc_SummPriceList (1, zfCalc_CurrencySumm (vbOperPriceList_curr, vbCurrencyId_pl, zc_Currency_EUR(), vbCurrencyValue_pl, vbParValue_pl), 0);
              ELSE
                  -- !!! ВРЕМЕННО - а здесь надо в zc_Currency_EUR + округление до 0-х зн. - т.к. у покупателя в Валюте !!!
                  vbOperPriceList_curr:= zfCalc_SummPriceList (1, zfCalc_CurrencySumm (vbOperPriceList_curr, vbCurrencyId_pl, zc_Currency_EUR(), vbCurrencyValue_pl, vbParValue_pl), 0);
              END IF;
          END IF;

          -- цена в ГРН из Истории со скидкой - ТОЛЬКО когда INSERT + если вводит IsOperPriceListReal = TRUE
          IF COALESCE (ioId, 0) = 0 AND vbIsOperPriceListReal = TRUE
          THEN
              -- на самом деле возвращается в грид как Цена факт ГРН + округление
              ioOperPriceList:= zfCalc_SummChangePercent (1, vbOperPriceList_pl, ioChangePercent);
          END IF;

     END IF;


     -- Дополнительная скидка в продаже ГРН
     IF (inIsPay = TRUE AND ioAmount <> COALESCE ((SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = ioId), 0))
        OR ioAmount = 0
     THEN
         -- Дополнительная скидка в продаже ГРН + в валюте
         IF inIsPay = FALSE
         THEN -- !!!обнулили!!!
              ioSummChangePercent     := 0;
              ioSummChangePercent_curr:= 0;
         ELSE
             -- !!!режим!!!
             IF vbIsOperPriceListReal = FALSE
             THEN
                  -- взяли ту что есть
                  ioSummChangePercent     := COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummChangePercent()),      0);
                  ioSummChangePercent_curr:= COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummChangePercent_curr()), 0);
             ELSE
                 -- посчитали для PriceListReal
                 IF vbCurrencyId_Client = zc_Currency_GRN()
                 THEN
                     -- Сумма скидки по цене в ГРН + округление
                     ioSummChangePercent     := zfCalc_SummChangePercent (ioAmount, vbOperPriceList_pl, ioChangePercent)
                                              - zfCalc_SummPriceList (ioAmount, ioOperPriceList);
                     -- переводим из ГРН в Валюту + округление
                     ioSummChangePercent_curr:= zfCalc_SummPriceList (1, zfCalc_CurrencyTo (ioSummChangePercent, outCurrencyValue, outParValue));
                 ELSE
                     -- Сумма скидки по цене в Валюте + округление
                     ioSummChangePercent_curr:= zfCalc_SummChangePercent (ioAmount, vbOperPriceList_curr, ioChangePercent)
                                                -- !!! ВРЕМЕННО - zc_Currency_EUR !!!
                                              - zfCalc_SummPriceList (ioAmount, vbOperPriceList_curr);
                     -- переводим из Валюты в ГРН + округление
                     ioSummChangePercent     := zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (ioSummChangePercent_curr, outCurrencyValue, outParValue));
                 END IF;
             END IF;
         END IF;

     ELSE
         -- !!!режим!!!
         IF vbIsOperPriceListReal = TRUE
         THEN
              -- посчитали для PriceListReal
              IF vbCurrencyId_Client = zc_Currency_GRN()
              THEN
                  -- Сумма скидки по цене в ГРН + округление
                  ioSummChangePercent     := zfCalc_SummChangePercent (ioAmount, vbOperPriceList_pl, ioChangePercent)
                                           - zfCalc_SummPriceList (ioAmount, ioOperPriceList);
                  -- переводим из ГРН в Валюту + округление
                  ioSummChangePercent_curr:= zfCalc_SummPriceList (1, zfCalc_CurrencyTo (ioSummChangePercent, outCurrencyValue, outParValue));
              ELSE
                  -- Сумма скидки по цене в Валюте + округление
                  ioSummChangePercent_curr:= zfCalc_SummChangePercent (ioAmount, vbOperPriceList_curr, ioChangePercent)
                                             -- !!! ВРЕМЕННО - zc_Currency_EUR !!!
                                           - zfCalc_SummPriceList (ioAmount, vbOperPriceList_curr);
                  -- переводим из Валюты в ГРН + округление
                  ioSummChangePercent     := zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (ioSummChangePercent_curr, outCurrencyValue, outParValue));
              END IF;
         END IF;
     END IF;


     -- вернули название Скидки
     outDiscountSaleKindName := (SELECT Object.ValueData FROM Object WHERE Object.Id = ioDiscountSaleKindId);


     -- вернули Сумма вх. в валюте, для грида - Округлили до 2-х Знаков
     outTotalSumm := zfCalc_SummIn (ioAmount, outOperPrice, outCountForPrice);
     -- вернули сумму вх. в грн по элементу, для грида
     outTotalSummBalance := zfCalc_CurrencyFrom (outTotalSumm, outCurrencyValue, outParValue);


     -- Итого Сумма по прайсу + цены уже округлены как надо
     IF vbCurrencyId_Client = zc_Currency_GRN()
     THEN
         -- расчитали для ГРН
         outTotalSummPriceList      := zfCalc_SummIn (ioAmount, vbOperPriceList_pl, 1);
         -- расчитали для Валюты
         outTotalSummPriceList_curr := zfCalc_SummIn (ioAmount, vbOperPriceList_curr, 1);
     ELSE
         -- расчитали для ГРН
         outTotalSummPriceList      := zfCalc_SummIn (ioAmount, vbOperPriceList_pl, 1);
         -- расчитали для Валюты
         outTotalSummPriceList_curr := zfCalc_SummIn (ioAmount, vbOperPriceList_curr, 1);
     END IF;


     -- Итого скидка в продаже, для грида - !!!Округлили до НОЛЬ Знаков - только %, ВСЕ округлять - нельзя!!!
     IF vbCurrencyId_Client = zc_Currency_GRN()
     THEN
         -- расчитали для ГРН
         outTotalChangePercent      := outTotalSummPriceList      - zfCalc_SummChangePercent (ioAmount, vbOperPriceList_pl,   ioChangePercent) + COALESCE (ioSummChangePercent,      0);
         -- расчитали для Валюты
         outTotalChangePercent_curr := outTotalSummPriceList_curr - zfCalc_SummChangePercent (ioAmount, vbOperPriceList_curr, ioChangePercent) + COALESCE (ioSummChangePercent_curr, 0);
         -- переводим из ГРН в Валюту + округление
         -- outTotalChangePercent_curr := zfCalc_SummPriceList (1, zfCalc_CurrencyTo (outTotalChangePercent, outCurrencyValue, outParValue));
     ELSE
         -- расчитали для Валюты
         outTotalChangePercent_curr := outTotalSummPriceList_curr - zfCalc_SummChangePercent (ioAmount, vbOperPriceList_curr, ioChangePercent) + COALESCE (ioSummChangePercent_curr, 0);
         -- расчитали для ГРН
         outTotalChangePercent      := outTotalSummPriceList      - zfCalc_SummChangePercent (ioAmount, vbOperPriceList_pl,   ioChangePercent) + COALESCE (ioSummChangePercent,      0);
         -- переводим из Валюты в ГРН + округление
         -- outTotalChangePercent := zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (outTotalChangePercent_curr, outCurrencyValue, outParValue));
     END IF;


     -- Итого оплата в продаже, для грида
     IF inIsPay = TRUE
     THEN
         IF vbCurrencyId_Client = zc_Currency_GRN()
         THEN
             -- расчитали для ГРН
             outTotalPay      := COALESCE (outTotalSummPriceList, 0)      - COALESCE (outTotalChangePercent,      0) ;
             -- расчитали для Валюты
             outTotalPay_curr := COALESCE (outTotalSummPriceList_curr, 0) - COALESCE (outTotalChangePercent_curr, 0) ;
             -- переводим из ГРН в Валюту + округление
             -- outTotalPay_curr := zfCalc_SummIn (1, zfCalc_CurrencyTo (outTotalPay, outCurrencyValue, outParValue), 1);
         ELSE
             -- расчитали для Валюты
             outTotalPay_curr := COALESCE (outTotalSummPriceList_curr, 0) - COALESCE (outTotalChangePercent_curr, 0) ;
             -- расчитали для ГРН
             outTotalPay      := COALESCE (outTotalSummPriceList, 0)      - COALESCE (outTotalChangePercent,      0) ;
             -- переводим из Валюты в ГРН + округление
             -- outTotalPay      := zfCalc_SummIn (1, zfCalc_CurrencyFrom (outTotalPay_curr, outCurrencyValue, outParValue), 1);
         END IF;

     ELSE
         -- взяли ту что есть
         outTotalPay      := COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalPay()),      0);
         outTotalPay_curr := COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalPay_curr()), 0);
     END IF;


     -- вернули Сумма к оплате
     IF vbCurrencyId_Client = zc_Currency_GRN()
     THEN
         -- расчитали для ГРН
         outTotalSummToPay      := COALESCE (outTotalSummPriceList, 0)      - COALESCE (outTotalChangePercent,      0) ;
         -- расчитали для Валюты
         outTotalSummToPay_curr := COALESCE (outTotalSummPriceList_curr, 0) - COALESCE (outTotalChangePercent_curr, 0) ;
         -- переводим из ГРН в Валюту + округление
         -- outTotalSummPriceList_curr := zfCalc_SummIn (1, zfCalc_CurrencyTo (outTotalSummPriceList, outCurrencyValue, outParValue), 1);
     ELSE
         -- расчитали для Валюты
         outTotalSummToPay_curr := COALESCE (outTotalSummPriceList_curr, 0) - COALESCE (outTotalChangePercent_curr, 0) ;
         -- расчитали для ГРН
         outTotalSummToPay      := COALESCE (outTotalSummPriceList, 0)      - COALESCE (outTotalChangePercent,      0) ;
         -- переводим из Валюты в ГРН + округление
         -- outTotalSummPriceList      := zfCalc_SummIn (1, zfCalc_CurrencyFrom (outTotalSummPriceList_curr, outCurrencyValue, outParValue), 1);
     END IF;


     -- вернули Сумма долга в продаже
     IF vbCurrencyId_Client = zc_Currency_GRN()
     THEN
         -- расчитали для ГРН
         outTotalSummDebt      := COALESCE (outTotalSummToPay, 0)      - COALESCE (outTotalPay,      0) ;
         -- расчитали для Валюты
         outTotalSummDebt_curr := COALESCE (outTotalSummToPay_curr, 0) - COALESCE (outTotalPay_curr, 0) ;
         -- переводим из ГРН в Валюту + округление
         -- outTotalSummDebt_curr := zfCalc_SummPriceList (1, zfCalc_CurrencyTo (outTotalSummDebt, outCurrencyValue, outParValue));
     ELSE
         -- расчитали для Валюты
         outTotalSummDebt_curr := COALESCE (outTotalSummToPay_curr, 0) - COALESCE (outTotalPay_curr, 0) ;
         -- расчитали для ГРН
         outTotalSummDebt      := COALESCE (outTotalSummToPay, 0)      - COALESCE (outTotalPay,      0) ;
         -- переводим из Валюты в ГРН + округление
         -- outTotalSummDebt      := zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (outTotalSummDebt_curr, outCurrencyValue, outParValue));
     END IF;
     

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
                                                -- передаем цену прайса в ГРН
                                              , inOperPriceList         := vbOperPriceList_pl
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


     -- сохранили -
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalChangePercent_curr(), ioId, COALESCE (outTotalChangePercent_curr, 0));
     -- сохранили - Цена факт ГРН
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceListReal(), ioId
                                             , CASE WHEN ioAmount <> 0 THEN (COALESCE (outTotalSummPriceList, 0) - COALESCE (outTotalChangePercent, 0)) / ioAmount ELSE 0 END
                                              );
     -- сохранили - Цена Прайс (в валюте) - !!! ВРЕМЕННО - zc_Currency_EUR!!!
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList_curr(), ioId, vbOperPriceList_curr);
     -- сохранили - Валюта (цена прайса) - в какой валюте была цена прайса, что б обратным счетом не получать ошибку на округлениях
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Currency_pl(), ioId, vbCurrencyId_pl);

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
                    , COALESCE (tmpMI.CurrencyValue, 0)                         AS CurrencyValue
                    , COALESCE (tmpMI.CurrencyId, 0)                            AS ParValue
               FROM (SELECT vbCashId AS CashId, zc_Currency_GRN() AS CurrencyId
                    ) AS _tmpCash
                    FULL JOIN tmpMI ON tmpMI.CashId = _tmpCash.CashId
              ) AS tmp
         ;

         -- в мастер записать - Дополнительная скидка в продаже ГРН - т.к. могли обнулить
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent(), ioId, COALESCE (ioSummChangePercent, 0));
         -- в мастер записать - Дополнительная скидка в продаже в вал  - т.к. могли обнулить
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent_curr(), ioId, COALESCE (ioSummChangePercent_curr, 0));

         -- в мастер записать - Итого оплата в продаже ГРН
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPay(),      ioId, outTotalPay);
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPay_curr(), ioId, outTotalPay_curr);

         -- пересчитали Итоговые суммы по накладной
         PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     END IF;


     -- в мастер записать - Курс - из истории !!!в проводках убрал!!!
     -- PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CurrencyValue(), ioId, outCurrencyValue)
     --       , lpInsertUpdate_MovementItemFloat (zc_MIFloat_ParValue(),      ioId, outParValue)
     --        ;


     -- "сложно" пересчитали "итоговые" суммы по элементу
     PERFORM lpUpdate_MI_Sale_Total (ioId);


     -- вернули Дополнительная скидка в расчетах, для грида
     outTotalChangePercentPay     := COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalChangePercentPay()),      0);
     outTotalChangePercentPay_curr:= COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalChangePercentPay_curr()), 0);

     -- вернули Итого оплата в расчетах, для грида
     outTotalPayOth     := COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalPayOth()),      0);
     outTotalPayOth_curr:= COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalPayOth_curr()), 0);

     -- вернули Кол-во возврат, для грида
     outTotalCountReturn:= COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalCountReturn()), 0);
     -- вернули Сумма возврата ГРН, для грида
     outTotalReturn:= COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalReturn()), 0);
     -- вернули Сумма возврата оплаты ГРН, для грида
     outTotalPayReturn:= COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalPayReturn()), 0);

     -- Обнуляем Штрих-код поставщика для верхнего грида
     outBarCode_partner:= '';

-- if inSession = '2'
-- then
--    RAISE EXCEPTION 'Ошибка.<%>', ioOperPriceList;
-- end if;


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
-- SELECT * FROM gpInsertUpdate_MovementItem_SalePodium (ioId := 0 , inMovementId := 8 , ioGoodsId := 446 , inPartionId := 50 , inIsPay := False ,  ioAmount := 4 ,ioSummChangePercent:=0, ioOperPriceList := 1030 , inBarCode_partner := '1' ::TVarChar,  inSession := zfCalc_UserAdmin());
