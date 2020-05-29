-- Function: gpInsertUpdate_MovementItem_SalePodium_update()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SalePodium_update (Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_SalePodium_update(
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
                                       
 INOUT ioOperPriceList                  TFloat    , -- *** - Цена факт ГРН

    IN inSession                        TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbOperDate      TDateTime;
--   DECLARE vbCurrencyId    Integer;
   DECLARE vbCurrencyId_pl Integer;
   DECLARE vbUnitId        Integer;
   DECLARE vbUnitId_user   Integer;
   DECLARE vbClientId      Integer;
--   DECLARE vbCashId        Integer;

   DECLARE vbPriceListId        Integer; -- *Прайс магазина, может быть как в ГРН так и в ВАЛЮТЕ
   DECLARE vbCurrencyValue_pl   TFloat;  -- *Курс для перевода из валюты прайса в ГРН
   DECLARE vbParValue_pl        TFloat;  -- *Номинал для перевода из валюты прайса в ГРН
   DECLARE vbOperPriceList_pl   TFloat;  -- *Цена из прайса - переводим в ГРН
   DECLARE vbOperPriceList_curr TFloat;  -- *Цена из прайса - в той валюте что есть

   DECLARE vbIsOperPriceListReal Boolean; -- режим

--   DECLARE outCountForPrice TFloat;
  --  DECLARE outCountForPrice TFloat;

   DECLARE outTotalSummPriceList            TFloat    ; -- +Сумма по прайсу в ГРН
   DECLARE outTotalSummPriceList_curr       TFloat    ; -- +Сумма по прайсу в валюте***

   DECLARE outTotalChangePercent            TFloat    ; -- *+Итого скидка в продаже ГРН
   DECLARE outTotalChangePercent_curr       TFloat    ; -- *+Итого скидка в продаже в валюте***

   DECLARE outTotalChangePercentPay         TFloat    ; -- *Дополнительная скидка в расчетах ГРН
   DECLARE outTotalChangePercentPay_curr    TFloat    ; -- *Дополнительная скидка в валюте***

--   DECLARE outTotalPay                      TFloat    ; -- *+Итого оплата в продаже ГРН
  -- DECLARE outTotalPay_curr                 TFloat    ; -- *+Итого оплата в продаже в валюте***

BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale());
     vbUserId:= lpGetUserBySession (inSession);

     -- Получили для Пользователя - к какому Подразделению он привязан
     vbUnitId_user:= lpGetUnit_byUser (vbUserId);

     
     -- режим
     vbIsOperPriceListReal:= TRUE;

     -- замена
     inIsPay:= TRUE;


     -- параметры из Документа
     SELECT Movement.OperDate
          , COALESCE (MovementLinkObject_From.ObjectId, 0)            AS UnitId
          , COALESCE (MovementLinkObject_To.ObjectId, 0)              AS ClientId
            -- Прайс для Магазина, если установлен
          , COALESCE (OL_pl.ChildObjectId, zc_PriceList_Basis())      AS PriceListId
            INTO vbOperDate, vbUnitId, vbClientId, vbPriceListId
     FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN ObjectLink AS OL_pl ON OL_pl.ObjectId = MovementLinkObject_From.ObjectId
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
    --      , COALESCE (Object_PartionGoods.CountForPrice, 1)                AS CountForPrice
  --        , COALESCE (Object_PartionGoods.OperPrice, 0)                    AS OperPrice
--          , COALESCE (Object_PartionGoods.CurrencyId, zc_Currency_Basis()) AS CurrencyId
            INTO ioGoodsId -- , outCountForPrice, outOperPrice, vbCurrencyId
     FROM Object_PartionGoods
     WHERE Object_PartionGoods.MovementItemId = inPartionId;

     -- проверка - свойство должно быть установлено
     IF COALESCE (ioGoodsId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Товар>.';
     END IF;

/*
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
     */

     -- Всегда, а не только - Если цена прайса НЕ в Базовой Валюте
     IF 1=1 OR COALESCE (vbCurrencyId_pl, 0) <> zc_Currency_Basis()
     THEN
         -- Определили курс на Дату документа
         SELECT COALESCE (tmp.Amount, 0), COALESCE (tmp.ParValue, 0)
                INTO vbCurrencyValue_pl, vbParValue_pl
         FROM lfSelect_Movement_Currency_byDate (inOperDate      := vbOperDate
                                               , inCurrencyFromId:= zc_Currency_Basis()
                                                 -- !!! ВРЕМЕННО - zc_Currency_EUR !!!
                                               , inCurrencyToId  := zc_Currency_EUR() -- vbCurrencyId_pl
                                                ) AS tmp;
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
                        OR ObjectFloat_PeriodYear.ValueData > 2020
                          )
                   )
         THEN
             SELECT tmp.ChangePercent, tmp.DiscountSaleKindId INTO ioChangePercent, ioDiscountSaleKindId
             FROM zfSelect_DiscountSaleKind (vbOperDate, vbUnitId, ioGoodsId, vbClientId, vbUserId) AS tmp;

     ioChangePercent :=  COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.DescId = zc_MIFloat_ChangePercent() AND MIF.MovementItemId = ioId), 0);

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
          IF vbCurrencyId_pl <> zc_Currency_Basis()
          THEN
              -- переводим в ГРН
              vbOperPriceList_pl:= zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (vbOperPriceList_curr, vbCurrencyValue_pl, vbParValue_pl));
          ELSE
              -- она в прайсе в ГРН
              vbOperPriceList_pl:= vbOperPriceList_curr;
              -- !!! ВРЕМЕННО - а здесь надо в zc_Currency_EUR !!!
              vbOperPriceList_curr:= zfCalc_SummPriceList (1, zfCalc_CurrencySumm (vbOperPriceList_curr, vbCurrencyId_pl, zc_Currency_EUR(), vbCurrencyValue_pl, vbParValue_pl));
          END IF;

          -- цена в ГРН из Истории со скидкой - ТОЛЬКО когда INSERT
          IF COALESCE (ioId, 0) = 0 AND vbIsOperPriceListReal = TRUE
          THEN
              -- на самом деле возвращается в грид как Цена факт ГРН
              ioOperPriceList := zfCalc_SummChangePercent (1, vbOperPriceList_pl, ioChangePercent);
          END IF;
     
     END IF;


                 -- посчитали если PriceListReal
                 ioSummChangePercent     := zfCalc_SummChangePercent (ioAmount, vbOperPriceList_pl, ioChangePercent)
                                          - zfCalc_SummPriceList (ioAmount, ioOperPriceList);
                 --
                 ioSummChangePercent_curr:= zfCalc_SummChangePercent (ioAmount, vbOperPriceList_curr, ioChangePercent)
                                            -- !!! ВРЕМЕННО - zc_Currency_EUR !!!
                                          - zfCalc_SummPriceList (ioAmount, zfCalc_CurrencySumm (ioOperPriceList, zc_Currency_Basis(), zc_Currency_EUR(), vbCurrencyValue_pl, vbParValue_pl));




     -- вернули Сумма вх. в валюте, для грида - Округлили до 2-х Знаков
