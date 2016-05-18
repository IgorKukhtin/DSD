-- Function: lpUpdate_Movement_ReturnIn_Auto_OLD()

DROP FUNCTION IF EXISTS lpUpdate_Movement_ReturnIn_Auto_OLD (Integer, Integer);
DROP FUNCTION IF EXISTS lpUpdate_Movement_ReturnIn_Auto_OLD (TDateTime, TDateTime, Integer, Integer);
DROP FUNCTION IF EXISTS lpUpdate_Movement_ReturnIn_Auto_OLD (Integer, TDateTime, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Movement_ReturnIn_Auto_OLD(
    IN inMovementId          Integer   , -- ключ Документа
    IN inStartDateSale       TDateTime , --
    IN inEndDateSale         TDateTime , --
   OUT outMessageText        Text      ,
    IN inUserId              Integer     -- Пользователь
)
RETURNS Text
AS
$BODY$
   DECLARE vbPeriod1 INTERVAL;
   DECLARE vbPeriod2 INTERVAL;
   DECLARE vbPeriod3 INTERVAL;

   DECLARE vbStartDate  TDateTime;
   DECLARE vbEndDate    TDateTime;
   DECLARE vbPartnerId  Integer;
   DECLARE vbPaidKindId Integer;
   DECLARE vbContractId Integer;
   DECLARE vbJuridicalId  Integer;

   DECLARE vbMovementItemId_return Integer;
   DECLARE vbMovementId_sale       Integer;
   DECLARE vbMovementItemId_sale   Integer;

   DECLARE vbGoodsId     Integer;
   DECLARE vbGoodsKindId Integer;
   DECLARE vbGoodsKindId_two Integer;
   DECLARE vbAmount      TFloat;
   DECLARE vbAmount_sale TFloat;
   DECLARE vbOperPrice   TFloat;

   DECLARE vbStep Integer;

   DECLARE curMI_ReturnIn refcursor;
   DECLARE curMI_Sale refcursor;
   DECLARE curMI_Sale_TWO refcursor;
   DECLARE curMI_Sale_3 refcursor;
   DECLARE curMI_Sale_4 refcursor;
BEGIN
     -- инициализация, от этих параметров может зависеть скорость
     vbPeriod1:= '1 MONTH'  :: INTERVAL;
     vbPeriod2:= '1 MONTH'  :: INTERVAL;
     vbPeriod3:= '1 MONTH' :: INTERVAL;
     --
     vbStep:= 1;




     -- таблица
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpResult_ReturnIn_Auto'))
     THEN
         DELETE FROM _tmpResult_ReturnIn_Auto;
     ELSE
         -- таблица - продаж
         CREATE TEMP TABLE _tmpResult_Sale_Auto (PartnerId Integer, OperDate TDateTime, MovementId Integer, MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, Amount TFloat, Price_original TFloat) ON COMMIT DROP;
         -- таблица - результат
         CREATE TEMP TABLE _tmpResult_ReturnIn_Auto (ParentId Integer, MovementId_sale Integer, MovementItemId_sale Integer, GoodsId Integer, GoodsKindId Integer, GoodsKindId_return Integer, Amount TFloat, Price_original TFloat) ON COMMIT DROP;
     END IF;


     -- таблица
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpItem'))
     THEN
         -- таблица - возвраты
         CREATE TEMP TABLE _tmpItem (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, OperCount_Partner TFloat, Price_original TFloat)  ON COMMIT DROP;
     ELSE 
         DELETE FROM _tmpItem;
     END IF;

     -- формируются текущие возвраты
     INSERT INTO _tmpItem (MovementItemId, GoodsId, GoodsKindId, OperCount_Partner, Price_original)
        SELECT MI.Id AS MovementItemId, MI.ObjectId AS GoodsId, COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId, COALESCE (MIF_AmountPartner.ValueData, 0) AS OperCount_Partner, COALESCE (MIF_Price.ValueData, 0) AS Price_original
        FROM MovementItem AS MI
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind ON MILinkObject_GoodsKind.MovementItemId = MI.Id AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
             LEFT JOIN MovementItemFloat AS MIF_AmountPartner ON MIF_AmountPartner.MovementItemId = MI.Id AND MIF_AmountPartner.DescId = zc_MIFloat_AmountPartner()
             LEFT JOIN MovementItemFloat AS MIF_Price ON MIF_Price.MovementItemId = MI.Id AND MIF_Price.DescId = zc_MIFloat_Price()
        WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE
          AND MIF_AmountPartner.ValueData <> 0
       ;



     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - ПОИСК ПАРТИЙ !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


         -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
         -- !!!будут медленно формироваться партии продажи!!!
         -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

         -- параметры из документа
         SELECT /*CASE WHEN inStartDateSale >= COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) - vbPeriod1 THEN inStartDateSale ELSE COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) - vbPeriod1 END AS StartDate
              , COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) - INTERVAL '1 DAY' AS EndDate
              , COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) - INTERVAL '1 DAY' AS inEndDateSale -- !!!замена!!!*/
                DATE_TRUNC ('MONTH', COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate)) AS StartDate
              , DATE_TRUNC ('MONTH', COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate)) + INTERVAL '1 MONTH' - INTERVAL '1 DAY' AS EndDate
              , DATE_TRUNC ('MONTH', COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate)) + INTERVAL '1 MONTH' - INTERVAL '1 DAY' AS inEndDateSale -- !!!замена!!!

              , MovementLinkObject_From.ObjectId     AS PartnerId
              , MovementLinkObject_PaidKind.ObjectId AS PaidKindId
              , MovementLinkObject_Contract.ObjectId AS ContractId

              , ObjectLink_Jur.ChildObjectId

                INTO vbStartDate, vbEndDate, inEndDateSale
                   , vbPartnerId, vbPaidKindId, vbContractId
                   , vbJuridicalId
         FROM Movement
              LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                     ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                    AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
              LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                           ON MovementLinkObject_From.MovementId = Movement.Id
                                          AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()

              LEFT JOIN ObjectLink AS ObjectLink_Jur
                                           ON ObjectLink_Jur.ObjectId = MovementLinkObject_From.ObjectId
                                          AND ObjectLink_Jur.DescId     = zc_ObjectLink_Partner_Juridical()

              LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                           ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                          AND MovementLinkObject_PaidKind.DescId     = zc_MovementLinkObject_PaidKind()
              LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                           ON MovementLinkObject_Contract.MovementId = Movement.Id
                                          AND MovementLinkObject_Contract.DescId     = zc_MovementLinkObject_Contract()
         WHERE Movement.Id = inMovementId;


         -- таблица
         IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpGoods_list'))
         THEN CREATE TEMP TABLE tmpGoods_list (GoodsId Integer) ON COMMIT DROP;
         END IF;
         -- таблица
         IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpPartner'))
         THEN CREATE TEMP TABLE tmpPartner (PartnerId Integer) ON COMMIT DROP;
         ELSE DELETE FROM tmpPartner;
         END IF;
         --
         INSERT INTO tmpPartner (PartnerId) SELECT ObjectLink_Jur.ObjectId AS PartnerId
                                            FROM ObjectLink AS ObjectLink_Jur
                                            WHERE ObjectLink_Jur.ChildObjectId = vbJuridicalId
                                            AND ObjectLink_Jur.DescId          = zc_ObjectLink_Partner_Juridical()
                                           ;
         -- Оптимизация
         ANALYZE tmpPartner;


         -- Цикл по периодам (так наверно быстрее)
         WHILE vbStartDate >= inStartDateSale AND vbStartDate <= vbEndDate LOOP

            -- очистили
            DELETE FROM _tmpResult_Sale_Auto;
            -- очистили
            DELETE FROM tmpGoods_list;
            --
            INSERT INTO tmpGoods_list (GoodsId)
               (SELECT DISTINCT tmp.GoodsId 
                FROM                  (SELECT tmp1.GoodsId, tmp1.GoodsKindId, tmp1.Price_original, tmp1.Amount - COALESCE (tmp2.Amount, 0) AS Amount
                                       FROM (SELECT tmp.GoodsId, tmp.GoodsKindId, tmp.Price_original, SUM (tmp.OperCount_Partner) AS Amount
                                             FROM _tmpItem AS tmp GROUP BY tmp.GoodsId, tmp.GoodsKindId, tmp.Price_original
                                            ) AS tmp1
                                            LEFT JOIN (SELECT tmp.GoodsId, tmp.GoodsKindId_return AS GoodsKindId, tmp.Price_original, SUM (tmp.Amount) AS Amount
                                                       FROM _tmpResult_ReturnIn_Auto AS tmp GROUP BY tmp.GoodsId, tmp.GoodsKindId_return, tmp.Price_original
                                                      ) AS tmp2 ON tmp2.GoodsId        = tmp1.GoodsId
                                                               AND tmp2.GoodsKindId    = tmp1.GoodsKindId
                                                               AND tmp2.Price_original = tmp1.Price_original
                                       WHERE tmp1.Amount - COALESCE (tmp2.Amount, 0) > 0
                                      ) AS tmp
               );
            -- Оптимизация
            ANALYZE tmpGoods_list;

            -- сохранили, потом среди этих продаж будем подбирать партии
            INSERT INTO _tmpResult_Sale_Auto (PartnerId, OperDate, MovementId, MovementItemId, GoodsId, GoodsKindId, Amount, Price_original)
               WITH -- 
                    /*tmpPartner AS (SELECT ObjectLink_Jur.ObjectId AS PartnerId
                                   FROM ObjectLink AS ObjectLink_Jur
                                   WHERE ObjectLink_Jur.ChildObjectId = vbJuridicalId
                                     AND ObjectLink_Jur.DescId     = zc_ObjectLink_Partner_Juridical()
                                  )
                    -- текущий возврат МИНУС сколько партий нашли (т.е. сколько осталось)
                  ,*/ tmpMI_ReturnIn AS (SELECT tmp1.GoodsId, tmp1.GoodsKindId, tmp1.Price_original, tmp1.Amount - COALESCE (tmp2.Amount, 0) AS Amount
                                       FROM (SELECT tmp.GoodsId, tmp.GoodsKindId, tmp.Price_original, SUM (tmp.OperCount_Partner) AS Amount
                                             FROM _tmpItem AS tmp GROUP BY tmp.GoodsId, tmp.GoodsKindId, tmp.Price_original
                                            ) AS tmp1
                                            LEFT JOIN (SELECT tmp.GoodsId, tmp.GoodsKindId_return AS GoodsKindId, tmp.Price_original, SUM (tmp.Amount) AS Amount
                                                       FROM _tmpResult_ReturnIn_Auto AS tmp GROUP BY tmp.GoodsId, tmp.GoodsKindId_return, tmp.Price_original
                                                      ) AS tmp2 ON tmp2.GoodsId        = tmp1.GoodsId
                                                               AND tmp2.GoodsKindId    = tmp1.GoodsKindId
                                                               AND tmp2.Price_original = tmp1.Price_original
                                       WHERE tmp1.Amount - COALESCE (tmp2.Amount, 0) > 0
                                      )
                  -- , tmpGoods_list AS (SELECT DISTINCT tmpMI_ReturnIn.GoodsId /*, tmpMI_ReturnIn.GoodsKindId*/ FROM tmpMI_ReturnIn)
                    -- продажа - почти вся
                  /*, tmpMI_sale_all AS (-- Оптимизация - 1.1
                                       SELECT MIContainer.ObjectExtId_analyzer               AS PartnerId
                                            , MD_OperDatePartner.ValueData                   AS OperDate
                                            , MIContainer.MovementId                         AS MovementId
                                            , MIContainer.MovementItemId                     AS MovementItemId
                                            , MIContainer.ObjectId_Analyzer                  AS GoodsId
                                            , COALESCE (MIContainer.ObjectIntId_Analyzer, 0) AS GoodsKindId
                                            , SUM (-1 * MIContainer.Amount)                  AS Amount
                                       FROM MovementDate AS MD_OperDatePartner
                                            INNER JOIN MovementItemContainer AS MIContainer
                                                                             ON MIContainer.MovementId           = MD_OperDatePartner.MovementId
                                                                            AND MIContainer.DescId               = zc_MIContainer_Count()
                                                                            AND MIContainer.AnalyzerId           = zc_Enum_AnalyzerId_SaleCount_10400() -- Кол-во, реализация, у покупателя
                                                                            AND MIContainer.MovementDescId       = zc_Movement_Sale()
                                                                            AND MIContainer.ObjectId_Analyzer    IN (SELECT DISTINCT tmpMI_ReturnIn.GoodsId FROM tmpMI_ReturnIn)
                                                                            -- AND MIContainer.ObjectExtId_analyzer = vbPartnerId
                                            INNER JOIN tmpPartner ON tmpPartner.PartnerId = MIContainer.ObjectExtId_analyzer
                                       WHERE MD_OperDatePartner.ValueData BETWEEN vbStartDate AND vbEndDate
                                         AND MD_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                       GROUP BY MIContainer.ObjectExtId_analyzer
                                              , MD_OperDatePartner.ValueData
                                              , MIContainer.MovementId
                                              , MIContainer.MovementItemId
                                              , MIContainer.ObjectId_Analyzer
                                              , MIContainer.ObjectIntId_Analyzer
*/
/*
                                       -- Оптимизация - 1.2
                                       SELECT MIContainer.ObjectExtId_analyzer               AS PartnerId
                                            , MD_OperDatePartner.ValueData                   AS OperDate
                                            , MIContainer.MovementId                         AS MovementId
                                            , MIContainer.MovementItemId                     AS MovementItemId
                                            , MIContainer.ObjectId_Analyzer                  AS GoodsId
                                            , COALESCE (MIContainer.ObjectIntId_Analyzer, 0) AS GoodsKindId
                                            , SUM (-1 * MIContainer.Amount)                  AS Amount
                                       FROM tmpGoods_list
                                            INNER JOIN MovementItemContainer AS MIContainer
                                                                             ON MIContainer.DescId               = zc_MIContainer_Count()
                                                                            AND MIContainer.AnalyzerId           = zc_Enum_AnalyzerId_SaleCount_10400() -- Кол-во, реализация, у покупателя
                                                                            AND MIContainer.MovementDescId       = zc_Movement_Sale()
                                                                            AND MIContainer.ObjectId_Analyzer    = tmpGoods_list.GoodsId
                                                                            -- AND COALESCE (MIContainer.ObjectIntId_Analyzer, 0) = tmpGoods_list.GoodsKindId
                                                                            -- AND MIContainer.ObjectExtId_analyzer = vbPartnerId
                                            INNER JOIN tmpPartner ON tmpPartner.PartnerId = MIContainer.ObjectExtId_analyzer

                                            INNER JOIN MovementDate AS MD_OperDatePartner
                                                                    ON MD_OperDatePartner.MovementId = MIContainer.MovementId
                                                                   AND MD_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                                                   AND MD_OperDatePartner.ValueData BETWEEN vbStartDate AND vbEndDate
                                       GROUP BY MIContainer.ObjectExtId_analyzer
                                              , MD_OperDatePartner.ValueData
                                              , MIContainer.MovementId
                                              , MIContainer.MovementItemId
                                              , MIContainer.ObjectId_Analyzer
                                              , MIContainer.ObjectIntId_Analyzer
                                      )*/
                        -- продажа - почти вся
                      , tmpMI_sale AS (-- Оптимизация - 2.1
                                       SELECT MovementLinkObject_To.ObjectId                 AS PartnerId
                                            , MD_OperDatePartner.ValueData                   AS OperDate
                                            , MovementItem.MovementId                        AS MovementId
                                            , MovementItem.Id                                AS MovementItemId
                                            , MovementItem.ObjectId                          AS GoodsId
                                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  AS GoodsKindId
                                            , MIFloat_AmountPartner.ValueData                AS Amount
                                            , MIFloat_Price.ValueData                        AS Price_original -- Price_find
                                       FROM MovementDate AS MD_OperDatePartner
                                            INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                          ON MovementLinkObject_To.MovementId = MD_OperDatePartner.MovementId
                                                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                            INNER JOIN tmpPartner ON tmpPartner.PartnerId = MovementLinkObject_To.ObjectId
                                            INNER JOIN Movement ON Movement.Id       = MD_OperDatePartner.MovementId
                                                               AND Movement.DescId   = zc_Movement_Sale()
                                                               AND Movement.StatusId = zc_Enum_Status_Complete()


                                            INNER JOIN MovementLinkObject AS MLO_PaidKind
                                                                          ON MLO_PaidKind.MovementId = MD_OperDatePartner.MovementId
                                                                         AND MLO_PaidKind.DescId     = zc_MovementLinkObject_PaidKind()
                                                                         AND MLO_PaidKind.ObjectId   = vbPaidKindId
                                            INNER JOIN MovementLinkObject AS MLO_Contract
                                                                          ON MLO_Contract.MovementId = MD_OperDatePartner.MovementId
                                                                         AND MLO_Contract.DescId     = zc_MovementLinkObject_Contract()
                                                                         AND MLO_Contract.ObjectId   = vbContractId


                                            INNER JOIN MovementItem ON MovementItem.MovementId = MD_OperDatePartner.MovementId
                                                                   AND MovementItem.isErased    = FALSE
                                                                   AND MovementItem.DescId      = zc_MI_Master()
                                            INNER JOIN tmpGoods_list ON tmpGoods_list.GoodsId = MovementItem.ObjectId
                                            INNER JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                                         ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                                        AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                                                                        AND MIFloat_AmountPartner.ValueData    <> 0

                                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                                            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                                       AND MIFloat_Price.DescId         = zc_MIFloat_Price()

                                       WHERE MD_OperDatePartner.ValueData BETWEEN vbStartDate AND vbEndDate
                                         AND MD_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                      )
                        -- продажа - с ограничениями (так типа быстрее)
                      /*, tmpMI_sale AS (SELECT tmpMI_sale_all.*
                                            -- , tmpMI_ReturnIn.Price_original
                                            , MIFloat_Price.ValueData    AS Price_original -- Price_find
                                       FROM tmpMI_sale_all
                                            INNER JOIN MovementLinkObject AS MLO_PaidKind
                                                                          ON MLO_PaidKind.MovementId = tmpMI_sale_all.MovementId
                                                                         AND MLO_PaidKind.DescId     = zc_MovementLinkObject_PaidKind()
                                                                         AND MLO_PaidKind.ObjectId   = vbPaidKindId
                                            INNER JOIN MovementLinkObject AS MLO_Contract
                                                                          ON MLO_Contract.MovementId = tmpMI_sale_all.MovementId
                                                                         AND MLO_Contract.DescId     = zc_MovementLinkObject_Contract()
                                                                         AND MLO_Contract.ObjectId   = vbContractId
                                            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                        ON MIFloat_Price.MovementItemId = tmpMI_sale_all.MovementItemId
                                                                       AND MIFloat_Price.DescId         = zc_MIFloat_Price()
                                                                      -- AND MIFloat_Price.ValueData      = tmpMI_ReturnIn.Price_original
                                            -- INNER JOIN tmpMI_ReturnIn ON tmpMI_ReturnIn.GoodsId        = tmpMI_sale_all.GoodsId
                                            --                          AND tmpMI_ReturnIn.GoodsKindId    = tmpMI_sale_all.GoodsKindId
                                            --                          AND tmpMI_ReturnIn.Price_original = MIFloat_Price.ValueData
                                       -- WHERE tmpMI_sale_all.GoodsKindId IN (SELECT DISTINCT tmpMI_ReturnIn.GoodsKindId FROM tmpMI_ReturnIn)
                                      )*/
                   -- находим для продаж - сколько уже привязано в возвратах
                 , tmpMI_ReturnIn_find AS (SELECT tmpMI_sale.MovementItemId
                                                , SUM (MovementItem.Amount) AS Amount
                                           FROM tmpMI_sale
                                                INNER JOIN MovementItemFloat AS MIFloat_MovementItemId
                                                                             ON MIFloat_MovementItemId.ValueData = tmpMI_sale.MovementItemId
                                                                            AND MIFloat_MovementItemId.DescId    = zc_MIFloat_MovementItemId()
                                                INNER JOIN MovementItem ON MovementItem.Id          = MIFloat_MovementItemId.ValueData :: Integer
                                                                       AND MovementItem.isErased    = FALSE
                                                                       AND MovementItem.DescId      = zc_MI_Master()
                                                                       AND MovementItem.MovementId <> inMovementId -- !!!что б не попал текущий возврат!!!
                                                INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                   AND Movement.DescId   IN (zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn())
                                                                   AND Movement.StatusId = zc_Enum_Status_Complete()
                                           GROUP BY tmpMI_sale.MovementItemId
                                          )
               -- результат - среди этих продаж будем подбирать партии
               SELECT tmpMI_sale.PartnerId
                    , tmpMI_sale.OperDate
                    , tmpMI_sale.MovementId
                    , MIN (tmpMI_sale.MovementItemId) AS MovementItemId
                    , tmpMI_sale.GoodsId
                    , tmpMI_sale.GoodsKindId
                    , SUM (tmpMI_sale.Amount - COALESCE (tmpMI_ReturnIn_find.Amount, 0))
                    , tmpMI_sale.Price_original
               FROM tmpMI_sale
                    LEFT JOIN tmpMI_ReturnIn_find ON tmpMI_ReturnIn_find.MovementItemId = tmpMI_sale.MovementItemId
               GROUP BY tmpMI_sale.PartnerId
                      , tmpMI_sale.OperDate
                      , tmpMI_sale.MovementId
                      , tmpMI_sale.GoodsId
                      , tmpMI_sale.GoodsKindId
                      , tmpMI_sale.Price_original
             ;


            -- курсор1 - текущий возврат МИНУС сколько партий нашли (т.е. сколько осталось)
            OPEN curMI_ReturnIn FOR    SELECT tmp1.MovementItemId, tmp1.GoodsId, tmp1.GoodsKindId, tmp1.Price_original, tmp1.Amount - COALESCE (tmp2.Amount, 0) AS Amount
                                       FROM (SELECT MIN (tmp.MovementItemId) AS MovementItemId, tmp.GoodsId, tmp.GoodsKindId, tmp.Price_original, SUM (tmp.OperCount_Partner) AS Amount FROM _tmpItem AS tmp GROUP BY tmp.GoodsId, tmp.GoodsKindId, tmp.Price_original
                                            ) AS tmp1
                                            LEFT JOIN (SELECT tmp.GoodsId, tmp.GoodsKindId_return AS GoodsKindId, tmp.Price_original, SUM (tmp.Amount) AS Amount FROM _tmpResult_ReturnIn_Auto AS tmp GROUP BY tmp.GoodsId, tmp.GoodsKindId_return, tmp.Price_original
                                                      ) AS tmp2 ON tmp2.GoodsId        = tmp1.GoodsId
                                                               AND tmp2.GoodsKindId    = tmp1.GoodsKindId
                                                               AND tmp2.Price_original = tmp1.Price_original
                                       WHERE tmp1.Amount - COALESCE (tmp2.Amount, 0) > 0
                                      ;
            -- начало цикла по курсору1 - возвраты
            LOOP
                -- данные по возвратам
                FETCH curMI_ReturnIn INTO vbMovementItemId_return, vbGoodsId, vbGoodsKindId, vbOperPrice, vbAmount;
                -- если данные закончились, тогда выход
                IF NOT FOUND THEN EXIT; END IF;


                -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!
                -- !!!!! 1 - vbGoodsKindId!!!!!
                -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!

                -- курсор2 - все продажи для ОДНОГО элемента возврата
                OPEN curMI_Sale FOR
                   SELECT _tmpResult_Sale_Auto.MovementId, _tmpResult_Sale_Auto.MovementItemId, _tmpResult_Sale_Auto.Amount
                   FROM _tmpResult_Sale_Auto
                   WHERE _tmpResult_Sale_Auto.GoodsId        = vbGoodsId
                     AND _tmpResult_Sale_Auto.GoodsKindId    = vbGoodsKindId
                     AND _tmpResult_Sale_Auto.Price_original = vbOperPrice
                     AND _tmpResult_Sale_Auto.PartnerId      = vbPartnerId
                   ORDER BY _tmpResult_Sale_Auto.OperDate DESC, _tmpResult_Sale_Auto.Amount DESC
                  ;

                -- начало цикла по курсору2 - продажи
                LOOP
                    -- данные по продажам
                    FETCH curMI_Sale INTO vbMovementId_sale, vbMovementItemId_sale, vbAmount_sale;
                    -- если данные закончились, или все кол-во найдено тогда выход
                    IF NOT FOUND OR vbAmount = 0 THEN EXIT; END IF;


                    --
                    IF vbAmount_sale > vbAmount
                    THEN
                        -- получилось в продаже больше чем искали, !!!сохраняем в табл-результата!!!
                        INSERT INTO _tmpResult_ReturnIn_Auto (ParentId, MovementId_sale, MovementItemId_sale, GoodsId, GoodsKindId, GoodsKindId_return, Amount, Price_original)
                           SELECT vbMovementItemId_return, vbMovementId_sale, vbMovementItemId_sale, vbGoodsId, vbGoodsKindId, vbGoodsKindId, vbAmount, vbOperPrice;
                        -- обнуляем кол-во что бы больше не искать
                        vbAmount:= 0;
                    ELSE
                        -- получилось в продаже меньше чем искали, !!!сохраняем в табл-результата!!!
                        INSERT INTO _tmpResult_ReturnIn_Auto (ParentId, MovementId_sale, MovementItemId_sale, GoodsId, GoodsKindId, GoodsKindId_return, Amount, Price_original)
                           SELECT vbMovementItemId_return, vbMovementId_sale, vbMovementItemId_sale, vbGoodsId, vbGoodsKindId, vbGoodsKindId, vbAmount_sale, vbOperPrice;
                        -- уменьшаем на кол-во которое нашли и продолжаем поиск
                        vbAmount:= vbAmount - vbAmount_sale;
                    END IF;


                END LOOP; -- финиш цикла по курсору2 - продажи
                CLOSE curMI_Sale; -- закрыли курсор2 - продажи



                -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                -- !!!!! 2 - Start NOT vbGoodsKindId!!!!!
                -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                IF vbAmount > 0 THEN

                -- курсор2 - все продажи для ОДНОГО элемента возврата
                OPEN curMI_Sale_TWO FOR
                   SELECT _tmpResult_Sale_Auto.MovementId, _tmpResult_Sale_Auto.MovementItemId, _tmpResult_Sale_Auto.Amount
                        , _tmpResult_Sale_Auto.GoodsKindId
                   FROM _tmpResult_Sale_Auto
                   WHERE _tmpResult_Sale_Auto.GoodsId        = vbGoodsId
                     AND _tmpResult_Sale_Auto.GoodsKindId    <> vbGoodsKindId
                     AND _tmpResult_Sale_Auto.Price_original = vbOperPrice
                     AND _tmpResult_Sale_Auto.PartnerId      = vbPartnerId
                   ORDER BY _tmpResult_Sale_Auto.OperDate DESC, _tmpResult_Sale_Auto.Amount DESC
                  ;

                -- начало цикла по курсору2 - продажи
                LOOP
                    -- данные по продажам
                    FETCH curMI_Sale_TWO INTO vbMovementId_sale, vbMovementItemId_sale, vbAmount_sale, vbGoodsKindId_two;
                    -- если данные закончились, или все кол-во найдено тогда выход
                    IF NOT FOUND OR vbAmount = 0 THEN EXIT; END IF;


                    --
                    IF vbAmount_sale > vbAmount
                    THEN
                        -- получилось в продаже больше чем искали, !!!сохраняем в табл-результата!!!
                        INSERT INTO _tmpResult_ReturnIn_Auto (ParentId, MovementId_sale, MovementItemId_sale, GoodsId, GoodsKindId, GoodsKindId_return, Amount, Price_original)
                           SELECT vbMovementItemId_return, vbMovementId_sale, vbMovementItemId_sale, vbGoodsId, vbGoodsKindId_two, vbGoodsKindId, vbAmount, vbOperPrice;
                        -- обнуляем кол-во что бы больше не искать
                        vbAmount:= 0;
                    ELSE
                        -- получилось в продаже меньше чем искали, !!!сохраняем в табл-результата!!!
                        INSERT INTO _tmpResult_ReturnIn_Auto (ParentId, MovementId_sale, MovementItemId_sale, GoodsId, GoodsKindId, GoodsKindId_return, Amount, Price_original)
                           SELECT vbMovementItemId_return, vbMovementId_sale, vbMovementItemId_sale, vbGoodsId, vbGoodsKindId_two, vbGoodsKindId, vbAmount_sale, vbOperPrice;
                        -- уменьшаем на кол-во которое нашли и продолжаем поиск
                        vbAmount:= vbAmount - vbAmount_sale;
                    END IF;


                END LOOP; -- финиш цикла по курсору2 - продажи
                CLOSE curMI_Sale_TWO; -- закрыли курсор2 - продажи

                END IF; -- IF vbAmount > 0 THEN
                -- !!!!!!!!!!!!!!!!!!!!!!!
                -- !!!!! 2 -  End NOT vbGoodsKindId!!!!!
                -- !!!!!!!!!!!!!!!!!!!!!!!



                IF vbAmount > 0 THEN
                -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!
                -- !!!!! 3 - vbGoodsKindId AND NOT vbPartnerId!!!!!
                -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!

                -- курсор3 - все продажи для ОДНОГО элемента возврата
                OPEN curMI_Sale_3 FOR
                   SELECT _tmpResult_Sale_Auto.MovementId, _tmpResult_Sale_Auto.MovementItemId, _tmpResult_Sale_Auto.Amount
                   FROM _tmpResult_Sale_Auto
                   WHERE _tmpResult_Sale_Auto.GoodsId        = vbGoodsId
                     AND _tmpResult_Sale_Auto.GoodsKindId    = vbGoodsKindId
                     AND _tmpResult_Sale_Auto.Price_original = vbOperPrice
                     AND _tmpResult_Sale_Auto.PartnerId      <> vbPartnerId
                   ORDER BY _tmpResult_Sale_Auto.OperDate DESC, _tmpResult_Sale_Auto.Amount DESC
                  ;

                -- начало цикла по курсору3 - продажи
                LOOP
                    -- данные по продажам
                    FETCH curMI_Sale_3 INTO vbMovementId_sale, vbMovementItemId_sale, vbAmount_sale;
                    -- если данные закончились, или все кол-во найдено тогда выход
                    IF NOT FOUND OR vbAmount = 0 THEN EXIT; END IF;


                    --
                    IF vbAmount_sale > vbAmount
                    THEN
                        -- получилось в продаже больше чем искали, !!!сохраняем в табл-результата!!!
                        INSERT INTO _tmpResult_ReturnIn_Auto (ParentId, MovementId_sale, MovementItemId_sale, GoodsId, GoodsKindId, GoodsKindId_return, Amount, Price_original)
                           SELECT vbMovementItemId_return, vbMovementId_sale, vbMovementItemId_sale, vbGoodsId, vbGoodsKindId, vbGoodsKindId, vbAmount, vbOperPrice;
                        -- обнуляем кол-во что бы больше не искать
                        vbAmount:= 0;
                    ELSE
                        -- получилось в продаже меньше чем искали, !!!сохраняем в табл-результата!!!
                        INSERT INTO _tmpResult_ReturnIn_Auto (ParentId, MovementId_sale, MovementItemId_sale, GoodsId, GoodsKindId, GoodsKindId_return, Amount, Price_original)
                           SELECT vbMovementItemId_return, vbMovementId_sale, vbMovementItemId_sale, vbGoodsId, vbGoodsKindId, vbGoodsKindId, vbAmount_sale, vbOperPrice;
                        -- уменьшаем на кол-во которое нашли и продолжаем поиск
                        vbAmount:= vbAmount - vbAmount_sale;
                    END IF;


                END LOOP; -- финиш цикла по курсору3 - продажи
                CLOSE curMI_Sale_3; -- закрыли курсор3 - продажи

                END IF; -- IF vbAmount > 0 THEN
                -- !!!!!!!!!!!!!!!!!!!!!!!
                -- !!!!! 3 -  End vbGoodsKindId AND NOT vbPartnerId!!!!!
                -- !!!!!!!!!!!!!!!!!!!!!!!


                -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                -- !!!!! 4 - Start NOT vbGoodsKindId AND NOT vbPartnerId!!!!!
                -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                IF vbAmount > 0 THEN

                -- курсор2 - все продажи для ОДНОГО элемента возврата
                OPEN curMI_Sale_4 FOR
                   SELECT _tmpResult_Sale_Auto.MovementId, _tmpResult_Sale_Auto.MovementItemId, _tmpResult_Sale_Auto.Amount
                        , _tmpResult_Sale_Auto.GoodsKindId
                   FROM _tmpResult_Sale_Auto
                   WHERE _tmpResult_Sale_Auto.GoodsId        = vbGoodsId
                     AND _tmpResult_Sale_Auto.GoodsKindId    <> vbGoodsKindId
                     AND _tmpResult_Sale_Auto.Price_original = vbOperPrice
                     AND _tmpResult_Sale_Auto.PartnerId      <> vbPartnerId
                   ORDER BY _tmpResult_Sale_Auto.OperDate DESC, _tmpResult_Sale_Auto.Amount DESC
                  ;

                -- начало цикла по курсору2 - продажи
                LOOP
                    -- данные по продажам
                    FETCH curMI_Sale_4 INTO vbMovementId_sale, vbMovementItemId_sale, vbAmount_sale, vbGoodsKindId_two;
                    -- если данные закончились, или все кол-во найдено тогда выход
                    IF NOT FOUND OR vbAmount = 0 THEN EXIT; END IF;


                    --
                    IF vbAmount_sale > vbAmount
                    THEN
                        -- получилось в продаже больше чем искали, !!!сохраняем в табл-результата!!!
                        INSERT INTO _tmpResult_ReturnIn_Auto (ParentId, MovementId_sale, MovementItemId_sale, GoodsId, GoodsKindId, GoodsKindId_return, Amount, Price_original)
                           SELECT vbMovementItemId_return, vbMovementId_sale, vbMovementItemId_sale, vbGoodsId, vbGoodsKindId_two, vbGoodsKindId, vbAmount, vbOperPrice;
                        -- обнуляем кол-во что бы больше не искать
                        vbAmount:= 0;
                    ELSE
                        -- получилось в продаже меньше чем искали, !!!сохраняем в табл-результата!!!
                        INSERT INTO _tmpResult_ReturnIn_Auto (ParentId, MovementId_sale, MovementItemId_sale, GoodsId, GoodsKindId, GoodsKindId_return, Amount, Price_original)
                           SELECT vbMovementItemId_return, vbMovementId_sale, vbMovementItemId_sale, vbGoodsId, vbGoodsKindId_two, vbGoodsKindId, vbAmount_sale, vbOperPrice;
                        -- уменьшаем на кол-во которое нашли и продолжаем поиск
                        vbAmount:= vbAmount - vbAmount_sale;
                    END IF;


                END LOOP; -- финиш цикла по курсору2 - продажи
                CLOSE curMI_Sale_4; -- закрыли курсор2 - продажи

                END IF; -- IF vbAmount > 0 THEN
                -- !!!!!!!!!!!!!!!!!!!!!!!
                -- !!!!! 4 -  End NOT vbGoodsKindId AND NOT vbPartnerId!!!!!
                -- !!!!!!!!!!!!!!!!!!!!!!!


            END LOOP; -- финиш цикла по курсору1 - возвраты
            CLOSE curMI_ReturnIn; -- закрыли курсор1 - возвраты



            -- теперь следующий период
            vbStep:= vbStep + 1;
            vbEndDate:= vbStartDate - INTERVAL '1 DAY';
            vbStartDate:= (WITH tmp AS (SELECT CASE WHEN vbStep = 2 THEN vbStartDate - vbPeriod2 ELSE vbStartDate - vbPeriod3 END AS StartDate)
                           SELECT CASE WHEN inStartDateSale >= tmp.StartDate THEN inStartDateSale ELSE tmp.StartDate END FROM tmp);


         END LOOP; -- Цикл по периодам (так наверно быстрее)




     -- !!!сохранение!!!
     PERFORM lpInsertUpdate_MovementItem_ReturnIn_Child (ioId                  := tmp.MovementItemId
                                                       , inMovementId          := inMovementId
                                                       , inParentId            := tmp.ParentId
                                                       , inGoodsId             := tmp.GoodsId
                                                       , inAmount              := CASE WHEN tmp.MovementId_sale > 0 AND tmp.MovementItemId_sale > 0 THEN COALESCE (tmp.Amount, 0) ELSE 0 END
                                                       , inMovementId_sale     := COALESCE (tmp.MovementId_sale, 0)
                                                       , inMovementItemId_sale := COALESCE (tmp.MovementItemId_sale, 0)
                                                       , inUserId              := inUserId
                                                       , inIsRightsAll         := TRUE
                                                        )
     FROM (WITH MI_Master AS (SELECT MovementItem.Id, MovementItem.ObjectId AS GoodsId
                              FROM MovementItem
                              WHERE MovementItem.MovementId = inMovementId
                                AND MovementItem.DescId     = zc_MI_Master()
                             )
               , MI_Child AS (SELECT MovementItem.Id, MovementItem.ParentId, COALESCE (MIFloat_MovementItemId.ValueData, 0) :: Integer AS MovementItemId_sale
                              FROM MovementItem
                                   LEFT JOIN MovementItemFloat AS MIFloat_MovementItemId
                                                               ON MIFloat_MovementItemId.MovementItemId = MovementItem.Id
                                                              AND MIFloat_MovementItemId.DescId         = zc_MIFloat_MovementItemId()
                              WHERE MovementItem.MovementId = inMovementId
                                AND MovementItem.DescId     = zc_MI_Child()
                             )
                 , MI_All AS (SELECT MI_Child.Id AS MovementItemId
                                   , COALESCE (_tmpResult_ReturnIn_Auto.ParentId, COALESCE (MI_Child.ParentId, 0)) AS ParentId
                                   , _tmpResult_ReturnIn_Auto.MovementId_sale
                                   , _tmpResult_ReturnIn_Auto.MovementItemId_sale
                                   , _tmpResult_ReturnIn_Auto.Amount
                              FROM _tmpResult_ReturnIn_Auto
                                   FULL JOIN MI_Child ON MI_Child.ParentId            = _tmpResult_ReturnIn_Auto.ParentId
                                                     AND MI_Child.MovementItemId_sale = _tmpResult_ReturnIn_Auto.MovementItemId_sale
                             )
           -- результат
           SELECT MI_Master.Id AS ParentId
                , MI_Master.GoodsId
                , MI_All.MovementItemId
                , MI_All.MovementId_sale
                , MI_All.MovementItemId_sale
                , MI_All.Amount
           FROM MI_Master
                LEFT JOIN MI_All ON MI_All.ParentId = MI_Master.Id
          ) AS tmp;

    

     -- !!!вернули ОШИБКУ, если есть!!!
     outMessageText:= lpCheck_Movement_ReturnIn_Auto (inMovementId    := inMovementId
                                                    , inUserId        := inUserId
                                                     )
       || CHR (13) || 'за период с <' || DATE (inStartDateSale) :: TVarChar || '> по <' || DATE (inEndDateSale) :: TVarChar || '>'
       || CHR (13) || '(' || (vbStep - 1) :: TVarChar || ')'
       || CHR (13) || (SELECT COUNT(*) FROM _tmpResult_Sale_Auto) :: TVarChar
            -- || ' ' || (SELECT COUNT(*) FROM _tmpResult_ReturnIn_Auto) :: TVarChar
            -- || ' ' || DATE (vbStartDate) :: TVarChar
            -- || ' ' || DATE (vbEndDate) :: TVarChar
                     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 14.05.16                                        *
*/

-- тест
-- SELECT * FROM MovementItem WHERE MovementId = 3662505 AND DescId = zc_MI_Child() -- SELECT * FROM MovementItemFloat WHERE MovementItemId IN (SELECT Id FROM MovementItem WHERE MovementId = 3662505 AND DescId = zc_MI_Child())
-- SELECT lpUpdate_Movement_ReturnIn_Auto_OLD (inMovementId:= Movement.Id, inStartDateSale:= Movement.OperDate - INTERVAL '1 DAY', inEndDateSale:= Movement.OperDate, inUserId:= zfCalc_UserAdmin() :: Integer) || CHR (13), Movement.* FROM Movement WHERE Movement.Id = 2582825
-- SELECT lpUpdate_Movement_ReturnIn_Auto_OLD (inMovementId:= Movement.Id, inStartDateSale:= Movement.OperDate - INTERVAL '2 MONTH', inEndDateSale:= Movement.OperDate, inUserId:= zfCalc_UserAdmin() :: Integer) || CHR (13), Movement.* FROM Movement WHERE Movement.Id = 2582825
