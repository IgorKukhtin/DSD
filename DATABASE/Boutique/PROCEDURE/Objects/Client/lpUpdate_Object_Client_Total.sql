-- Function: lpUpdate_Object_Client_Total (Integer, Integer)

DROP FUNCTION IF EXISTS lpUpdate_Object_Client_Total (Integer, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Object_Client_Total(
    IN inMovementId          Integer   ,   -- Ключ объекта <Документ>
    IN inIsComplete          Boolean   ,   -- Проведение Да/Нет (если Да добавляем сумму продажи... иначе снимаем) 
    IN inUserId              Integer       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbMovementDescId            Integer;
   DECLARE vbClientId                  Integer;
   DECLARE vbUserId                    Integer;
   DECLARE vbOperDate                  TDateTime;
   DECLARE vbLastDate_Client           TDateTime;
   DECLARE vbTotalSummPay_Client       TFloat;
   DECLARE vbTotalCount_Client         TFloat;
   DECLARE vbTotalSumm_Client          TFloat;
   DECLARE vbTotalSummDiscount_Client  TFloat;
   DECLARE vbTotalCount                TFloat;
   DECLARE vbTotalSummPriceList        TFloat;
   DECLARE vbTotalSummChange           TFloat;
   DECLARE vbTotalSummPay              TFloat;
   DECLARE vbKoef                      TFloat;
BEGIN

   -- данные из шапки вид Документа, Клиент, коэф. (если продажа = 1 , если возврат = -1 )
   SELECT Movement.DescId                                                                                              AS MovementDescId
        , CASE WHEN Object_From.DescId = zc_Object_Client() THEN MovementLinkObject_From.ObjectId
               WHEN Object_To.DescId   = zc_Object_Client() THEN MovementLinkObject_To.ObjectId
          END                                                                                                          AS ClientId
        , CASE WHEN Movement.DescId = zc_Movement_GoodsAccount() AND Object_From.DescId = zc_Object_Client() THEN 1
               WHEN Movement.DescId = zc_Movement_GoodsAccount() AND Object_To.DescId   = zc_Object_Client() THEN (-1)
               WHEN Movement.DescId = zc_Movement_Sale()     THEN 1
               WHEN Movement.DescId = zc_Movement_ReturnIn() THEN (-1)
          END   
          * CASE WHEN inIsComplete = TRUE THEN 1 ELSE (-1) END                                                         AS Koef
          INTO vbMovementDescId, vbClientId, vbKoef
   FROM Movement 
        LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                     ON MovementLinkObject_From.MovementId = Movement.Id
                                    AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
        LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
        
        LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                     ON MovementLinkObject_To.MovementId = Movement.Id
                                    AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
        LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
   WHERE Movement.Id = inMovementId;
   
   -- получаем данные по клиенту
   SELECT COALESCE (ObjectFloat_TotalCount.ValueData, 0)           AS TotalCount         -- Итого количество
        , COALESCE (ObjectFloat_TotalSumm.ValueData, 0)            AS TotalSumm          -- Итого Сумма
        , COALESCE (ObjectFloat_TotalSummDiscount.ValueData, 0)    AS TotalSummDiscount  -- Итого Сумма скидки
        , COALESCE (ObjectFloat_TotalSummPay.ValueData, 0)         AS TotalSummPay       -- Итого Сумма оплаты
        , COALESCE (ObjectDate_LastDate.ValueData, zc_DateStart()) AS LastDate           -- последняя дата покупки
          INTO vbTotalCount_Client, vbTotalSumm_Client, vbTotalSummDiscount_Client, vbTotalSummPay_Client, vbLastDate_Client
   FROM Object AS Object_Client
        LEFT JOIN ObjectFloat AS ObjectFloat_TotalCount 
                              ON ObjectFloat_TotalCount.ObjectId = Object_Client.Id 
                             AND ObjectFloat_TotalCount.DescId = zc_ObjectFloat_Client_TotalCount()

        LEFT JOIN ObjectFloat AS ObjectFloat_TotalSumm 
                              ON ObjectFloat_TotalSumm.ObjectId = Object_Client.Id 
                             AND ObjectFloat_TotalSumm.DescId   = zc_ObjectFloat_Client_TotalSumm()

        LEFT JOIN ObjectFloat AS ObjectFloat_TotalSummDiscount 
                              ON ObjectFloat_TotalSummDiscount.ObjectId = Object_Client.Id 
                             AND ObjectFloat_TotalSummDiscount.DescId   = zc_ObjectFloat_Client_TotalSummDiscount()

        LEFT JOIN ObjectFloat AS ObjectFloat_TotalSummPay 
                              ON ObjectFloat_TotalSummPay.ObjectId = Object_Client.Id 
                             AND ObjectFloat_TotalSummPay.DescId   = zc_ObjectFloat_Client_TotalSummPay()

        LEFT JOIN ObjectDate AS ObjectDate_LastDate 
                             ON ObjectDate_LastDate.ObjectId = Object_Client.Id 
                            AND ObjectDate_LastDate.DescId   = zc_ObjectDate_Client_LastDate()
   WHERE Object_Client.Id = vbClientId;

   -- получаем данные док.продажи : кол-во, Сумма, Сумма скидки, Сумма оплаты, дата, пользователь
   SELECT COALESCE (MD_Insert.ValueData, Movement.OperDate)                 AS OperDate            -- дата/время создания, а уже потом - дата документа
        , COALESCE (CASE WHEN Movement.DescId = zc_Movement_GoodsAccount() THEN 0 ELSE MovementFloat_TotalCount.ValueData END, 0)         * vbKoef AS TotalCount          -- кол-во
        , COALESCE (CASE WHEN Movement.DescId = zc_Movement_GoodsAccount() THEN 0 ELSE MovementFloat_TotalSummPriceList.ValueData END, 0) * vbKoef AS TotalSummPriceList  -- Сумма
        , COALESCE (MovementFloat_TotalSummChange.ValueData, 0)    * vbKoef AS TotalSummChange     -- Сумма скидки
        , COALESCE (MovementFloat_TotalSummPay.ValueData, 0)       * vbKoef AS TotalSummPay        -- Сумма оплаты
        , MLO_Insert.ObjectId                                               AS UserId              -- Пользователь
          INTO vbOperDate, vbTotalCount, vbTotalSummPriceList, vbTotalSummChange, vbTotalSummPay, vbUserId
   FROM Movement
        LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                ON MovementFloat_TotalCount.MovementId = Movement.Id
                               AND MovementFloat_TotalCount.DescId     = zc_MovementFloat_TotalCount()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSummPriceList
                                ON MovementFloat_TotalSummPriceList.MovementId = Movement.Id
                               AND MovementFloat_TotalSummPriceList.DescId     = zc_MovementFloat_TotalSummPriceList()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSummChange
                                ON MovementFloat_TotalSummChange.MovementId = Movement.Id
                               AND MovementFloat_TotalSummChange.DescId     = zc_MovementFloat_TotalSummChange()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSummPay
                                ON MovementFloat_TotalSummPay.MovementId = Movement.Id
                               AND MovementFloat_TotalSummPay.DescId     = zc_MovementFloat_TotalSummPay()

        LEFT JOIN MovementLinkObject AS MLO_Insert
                                     ON MLO_Insert.MovementId = Movement.Id
                                    AND MLO_Insert.DescId     = zc_MovementLinkObject_Insert()
        LEFT JOIN MovementDate AS MD_Insert
                               ON MD_Insert.MovementId = Movement.Id
                              AND MD_Insert.DescId     = zc_MovementDate_Insert()

        LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId
   WHERE Movement.Id = inMovementId;
     
   -- сохранили ИТОГОВЫЕ СУММЫ
   -- сохранили <Итого количество>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_TotalCount(), vbClientId, vbTotalCount_Client + vbTotalCount);
   -- сохранили <Итого Сумма>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_TotalSumm(), vbClientId, vbTotalSumm_Client + vbTotalSummPriceList);
   -- сохранили <Итого Сумма скидки>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_TotalSummDiscount(), vbClientId, vbTotalSummDiscount_Client + vbTotalSummChange);
   -- сохранили <Итого Сумма оплаты>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_TotalSummPay(), vbClientId, vbTotalSummPay_Client + vbTotalSummPay);
        
        
   -- Если это продажа и дата документа больше сохраненной в клиенте обновляем данные последней покупки
   IF vbMovementDescId = zc_Movement_Sale() AND inIsComplete = TRUE AND vbOperDate > vbLastDate_Client
   THEN
       -- сохранили <Количество в последней покупке>
       PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_LastCount(), vbClientId, vbTotalCount);
       -- сохранили <Сумма последней покупки>
       PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_LastSumm(), vbClientId, vbTotalSummPriceList);
       -- сохранили <Сумма скидки в последней покупке>
       PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_LastSummDiscount(), vbClientId, vbTotalSummChange);
       -- сохранили <Последняя дата покупки>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Client_LastDate(), vbClientId, vbOperDate);
       -- сохранили связь с <Пользователь кто формировал последнюю покупку>
       PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Client_LastUser(), vbClientId, vbUserId);      
   END IF;
   
   -- Если это док.продажа распроводится/удаляет и дата документа больше сохраненной в клиенте обновляем данные последней покупки
   IF vbMovementDescId = zc_Movement_Sale() AND inIsComplete = FALSE AND vbOperDate > vbLastDate_Client
   THEN
       -- находим данные по последнему док.продажи
       SELECT Movement.OperDate                                        AS OperDate            -- дата/время создания, а уже потом - дата документа
            , COALESCE (MovementFloat_TotalCount.ValueData, 0)         AS TotalCount          -- кол-во
            , COALESCE (MovementFloat_TotalSummPriceList.ValueData, 0) AS TotalSummPriceList  -- Сумма
            , COALESCE (MovementFloat_TotalSummChange.ValueData, 0)    AS TotalSummChange     -- Сумма скидки
            , COALESCE (MovementFloat_TotalSummPay.ValueData, 0)       AS TotalSummPay        -- Сумма оплаты
            , MLO_Insert.ObjectId                                      AS UserId              -- Пользователь
              INTO vbOperDate, vbTotalCount, vbTotalSummPriceList, vbTotalSummChange, vbTotalSummPay, vbUserId
       FROM (SELECT Movement.Id
                  , COALESCE (MD_Insert.ValueData, Movement.OperDate) AS OperDate
             FROM Movement
                  INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                ON MovementLinkObject_To.MovementId = Movement.Id
                                               AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                               AND MovementLinkObject_To.ObjectId = vbClientId
                  LEFT JOIN MovementDate AS MD_Insert
                                         ON MD_Insert.MovementId = Movement.Id
                                        AND MD_Insert.DescId     = zc_MovementDate_Insert()
             WHERE Movement.StatusId = zc_Enum_Status_Complete() 
               AND Movement.DescId = zc_Movement_Sale()
             ORDER BY MD_Insert.ValueData DESC -- для скорости - без Movement.OperDate
             LIMIT 1
            ) AS Movement
            
            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId = Movement.Id
                                   AND MovementFloat_TotalCount.DescId     = zc_MovementFloat_TotalCount()
                                   
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPriceList
                                    ON MovementFloat_TotalSummPriceList.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummPriceList.DescId     = zc_MovementFloat_TotalSummPriceList()
                                   
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummChange
                                    ON MovementFloat_TotalSummChange.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummChange.DescId     = zc_MovementFloat_TotalSummChange()
                                   
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPay
                                    ON MovementFloat_TotalSummPay.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummPay.DescId     = zc_MovementFloat_TotalSummPay()
    
            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId     = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId
       ;
       
       -- сохранили <Количество в последней покупке>
       PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_LastCount(), vbClientId, vbTotalCount);
       -- сохранили <Сумма последней покупки>
       PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_LastSumm(), vbClientId, vbTotalSummPriceList);
       -- сохранили <Сумма скидки в последней покупке>
       PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_LastSummDiscount(), vbClientId, vbTotalSummChange);
       -- сохранили <Последняя дата покупки>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Client_LastDate(), vbClientId, vbOperDate);
       -- сохранили связь с <Пользователь кто формировал последнюю покупку>
       PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Client_LastUser(), vbClientId, vbUserId); 
            
   END IF;
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (vbClientId, inUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятикин А.А.
23.07.17          *
*/

-- тест
-- 
--select lpUpdate_Object_Client_Total (29, FALSE, 2);
--select lpUpdate_Object_Client_Total (29, TRUE, 2);
