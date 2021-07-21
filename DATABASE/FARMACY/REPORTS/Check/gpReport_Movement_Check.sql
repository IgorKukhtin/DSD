-- Function:  gpReport_Movement_Check()

DROP FUNCTION IF EXISTS gpReport_Movement_Check (Integer, TDateTime, TDateTime, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Movement_Check (Integer, Integer, TDateTime, TDateTime, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Movement_Check(
    IN inUnitId           Integer  ,  -- Подразделение
    IN inRetailId         Integer  ,  -- ссылка на торг.сеть
    IN inDateStart        TDateTime,  -- Дата начала
    IN inDateFinal        TDateTime,  -- Дата окончания
    IN inIsPartion        Boolean,    -- 
    IN inisPartionPrice   Boolean,    -- 
    IN inisJuridical      Boolean,    -- 
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (
  JuridicalCode  Integer, 
  JuridicalName  TVarChar,

  GoodsId        Integer, 
  GoodsCode      Integer, 
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
  SummaSaleWithOut      TFloat,
  SummaWithVAT          Tfloat,      --Сумма поставщика с учетом НДС (без % корр.)
  SummaWithOutVAT       Tfloat,
  SummaMargin           TFloat,
  SummaMarginWithVAT    TFloat,

  AmountPromo           TFloat,
  AmountPromoPlanMax    TFloat,

  PersentPlan           TFloat,   -- Процент выполнения
  SummaBonus            TFloat,   -- сумма премии
  SummaPenalty          TFloat,   -- сумма штрафа
  SummaPay              TFloat,   -- Итог для точки - Премия минус Штраф равно разница 

  isPromoUnit           Boolean,
  isPromoPlanMax        Boolean,

  PartionDescName       TVarChar,
  PartionInvNumber      TVarChar,
  PartionOperDate       TDateTime,
  PartionPriceDescName  TVarChar,
  PartionPriceInvNumber TVarChar,
  PartionPriceOperDate  TDateTime,
  UnitName              TVarChar,
  OurJuridicalName      TVarChar,
  
  IsClose Boolean, UpdateDate TDateTime,
  MCSIsClose Boolean, MCSIsCloseDateChange TDateTime
  

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
    -- Контролшь использования подразделения
    PERFORM lpCheckingUser_Retail(inUnitId, inRetailId, inSession);

    vbDateStartPromo := date_trunc('month', inDateStart);
    vbDatEndPromo := date_trunc('month', inDateFinal) + interval '1 month'; 
    
    -- Результат
    RETURN QUERY
    WITH
   
    tmpUnit AS (SELECT inUnitId AS UnitId
                WHERE COALESCE (inUnitId, 0) <> 0
               UNION 
                SELECT ObjectLink_Unit_Juridical.ObjectId     AS UnitId
                FROM ObjectLink AS ObjectLink_Unit_Juridical
                     INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                           ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                          AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                          AND ((ObjectLink_Juridical_Retail.ChildObjectId = inRetailId AND inUnitId = 0)
                                               OR (inRetailId = 0 AND inUnitId = 0))
                WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
             )
             
  , tmpData_Container AS (SELECT COALESCE (MIContainer.AnalyzerId,0)         AS MovementItemId_Income
                               , MIContainer.WhereObjectId_analyzer          AS UnitId
                               , MIContainer.ObjectId_analyzer AS GoodsId
                               , SUM (COALESCE (-1 * MIContainer.Amount, 0)) AS Amount
                               , SUM (zfCalc_SummaCheck(COALESCE (MovementItem.Amount, 0) * COALESCE (MIContainer.Price,0)
                                                      , COALESCE (MB_RoundingDown.ValueData, False)
                                                      , COALESCE (MB_RoundingTo10.ValueData, False)
                                                      , COALESCE (MB_RoundingTo50.ValueData, False))) AS SummaSale
--                               , SUM (COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0)) AS SummaSale
                          FROM MovementItemContainer AS MIContainer
                               INNER JOIN tmpUnit ON tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer
                               LEFT JOIN MovementItem ON MovementItem.ID =  MIContainer.MovementItemID
                               LEFT JOIN MovementBoolean AS MB_RoundingTo10
                                                         ON MB_RoundingTo10.MovementId = MIContainer.MovementID
                                                        AND MB_RoundingTo10.DescId = zc_MovementBoolean_RoundingTo10()
                               LEFT JOIN MovementBoolean AS MB_RoundingDown
                                                         ON MB_RoundingDown.MovementId = MIContainer.MovementID
                                                        AND MB_RoundingDown.DescId = zc_MovementBoolean_RoundingDown()                               
                               LEFT JOIN MovementBoolean AS MB_RoundingTo50
                                                         ON MB_RoundingTo50.MovementId = MIContainer.MovementID
                                                        AND MB_RoundingTo50.DescId = zc_MovementBoolean_RoundingTo50()
                          WHERE MIContainer.DescId = zc_MIContainer_Count()
                            AND MIContainer.MovementDescId = zc_Movement_Check()
                            AND MIContainer.OperDate >= inDateStart AND MIContainer.OperDate < inDateFinal + INTERVAL '1 DAY'
                            --AND MIContainer.WhereObjectId_analyzer = inUnitId
                           -- AND MIContainer.OperDate >= '03.10.2016' AND MIContainer.OperDate < '01.12.2016'
                            AND COALESCE (MovementItem.Amount, 0) <> 0
                          GROUP BY COALESCE (MIContainer.AnalyzerId,0)
                                 , MIContainer.ObjectId_analyzer 
                                 , MIContainer.WhereObjectId_analyzer
                          HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
                          )
                          
  , tmpData_all AS (SELECT MI_Income.MovementId      AS MovementId_Income
                         , MI_Income_find.MovementId AS MovementId_find
                         , COALESCE (MI_Income_find.Id,         MI_Income.Id)         :: Integer AS MovementItemId
                         , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) :: Integer AS MovementId
                         , tmpData_Container.UnitId
                         , tmpData_Container.GoodsId
                         , SUM (COALESCE (tmpData_Container.Amount, 0))    AS Amount
                         , SUM (COALESCE (tmpData_Container.SummaSale, 0)) AS SummaSale
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
                          , tmpData_Container.UnitId
                         )

  , tmpData AS (SELECT CASE WHEN inIsPartion = TRUE THEN tmpData_all.MovementId_Income ELSE 0 END AS MovementId_Income
                     , CASE WHEN inIsPartion = TRUE THEN tmpData_all.MovementId_find   ELSE 0 END AS MovementId_find
                     , CASE WHEN inisJuridical = TRUE OR inIsPartion = TRUE THEN MovementLinkObject_From_Income.ObjectId ELSE 0 END  AS JuridicalId_Income
                     , MovementLinkObject_NDSKind_Income.ObjectId                                 AS NDSKindId_Income
                     , tmpData_all.UnitId
                     , tmpData_all.GoodsId
                     , SUM (tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0))  AS Summa
                     , SUM (tmpData_all.Amount * COALESCE (MIFloat_PriceWithOutVAT.ValueData, 0)) AS SummaWithOutVAT
                     , SUM (tmpData_all.Amount * COALESCE (MIFloat_PriceWithVAT.ValueData, 0))    AS SummaWithVAT
                     , SUM (tmpData_all.Amount)    AS Amount
                     , SUM (tmpData_all.SummaSale) AS SummaSale

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
                       , tmpData_all.UnitId
                       , tmpData_all.GoodsId
                       , CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0) = 0 THEN 0 ELSE 1 END
                       , CASE WHEN inisPartionPrice = TRUE THEN MovementLinkObject_Juridical_Income.ObjectId ELSE 0 END
                       , CASE WHEN inisPartionPrice = TRUE THEN MovementLinkObject_To.ObjectId ELSE 0 END    
               )

        -- считаем кол-во дней для расчета выполнения  плана по маркетингу
  , tmpDateList AS (SELECT generate_series(inDateStart, inDateFinal, '1 day'::interval) as OperDate)

  , tmpKoef AS (SELECT tmp.OperDate
                     , CAST (CountDays / date_part ('day', ((tmp.OperDate + interval '1 month') - tmp.OperDate)) AS NUMERIC (15,4)) AS Amount
                FROM
                    (SELECT date_trunc('month', tmpDateList.OperDate) AS OperDate
                          , count (date_trunc('month', tmpDateList.OperDate)) AS CountDays
                     FROM tmpDateList
                     GROUP BY date_trunc('month', tmpDateList.OperDate)
                    ) AS tmp
                )
   --  данные из "план по маркетингу для точек"
  , tmpMovPromoUnit AS (SELECT DATE_TRUNC ('month', Movement.OperDate) AS OperDate
                             , MovementLinkObject_Unit.ObjectId        AS UnitId
                             , MovementItem.ObjectId                   AS GoodsId
                             , SUM (MovementItem.Amount)               AS Amount
                             , SUM (MIFloat_AmountPlanMax.ValueData)   AS AmountPlanMax 
                        FROM Movement
                             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                    --AND MovementLinkObject_Unit.ObjectId = inUnitId
                                    
                             INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
                             
                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId = zc_MI_Master()
                                                    AND MovementItem.isErased = FALSE 
                             LEFT JOIN MovementItemFloat AS MIFloat_AmountPlanMax
                                                         ON MIFloat_AmountPlanMax.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountPlanMax.DescId = zc_MIFloat_AmountPlanMax()

                        WHERE Movement.DescId = zc_Movement_PromoUnit()
                          AND Movement.OperDate >= vbDateStartPromo AND Movement.OperDate < vbDatEndPromo
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                        GROUP BY DATE_TRUNC ('month', Movement.OperDate)
                               , MovementItem.ObjectId  
                               , MovementLinkObject_Unit.ObjectId  
                        )
  , tmpPromoUnit AS (SELECT tmpMovPromoUnit.GoodsId
                          , tmpMovPromoUnit.UnitId
                          , SUM (tmpMovPromoUnit.Amount * tmpKoef.Amount)        AS Amount
                          , SUM (tmpMovPromoUnit.AmountPlanMax * tmpKoef.Amount) AS AmountPlanMax 
                     FROM tmpMovPromoUnit
                          LEFT JOIN tmpKoef ON tmpKoef.OperDate = tmpMovPromoUnit.OperDate
                     GROUP BY tmpMovPromoUnit.GoodsId
                            , tmpMovPromoUnit.UnitId
                     )

  , tmpDataRez AS (SELECT tmpData.MovementId_Income
                        , tmpData.MovementId_find
                        , tmpData.JuridicalId_Income
                        , tmpData.NDSKindId_Income
                        , tmpData.UnitId
                        , tmpData.GoodsId
                        , tmpData.Summa
                        , tmpData.SummaWithOutVAT
                        , tmpData.SummaWithVAT
                        , tmpData.Amount
                        , tmpData.SummaSale
                        , tmpData.isPrice
                        , tmpData.OurJuridicalId_Income
                        , tmpData.ToId_Income
                        , CASE WHEN tmpData.Amount <> 0 THEN tmpData.Summa           / tmpData.Amount ELSE 0 END :: TFloat AS Price
                        , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaSale       / tmpData.Amount ELSE 0 END :: TFloat AS PriceSale
                        , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaWithVAT    / tmpData.Amount ELSE 0 END :: TFloat AS PriceWithVAT
                        , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaWithOutVAT / tmpData.Amount ELSE 0 END :: TFloat AS PriceWithOutVAT
                   FROM tmpData
                   )

  , tmpPrice AS ( SELECT tmp.UnitId
                       , tmp.GoodsId
                       , COALESCE (ObjectHistoryFloat_Price.ValueData, 0) AS Price
                  FROM (SELECT DISTINCT tmpPromoUnit.GoodsId, tmpPromoUnit.UnitId FROM tmpPromoUnit) AS tmp
                       LEFT JOIN Object_Price_View AS Object_Price
                                                   ON Object_Price.GoodsId = tmp.GoodsId
                                                  AND Object_Price.UnitId  = tmp.UnitId 
                       --INNER JOIN tmpUnit ON tmpUnit.UnitId = Object_Price.UnitId
                       
                       -- получаем значения цены из истории значений на кон.дату
                       LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                               ON ObjectHistory_Price.ObjectId = Object_Price.Id
                                              AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                              AND inDateFinal >= ObjectHistory_Price.StartDate AND inDateFinal < ObjectHistory_Price.EndDate
                       LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                         ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id
                                        AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_Price_Value()
                 )
  
  , tmpPriceClose AS ( SELECT tmp.GoodsId 
                            , tmp.UnitId
                            , Object_Price.MCSIsClose
                            , Object_Price.MCSIsCloseDateChange
                       FROM (SELECT DISTINCT tmpPromoUnit.GoodsId, tmpPromoUnit.UnitId
                             FROM tmpPromoUnit
                             UNION
                             SELECT DISTINCT tmpDataRez.GoodsId, tmpDataRez.UnitId 
                             FROM tmpDataRez
                             ) AS tmp
                            LEFT JOIN Object_Price_View AS Object_Price
                                                        ON Object_Price.GoodsId = tmp.GoodsId
                                                       AND Object_Price.UnitId  = tmp.UnitId
                       )

        -- результат
        SELECT
             Object_From_Income.ObjectCode                            AS JuridicalCode
           , Object_From_Income.ValueData                             AS JuridicalName

           , Object_Goods.Id                                          AS GoodsId
           , Object_Goods.ObjectCode                                  AS GoodsCode
           , Object_Goods.ValueData                                   AS GoodsName
           , Object_GoodsGroup.ValueData                              AS GoodsGroupName

           , Object_NDSKind_Income.ValueData                          AS NDSKindName
           , ObjectFloat_NDSKind_NDS.ValueData                        AS NDS
           , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar AS ConditionsKeepName           

           , tmpData.Amount                                ::TFloat   AS Amount
        
           , tmpData.Price                                 ::TFloat
           , tmpData.PriceSale                             ::TFloat   AS PriceSale
           , tmpData.PriceWithVAT                          ::TFloat
           , tmpData.PriceWithOutVAT                       ::TFloat
                        
           , tmpData.Summa           :: TFloat AS Summa
           , tmpData.SummaSale       :: TFloat AS SummaSale
           , Round(tmpData.SummaSale * 100 / (100 + ObjectFloat_NDSKind_NDS.ValueData), 2):: TFloat AS SummaSaleWithOut
           , tmpData.SummaWithVAT    :: TFloat AS SummaWithVAT
           , tmpData.SummaWithOutVAT :: TFloat AS SummaWithOutVAT

           , (tmpData.SummaSale - tmpData.Summa)           :: TFloat  AS SummaMargin
           , (tmpData.SummaSale - tmpData.SummaWithVAT)    :: TFloat  AS SummaMarginWithVAT

           , tmpData.AmountPromo                           :: TFloat  AS AmountPromo
           , tmpData.AmountPromoPlanMax                    :: TFloat  AS AmountPromoPlanMax

           , CAST ( (CASE WHEN COALESCE (tmpData.AmountPromo,0) <> 0 THEN tmpData.Amount*100 /tmpData.AmountPromo ELSE 0 END) AS NUMERIC (16,0) )  ::TFloat AS PersentPlan  -- Процент выполнения
           , CAST ( (CASE WHEN (COALESCE(tmpData.Amount,0) - tmpData.AmountPromoPlanMax) >= 0 THEN tmpData.SummaSale/100 * 3 ELSE 0 END) AS NUMERIC (16,2) )   ::TFloat AS SummaBonus               -- сумма премии
           , CAST ( (CASE WHEN (COALESCE(tmpData.Amount,0) - tmpData.AmountPromo) < 0 
                          THEN (tmpData.AmountPromo - COALESCE(tmpData.Amount,0)) * COALESCE(tmpData.PriceSale,tmpData.Price_P) / 100 * 10
                          ELSE 0 END) AS NUMERIC (16,2) )   ::TFloat AS SummaPenalty             -- сумма штрафа
           , CAST (CASE WHEN (CASE WHEN COALESCE (tmpData.AmountPromo,0) <> 0 THEN COALESCE(tmpData.Amount,0) * 100 /tmpData.AmountPromo ELSE 0 END)  >= 90
                        THEN
                            ( (CASE WHEN (COALESCE(tmpData.Amount,0) - tmpData.AmountPromoPlanMax) >= 0 THEN tmpData.SummaSale/100 * 3 ELSE 0 END)
                             - 
                              (CASE WHEN (COALESCE(tmpData.Amount,0) - tmpData.AmountPromo) < 0 
                                    THEN (tmpData.AmountPromo - COALESCE(tmpData.Amount,0)) * COALESCE(tmpData.PriceSale,tmpData.Price_P) / 100 * 10
                                    ELSE 0 END)
                             )
                        ELSE (CASE WHEN (COALESCE(tmpData.Amount,0) - tmpData.AmountPromo) < 0 
                                    THEN (tmpData.AmountPromo - COALESCE(tmpData.Amount,0)) * COALESCE(tmpData.PriceSale,tmpData.Price_P) / 100 * 10
                                    ELSE 0 END) * (-1)
                    END  AS NUMERIC (16,2) )   ::TFloat AS SummaPay                                  -- Итог для точки - Премия минус Штраф равно разница 

           , CASE WHEN (COALESCE(tmpData.Amount,0) - tmpData.AmountPromo) >= 0 THEN TRUE ELSE FALSE END         AS isPromoUnit
           , CASE WHEN (COALESCE(tmpData.Amount,0) - tmpData.AmountPromoPlanMax) >= 0 THEN TRUE ELSE FALSE END  AS isPromoPlanMax

           , MovementDesc_Income.ItemName                             AS PartionDescName
           , Movement_Income.InvNumber                                AS PartionInvNumber
           , Movement_Income.OperDate                                 AS PartionOperDate
           , COALESCE (MovementDesc_Price.ItemName, MovementDesc_Income.ItemName) AS PartionPriceDescName
           , COALESCE (Movement_Price.InvNumber, Movement_Income.InvNumber)       AS PartionPriceInvNumber
           , COALESCE (Movement_Price.OperDate, Movement_Income.OperDate)         AS PartionPriceOperDate

           , Object_To_Income.ValueData                               AS UnitName
           , Object_OurJuridical_Income.ValueData                     AS OurJuridicalName

           , COALESCE(ObjectBoolean_Goods_Close.ValueData, False)                 AS isClose
           , COALESCE(ObjectDate_Update.ValueData, Null)        ::TDateTime       AS UpdateDate   
           , tmpData.MCSIsClose
           , tmpData.MCSIsCloseDateChange                       ::TDateTime       AS MCSIsCloseDateChange
      
        FROM (SELECT tmpData.JuridicalId_Income
                   , tmpData.NDSKindId_Income
                   , COALESCE (tmpData.GoodsId, tmpPromoUnit.GoodsId) AS GoodsId
                   , tmpData.ToId_Income
                   , tmpData.OurJuridicalId_Income
                   , tmpData.MovementId_Income
                   , tmpData.MovementId_find
                   
                   , SUM (tmpData.Amount)                                ::TFloat   AS Amount
                
                   , CASE WHEN SUM (tmpData.Amount) <> 0 THEN SUM (tmpData.Summa)           / SUM (tmpData.Amount) ELSE 0 END :: TFloat AS Price
                   , CASE WHEN SUM (tmpData.Amount) <> 0 THEN SUM (tmpData.SummaSale)       / SUM (tmpData.Amount) ELSE 0 END :: TFloat AS PriceSale
                   , CASE WHEN SUM (tmpData.Amount) <> 0 THEN SUM (tmpData.SummaWithVAT)    / SUM (tmpData.Amount) ELSE 0 END :: TFloat AS PriceWithVAT
                   , CASE WHEN SUM (tmpData.Amount) <> 0 THEN SUM (tmpData.SummaWithOutVAT) / SUM (tmpData.Amount) ELSE 0 END :: TFloat AS PriceWithOutVAT
                   , CASE WHEN SUM (tmpData.Amount) <> 0 THEN SUM (tmpData.Amount * tmpPrice.Price) / SUM (tmpData.Amount) ELSE 0 END :: TFloat AS Price_P 
                   
                   , SUM (tmpData.Summa)                                   AS Summa
                   , SUM (tmpData.SummaSale)                               AS SummaSale
                   , SUM (tmpData.SummaWithVAT)                            AS SummaWithVAT
                   , SUM (tmpData.SummaWithOutVAT )                        AS SummaWithOutVAT
        
                   , SUM (tmpPromoUnit.Amount)                             AS AmountPromo
                   , SUM (tmpPromoUnit.AmountPlanMax)                      AS AmountPromoPlanMax
        
                   , COALESCE(tmpPriceClose.MCSIsClose, False)             AS MCSIsClose
                   , COALESCE(tmpPriceClose.MCSIsCloseDateChange, Null)    AS MCSIsCloseDateChange
                   
                   
              FROM tmpDataRez AS tmpData
      
                   FUll JOIN tmpPromoUnit ON tmpPromoUnit.GoodsId = tmpData.GoodsId
                                         AND tmpPromoUnit.UnitId  = tmpData.UnitId
                
                   LEFT JOIN tmpPrice ON tmpPrice.GoodsId = tmpPromoUnit.GoodsId
                                     AND tmpPrice.UnitId  = tmpPromoUnit.UnitId
                                                                                
                   LEFT JOIN tmpPriceClose ON tmpPriceClose.GoodsId = COALESCE (tmpData.GoodsId, tmpPromoUnit.GoodsId)
                                          AND tmpPriceClose.UnitId  = tmpData.UnitId  
              GROUP BY tmpData.JuridicalId_Income
                   , tmpData.NDSKindId_Income
                   , COALESCE (tmpData.GoodsId, tmpPromoUnit.GoodsId) 
                   , tmpData.ToId_Income
                   , tmpData.OurJuridicalId_Income
                   , tmpData.MovementId_Income
                   , tmpData.MovementId_find
                   , COALESCE(tmpPriceClose.MCSIsClose, False)
                   , COALESCE(tmpPriceClose.MCSIsCloseDateChange, Null)
              ) AS tmpData
             
             LEFT JOIN Object AS Object_From_Income ON Object_From_Income.Id = tmpData.JuridicalId_Income
             LEFT JOIN Object AS Object_NDSKind_Income ON Object_NDSKind_Income.Id = tmpData.NDSKindId_Income

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
             
             LEFT JOIN Object AS Object_To_Income ON Object_To_Income.Id = tmpData.ToId_Income
             LEFT JOIN Object AS Object_OurJuridical_Income ON Object_OurJuridical_Income.Id = tmpData.OurJuridicalId_Income

             LEFT JOIN Movement AS Movement_Income ON Movement_Income.Id = tmpData.MovementId_Income
             LEFT JOIN Movement AS Movement_Price ON Movement_Price.Id = tmpData.MovementId_find

             LEFT JOIN MovementDesc AS MovementDesc_Income ON MovementDesc_Income.Id = Movement_Income.DescId
             LEFT JOIN MovementDesc AS MovementDesc_Price ON MovementDesc_Price.Id = Movement_Price.DescId
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

 
             LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                   ON ObjectFloat_NDSKind_NDS.ObjectId = tmpData.NDSKindId_Income
                                  AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS() 
                                                                     
        ORDER BY Object_GoodsGroup.ValueData
               , Object_Goods.ValueData
;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 07.07.17         *
 17.02.17         *
 12.01.17         *
 14.03.16                                        * ALL
 28.01.16         * 
 11.08.15                                                                       *
*/

-- тест
-- SELECT * FROM gpReport_Movement_Check(inUnitId := 183292 , inDateStart := ('01.02.2016')::TDateTime , inDateFinal := ('29.02.2016')::TDateTime , inIsPartion := 'False' ,  inSession := '3');
-- SELECT * FROM gpReport_Movement_Check (inUnitId:= 183292, inDateStart:= '20150801'::TDateTime, inDateFinal:= '20150810'::TDateTime, inIsPartion:= FALSE, inSession:= '3')