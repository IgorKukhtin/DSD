-- Function: lpUpdate_Movement_ReturnIn_Auto()

DROP FUNCTION IF EXISTS lpUpdate_Movement_ReturnIn_Auto (Integer, Integer);
DROP FUNCTION IF EXISTS lpUpdate_Movement_ReturnIn_Auto (TDateTime, TDateTime, Integer, Integer);
DROP FUNCTION IF EXISTS lpUpdate_Movement_ReturnIn_Auto (Integer, TDateTime, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Movement_ReturnIn_Auto(
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
   DECLARE vbMovementDescId      Integer;
   DECLARE vbMovementDescId_orig Integer;
   DECLARE vbMovementId_tax      Integer;

   DECLARE vbMovementItemId_return Integer;
   DECLARE vbMovementId_sale       Integer;
   DECLARE vbMovementItemId_sale   Integer;

   DECLARE vbGoodsId     Integer;
   DECLARE vbGoodsKindId Integer;
   DECLARE vbAmount      TFloat;
   DECLARE vbAmount_sale TFloat;
   DECLARE vbOperPrice   TFloat;

   DECLARE vbStep Integer;

   DECLARE curMI_ReturnIn refcursor;
   DECLARE curMI_Sale refcursor;
   DECLARE curMI_Sale_two refcursor;
BEGIN
     -- инициализация, от этих параметров может зависеть скорость
     vbPeriod1:= '15 DAY'  :: INTERVAL;
     vbPeriod2:= '15 DAY'  :: INTERVAL;
     vbPeriod3:= '1 MONTH' :: INTERVAL;
     --
     vbStep:= 1;

     -- !!!проверка!!!
     IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_PriceCorrective())
        AND EXISTS (SELECT 1
                    FROM MovementItem AS MI
                         LEFT JOIN MovementItemFloat AS MIF_PriceTax_calc ON MIF_PriceTax_calc.MovementItemId = MI.Id AND MIF_PriceTax_calc.DescId = zc_MIFloat_PriceTax_calc()
                    WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE
                      AND COALESCE (MIF_PriceTax_calc.ValueData, 0) = 0
                   )
     THEN
         RAISE EXCEPTION 'Ошибка.Для товара <%> <%> не установлена <Цена продажи, которая корректируется>.'
                       , lfGet_Object_ValueData ((SELECT MI.ObjectId
                                                  FROM MovementItem AS MI
                                                       LEFT JOIN MovementItemFloat AS MIF_PriceTax_calc ON MIF_PriceTax_calc.MovementItemId = MI.Id AND MIF_PriceTax_calc.DescId = zc_MIFloat_PriceTax_calc()
                                                  WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE
                                                    AND COALESCE (MIF_PriceTax_calc.ValueData, 0) = 0
                                                  ORDER BY MI.Id
                                                  LIMIT 1
                                                ))
                       , lfGet_Object_ValueData_sh ((SELECT MILinkObject_GoodsKind.ObjectId
                                                     FROM MovementItem AS MI
                                                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind ON MILinkObject_GoodsKind.MovementItemId = MI.Id AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                                          LEFT JOIN MovementItemFloat AS MIF_PriceTax_calc ON MIF_PriceTax_calc.MovementItemId = MI.Id AND MIF_PriceTax_calc.DescId = zc_MIFloat_PriceTax_calc()
                                                     WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE
                                                       AND COALESCE (MIF_PriceTax_calc.ValueData, 0) = 0
                                                     ORDER BY MI.Id
                                                     LIMIT 1
                                                   ))
                        ;
     END IF;

     -- !!!замена!!!
     inStartDateSale:= (SELECT CASE WHEN Movement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_PriceCorrective()) THEN inStartDateSale ELSE DATE_TRUNC ('MONTH', Movement.OperDate) - INTERVAL '4 MONTH' END FROM Movement WHERE Movement.Id = inMovementId);


     -- таблица
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpItem'))
     THEN
         -- таблица - текущие возвраты***
         CREATE TEMP TABLE _tmpItem (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, OperCount TFloat, OperCount_Partner TFloat, Price_original TFloat, MovementId_sale Integer, isErased Boolean) ON COMMIT DROP;
     END IF;

         -- очистили
         DELETE FROM _tmpItem;
         -- текущие возвраты - сформировали один раз***
         INSERT INTO _tmpItem (MovementItemId, GoodsId, GoodsKindId, OperCount, OperCount_Partner, Price_original, MovementId_sale, isErased)
            SELECT MI.Id, MI.ObjectId AS GoodsId, COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                 , CASE WHEN Movement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_PriceCorrective()) THEN 0 ELSE MI.Amount END AS OperCount
                 , CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN MIF_AmountPartner.ValueData WHEN Movement.DescId = zc_Movement_PriceCorrective() THEN MI.Amount ELSE 0 END AS OperCount_Partner
                 , COALESCE (CASE WHEN Movement.DescId = zc_Movement_PriceCorrective() THEN MIF_PriceTax_calc.ValueData ELSE MIF_Price.ValueData END, 0) AS Price_original
                 , COALESCE (MIF_MovementId.ValueData, 0) AS MovementId_sale
                 , MI.isErased
            FROM MovementItem AS MI
                 LEFT JOIN Movement ON Movement.Id = MI.MovementId
                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind ON MILinkObject_GoodsKind.MovementItemId = MI.Id AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                 LEFT JOIN MovementItemFloat AS MIF_AmountPartner ON MIF_AmountPartner.MovementItemId = MI.Id AND MIF_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                 LEFT JOIN MovementItemFloat AS MIF_Price ON MIF_Price.MovementItemId = MI.Id AND MIF_Price.DescId = zc_MIFloat_Price()
                 LEFT JOIN MovementItemFloat AS MIF_PriceTax_calc ON MIF_PriceTax_calc.MovementItemId = MI.Id AND MIF_PriceTax_calc.DescId = zc_MIFloat_PriceTax_calc()
                 LEFT JOIN MovementItemFloat AS MIF_MovementId ON MIF_MovementId.MovementItemId = MI.Id AND MIF_MovementId.DescId = zc_MIFloat_MovementId()
            WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master()
              -- AND MI.isErased = FALSE
              -- AND (CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN 0 ELSE MI.Amount END <> 0
              --   OR CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN MIF_AmountPartner.ValueData ELSE 0 END <> 0
              --     )
            ;

     -- таблица
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpResult_ReturnIn_Auto'))
     THEN
         --
         -- DELETE FROM _tmpItem;
         --
         DELETE FROM _tmpResult_ReturnIn_Auto;
         --
         DELETE FROM _tmpPartner_ReturnIn_Auto;
     ELSE
         -- таблица - продаж (для поиска партий) + оптимизации
         CREATE TEMP TABLE _tmpResult_Sale_Auto (MovementDescId Integer, PartnerId Integer, OperDate TDateTime, MovementId Integer, MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, Amount TFloat, Price_original TFloat) ON COMMIT DROP;
         -- таблица - результат (нашли партии)***
         CREATE TEMP TABLE _tmpResult_ReturnIn_Auto (ParentId Integer, MovementId_sale Integer, MovementItemId_sale Integer, GoodsId Integer, GoodsKindId Integer, GoodsKindId_return Integer, Amount TFloat, Price_original TFloat) ON COMMIT DROP;
         -- таблица - список контрагентов (для оптимизации)***
         CREATE TEMP TABLE _tmpPartner_ReturnIn_Auto (PartnerId Integer) ON COMMIT DROP;
         -- таблица - список товаров (для оптимизации)
         CREATE TEMP TABLE _tmpGoods_ReturnIn_Auto_all (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, Price_original TFloat, Amount TFloat) ON COMMIT DROP;
         CREATE TEMP TABLE _tmpGoods_ReturnIn_Auto (GoodsId Integer) ON COMMIT DROP;

     END IF;



     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! Ну а теперь - ПОИСК ПАРТИЙ !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


     -- если - использовать "основание № (продажа)" для привязки к накладной "продажа"
     IF TRUE = (SELECT MovementBoolean.ValueData FROM MovementBoolean WHERE MovementBoolean.MovementId = inMovementId AND MovementBoolean.DescId = zc_MovementBoolean_List())
        AND EXISTS (SELECT 1 FROM _tmpItem WHERE _tmpItem.MovementId_sale <> 0 AND _tmpItem.isErased = FALSE)
     THEN
         -- параметры из документа
         vbMovementDescId:= (SELECT CASE WHEN Movement.DescId = zc_Movement_PriceCorrective() THEN zc_Movement_ReturnIn() ELSE Movement.DescId END FROM Movement WHERE Movement.Id = inMovementId);
         vbMovementDescId_orig:= (SELECT Movement.DescId FROM Movement WHERE Movement.Id = inMovementId);

         -- !!!будут чуть быстрее формироваться партии продажи!!!
         INSERT INTO _tmpResult_ReturnIn_Auto (ParentId, MovementId_sale, MovementItemId_sale, GoodsId, GoodsKindId, Amount, Price_original)
           WITH -- текущий возврат - нашли "ручную" привязку
                tmpMI_all AS (SELECT _tmpItem.MovementItemId
                                   , _tmpItem.GoodsId
                                   , CASE WHEN _tmpItem.GoodsKindId = 0 THEN zc_GoodsKind_Basis() ELSE _tmpItem.GoodsKindId END AS GoodsKindId
                                   , CASE WHEN vbMovementDescId IN (zc_Movement_ReturnIn(), zc_Movement_PriceCorrective()) THEN _tmpItem.OperCount_Partner ELSE _tmpItem.OperCount END AS Amount
                                   , _tmpItem.Price_original                               AS Price_original
                                   , _tmpItem.MovementId_sale
                              FROM _tmpItem
                              WHERE _tmpItem.isErased = FALSE
                                AND 0 <> CASE WHEN vbMovementDescId IN (zc_Movement_ReturnIn(), zc_Movement_PriceCorrective()) THEN _tmpItem.OperCount_Partner ELSE _tmpItem.OperCount END
                             )
                -- текущий возврат - группируется
              , tmpMI AS (SELECT MIN (tmpMI_all.MovementItemId) AS MovementItemId
                               , tmpMI_all.GoodsId
                               , tmpMI_all.GoodsKindId
                               , tmpMI_all.Price_original
                               , SUM (tmpMI_all.Amount) AS Amount_return
                               , tmpMI_all.MovementId_sale
                          FROM tmpMI_all
                          WHERE tmpMI_all.MovementId_sale > 0
                          GROUP BY tmpMI_all.GoodsId
                                 , tmpMI_all.GoodsKindId
                                 , tmpMI_all.Price_original
                                 , tmpMI_all.MovementId_sale
                         )
            -- продажа, установленная пользователем
          , tmpMI_sale_all AS (SELECT tmpMI.MovementItemId
                                    , tmpMI.MovementId_sale
                                    , tmpMI.GoodsId
                                    , tmpMI.GoodsKindId
                                    , tmpMI.Amount_return
                                    , tmpMI.Price_original
                                    , MIFloat_Price.ValueData    AS Price_find
                                    , MIN (MovementItem.Id)      AS MovementItemId_sale
                                    -- , SUM (MovementItem.Amount)  AS Amount_sale
                                    , SUM (MIFloat_AmountPartner.ValueData) AS Amount_sale
                               FROM tmpMI
                                    INNER JOIN MovementItem ON MovementItem.MovementId = tmpMI.MovementId_sale
                                                           AND MovementItem.isErased   = FALSE
                                                           AND MovementItem.DescId     = zc_MI_Master()
                                                           AND MovementItem.ObjectId   = tmpMI.GoodsId
                                    INNER JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                                 ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                                AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                                                                AND MIFloat_AmountPartner.ValueData    <> 0
                                    LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                               AND MIFloat_Price.DescId         = zc_MIFloat_Price()
                                                               -- AND MIFloat_Price.ValueData      = tmpMI.Price_original
                                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                     ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                    AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                               WHERE COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) = tmpMI.GoodsKindId
                               GROUP BY tmpMI.MovementItemId
                                      , tmpMI.MovementId_sale
                                      , tmpMI.GoodsId
                                      , tmpMI.GoodsKindId
                                      , tmpMI.Amount_return
                                      , tmpMI.Price_original
                                      , MIFloat_Price.ValueData
                              )
                -- так работает быстрее
              , tmpMI_sale AS (SELECT tmpMI_sale_all.* FROM tmpMI_sale_all WHERE  tmpMI_sale_all.Price_original = tmpMI_sale_all.Price_find)
                -- возврат от пок., который уже привязан к продаже
              , tmpMI_ReturnIn AS (SELECT tmpMI_sale.MovementId_sale
                                        , tmpMI_sale.GoodsId
                                        , tmpMI_sale.GoodsKindId
                                        , CASE WHEN Movement.DescId = zc_Movement_PriceCorrective() THEN MIFloat_PriceTax_calc.ValueData ELSE MIFloat_Price.ValueData END AS Price_find
                                        , SUM (MovementItem.Amount) AS Amount_return
                                   FROM tmpMI_sale
                                        -- !!!обязательно по документу!!!
                                        INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                                     ON MIFloat_MovementId.ValueData = tmpMI_sale.MovementId_sale
                                                                    AND MIFloat_MovementId.DescId    = zc_MIFloat_MovementId()
                                        INNER JOIN MovementItem ON MovementItem.Id       = MIFloat_MovementId.MovementItemId
                                                               AND MovementItem.ObjectId = tmpMI_sale.GoodsId
                                                               AND MovementItem.isErased = FALSE
                                                               AND MovementItem.DescId     = zc_MI_Child()
                                        INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                           AND Movement.DescId   IN (zc_Movement_ReturnIn(), zc_Movement_PriceCorrective(), zc_Movement_TransferDebtIn())
                                                           AND Movement.StatusId = zc_Enum_Status_Complete()
                                        LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                         ON MILinkObject_GoodsKind.MovementItemId = MovementItem.ParentId -- !!!из  "главного"!!!
                                                                        AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                        LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                    ON MIFloat_Price.MovementItemId = MovementItem.ParentId -- !!!из  "главного"!!!
                                                                   AND MIFloat_Price.DescId         = zc_MIFloat_Price()
                                                                   -- AND MIFloat_Price.ValueData      = tmpMI_sale.Price_original
                                        LEFT JOIN MovementItemFloat AS MIFloat_PriceTax_calc
                                                                    ON MIFloat_PriceTax_calc.MovementItemId = MovementItem.ParentId
                                                                   AND MIFloat_PriceTax_calc.DescId         = zc_MIFloat_PriceTax_calc()

                                   WHERE COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) = tmpMI_sale.GoodsKindId
                                   GROUP BY tmpMI_sale.MovementId_sale
                                          , tmpMI_sale.GoodsId
                                          , tmpMI_sale.GoodsKindId
                                          , CASE WHEN Movement.DescId = zc_Movement_PriceCorrective() THEN MIFloat_PriceTax_calc.ValueData ELSE MIFloat_Price.ValueData END
                                  )
                -- продажа МИНУС уже проведенный возврат от пок.
              , tmpResult AS (SELECT tmpMI_sale.MovementItemId
                                   , tmpMI_sale.MovementId_sale
                                   , tmpMI_sale.MovementItemId_sale
                                   , tmpMI_sale.GoodsId
                                   , tmpMI_sale.GoodsKindId
                                   , tmpMI_sale.Amount_return -- итого для текущего возврата
                                     -- что осталось в продаже
                                   , tmpMI_sale.Amount_sale - COALESCE (tmpMI_ReturnIn.Amount_return, 0) AS Amount
                              FROM tmpMI_sale
                                   LEFT JOIN tmpMI_ReturnIn ON tmpMI_ReturnIn.MovementId_sale = tmpMI_sale.MovementId_sale
                                                           AND tmpMI_ReturnIn.GoodsId         = tmpMI_sale.GoodsId
                                                           AND tmpMI_ReturnIn.GoodsKindId     = tmpMI_sale.GoodsKindId
                                                           AND tmpMI_ReturnIn.Price_find      = tmpMI_sale.Price_original
                             )
           -- сразу результат ... все эти CASE WHEN для повторяющихся товаров, т.е. только у ОДНОГО возврата сохраняется найденная продажа
           SELECT tmpMI_all.MovementItemId AS ParentId
                , CASE WHEN tmpResult.MovementItemId = tmpMI_all.MovementItemId THEN tmpMI_all.MovementId_sale     ELSE 0 END AS MovementId_sale
                , CASE WHEN tmpResult.MovementItemId = tmpMI_all.MovementItemId THEN tmpResult.MovementItemId_sale ELSE 0 END AS MovementItemId_sale
                , tmpMI_all.GoodsId
                , tmpMI_all.GoodsKindId
                  -- если в возврате <= чем осталось в продаже, тогда = ВОЗВРАТУ, иначе = что осталось в продаже
                , CASE WHEN tmpResult.MovementItemId = tmpMI_all.MovementItemId THEN CASE WHEN tmpResult.Amount_return < tmpResult.Amount THEN tmpResult.Amount_return ELSE tmpResult.Amount END ELSE 0 END AS Amount
                , tmpMI_all.Price_original
           FROM tmpMI_all
                LEFT JOIN tmpResult ON tmpResult.MovementId_sale = tmpMI_all.MovementId_sale
                                   AND tmpResult.GoodsId         = tmpMI_all.GoodsId
                                   AND tmpResult.GoodsKindId     = tmpMI_all.GoodsKindId
                                   AND (tmpResult.Amount          >= 0
                                     OR tmpResult.Amount_return   < 0)
          ;

     ELSE

         -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
         -- !!!будут медленно формироваться партии продажи!!!
         -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

         -- параметры из документа
         SELECT CASE WHEN inStartDateSale >= COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) - vbPeriod1 THEN inStartDateSale ELSE COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) - vbPeriod1 END AS StartDate
              , COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) - INTERVAL '1 DAY' AS EndDate
              , COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) - INTERVAL '1 DAY' AS inEndDateSale -- !!!замена!!!
               -- замена, что б сразу искало в продажах
              , CASE WHEN Movement.DescId = zc_Movement_PriceCorrective() THEN zc_Movement_ReturnIn() ELSE Movement.DescId END AS MovementDescId
              , Movement.DescId                                                                                                AS MovementDescId_orig

               --
              , CASE WHEN Movement.DescId = zc_Movement_PriceCorrective() THEN COALESCE (Movement.ParentId, 0) ELSE 0 END AS MovementId_tax
               --
              , CASE WHEN Movement.DescId = zc_Movement_ReturnIn()        THEN MovementLinkObject_From.ObjectId
                     WHEN Movement.DescId = zc_Movement_PriceCorrective() THEN MovementLinkObject_Partner.ObjectId
                     ELSE MovementLinkObject_PartnerFrom.ObjectId
                END AS PartnerId
               --
              , MovementLinkObject_PaidKind.ObjectId AS PaidKindId
               --
              , MovementLinkObject_Contract.ObjectId AS ContractId
                INTO vbStartDate, vbEndDate, inEndDateSale
                   , vbMovementDescId, vbMovementDescId_orig, vbMovementId_tax, vbPartnerId, vbPaidKindId, vbContractId
         FROM Movement
              LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                     ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                    AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
                                    AND Movement.DescId                         = zc_Movement_ReturnIn()
              LEFT JOIN MovementLinkObject AS MovementLinkObject_PartnerFrom
                                           ON MovementLinkObject_PartnerFrom.MovementId = Movement.Id
                                          AND MovementLinkObject_PartnerFrom.DescId = zc_MovementLinkObject_PartnerFrom()
              LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                           ON MovementLinkObject_Partner.MovementId = Movement.Id
                                          AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
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
         /*INSERT INTO _tmpPartner_ReturnIn_Auto (PartnerId)
            SELECT ObjectLink_Jur.ObjectId AS PartnerId
            FROM ObjectLink AS ObjectLink_Jur
            WHERE ObjectLink_Jur.ChildObjectId = (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.ObjectId = vbPartnerId AND ObjectLink.DescId = zc_ObjectLink_Partner_Juridical())
              AND ObjectLink_Jur.DescId        = zc_ObjectLink_Partner_Juridical();
         -- Оптимизация
         ANALYZE _tmpPartner_ReturnIn_Auto;*/

         -- !!!проверка!!!
         IF COALESCE (vbPartnerId, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Для привязки к продажам необходимо установить контрагента.';
         END IF;


         -- Цикл по периодам (так наверно быстрее)
         WHILE vbStartDate >= inStartDateSale AND vbStartDate <= vbEndDate LOOP

            -- очистили - список товаров (для оптимизации)
            DELETE FROM _tmpGoods_ReturnIn_Auto_all;
            DELETE FROM _tmpGoods_ReturnIn_Auto;
            -- список товаров - формируется каждый раз
            INSERT INTO _tmpGoods_ReturnIn_Auto_all (MovementItemId, GoodsId, GoodsKindId, Price_original, Amount)
               -- текущий возврат МИНУС сколько партий нашли (т.е. сколько осталось)
               SELECT tmp1.MovementItemId, tmp1.GoodsId, tmp1.GoodsKindId, tmp1.Price_original, tmp1.Amount - COALESCE (tmp2.Amount, 0) AS Amount
               FROM (SELECT MIN (tmp.MovementItemId) AS MovementItemId, tmp.GoodsId, tmp.GoodsKindId, tmp.Price_original
                          , SUM (CASE WHEN vbMovementDescId IN (zc_Movement_ReturnIn(), zc_Movement_PriceCorrective()) THEN tmp.OperCount_Partner ELSE tmp.OperCount END) AS Amount
                     FROM _tmpItem AS tmp
                     WHERE tmp.isErased = FALSE
                       AND 0 <> CASE WHEN vbMovementDescId IN (zc_Movement_ReturnIn(), zc_Movement_PriceCorrective()) THEN tmp.OperCount_Partner ELSE tmp.OperCount END
                     GROUP BY tmp.GoodsId, tmp.GoodsKindId, tmp.Price_original
                    ) AS tmp1
                    LEFT JOIN (SELECT tmp.GoodsId, tmp.GoodsKindId_return AS GoodsKindId, tmp.Price_original, SUM (tmp.Amount) AS Amount
                               FROM _tmpResult_ReturnIn_Auto AS tmp GROUP BY tmp.GoodsId, tmp.GoodsKindId_return, tmp.Price_original
                              ) AS tmp2 ON tmp2.GoodsId        = tmp1.GoodsId
                                       AND tmp2.GoodsKindId    = tmp1.GoodsKindId
                                       AND tmp2.Price_original = tmp1.Price_original
               WHERE tmp1.Amount < 0
                  OR tmp1.Amount - COALESCE (tmp2.Amount, 0) > 0
                    ;
            -- ... каждый раз
            INSERT INTO _tmpGoods_ReturnIn_Auto (GoodsId) SELECT DISTINCT tmp.GoodsId FROM _tmpGoods_ReturnIn_Auto_all AS tmp;
            -- Оптимизация
            ANALYZE _tmpGoods_ReturnIn_Auto_all; ANALYZE _tmpGoods_ReturnIn_Auto;


            -- очистили - продажи (для поиска партий) + оптимизации
            DELETE FROM _tmpResult_Sale_Auto;

            -- продажи (потом среди этих продаж будем подбирать партии) - формируется каждый раз
            INSERT INTO _tmpResult_Sale_Auto (MovementDescId, PartnerId, OperDate, MovementId, MovementItemId, GoodsId, GoodsKindId, Amount, Price_original)

               WITH -- текущий возврат МИНУС сколько партий нашли (т.е. сколько осталось)
                    tmpMI_ReturnIn AS (SELECT * FROM _tmpGoods_ReturnIn_Auto_all)
                    -- продажа - почти вся
                  , tmpMI_sale_all AS (SELECT zc_Movement_ReturnIn()                         AS MovementDescId
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
                                                                         -- !!!т.к. для НАЛ - без проверки!!!
                                                                         -- AND MovementLinkObject_To.ObjectId = vbPartnerId
                                            -- INNER JOIN _tmpPartner_ReturnIn_Auto AS tmpPartner_list ON tmpPartner_list.PartnerId = MovementLinkObject_To.ObjectId
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
                                            LEFT JOIN MovementLinkMovement AS MLM_Master
                                                                           ON MLM_Master.MovementId = MD_OperDatePartner.MovementId
                                                                          AND MLM_Master.DescId     = zc_MovementLinkMovement_Master()

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
                                         AND (MLM_Master.MovementChildId = vbMovementId_tax OR vbMovementId_tax = 0)
                                      UNION ALL
                                       SELECT zc_Movement_TransferDebtIn()                   AS MovementDescId
                                            , MovementLinkObject_To.ObjectId                 AS PartnerId
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
                                                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_Partner()
                                                                         AND MovementLinkObject_To.ObjectId = vbPartnerId
                                            -- INNER JOIN _tmpPartner_ReturnIn_Auto AS tmpPartner_list ON tmpPartner_list.PartnerId = MovementLinkObject_To.ObjectId

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
                                            INNER JOIN (SELECT DISTINCT _tmp.GoodsId, _tmp.Price_original /*, _tmp.GoodsKindId*/ FROM _tmpGoods_ReturnIn_Auto_all AS _tmp
                                                       ) AS tmp ON tmp.GoodsId        = tmpMI_sale_all.GoodsId
                                                               -- !!!т.к. для НАЛ - без проверки!!!
                                                               -- AND tmp.GoodsKindId    = tmpMI_sale_all.GoodsKindId
                                                               AND tmp.Price_original = tmpMI_sale_all.Price_original
                                      )
                   -- находим для продаж - сколько уже привязано в возвратах
                 , tmpMI_ReturnIn_find AS (SELECT tmpMI_sale.MovementItemId
                                                , SUM (CASE WHEN Movement.DescId = zc_Movement_PriceCorrective() AND tmpMI_sale.Amount = MovementItem.Amount
                                                                 THEN MovementItem.Amount -- 0
                                                            ELSE MovementItem.Amount
                                                       END) AS Amount
                                           FROM tmpMI_sale
                                                INNER JOIN MovementItemFloat AS MIFloat_MovementItemId
                                                                             ON MIFloat_MovementItemId.ValueData = tmpMI_sale.MovementItemId
                                                                            AND MIFloat_MovementItemId.DescId    = zc_MIFloat_MovementItemId()
                                                INNER JOIN MovementItem ON MovementItem.Id          = MIFloat_MovementItemId.MovementItemId
                                                                       AND MovementItem.isErased    = FALSE
                                                                       AND MovementItem.DescId      = zc_MI_Child()
                                                                       AND MovementItem.MovementId <> inMovementId -- !!!что б не попал текущий возврат!!!
                                                INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                                   AND Movement.DescId   IN (zc_Movement_ReturnIn(), zc_Movement_PriceCorrective(), zc_Movement_TransferDebtIn())
                                                                   AND Movement.StatusId = zc_Enum_Status_Complete()
                                           GROUP BY tmpMI_sale.MovementItemId
                                          )
               -- результат - среди этих продаж будем подбирать партии
               SELECT tmpMI_sale.MovementDescId
                    , tmpMI_sale.PartnerId
                    , tmpMI_sale.OperDate
                    , tmpMI_sale.MovementId
                    , (tmpMI_sale.MovementItemId) AS MovementItemId -- !!! MIN ???
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
                      , tmpMI_sale.Price_original
               HAVING SUM (tmpMI_sale.Amount - COALESCE (tmpMI_ReturnIn_find.Amount, 0)) > 0*/
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
                -- !!!!! 2.1. - ALL PARAM !!!!!!!!
                -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

                -- курсор2.1. - все продажи для ОДНОГО элемента возврата
                OPEN curMI_Sale FOR
                   SELECT _tmpResult_Sale_Auto.MovementId, _tmpResult_Sale_Auto.MovementItemId, _tmpResult_Sale_Auto.Amount
                   FROM _tmpResult_Sale_Auto
                   WHERE _tmpResult_Sale_Auto.GoodsId        = vbGoodsId
                     AND (_tmpResult_Sale_Auto.GoodsKindId    = vbGoodsKindId OR (_tmpResult_Sale_Auto.GoodsKindId = 0 AND vbGoodsKindId = zc_GoodsKind_Basis()))
                     AND _tmpResult_Sale_Auto.Price_original = vbOperPrice
                     AND _tmpResult_Sale_Auto.PartnerId      = vbPartnerId
                     AND _tmpResult_Sale_Auto.MovementDescId = vbMovementDescId
                   ORDER BY _tmpResult_Sale_Auto.OperDate DESC, _tmpResult_Sale_Auto.Amount DESC
                  ;

                -- начало цикла по курсору2.1. - продажи
                LOOP
                    -- данные по продажам
                    FETCH curMI_Sale INTO vbMovementId_sale, vbMovementItemId_sale, vbAmount_sale;
                    -- если данные закончились, или все кол-во найдено тогда выход
                    IF NOT FOUND OR vbAmount = 0 THEN EXIT; END IF;

                    --
                    IF vbAmount_sale > vbAmount OR vbAmount < 0
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


                END LOOP; -- финиш цикла по курсору2.1. - продажи
                CLOSE curMI_Sale; -- закрыли курсор2.1. - продажи

                -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                -- !!!!! 2.1. - END ALL PARAM !!!!!!!!
                -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

                IF vbAmount <> 0 THEN
                -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                -- !!!!! 2.2. - ALL PARAM !!!!!!!!
                -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

                -- курсор2.2. - все продажи для ОДНОГО элемента возврата
                OPEN curMI_Sale_two FOR
                   SELECT _tmpResult_Sale_Auto.MovementId, _tmpResult_Sale_Auto.MovementItemId, _tmpResult_Sale_Auto.Amount
                   FROM _tmpResult_Sale_Auto
                   WHERE _tmpResult_Sale_Auto.GoodsId        = vbGoodsId
                     AND (_tmpResult_Sale_Auto.GoodsKindId    = vbGoodsKindId OR (_tmpResult_Sale_Auto.GoodsKindId = 0 AND vbGoodsKindId = zc_GoodsKind_Basis()))
                     AND _tmpResult_Sale_Auto.Price_original = vbOperPrice
                     AND _tmpResult_Sale_Auto.PartnerId      = vbPartnerId
                     AND _tmpResult_Sale_Auto.MovementDescId <> vbMovementDescId -- !!!с другим значением!!!
                   ORDER BY _tmpResult_Sale_Auto.OperDate DESC, _tmpResult_Sale_Auto.Amount DESC
                  ;

                -- начало цикла по курсору2.2. - продажи
                LOOP
                    -- данные по продажам
                    FETCH curMI_Sale_two INTO vbMovementId_sale, vbMovementItemId_sale, vbAmount_sale;
                    -- если данные закончились, или все кол-во найдено тогда выход
                    IF NOT FOUND OR vbAmount = 0 THEN EXIT; END IF;


                    --
                    IF vbAmount_sale > vbAmount OR vbAmount < 0
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


                END LOOP; -- финиш цикла по курсору2.2. - продажи
                CLOSE curMI_Sale_two; -- закрыли курсор2.2. - продажи

                END IF; -- IF vbAmount > 0 THEN
                -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                -- !!!!! 2.2. - End ALL PARAM !!!!!!!!
                -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


                -- для НАЛ - ТОЛЬКО
                IF vbAmount > 0 AND vbPaidKindId = zc_Enum_PaidKind_SecondForm() THEN
                -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                -- !!!!! 2.3. - NOT vbGoodsKindId!!
                -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

                -- курсор2.3. - все продажи для ОДНОГО элемента возврата
                OPEN curMI_Sale_two FOR
                   SELECT _tmpResult_Sale_Auto.MovementId, _tmpResult_Sale_Auto.MovementItemId, _tmpResult_Sale_Auto.Amount
                   FROM _tmpResult_Sale_Auto
                   WHERE _tmpResult_Sale_Auto.GoodsId        = vbGoodsId
                     AND _tmpResult_Sale_Auto.GoodsKindId    <> vbGoodsKindId -- !!!без этого параметра!!!
                     AND _tmpResult_Sale_Auto.GoodsKindId    <> 0
                     AND _tmpResult_Sale_Auto.Price_original = vbOperPrice
                     AND _tmpResult_Sale_Auto.PartnerId      = vbPartnerId
                   ORDER BY _tmpResult_Sale_Auto.OperDate DESC, _tmpResult_Sale_Auto.Amount DESC
                  ;

                -- начало цикла по курсору2.3. - продажи
                LOOP
                    -- данные по продажам
                    FETCH curMI_Sale_two INTO vbMovementId_sale, vbMovementItemId_sale, vbAmount_sale;
                    -- если данные закончились, или все кол-во найдено тогда выход
                    IF NOT FOUND OR vbAmount = 0 THEN EXIT; END IF;


                    --
                    IF vbAmount_sale > vbAmount OR vbAmount < 0
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


                END LOOP; -- финиш цикла по курсору2.3. - продажи
                CLOSE curMI_Sale_two; -- закрыли курсор2.3. - продажи

                END IF; -- IF vbAmount > 0 THEN
                -- !!!!!!!!!!!!!!!!!!!!!!!
                -- !!!!! 2.3. - End - NOT vbPartnerId!!!!!
                -- !!!!!!!!!!!!!!!!!!!!!!!


                -- для НАЛ - ТОЛЬКО OR zc_Movement_PriceCorrective
                IF vbAmount > 0 AND (vbPaidKindId = zc_Enum_PaidKind_SecondForm() OR vbMovementDescId_orig = zc_Movement_PriceCorrective()) THEN
                -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                -- !!!!! 2.4. - NOT vbPartnerId AND vbGoodsKindId!!
                -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

                -- курсор2.4. - все продажи для ОДНОГО элемента возврата
                OPEN curMI_Sale_two FOR
                   SELECT _tmpResult_Sale_Auto.MovementId, _tmpResult_Sale_Auto.MovementItemId, _tmpResult_Sale_Auto.Amount
                   FROM _tmpResult_Sale_Auto
                   WHERE _tmpResult_Sale_Auto.GoodsId        = vbGoodsId
                     -- AND _tmpResult_Sale_Auto.GoodsKindId    = vbGoodsKindId -- !!!без этого параметра!!!
                     AND _tmpResult_Sale_Auto.Price_original = vbOperPrice
                     AND _tmpResult_Sale_Auto.PartnerId      <> vbPartnerId -- !!!без этого параметра!!!
                   ORDER BY _tmpResult_Sale_Auto.OperDate DESC, _tmpResult_Sale_Auto.Amount DESC
                  ;

                -- начало цикла по курсору2.4. - продажи
                LOOP
                    -- данные по продажам
                    FETCH curMI_Sale_two INTO vbMovementId_sale, vbMovementItemId_sale, vbAmount_sale;
                    -- если данные закончились, или все кол-во найдено тогда выход
                    IF NOT FOUND OR vbAmount = 0 THEN EXIT; END IF;


                    --
                    IF vbAmount_sale > vbAmount OR vbAmount < 0
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


                END LOOP; -- финиш цикла по курсору2.4. - продажи
                CLOSE curMI_Sale_two; -- закрыли курсор2.4. - продажи

                END IF; -- IF vbAmount > 0 THEN
                -- !!!!!!!!!!!!!!!!!!!!!!!
                -- !!!!! 2.4. - End - NOT vbPartnerId!!!!!
                -- !!!!!!!!!!!!!!!!!!!!!!!


            END LOOP; -- финиш цикла по курсору1 - возвраты
            CLOSE curMI_ReturnIn; -- закрыли курсор1 - возвраты



            -- теперь следующий период
            vbStep:= vbStep + 1;
            vbEndDate:= vbStartDate - INTERVAL '1 DAY';
            vbStartDate:= (WITH tmp AS (SELECT CASE WHEN vbStep = 2 THEN vbStartDate - vbPeriod2 ELSE vbStartDate - vbPeriod3 END AS StartDate)
                           SELECT CASE WHEN inStartDateSale >= tmp.StartDate THEN inStartDateSale ELSE tmp.StartDate END FROM tmp);


         END LOOP; -- Цикл по периодам (так наверно быстрее)


     END IF; -- партии продажи - сформированы



     -- !!!синхронизируем zc_MI_Master и zc_MI_Child!!!
     UPDATE MovementItem SET ObjectId = _tmpItem.GoodsId
                           , isErased = CASE WHEN _tmpItem.OperCount = 0 AND _tmpItem.OperCount_Partner = 0 THEN TRUE ELSE _tmpItem.isErased END
     FROM _tmpItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Child()
       AND MovementItem.ParentId   = _tmpItem.MovementItemId
       AND (MovementItem.ObjectId  <> _tmpItem.GoodsId
         OR MovementItem.isErased  <> CASE WHEN _tmpItem.OperCount = 0 AND _tmpItem.OperCount_Partner = 0 THEN TRUE ELSE _tmpItem.isErased END
           )
      ;

     -- !!!сохранение!!!
     PERFORM lpInsertUpdate_MovementItem_ReturnIn_Child (ioId                  := tmp.MovementItemId
                                                       , inMovementId          := inMovementId
                                                       , inParentId            := tmp.ParentId
                                                       , inGoodsId             := tmp.GoodsId
                                                       , inAmount              := CASE WHEN tmp.MovementId_sale > 0 AND tmp.MovementItemId_sale > 0 THEN COALESCE (tmp.Amount, 0) ELSE 0 END
                                                       , inMovementId_sale     := COALESCE (tmp.MovementId_sale, 0)
                                                       , inMovementItemId_sale := COALESCE (tmp.MovementItemId_sale, 0)
                                                       , inUserId              := ABS (inUserId)
                                                       -- , inIsRightsAll         := FALSE
                                                       , inIsRightsAll         := CASE WHEN inUserId IN (zfCalc_UserAdmin() :: Integer, zc_Enum_Process_Auto_ReturnIn()) THEN TRUE ELSE FALSE END
                                                        )
     FROM (WITH MI_Master AS (SELECT _tmpItem.MovementItemId AS Id, _tmpItem.GoodsId
                              FROM _tmpItem
                              WHERE _tmpItem.isErased = FALSE
                                AND 0 <> CASE WHEN vbMovementDescId IN (zc_Movement_ReturnIn(), zc_Movement_PriceCorrective()) THEN _tmpItem.OperCount_Partner ELSE _tmpItem.OperCount END
                             )
               , MI_Child AS (SELECT MovementItem.Id, MovementItem.ParentId
                                   , CASE WHEN ROW_NUMBER() OVER (PARTITION BY MIFloat_MovementItemId.ValueData ORDER BY MovementItem.Id)  = 1
                                               THEN COALESCE (MIFloat_MovementItemId.ValueData, 0)
                                          ELSE 0
                                     END :: Integer AS MovementItemId_sale
                              FROM MovementItem
                                   LEFT JOIN MovementItemFloat AS MIFloat_MovementItemId
                                                               ON MIFloat_MovementItemId.MovementItemId = MovementItem.Id
                                                              AND MIFloat_MovementItemId.DescId         = zc_MIFloat_MovementItemId()
                              WHERE MovementItem.MovementId = inMovementId
                                AND MovementItem.DescId     = zc_MI_Child()
                                AND MovementItem.isErased   = FALSE
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

     -- Ошибка - № 120523 от 06.08.2016 код 41
     -- !!!в Мастере меняется скидка + ставится Акция!!!
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), _tmpItem.MovementItemId
                                             , CASE WHEN MovementDate_OperDatePartner.ValueData < '01.08.2016'
                                                         THEN COALESCE (MovementFloat_ChangePercent.ValueData, 0)
                                                    WHEN Movement.OperDate < zc_isReturnInNAL_bySale()
                                                     AND MLO_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm()
                                                         THEN COALESCE (MovementFloat_ChangePercent.ValueData, 0)
                                                    WHEN tmp.MovementItemId_sale > 0
                                                         THEN COALESCE (MIFloat_ChangePercent.ValueData, 0)
                                                    ELSE COALESCE (MovementFloat_ChangePercent.ValueData, 0)
                                               END)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_PromoMovementId(), _tmpItem.MovementItemId, COALESCE (tmp.MovementId_promo, 0))
     FROM _tmpItem
          LEFT JOIN  (SELECT MIFloat_PromoMovement.ValueData               AS MovementId_promo
                           , _tmpResult_ReturnIn_Auto.MovementItemId_sale  AS MovementItemId_sale
                           , _tmpResult_ReturnIn_Auto.GoodsId, _tmpResult_ReturnIn_Auto.GoodsKindId_return, _tmpResult_ReturnIn_Auto.Price_original
                           , ROW_NUMBER() OVER (PARTITION BY _tmpResult_ReturnIn_Auto.GoodsId, _tmpResult_ReturnIn_Auto.GoodsKindId_return, _tmpResult_ReturnIn_Auto.Price_original
                                                ORDER BY COALESCE (MIFloat_PromoMovement.ValueData, 0) DESC) AS Ord
                      FROM _tmpResult_ReturnIn_Auto
                           LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                                       ON MIFloat_PromoMovement.MovementItemId = _tmpResult_ReturnIn_Auto.MovementItemId_sale
                                                      AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                     ) AS tmp ON tmp.GoodsId            = _tmpItem.GoodsId
                             AND tmp.GoodsKindId_return = _tmpItem.GoodsKindId
                             AND tmp.Price_original     = _tmpItem.Price_original
                             AND tmp.Ord                = 1
          LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                      ON MIFloat_ChangePercent.MovementItemId = tmp.MovementItemId_sale
                                     AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
          LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                  ON MovementFloat_ChangePercent.MovementId = inMovementId
                                 AND MovementFloat_ChangePercent.DescId     = zc_MovementFloat_ChangePercent()
          LEFT JOIN Movement ON Movement.Id = inMovementId
          LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                 ON MovementDate_OperDatePartner.MovementId = inMovementId
                                AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
          LEFT JOIN MovementLinkObject AS MLO_PaidKind
                                       ON MLO_PaidKind.MovementId = inMovementId
                                      AND MLO_PaidKind.DescId     = zc_MovementLinkObject_PaidKind()
         ;
     -- !!!в Movement ставится Акция!!!
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Promo(), tmp.MovementId, CASE WHEN tmp_find.MovemenId_max > 0 THEN TRUE ELSE FALSE END)
           , lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Promo(), tmp.MovementId, CASE WHEN tmp_find.MovemenId_max = tmp_find.MovemenId_min THEN tmp_find.MovemenId_max ELSE NULL END :: Integer)
     FROM (SELECT inMovementId AS MovementId) AS tmp
          LEFT JOIN
          (SELECT MAX (MIFloat_PromoMovement.ValueData) AS MovemenId_max, MIN (MIFloat_PromoMovement.ValueData) AS MovemenId_min
           FROM _tmpItem
                INNER JOIN MovementItemFloat AS MIFloat_PromoMovement
                                             ON MIFloat_PromoMovement.MovementItemId = _tmpItem.MovementItemId
                                            AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                                            AND MIFloat_PromoMovement.ValueData > 0
           WHERE _tmpItem.isErased = FALSE
             AND 0 <> CASE WHEN vbMovementDescId IN (zc_Movement_ReturnIn(), zc_Movement_PriceCorrective()) THEN _tmpItem.OperCount_Partner ELSE _tmpItem.OperCount END
             AND _tmpItem.MovementId_sale <> 0
          ) AS tmp_find ON 1 = 1
          ;


     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovemenTFloat_TotalSumm (inMovementId);


     -- !!!вернули ОШИБКУ, если есть!!!
     outMessageText:= lpCheck_Movement_ReturnIn_Auto (inMovementId    := inMovementId
                                                    , inUserId        := -1 * inUserId
                                                     )
       || CHR (13) || 'за период с <' || DATE (inStartDateSale) :: TVarChar || '> по <' || DATE (inEndDateSale) :: TVarChar || '>'
       || CHR (13) || '(' || (vbStep - 1) :: TVarChar || ')'
       -- || CHR (13) || (SELECT COUNT(*) FROM _tmpResult_Sale_Auto) :: TVarChar
            -- || ' ' || (SELECT COUNT(*) FROM _tmpResult_ReturnIn_Auto) :: TVarChar
            -- || ' ' || DATE (vbStartDate) :: TVarChar
            -- || ' ' || DATE (vbEndDate) :: TVarChar
                     ;

