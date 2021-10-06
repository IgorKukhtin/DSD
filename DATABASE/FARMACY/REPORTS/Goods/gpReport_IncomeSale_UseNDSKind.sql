-- Function:  gpReport_IncomeSale_UseNDSKind()

/*
Мне нужен отчет  для позиций  , которые приходя в накладных помеченных галкой " Использовать ставку НДС по приходу".
Я в нем должна  иметь возможность выбрать период, точку, юрлицо, сеть и видеть в нем позиции которые пришли , их цену закупки и цену продажи, наценку 
можно как то все это сделать в одном отчете 
то есть мне нужно понимать  что я закупила   и что продала из таких накладных
и что осталось
в нем же должны быть данные колонок - постановление 224, ТОП сети, наценка ТОПа сети,  Маркетинг, НДС из нашего справочника сети.

*/


DROP FUNCTION IF EXISTS gpReport_IncomeSale_UseNDSKind (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_IncomeSale_UseNDSKind(
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inJuridicalId      Integer  ,
    IN inUnitId           Integer  ,  -- Подразделение
    IN inRetailId         Integer  ,  -- ссылка на торг.сеть
    IN inisUnitList       Boolean  ,  -- 
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitId Integer, UnitName TVarChar,
               GoodsId Integer, GoodsCode Integer, GoodsName TVarChar,
               GoodsGroupName TVarChar,
              
               Amount_income       TFloat,
               PriceWithVAT_income TFloat,
               PriceSale_income    TFloat,
               MarginPercent       TFloat,
               SummaWithVAT        TFloat,
               SummaSale_income    TFloat,
               Amount_sale         TFloat,
               PriceSale_sale      TFloat,
               SummaSale_sale      TFloat,
               Amount_diff         TFloat,
             
               isTOP               Boolean,
               isFirst             Boolean,
               isSecond            Boolean,
               isClose             Boolean,
               isResolution_224    Boolean,
               isPromo             Boolean,
               isSP                Boolean

           /*, Amount_income
           , PriceWithVAT_income
           , PriceSale_income
           , MarginPercent
           , SummaWithVAT
           , SummaSale_income
           , Amount_sale
           , PriceSale_sale
           , SummaSale_sale
*/

               )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ListDiff());
    vbUserId:= lpGetUserBySession (inSession);

    -- определяется <Торговая сеть>
    IF vbUserId IN (3, 183242, 375661) -- Админ + Люба + Юра 
    THEN vbObjectId:= 0;
    ELSE vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);
    END IF;

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
                                              AND (ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId OR vbObjectId = 0)
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

      , tmpIncome_Mov AS (SELECT Movement_Income.Id             AS Id
                               , MovementLinkObject_To.ObjectId AS UnitId
                               , MovementBoolean_PriceWithVAT.ValueData  AS isPriceWithVAT
                               , ObjectFloat_NDSKind_NDS.ValueData       AS NDS
                          FROM Movement AS Movement_Income
                               INNER JOIN MovementDate AS MovementDate_Branch
                                                       ON MovementDate_Branch.MovementId = Movement_Income.Id
                                                      AND MovementDate_Branch.DescId = zc_MovementDate_Branch()
                                                      AND MovementDate_Branch.ValueData >= inStartDate AND MovementDate_Branch.ValueData < inEndDate + INTERVAL '1 DAY'
    
                               INNER JOIN MovementBoolean AS MovementBoolean_UseNDSKind
                                                          ON MovementBoolean_UseNDSKind.MovementId = Movement_Income.Id
                                                         AND MovementBoolean_UseNDSKind.DescId = zc_MovementBoolean_UseNDSKind()
                                                         AND COALESCE (MovementBoolean_UseNDSKind.ValueData, FALSE) = TRUE
    
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                            ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                                           AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                               INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_To.ObjectId

                               LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                         ON MovementBoolean_PriceWithVAT.MovementId = Movement_Income.Id
                                                        AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                            ON MovementLinkObject_NDSKind.MovementId = Movement_Income.Id
                                                           AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                               LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                     ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                                                    AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                           WHERE Movement_Income.DescId = zc_Movement_Income()
                             AND Movement_Income.StatusId = zc_Enum_Status_Complete() 
                        )   

      , tmpIncome AS (SELECT Movement_Income.UnitId                  AS UnitId
                           --, Movement_Income.NDS                     AS NDS
                           , MI_Income.ObjectId                      AS GoodsId
                           , SUM (COALESCE (MI_Income.Amount, 0))    AS AmountIncome 
                           , SUM (COALESCE (MI_Income.Amount, 0) * CASE WHEN Movement_Income.isPriceWithVAT
                                                                        THEN MIFloat_Price.ValueData
                                                                        ELSE (MIFloat_Price.ValueData * (1 + Movement_Income.NDS/100))::TFloat
                                                                   END)                                     AS SummaWithVAT       -- сумма прихода с НДС 
                           , SUM(COALESCE (MI_Income.Amount, 0) * COALESCE(MIFloat_PriceSale.ValueData,0))  AS SummaSale_Income   -- сумма прихода в ценах продажи 

                      FROM tmpIncome_Mov AS Movement_Income
                           LEFT JOIN MovementItem AS MI_Income 
                                                  ON MI_Income.MovementId = Movement_Income.Id
                                                 AND MI_Income.DescId     = zc_MI_Master()
                                                 AND MI_Income.isErased   = False

                           LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                       ON MIFloat_Price.MovementItemId = MI_Income.Id
                                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()

                           LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                       ON MIFloat_PriceSale.MovementItemId = MI_Income.Id
                                                      AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
                       GROUP BY Movement_Income.UnitId
                              --, Movement_Income.NDS
                              , MI_Income.ObjectId
                    )  
 
       -- Маркетинговый контракт
      , GoodsPromo AS (SELECT DISTINCT ObjectLink_Child_retail.ChildObjectId AS GoodsId  -- здесь товар "сети"
                                     , ObjectLink_Goods_Object.ChildObjectId AS ObjectId
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
                            INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                  ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_retail.ChildObjectId
                                                 AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                         )

       -- Товары соц-проект (документ)
      , tmpGoodsSP AS (SELECT DISTINCT tmp.GoodsId
                            , TRUE AS isSP
                       FROM lpSelect_MovementItem_GoodsSPUnit_onDate (inStartDate:= inStartDate, inEndDate:= inEndDate, inUnitId := inUnitId) AS tmp
                         )

      -- продажи
      , tmpCheck AS (SELECT MIContainer.WhereObjectId_analyzer          AS UnitId
                          , MIContainer.ObjectId_analyzer               AS GoodsId
                          , SUM (COALESCE (-1 * MIContainer.Amount, 0)) AS Amount
                          , SUM (COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0)) AS SummaSale

                     FROM MovementItemContainer AS MIContainer
                          INNER JOIN tmpUnit ON tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer
                          INNER JOIN (SELECT DISTINCT tmpIncome.GoodsId FROM tmpIncome) AS tmpGoods ON tmpGoods.GoodsId = MIContainer.ObjectId_analyzer
                          
                          LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                        ON ContainerLinkObject_MovementItem.ContainerId = MIContainer.ContainerId
                                                       AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                          LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                          -- элемент прихода
                          LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                          -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                          LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                      ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                     AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                          -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                          LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                                           
                          INNER JOIN (SELECT DISTINCT tmpIncome_Mov.Id FROM tmpIncome_Mov) AS tmp ON tmp.Id = COALESCE (MI_Income_find.MovementId, MI_Income.MovementId)

                     WHERE MIContainer.DescId = zc_MIContainer_Count()
                       AND MIContainer.MovementDescId = zc_Movement_Check()
                       AND MIContainer.OperDate >= inStartDate AND MIContainer.OperDate < inEndDate + INTERVAL '1 DAY'
                     GROUP BY MIContainer.ObjectId_analyzer 
                            , MIContainer.WhereObjectId_analyzer
                          --  , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId)
                     HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
                     )

      , tmpData AS (SELECT tmpIncome.UnitId
                         --, tmpIncome.NDS
                         , tmpIncome.GoodsId
                         , tmpIncome.AmountIncome     AS Amount_income
                         , tmpIncome.SummaWithVAT     AS SummaWithVAT
                         , tmpIncome.SummaSale_income AS SummaSale_income
                         , tmpCheck.Amount            AS Amount_sale
                         , tmpCheck.SummaSale         AS SummaSale_sale
                    FROM tmpIncome
                         LEFT JOIN tmpCheck ON tmpCheck.UnitId = tmpIncome.UnitId
                                           AND tmpCheck.GoodsId = tmpIncome.GoodsId

                    )

        -- таблица остатков
   /*   , tmpContainer AS (SELECT Container.Id            AS ContainerId
                              , Container.ObjectId      AS GoodsId
                              , Container.WhereObjectId AS UnitId
                              , Container.Amount        AS Amount
                         FROM Container 
                         WHERE Container.DescId = zc_Container_Count()
                           AND Container.WhereObjectId IN (SELECT tmpUnit.UnitId FROM tmpUnit)
                           AND Container.Amount <> 0
                           AND Container.ObjectId IN (SELECT DISTINCT tmpIncome.GoodsId FROM tmpIncome)
                         GROUP BY Container.Id
                                , Container.ObjectId
                                , Container.Amount
                                , Container.WhereObjectId
                         )
      , tmpRemains_All AS (SELECT tmp.GoodsId
                                , tmp.UnitId
                                , SUM (tmp.RemainsStart) AS RemainsStart
                                , SUM (tmp.RemainsEnd)   AS RemainsEnd
                           FROM (SELECT tmpContainer.GoodsId       AS GoodsId
                                      , tmpContainer.UnitId        AS UnitId
                                      , tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0)  AS RemainsStart
                                      , tmpContainer.Amount - SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS RemainsEnd
                                 FROM tmpContainer                                                        
                                      LEFT JOIN MovementItemContainer AS MIContainer
                                                                      ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                                     AND MIContainer.OperDate >= inStartDate
                                                                     AND MIContainer.DescId = zc_Container_Count()
                                 GROUP BY tmpContainer.ContainerId
                                        , tmpContainer.GoodsId
                                        , tmpContainer.Amount
                                        , tmpContainer.UnitId
                                 HAVING (tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0)) <> 0
                                     OR (tmpContainer.Amount - SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END)) <> 0
                                 ) AS tmp
                           GROUP BY tmp.GoodsId
                                  , tmp.UnitId
                          )
      , tmpPrice AS (SELECT Price_Goods.ChildObjectId           AS GoodsId
                          , ObjectLink_Price_Unit.ChildObjectId AS UnitId
                          , ObjectLink_Price_Unit.ObjectId      AS PriceId
                     FROM tmpUnit
                          INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                                ON ObjectLink_Price_Unit.ChildObjectId = tmpUnit.UnitId
                                               AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                          INNER JOIN ObjectLink AS Price_Goods
                                                ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                               AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                               AND Price_Goods.ChildObjectId IN (SELECT DISTINCT tmpData_MI.GoodsId FROM tmpData_MI)
                     )

      , tmpOH_Price_Start AS (SELECT ObjectHistory.*
                              FROM ObjectHistory
                              WHERE ObjectHistory.ObjectId IN (SELECT DISTINCT tmpPrice.PriceId FROM tmpPrice)
                                AND ObjectHistory.DescId = zc_ObjectHistory_Price()
                                AND inStartDate >= ObjectHistory.StartDate AND inStartDate < ObjectHistory.EndDate
                              )
      , tmpOH_Price_End AS (SELECT ObjectHistory.*
                            FROM ObjectHistory
                            WHERE ObjectHistory.ObjectId IN (SELECT DISTINCT tmpPrice.PriceId FROM tmpPrice)
                              AND ObjectHistory.DescId = zc_ObjectHistory_Price()
                              AND inEndDate >= ObjectHistory.StartDate AND inEndDate < ObjectHistory.EndDate
                            )

      , tmpOHFloat_Start AS (SELECT ObjectHistoryFloat.*
                             FROM ObjectHistoryFloat
                             WHERE ObjectHistoryFloat.ObjectHistoryId IN (SELECT DISTINCT tmpOH_Price_Start.Id FROM tmpOH_Price_Start)
                               AND ObjectHistoryFloat.DescId = zc_ObjectHistoryFloat_Price_Value()
                            )
      , tmpOHFloat_End AS (SELECT ObjectHistoryFloat.*
                           FROM ObjectHistoryFloat
                           WHERE ObjectHistoryFloat.ObjectHistoryId IN (SELECT DISTINCT tmpOH_Price_End.Id FROM tmpOH_Price_End)
                             AND ObjectHistoryFloat.DescId = zc_ObjectHistoryFloat_Price_Value()
                          )

      -- для остатка получаем значение цены
      , tmpPriceRemains AS ( SELECT tmpRemains.GoodsId                                  AS GoodsId
                                  , tmpRemains.UnitId                                   AS UnitId
                                  , COALESCE (ObjectHistoryFloat_Price.ValueData, 0)    AS Price_RemainsStart
                                  , COALESCE (ObjectHistoryFloat_PriceEnd.ValueData, 0) AS Price_RemainsEnd
                             FROM tmpRemains_All AS tmpRemains
                                LEFT JOIN tmpPrice ON tmpPrice.GoodsId = tmpRemains.GoodsId
                                                  AND tmpPrice.unitid  = tmpRemains.UnitId
                                -- получаем значения цены из истории значений на начало дня 

                                LEFT JOIN tmpOH_Price_Start AS ObjectHistory_Price
                                                            ON ObjectHistory_Price.ObjectId = tmpPrice.PriceId 

                                LEFT JOIN tmpOHFloat_Start AS ObjectHistoryFloat_Price
                                                           ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id

                                -- получаем значения цены из истории значений на конеч. дату                                                          
                                LEFT JOIN tmpOH_Price_End AS ObjectHistory_PriceEnd
                                                          ON ObjectHistory_PriceEnd.ObjectId = tmpPrice.PriceId 

                                LEFT JOIN tmpOHFloat_End AS ObjectHistoryFloat_PriceEnd
                                                         ON ObjectHistoryFloat_PriceEnd.ObjectHistoryId = ObjectHistory_PriceEnd.Id
                              )

      , tmpRemains AS (SELECT tmpRemains_All.UnitId
                            , tmpRemains_All.GoodsId
                            , SUM (tmpRemains_All.RemainsStart) AS RemainsStart
                            , SUM (tmpRemains_All.RemainsEnd)   AS RemainsEnd
                            , SUM (tmpRemains_All.RemainsStart * tmpPriceRemains.Price_RemainsStart) AS SummaRemainsStart
                            , SUM (tmpRemains_All.RemainsEnd * tmpPriceRemains.Price_RemainsEnd)     AS SummaRemainsEnd
                       FROM tmpRemains_All
                            LEFT JOIN tmpPriceRemains ON tmpPriceRemains.GoodsId = tmpRemains_All.GoodsId
                                                     AND tmpPriceRemains.UnitId  = tmpRemains_All.UnitId
                       GROUP BY tmpRemains_All.UnitId
                              , tmpRemains_All.GoodsId
                      )
    */
