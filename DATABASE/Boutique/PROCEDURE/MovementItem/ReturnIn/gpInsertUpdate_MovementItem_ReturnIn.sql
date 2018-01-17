-- Function: gpInsertUpdate_MovementItem_ReturnIn()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ReturnIn(
 INOUT ioId                     Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId             Integer   , -- Ключ объекта <Документ>
 INOUT ioGoodsId                Integer   , -- Товары
    IN inPartionId              Integer   , -- Партия
    IN inSaleMI_Id              Integer   , -- строка док. продажи
    IN inIsPay                  Boolean   , -- добавить с оплатой
    IN inAmount                 TFloat    , -- Количество
   OUT outOperPrice             TFloat    , -- Цена вх. в валюте
   OUT outCountForPrice         TFloat    , -- Цена за количество
   OUT outTotalSumm             TFloat    , -- +Сумма вх. в валюте
   OUT outTotalSummBalance      TFloat    , -- +Сумма вх. (ГРН)
 INOUT ioOperPriceList          TFloat    , -- *** - Цена по прайсу
   OUT outTotalSummPriceList    TFloat    , -- +Сумма по прайсу
   OUT outCurrencyValue         TFloat    , -- *Курс для перевода из валюты
   OUT outParValue              TFloat    , -- *Номинал для перевода из валю
   OUT outTotalChangePercent    TFloat    , -- Итого сумма возврата Скидки (в ГРН)
   OUT outTotalPay              TFloat    , -- Итого сумма возврата оплаты (в ГРН)
   OUT outTotalPayOth           TFloat    , -- Итого сумма возврата оплаты  в расчетах (в ГРН)
   OUT outTotalSummToPay        TFloat    , -- +Сумма к возврату ГРН
    IN inComment                TVarChar  , -- примечание
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPartionMI_Id Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbCurrencyId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbClientId Integer;
   DECLARE vbCashId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ReturnIn());
     -- !!!временно - для Sybase!!!
     vbUserId := zc_User_Sybase() ;


     -- проверка - документ должен быть сохранен
     IF COALESCE (inMovementId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Документ не сохранен.';
     END IF;
     -- проверка - свойство должно быть установлено
     IF COALESCE (inPartionId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Партия>.';
     END IF;
     -- проверка - свойство должно быть установлено
     IF COALESCE (inSaleMI_Id, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не определен элемент Продажи.';
     END IF;


     -- данные из шапки
     SELECT Movement.OperDate                AS OperDate
          , MovementLinkObject_From.ObjectId AS ClientId
          , MovementLinkObject_To.ObjectId   AS UnitId
            INTO vbOperDate, vbClientId, vbUnitId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
     WHERE Movement.Id = inMovementId;


     -- определяем Партию элемента продажи/возврата
     vbPartionMI_Id := lpInsertFind_Object_PartionMI (inSaleMI_Id);


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

     -- Цена (прайс)
     IF vbUserId = zc_User_Sybase()
     THEN
         -- !!!для SYBASE - потом убрать!!!
         IF 1=0 THEN RAISE EXCEPTION 'Ошибка.Параметр только для загрузки из Sybase.'; END IF;
     ELSE
         -- из Элемента Продажи
         ioOperPriceList := (SELECT COALESCE (MIFloat_OperPriceList.ValueData, 0) AS OperPriceList
                             FROM MovementItemFloat AS MIFloat_OperPriceList
                             WHERE MIFloat_OperPriceList.MovementItemId = inSaleMI_Id
                               AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
                            );
         -- проверка - свойство должно быть установлено
         IF COALESCE (ioOperPriceList, 0) <= 0 THEN
            RAISE EXCEPTION 'Ошибка.Не установлено значение <Цена (прайс)>. (%)', inSaleMI_Id;
         END IF;

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


     -- вернули Сумма вх. в валюте, для грида - Округлили до 2-х Знаков
     outTotalSumm := zfCalc_SummIn (inAmount, outOperPrice, outCountForPrice);
     -- вернули сумму вх. в грн по элементу, для грида
     outTotalSummBalance := zfCalc_CurrencyFrom (outTotalSumm, outCurrencyValue, outParValue);

     -- расчитали сумму по прайсу по элементу, для грида
     outTotalSummPriceList := zfCalc_SummPriceList (inAmount, ioOperPriceList);

     -- расчитали Итого оплата в возврате ГРН, для грида - !!!из Элемента Продажи!!!
     IF inIsPay = TRUE
     THEN
         outTotalPay := COALESCE ((SELECT CASE -- если вернули все - Вся сумма ОПЛАТЫ
                                               WHEN MovementItem.Amount = inAmount
                                                    THEN COALESCE (MIFloat_TotalPay.ValueData, 0) + COALESCE (MIFloat_TotalPayOth.ValueData, 0)

                                               -- если вернули все что осталось - тогда возвращаем Остаток для сумма ОПЛАТЫ к возврату
                                               WHEN MovementItem.Amount - COALESCE (MIFloat_TotalCountReturn.ValueData, 0) = inAmount
                                                    THEN COALESCE (MIFloat_TotalPay.ValueData, 0) + COALESCE (MIFloat_TotalPayOth.ValueData, 0) - COALESCE (MIFloat_TotalPayReturn.ValueData, 0)

                                               -- если возрат * "Цену к оплате" больше чем остаток оплаты - тогда тоже возвращаем Остаток для сумма ОПЛАТЫ к возврату
                                               WHEN (zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData)
                                                   - COALESCE (MIFloat_TotalChangePercent.ValueData, 0) - COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0)
                                                    )
                                                  / MovementItem.Amount * inAmount
                                                      >= COALESCE (MIFloat_TotalPay.ValueData, 0) + COALESCE (MIFloat_TotalPayOth.ValueData, 0) - COALESCE (MIFloat_TotalPayReturn.ValueData, 0)

                                                    THEN COALESCE (MIFloat_TotalPay.ValueData, 0) + COALESCE (MIFloat_TotalPayOth.ValueData, 0) - COALESCE (MIFloat_TotalPayReturn.ValueData, 0)

                                               -- иначе возрат * Цену к оплате
                                               ELSE ROUND ((zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData)
                                                          - COALESCE (MIFloat_TotalChangePercent.ValueData, 0) - COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0)
                                                           )
                                                         / MovementItem.Amount * inAmount, 2)
                                          END
                                   FROM MovementItem
                                        LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                                    ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                                   AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()

                                        LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                                    ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                                   AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                                        LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth
                                                                    ON MIFloat_TotalPayOth.MovementItemId = MovementItem.Id
                                                                   AND MIFloat_TotalPayOth.DescId         = zc_MIFloat_TotalPayOth()
                                        LEFT JOIN MovementItemFloat AS MIFloat_TotalPayReturn
                                                                    ON MIFloat_TotalPayReturn.MovementItemId = MovementItem.Id
                                                                   AND MIFloat_TotalPayReturn.DescId         = zc_MIFloat_TotalPayReturn()

                                        LEFT JOIN MovementItemFloat AS MIFloat_TotalCountReturn
                                                                    ON MIFloat_TotalCountReturn.MovementItemId = MovementItem.Id
                                                                   AND MIFloat_TotalCountReturn.DescId         = zc_MIFloat_TotalCountReturn()

                                        LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                                                    ON MIFloat_TotalChangePercent.MovementItemId = MovementItem.Id
                                                                   AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()
                                        LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercentPay
                                                                    ON MIFloat_TotalChangePercentPay.MovementItemId = MovementItem.Id
                                                                   AND MIFloat_TotalChangePercentPay.DescId         = zc_MIFloat_TotalChangePercentPay()

                                   WHERE MovementItem.Id         = inSaleMI_Id
                                     -- AND MovementItem.MovementId = inMovementId
                                     AND MovementItem.DescId     = zc_MI_Master()
                                     AND MovementItem.isErased   = FALSE
                                  ), 0);
     ELSE
         outTotalPay := COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalPay()), 0);
     END IF;

     -- расчитали Итого сумма возврата Скидки (в ГРН)
     outTotalChangePercent:= (SELECT CASE -- если вернули все - тогда вся скидка из продажи
                                          WHEN MovementItem.Amount = inAmount
                                               THEN COALESCE (MIFloat_TotalChangePercent.ValueData, 0) + COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0)

                                          -- !!!Сложный расчет - для Sybase - что б после возврата оплаты ДОЛГ был = 0 - только для №п/п=1!!!
                                          WHEN vbUserId = zc_User_Sybase()
                                           AND MIBoolean_Close.ValueData = TRUE
                                               -- №п/п=1
                                           AND COALESCE (ioId, 0) = COALESCE ((SELECT tmp.Id
                                                                               FROM (SELECT MovementItem.Id
                                                                                          , ROW_NUMBER() OVER (PARTITION BY MIL_PartionMI.ObjectId ORDER BY Movement.OperDate ASC, MovementItem.Id ASC) AS Ord
                                                                                     FROM MovementItemLinkObject AS MIL_PartionMI
                                                                                          INNER JOIN MovementItem ON MovementItem.Id       = MIL_PartionMI.MovementItemId
                                                                                                                 AND MovementItem.DescId   = zc_MI_Master()
                                                                                                                 AND MovementItem.isErased = FALSE
                                                                                          INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                                                             AND Movement.DescId   = zc_Movement_ReturnIn()
                                                                                                             AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                                                                                          LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                                                                                      ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                                                                                     AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
      
                                                                                     WHERE MIL_PartionMI.DescId   = zc_MILinkObject_PartionMI()
                                                                                       AND MIL_PartionMI.ObjectId = vbPartionMI_Id
      
                                                                                    ) AS tmp
                                                                               WHERE tmp.Ord = 1
                                                                              ), 0)

                                               THEN 0 - (-- Сумма по Прайсу
                                                         zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData)
                                                         -- МИНУС сколько скидки !!!только из Продажи, т.к. для Sybase скидки по Оплатам=0!!!
                                                       - COALESCE (MIFloat_TotalChangePercent.ValueData, 0)
                                                         -- МИНУС Итого сумма оплаты !!!только из Продажи!!!
                                                       - COALESCE (MIFloat_TotalPay.ValueData, 0)
                                                         -- МИНУС сумма оплаты !!!Расчеты - ВСЕ Статусы!!!
                                                       - COALESCE ((SELECT SUM (COALESCE (MIFloat_TotalPay.ValueData, 0))
                                                                    FROM MovementItemLinkObject AS MIL_PartionMI
                                                                         INNER JOIN MovementItem ON MovementItem.Id       = MIL_PartionMI.MovementItemId
                                                                                                AND MovementItem.DescId   = zc_MI_Master()
                                                                                                AND MovementItem.isErased = FALSE
                                                                         INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                                            AND Movement.DescId   = zc_Movement_GoodsAccount()
                                                                                            AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                                                                         LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                                                                     ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                                                                    AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()

                                                                    WHERE MIL_PartionMI.DescId   = zc_MILinkObject_PartionMI()
                                                                      AND MIL_PartionMI.ObjectId = vbPartionMI_Id

                                                                   ), 0)
                                                         -- МИНУС ИТОГО - Сумма ВОЗВРАТ по Прайсу
                                                       - zfCalc_SummPriceList (COALESCE ((SELECT SUM (MovementItem.Amount)
                                                                                          FROM MovementItemLinkObject AS MIL_PartionMI
                                                                                               INNER JOIN MovementItem ON MovementItem.Id       = MIL_PartionMI.MovementItemId
                                                                                                                      AND MovementItem.DescId   = zc_MI_Master()
                                                                                                                      AND MovementItem.isErased = FALSE
                                                                                               INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                                                                  AND Movement.DescId   = zc_Movement_ReturnIn()
                                                                                                                  AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                                                                                          WHERE MIL_PartionMI.DescId   = zc_MILinkObject_PartionMI()
                                                                                            AND MIL_PartionMI.ObjectId = vbPartionMI_Id
                      
                                                                                         ), 0)
                                                                             , MIFloat_OperPriceList.ValueData)
                                                         -- ПЛЮС ИТОГО - Сумма ВОЗВРАТ ОПЛАТЫ
                                                       + COALESCE ((SELECT SUM (COALESCE (MIFloat_TotalPay.ValueData, 0))
                                                                    FROM MovementItemLinkObject AS MIL_PartionMI
                                                                         INNER JOIN MovementItem ON MovementItem.Id       = MIL_PartionMI.MovementItemId
                                                                                                AND MovementItem.DescId   = zc_MI_Master()
                                                                                                AND MovementItem.isErased = FALSE
                                                                         INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                                            AND Movement.DescId   = zc_Movement_ReturnIn()
                                                                                            AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                                                                         LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                                                                     ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                                                                    AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()

                                                                    WHERE MIL_PartionMI.DescId   = zc_MILinkObject_PartionMI()
                                                                      AND MIL_PartionMI.ObjectId = vbPartionMI_Id

                                                                   ), 0)
                                                         /*COALESCE ((SELECT MIFloat_TotalPay.ValueData
                                                                    FROM MovementItemFloat AS MIFloat_TotalPay
                                                                    WHERE MIFloat_TotalPay.MovementItemId = ioId
                                                                      AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                                                                   ), 0)*/
                                                        )

                                          -- !!!иначе - для Sybase - №п/п<>1!!!
                                          WHEN vbUserId = zc_User_Sybase()
                                           AND MIBoolean_Close.ValueData = TRUE
                                               THEN 0

                                          -- !!!для Sybase!!! если вернули все но не сразу - тогда вся скидка из продажи МИНУС сколько скидки вернули раньше
                                          WHEN vbUserId = zc_User_Sybase()
                                           AND MovementItem.Amount - COALESCE ((SELECT SUM (COALESCE (MovementItem.Amount, 0))
                                                                                FROM MovementItemLinkObject AS MIL_PartionMI
                                                                                     INNER JOIN MovementItem ON MovementItem.Id       = MIL_PartionMI.MovementItemId
                                                                                                            AND MovementItem.DescId   = zc_MI_Master()
                                                                                                            AND MovementItem.isErased = FALSE
                                                                                                            AND (MovementItem.Id < ioId OR COALESCE (ioId, 0) = 0)
                                                                                     INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                                                        AND Movement.DescId   = zc_Movement_ReturnIn()
                                                                                                        AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                                                                                WHERE MIL_PartionMI.DescId   = zc_MILinkObject_PartionMI ()
                                                                                  AND MIL_PartionMI.ObjectId = vbPartionMI_Id
            
                                                                               ), 0)
                                             = inAmount
                                               THEN COALESCE (MIFloat_TotalChangePercent.ValueData, 0) + COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0)
                                                    -- МИНУС сколько скидки вернули раньше
                                                  - COALESCE ((SELECT SUM (COALESCE (MIFloat_TotalChangePercent.ValueData, 0))
                                                               FROM MovementItemLinkObject AS MIL_PartionMI
                                                                    INNER JOIN MovementItem ON MovementItem.Id       = MIL_PartionMI.MovementItemId
                                                                                           AND MovementItem.DescId   = zc_MI_Master()
                                                                                           AND MovementItem.isErased = FALSE
                                                                                           AND (MovementItem.Id < ioId OR COALESCE (ioId, 0) = 0)
                                                                    INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                                       AND Movement.DescId   = zc_Movement_ReturnIn()
                                                                                       AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                                                                    LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                                                                                ON MIFloat_TotalChangePercent.MovementItemId = MovementItem.Id
                                                                                               AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()

                                                               WHERE MIL_PartionMI.DescId   = zc_MILinkObject_PartionMI ()
                                                                 AND MIL_PartionMI.ObjectId = vbPartionMI_Id

                                                              ), 0)

                                          -- если вернули все но не сразу - тогда вся скидка из продажи МИНУС сколько скидки вернули раньше
                                          WHEN MovementItem.Amount - COALESCE (MIFloat_TotalCountReturn.ValueData, 0)  = inAmount
                                               THEN COALESCE (MIFloat_TotalChangePercent.ValueData, 0) + COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0)
                                                    -- МИНУС сколько скидки вернули раньше
                                                  - COALESCE ((SELECT SUM (COALESCE (MIFloat_TotalChangePercent.ValueData, 0))
                                                               FROM MovementItemLinkObject AS MIL_PartionMI
                                                                    INNER JOIN MovementItem ON MovementItem.Id       = MIL_PartionMI.MovementItemId
                                                                                           AND MovementItem.DescId   = zc_MI_Master()
                                                                                           AND MovementItem.isErased = FALSE
                                                                    INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                                       AND Movement.DescId   = zc_Movement_ReturnIn()
                                                                                       AND Movement.StatusId = zc_Enum_Status_Complete()
                                                                    LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                                                                                ON MIFloat_TotalChangePercent.MovementItemId = MovementItem.Id
                                                                                               AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()

                                                               WHERE MIL_PartionMI.DescId   = zc_MILinkObject_PartionMI ()
                                                                 AND MIL_PartionMI.ObjectId = vbPartionMI_Id

                                                              ), 0)
                                          
                                          ELSE -- иначе почти пропроционально - ОКРУГЛИМ дробную часть после второго знака
                                               ROUND ((COALESCE (MIFloat_TotalChangePercent.ValueData, 0) + COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0))
                                                    / MovementItem.Amount * inAmount, 2)
                                     END
                             FROM MovementItem
                                LEFT JOIN MovementItemBoolean AS MIBoolean_Close
                                                              ON MIBoolean_Close.MovementItemId = MovementItem.Id
                                                             AND MIBoolean_Close.DescId         = zc_MIBoolean_Close()
                                LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                            ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                           AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                                LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                            ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                           AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
                                LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                                            ON MIFloat_TotalChangePercent.MovementItemId = MovementItem.Id
                                                           AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()
                                LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercentPay
                                                            ON MIFloat_TotalChangePercentPay.MovementItemId = MovementItem.Id
                                                           AND MIFloat_TotalChangePercentPay.DescId         = zc_MIFloat_TotalChangePercentPay()
                                LEFT JOIN MovementItemFloat AS MIFloat_TotalCountReturn
                                                            ON MIFloat_TotalCountReturn.MovementItemId = MovementItem.Id
                                                           AND MIFloat_TotalCountReturn.DescId         = zc_MIFloat_TotalCountReturn()

                             WHERE MovementItem.Id         = inSaleMI_Id
                               -- AND MovementItem.MovementId = inMovementId
                               AND MovementItem.DescId     = zc_MI_Master()
                               AND MovementItem.isErased   = FALSE
                            );

