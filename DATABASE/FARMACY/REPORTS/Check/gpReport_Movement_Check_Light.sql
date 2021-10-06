-- Function:  gpReport_Movement_Check_Light()

DROP FUNCTION IF EXISTS gpReport_Movement_Check_Light (Integer, Integer, TDateTime, TDateTime, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Movement_Check_Light (Integer, Integer, Integer, TDateTime, TDateTime, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Movement_Check_Light (Integer, Integer, Integer, TDateTime, TDateTime, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Movement_Check_Light(
    IN inUnitId           Integer  ,  -- Подразделение
    IN inRetailId         Integer  ,  -- ссылка на торг.сеть
    IN inJuridicalId      Integer  ,  -- юр.лицо
    IN inDateStart        TDateTime,  -- Дата начала
    IN inDateFinal        TDateTime,  -- Дата окончания
    IN inIsPartion        Boolean,    -- 
    IN inisPartionPrice   Boolean,    -- 
    IN inisJuridical      Boolean,    -- 
    IN inisUnitList       Boolean,    -- 
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (
               JuridicalCode  Integer,  
               JuridicalName  TVarChar,
               GoodsId        Integer, 
               GoodsCode      Integer, 
               BarCode        TVarChar,
               GoodsName      TVarChar,
               GoodsGroupName TVarChar, 
               NDSKindName    TVarChar,
               NDS            TFloat,
               ConditionsKeepName    TVarChar,
               Amount                TFloat,
               Price                 TFloat,
               PriceSale             TFloat,
               PriceWithVAT          Tfloat,      --Цена поставщика с учетом НДС (без % корр.)
               PriceWithOutVAT       Tfloat, 
               Summa                 TFloat,
               SummaSale             TFloat,
               SummaWithVAT          Tfloat,      --Сумма поставщика с учетом НДС (без % корр.)
               SummaWithOutVAT       Tfloat,
               SummChangePercent     Tfloat,      -- сумма скидки
               SummaMargin           TFloat,
               SummaMarginWithVAT    TFloat,
               PersentMargin         TFloat,      -- процент наценки
             
               PartionDescName       TVarChar,
               PartionInvNumber      TVarChar,
               PartionOperDate       TDateTime,
               PartionPriceDescName  TVarChar,
               PartionPriceInvNumber TVarChar,
               PartionPriceOperDate  TDateTime,
               UnitName              TVarChar,
               OurJuridicalName      TVarChar,
               PartionDateKindName   TVarChar,
               
               IsClose Boolean, UpdateDate TDateTime,
               isTop boolean, isFirst boolean , isSecond boolean,
               isSP Boolean, isPromo boolean,
               isResolution_224 boolean
               )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbDateStartPromo TDateTime;
   DECLARE vbDatEndPromo TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
    WITH
    tmpUnit AS (SELECT inUnitId AS UnitId
                WHERE COALESCE (inUnitId, 0) <> 0 
                  AND inisUnitList = FALSE
               UNION 
                SELECT ObjectLink_Unit_Juridical.ObjectId     AS UnitId
                FROM ObjectLink AS ObjectLink_Unit_Juridical
                     INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                           ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                          AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                          AND ((ObjectLink_Juridical_Retail.ChildObjectId = inRetailId AND inUnitId = 0)
                                               OR (inRetailId = 0 AND inUnitId = 0))
                WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                  AND (ObjectLink_Unit_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
                  AND inisUnitList = FALSE
               UNION
                SELECT ObjectBoolean_Report.ObjectId          AS UnitId
                FROM ObjectBoolean AS ObjectBoolean_Report
                WHERE ObjectBoolean_Report.DescId = zc_ObjectBoolean_Unit_Report()
                  AND ObjectBoolean_Report.ValueData = TRUE
                  AND inisUnitList = TRUE
             )
             
  , tmpContainer AS (SELECT COALESCE (MIContainer.AnalyzerId,0)         AS MovementItemId_Income
                          , MIContainer.MovementItemId                  AS MovementItemId
                          , MIContainer.ObjectId_analyzer               AS GoodsId
                          , SUM (COALESCE (-1 * MIContainer.Amount, 0)) AS Amount
                          , SUM (COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0)) AS SummaSale
                          , ROW_NUMBER() OVER (PARTITION BY MIContainer.MovementItemId) AS Ord
                     FROM MovementItemContainer AS MIContainer
                          INNER JOIN tmpUnit ON tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer
                          
                     WHERE MIContainer.DescId = zc_MIContainer_Count()
                       AND MIContainer.MovementDescId = zc_Movement_Check()
                       AND MIContainer.OperDate >= inDateStart AND MIContainer.OperDate < inDateFinal + INTERVAL '1 DAY'
                       --AND MIContainer.WhereObjectId_analyzer = inUnitId
                      -- AND MIContainer.OperDate >= '03.10.2016' AND MIContainer.OperDate < '01.12.2016'
                     GROUP BY COALESCE (MIContainer.AnalyzerId,0)
                            , MIContainer.ObjectId_analyzer
                            , MIContainer.MovementItemId
                     HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
                     )

  , tmpMIFloat_SummChangePercent AS (SELECT MovementItemFloat.*
                                     FROM MovementItemFloat
                                     WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpContainer.MovementItemId FROM tmpContainer) 
                                       AND MovementItemFloat.DescId = zc_MIFloat_SummChangePercent()
                                     )

  , tmpMILO_PartionDateKind AS (SELECT MovementItemLinkObject.*
                                FROM MovementItemLinkObject
                                WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpContainer.MovementItemId FROM tmpContainer) 
                                  AND MovementItemLinkObject.DescId = zc_MILinkObject_PartionDateKind()
                               )
                                     
  , tmpData_Container AS (SELECT tmpContainer.MovementItemId_Income
                               , tmpContainer.GoodsId
                               , MILinkObject_PartionDateKind.ObjectId AS PartionDateKindId
                               , SUM (tmpContainer.Amount)             AS Amount
                               , SUM (tmpContainer.SummaSale)          AS SummaSale
                               , SUM (COALESCE (MIFloat_SummChangePercent.ValueData, 0)) AS SummChangePercent
                          FROM tmpContainer
                               LEFT JOIN tmpMIFloat_SummChangePercent AS MIFloat_SummChangePercent
                                                                      ON MIFloat_SummChangePercent.MovementItemId = tmpContainer.MovementItemId
                                                                     AND tmpContainer.Ord = 1                                                     -- чтоб не задваивало скидку

                               LEFT JOIN tmpMILO_PartionDateKind AS MILinkObject_PartionDateKind
                                                                 ON MILinkObject_PartionDateKind.MovementItemId = tmpContainer.MovementItemId
                                                                AND MILinkObject_PartionDateKind.DescId         = zc_MILinkObject_PartionDateKind()
                               LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = MILinkObject_PartionDateKind.ObjectId
                          GROUP BY tmpContainer.MovementItemId_Income
                                 , tmpContainer.GoodsId
                                 , MILinkObject_PartionDateKind.ObjectId
                          )


  , tmpData_all AS (SELECT MI_Income.MovementId      AS MovementId_Income
                         , MI_Income_find.MovementId AS MovementId_find
                         , COALESCE (MI_Income_find.Id,         MI_Income.Id)         :: Integer AS MovementItemId
                         , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) :: Integer AS MovementId
                         , tmpData_Container.GoodsId
                         , tmpData_Container.PartionDateKindId
                         , SUM (COALESCE (tmpData_Container.Amount, 0))    AS Amount
                         , SUM (COALESCE (tmpData_Container.SummaSale, 0)) AS SummaSale
                         , SUM (COALESCE (tmpData_Container.SummChangePercent, 0)) AS SummChangePercent
                    FROM tmpData_Container
                          -- элемент прихода
                         LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = tmpData_Container.MovementItemId_Income

                         -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                         LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                     ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                    AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                         -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                         LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)

                   GROUP BY COALESCE (MI_Income_find.Id,         MI_Income.Id)
                          , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) 
                          , MI_Income.MovementId
                          , MI_Income_find.MovementId  
                          , tmpData_Container.GoodsId
                          , tmpData_Container.PartionDateKindId
                   )

           , tmpData AS (SELECT CASE WHEN inIsPartion = TRUE THEN tmpData_all.MovementId_Income ELSE 0 END AS MovementId_Income
                              , CASE WHEN inIsPartion = TRUE THEN tmpData_all.MovementId_find   ELSE 0 END AS MovementId_find
                              , CASE WHEN inisJuridical = TRUE OR inIsPartion = TRUE THEN MovementLinkObject_From_Income.ObjectId ELSE 0 END  AS JuridicalId_Income
                              , MovementLinkObject_NDSKind_Income.ObjectId                                 AS NDSKindId_Income
                              , tmpData_all.GoodsId
                              , tmpData_all.PartionDateKindId
                              , SUM (tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0))  AS Summa
                              , SUM (tmpData_all.Amount * COALESCE (MIFloat_PriceWithOutVAT.ValueData, 0)) AS SummaWithOutVAT
                              , SUM (tmpData_all.Amount * COALESCE (MIFloat_PriceWithVAT.ValueData, 0))    AS SummaWithVAT
                              , SUM (tmpData_all.Amount)            AS Amount
                              , SUM (tmpData_all.SummaSale)         AS SummaSale
                              , SUM (tmpData_all.SummChangePercent) AS SummChangePercent
                                -- таким образом выделим цены = 0 (что б не искажать среднюю с/с)
                              , CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0) = 0 THEN 0 ELSE 1 END AS isPrice
                              --
                              , CASE WHEN inisPartionPrice = TRUE THEN MovementLinkObject_Juridical_Income.ObjectId ELSE 0 END AS OurJuridicalId_Income
                              , CASE WHEN inisPartionPrice = TRUE THEN MovementLinkObject_To.ObjectId ELSE 0 END               AS ToId_Income
                         FROM tmpData_all
                              -- цена с учетом НДС, для элемента прихода от поставщика (или NULL)
                              LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice
                                                          ON MIFloat_JuridicalPrice.MovementItemId = tmpData_all.MovementItemId
                                                         AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()
                              -- цена с учетом НДС, для элемента прихода от поставщика без % корректировки  (или NULL)
                              LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                                          ON MIFloat_PriceWithVAT.MovementItemId = tmpData_all.MovementItemId
                                                         AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
                              -- цена без учета НДС, для элемента прихода от поставщика без % корректировки  (или NULL)
                              LEFT JOIN MovementItemFloat AS MIFloat_PriceWithOutVAT
                                                          ON MIFloat_PriceWithOutVAT.MovementItemId = tmpData_all.MovementItemId
                                                         AND MIFloat_PriceWithOutVAT.DescId = zc_MIFloat_PriceWithOutVAT()
                              -- Поставшик, для элемента прихода от поставщика (или NULL)
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_From_Income
                                                           ON MovementLinkObject_From_Income.MovementId = tmpData_all.MovementId
                                                          AND MovementLinkObject_From_Income.DescId     = zc_MovementLinkObject_From()
                              -- Вид НДС, для элемента прихода от поставщика (или NULL)
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind_Income
                                                           ON MovementLinkObject_NDSKind_Income.MovementId = tmpData_all.MovementId
                                                          AND MovementLinkObject_NDSKind_Income.DescId = zc_MovementLinkObject_NDSKind()
                              -- куда был приход от поставщика (склад или аптека)
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                           ON MovementLinkObject_To.MovementId = tmpData_all.MovementId
                                                          AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                              -- на какое наше юр лицо был приход
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical_Income
                                                           ON MovementLinkObject_Juridical_Income.MovementId = tmpData_all.MovementId
                                                          AND MovementLinkObject_Juridical_Income.DescId = zc_MovementLinkObject_Juridical()

                         GROUP BY CASE WHEN inIsPartion = TRUE THEN tmpData_all.MovementId_Income ELSE 0 END
                                , CASE WHEN inIsPartion = TRUE THEN tmpData_all.MovementId_find   ELSE 0 END
                                , CASE WHEN inisJuridical = TRUE OR inIsPartion = TRUE THEN MovementLinkObject_From_Income.ObjectId ELSE 0 END
                                , MovementLinkObject_NDSKind_Income.ObjectId
                                , tmpData_all.GoodsId
                                , CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0) = 0 THEN 0 ELSE 1 END
                                , CASE WHEN inisPartionPrice = TRUE THEN MovementLinkObject_Juridical_Income.ObjectId ELSE 0 END
                                , CASE WHEN inisPartionPrice = TRUE THEN MovementLinkObject_To.ObjectId ELSE 0 END
                                , tmpData_all.PartionDateKindId
                        )

   , tmpDataRez AS (SELECT tmpData.MovementId_Income
                         , tmpData.MovementId_find
                         , tmpData.JuridicalId_Income
                         , tmpData.NDSKindId_Income
                         , tmpData.GoodsId
                         , tmpData.PartionDateKindId
                         , SUM (tmpData.Summa)              AS Summa
                         , SUM (tmpData.SummaWithOutVAT)    AS SummaWithOutVAT
                         , SUM (tmpData.SummaWithVAT)       AS SummaWithVAT
                         , SUM (tmpData.Amount)             AS Amount
                         , SUM (tmpData.SummaSale)          AS SummaSale
                         , SUM (tmpData.SummChangePercent)  AS SummChangePercent
                         , tmpData.isPrice
                         , tmpData.OurJuridicalId_Income
                         , tmpData.ToId_Income
                    FROM tmpData
                    GROUP BY tmpData.MovementId_Income
                         , tmpData.MovementId_find
                         , tmpData.JuridicalId_Income
                         , tmpData.NDSKindId_Income
                         , tmpData.GoodsId
                         , tmpData.OurJuridicalId_Income
                         , tmpData.ToId_Income
                         , tmpData.isPrice
                         , tmpData.PartionDateKindId
                    )

        -- Маркетинговый контракт
      , GoodsPromo AS (SELECT DISTINCT ObjectLink_Child_retail.ChildObjectId AS GoodsId  -- здесь товар "сети"
                         --   , tmp.ChangePercent
                       FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= CURRENT_DATE) AS tmp   --CURRENT_DATE
                                    INNER JOIN ObjectLink AS ObjectLink_Child
                                                          ON ObjectLink_Child.ChildObjectId = tmp.GoodsId
                                                         AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                                    INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                             AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                                    INNER JOIN ObjectLink AS ObjectLink_Main_retail ON ObjectLink_Main_retail.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                                   AND ObjectLink_Main_retail.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                    INNER JOIN ObjectLink AS ObjectLink_Child_retail ON ObjectLink_Child_retail.ObjectId = ObjectLink_Main_retail.ObjectId
                                                                                    AND ObjectLink_Child_retail.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                    /*INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                          ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_retail.ChildObjectId
                                                         AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                         AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId*/
                         )
      -- Штрих-коды производителя
      , tmpGoodsBarCode AS (SELECT ObjectLink_Main_BarCode.ChildObjectId                                                  AS GoodsMainId
                                 , STRING_AGG (Object_Goods_BarCode.ValueData, ',' ORDER BY Object_Goods_BarCode.ID desc) AS BarCode
                                 --, Object_Goods_BarCode.ValueData        AS BarCode
                            FROM ObjectLink AS ObjectLink_Main_BarCode
                                 JOIN ObjectLink AS ObjectLink_Child_BarCode
                                                 ON ObjectLink_Child_BarCode.ObjectId = ObjectLink_Main_BarCode.ObjectId
                                                AND ObjectLink_Child_BarCode.DescId = zc_ObjectLink_LinkGoods_Goods()
                                 JOIN ObjectLink AS ObjectLink_Goods_Object_BarCode
                                                 ON ObjectLink_Goods_Object_BarCode.ObjectId = ObjectLink_Child_BarCode.ChildObjectId
                                                AND ObjectLink_Goods_Object_BarCode.DescId = zc_ObjectLink_Goods_Object()
                                                AND ObjectLink_Goods_Object_BarCode.ChildObjectId = zc_Enum_GlobalConst_BarCode()
                                 LEFT JOIN Object AS Object_Goods_BarCode ON Object_Goods_BarCode.Id = ObjectLink_Goods_Object_BarCode.ObjectId
                            WHERE ObjectLink_Main_BarCode.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                              AND ObjectLink_Main_BarCode.ChildObjectId > 0
                              AND TRIM (Object_Goods_BarCode.ValueData) <> ''
                            GROUP BY ObjectLink_Main_BarCode.ChildObjectId
                           )
       -- Товары соц-проект (документ)
      , tmpGoodsSP AS (SELECT DISTINCT tmp.GoodsId, TRUE AS isSP
                       FROM lpSelect_MovementItem_GoodsSPUnit_onDate (inStartDate:= inDateStart, inEndDate:= inDateFinal, inUnitId := inUnitId) AS tmp
                       )

        -- результат
        SELECT
            Object_From_Income.ObjectCode                                      AS JuridicalCode
           ,Object_From_Income.ValueData                                       AS JuridicalName

           , Object_Goods.Id                                                   AS GoodsId
           , Object_Goods.ObjectCode                                           AS GoodsCode
           , COALESCE (tmpGoodsBarCode.BarCode, '')        :: TVarChar         AS BarCode
           , Object_Goods.ValueData                                            AS GoodsName
           , Object_GoodsGroup.ValueData                                       AS GoodsGroupName
           , Object_NDSKind_Income.ValueData                                   AS NDSKindName
           , ObjectFloat_NDSKind_NDS.ValueData                                 AS NDS
           , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar          AS ConditionsKeepName           

           , tmpData.Amount          :: TFloat

                         , CASE WHEN tmpData.Amount <> 0 THEN tmpData.Summa           / tmpData.Amount ELSE 0 END :: TFloat AS Price
                         , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaSale       / tmpData.Amount ELSE 0 END :: TFloat AS PriceSale
                         , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaWithVAT    / tmpData.Amount ELSE 0 END :: TFloat AS PriceWithVAT
                         , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaWithOutVAT / tmpData.Amount ELSE 0 END :: TFloat AS PriceWithOutVAT

           , tmpData.Summa             :: TFloat AS Summa
           , tmpData.SummaSale         :: TFloat AS SummaSale
           , tmpData.SummaWithVAT      :: TFloat AS SummaWithVAT
           , tmpData.SummaWithOutVAT   :: TFloat AS SummaWithOutVAT
           , tmpData.SummChangePercent :: TFloat AS SummChangePercent

           , (tmpData.SummaSale - tmpData.Summa)        :: TFloat AS SummaMargin
           , (tmpData.SummaSale - tmpData.SummaWithVAT) :: TFloat AS SummaMarginWithVAT
           , CASE WHEN COALESCE (tmpData.SummaWithVAT, 0) <> 0 THEN (tmpData.SummaSale - tmpData.SummaWithVAT) * 100 / tmpData.SummaWithVAT ELSE 0 END  :: TFloat AS PersentMargin

           , MovementDesc_Income.ItemName AS PartionDescName
           , Movement_Income.InvNumber    AS PartionInvNumber
           , Movement_Income.OperDate     AS PartionOperDate
           , COALESCE (MovementDesc_Price.ItemName, MovementDesc_Income.ItemName) AS PartionPriceDescName
           , COALESCE (Movement_Price.InvNumber, Movement_Income.InvNumber)       AS PartionPriceInvNumber
           , COALESCE (Movement_Price.OperDate, Movement_Income.OperDate)         AS PartionPriceOperDate

           , Object_To_Income.ValueData              AS UnitName
           , Object_OurJuridical_Income.ValueData    AS OurJuridicalName
           , Object_PartionDateKind.ValueData :: TVarChar AS PartionDateKindName

           , COALESCE(ObjectBoolean_Goods_Close.ValueData, False)  :: Boolean AS isClose
           , COALESCE(ObjectDate_Update.ValueData, Null)          ::TDateTime AS UpdateDate   
           
           , COALESCE(ObjectBoolean_Goods_TOP.ValueData, false)    :: Boolean AS isTOP
           , COALESCE(ObjectBoolean_Goods_First.ValueData, False)  :: Boolean AS isFirst
           , COALESCE(ObjectBoolean_Goods_Second.ValueData, False) :: Boolean AS isSecond
           
           , COALESCE (tmpGoodsSP.isSP, False)                     :: Boolean AS isSP
           , CASE WHEN COALESCE(GoodsPromo.GoodsId,0) <> 0 THEN TRUE ELSE FALSE END AS isPromo
           , COALESCE(ObjectBoolean_Goods_Resolution_224.ValueData, False) :: Boolean AS isResolution_224
        FROM tmpDataRez AS tmpData
             LEFT JOIN Object AS Object_From_Income ON Object_From_Income.Id = tmpData.JuridicalId_Income
             LEFT JOIN Object AS Object_NDSKind_Income ON Object_NDSKind_Income.Id = tmpData.NDSKindId_Income

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId

             LEFT JOIN Object AS Object_To_Income ON Object_To_Income.Id = tmpData.ToId_Income
             LEFT JOIN Object AS Object_OurJuridical_Income ON Object_OurJuridical_Income.Id = tmpData.OurJuridicalId_Income

             LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = tmpData.PartionDateKindId

             LEFT JOIN Movement AS Movement_Income ON Movement_Income.Id = tmpData.MovementId_Income
             LEFT JOIN Movement AS Movement_Price ON Movement_Price.Id = tmpData.MovementId_find

             LEFT JOIN MovementDesc AS MovementDesc_Income ON MovementDesc_Income.Id = Movement_Income.DescId
             LEFT JOIN MovementDesc AS MovementDesc_Price ON MovementDesc_Price.Id = Movement_Price.DescId
             
             LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId = Object_Goods.Id
             -- условия хранения
             LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep 
                                  ON ObjectLink_Goods_ConditionsKeep.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
             LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId
 
             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                  ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
             LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
             
             LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Close
                                     ON ObjectBoolean_Goods_Close.ObjectId = Object_Goods.Id
                                    AND ObjectBoolean_Goods_Close.DescId = zc_ObjectBoolean_Goods_Close()  
             LEFT JOIN ObjectDate AS ObjectDate_Update
                                  ON ObjectDate_Update.ObjectId = Object_Goods.Id
                                 AND ObjectDate_Update.DescId = zc_ObjectDate_Protocol_Update()  

             LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                     ON ObjectBoolean_Goods_TOP.ObjectId = Object_Goods.Id
                                    AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()  
             LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_First
                                     ON ObjectBoolean_Goods_First.ObjectId = Object_Goods.Id
                                    AND ObjectBoolean_Goods_First.DescId = zc_ObjectBoolean_Goods_First() 
             LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Second
                                     ON ObjectBoolean_Goods_Second.ObjectId = Object_Goods.Id
                                    AND ObjectBoolean_Goods_Second.DescId = zc_ObjectBoolean_Goods_Second() 
             -- получается GoodsMainId
             LEFT JOIN  ObjectLink AS ObjectLink_Child ON ObjectLink_Child.ChildObjectId = Object_Goods.Id
                                                      AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
             LEFT JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                     AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

             LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = ObjectLink_Main.ChildObjectId
             /*LEFT JOIN  ObjectBoolean AS ObjectBoolean_Goods_SP 
                                      ON ObjectBoolean_Goods_SP.ObjectId = ObjectLink_Main.ChildObjectId 
                                     AND ObjectBoolean_Goods_SP.DescId = zc_ObjectBoolean_Goods_SP()*/

             LEFT JOIN tmpGoodsBarCode ON tmpGoodsBarCode.GoodsMainId = ObjectLink_Main.ChildObjectId
             
             LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                   ON ObjectFloat_NDSKind_NDS.ObjectId = tmpData.NDSKindId_Income
                                  AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS() 

             LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Resolution_224
                                     ON ObjectBoolean_Goods_Resolution_224.ObjectId = ObjectLink_Main.ChildObjectId
                                    AND ObjectBoolean_Goods_Resolution_224.DescId = zc_ObjectBoolean_Goods_Resolution_224() 
                                    
        ORDER BY Object_GoodsGroup.ValueData
               , Object_Goods.ValueData
;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 09.08.19         * SummChangePercent
 11.02.19         * признак Товары соц-проект берем и документа
 05.09.18         * add PersentMargin
 15.07.17         *
 12.07.17         *
*/

-- тест
-- SELECT * FROM gpReport_Movement_Check_Light(inUnitId := 183292 , inRetailId:=0 , inJuridicalId:= 0, inDateStart := ('01.02.2016')::TDateTime , inDateFinal := ('29.02.2016')::TDateTime , inIsPartion := 'False' , inisPartionPrice:='False', inisJuridical:='False', inisUnitList:='False', inSession := '3');