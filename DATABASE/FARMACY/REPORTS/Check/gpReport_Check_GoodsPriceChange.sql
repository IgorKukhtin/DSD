-- Function:  gpReport_Movement_Check_Light()

DROP FUNCTION IF EXISTS gpReport_Check_GoodsPriceChange(Integer, Integer, Integer, TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Check_GoodsPriceChange(
    IN inUnitId           Integer  ,  -- Подразделение
    IN inRetailId         Integer  ,  -- ссылка на торг.сеть
    IN inJuridicalId      Integer  ,  -- юр.лицо
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inisUnitList       Boolean,    -- 
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (JuridicalCode  Integer,  
               JuridicalName  TVarChar,
               UnitName       TVarChar,
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
               PriceReal             TFloat,
               Summa                 TFloat,
               SummaSale             TFloat,
               SummaWithVAT          Tfloat,      --Сумма поставщика с учетом НДС (без % корр.)
               SummaWithOutVAT       Tfloat,
               SummaReal             TFloat,
               
               PartionDescName       TVarChar,
               PartionInvNumber      TVarChar,
               PartionOperDate       TDateTime,
               
               UnitName_Partion         TVarChar,
               OurJuridicalName_Partion TVarChar,
               isDiscont Boolean,
               isClose Boolean, UpdateDate TDateTime,
               isTop boolean, isFirst boolean , isSecond boolean
               )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
   RETURN QUERY
   WITH
   tmpUnit AS (SELECT inUnitId AS UnitId
                    , ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                FROM ObjectLink AS ObjectLink_Unit_Juridical
                     LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                          ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                         AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                WHERE COALESCE (inUnitId, 0) <> 0 
                  AND inisUnitList = FALSE
                  AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                  AND ObjectLink_Unit_Juridical.ObjectId = inUnitId
              UNION 
               SELECT ObjectLink_Unit_Juridical.ObjectId        AS UnitId
                    , ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
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
                SELECT ObjectBoolean_Report.ObjectId             AS UnitId
                     , ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                FROM ObjectBoolean AS ObjectBoolean_Report
                     LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                          ON ObjectLink_Unit_Juridical.ObjectId = ObjectBoolean_Report.ObjectId
                                         AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                     LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                          ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                         AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                WHERE ObjectBoolean_Report.DescId = zc_ObjectBoolean_Unit_Report()
                  AND ObjectBoolean_Report.ValueData = TRUE
                  AND inisUnitList = TRUE
            )

    -- Товары PriceChange
 , tmpPriceChange AS (SELECT ObjectLink_PriceChange_Retail.ObjectId        AS Id
                           , PriceChange_Goods.ChildObjectId               AS GoodsId
                      FROM ObjectLink AS ObjectLink_PriceChange_Retail
                          INNER JOIN tmpUnit ON tmpUnit.RetailId = ObjectLink_PriceChange_Retail.ChildObjectId
                          LEFT JOIN ObjectLink AS PriceChange_Goods
                                               ON PriceChange_Goods.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                              AND PriceChange_Goods.DescId = zc_ObjectLink_PriceChange_Goods()
                      WHERE ObjectLink_PriceChange_Retail.DescId = zc_ObjectLink_PriceChange_Retail()
                     UNION
                      SELECT ObjectLink_PriceChange_Unit.ObjectId          AS Id
                           , PriceChange_Goods.ChildObjectId               AS GoodsId
                      FROM ObjectLink AS ObjectLink_PriceChange_Unit
                          INNER JOIN tmpUnit ON tmpUnit.RetailId = ObjectLink_PriceChange_Unit.ChildObjectId
                          LEFT JOIN ObjectLink AS PriceChange_Goods
                                               ON PriceChange_Goods.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                              AND PriceChange_Goods.DescId = zc_ObjectLink_PriceChange_Goods()
                      WHERE ObjectLink_PriceChange_Unit.DescId        = zc_ObjectLink_PriceChange_Unit()
                      )

 , tmpGoodsPriceChange AS (SELECT DISTINCT tmpPriceChange.GoodsId
                           FROM tmpPriceChange
                               -- получаем значения цены из истории                                                           
                               LEFT JOIN ObjectHistory AS ObjectHistory_PriceChange
                                                       ON ObjectHistory_PriceChange.ObjectId = tmpPriceChange.Id 
                                                      AND ObjectHistory_PriceChange.DescId = zc_ObjectHistory_PriceChange()
                                                      AND inEndDate >= ObjectHistory_PriceChange.StartDate AND inStartDate < ObjectHistory_PriceChange.EndDate
                                                   --AND '31.10.2018' >= ObjectHistory_PriceChange.StartDate AND '30.10.2018' <= ObjectHistory_PriceChange.EndDate

                               LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceChange
                                                            ON ObjectHistoryFloat_PriceChange.ObjectHistoryId = ObjectHistory_PriceChange.Id
                                                           AND ObjectHistoryFloat_PriceChange.DescId = zc_ObjectHistoryFloat_PriceChange_Value()

                               LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_FixValue
                                                            ON ObjectHistoryFloat_FixValue.ObjectHistoryId = ObjectHistory_PriceChange.Id
                                                           AND ObjectHistoryFloat_FixValue.DescId = zc_ObjectHistoryFloat_PriceChange_FixValue()                

                               LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_FixPercent
                                                            ON ObjectHistoryFloat_FixPercent.ObjectHistoryId = ObjectHistory_PriceChange.Id
                                                           AND ObjectHistoryFloat_FixPercent.DescId = zc_ObjectHistoryFloat_PriceChange_FixPercent()

                               LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_FixDiscount
                                                            ON ObjectHistoryFloat_FixDiscount.ObjectHistoryId = ObjectHistory_PriceChange.Id
                                                           AND ObjectHistoryFloat_FixDiscount.DescId = zc_ObjectHistoryFloat_PriceChange_FixDiscount()                

                           WHERE COALESCE (ObjectHistoryFloat_PriceChange.ValueData, 0)  <> 0
                              OR COALESCE (ObjectHistoryFloat_FixValue.ValueData, 0) <> 0
                              OR COALESCE (ObjectHistoryFloat_FixPercent.ValueData, 0) <> 0
                              OR COALESCE (ObjectHistoryFloat_FixDiscount.ValueData, 0) <> 0
                           )

 , tmpData_Container AS (SELECT COALESCE (MIContainer.AnalyzerId,0)         AS MovementItemId_Income
                              , MIContainer.OperDate                        AS OperDate
                              , MIContainer.WhereObjectId_analyzer          AS UnitId
                              , MIContainer.MovementItemId                  AS MI_Id
                              , MIContainer.ObjectId_analyzer               AS GoodsId
                              , COALESCE (MIContainer.Price,0)              AS PriceSale
                              , SUM (COALESCE (-1 * MIContainer.Amount, 0)) AS Amount
                              , SUM (COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0)) AS SummaSale
                         FROM MovementItemContainer AS MIContainer
                              INNER JOIN tmpUnit ON tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer
                              INNER JOIN tmpGoodsPriceChange ON tmpGoodsPriceChange.GoodsId = MIContainer.ObjectId_analyzer
                         WHERE MIContainer.DescId = zc_MIContainer_Count()
                           AND MIContainer.MovementDescId = zc_Movement_Check()
                           AND MIContainer.OperDate >= inStartDate AND MIContainer.OperDate < inEndDate + INTERVAL '1 DAY'
                          -- AND MIContainer.OperDate >= '03.10.2018' AND MIContainer.OperDate < '17.10.2018'
                         GROUP BY COALESCE (MIContainer.AnalyzerId,0)
                                , MIContainer.ObjectId_analyzer 
                                , MIContainer.OperDate
                                , MIContainer.WhereObjectId_analyzer
                                , COALESCE (MIContainer.Price,0)
                                , MIContainer.MovementItemId
                         HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
                         )

  -- плоучаем цену без скидки из док. продажи
 , tmpMI_FLoat AS (SELECT MovementItemFloat.*
                   FROM MovementItemFloat
                   WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpData_Container.MI_Id FROM tmpData_Container)
                     AND MovementItemFloat.DescId = zc_MIFloat_PriceSale()
                   )
  
 , tmpData_ AS (SELECT tmpData_Container.UnitId 
                     , tmpData_Container.GoodsId
                     , tmpData_Container.MovementItemId_Income
                     , tmpData_Container.PriceSale
                     , tmpMI_FLoat.ValueData                           AS PriceReal
                     , SUM (tmpData_Container.Amount)                  AS Amount
                     , SUM (tmpData_Container.SummaSale)               AS SummaSale
                     , SUM (tmpData_Container.Amount * tmpMI_FLoat.ValueData) AS SummaReal
                FROM tmpData_Container
                     LEFT JOIN tmpMI_FLoat ON tmpMI_FLoat.MovementItemId = tmpData_Container.MI_Id
                GROUP BY tmpData_Container.MovementItemId_Income
                       , tmpData_Container.UnitId 
                       , tmpData_Container.GoodsId
                       , tmpData_Container.MovementItemId_Income
                       , tmpData_Container.PriceSale
                       , tmpMI_FLoat.ValueData
               )
         
 , tmpData_all AS (SELECT MI_Income.MovementId      AS MovementId_Income
                        , COALESCE (MI_Income_find.Id,         MI_Income.Id)         :: Integer AS MovementItemId
                        , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) :: Integer AS MovementId
                        , tmpData_Container.UnitId
                        , tmpData_Container.GoodsId
                        , tmpData_Container.PriceSale
                        , tmpData_Container.PriceReal
                        , SUM (COALESCE (tmpData_Container.Amount, 0))    AS Amount
                        , SUM (COALESCE (tmpData_Container.SummaSale, 0)) AS SummaSale
                        , SUM (COALESCE (tmpData_Container.SummaReal, 0)) AS SummaReal
                   FROM tmpData_ AS tmpData_Container
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
                         , tmpData_Container.GoodsId
                         , tmpData_Container.UnitId
                         , tmpData_Container.PriceSale
                         , tmpData_Container.PriceReal
                  )

 , tmpData AS (SELECT tmpData_all.MovementId_Income               AS MovementId_Income
                    , MovementLinkObject_From_Income.ObjectId     AS JuridicalId_Income
                    , MovementLinkObject_NDSKind_Income.ObjectId  AS NDSKindId_Income
                    , tmpData_all.UnitId
                    , tmpData_all.GoodsId
                    , tmpData_all.PriceSale
                    , tmpData_all.PriceReal
                    , SUM (tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0))  AS Summa
                    , SUM (tmpData_all.Amount * COALESCE (MIFloat_PriceWithOutVAT.ValueData, 0)) AS SummaWithOutVAT
                    , SUM (tmpData_all.Amount * COALESCE (MIFloat_PriceWithVAT.ValueData, 0))    AS SummaWithVAT
                    , SUM (tmpData_all.Amount)                    AS Amount
                    , SUM (tmpData_all.SummaSale)                 AS SummaSale
                    , SUM (tmpData_all.SummaReal)                 AS SummaReal
                    --
                    , MovementLinkObject_Juridical_Income.ObjectId AS OurJuridicalId_Income
                    , MovementLinkObject_To.ObjectId               AS ToId_Income
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

               GROUP BY tmpData_all.MovementId_Income
                      , MovementLinkObject_From_Income.ObjectId
                      , MovementLinkObject_NDSKind_Income.ObjectId
                      , tmpData_all.GoodsId
                      , tmpData_all.UnitId
                      , MovementLinkObject_Juridical_Income.ObjectId
                      , MovementLinkObject_To.ObjectId
                      , tmpData_all.PriceSale
                      , tmpData_all.PriceReal
              )

 , tmpDataRez AS (SELECT tmpData.MovementId_Income
                       , tmpData.JuridicalId_Income
                       , tmpData.NDSKindId_Income
                       , tmpData.UnitId
                       , tmpData.GoodsId
                       , tmpData.PriceSale
                       , tmpData.PriceReal
                       , SUM (tmpData.Summa)           AS Summa
                       , SUM (tmpData.SummaWithOutVAT) AS SummaWithOutVAT
                       , SUM (tmpData.SummaWithVAT)    AS SummaWithVAT
                       , SUM (tmpData.Amount)          AS Amount
                       , SUM (tmpData.SummaSale)       AS SummaSale
                       , SUM (tmpData.SummaReal)       AS SummaReal
                       , tmpData.OurJuridicalId_Income
                       , tmpData.ToId_Income
                  FROM tmpData
                  GROUP BY tmpData.MovementId_Income
                         , tmpData.JuridicalId_Income
                         , tmpData.NDSKindId_Income
                         , tmpData.GoodsId
                         , tmpData.OurJuridicalId_Income
                         , tmpData.ToId_Income
                         , tmpData.UnitId
                         , tmpData.PriceSale
                         , tmpData.PriceReal
                  )


        -- результат
        SELECT Object_From_Income.ObjectCode                                     AS JuridicalCode
             , Object_From_Income.ValueData                                      AS JuridicalName -- +поставщик
             , Object_Unit.ValueData                                             AS UnitName
             , Object_Goods.Id                                                   AS GoodsId
             , Object_Goods.ObjectCode                                           AS GoodsCode
             , Object_Goods.ValueData                                            AS GoodsName
             , Object_GoodsGroup.ValueData                                       AS GoodsGroupName
             , Object_NDSKind_Income.ValueData                                   AS NDSKindName
             , ObjectFloat_NDSKind_NDS.ValueData                                 AS NDS
             , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar          AS ConditionsKeepName           

             , tmpData.Amount          :: TFloat

             , CASE WHEN tmpData.Amount <> 0 THEN tmpData.Summa           / tmpData.Amount ELSE 0 END :: TFloat AS Price