if inUserId = 5 AND 1=1
then
    RAISE EXCEPTION 'Admin - Errr _end   % % % %', outMessageText
    , (SELECT MAX (_tmpResult_ReturnIn_Auto.Amount) :: TVarChar || ' _ ' || MIN (_tmpResult_ReturnIn_Auto.Amount) :: TVarChar FROM _tmpResult_ReturnIn_Auto)
    , (select Movement.InvNumber from _tmpResult_ReturnIn_Auto join Movement on Movement.Id = MovementId_sale LIMIT 1)
    , (select count(*) from _tmpResult_ReturnIn_Auto)
     ;
    -- 'Повторите действие через 3 мин.'
end if;

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
-- SELECT lpUpdate_Movement_ReturnIn_Auto (inMovementId:= Movement.Id, inStartDateSale:= Movement.OperDate - INTERVAL '15 DAY', inEndDateSale:= Movement.OperDate, inUserId:= zfCalc_UserAdmin() :: Integer) || CHR (13), Movement.* FROM Movement WHERE Movement.Id = 3662505
-- SELECT lpUpdate_Movement_ReturnIn_Auto (inMovementId:= Movement.Id, inStartDateSale:= Movement.OperDate - INTERVAL '4 MONTH', inEndDateSale:= Movement.OperDate, inUserId:= zfCalc_UserAdmin() :: Integer) || CHR (13), Movement.* FROM Movement WHERE Movement.Id = 3185773
