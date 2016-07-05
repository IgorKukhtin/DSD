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

   DECLARE vbStartDate      TDateTime;
   DECLARE vbEndDate        TDateTime;
   DECLARE vbPartnerId      Integer;
   DECLARE vbJuridicalId    Integer;
   DECLARE vbPaidKindId     Integer;
   DECLARE vbContractId     Integer;
   DECLARE vbMovementDescId Integer;

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
         --
         DELETE FROM _tmpItem;
         --
         DELETE FROM _tmpResult_ReturnIn_Auto;
         --
         DELETE FROM _tmpPartner_ReturnIn_Auto;
     ELSE
         -- таблица - текущие возвраты***
         CREATE TEMP TABLE _tmpItem (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, OperCount TFloat, OperCount_Partner TFloat, Price_original TFloat)  ON COMMIT DROP;
         -- таблица - продаж (для поиска партий) + оптимизации
         CREATE TEMP TABLE _tmpResult_Sale_Auto (MovementDescId Integer, PartnerId Integer, OperDate TDateTime, MovementId Integer, MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, Amount TFloat, Price_original TFloat) ON COMMIT DROP;
         -- таблица - результат (нашли партии)***
         CREATE TEMP TABLE _tmpResult_ReturnIn_Auto (ParentId Integer, MovementId_sale Integer, MovementItemId_sale Integer, GoodsId Integer, GoodsKindId Integer, GoodsKindId_return Integer, Amount TFloat, Price_original TFloat) ON COMMIT DROP;
         -- таблица - список контрагентов (для оптимизации)***
         CREATE TEMP TABLE _tmpPartner_ReturnIn_Auto (PartnerId Integer) ON COMMIT DROP;
         -- таблица - список товаров (для оптимизации)
         CREATE TEMP TABLE _tmpGoods_ReturnIn_Auto_all (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, Price_original TFloat, Amount TFloat) ON COMMIT DROP;
         CREATE TEMP TABLE _tmpGoods_ReturnIn_Auto_two (GoodsId Integer, Price_original TFloat) ON COMMIT DROP;
         CREATE TEMP TABLE _tmpGoods_ReturnIn_Auto (GoodsId Integer) ON COMMIT DROP;
     END IF;


     -- текущие возвраты - сформировали один раз***
     INSERT INTO _tmpItem (MovementItemId, GoodsId, GoodsKindId, OperCount, OperCount_Partner, Price_original)
        SELECT MI.Id AS MovementItemId, MI.ObjectId AS GoodsId, COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
             , CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN COALESCE (MIF_AmountPartner.ValueData, 0) ELSE MI.Amount END AS OperCount
             , CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN COALESCE (MIF_AmountPartner.ValueData, 0) ELSE MI.Amount END AS OperCount_Partner
             , COALESCE (MIF_Price.ValueData, 0) AS Price_original
        FROM MovementItem AS MI
             LEFT JOIN Movement ON Movement.Id = MI.MovementId
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind ON MILinkObject_GoodsKind.MovementItemId = MI.Id AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
             LEFT JOIN MovementItemFloat AS MIF_AmountPartner ON MIF_AmountPartner.MovementItemId = MI.Id AND MIF_AmountPartner.DescId = zc_MIFloat_AmountPartner()
             LEFT JOIN MovementItemFloat AS MIF_Price ON MIF_Price.MovementItemId = MI.Id AND MIF_Price.DescId = zc_MIFloat_Price()
        WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE
          AND CASE WHEN Movement.DescId = zc_Movement_Sale() THEN COALESCE (MIF_AmountPartner.ValueData, 0) ELSE MI.Amount END <> 0
       ;



     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - ПОИСК ПАРТИЙ !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


         -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
         -- !!!будут медленно формироваться партии продажи!!!
         -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

         -- параметры из документа
         SELECT CASE WHEN inStartDateSale >= DATE_TRUNC ('MONTH', COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate)) THEN inStartDateSale ELSE DATE_TRUNC ('MONTH', COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate)) END AS StartDate
              , CASE WHEN 1=1
                          THEN DATE_TRUNC ('MONTH', COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate)) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'
                     ELSE COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) - INTERVAL '1 DAY'
                END AS EndDate
              , CASE WHEN 1=1
                          THEN DATE_TRUNC ('MONTH', COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate)) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'
                     ELSE COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) - INTERVAL '1 DAY'
                END AS inEndDateSale -- !!!замена!!!

              , Movement.DescId                      AS DescId
              , CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN MovementLinkObject_From.ObjectId ELSE COALESCE (MovementLinkObject_Partner.ObjectId, 0) END AS PartnerId
              , CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN 0 ELSE MovementLinkObject_From.ObjectId END AS JuridicalId
              , MovementLinkObject_PaidKind.ObjectId AS PaidKindId
              , MovementLinkObject_Contract.ObjectId AS ContractId

                INTO vbStartDate, vbEndDate, inEndDateSale
                   , vbMovementDescId, vbPartnerId, vbJuridicalId, vbPaidKindId, vbContractId
         FROM Movement
              LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                     ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                    AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
                                    AND Movement.DescId                         = zc_Movement_ReturnIn()
              LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                           ON MovementLinkObject_Partner.MovementId = Movement.Id
                                          AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_PartnerFrom()
              LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                           ON MovementLinkObject_From.MovementId = Movement.Id
                                          AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()

              LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                           ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                          AND MovementLinkObject_PaidKind.DescId     IN (zc_MovementLinkObject_PaidKind(), zc_MovementLinkObject_PaidKindFrom())
              LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                           ON MovementLinkObject_Contract.MovementId = Movement.Id
                                          AND MovementLinkObject_Contract.DescId     IN (zc_MovementLinkObject_Contract(), zc_MovementLinkObject_ContractFrom())
         WHERE Movement.Id = inMovementId;


         -- список контрагентов - сформировали один раз***
         INSERT INTO _tmpPartner_ReturnIn_Auto (PartnerId)
            SELECT ObjectLink_Jur.ObjectId AS PartnerId
            FROM ObjectLink AS ObjectLink_Jur
            WHERE ObjectLink_Jur.ChildObjectId = vbJuridicalId
              AND ObjectLink_Jur.DescId        = zc_ObjectLink_Partner_Juridical()
           UNION
            SELECT ObjectLink_Jur.ObjectId AS PartnerId
            FROM ObjectLink AS ObjectLink_Jur
            WHERE ObjectLink_Jur.ChildObjectId = (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.ObjectId = vbPartnerId AND ObjectLink.DescId = zc_ObjectLink_Partner_Juridical())
              AND ObjectLink_Jur.DescId        = zc_ObjectLink_Partner_Juridical()
           ;
         -- Оптимизация
         ANALYZE _tmpPartner_ReturnIn_Auto;


         -- Цикл по периодам (так наверно быстрее)
         WHILE vbStartDate >= inStartDateSale AND vbStartDate <= vbEndDate LOOP

            -- очистили - список товаров (для оптимизации)
            DELETE FROM _tmpGoods_ReturnIn_Auto_all;
            DELETE FROM _tmpGoods_ReturnIn_Auto_two;
            DELETE FROM _tmpGoods_ReturnIn_Auto;
            -- список товаров - формируется каждый раз
            INSERT INTO _tmpGoods_ReturnIn_Auto_all (MovementItemId, GoodsId, GoodsKindId, Price_original, Amount)
               -- текущий возврат МИНУС сколько партий нашли (т.е. сколько осталось)
               SELECT tmp1.MovementItemId, tmp1.GoodsId, tmp1.GoodsKindId, tmp1.Price_original, tmp1.Amount - COALESCE (tmp2.Amount, 0) AS Amount
               FROM (SELECT MIN (tmp.MovementItemId) AS MovementItemId, tmp.GoodsId, tmp.GoodsKindId, tmp.Price_original
                          , SUM (tmp.OperCount_Partner) AS Amount
                     FROM _tmpItem AS tmp GROUP BY tmp.GoodsId, tmp.GoodsKindId, tmp.Price_original
                    ) AS tmp1
                    LEFT JOIN (SELECT tmp.GoodsId, tmp.GoodsKindId_return AS GoodsKindId, tmp.Price_original, SUM (tmp.Amount) AS Amount
                               FROM _tmpResult_ReturnIn_Auto AS tmp GROUP BY tmp.GoodsId, tmp.GoodsKindId_return, tmp.Price_original
                              ) AS tmp2 ON tmp2.GoodsId        = tmp1.GoodsId
                                       AND tmp2.GoodsKindId    = tmp1.GoodsKindId
                                       AND tmp2.Price_original = tmp1.Price_original
               WHERE tmp1.Amount - COALESCE (tmp2.Amount, 0) > 0;
            -- ... каждый раз
            INSERT INTO _tmpGoods_ReturnIn_Auto_two (GoodsId, Price_original) SELECT DISTINCT tmp.GoodsId, tmp.Price_original FROM _tmpGoods_ReturnIn_Auto_all AS tmp;
            -- ... каждый раз
            INSERT INTO _tmpGoods_ReturnIn_Auto (GoodsId) SELECT DISTINCT tmp.GoodsId FROM _tmpGoods_ReturnIn_Auto_all AS tmp;
            -- Оптимизация
            ANALYZE _tmpGoods_ReturnIn_Auto_all; ANALYZE _tmpGoods_ReturnIn_Auto_two; ANALYZE _tmpGoods_ReturnIn_Auto;


            -- очистили - продажи (для поиска партий) + оптимизации
            DELETE FROM _tmpResult_Sale_Auto;

            -- продажи (потом среди этих продаж будем подбирать партии) - формируется каждый раз
            INSERT INTO _tmpResult_Sale_Auto (MovementDescId, PartnerId, OperDate, MovementId, MovementItemId, GoodsId, GoodsKindId, Amount, Price_original)

               WITH -- текущий возврат МИНУС сколько партий нашли (т.е. сколько осталось)
                    tmpMI_ReturnIn AS (SELECT * FROM _tmpGoods_ReturnIn_Auto_all)
                    -- продажа - почти вся
                  , tmpMI_sale_all AS (-- Оптимизация - 2.1
                                       SELECT zc_Movement_ReturnIn()                         AS MovementDescId
                                            , MovementLinkObject_To.ObjectId                 AS PartnerId
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
                                            INNER JOIN _tmpPartner_ReturnIn_Auto AS tmpPartner_list ON tmpPartner_list.PartnerId = MovementLinkObject_To.ObjectId
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
                                            INNER JOIN _tmpGoods_ReturnIn_Auto AS tmpGoods_list ON tmpGoods_list.GoodsId = MovementItem.ObjectId
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
                                      UNION ALL
                                       SELECT zc_Movement_TransferDebtIn()                   AS MovementDescId
                                            , COALESCE (MovementLinkObject_To.ObjectId, 0)   AS PartnerId
                                            , Movement.OperDate                              AS OperDate
                                            , MovementItem.MovementId                        AS MovementId
                                            , MovementItem.Id                                AS MovementItemId
                                            , MovementItem.ObjectId                          AS GoodsId
                                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  AS GoodsKindId
                                            , MovementItem.Amount                            AS Amount
                                            , MIFloat_Price.ValueData                        AS Price_original -- Price_find
                                       FROM Movement
                                            INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                         AND MovementLinkObject_To.ObjectId = vbJuridicalId
                                            -- INNER JOIN _tmpPartner_ReturnIn_Auto AS tmpPartner_list ON tmpPartner_list.PartnerId = 

                                            INNER JOIN MovementLinkObject AS MLO_PaidKind
                                                                          ON MLO_PaidKind.MovementId = Movement.Id
                                                                         AND MLO_PaidKind.DescId     = zc_MovementLinkObject_PaidKindTo()
                                                                         AND MLO_PaidKind.ObjectId   = vbPaidKindId
                                            INNER JOIN MovementLinkObject AS MLO_Contract
                                                                          ON MLO_Contract.MovementId = Movement.Id
                                                                         AND MLO_Contract.DescId     = zc_MovementLinkObject_ContractTo()
                                                                         AND MLO_Contract.ObjectId   = vbContractId

                                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                   AND MovementItem.isErased    = FALSE
                                                                   AND MovementItem.DescId      = zc_MI_Master()
                                                                   AND MovementItem.Amount      <> 0
                                            INNER JOIN _tmpGoods_ReturnIn_Auto AS tmpGoods_list ON tmpGoods_list.GoodsId = MovementItem.ObjectId

                                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                                            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                                       AND MIFloat_Price.DescId         = zc_MIFloat_Price()

                                       WHERE Movement.OperDate BETWEEN vbStartDate AND vbEndDate
                                         AND Movement.DescId   = zc_Movement_TransferDebtOut()
                                         AND Movement.StatusId = zc_Enum_Status_Complete()
                                      )
                        -- продажа - с ограничениями (так типа быстрее)
                      , tmpMI_sale AS (SELECT tmpMI_sale_all.*
                                       FROM tmpMI_sale_all
                                            INNER JOIN _tmpGoods_ReturnIn_Auto_two ON _tmpGoods_ReturnIn_Auto_two.GoodsId        = tmpMI_sale_all.GoodsId
                                                                                  AND _tmpGoods_ReturnIn_Auto_two.Price_original = tmpMI_sale_all.Price_original
                                      )
                   -- находим для продаж - сколько уже привязано в возвратах
                 , tmpMI_ReturnIn_find AS (SELECT tmpMI_sale.MovementItemId
                                                , SUM (MovementItem.Amount) AS Amount
                                           FROM tmpMI_sale
                                                INNER JOIN MovementItemFloat AS MIFloat_MovementItemId
                                                                             ON MIFloat_MovementItemId.ValueData = tmpMI_sale.MovementItemId
                                                                            AND MIFloat_MovementItemId.DescId    = zc_MIFloat_MovementItemId()
                                                INNER JOIN MovementItem ON MovementItem.Id          = MIFloat_MovementItemId.MovementItemId
                                                                       AND MovementItem.isErased    = FALSE
                                                                       AND MovementItem.DescId      = zc_MI_Child()
                                                                       AND MovementItem.MovementId <> inMovementId -- !!!что б не попал текущий возврат!!!
                                                INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                   AND Movement.DescId   IN (zc_Movement_ReturnIn(), zc_Movement_TransferDebtIn())
                                                                   AND Movement.StatusId = zc_Enum_Status_Complete()
                                           GROUP BY tmpMI_sale.MovementItemId
                                          )
               -- результат - среди этих продаж будем подбирать партии
               SELECT tmpMI_sale.MovementDescId
                    , tmpMI_sale.PartnerId
                    , tmpMI_sale.OperDate
                    , tmpMI_sale.MovementId
                    ,  (tmpMI_sale.MovementItemId) AS MovementItemId -- !!! MIN ???
                    , tmpMI_sale.GoodsId
                    , tmpMI_sale.GoodsKindId
                    , (tmpMI_sale.Amount - COALESCE (tmpMI_ReturnIn_find.Amount, 0)) -- !!! SUM ???
                    , tmpMI_sale.Price_original
               FROM tmpMI_sale
                    LEFT JOIN tmpMI_ReturnIn_find ON tmpMI_ReturnIn_find.MovementItemId = tmpMI_sale.MovementItemId
               WHERE (tmpMI_sale.Amount - COALESCE (tmpMI_ReturnIn_find.Amount, 0)) > 0
               /*GROUP BY tmpMI_sale.MovementDescId
                      , tmpMI_sale.PartnerId
                      , tmpMI_sale.OperDate
                      , tmpMI_sale.MovementId
                      , tmpMI_sale.GoodsId
                      , tmpMI_sale.GoodsKindId
                      , tmpMI_sale.Price_original*/
             ;


            -- курсор1 - текущий возврат МИНУС сколько партий нашли (т.е. сколько осталось)
            OPEN curMI_ReturnIn FOR SELECT tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindId, tmp.Price_original, tmp.Amount FROM _tmpGoods_ReturnIn_Auto_all AS tmp;
            -- начало цикла по курсору1 - возвраты
            LOOP
                -- данные по возвратам
                FETCH curMI_ReturnIn INTO vbMovementItemId_return, vbGoodsId, vbGoodsKindId, vbOperPrice, vbAmount;
                -- если данные закончились, тогда выход
                IF NOT FOUND THEN EXIT; END IF;


                -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                -- !!!!! 1.1. - ALL PARAM !!!!!!!!
                -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

                -- курсор2 - все продажи для ОДНОГО элемента возврата
                OPEN curMI_Sale FOR
                   SELECT _tmpResult_Sale_Auto.MovementId, _tmpResult_Sale_Auto.MovementItemId, _tmpResult_Sale_Auto.Amount
                   FROM _tmpResult_Sale_Auto
                   WHERE _tmpResult_Sale_Auto.GoodsId        = vbGoodsId
                     AND _tmpResult_Sale_Auto.GoodsKindId    = vbGoodsKindId
                     AND _tmpResult_Sale_Auto.Price_original = vbOperPrice
                     AND _tmpResult_Sale_Auto.PartnerId      = vbPartnerId
                     AND _tmpResult_Sale_Auto.MovementDescId = vbMovementDescId
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



                IF vbAmount <> 0 THEN
                -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                -- !!!!! 1.2. - ALL PARAM !!!!!!!!
                -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

                -- курсор2 - все продажи для ОДНОГО элемента возврата
                OPEN curMI_Sale FOR
                   SELECT _tmpResult_Sale_Auto.MovementId, _tmpResult_Sale_Auto.MovementItemId, _tmpResult_Sale_Auto.Amount
                   FROM _tmpResult_Sale_Auto
                   WHERE _tmpResult_Sale_Auto.GoodsId        = vbGoodsId
                     AND _tmpResult_Sale_Auto.GoodsKindId    = vbGoodsKindId
                     AND _tmpResult_Sale_Auto.Price_original = vbOperPrice
                     AND _tmpResult_Sale_Auto.PartnerId      = vbPartnerId
                     AND _tmpResult_Sale_Auto.MovementDescId <> vbMovementDescId
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

                END IF; -- IF vbAmount <> 0 THEN
                -- !!!!!!!!!!!!!!!!!!!!!!!
                -- !!!!! 1.2. -  End !!!!!
                -- !!!!!!!!!!!!!!!!!!!!!!!



                -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                -- !!!!! 2.1. - Start NOT vbGoodsKindId!!!!!
                -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                IF vbAmount <> 0 THEN

                -- курсор2 - все продажи для ОДНОГО элемента возврата
                OPEN curMI_Sale_TWO FOR
                   SELECT _tmpResult_Sale_Auto.MovementId, _tmpResult_Sale_Auto.MovementItemId, _tmpResult_Sale_Auto.Amount
                        , _tmpResult_Sale_Auto.GoodsKindId
                   FROM _tmpResult_Sale_Auto
                   WHERE _tmpResult_Sale_Auto.GoodsId        = vbGoodsId
                     AND _tmpResult_Sale_Auto.GoodsKindId    <> vbGoodsKindId -- !!!без этого параметра!!!
                     AND _tmpResult_Sale_Auto.Price_original = vbOperPrice
                     AND _tmpResult_Sale_Auto.PartnerId      = vbPartnerId
                     AND _tmpResult_Sale_Auto.MovementDescId = vbMovementDescId
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

                END IF; -- IF vbAmount <> 0 THEN
                -- !!!!!!!!!!!!!!!!!!!!!!!
                -- !!!!! 2.1. -  End NOT vbGoodsKindId!!!!!
                -- !!!!!!!!!!!!!!!!!!!!!!!


                -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                -- !!!!! 2.2. - Start NOT vbGoodsKindId!!!!!
                -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                IF vbAmount <> 0 THEN

                -- курсор2 - все продажи для ОДНОГО элемента возврата
                OPEN curMI_Sale_TWO FOR
                   SELECT _tmpResult_Sale_Auto.MovementId, _tmpResult_Sale_Auto.MovementItemId, _tmpResult_Sale_Auto.Amount
                        , _tmpResult_Sale_Auto.GoodsKindId
                   FROM _tmpResult_Sale_Auto
                   WHERE _tmpResult_Sale_Auto.GoodsId        = vbGoodsId
                     AND _tmpResult_Sale_Auto.GoodsKindId    <> vbGoodsKindId -- !!!без этого параметра!!!
                     AND _tmpResult_Sale_Auto.Price_original = vbOperPrice
                     AND _tmpResult_Sale_Auto.PartnerId      = vbPartnerId
                     AND _tmpResult_Sale_Auto.MovementDescId <> vbMovementDescId
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

                END IF; -- IF vbAmount <> 0 THEN
                -- !!!!!!!!!!!!!!!!!!!!!!!
                -- !!!!! 2.2. -  End NOT vbGoodsKindId!!!!!
                -- !!!!!!!!!!!!!!!!!!!!!!!



                IF vbAmount <> 0 THEN
                -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!
                -- !!!!! 3.1. - vbGoodsKindId AND NOT vbPartnerId!!!!!
                -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!

                -- курсор3 - все продажи для ОДНОГО элемента возврата
                OPEN curMI_Sale_3 FOR
                   SELECT _tmpResult_Sale_Auto.MovementId, _tmpResult_Sale_Auto.MovementItemId, _tmpResult_Sale_Auto.Amount
                   FROM _tmpResult_Sale_Auto
                   WHERE _tmpResult_Sale_Auto.GoodsId        = vbGoodsId
                     AND _tmpResult_Sale_Auto.GoodsKindId    = vbGoodsKindId
                     AND _tmpResult_Sale_Auto.Price_original = vbOperPrice
                     AND _tmpResult_Sale_Auto.PartnerId      <> vbPartnerId -- !!!без этого параметра!!!
                     AND _tmpResult_Sale_Auto.MovementDescId = vbMovementDescId
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

                END IF; -- IF vbAmount <> 0 THEN
                -- !!!!!!!!!!!!!!!!!!!!!!!
                -- !!!!! 3.1. -  End vbGoodsKindId AND NOT vbPartnerId!!!!!
                -- !!!!!!!!!!!!!!!!!!!!!!!


                IF vbAmount <> 0 THEN
                -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!
                -- !!!!! 3.2. - vbGoodsKindId AND NOT vbPartnerId!!!!!
                -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!

                -- курсор3 - все продажи для ОДНОГО элемента возврата
                OPEN curMI_Sale_3 FOR
                   SELECT _tmpResult_Sale_Auto.MovementId, _tmpResult_Sale_Auto.MovementItemId, _tmpResult_Sale_Auto.Amount
                   FROM _tmpResult_Sale_Auto
                   WHERE _tmpResult_Sale_Auto.GoodsId        = vbGoodsId
                     AND _tmpResult_Sale_Auto.GoodsKindId    = vbGoodsKindId
                     AND _tmpResult_Sale_Auto.Price_original = vbOperPrice
                     AND _tmpResult_Sale_Auto.PartnerId      <> vbPartnerId -- !!!без этого параметра!!!
                     AND _tmpResult_Sale_Auto.MovementDescId <> vbMovementDescId
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

                END IF; -- IF vbAmount <> 0 THEN
                -- !!!!!!!!!!!!!!!!!!!!!!!
                -- !!!!! 3.2. -  End vbGoodsKindId AND NOT vbPartnerId!!!!!
                -- !!!!!!!!!!!!!!!!!!!!!!!




                -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                -- !!!!! 4.1. - Start NOT vbGoodsKindId AND NOT vbPartnerId!!!!!
                -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                IF vbAmount <> 0 THEN

                -- курсор2 - все продажи для ОДНОГО элемента возврата
                OPEN curMI_Sale_4 FOR
                   SELECT _tmpResult_Sale_Auto.MovementId, _tmpResult_Sale_Auto.MovementItemId, _tmpResult_Sale_Auto.Amount
                        , _tmpResult_Sale_Auto.GoodsKindId
                   FROM _tmpResult_Sale_Auto
                   WHERE _tmpResult_Sale_Auto.GoodsId        = vbGoodsId
                     AND _tmpResult_Sale_Auto.GoodsKindId    <> vbGoodsKindId -- !!!без этого параметра!!!
                     AND _tmpResult_Sale_Auto.Price_original = vbOperPrice
                     AND _tmpResult_Sale_Auto.PartnerId      <> vbPartnerId   -- !!!без этого параметра!!!
                     AND _tmpResult_Sale_Auto.MovementDescId = vbMovementDescId
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

                END IF; -- IF vbAmount <> 0 THEN
                -- !!!!!!!!!!!!!!!!!!!!!!!
                -- !!!!! 4.1. -  End NOT vbGoodsKindId AND NOT vbPartnerId!!!!!
                -- !!!!!!!!!!!!!!!!!!!!!!!


                -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                -- !!!!! 4.2. - Start NOT vbGoodsKindId AND NOT vbPartnerId!!!!!
                -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                IF vbAmount <> 0 THEN

                -- курсор2 - все продажи для ОДНОГО элемента возврата
                OPEN curMI_Sale_4 FOR
                   SELECT _tmpResult_Sale_Auto.MovementId, _tmpResult_Sale_Auto.MovementItemId, _tmpResult_Sale_Auto.Amount
                        , _tmpResult_Sale_Auto.GoodsKindId
                   FROM _tmpResult_Sale_Auto
                   WHERE _tmpResult_Sale_Auto.GoodsId        = vbGoodsId
                     AND _tmpResult_Sale_Auto.GoodsKindId    <> vbGoodsKindId -- !!!без этого параметра!!!
                     AND _tmpResult_Sale_Auto.Price_original = vbOperPrice
                     AND _tmpResult_Sale_Auto.PartnerId      <> vbPartnerId   -- !!!без этого параметра!!!
                     AND _tmpResult_Sale_Auto.MovementDescId <> vbMovementDescId
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

                END IF; -- IF vbAmount <> 0 THEN
                -- !!!!!!!!!!!!!!!!!!!!!!!
                -- !!!!! 4.2. -  End NOT vbGoodsKindId AND NOT vbPartnerId!!!!!
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
-- SELECT lpUpdate_Movement_ReturnIn_Auto_OLD (inMovementId:= Movement.Id, inStartDateSale:= Movement.OperDate - INTERVAL '2 MONTH', inEndDateSale:= Movement.OperDate, inUserId:= zfCalc_UserAdmin() :: Integer) || CHR (13), Movement.* FROM Movement WHERE Movement.Id = 2920295
