-- Function: gpInsertUpdate_MovementItem_Sale()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Sale(
 INOUT ioId                   Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId           Integer   , -- Ключ объекта <Документ>
 INOUT ioGoodsId              Integer   , -- *** - Товар
    IN inPartionId            Integer   , -- Партия
 INOUT ioDiscountSaleKindId   Integer   , -- *** - Вид скидки при продаже
    IN inIsPay                Boolean   , -- добавить с оплатой
    IN inAmount               TFloat    , -- Количество
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
    IN inBarCode                TVarChar  , -- Штрих-код поставщика
    IN inComment                TVarChar  , -- примечание
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPartionId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbCurrencyId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbClientId Integer;
   DECLARE vbCashId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale());


     -- проверка - документ должен быть сохранен
     IF COALESCE (inMovementId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Документ не сохранен.';
     END IF;
     -- проверка - свойство должно быть установлено
     IF COALESCE (inPartionId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Партия>.';
     END IF;

     -- параметры из Документа
     SELECT Movement.OperDate
          , MovementLinkObject_From.ObjectId
          , MovementLinkObject_To.ObjectId
            INTO vbOperDate, vbUnitId, vbClientId
     FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
     WHERE Movement.Id = inMovementId;

     -- Цена (прайс)
     IF vbUserId = zc_User_Sybase()
     THEN
         -- !!!для SYBASE - потом убрать!!!
         IF 1=0 THEN RAISE EXCEPTION 'Ошибка.Параметр только для загрузки из Sybase.'; END IF;
     ELSE
         -- из Истории
         ioOperPriceList := COALESCE ((SELECT tmp.ValuePrice FROM lpGet_ObjectHistory_PriceListItem (vbOperDate
                                                                                                   , zc_PriceList_Basis()
                                                                                                   , ioGoodsId
                                                                                                    ) AS tmp), 0);
         -- проверка - свойство должно быть установлено
         IF COALESCE (ioOperPriceList, 0) <= 0 THEN
            RAISE EXCEPTION 'Ошибка.Не установлено значение <Цена (прайс)>.';
         END IF;

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


     -- Скидка
     IF vbUserId = zc_User_Sybase()
     THEN
         -- !!!для SYBASE - потом убрать!!!
         IF 1=0 THEN RAISE EXCEPTION 'Ошибка.Параметр только для загрузки из Sybase.'; END IF;

     ELSE
         -- расчет
         SELECT tmp.ChangePercent, tmp.DiscountSaleKindId INTO ioChangePercent, ioDiscountSaleKindId
         FROM zfSelect_DiscountSaleKind (vbOperDate, vbUnitId, ioGoodsId, vbClientId, vbUserId) AS tmp;

         -- Дополнительная скидка в продаже ГРН
         IF inIsPay = TRUE
         THEN 
             -- !!!обнулили!!!
             ioSummChangePercent:= 0;
         ELSE
             -- взяли ту что есть
             ioSummChangePercent:= COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummChangePercent()), 0);
         END IF;

     END IF;
     -- вернули название Скики
     outDiscountSaleKindName := (SELECT Object.ValueData FROM Object WHERE Object.Id = ioDiscountSaleKindId);


     -- вернули Сумма вх. в валюте, для грида - Округлили до 2-х Знаков
     outTotalSumm := CASE WHEN outCountForPrice > 0
                                THEN CAST (inAmount * outOperPrice / outCountForPrice AS NUMERIC (16, 2))
                           ELSE CAST (inAmount * outOperPrice AS NUMERIC (16, 2))
                      END;
     -- вернули Сумма вх. ГРН, для грида - Округлили до 2-х Знаков
     outTotalSummBalance := CAST (outTotalSumm * outCurrencyValue / CASE WHEN outParValue <> 0 THEN outParValue ELSE 1 END AS NUMERIC (16, 2));

     -- вернули Сумма по прайсу, для грида - !!!Округлили до НОЛЬ Знаков!!!
     outTotalSummPriceList := CAST (inAmount * ioOperPriceList AS NUMERIC (16, 0));

     -- вернули Итого скидка в продаже ГРН, для грида - !!!Округлили до НОЛЬ Знаков - только %, ВСЕ - нельзя!!!
     outTotalChangePercent := CAST (outTotalSummPriceList * COALESCE (ioChangePercent, 0) / 100 AS NUMERIC (16, 0)) + COALESCE (ioSummChangePercent, 0) ;

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


     -- сохранили
     ioId:= lpInsertUpdate_MovementItem_Sale   (ioId                    := ioId
                                              , inMovementId            := inMovementId
                                              , inGoodsId               := ioGoodsId
                                              , inPartionId             := COALESCE (inPartionId, 0)
                                              , inDiscountSaleKindId    := ioDiscountSaleKindId
                                              , inAmount                := inAmount
                                              , inChangePercent         := COALESCE (ioChangePercent, 0)
                                              -- , inSummChangePercent     := COALESCE (ioSummChangePercent, 0)
                                              , inOperPrice             := COALESCE (outOperPrice, 0)
                                              , inCountForPrice         := COALESCE (outCountForPrice, 0)
                                              , inOperPriceList         := ioOperPriceList
                                              , inCurrencyValue         := outCurrencyValue
                                              , inParValue              := outParValue
                                              , inTotalChangePercent    := COALESCE (outTotalChangePercent, 0)
                                              -- , inTotalChangePercentPay := COALESCE (outTotalChangePercentPay, 0)
                                              -- , inTotalPay              := COALESCE (outTotalPay, 0)
                                              -- , inTotalPayOth           := COALESCE (outTotalPayOth, 0)
                                              -- , inTotalCountReturn      := COALESCE (outTotalCountReturn, 0)
                                              -- , inTotalReturn           := COALESCE (outTotalReturn, 0)
                                              -- , inTotalPayReturn        := COALESCE (outTotalPayReturn, 0)
                                              , inBarCode               := inBarCode
                                              , inComment               := inComment
                                              , inUserId                := vbUserId
                                               );

    -- !!!для SYBASE - потом убрать!!!
    IF vbUserId = zc_User_Sybase() AND SUBSTRING (inComment FROM 1 FOR 5) = '*123*'
    THEN
        -- убрали хардкод
        inComment:= SUBSTRING (inComment FROM 6 FOR CHAR_LENGTH (inComment) - 5);

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
       vbCashId := (SELECT Object_Cash.Id
                    FROM Object AS Object_Unit
                         LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                              ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                                             AND ObjectLink_Unit_Parent.DescId   = zc_ObjectLink_Unit_Parent()
                         LEFT JOIN ObjectLink AS ObjectLink_Cash_Unit
                                              ON ObjectLink_Cash_Unit.ChildObjectId = Object_Unit.Id
                                             AND ObjectLink_Cash_Unit.DescId        = zc_ObjectLink_Cash_Unit()
                         LEFT JOIN ObjectLink AS ObjectLink_Cash_Unit_Parent
                                              ON ObjectLink_Cash_Unit_Parent.ChildObjectId = ObjectLink_Unit_Parent.ChildObjectId
                                             AND ObjectLink_Cash_Unit_Parent.DescId        = zc_ObjectLink_Cash_Unit()
                                             AND ObjectLink_Cash_Unit.ChildObjectId        IS NULL
                         INNER JOIN Object AS Object_Cash
                                           ON Object_Cash.Id       = COALESCE (ObjectLink_Cash_Unit.ObjectId, ObjectLink_Cash_Unit_Parent.ObjectId)
                                          AND Object_Cash.DescId   = zc_Object_Cash()
                                          AND Object_Cash.isErased = FALSE
                         INNER JOIN ObjectLink AS ObjectLink_Cash_Currency
                                               ON ObjectLink_Cash_Currency.ObjectId      = Object_Cash.Id
                                              AND ObjectLink_Cash_Currency.DescId        = zc_ObjectLink_Cash_Currency()
                                              AND ObjectLink_Cash_Currency.ChildObjectId = zc_Currency_GRN()
                    WHERE Object_Unit.Id = vbUnitId
                   );


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
       PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent(), ioId, ioSummChangePercent);

       -- в мастер записать - Итого оплата в продаже ГРН
       PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPay(), ioId, outTotalPay);

    END IF;


    -- "сложно" пересчитали "итоговые" суммы по элементу
    PERFORM lpUpdate_MI_Sale_Total(ioId);

     -- Дополнительная скидка в расчетах ГРН
     outTotalChangePercentPay:= COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalChangePercentPay()), 0);
     -- Итого оплата в расчетах ГРН
     outTotalPayOth:= COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalPayOth()), 0);

    -- Кол-во возврат
    outTotalCountReturn:= COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalCountReturn()), 0);
    -- Сумма возврата ГРН
    outTotalReturn:= COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalReturn()), 0);
    -- Сумма возврата оплаты ГРН
    outTotalPayReturn:= COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalPayReturn()), 0);
    

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
-- SELECT * FROM gpInsertUpdate_MovementItem_Sale (ioId := 0 , inMovementId := 8 , ioGoodsId := 446 , inPartionId := 50 , inIsPay := False ,  inAmount := 4 ,ioSummChangePercent:=0, ioOperPriceList := 1030 , inBarCode := '1' ::TVarChar,  inSession := zfCalc_UserAdmin());
