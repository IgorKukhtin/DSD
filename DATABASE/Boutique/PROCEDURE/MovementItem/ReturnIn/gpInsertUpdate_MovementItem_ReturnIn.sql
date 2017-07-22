-- Function: gpInsertUpdate_MovementItem_ReturnIn()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ReturnIn (Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ReturnIn(
 INOUT ioId                     Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId             Integer   , -- Ключ объекта <Документ>
 INOUT ioGoodsId                Integer   , -- Товары
    IN inPartionId              Integer   , -- Партия
    IN inMovementMI_Id          Integer   , -- строка док. продажи
    IN inisPay                  Boolean   , -- добавить с оплатой
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
   DECLARE vbPartionId Integer;
   DECLARE vbPartionMI_Id Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbCurrencyId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbClientId Integer;
   DECLARE vbTotalPay_Sale TFloat;
   DECLARE vbTotalSummPriceList_Sale TFloat;
   DECLARE vbTotalChangePercent_Sale TFloat;
   DECLARE vbCashId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ReturnIn());

     -- проверка - документ должен быть сохранен
     IF COALESCE (inMovementId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Документ не сохранен.';
     END IF;
     -- проверка - свойство должно быть установлено
     IF COALESCE (inPartionId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Партия>.';
     END IF;
     -- проверка - свойство должно быть установлено
     IF COALESCE (inMovementMI_Id, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не определен документ Продажи.';
     END IF;
     
     -- данные из шапки
     SELECT Movement.OperDate
          , MovementLinkObject_From.ObjectId
          , MovementLinkObject_To.ObjectId
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
     vbPartionMI_Id := lpInsertFind_Object_PartionMI (inMovementMI_Id);
     
     -- Цена (прайс)
     IF vbUserId = zc_User_Sybase()
     THEN
         -- !!!для SYBASE - потом убрать!!!
         IF 1=0 THEN RAISE EXCEPTION 'Ошибка.Параметр только для загрузки из Sybase.'; END IF;
     ELSE
         -- из Истории
         --ioOperPriceList := COALESCE ((SELECT tmp.ValuePrice FROM lpGet_ObjectHistory_PriceListItem (vbOperDate, zc_PriceList_Basis(), inGoodsId) AS tmp), 0);
         ioOperPriceList := (SELECT COALESCE (MIFloat_OperPriceList.ValueData, 0)  AS OperPriceList
                             FROM MovementItemFloat AS MIFloat_OperPriceList
                             WHERE MIFloat_OperPriceList.MovementItemId = inMovementMI_Id
                               AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
                             );
     END IF;
     
     -- проверка - свойство должно быть установлено
     IF COALESCE (ioOperPriceList, 0) <= 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Цена (прайс)>.';
     END IF;
     
     -- данные из партии : OperPrice и CountForPrice
     SELECT Object_PartionGoods.GoodsId
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

     -- расчитали сумму по элементу, для грида
     outTotalSumm := zfCalc_SummIn (inAmount, outOperPrice, outCountForPrice);

     -- расчитали сумму вх. в грн по элементу, для грида
     outTotalSummBalance := zfCalc_CurrencyFrom (outTotalSumm, outCurrencyValue, outParValue);

     -- расчитали сумму по прайсу по элементу, для грида
     outTotalSummPriceList := zfCalc_SummPriceList (inAmount, ioOperPriceList);

     -- получаем сумму скидки и сумму продажи из партии док. продажи
     SELECT zfCalc_SummPriceList (MovementItem.Amount, ioOperPriceList)
          , COALESCE (MIFloat_TotalChangePercent.ValueData, 0)  AS TotalChangePercent
       INTO vbTotalSummPriceList_Sale, vbTotalChangePercent_Sale
     FROM MovementItem
         LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                     ON MIFloat_TotalChangePercent.MovementItemId = MovementItem.Id
                                    AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()
     WHERE MovementItem.Id = inMovementMI_Id
       AND MovementItem.isErased = False;
       
     -- получим оплату из партии док. продажи
     vbTotalPay_Sale := (SELECT COALESCE (MIFloat_TotalPay.ValueData, 0) 
                         FROM MovementItemFloat AS MIFloat_TotalPay
                         WHERE MIFloat_TotalPay.MovementItemId = inMovementMI_Id
                           AND MIFloat_TotalPay.DescId = zc_MIFloat_TotalPay());
                                
     -- пропорция для Итого сумма скидки из партии продажи                       
     outTotalChangePercent := CASE WHEN vbTotalSummPriceList_Sale <>0 THEN outTotalSummPriceList * COALESCE(vbTotalChangePercent_Sale,0) / vbTotalSummPriceList_Sale ELSE 0 END;
     outTotalChangePercent := CASE WHEN outTotalChangePercent > vbTotalChangePercent_Sale THEN vbTotalChangePercent_Sale ELSE outTotalChangePercent END;
     
     -- расчитали Cумма оплаты возврата в грн
     IF inIsPay = TRUE
     THEN
         outTotalPay := COALESCE (outTotalSummPriceList, 0) - COALESCE (outTotalChangePercent, 0) ;
         outTotalPay := CASE WHEN outTotalPay > vbTotalPay_Sale THEN vbTotalPay_Sale ELSE outTotalPay END;
     ELSE
         outTotalPay := COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalPay()), 0);
     END IF;
     
     outTotalSummToPay := COALESCE(outTotalSummPriceList,0) - COALESCE(outTotalChangePercent,0);
     outTotalSummToPay := CASE WHEN outTotalSummToPay > vbTotalPay_Sale THEN vbTotalPay_Sale ELSE outTotalSummToPay END;
               
     -- сохранили
     ioId:= lpInsertUpdate_MovementItem_ReturnIn(ioId                    := ioId
                                               , inMovementId            := inMovementId
                                               , inGoodsId               := ioGoodsId
                                               , inPartionId             := COALESCE(inPartionId,0)
                                               , inPartionMI_Id          := COALESCE(vbPartionMI_Id,0)
                                               , inAmount                := inAmount
                                               , inOperPrice             := outOperPrice
                                               , inCountForPrice         := outCountForPrice
                                               , inOperPriceList         := ioOperPriceList
                                               , inCurrencyValue         := outCurrencyValue 
                                               , inParValue              := outParValue 
                                               , inTotalChangePercent    := COALESCE(outTotalChangePercent,0)    ::TFloat     
                                               --, inTotalPay              := COALESCE(outTotalPay,0)              ::TFloat              
                                               --, inTotalPayOth           := COALESCE(outTotalPayOth,0)           ::TFloat    
                                               , inComment               := COALESCE(inComment,'')               ::TVarChar       
                                               , inUserId                := vbUserId
                                               );
     
    IF inisPay = TRUE THEN
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
                    
        -- проверка - свойство должно быть установлено
        IF COALESCE (vbCashId, 0) = 0 THEN
           vbCashId:= 4219 ;
           -- RAISE EXCEPTION 'Ошибка.Для магазина <%> Не установлено значение <Касса> в грн. (%)', lfGet_Object_ValueData (vbUnitId), vbUnitId;
        END IF;
              
       -- сохранили
       PERFORM lpInsertUpdate_MI_ReturnIn_Child (ioId                 := COALESCE (tmp.Id,0)
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
            
       -- в мастер записать итого сумма оплаты грн
       PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPay(), ioId, outTotalPay);       
    END IF;

    
    -- пересчитали
    -- Итого сумма оплаты (в ГРН) - док расчет
    PERFORM lpUpdate_MI_ReturnIn_Total(ioId);
    
    -- Итого оплата в расчетах ГРН
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
-- select * from gpInsertUpdate_MovementItem_ReturnIn(ioId := 0 , inMovementId := 8 , inGoodsId := 446 , inPartionId := 50 , inAmount := 4 , outOperPrice := 100 , ioCountForPrice := 1 ,  inSession := '2');