--             , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaSale       / tmpData.Amount ELSE 0 END :: TFloat AS PriceSale
             , tmpData.PriceSale :: TFloat
             , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaWithVAT    / tmpData.Amount ELSE 0 END :: TFloat AS PriceWithVAT      --Цена прихода (с НДС) +
             , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaWithOutVAT / tmpData.Amount ELSE 0 END :: TFloat AS PriceWithOutVAT 
             , tmpData.PriceReal :: TFloat        --, CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaReal       / tmpData.Amount ELSE 0 END :: TFloat AS PriceReal

             , tmpData.Summa           :: TFloat AS Summa        
             , tmpData.SummaSale       :: TFloat AS SummaSale
             , tmpData.SummaWithVAT    :: TFloat AS SummaWithVAT
             , tmpData.SummaWithOutVAT :: TFloat AS SummaWithOutVAT
             , tmpData.SummaReal       :: TFloat AS SummaReal

             , MovementDesc_Income.ItemName AS PartionDescName
             , Movement_Income.InvNumber    AS PartionInvNumber
             , Movement_Income.OperDate     AS PartionOperDate

             , Object_To_Income.ValueData              AS UnitName_Partion
             , Object_OurJuridical_Income.ValueData    AS OurJuridicalName_Partion

             , CASE WHEN COALESCE (tmpData.SummaReal, 0) > COALESCE (tmpData.SummaSale, 0) THEN TRUE ELSE FALSE END AS isDiscont --продано по Скидке да/нет

             , COALESCE(ObjectBoolean_Goods_Close.ValueData, False)  :: Boolean  AS isClose
             , COALESCE(ObjectDate_Update.ValueData, Null)           ::TDateTime AS UpdateDate   

             , COALESCE(ObjectBoolean_Goods_TOP.ValueData, false)    :: Boolean  AS isTOP
             , COALESCE(ObjectBoolean_Goods_First.ValueData, False)  :: Boolean  AS isFirst
             , COALESCE(ObjectBoolean_Goods_Second.ValueData, False) :: Boolean  AS isSecond

        FROM tmpDataRez AS tmpData
             LEFT JOIN Object AS Object_From_Income ON Object_From_Income.Id = tmpData.JuridicalId_Income
             LEFT JOIN Object AS Object_NDSKind_Income ON Object_NDSKind_Income.Id = tmpData.NDSKindId_Income

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpData.UnitId
             
             LEFT JOIN Object AS Object_To_Income ON Object_To_Income.Id = tmpData.ToId_Income
             LEFT JOIN Object AS Object_OurJuridical_Income ON Object_OurJuridical_Income.Id = tmpData.OurJuridicalId_Income

             LEFT JOIN Movement AS Movement_Income ON Movement_Income.Id = tmpData.MovementId_Income
 
             LEFT JOIN MovementDesc AS MovementDesc_Income ON MovementDesc_Income.Id = Movement_Income.DescId
             
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
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.10.18         *
 17.10.18         *
*/

-- тест
-- SELECT * FROM gpReport_Check_GoodsPriceChange (inUnitId := 183292 ,inRetailId := 0, inJuridicalId := 0,  inStartDate := ('01.10.2018')::TDateTime , inEndDate := ('28.10.2018')::TDateTime , inisUnitList := 'true' ,  inSession := '3');