--     outTotalSumm := zfCalc_SummIn (ioAmount, outOperPrice, outCountForPrice);
     -- вернули сумму вх. в грн по элементу, для грида
--     outTotalSummBalance := zfCalc_CurrencyFrom (outTotalSumm, outCurrencyValue, outParValue);
     -- расчитали Сумма по прайсу по элементу, для грида
     outTotalSummPriceList := zfCalc_SummPriceList (ioAmount, vbOperPriceList_pl);
     -- расчитали Сумма по прайсу по элементу, для грида
     outTotalSummPriceList_curr := zfCalc_SummPriceList (ioAmount, vbOperPriceList_curr);

     -- расчитали Итого скидка в продаже ГРН, для грида - !!!Округлили до НОЛЬ Знаков - только %, ВСЕ округлять - нельзя!!!
     IF vbIsOperPriceListReal = FALSE
     THEN
         outTotalChangePercent      := outTotalSummPriceList      - zfCalc_SummChangePercent (ioAmount, vbOperPriceList_pl,   ioChangePercent) + COALESCE (ioSummChangePercent,      0);
         outTotalChangePercent_curr := outTotalSummPriceList_curr - zfCalc_SummChangePercent (ioAmount, vbOperPriceList_curr, ioChangePercent) + COALESCE (ioSummChangePercent_curr, 0);
     ELSE
         -- !!!режим!!!
         outTotalChangePercent      := outTotalSummPriceList      - zfCalc_SummChangePercent (ioAmount, vbOperPriceList_pl,   ioChangePercent) + COALESCE (ioSummChangePercent, 0);
         outTotalChangePercent_curr := outTotalSummPriceList_curr - zfCalc_SummChangePercent (ioAmount, vbOperPriceList_curr, ioChangePercent) + COALESCE (ioSummChangePercent_curr, 0);
     END IF;