--------------------------

        -- Результат   
        SELECT
             Object_Unit.Id                       AS UnitId
           , Object_Unit.ValueData                AS UnitName
           , Object_Goods.Id                      AS GoodsId
           , Object_Goods.ObjectCode    ::Integer AS GoodsCode
           , Object_Goods.ValueData               AS GoodsName
           , Object_GoodsGroup.ValueData          AS GoodsGroupName
  
           , tmpData.Amount_income     ::TFloat AS Amount_income
           , CASE WHEN COALESCE (tmpData.Amount_income,0) <> 0 THEN tmpData.SummaWithVAT / tmpData.Amount_income ELSE 0 END     ::TFloat AS PriceWithVAT_income
           , CASE WHEN COALESCE (tmpData.Amount_income,0) <> 0 THEN tmpData.SummaSale_income / tmpData.Amount_income ELSE 0 END ::TFloat AS PriceSale_income
           
           , CASE WHEN COALESCE (tmpData.SummaWithVAT,0) <> 0 THEN  ((tmpData.SummaSale_income / tmpData.SummaWithVAT)-1)*100 ELSE 0 END  ::TFloat AS MarginPercent
           , tmpData.SummaWithVAT      ::TFloat AS SummaWithVAT
           , tmpData.SummaSale_income  ::TFloat AS SummaSale_income
           
           , tmpData.Amount_sale       ::TFloat AS Amount_sale
           , CASE WHEN COALESCE (tmpData.Amount_sale,0) <> 0 THEN tmpData.SummaSale_sale / tmpData.Amount_sale ELSE 0 END ::TFloat AS PriceSale_sale
           , tmpData.SummaSale_sale    ::TFloat AS SummaSale_sale

           , (COALESCE (tmpData.Amount_income,0) - COALESCE (tmpData.Amount_sale,0) ) ::TFloat AS Amount_diff

           , COALESCE(Object_Goods_Retail.isTOP, false)           :: Boolean AS isTOP
           , COALESCE(Object_Goods_Retail.isFirst, False)         :: Boolean AS isFirst
           , COALESCE(Object_Goods_Retail.isSecond, False)        :: Boolean AS isSecond
           , COALESCE(Object_Goods_Main.isClose, False)           :: Boolean AS isClose
           , COALESCE(Object_Goods_Main.isResolution_224, False)  :: Boolean AS isResolution_224
           , CASE WHEN COALESCE (GoodsPromo.GoodsId,0) <> 0 THEN TRUE ELSE FALSE END AS isPromo
           , COALESCE (tmpGoodsSP.isSP, False)                    :: Boolean AS isSP
        FROM tmpData
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpData.UnitId
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
            
            LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = tmpData.GoodsId 
            LEFT JOIN Object_Goods_Main   ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

            -- группа товара
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = Object_Goods_Main.GoodsGroupId
                                                   
            LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId = tmpData.GoodsId

            LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = Object_Goods_Retail.GoodsMainId

        ORDER BY Object_GoodsGroup.ValueData
               , Object_Goods.ValueData ;
----

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.04.20         *
*/

-- тест
-- select * from gpReport_IncomeSale_UseNDSKind(inStartDate := ('01.04.2020')::TDateTime, inEndDate := ('27.04.2020')::TDateTime, inJuridicalId := 0, inUnitId := 0 , inRetailId:= 0, inisUnitList := TRUE ,  inSession := '3');