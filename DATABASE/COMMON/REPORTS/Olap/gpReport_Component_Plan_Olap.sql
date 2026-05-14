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
             )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- !!!Только просмотр Аудитор!!!
    PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

   --zc_Unit_RK()
    -- Результат
    RETURN QUERY
      WITH tmpGoods AS (SELECT tmp.GoodsId
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
                                                  AND (ObjectLink_Goods_InfoMoney.ChildObjectId = inInfoMoneyId OR inInfoMoneyId = 0)
                       )

           --две группы - ГП (1832) + Тушенка     (1979)
         , tmpGoods_gp AS (SELECT lfObject_Goods_byGoodsGroup.GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (1832) AS lfObject_Goods_byGoodsGroup
                          UNION
                           SELECT lfObject_Goods_byGoodsGroup.GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (1979) AS lfObject_Goods_byGoodsGroup
                          )

         -- выбираем документы ,  1.1.Продано Покуп с РК 1.2.Расход на филиалы с РК  Sale SendonPrice
         , tmpUnion_1 AS(WITH
                         tmpMov AS (SELECT Movement.*
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
                                       --огр. товаром ГП
                                       INNER JOIN tmpGoods_gp ON tmpGoods_gp.GoodsId = MovementItem.ObjectId
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

                        SELECT Movement.Id AS MovementId
                             , Movement.OperDate
                             , Movement.UnitId
                             , MovementItem.ObjectId AS GoodsId
                             , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                             , CASE WHEN Movement.DescId = zc_Movement_Sale() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END AS AmountPartner_Sale
                             , CASE WHEN Movement.DescId = zc_Movement_SendOnPrice() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END AS AmountPartner_Send
                             , COALESCE (MIFloat_AmountPartner.ValueData, 0) AmountPartner
                        FROM tmpMov AS Movement
                             INNER JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id
                             LEFT JOIN tmpMILO AS MILinkObject_GoodsKind
                                               ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                              AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                             LEFT JOIN tmpMIFloat AS MIFloat_AmountPartner
                                                  ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                 AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                       )

           --2) юнион это приходы от поставщика
         , tmpUnion_2 AS (WITH
                          tmpMov AS (SELECT Movement.*
                                     FROM Movement
                                     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                                       AND Movement.DescId = zc_Movement_Income()
                                       AND Movement.StatusId = zc_Enum_Status_Complete()
                                     )
                        , tmpMI AS (SELECT MovementItem.*
                                    FROM MovementItem
                                        --огр. Товар Расход + вид
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

                         SELECT Movement.Id AS MovementId
                              , Movement.OperDate
                              , MovementLinkObject_From.ObjectId AS PartnerInId    --поставщик
                              , MovementLinkObject_To.ObjectId   AS UnitId    --кому
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

           --3) юнион это все расходы для Назв Товар Расход + вид
           --   Movement_ProductionUnion (child) + Movement_Loss + Movement_Inventory + Movement_Sale
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
                         --товары Расход
                        , tmpMI AS (SELECT MovementItem.*
                                    FROM MovementItem
                                        --огр. Товар Расход + вид
                                        INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
                                    WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMov.Id FROM tmpMov)
                                      AND MovementItem.isErased   = FALSE
                                      --AND MovementItem.DescId     IN (zc_MI_Master(), zc_MI_Child())
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
                         --
                         --товары ГП ProductionUnion master + zc_GoodsKind_WorkProgress
                        , tmpMI_gp AS (SELECT MovementItem.*
                                       FROM MovementItem
                                           --огр. Товар ГП
                                           INNER JOIN tmpGoods_gp ON tmpGoods_gp.GoodsId = MovementItem.ObjectId
                                       WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMov.Id FROM tmpMov WHERE tmpMov.DescId = zc_Movement_ProductionUnion())
                                         AND MovementItem.isErased   = FALSE
                                         AND MovementItem.DescId IN (zc_MI_Master())
                                       )
                        , tmpMILO_gp AS (SELECT MovementItemLinkObject.*
                                         FROM MovementItemLinkObject
                                         WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_gp.Id FROM tmpMI_gp)
                                          AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                                          AND MovementItemLinkObject.ObjectId = zc_GoodsKind_WorkProgress()
                                         )


                         SELECT Movement.Id                                   AS MovementId
                              , Movement.OperDate
                              , MovementLinkObject_From.ObjectId              AS UnitId    --
                              , MovementItem.ObjectId                         AS GoodsId
                              , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                              , 0 AS GoodsId_gp
                              , 0 AS GoodsKindId_gp
                              , CASE WHEN Movement.DescId = zc_Movement_Sale() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END AS Amount_sale
                              , 0                                                                                                   ::TFloat AS Amount_produnion_master
                              , CASE WHEN Movement.DescId = zc_Movement_ProductionUnion() THEN COALESCE (MovementItem.Amount, 0) ELSE 0 END  AS Amount_produnion_ch
                              , CASE WHEN Movement.DescId = zc_Movement_Loss() THEN COALESCE (MovementItem.Amount, 0) ELSE 0 END             AS Amount_loss
                              , CASE WHEN Movement.DescId = zc_Movement_Inventory() THEN COALESCE (MovementItem.Amount, 0) ELSE 0 END        AS Amount_Inv
                         FROM tmpMov AS Movement
                              LEFT JOIN tmpMLO AS MovementLinkObject_From
                                               ON MovementLinkObject_From.MovementId = Movement.Id
                                              AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                              INNER JOIN tmpMI AS MovementItem
                                               ON MovementItem.MovementId = Movement.Id
                                              AND MovementItem.DescId = CASE WHEN Movement.DescId = zc_Movement_ProductionUnion() THEN zc_MI_Child() ELSE zc_MI_Master() END
                              LEFT JOIN tmpMILO AS MILinkObject_GoodsKind
                                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                               AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                              LEFT JOIN tmpMI_Float AS MIFloat_AmountPartner
                                                    ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                   AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                                   AND Movement.DescId = zc_Movement_Sale()
                       UNION
                         SELECT Movement.Id AS MovementId
                              , Movement.OperDate
                              , MovementLinkObject_From.ObjectId AS UnitId    --
                              , 0 AS GoodsId
                              , 0 AS GoodsKindId
                              , MovementItem.ObjectId                         AS GoodsId_gp
                              , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId_gp
                              , 0                        ::TFloat AS Amount_sale
                              , COALESCE (MovementItem.Amount, 0) AS Amount_produnion_master
                              , 0                        ::TFloat AS Amount_produnion_ch
                              , 0                        ::TFloat AS Amount_loss
                              , 0                        ::TFloat AS Amount_Inv
                         FROM tmpMov AS Movement
                              LEFT JOIN tmpMLO AS MovementLinkObject_From
                                               ON MovementLinkObject_From.MovementId = Movement.Id
                                              AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                              INNER JOIN tmpMI_gp AS MovementItem
                                                  ON MovementItem.MovementId = Movement.Id
                              INNER JOIN tmpMILO_gp AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                         WHERE Movement.DescId = zc_Movement_ProductionUnion()
                         )

         , tmpData AS (
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
                            , 0 ::TFloat             AS Amount_produnion_master  --приход ПФ-ГП
                            , 0 ::TFloat             AS Amount_produnion_ch      --2.1
                            , 0 ::TFloat             AS Amount_sale              --2.4
                            , 0 ::TFloat             AS Amount_loss              --2.2
                            , 0 ::TFloat             AS Amount_inv               --2.3
                            , 0 ::TFloat             AS Amount_fact              --2.ФАКТ ИТОГО Расход 2.1+2+3+4
                            , 0 ::TFloat             AS Amount_income            -- Кол-во приход
                            , 0 ::TFloat             AS Summ_income              -- Сумма приход
                       FROM tmpUnion_1 AS tmp
                      UNION
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
                            , 0 ::TFloat             AS Amount_produnion_master  --приход ПФ-ГП
                            , 0 ::TFloat             AS Amount_produnion_ch      --2.1
                            , 0 ::TFloat             AS Amount_sale              --2.4
                            , 0 ::TFloat             AS Amount_loss              --2.2
                            , 0 ::TFloat             AS Amount_inv               --2.3
                            , 0 ::TFloat             AS Amount_fact              --2.ФАКТ ИТОГО Расход 2.1+2+3+4
                            , tmp.Amount_income      AS Amount_income            -- Кол-во приход
                            , tmp.Summ_income        AS Summ_income              -- Сумма приход
                       FROM tmpUnion_2 AS tmp
                      UNION
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
                            , tmp.Amount_produnion_master             AS Amount_produnion_master  --приход ПФ-ГП
                            , tmp.Amount_produnion_ch                 AS Amount_produnion_ch      --2.1
                            , tmp.Amount_sale                         AS Amount_sale              --2.4
                            , tmp.Amount_loss                         AS Amount_loss              --2.2
                            , tmp.Amount_inv                          AS Amount_inv               --2.3
                            , (COALESCE (tmp.Amount_produnion_ch,0)
                             + COALESCE (tmp.Amount_loss,0)
                             + COALESCE (tmp.Amount_inv,0)
                             + COALESCE (tmp.Amount_sale,0)) ::TFloat AS Amount_fact              --2.ФАКТ ИТОГО Расход 2.1+2+3+4
                            , 0 ::TFloat                              AS Amount_income            -- Кол-во приход
                            , 0 ::TFloat                              AS Summ_income              -- Сумма приход
                       FROM tmpUnion_3 AS tmp
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
           , (tmpData.AmountSale_rk           * (CASE WHEN tmpGoodsParam_gp.MeasureId = zc_Measure_Sh() THEN 1 ELSE 0 END))                    ::TFloat AS AmountSale_rk_sh
           , (tmpData.AmountSale_rk           * (CASE WHEN tmpGoodsParam_gp.MeasureId = zc_Measure_Sh() THEN tmpGoodsParam_gp.Weight ELSE 1 END)) ::TFloat AS AmountSale_rk
             -- 1.2.Расход на филиалы с РК - ГП
           , (tmpData.AmountSendOnPrice_rk    * (CASE WHEN tmpGoodsParam_gp.MeasureId = zc_Measure_Sh() THEN 1 ELSE 0 END))                    ::TFloat AS AmountSendOnPrice_rk_sh
           , (tmpData.AmountSendOnPrice_rk    * (CASE WHEN tmpGoodsParam_gp.MeasureId = zc_Measure_Sh() THEN tmpGoodsParam_gp.Weight ELSE 1 END)) ::TFloat AS AmountSendOnPrice
             -- 1. Продано с РК 1.1 + 1.2 - ГП
           , (tmpData.Amount_rk               * (CASE WHEN tmpGoodsParam_gp.MeasureId = zc_Measure_Sh() THEN 1 ELSE 0 END))                    ::TFloat AS Amount_rk_sh
           , (tmpData.Amount_rk               * (CASE WHEN tmpGoodsParam_gp.MeasureId = zc_Measure_Sh() THEN tmpGoodsParam_gp.Weight ELSE 1 END)) ::TFloat AS Amount_rk

             -- Приход ПФ-ГП - факт - ГП
           , (tmpData.Amount_produnion_master * (CASE WHEN tmpGoodsParam_gp.MeasureId = zc_Measure_Sh() THEN 1 ELSE 0 END))                    ::TFloat AS Amount_produnion_in_sh
           , (tmpData.Amount_produnion_master * (CASE WHEN tmpGoodsParam_gp.MeasureId = zc_Measure_Sh() THEN tmpGoodsParam_gp.Weight ELSE 1 END)) ::TFloat AS Amount_produnion_in
             -- Приход ПФ-ГП - Расчет - ГП
           , 0 :: TFloat AS Amount_prod_in_calc_sh
           , 0 :: TFloat AS Amount_prod_in_calc

            -- Расчет расх на производство - Компоненты
           , 0 :: TFloat AS Amount_prod_out_calc

             -- 2.1 - Компоненты
           , tmpData.Amount_produnion_ch          ::TFloat AS Amount_prod_out
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
-- SELECT * FROM gpReport_Component_Plan_Olap (inStartDate:= '01.05.2026', inEndDate:= '01.05.2026', inGoodsGroupId:= 0/*1928*/, inInfoMoneyId:= 0, inSession:= zfCalc_UserAdmin())