/*
     -- вернули Итого оплата в продаже ГРН, для грида
     IF inIsPay = TRUE
     THEN
         outTotalPay      := COALESCE (outTotalSummPriceList, 0)      - COALESCE (outTotalChangePercent,      0) ;
         outTotalPay_curr := COALESCE (outTotalSummPriceList_curr, 0) - COALESCE (outTotalChangePercent_curr, 0) ;
     ELSE
         outTotalPay      := COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalPay()),      0);
         outTotalPay_curr := COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalPay_curr()), 0);
     END IF;


     -- вернули Сумма к оплате
     outTotalSummToPay      := COALESCE (outTotalSummPriceList, 0)      - COALESCE (outTotalChangePercent,      0) ;
     outTotalSummToPay_curr := COALESCE (outTotalSummPriceList_curr, 0) - COALESCE (outTotalChangePercent_curr, 0) ;

     -- вернули Сумма долга в продаже ГРН
     outTotalSummDebt      := COALESCE (outTotalSummToPay, 0)      - COALESCE (outTotalPay,      0) ;
     outTotalSummDebt_curr := COALESCE (outTotalSummToPay_curr, 0) - COALESCE (outTotalPay_curr, 0) ;

*/


     -- сохранили
     -- ioId:= lpInsertUpdate_MovementItem_Sale   (ioId                    := ioId

     -- сохранили - Цена Прайс
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), ioId, vbOperPriceList_pl);

     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), ioId, ioChangePercent);

     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalChangePercent(), ioId, outTotalChangePercent);


     -- сохранили - Цена факт ГРН
     -- PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceListReal(), ioId, CASE WHEN ioAmount <> 0 THEN (COALESCE (outTotalSummPriceList, 0) - COALESCE (outTotalChangePercent, 0)) / ioAmount ELSE 0 END);


     -- сохранили - Цена Прайс (в валюте) - !!! ВРЕМЕННО - zc_Currency_EUR!!!
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList_curr(), ioId, vbOperPriceList_curr);
     -- сохранили - Валюта (цена прайса) - в какой валюте была цена прайса, что б обратным счетом не получать ошибку на округлениях
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Currency_pl(), ioId, vbCurrencyId_pl);
         
     -- сохранили - 
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalChangePercent_curr(), ioId, COALESCE (outTotalChangePercent_curr, 0));



         -- в мастер записать - Дополнительная скидка в продаже ГРН - т.к. могли обнулить
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent(), ioId, COALESCE (ioSummChangePercent, 0));
         -- в мастер записать - Дополнительная скидка в продаже в вал  - т.к. могли обнулить
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent_curr(), ioId, COALESCE (ioSummChangePercent_curr, 0));

         -- в мастер записать - Итого оплата в продаже ГРН
--         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPay(),      ioId, outTotalPay);
  --       PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPay_curr(), ioId, outTotalPay_curr);

         -- пересчитали Итоговые суммы по накладной
         PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);


     -- "сложно" пересчитали "итоговые" суммы по элементу
     PERFORM lpUpdate_MI_Sale_Total (ioId);


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
/*
select 
   gpInsertUpdate_MovementItem_SalePodium_update(
      ioId                             := MovementItem.Id
    , inMovementId                     := MovementItem.MovementId
    , ioGoodsId                        := MovementItem.ObjectId
    , inPartionId                      := MovementItem.PartionId
    , ioDiscountSaleKindId             := 0
    , inIsPay                          := TRUE
    , ioAmount                         := MovementItem.Amount
    , ioChangePercent                  := 0
                                        
    , ioSummChangePercent              := 0
    , ioSummChangePercent_curr         := 0
                                       
    , ioOperPriceList                  := MIFloat_OperPriceListReal.ValueData

    , inSession                        := '2'
)
, *
      from Movement
          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                 AND MovementItem.DescId     = zc_MI_Master()
                                 AND MovementItem.isErased   = FALSE
          LEFT JOIN MovementItemFloat AS MIFloat_OperPriceListReal
                                      ON MIFloat_OperPriceListReal.MovementItemId = MovementItem.Id
                                     AND MIFloat_OperPriceListReal.DescId         = zc_MIFloat_OperPriceListReal()
WHERE Movement.DescId = zc_Movement_Sale()
and Movement.StatusId = zc_Enum_Status_Complete()
and Movement.Id = 3409 
*/
