-- Function: gpReport_Component_Plan_Olap()

DROP FUNCTION IF EXISTS gpReport_Component_Plan_Olap (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Component_Plan_Olap (
    IN inStartDate          TDateTime ,
    IN inEndDate            TDateTime ,
    IN inGoodsGroupId       Integer   ,
    IN inInfoMoneyId        Integer   ,    -- уп статья (zc_ObjectLink_Goods_InfoMoney) - ограничиваем только Назв Товар Расход + вид
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS TABLE (MovementId  Integer
             , OperDate    TDateTime
             , MonthDate   TDateTime
             , Year        Integer
             , WeekNumber  Integer
             --
             , UnitId           Integer
             , UnitName         TVarChar
             , PartnerInId      Integer
             , PartnerInName    TVarChar

             --ТОвар ГП
             , GoodsId_gp          Integer
             , GoodsCode_gp        Integer
             , GoodsName_gp        TVarChar
             , GoodsKindId_gp      Integer
             , GoodsKindName_gp    TVarChar
             --Товар Расход
             , GoodsId             Integer
             , GoodsCode           Integer
             , GoodsName           TVarChar
             , GoodsKindId         Integer
             , GoodsKindName       TVarChar

             , AmountSale_rk_sh            TFloat  -- 1.1.Продано Покуп с РК - ГП
             , AmountSale_rk               TFloat
             , AmountSendOnPrice_rk_sh     TFloat  -- 1.2.Расход на филиалы с РК - ГП
             , AmountSendOnPrice_rk        TFloat
             , Amount_rk_sh                TFloat  -- 1. Продано с РК 1.1 + 1.2 - ГП
             , Amount_rk                   TFloat

             , Amount_prod_in_sh           TFloat  -- Приход ПФ-ГП - факт - ГП
             , Amount_prod_in              TFloat

             , Amount_prod_in_calc_sh TFloat  -- Приход ПФ-ГП - Расчет - ГП
             , Amount_prod_in_calc    TFloat

               -- Расчет расх на производство - Компоненты
             , Amount_prod_out_calc        TFloat

             , Amount_prod_out             TFloat  -- 2.1 - Компоненты
             , Amount_sale                 TFloat  -- 2.4 - Компоненты
             , Amount_loss                 TFloat  -- 2.2 - Компоненты
             , Amount_inv                  TFloat  -- 2.3 - Компоненты
             , Amount_fact                 TFloat  -- 2.ФАКТ ИТОГО Расход 2.1+2+3+4 - Компоненты

             , Amount_income               TFloat  -- Кол-во приход - Компоненты
             , Summ_income                 TFloat  -- Сумма приход - Компоненты

             -- Товар ГП
             , MeasureId_gp                Integer
             , MeasureName_gp              TVarChar
             , GoodsGroupId_gp             Integer
             , GoodsGroupName_gp           TVarChar
             , GoodsGroupNameFull_gp       TVarChar
             , TradeMarkId_gp              Integer
             , TradeMarkName_gp            TVarChar
             , InfoMoneyCode_gp            Integer
             , InfoMoneyGroupName_gp       TVarChar
             , InfoMoneyDestinationName_gp TVarChar
             , InfoMoneyName_gp            TVarChar
             , InfoMoneyName_all_gp        TVarChar
             , InfoMoneyId_gp              Integer
             --Товар расход
             , MeasureId                   Integer
             , MeasureName                 TVarChar
             , GoodsGroupId                Integer
             , GoodsGroupName              TVarChar
             , GoodsGroupNameFull          TVarChar
             , InfoMoneyCode               Integer
             , InfoMoneyGroupName          TVarChar
             , InfoMoneyDestinationName    TVarChar
             , InfoMoneyName               TVarChar
             , InfoMoneyName_all           TVarChar
             , InfoMoneyId                 Integer
             , ReceiptId_parent            Integer
             , ReceiptId_from              Integer
             )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- !!!Только просмотр Аудитор!!!
    PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


    -- две группы
    CREATE TEMP TABLE _tmpGoods_gp ON COMMIT DROP
       AS (-- ГП
           SELECT lfObject_Goods_byGoodsGroup.GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (1832) AS lfObject_Goods_byGoodsGroup
          UNION
           -- Тушенка
           SELECT lfObject_Goods_byGoodsGroup.GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (1979) AS lfObject_Goods_byGoodsGroup
          );

    -- ГП - с РК Sale + SendOnPrice
    CREATE TEMP TABLE _tmpMI_RK_sale (MovementId Integer, OperDate TDateTime, UnitId Integer, GoodsId Integer, GoodsKindId Integer, Amount_sale TFloat, Amount_send TFloat, ReceiptId Integer) ON COMMIT DROP;
    INSERT INTO _tmpMI_RK_sale (MovementId, OperDate, UnitId, GoodsId, GoodsKindId, Amount_sale, Amount_send, ReceiptId)
        WITH tmpMov AS (SELECT Movement.*
                             , MovementLinkObject_From.ObjectId AS UnitId
                        FROM Movement
                             INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                           ON MovementLinkObject_From.MovementId = Movement.Id
                                                          AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                          AND MovementLinkObject_From.ObjectId = zc_Unit_RK()
                        WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                          AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_SendOnPrice())
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                       )
           , tmpMI AS (SELECT MovementItem.*
                       FROM MovementItem
                           -- товары ГП
                           INNER JOIN _tmpGoods_gp ON _tmpGoods_gp.GoodsId = MovementItem.ObjectId
                       WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMov.Id FROM tmpMov)
                         AND MovementItem.isErased   = FALSE
                         AND MovementItem.DescId     = zc_MI_Master()
                      )
           , tmpMILO AS (SELECT MovementItemLinkObject.*
                         FROM MovementItemLinkObject
                         WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                          AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                        )
           , tmpMIFloat AS (SELECT MovementItemFloat.*
                            FROM MovementItemFloat
                            WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                             AND MovementItemFloat.DescId = zc_MIFloat_AmountPartner()
                           )
            -- Результат
            SELECT Movement.Id AS MovementId
                 , Movement.OperDate
                 , Movement.UnitId
                 , MovementItem.ObjectId AS GoodsId
                 , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                 , CASE WHEN Movement.DescId = zc_Movement_Sale()        THEN MovementItem.Amount /*COALESCE (MIFloat_AmountPartner.ValueData, 0)*/ ELSE 0 END AS Amount_sale
                 , CASE WHEN Movement.DescId = zc_Movement_SendOnPrice() THEN MovementItem.Amount /*COALESCE (MIFloat_AmountPartner.ValueData, 0)*/ ELSE 0 END AS Amount_Send
                   -- найдем потом
                 , 0 AS ReceiptId

            FROM tmpMov AS Movement
                 INNER JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id
                 LEFT JOIN tmpMILO AS MILinkObject_GoodsKind
                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                 LEFT JOIN tmpMIFloat AS MIFloat_AmountPartner
                                      ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                     AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                ;

     -- нашли Receipt
     UPDATE _tmpMI_RK_sale SET ReceiptId = tmpReceipt.ReceiptId
     FROM (WITH tmpMI_list AS(SELECT DISTINCT _tmpMI_RK_sale.GoodsId, _tmpMI_RK_sale.GoodsKindId FROM _tmpMI_RK_sale)
              , tmpReceipt AS (SELECT tmpMI_list.GoodsId, tmpMI_list.GoodsKindId, ObjectLink_Receipt_Goods.ObjectId AS ReceiptId
                               FROM tmpMI_list
                                    INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                          ON ObjectLink_Receipt_Goods.ChildObjectId = tmpMI_list.GoodsId
                                                         AND ObjectLink_Receipt_Goods.DescId        = zc_ObjectLink_Receipt_Goods()
                                    INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id       = ObjectLink_Receipt_Goods.ObjectId
                                                                       AND Object_Receipt.isErased = FALSE
                                    INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                             ON ObjectBoolean_Main.ObjectId  = Object_Receipt.Id
                                                            AND ObjectBoolean_Main.DescId    = zc_ObjectBoolean_Receipt_Main()
                                                            AND ObjectBoolean_Main.ValueData = TRUE
                                    LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                         ON ObjectLink_Receipt_GoodsKind.ObjectId = Object_Receipt.Id
                                                        AND ObjectLink_Receipt_GoodsKind.DescId   = zc_ObjectLink_Receipt_GoodsKind()
                               WHERE COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0) = tmpMI_list.GoodsKindId
                              )
             , tmpReceipt_oth AS (SELECT tmpMI_list.GoodsId, tmpMI_list.GoodsKindId, ObjectLink_Receipt_Goods.ObjectId AS ReceiptId
                                  FROM tmpMI_list
                                       INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                                             ON ObjectLink_Receipt_Goods.ChildObjectId = tmpMI_list.GoodsId
                                                            AND ObjectLink_Receipt_Goods.DescId        = zc_ObjectLink_Receipt_Goods()
                                       INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id       = ObjectLink_Receipt_Goods.ObjectId
                                                                          AND Object_Receipt.isErased = FALSE
                                       LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                            ON ObjectLink_Receipt_GoodsKind.ObjectId = Object_Receipt.Id
                                                           AND ObjectLink_Receipt_GoodsKind.DescId   = zc_ObjectLink_Receipt_GoodsKind()

                                       LEFT JOIN tmpReceipt ON tmpReceipt.GoodsId     = tmpMI_list.GoodsId
                                                           AND tmpReceipt.GoodsKindId = tmpMI_list.GoodsKindId

                                  WHERE COALESCE (ObjectLink_Receipt_GoodsKind.ChildObjectId, 0) = tmpMI_list.GoodsKindId
                                       -- если не нашли Receipt_Main = TRUE
                                       AND tmpReceipt.GoodsId IS NULL
                                 )
           -- Главные
           SELECT tmpReceipt.GoodsId, tmpReceipt.GoodsKindId, tmpReceipt.ReceiptId FROM tmpReceipt
          UNION ALL
           -- Если НЕ главная и только одна
           SELECT tmpReceipt.GoodsId, tmpReceipt.GoodsKindId, tmpReceipt.ReceiptId
           FROM tmpReceipt_oth AS tmpReceipt
           WHERE tmpReceipt.ReceiptId IN (SELECT tmpReceipt_oth.ReceiptId FROM tmpReceipt_oth GROUP BY tmpReceipt_oth.ReceiptId HAVING COUNT(*) = 1)
          ) AS tmpReceipt
     WHERE _tmpMI_RK_sale.GoodsId     = tmpReceipt.GoodsId
       AND _tmpMI_RK_sale.GoodsKindId = tmpReceipt.GoodsKindId
    ;

     -- ВСЕ рецептуры
     CREATE TEMP TABLE tmpChildReceiptTable (ReceiptId_parent Integer, ReceiptId_from Integer, ReceiptId Integer, GoodsId_in Integer, GoodsKindId_in Integer, Amount_in TFloat
                                           , ReceiptChildId integer, GoodsId_out Integer, GoodsKindId_out Integer, Amount_out TFloat, Amount_out_start TFloat, isStart Integer
                                            ) ON COMMIT DROP;
     -- ВСЕ рецептуры
     INSERT INTO tmpChildReceiptTable (ReceiptId_parent, ReceiptId_from, ReceiptId, GoodsId_in, GoodsKindId_in, Amount_in
                                     , ReceiptChildId, GoodsId_out, GoodsKindId_out, Amount_out, Amount_out_start, isStart
                                      )
          SELECT lpSelect.ReceiptId_parent, lpSelect.ReceiptId_from, lpSelect.ReceiptId, lpSelect.GoodsId_in, lpSelect.GoodsKindId_in, lpSelect.Amount_in
               , 0 AS ReceiptChildId, lpSelect.GoodsId_out, lpSelect.GoodsKindId_out
               , SUM (lpSelect.Amount_out) AS Amount_out
               , SUM (CASE WHEN lpSelect.isStart = TRUE THEN lpSelect.Amount_out ELSE 0 END) AS Amount_out_start
               , MAX (CASE WHEN lpSelect.isStart = TRUE THEN 1 ELSE 0 END) AS isStart
          FROM lpSelect_Object_ReceiptChildDetail (FALSE) AS lpSelect
          WHERE lpSelect.isCost = FALSE -- AND lpSelect.ReceiptId_from = 0
          GROUP BY lpSelect.ReceiptId_parent, lpSelect.ReceiptId_from, lpSelect.ReceiptId
                 , lpSelect.GoodsId_in, lpSelect.GoodsKindId_in, lpSelect.Amount_in
                 , lpSelect.GoodsId_out, lpSelect.GoodsKindId_out
                 -- , lpSelect.isStart
         ;

    -- Результат
    RETURN QUERY
      WITH -- Компоненты
           tmpGoods AS (SELECT tmp.GoodsId
                        FROM (SELECT lfObject_Goods_byGoodsGroup.GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup
                              WHERE inGoodsGroupId > 0
                             UNION
                              SELECT Object.Id
                              FROM Object
                              WHERE Object.DescId = zc_Object_Goods()
                                AND COALESCE (inGoodsGroupId, 0) = 0
                             ) AS tmp
                             INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                   ON ObjectLink_Goods_InfoMoney.ObjectId = tmp.GoodsId
                                                  AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                                  AND ((ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_10201() -- Специи
                                                                                                   , zc_Enum_InfoMoney_10202() -- Оболочка
                                                                                                   , zc_Enum_InfoMoney_10203() -- Упаковка
                                                                                                   , zc_Enum_InfoMoney_10204() -- Прочее сырье
                                                                                                    )
                                                    AND inInfoMoneyId = 0
                                                       )
                                                    OR ObjectLink_Goods_InfoMoney.ChildObjectId = inInfoMoneyId
                                                      )
                       )
           -- ГП
         , tmpUnion_1 AS (SELECT _tmpMI_RK_sale.MovementId
                               , _tmpMI_RK_sale.OperDate
                               , _tmpMI_RK_sale.UnitId
                               , _tmpMI_RK_sale.GoodsId
                               , _tmpMI_RK_sale.GoodsKindId
                               , _tmpMI_RK_sale.ReceiptId
                               , _tmpMI_RK_sale.Amount_sale                              AS AmountPartner_Sale
                               , _tmpMI_RK_sale.Amount_send                              AS AmountPartner_Send
                               , _tmpMI_RK_sale.Amount_sale + _tmpMI_RK_sale.Amount_send AS AmountPartner
                          FROM _tmpMI_RK_sale
                         )

           -- приходы от поставщика
         , tmpUnion_2 AS (WITH
                          tmpMov AS (SELECT Movement.*
                                     FROM Movement
                                     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                                       AND Movement.DescId = zc_Movement_Income()
                                       AND Movement.StatusId = zc_Enum_Status_Complete()
                                     )
                        , tmpMI AS (SELECT MovementItem.*
                                    FROM MovementItem
                                        -- Компоненты
                                        INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
                                    WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMov.Id FROM tmpMov)
                                      AND MovementItem.isErased   = FALSE
                                      AND MovementItem.DescId     = zc_MI_Master()
                                    )
                        , tmpMILO AS (SELECT MovementItemLinkObject.*
                                      FROM MovementItemLinkObject
                                      WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                       AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                                      )
                        , tmpMI_Float AS (SELECT MovementItemFloat.*
                                          FROM MovementItemFloat
                                          WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                           AND MovementItemFloat.DescId IN (zc_MIFloat_Price()
                                                                          , zc_MIFloat_CountForPrice()
                                                                           )
                                          )

                        , tmpMLO AS (SELECT MovementLinkObject.*
                                     FROM MovementLinkObject
                                     WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMov.Id FROM tmpMov)
                                      AND MovementLinkObject.DescId IN (zc_MovementLinkObject_From()
                                                                      , zc_MovementLinkObject_To()
                                                                      )
                                     )
                         -- Результат
                         SELECT Movement.Id AS MovementId
                              , Movement.OperDate
                              , MovementLinkObject_From.ObjectId AS PartnerInId --поставщик
                              , MovementLinkObject_To.ObjectId   AS UnitId      --кому
                              , MovementItem.ObjectId AS GoodsId
                              , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                              , MovementItem.Amount              AS Amount_income
                              , CAST ((MovementItem.Amount) * COALESCE (MIFloat_Price.ValueData, 0)
                                      / CASE WHEN MIFloat_CountForPrice.ValueData <> 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS NUMERIC (16, 2)
                                      ) :: TFloat AS Summ_income
                         FROM tmpMov AS Movement
                              LEFT JOIN tmpMLO AS MovementLinkObject_From
                                               ON MovementLinkObject_From.MovementId = Movement.Id
                                              AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                              LEFT JOIN tmpMLO AS MovementLinkObject_To
                                               ON MovementLinkObject_To.MovementId = Movement.Id
                                              AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                              INNER JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id
                              LEFT JOIN tmpMILO AS MILinkObject_GoodsKind
                                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                               AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                              LEFT JOIN tmpMI_Float AS MIFloat_Price
                                                    ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()

                              LEFT JOIN tmpMI_Float AS MIFloat_CountForPrice
                                                    ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                   AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                        )

           -- 3) Компоненты - Расходы
         , tmpUnion_3 AS (WITH
                          tmpMov AS (SELECT Movement.*
                                     FROM Movement
                                     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                                       AND Movement.StatusId = zc_Enum_Status_Complete()
                                       AND Movement.DescId IN (zc_Movement_ProductionUnion()
                                                             , zc_Movement_Loss()
                                                             , zc_Movement_Inventory()
                                                             , zc_Movement_Sale()
                                                              )
                                     )
                          -- товары Расход
                        , tmpMI AS (SELECT MovementItem.*
                                         , 0 AS GoodsId_gp
                                         , 0 AS GoodsKindId_gp
                                    FROM MovementItem
                                        -- Компоненты
                                        INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
                                    WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMov.Id FROM tmpMov WHERE tmpMov.DescId <> zc_Movement_ProductionUnion())
                                      AND MovementItem.isErased   = FALSE
                                      AND MovementItem.DescId     = zc_MI_Master()

                                   UNION ALL
                                    SELECT MovementItem.*
                                         , MI_Master.ObjectId                                   AS GoodsId_gp
                                         , COALESCE (MILinkObject_GoodsKind_master.ObjectId, 0) AS GoodsKindId_gp
                                    FROM MovementItem
                                        INNER JOIN MovementItem AS MI_Master
                                                                ON MI_Master.Id         = MovementItem.ParentId
                                                               AND MI_Master.DescId     = zc_MI_Master()
                                                               AND MI_Master.MovementId = MovementItem.MovementId
                                                               AND MI_Master.isErased   = FALSE
                                        -- Компоненты
                                        INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
                                        -- 
                                        LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind_master
                                                                         ON MILinkObject_GoodsKind_master.MovementItemId = MI_Master.Id
                                                                        AND MILinkObject_GoodsKind_master.DescId         = zc_MILinkObject_GoodsKind()

                                    WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMov.Id FROM tmpMov WHERE tmpMov.DescId = zc_Movement_ProductionUnion())
                                      AND MovementItem.isErased   = FALSE
                                      AND MovementItem.DescId     = zc_MI_Child()
                                   )

                        , tmpMILO AS (SELECT MovementItemLinkObject.*
                                      FROM MovementItemLinkObject
                                      WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                       AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                                      )
                        , tmpMLO AS (SELECT MovementLinkObject.*
                                     FROM MovementLinkObject
                                     WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMov.Id FROM tmpMov)
                                      AND MovementLinkObject.DescId = zc_MovementLinkObject_From()
                                    )
                        , tmpMI_Float AS (SELECT MovementItemFloat.*
                                          FROM MovementItemFloat
                                          WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                           AND MovementItemFloat.DescId IN (zc_MIFloat_AmountPartner())
                                         )
                         -- Результат
                         SELECT Movement.Id                                   AS MovementId
                              , Movement.OperDate                             AS OperDate
                              , MovementLinkObject_From.ObjectId              AS UnitId
                              , MovementItem.GoodsId_gp                       AS GoodsId_gp
                              , MovementItem.GoodsKindId_gp                   AS GoodsKindId_gp
                              , MovementItem.ObjectId                         AS GoodsId
                              , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                              , CASE WHEN Movement.DescId = zc_Movement_Sale()            THEN MovementItem.Amount /*COALESCE (MIFloat_AmountPartner.ValueData, 0)*/ ELSE 0 END AS Amount_sale
                              , CASE WHEN Movement.DescId = zc_Movement_ProductionUnion() THEN MovementItem.Amount ELSE 0 END  AS Amount_prod_out
                              , CASE WHEN Movement.DescId = zc_Movement_Loss()            THEN MovementItem.Amount ELSE 0 END  AS Amount_loss
                              , CASE WHEN Movement.DescId = zc_Movement_Inventory()       THEN MovementItem.Amount ELSE 0 END  AS Amount_Inv
                         FROM tmpMov AS Movement
                              LEFT JOIN tmpMLO AS MovementLinkObject_From
                                               ON MovementLinkObject_From.MovementId = Movement.Id
                                              AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                              INNER JOIN tmpMI AS MovementItem
                                               ON MovementItem.MovementId = Movement.Id
                              LEFT JOIN tmpMILO AS MILinkObject_GoodsKind
                                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                               AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                              LEFT JOIN tmpMI_Float AS MIFloat_AmountPartner
                                                    ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                   AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                                                   -- Только для продажи
                                                   AND Movement.DescId                      = zc_Movement_Sale()
                        )
           -- 4) Факт Приход ПФ-ГП
         , tmpUnion_4 AS (WITH
                          tmpMov AS (SELECT Movement.*
                                     FROM Movement
                                     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                                       AND Movement.StatusId = zc_Enum_Status_Complete()
                                       AND Movement.DescId   = zc_Movement_ProductionUnion()
                                    )
                             -- ProductionUnion master + zc_GoodsKind_WorkProgress
                           , tmpMI AS (SELECT MovementItem.*
                                            , MILO_GoodsKind.ObjectId AS GoodsKindId_gp
                                       FROM MovementItem
                                           -- товары ГП
                                           INNER JOIN _tmpGoods_gp ON _tmpGoods_gp.GoodsId = MovementItem.ObjectId
                                           --
                                           INNER JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                                             ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                                            AND MILO_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                                                            AND MILO_GoodsKind.ObjectId = zc_GoodsKind_WorkProgress()
                                       WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMov.Id FROM tmpMov WHERE tmpMov.DescId = zc_Movement_ProductionUnion())
                                         AND MovementItem.isErased   = FALSE
                                         AND MovementItem.DescId     = zc_MI_Master()
                                       )
                        , tmpMLO AS (SELECT MovementLinkObject.*
                                     FROM MovementLinkObject
                                     WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMI.MovementId FROM tmpMI)
                                      AND MovementLinkObject.DescId = zc_MovementLinkObject_To()
                                    )
                         -- Результат
                         SELECT Movement.Id                                   AS MovementId
                              , Movement.OperDate                             AS OperDate
                              , MovementLinkObject_To.ObjectId                AS UnitId
                              , MovementItem.ObjectId                         AS GoodsId_gp
                              , MovementItem.GoodsKindId_gp                   AS GoodsKindId_gp
                              , MovementItem.Amount                           AS Amount_prod_in
                         FROM tmpMov AS Movement
                              LEFT JOIN tmpMLO AS MovementLinkObject_To
                                               ON MovementLinkObject_To.MovementId = Movement.Id
                                              AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                              INNER JOIN tmpMI AS MovementItem
                                               ON MovementItem.MovementId = Movement.Id
                        )

         , tmpData AS (-- 1.ГП - продажа
                       SELECT tmp.MovementId
                            , tmp.OperDate
                            , tmp.UnitId
                            , 0                      AS PartnerInId                   --поставщик
                            , tmp.GoodsId            AS GoodsId_gp               --ТОвар Гп
                            , tmp.GoodsKindId        AS GoodsKindId_gp           --Вид товара ГП
                            , 0                      AS GoodsId                  --Товар расход
                            , 0                      AS GoodsKindId              --Вид товара расход
                            , tmp.AmountPartner_Sale AS AmountSale_rk            --1.1.Продано Покуп с РК
                            , tmp.AmountPartner_Send AS AmountSendOnPrice_rk     --1.2.Расход на филиалы с РК
                            , tmp.AmountPartner      AS Amount_rk                --Продано с РК 1.1 + 1.2
                            , 0 ::TFloat             AS Amount_prod_in           --приход ПФ-ГП
                            , 0 ::TFloat             AS Amount_prod_out          --2.1
                            , 0 ::TFloat             AS Amount_sale              --2.4
                            , 0 ::TFloat             AS Amount_loss              --2.2
                            , 0 ::TFloat             AS Amount_inv               --2.3
                            , 0 ::TFloat             AS Amount_fact              --2.ФАКТ ИТОГО Расход 2.1+2+3+4
                            , 0 ::TFloat             AS Amount_income            -- Кол-во приход
                            , 0 ::TFloat             AS Summ_income              -- Сумма приход
                            , 0 ::TFloat             AS Amount_prod_out_calc     -- Расчет расх на производство - Компоненты
                            , 0 ::TFloat             AS Amount_prod_in_calc  -- Приход ПФ-ГП - Расчет - ГП

                            , tmpChildReceiptTable.ReceiptId_parent AS ReceiptId_parent
                            , tmp.ReceiptId                         AS ReceiptId_from

                       FROM tmpUnion_1 AS tmp
                            LEFT JOIN (SELECT MAX (tmpChildReceiptTable.ReceiptId_parent) AS ReceiptId_parent
                                            , tmpChildReceiptTable.ReceiptId
                                       FROM tmpChildReceiptTable
                                       WHERE tmpChildReceiptTable.ReceiptId_from = 0
                                       GROUP BY tmpChildReceiptTable.ReceiptId
                                      ) AS tmpChildReceiptTable ON tmpChildReceiptTable.ReceiptId = tmp.ReceiptId

                      UNION ALL
                       -- 2.Компоненты - Приход от поставщика
                       SELECT tmp.MovementId
                            , tmp.OperDate
                            , tmp.UnitId
                            , tmp.PartnerInId                                         --поставщик
                            , 0                      AS GoodsId_gp
                            , 0                      AS GoodsKindId_gp
                            , tmp.GoodsId
                            , tmp.GoodsKindId
                            , 0 ::TFloat             AS AmountSale_rk            --1.1.Продано Покуп с РК
                            , 0 ::TFloat             AS AmountSendOnPrice_rk     --1.2.Расход на филиалы с РК
                            , 0 ::TFloat             AS Amount_rk                --Продано с РК 1.1 + 1.2
                            , 0 ::TFloat             AS Amount_prod_in           --приход ПФ-ГП
                            , 0 ::TFloat             AS Amount_prod_out          --2.1
                            , 0 ::TFloat             AS Amount_sale              --2.4
                            , 0 ::TFloat             AS Amount_loss              --2.2
                            , 0 ::TFloat             AS Amount_inv               --2.3
                            , 0 ::TFloat             AS Amount_fact              --2.ФАКТ ИТОГО Расход 2.1+2+3+4
                            , tmp.Amount_income      AS Amount_income            -- Кол-во приход
                            , tmp.Summ_income        AS Summ_income              -- Сумма приход
                            , 0 ::TFloat             AS Amount_prod_out_calc     -- Расчет расх на производство - Компоненты
                            , 0 ::TFloat             AS Amount_prod_in_calc  -- Приход ПФ-ГП - Расчет - ГП

                            , 0 AS ReceiptId_parent
                            , 0 AS ReceiptId_from

                       FROM tmpUnion_2 AS tmp

                      UNION ALL
                       -- 3.Компоненты - Расход факт + Приход ПФ-ГП
                       SELECT tmp.MovementId
                            , tmp.OperDate
                            , tmp.UnitId
                            , 0                                       AS PartnerInId                   --поставщик
                            , tmp.GoodsId_gp
                            , tmp.GoodsKindId_gp
                            , tmp.GoodsId
                            , tmp.GoodsKindId

                            , 0 ::TFloat                              AS AmountSale_rk            --1.1.Продано Покуп с РК
                            , 0 ::TFloat                              AS AmountSendOnPrice_rk     --1.2.Расход на филиалы с РК
                            , 0 ::TFloat                              AS Amount_rk                --Продано с РК 1.1 + 1.2
                            , 0 ::TFloat                              AS Amount_prod_in           --приход ПФ-ГП

                            , tmp.Amount_prod_out                     AS Amount_prod_out          --2.1
                            , tmp.Amount_sale                         AS Amount_sale              --2.4
                            , tmp.Amount_loss                         AS Amount_loss              --2.2
                            , tmp.Amount_inv                          AS Amount_inv               --2.3
                            , (COALESCE (tmp.Amount_prod_out,0)
                             + COALESCE (tmp.Amount_loss,0)
                             + COALESCE (tmp.Amount_inv,0)
                             + COALESCE (tmp.Amount_sale,0)) ::TFloat AS Amount_fact              --2.ФАКТ ИТОГО Расход 2.1+2+3+4

                            , 0 ::TFloat                              AS Amount_income            -- Кол-во приход
                            , 0 ::TFloat                              AS Summ_income              -- Сумма приход
                            , 0 ::TFloat                              AS Amount_prod_out_calc     -- Расчет расх на производство - Компоненты
                            , 0 ::TFloat                              AS Amount_prod_in_calc  -- Приход ПФ-ГП - Расчет - ГП

                            , 0 AS ReceiptId_parent
                            , 0 AS ReceiptId_from

                       FROM tmpUnion_3 AS tmp

                      UNION ALL
                       -- 4. Приход ПФ-ГП
                       SELECT tmp.MovementId
                            , tmp.OperDate
                            , tmp.UnitId
                            , 0                                       AS PartnerInId                   --поставщик
                            , tmp.GoodsId_gp
                            , tmp.GoodsKindId_gp
                            , 0 AS GoodsId
                            , 0 AS GoodsKindId

                            , 0 ::TFloat                              AS AmountSale_rk            --1.1.Продано Покуп с РК
                            , 0 ::TFloat                              AS AmountSendOnPrice_rk     --1.2.Расход на филиалы с РК
                            , 0 ::TFloat                              AS Amount_rk                --Продано с РК 1.1 + 1.2
                            , tmp.Amount_prod_in                      AS Amount_prod_in           --приход ПФ-ГП
                            , 0 ::TFloat                              AS Amount_prod_out          --2.1
                            , 0 ::TFloat                              AS Amount_sale              --2.4
                            , 0 ::TFloat                              AS Amount_loss              --2.2
                            , 0 ::TFloat                              AS Amount_inv               --2.3
                            , 0 ::TFloat                              AS Amount_fact              --2.ФАКТ ИТОГО Расход 2.1+2+3+4
                            , 0 ::TFloat                              AS Amount_income            -- Кол-во приход
                            , 0 ::TFloat                              AS Summ_income              -- Сумма приход
                            , 0 ::TFloat                              AS Amount_prod_out_calc     -- Расчет расх на производство - Компоненты
                            , 0 ::TFloat                              AS Amount_prod_in_calc  -- Приход ПФ-ГП - Расчет - ГП

                            , 0 AS ReceiptId_parent
                            , 0 AS ReceiptId_from

                       FROM tmpUnion_4 AS tmp

                      UNION ALL
                       -- 5. Расчет расх на производство - Компоненты
                       SELECT tmp.MovementId
                            , tmp.OperDate
                            , tmp.UnitId
                            , 0                                     AS PartnerInId              --поставщик
                            , tmp.GoodsId                           AS GoodsId_gp               --ТОвар Гп
                            , tmp.GoodsKindId                       AS GoodsKindId_gp           --Вид товара ГП
                            , tmpChildReceiptTable.GoodsId_out      AS GoodsId                  --Товар расход
                            , tmpChildReceiptTable.GoodsKindId_out  AS GoodsKindId              --Вид товара расход
                            , 0 ::TFloat                            AS AmountSale_rk            --1.1.Продано Покуп с РК
                            , 0 ::TFloat                            AS AmountSendOnPrice_rk     --1.2.Расход на филиалы с РК
                            , 0 ::TFloat                            AS Amount_rk                --Продано с РК 1.1 + 1.2
                            , 0 ::TFloat                            AS Amount_prod_in           --приход ПФ-ГП
                            , 0 ::TFloat                            AS Amount_prod_out          --2.1
                            , 0 ::TFloat                            AS Amount_sale              --2.4
                            , 0 ::TFloat                            AS Amount_loss              --2.2
                            , 0 ::TFloat                            AS Amount_inv               --2.3
                            , 0 ::TFloat                            AS Amount_fact              --2.ФАКТ ИТОГО Расход 2.1+2+3+4
                            , 0 ::TFloat                            AS Amount_income            -- Кол-во приход
                            , 0 ::TFloat                            AS Summ_income              -- Сумма приход

                              -- Расчет расх на производство - Компоненты
                            , CASE WHEN tmpChildReceiptTable.Amount_in > 0
                                        THEN tmp.AmountPartner * tmpChildReceiptTable.Amount_out / tmpChildReceiptTable.Amount_in
                                   ELSE 0
                              END AS Amount_prod_out_calc

                            , 0 ::TFloat                            AS Amount_prod_in_calc  -- Приход ПФ-ГП - Расчет - ГП

                            , tmpChildReceiptTable.ReceiptId_parent AS ReceiptId_parent
                            , tmp.ReceiptId                         AS ReceiptId_from

                       FROM tmpUnion_1 AS tmp
                            -- Разворот по компонентам
                            LEFT JOIN tmpChildReceiptTable ON tmpChildReceiptTable.ReceiptId = tmp.ReceiptId
                                                          AND tmpChildReceiptTable.ReceiptId_from = 0
                            -- Компоненты
                            INNER JOIN tmpGoods ON tmpGoods.GoodsId = tmpChildReceiptTable.GoodsId_out

                      UNION ALL
                       -- 6. Приход ПФ-ГП - Расчет - ГП
                       SELECT tmp.MovementId
                            , tmp.OperDate
                            , tmp.UnitId
                            , 0                                     AS PartnerInId              --поставщик
                            , tmp.GoodsId                           AS GoodsId_gp               --Товар ГП
                            , tmp.GoodsKindId                       AS GoodsKindId_gp           --Вид товара ГП
                              -- Товар расход
                            , CASE WHEN tmpChildReceiptTable_1.GoodsKindId_out = zc_GoodsKind_WorkProgress()
                                        THEN tmpChildReceiptTable_1.GoodsId_out
                                   WHEN tmpChildReceiptTable_2.GoodsKindId_out = zc_GoodsKind_WorkProgress()
                                        THEN tmpChildReceiptTable_2.GoodsId_out
                                   WHEN tmpChildReceiptTable_3.GoodsKindId_out = zc_GoodsKind_WorkProgress()
                                        THEN tmpChildReceiptTable_3.GoodsId_out
                                   WHEN tmpChildReceiptTable_4.GoodsKindId_out = zc_GoodsKind_WorkProgress()
                                        THEN tmpChildReceiptTable_4.GoodsId_out
                                   WHEN tmpChildReceiptTable_5.GoodsKindId_out = zc_GoodsKind_WorkProgress()
                                        THEN tmpChildReceiptTable_5.GoodsId_out
                              END AS GoodsId                  
                              -- Вид товара расход
                            , CASE WHEN tmpChildReceiptTable_1.GoodsKindId_out = zc_GoodsKind_WorkProgress()
                                        THEN tmpChildReceiptTable_1.GoodsKindId_out
                                   WHEN tmpChildReceiptTable_2.GoodsKindId_out = zc_GoodsKind_WorkProgress()
                                        THEN tmpChildReceiptTable_2.GoodsKindId_out
                                   WHEN tmpChildReceiptTable_3.GoodsKindId_out = zc_GoodsKind_WorkProgress()
                                        THEN tmpChildReceiptTable_3.GoodsKindId_out
                                   WHEN tmpChildReceiptTable_4.GoodsKindId_out = zc_GoodsKind_WorkProgress()
                                        THEN tmpChildReceiptTable_4.GoodsKindId_out
                                   WHEN tmpChildReceiptTable_5.GoodsKindId_out = zc_GoodsKind_WorkProgress()
                                        THEN tmpChildReceiptTable_5.GoodsKindId_out
                              END AS GoodsKindId

                            , 0 ::TFloat                            AS AmountSale_rk            --1.1.Продано Покуп с РК
                            , 0 ::TFloat                            AS AmountSendOnPrice_rk     --1.2.Расход на филиалы с РК
                            , 0 ::TFloat                            AS Amount_rk                --Продано с РК 1.1 + 1.2
                            , 0 ::TFloat                            AS Amount_prod_in           --приход ПФ-ГП
                            , 0 ::TFloat                            AS Amount_prod_out          --2.1
                            , 0 ::TFloat                            AS Amount_sale              --2.4
                            , 0 ::TFloat                            AS Amount_loss              --2.2
                            , 0 ::TFloat                            AS Amount_inv               --2.3
                            , 0 ::TFloat                            AS Amount_fact              --2.ФАКТ ИТОГО Расход 2.1+2+3+4
                            , 0 ::TFloat                            AS Amount_income            -- Кол-во приход
                            , 0 ::TFloat                            AS Summ_income              -- Сумма приход

                              
                            , 0 ::TFloat                            AS Amount_prod_out_calc -- Расчет расх на производство - Компоненты
                            , CASE WHEN tmpChildReceiptTable_1.GoodsKindId_out = zc_GoodsKind_WorkProgress()
                                        THEN tmp.AmountPartner * tmpChildReceiptTable_1.Amount_out / tmpChildReceiptTable_1.Amount_in

                                   WHEN tmpChildReceiptTable_2.GoodsKindId_out = zc_GoodsKind_WorkProgress()
                                        THEN tmp.AmountPartner * tmpChildReceiptTable_1.Amount_out
                                                               * tmpChildReceiptTable_2.Amount_out / tmpChildReceiptTable_2.Amount_in
                                           / tmpChildReceiptTable_1.Amount_in

                                   WHEN tmpChildReceiptTable_3.GoodsKindId_out = zc_GoodsKind_WorkProgress()
                                        THEN tmp.AmountPartner * tmpChildReceiptTable_1.Amount_out
                                                               * tmpChildReceiptTable_2.Amount_out / tmpChildReceiptTable_2.Amount_in
                                                               * tmpChildReceiptTable_3.Amount_out / tmpChildReceiptTable_3.Amount_in
                                           / tmpChildReceiptTable_1.Amount_in

                                   WHEN tmpChildReceiptTable_4.GoodsKindId_out = zc_GoodsKind_WorkProgress()
                                        THEN tmp.AmountPartner * tmpChildReceiptTable_1.Amount_out
                                                               * tmpChildReceiptTable_2.Amount_out / tmpChildReceiptTable_2.Amount_in
                                                               * tmpChildReceiptTable_3.Amount_out / tmpChildReceiptTable_3.Amount_in
                                                               * tmpChildReceiptTable_4.Amount_out / tmpChildReceiptTable_4.Amount_in
                                           / tmpChildReceiptTable_1.Amount_in

                                   WHEN tmpChildReceiptTable_5.GoodsKindId_out = zc_GoodsKind_WorkProgress()
                                        THEN tmp.AmountPartner * tmpChildReceiptTable_1.Amount_out
                                                               * tmpChildReceiptTable_2.Amount_out / tmpChildReceiptTable_2.Amount_in
                                                               * tmpChildReceiptTable_3.Amount_out / tmpChildReceiptTable_3.Amount_in
                                                               * tmpChildReceiptTable_4.Amount_out / tmpChildReceiptTable_4.Amount_in
                                                               * tmpChildReceiptTable_5.Amount_out / tmpChildReceiptTable_5.Amount_in
                                           / tmpChildReceiptTable_1.Amount_in

                                   ELSE -1

                              END ::TFloat                            AS Amount_prod_in_calc  -- Приход ПФ-ГП - Расчет - ГП

                            , tmpChildReceiptTable_1.ReceiptId_parent AS ReceiptId_parent
                            , tmp.ReceiptId                           AS ReceiptId_from

                       FROM tmpUnion_1 AS tmp
                            -- Разворот по компонентам
                            INNER JOIN tmpChildReceiptTable AS tmpChildReceiptTable_1
                                                            ON tmpChildReceiptTable_1.ReceiptId      = tmp.ReceiptId
                                                           AND tmpChildReceiptTable_1.ReceiptId_from > 0
                            -- идем дальше - Разворот по компонентам
                            LEFT JOIN tmpChildReceiptTable AS tmpChildReceiptTable_2
                                                           ON tmpChildReceiptTable_2.ReceiptId      = tmpChildReceiptTable_1.ReceiptId_from
                                                          AND tmpChildReceiptTable_2.ReceiptId_from > 0
                                                          AND tmpChildReceiptTable_1.GoodsKindId_out <> zc_GoodsKind_WorkProgress()
                            -- идем дальше - Разворот по компонентам
                            LEFT JOIN tmpChildReceiptTable AS tmpChildReceiptTable_3
                                                           ON tmpChildReceiptTable_3.ReceiptId      = tmpChildReceiptTable_2.ReceiptId_from
                                                          AND tmpChildReceiptTable_3.ReceiptId_from > 0
                                                          AND tmpChildReceiptTable_2.GoodsKindId_out <> zc_GoodsKind_WorkProgress()
                            -- идем дальше - Разворот по компонентам
                            LEFT JOIN tmpChildReceiptTable AS tmpChildReceiptTable_4
                                                           ON tmpChildReceiptTable_4.ReceiptId      = tmpChildReceiptTable_3.ReceiptId_from
                                                          AND tmpChildReceiptTable_4.ReceiptId_from > 0
                                                          AND tmpChildReceiptTable_3.GoodsKindId_out <> zc_GoodsKind_WorkProgress()
                            -- идем дальше - Разворот по компонентам
                            LEFT JOIN tmpChildReceiptTable AS tmpChildReceiptTable_5
                                                           ON tmpChildReceiptTable_5.ReceiptId      = tmpChildReceiptTable_4.ReceiptId_from
                                                          AND tmpChildReceiptTable_5.ReceiptId_from > 0
                                                          AND tmpChildReceiptTable_4.GoodsKindId_out <> zc_GoodsKind_WorkProgress()
                      )

         , tmpGoodsParam AS (SELECT tmpGoods.GoodsId
                                  , Object_GoodsGroup.Id                         AS GoodsGroupId
                                  , Object_GoodsGroup.ValueData                  AS GoodsGroupName
                                  , ObjectLink_Goods_Measure.ChildObjectId       AS MeasureId
                                  , Object_Measure.ValueData                     AS MeasureName
                                  , ObjectFloat_Weight.ValueData                 AS Weight
                                  , ObjectString_Goods_GoodsGroupFull.ValueData  AS GoodsGroupNameFull
                                  , Object_TradeMark.Id                          AS TradeMarkId
                                  , Object_TradeMark.ValueData                   AS TradeMarkName

                                  , Object_InfoMoney_View.InfoMoneyCode
                                  , Object_InfoMoney_View.InfoMoneyGroupName
                                  , Object_InfoMoney_View.InfoMoneyDestinationName
                                  , Object_InfoMoney_View.InfoMoneyName
                                  , Object_InfoMoney_View.InfoMoneyName_all
                                  , Object_InfoMoney_View.InfoMoneyId
                             FROM (SELECT DISTINCT tmpData.GoodsId FROM tmpData
                             UNION SELECT DISTINCT tmpData.GoodsId_gp FROM tmpData
                                   ) AS tmpGoods
                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                       ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpGoods.GoodsId
                                                      AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                                  LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                       ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                                      AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                  LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

                                  LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                        ON ObjectFloat_Weight.ObjectId = tmpGoods.GoodsId
                                                       AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

                                  LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                                         ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                                        AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                                       ON ObjectLink_Goods_TradeMark.ObjectId = tmpGoods.GoodsId
                                                      AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                                  LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                       ON ObjectLink_Goods_InfoMoney.ObjectId = tmpGoods.GoodsId
                                                      AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                  LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                            )
      -- Результат
      SELECT tmpData.MovementId                      :: Integer   AS MovementId
           , tmpData.OperDate                        :: TDateTime AS OperDate
           , DATE_TRUNC ('MONTH', tmpData.OperDate)  :: TDateTime AS MonthDate
           , EXTRACT (YEAR FROM tmpData.OperDate)    :: Integer AS Year
           , EXTRACT (WEEK FROM tmpData.OperDate)    :: Integer AS WeekNumber
           --
           , Object_Unit.Id             ::Integer  AS UnitId
           , Object_Unit.ValueData      ::TVarChar AS UnitName
           , Object_PartnerIn.Id        ::Integer  AS PartnerInId
           , Object_PartnerIn.ValueData ::TVarChar AS PartnerInName

           --ТОвар ГП
           , Object_Goods_gp.Id               AS GoodsId_gp
           , Object_Goods_gp.ObjectCode       AS GoodsCode_gp
           , Object_Goods_gp.ValueData        AS GoodsName_gp
           , Object_GoodsKind_gp.Id           AS GoodsKindId_gp
           , Object_GoodsKind_gp.ValueData    AS GoodsKindName_gp
           --Товар Расход
           , Object_Goods.Id                  AS GoodsId
           , Object_Goods.ObjectCode          AS GoodsCode
           , Object_Goods.ValueData           AS GoodsName
           , Object_GoodsKind.Id              AS GoodsKindId
           , Object_GoodsKind.ValueData       AS GoodsKindName

             -- 1.1.Продано Покуп с РК - ГП
           , (tmpData.AmountSale_rk           * (CASE WHEN tmpGoodsParam_gp.MeasureId = zc_Measure_Sh() THEN 1 ELSE 0 END))                       ::TFloat AS AmountSale_rk_sh
           , (tmpData.AmountSale_rk           * (CASE WHEN tmpGoodsParam_gp.MeasureId = zc_Measure_Sh() THEN tmpGoodsParam_gp.Weight ELSE 1 END)) ::TFloat AS AmountSale_rk
             -- 1.2.Расход на филиалы с РК - ГП
           , (tmpData.AmountSendOnPrice_rk    * (CASE WHEN tmpGoodsParam_gp.MeasureId = zc_Measure_Sh() THEN 1 ELSE 0 END))                       ::TFloat AS AmountSendOnPrice_rk_sh
           , (tmpData.AmountSendOnPrice_rk    * (CASE WHEN tmpGoodsParam_gp.MeasureId = zc_Measure_Sh() THEN tmpGoodsParam_gp.Weight ELSE 1 END)) ::TFloat AS AmountSendOnPrice
             -- 1. Продано с РК 1.1 + 1.2 - ГП
           , (tmpData.Amount_rk               * (CASE WHEN tmpGoodsParam_gp.MeasureId = zc_Measure_Sh() THEN 1 ELSE 0 END))                       ::TFloat AS Amount_rk_sh
           , (tmpData.Amount_rk               * (CASE WHEN tmpGoodsParam_gp.MeasureId = zc_Measure_Sh() THEN tmpGoodsParam_gp.Weight ELSE 1 END)) ::TFloat AS Amount_rk

             -- Приход ПФ-ГП - факт - ГП
           , (tmpData.Amount_prod_in * (CASE WHEN tmpGoodsParam_gp.MeasureId = zc_Measure_Sh() THEN 1 ELSE 0 END))                       ::TFloat AS Amount_prod_in_sh
           , (tmpData.Amount_prod_in * (CASE WHEN tmpGoodsParam_gp.MeasureId = zc_Measure_Sh() THEN tmpGoodsParam_gp.Weight ELSE 1 END)) ::TFloat AS Amount_prod_in
             -- Приход ПФ-ГП - Расчет - ГП

           , (tmpData.Amount_prod_in_calc * (CASE WHEN tmpGoodsParam.MeasureId = zc_Measure_Sh() THEN 1 ELSE 0 END))                       ::TFloat AS Amount_prod_in_calc_sh
           , (tmpData.Amount_prod_in_calc * (CASE WHEN tmpGoodsParam.MeasureId = zc_Measure_Sh() THEN tmpGoodsParam.Weight ELSE 1 END))    ::TFloat AS Amount_prod_in_calc

             -- Расчет расх на производство - Компоненты
           , tmpData.Amount_prod_out_calc :: TFloat AS Amount_prod_out_calc

             -- 2.1 - Компоненты
           , tmpData.Amount_prod_out              ::TFloat AS Amount_prod_out
             -- 2.4 - Компоненты
           , tmpData.Amount_sale                  ::TFloat AS Amount_sale
             -- 2.2 - Компоненты
           , tmpData.Amount_loss                  ::TFloat AS Amount_loss
             -- 2.3 - Компоненты
           , tmpData.Amount_inv                   ::TFloat AS Amount_inv
             --2. ФАКТ ИТОГО Расход 2.1+2+3+4 - Компоненты
           , tmpData.Amount_fact                  ::TFloat AS Amount_fact

             -- Кол-во приход - Компоненты
           , tmpData.Amount_income                ::TFloat AS Amount_income
             -- Сумма приход - Компоненты
           , tmpData.Summ_income                  ::TFloat AS Summ_income

             -- Товар ГП
           , tmpGoodsParam_gp.MeasureId                AS MeasureId_gp
           , tmpGoodsParam_gp.MeasureName              AS MeasureName_gp
           , tmpGoodsParam_gp.GoodsGroupId             AS GoodsGroupId_gp
           , tmpGoodsParam_gp.GoodsGroupName           AS GoodsGroupName_gp
           , tmpGoodsParam_gp.GoodsGroupNameFull       AS GoodsGroupNameFull_gp
           , tmpGoodsParam_gp.TradeMarkId              AS TradeMarkId_gp
           , tmpGoodsParam_gp.TradeMarkName            AS TradeMarkName_gp
           , tmpGoodsParam_gp.InfoMoneyCode            AS InfoMoneyCode_gp
           , tmpGoodsParam_gp.InfoMoneyGroupName       AS InfoMoneyGroupName_gp
           , tmpGoodsParam_gp.InfoMoneyDestinationName AS InfoMoneyDestinationName_gp
           , tmpGoodsParam_gp.InfoMoneyName            AS InfoMoneyName_gp
           , tmpGoodsParam_gp.InfoMoneyName_all        AS InfoMoneyName_all_gp
           , tmpGoodsParam_gp.InfoMoneyId              AS InfoMoneyId_gp
             -- Товар Компоненты
           , tmpGoodsParam.MeasureId
           , tmpGoodsParam.MeasureName
           , tmpGoodsParam.GoodsGroupId
           , tmpGoodsParam.GoodsGroupName
           , tmpGoodsParam.GoodsGroupNameFull
           , tmpGoodsParam.InfoMoneyCode
           , tmpGoodsParam.InfoMoneyGroupName
           , tmpGoodsParam.InfoMoneyDestinationName
           , tmpGoodsParam.InfoMoneyName
           , tmpGoodsParam.InfoMoneyName_all
           , tmpGoodsParam.InfoMoneyId

           , tmpData.ReceiptId_parent
           , tmpData.ReceiptId_from

        FROM tmpData

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpData.GoodsKindId
             LEFT JOIN Object AS Object_Goods_gp ON Object_Goods_gp.Id = tmpData.GoodsId_gp
             LEFT JOIN Object AS Object_GoodsKind_gp ON Object_GoodsKind_gp.Id = tmpData.GoodsKindId_gp

             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpData.UnitId
             LEFT JOIN Object AS Object_PartnerIn ON Object_PartnerIn.Id = tmpData.PartnerInId

             LEFT JOIN tmpGoodsParam ON tmpGoodsParam.GoodsId = tmpData.GoodsId
             LEFT JOIN tmpGoodsParam AS tmpGoodsParam_gp ON tmpGoodsParam_gp.GoodsId = tmpData.GoodsId_gp
  ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/* -------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.05.26         *
*/

-- тест
-- SELECT * FROM gpReport_Component_Plan_Olap (inStartDate:= '01.05.2026', inEndDate:= '01.05.2026', inGoodsGroupId:= 0, inInfoMoneyId:= zc_Enum_InfoMoney_10202(), inSession:= zfCalc_UserAdmin())
