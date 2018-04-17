-- Function: gpInsertUpdate_MovementItem_GoodsAccount()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_GoodsAccount (Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_GoodsAccount (Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_GoodsAccount (Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_GoodsAccount (Integer, Integer, Integer, Integer, Boolean, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_GoodsAccount(
 INOUT ioId                     Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId             Integer   , -- Ключ объекта <Документ>
    IN inPartionId              Integer   , -- Партия
    IN inSaleMI_Id              Integer   , -- Партия элемента продажа/возврат
   OUT outLineNum               Integer   , -- № п.п.
   OUT outIsLine                TVarChar  , -- № п.п.
    IN inIsPay                  Boolean   , -- добавить с оплатой
    IN inAmount                 TFloat    , -- Количество
   OUT outSummChangePercent     TFloat    , -- сумма доп. Скидки - "Расчеты покупателей"
   OUT outTotalPay              TFloat    , -- сумма оплаты - "Расчеты покупателей"
   OUT outSummDebt              TFloat    , -- долг
    IN inComment                TVarChar  , -- примечание
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId          Integer;

   DECLARE vbMovementId_sale Integer; -- <Документ Продажи>
   DECLARE vbPartionMI_Id    Integer;
   DECLARE vbUnitId          Integer;
   DECLARE vbUnitId_user     Integer;
   DECLARE vbCashId          Integer;
   DECLARE vbGoodsId         Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_GoodsAccount());
     vbUserId:= lpGetUserBySession (inSession);


     -- Получили для Пользователя - к какому Подразделению он привязан
     vbUnitId_user:= lpGetUnit_byUser (vbUserId);

     -- определяем Партию элемента продажи/возврата
     vbPartionMI_Id := lpInsertFind_Object_PartionMI (inSaleMI_Id);
     -- определяем для Скорости
     vbMovementId_sale:=  (SELECT MovementItem.MovementId FROM MovementItem WHERE MovementItem.Id = inSaleMI_Id);

     -- параметры из Документа
     vbUnitId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To());


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
     IF COALESCE (inSaleMI_Id, 0) = 0 AND  vbUserId <> zc_User_Sybase() THEN
        RAISE EXCEPTION 'Ошибка.Не определен элемент Продажи.';
     END IF;
     -- проверка - свойство должно быть установлено
     IF inAmount < 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Кол-во>.';
     END IF;
     -- проверка - Уникальный vbPartionMI_Id
     IF EXISTS (SELECT 1 FROM MovementItem AS MI INNER JOIN MovementItemLinkObject AS MILO ON MILO.MovementItemId = MI.Id AND MILO.DescId = zc_MILinkObject_PartionMI() AND MILO.ObjectId = vbPartionMI_Id WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.Id <> COALESCE (ioId, 0)) THEN
        RAISE EXCEPTION 'Ошибка.В документе уже есть Товар <% %> р.<%>.Дублирование запрещено.'
                      , lfGet_Object_ValueData_sh ((SELECT Object_PartionGoods.LabelId     FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inPartionId))
                      , lfGet_Object_ValueData    ((SELECT Object_PartionGoods.GoodsId     FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inPartionId))
                      , lfGet_Object_ValueData_sh ((SELECT Object_PartionGoods.GoodsSizeId FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inPartionId))
                       ;
     END IF;


     -- Скидка
     IF vbUserId = zc_User_Sybase()
     THEN
         -- !!!для SYBASE - потом убрать!!!
         IF 1=0 THEN RAISE EXCEPTION 'Ошибка.Параметр только для загрузки из Sybase.'; END IF;
     ELSE
         -- Дополнительная скидка в расчетах ГРН
         IF (inIsPay = TRUE AND inAmount <> COALESCE ((SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = ioId), 0))
            OR inAmount = 0
         THEN
             -- !!!обнулили!!!
             outSummChangePercent:= 0;
         ELSE
             -- взяли ту что есть
             outSummChangePercent:= COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummChangePercent()), 0);
         END IF;

     END IF;


     -- данные из партии : GoodsId
     vbGoodsId:= (SELECT Object_PartionGoods.GoodsId FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inPartionId);


     -- сохранили
     ioId:= lpInsertUpdate_MovementItem_GoodsAccount (ioId                 := ioId
                                                    , inMovementId         := inMovementId
                                                    , inGoodsId            := vbGoodsId
                                                    , inPartionId          := COALESCE (inPartionId, 0)
                                                    , inPartionMI_Id       := COALESCE (vbPartionMI_Id, 0)
                                                    , inAmount             := inAmount
                                                    , inComment            := COALESCE (inComment,'') :: TVarChar
                                                    , inUserId             := vbUserId
                                                     );

     -- Добавляем оплату в грн
     IF inIsPay = TRUE AND vbUserId <> zc_User_Sybase()
     THEN
         -- вернули Итого оплата в расчетах ГРН = "Остаток долга", для грида
         outTotalPay := CASE WHEN inAmount = 0
                        THEN 0
                        ELSE COALESCE ((SELECT zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData)
                                             - COALESCE (MIFloat_TotalChangePercent.ValueData, 0)
                                             - COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0)
                                             - COALESCE (MIFloat_TotalPay.ValueData, 0)
                                             - COALESCE (MIFloat_TotalPayOth.ValueData, 0)
                                               -- так минуснули Возврат
                                             - COALESCE (MIFloat_TotalReturn.ValueData, 0)
                                               -- !!!ПЛЮС!!!
                                             + COALESCE (MIFloat_TotalPayReturn.ValueData, 0)
                                               -- минус скидка СЕЙЧАС
                                             - outSummChangePercent
                                        FROM MovementItem
                                             LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                                         ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                                        AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()

                                             LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                                                         ON MIFloat_TotalChangePercent.MovementItemId = MovementItem.Id
                                                                        AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()
                                             LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercentPay
                                                                         ON MIFloat_TotalChangePercentPay.MovementItemId = MovementItem.Id
                                                                        AND MIFloat_TotalChangePercentPay.DescId         = zc_MIFloat_TotalChangePercentPay()

                                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                                         ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                                        AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth
                                                                         ON MIFloat_TotalPayOth.MovementItemId = MovementItem.Id
                                                                        AND MIFloat_TotalPayOth.DescId         = zc_MIFloat_TotalPayOth()

                                             LEFT JOIN MovementItemFloat AS MIFloat_TotalReturn
                                                                         ON MIFloat_TotalReturn.MovementItemId = MovementItem.Id
                                                                        AND MIFloat_TotalReturn.DescId         = zc_MIFloat_TotalReturn()
                                             LEFT JOIN MovementItemFloat AS MIFloat_TotalPayReturn
                                                                         ON MIFloat_TotalPayReturn.MovementItemId = MovementItem.Id
                                                                        AND MIFloat_TotalPayReturn.DescId         = zc_MIFloat_TotalPayReturn()
                                        WHERE MovementItem.MovementId = vbMovementId_sale
                                          AND MovementItem.DescId     = zc_MI_Master()
                                          AND MovementItem.Id         = inSaleMI_Id
                                          AND MovementItem.isErased   = FALSE
                                       ), 0)
                        END;

         -- находим кассу для Магазина, в которую попадет оплата
         vbCashId := (SELECT lpSelect.CashId
                      FROM lpSelect_Object_Cash (vbUnitId, vbUserId) AS lpSelect
                      WHERE lpSelect.isBankAccount = FALSE
                        AND lpSelect.CurrencyId    = zc_Currency_GRN()
                     );
         -- проверка - свойство должно быть установлено
         IF COALESCE (vbCashId, 0) = 0 THEN
           RAISE EXCEPTION 'Ошибка.Для магазина <%> Не установлено значение <Касса> в грн. (%)', lfGet_Object_ValueData (vbUnitId), vbUnitId;
         END IF;

         -- сохранили
         PERFORM lpInsertUpdate_MI_GoodsAccount_Child (ioId                 := tmp.Id
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

         -- в мастер записать - Дополнительная скидка в расчетах ГРН - т.к. могли обнулить
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent(), ioId, COALESCE (outSummChangePercent, 0));

         -- в мастер записать - Итого оплата в расчетах ГРН
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPay(), ioId, outTotalPay);

         -- пересчитали Итоговые суммы по накладной
         PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     ELSE
        -- вернули Итого оплата в расчетах ГРН, для грида
         outTotalPay := COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalPay()), 0);
     END IF;


     -- вернули Сумма долга ГРН, для грида
     outSummDebt:= COALESCE ((SELECT zfCalc_SummPriceList (MovementItem.Amount, MIFloat_OperPriceList.ValueData)
                                   - COALESCE (MIFloat_TotalChangePercent.ValueData, 0)
                                   - COALESCE (MIFloat_TotalChangePercentPay.ValueData, 0)
                                   - COALESCE (MIFloat_TotalPay.ValueData, 0)
                                   - COALESCE (MIFloat_TotalPayOth.ValueData, 0)
                                     -- так минуснули Возврат
                                   - COALESCE (MIFloat_TotalReturn.ValueData, 0)
                                     -- !!!ПЛЮС!!!
                                   + COALESCE (MIFloat_TotalPayReturn.ValueData, 0)
                                     -- уменьшаем Долг на сумму из тек. документа
                                   - outSummChangePercent
                                   - outTotalPay
                              FROM MovementItem
                                   LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                               ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                              AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()

                                   LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercent
                                                               ON MIFloat_TotalChangePercent.MovementItemId = MovementItem.Id
                                                              AND MIFloat_TotalChangePercent.DescId         = zc_MIFloat_TotalChangePercent()
                                   LEFT JOIN MovementItemFloat AS MIFloat_TotalChangePercentPay
                                                               ON MIFloat_TotalChangePercentPay.MovementItemId = MovementItem.Id
                                                              AND MIFloat_TotalChangePercentPay.DescId         = zc_MIFloat_TotalChangePercentPay()

                                   LEFT JOIN MovementItemFloat AS MIFloat_TotalPay
                                                               ON MIFloat_TotalPay.MovementItemId = MovementItem.Id
                                                              AND MIFloat_TotalPay.DescId         = zc_MIFloat_TotalPay()
                                   LEFT JOIN MovementItemFloat AS MIFloat_TotalPayOth
                                                               ON MIFloat_TotalPayOth.MovementItemId = MovementItem.Id
                                                              AND MIFloat_TotalPayOth.DescId         = zc_MIFloat_TotalPayOth()

                                   LEFT JOIN MovementItemFloat AS MIFloat_TotalReturn
                                                               ON MIFloat_TotalReturn.MovementItemId = MovementItem.Id
                                                              AND MIFloat_TotalReturn.DescId         = zc_MIFloat_TotalReturn()
                                   LEFT JOIN MovementItemFloat AS MIFloat_TotalPayReturn
                                                               ON MIFloat_TotalPayReturn.MovementItemId = MovementItem.Id
                                                              AND MIFloat_TotalPayReturn.DescId         = zc_MIFloat_TotalPayReturn()
                              WHERE MovementItem.DescId     = zc_MI_Master()
                                AND MovementItem.MovementId = vbMovementId_sale
                                AND MovementItem.Id         = inSaleMI_Id
                                AND MovementItem.isErased   = FALSE
                             ), 0);



    -- № п.п. строки
    SELECT CASE WHEN tmp.isErased = FALSE AND tmp.Amount > 0 THEN tmp.LineNum ELSE NULL END :: Integer  AS LineNum
         , CASE WHEN tmp.isErased = FALSE AND tmp.Amount > 0 THEN '*'         ELSE '_'  END :: TVarChar AS isLine
           INTO outLineNum, outIsLine
    FROM (SELECT MI_Master.Id
               , ROW_NUMBER() OVER (ORDER BY CASE WHEN MI_Master.isErased = FALSE AND MI_Master.Amount > 0 THEN 0 ELSE 1 END ASC, MI_Master.Id ASC) AS LineNum
               , MI_Master.Amount
               , MI_Master.isErased
          FROM MovementItem AS MI_Master
          WHERE MI_Master.MovementId = inMovementId
            AND MI_Master.DescId     = zc_MI_Master()
         ) AS tmp
    WHERE tmp.Id = ioId;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.03.18         *
 18.05.17         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_GoodsAccount (ioId := 0 , inMovementId := 8 , inGoodsId := 446 , inPartionId := 50 , inAmount := 4 , outOperPrice := 100 , ioCountForPrice := 1 ,  inSession := '2');
