-- Function:  gpReport_Check_PriceChange()

DROP FUNCTION IF EXISTS gpReport_Check_PriceChange (Integer, Integer, Integer, TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Check_PriceChange (Integer, Integer, Integer, TDateTime, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Check_PriceChange(
    IN inUnitId           Integer  ,  -- Подразделение
    IN inRetailId         Integer  ,  -- ссылка на торг.сеть
    IN inJuridicalId      Integer  ,  -- юр.лицо
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inisUnitList       Boolean,    -- 
    IN inisDetails        Boolean,    -- показать подразделения
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsId        Integer 
             , GoodsCode      Integer 
             , GoodsName      TVarChar
             , GoodsGroupName TVarChar
             , ConditionsKeepName TVarChar
             , AmountSale     TFloat
             , AmountChange   TFloat
             , PriceSale      TFloat
             , PriceChange    TFloat
             , SummaSale      TFloat
             , SummaChange    TFloat
             , IsClose Boolean, UpdateDate TDateTime
             , isTop boolean, isFirst boolean, isSecond boolean
             
             , UnitId Integer, UnitName TVarChar
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
    
    CREATE TEMP TABLE tmpUnit_PC ON COMMIT DROP AS
               (SELECT inUnitId                                  AS UnitId
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
             );
             
    ANALYSE tmpUnit_PC;
    
   -- товары имеющие цену со скидкой
    CREATE TEMP TABLE tmpPriceChange_PC ON COMMIT DROP AS
                      (SELECT ObjectLink_PriceChange_Retail.ChildObjectId                                    AS RetailId
                            , ObjectLink_PriceChange_Unit.ChildObjectId                                      AS UnitId
                            , ObjectLink_PriceChange_Goods.ChildObjectId                                     AS GoodsId
                            , ROUND (COALESCE (ObjectHistoryFloat_PriceChange.ValueData, 0), 2) :: TFloat    AS PriceChange
                            , COALESCE (ObjectHistoryFloat_FixValue.ValueData, 0)               :: TFloat    AS FixValue
                            , COALESCE (ObjectHistoryFloat_PercentMarkup.ValueData, 0)          :: TFloat    AS PercentMarkupStart
                            , ObjectHistory_PriceChange.StartDate
                            , ObjectHistory_PriceChange.EndDate
                       FROM Object AS Object_PriceChange
                            LEFT JOIN ObjectLink AS ObjectLink_PriceChange_Retail 
                                                 ON ObjectLink_PriceChange_Retail.ObjectId = Object_PriceChange.Id
                                                AND ObjectLink_PriceChange_Retail.DescId = zc_ObjectLink_PriceChange_Retail()
                                                AND ObjectLink_PriceChange_Retail.ChildObjectId IN (SELECT DISTINCT tmpUnit.RetailId FROM tmpUnit_PC AS tmpUnit)

                            LEFT JOIN ObjectLink AS ObjectLink_PriceChange_Unit 
                                                 ON ObjectLink_PriceChange_Unit.ObjectId = Object_PriceChange.Id
                                                AND ObjectLink_PriceChange_Unit.DescId = zc_ObjectLink_PriceChange_Unit()
                                                AND ObjectLink_PriceChange_Unit.ChildObjectId IN (SELECT DISTINCT tmpUnit.UnitId FROM tmpUnit_PC AS tmpUnit)

                            LEFT JOIN ObjectLink AS ObjectLink_PriceChange_Goods
                                                 ON ObjectLink_PriceChange_Goods.ObjectId = COALESCE (ObjectLink_PriceChange_Unit.ObjectId, ObjectLink_PriceChange_Retail.ObjectId)
                                                AND ObjectLink_PriceChange_Goods.DescId = zc_ObjectLink_PriceChange_Goods()

                            LEFT JOIN ObjectFloat AS PriceChange_Value
                                                  ON PriceChange_Value.ObjectId = COALESCE (ObjectLink_PriceChange_Unit.ObjectId, ObjectLink_PriceChange_Retail.ObjectId)
                                                 AND PriceChange_Value.DescId = zc_ObjectFloat_PriceChange_Value()

                            -- получаем значения цены из истории значений на начало дня                                                          
                            LEFT JOIN ObjectHistory AS ObjectHistory_PriceChange
                                                    ON ObjectHistory_PriceChange.ObjectId = COALESCE (ObjectLink_PriceChange_Unit.ObjectId, ObjectLink_PriceChange_Retail.ObjectId)
                                                   AND ObjectHistory_PriceChange.DescId = zc_ObjectHistory_PriceChange()
                                                  -- AND DATE_TRUNC ('DAY', inStartDate) >= ObjectHistory_PriceChange.StartDate AND DATE_TRUNC ('DAY', inStartDate) < ObjectHistory_PriceChange.EndDate

                            -- получаем значения расчетная цена из истории значений на дату
                            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceChange
                                                         ON ObjectHistoryFloat_PriceChange.ObjectHistoryId = ObjectHistory_PriceChange.Id
                                                        AND ObjectHistoryFloat_PriceChange.DescId = zc_ObjectHistoryFloat_PriceChange_Value()

                            -- получаем значения фиксированная цена из истории значений на дату
                            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_FixValue
                                                         ON ObjectHistoryFloat_FixValue.ObjectHistoryId = ObjectHistory_PriceChange.Id
                                                        AND ObjectHistoryFloat_FixValue.DescId = zc_ObjectHistoryFloat_PriceChange_FixValue()                

                            -- получаем значения % наценки из истории значений на дату
                            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PercentMarkup
                                                         ON ObjectHistoryFloat_PercentMarkup.ObjectHistoryId = ObjectHistory_PriceChange.Id
                                                        AND ObjectHistoryFloat_PercentMarkup.DescId = zc_ObjectHistoryFloat_PriceChange_PercentMarkup()
                       WHERE Object_PriceChange.DescId = zc_Object_PriceChange()
                         AND Object_PriceChange.isErased = FALSE
                         AND COALESCE (ObjectHistoryFloat_PriceChange.ValueData, 0) <> 0
                       );    
                       
    ANALYSE tmpPriceChange_PC;

    -- Результат
    RETURN QUERY
    WITH
    tmpGoodsPriceChange AS (SELECT DISTINCT tmpPriceChange.GoodsId
                            FROM tmpPriceChange_PC AS tmpPriceChange
                           )
  -- цены аптеки
  , tmpPrice AS (SELECT tmpGoodsPriceChange.GoodsId                   AS GoodsId
                      , ObjectLink_Unit.ChildObjectId                 AS UnitId
                      , COALESCE (ObjectHistoryFloat_Price.ValueData, 0) :: TFloat  AS Price
                      , ObjectHistory_Price.StartDate
                      , ObjectHistory_Price.EndDate
                 FROM tmpGoodsPriceChange
                      INNER JOIN ObjectLink AS ObjectLink_Goods
                                            ON ObjectLink_Goods.ChildObjectId = tmpGoodsPriceChange.GoodsId
                                           AND ObjectLink_Goods.DescId        = zc_ObjectLink_Price_Goods()
                      LEFT JOIN ObjectLink AS ObjectLink_Unit
                                           ON ObjectLink_Unit.ObjectId      = ObjectLink_Goods.ObjectId
                                          AND ObjectLink_Unit.DescId        = zc_ObjectLink_Price_Unit()
                      INNER JOIN tmpUnit_PC AS tmpUnit ON tmpUnit.UnitId = ObjectLink_Unit.ChildObjectId

                      -- получаем значения цены и НТЗ из истории значений на начало дня                                                          
                      LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                              ON ObjectHistory_Price.ObjectId = ObjectLink_Goods.ObjectId 
                                             AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                             AND inEndDate >= ObjectHistory_Price.StartDate AND inStartDate < ObjectHistory_Price.EndDate
                      LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                                   ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id
                                                  AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_Price_Value()
                )
  , tmpDataContainer AS (SELECT tmpUnit.RetailId
                              , MIContainer.MovementId
                              , MIContainer.WhereObjectId_analyzer          AS UnitId
                              , MIContainer.OperDate                     ---DATE_TRUNC ('DAY', MIContainer.OperDate)    AS OperDate
                              , MIContainer.ObjectId_analyzer               AS GoodsId
                              , COALESCE (MIContainer.Price,0)              AS Price
                              , SUM (COALESCE (-1 * MIContainer.Amount, 0)) AS Amount
                              , SUM (COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0)) AS SummaSale
                         FROM MovementItemContainer AS MIContainer
                              INNER JOIN tmpUnit_PC AS tmpUnit ON tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer
                              INNER JOIN tmpGoodsPriceChange ON tmpGoodsPriceChange.GoodsId = MIContainer.ObjectId_analyzer
                         WHERE MIContainer.DescId = zc_MIContainer_Count()
                           AND MIContainer.MovementDescId = zc_Movement_Check()
                           AND MIContainer.OperDate >= inStartDate AND MIContainer.OperDate < inEndDate + INTERVAL '1 DAY'
                         GROUP BY tmpUnit.RetailId
                                , MIContainer.WhereObjectId_analyzer
                                , MIContainer.OperDate
                                , MIContainer.ObjectId_analyzer
                                , COALESCE (MIContainer.Price,0)
                                , MIContainer.MovementId
                         HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
                         )

  , tmpData AS (SELECT tmpDataContainer.*
                FROM tmpDataContainer
                     -- инфа из документа промо код
                     LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                                             ON MovementFloat_MovementItemId.MovementId = tmpDataContainer.MovementId
                                            AND MovementFloat_MovementItemId.DescId     = zc_MovementFloat_MovementItemId()
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_DiscountCard
                                                  ON MovementLinkObject_DiscountCard.MovementId = tmpDataContainer.MovementId
                                                 AND MovementLinkObject_DiscountCard.DescId = zc_MovementLinkObject_DiscountCard()
                     LEFT JOIN Object AS Object_DiscountCard ON Object_DiscountCard.Id = MovementLinkObject_DiscountCard.ObjectId
                WHERE COALESCE (MovementLinkObject_DiscountCard.ObjectId, 0) = 0 
                  AND COALESCE (MovementFloat_MovementItemId.ValueData,0) = 0
                )
                
  , tmpDataAll AS (SELECT tmpData.GoodsId
                        , CASE WHEN inisDetails = TRUE THEN tmpData.UnitId ELSE 0 END AS UnitId
                        , SUM (CASE WHEN COALESCE (tmpPriceChange.PriceChange, 0) = tmpData.Price THEN tmpData.Amount ELSE 0 END)     AS AmountChange
                        , SUM (CASE WHEN COALESCE (tmpPriceChange.PriceChange, 0) < tmpData.Price THEN tmpData.Amount  ELSE 0 END)    AS AmountSale
                        , SUM (CASE WHEN COALESCE (tmpPriceChange.PriceChange, 0) = tmpData.Price THEN tmpData.SummaSale ELSE 0 END)  AS SummaChange
                        , SUM (CASE WHEN COALESCE (tmpPriceChange.PriceChange, 0) < tmpData.Price THEN tmpData.SummaSale ELSE 0 END)  AS SummaSale
                   FROM tmpData
                        LEFT JOIN tmpPriceChange_PC AS tmpPriceChange 
                                                    ON (tmpPriceChange.RetailId = tmpData.RetailId OR tmpPriceChange.UnitId = tmpData.UnitId)
                                                   AND tmpPriceChange.GoodsId = tmpData.GoodsId
                                                   AND tmpData.OperDate >= tmpPriceChange.StartDate AND tmpData.OperDate < tmpPriceChange.EndDate
                                                   AND COALESCE (tmpPriceChange.PriceChange, 0) <> 0
                   GROUP BY tmpData.GoodsId
                          , CASE WHEN inisDetails = TRUE THEN tmpData.UnitId ELSE 0 END
                   )

        -- результат
        SELECT Object_Goods.Id                                                  AS GoodsId
             , Object_Goods.ObjectCode                                          AS GoodsCode
             , Object_Goods.ValueData                                           AS GoodsName
             , Object_GoodsGroup.ValueData                                      AS GoodsGroupName
             , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar         AS ConditionsKeepName           

             , tmpData.AmountSale      :: TFloat
             , tmpData.AmountChange    :: TFloat
             , CASE WHEN COALESCE (tmpData.AmountSale, 0) <> 0   THEN tmpData.SummaSale   / tmpData.AmountSale   ELSE 0 END :: TFloat AS PriceSale
             , CASE WHEN COALESCE (tmpData.AmountChange, 0) <> 0 THEN tmpData.SummaChange / tmpData.AmountChange ELSE 0 END :: TFloat AS PriceChange
             , tmpData.SummaSale       :: TFloat
             , tmpData.SummaChange     :: TFloat

             , COALESCE(ObjectBoolean_Goods_Close.ValueData, False)  :: Boolean AS isClose
             , COALESCE(ObjectDate_Update.ValueData, Null)          ::TDateTime AS UpdateDate   
             , COALESCE(ObjectBoolean_Goods_TOP.ValueData, false)    :: Boolean AS isTOP
             , COALESCE(ObjectBoolean_Goods_First.ValueData, False)  :: Boolean AS isFirst
             , COALESCE(ObjectBoolean_Goods_Second.ValueData, False) :: Boolean AS isSecond
             
             , Object_Unit.Id         AS UnitId
             , Object_Unit.ValueData  AS UnitName

        FROM tmpDataAll AS tmpData

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
             LEFT JOIN Object AS Object_Unit  ON Object_Unit.Id  = tmpData.UnitId

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

        ORDER BY Object_GoodsGroup.ValueData
               , Object_Goods.ValueData
        ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.09.18         *
*/

-- тест
-- 
SELECT * FROM gpReport_Check_PriceChange(inUnitId := 0 , inRetailId:=  4, inJuridicalId:=0 , inStartDate := ('01.12.2022')::TDateTime , inEndDate := ('31.12.2022')::TDateTime , inisUnitList := 'False' , inisDetails:= FALSE, inSession := '3');