-- RAISE EXCEPTION '<%>', outTotalChangePercent;

     -- сохранили
     ioId:= lpInsertUpdate_MovementItem_ReturnIn (ioId                    := ioId
                                                , inMovementId            := inMovementId
                                                , inGoodsId               := ioGoodsId
                                                , inPartionId             := inPartionId
                                                , inPartionMI_Id          := vbPartionMI_Id
                                                , inAmount                := inAmount
                                                , inOperPrice             := COALESCE (outOperPrice, 0)
                                                , inCountForPrice         := COALESCE (outCountForPrice, 0)
                                                , inOperPriceList         := ioOperPriceList
                                                , inCurrencyValue         := outCurrencyValue
                                                , inParValue              := outParValue
                                                , inTotalChangePercent    := COALESCE (outTotalChangePercent, 0)
                                                , inComment               := -- !!!для SYBASE - потом убрать!!!
                                                                             CASE WHEN vbUserId = zc_User_Sybase() AND SUBSTRING (inComment FROM 1 FOR 5) = '*123*'
                                                                                       THEN -- убрали хардкод
                                                                                            SUBSTRING (inComment FROM 6 FOR CHAR_LENGTH (inComment) - 5)
                                                                                       ELSE inComment
                                                                             END
                                                , inUserId                := vbUserId
                                                 );

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
    IF inIsPay = TRUE THEN
       -- находим кассу для Магазина, в которую попадет оплата
        vbCashId := (SELECT Object_Cash.Id AS CashId
                     FROM Object AS Object_Unit
                          -- если сразу получили по Магазину
                          LEFT JOIN ObjectLink AS ObjectLink_Cash_Unit
                                               ON ObjectLink_Cash_Unit.ChildObjectId = Object_Unit.Id
                                              AND ObjectLink_Cash_Unit.DescId        = zc_ObjectLink_Cash_Unit()
                          -- иначе попробуем найти через группу Подразделений
                          LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                               ON ObjectLink_Unit_Parent.ObjectId    = Object_Unit.Id
                                              AND ObjectLink_Unit_Parent.DescId      = zc_ObjectLink_Unit_Parent()
                                              AND ObjectLink_Cash_Unit.ChildObjectId IS NULL
                          LEFT JOIN ObjectLink AS ObjectLink_Cash_Unit_Parent
                                               ON ObjectLink_Cash_Unit_Parent.ChildObjectId = ObjectLink_Unit_Parent.ChildObjectId
                                              AND ObjectLink_Cash_Unit_Parent.DescId        = zc_ObjectLink_Cash_Unit()
                          -- нашли все кассы
                          LEFT JOIN Object AS Object_Cash
                                           ON Object_Cash.Id       = COALESCE (ObjectLink_Cash_Unit.ObjectId, ObjectLink_Cash_Unit_Parent.ObjectId)
                                          AND Object_Cash.DescId   = zc_Object_Cash()
                                          AND Object_Cash.isErased = FALSE
                          -- Валюта
                          INNER JOIN ObjectLink AS ObjectLink_Cash_Currency
                                                ON ObjectLink_Cash_Currency.ObjectId      = Object_Cash.Id
                                               AND ObjectLink_Cash_Currency.DescId        = zc_ObjectLink_Cash_Currency()
                                               AND ObjectLink_Cash_Currency.ChildObjectId = zc_Currency_GRN()

                     WHERE Object_Unit.Id = vbUnitId
                    );

        -- проверка - свойство должно быть установлено
        IF COALESCE (vbCashId, 0) = 0 THEN
          -- Для Sybase - ВРЕМЕННО
          IF vbUserId = zc_User_Sybase()
          THEN vbCashId:= 4219;
          ELSE RAISE EXCEPTION 'Ошибка.Для магазина <%> Не установлено значение <Касса> в грн. (%)', lfGet_Object_ValueData (vbUnitId), vbUnitId;
          END IF;
        END IF;

       -- сохранили
       PERFORM lpInsertUpdate_MI_ReturnIn_Child (ioId                 := tmp.Id
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
            ) AS tmp;

       -- в мастер записать - Итого оплата при возврате ГРН
       PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPay(), ioId, outTotalPay);

       -- пересчитали Итоговые суммы по накладной
       PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

    END IF;


    -- "сложно" пересчитали "итоговые" суммы по элементу
    PERFORM lpUpdate_MI_ReturnIn_Total (ioId);


    -- вернули Сумма возврата оплаты в расчетах ГРН, для грида
    outTotalPayOth:= COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalPayOth()), 0);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.06.17         *
 15.05.17         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_ReturnIn(ioId := 0 , inMovementId := 8 , inGoodsId := 446 , inPartionId := 50 , inAmount := 4 , outOperPrice := 100 , ioCountForPrice := 1 ,  inSession := '2');
