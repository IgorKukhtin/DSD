-- Function:  gpReport_OverOrder()

DROP FUNCTION IF EXISTS gpReport_OverOrder (TDateTime, TDateTime, Integer, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION  gpReport_OverOrder(
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inRetailId         Integer ,
    IN inJuridicalId      Integer ,
    IN inUnitId           TVarChar,--Integer  ,  -- Подразделение
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIndex Integer;
   DECLARE vbObjectId Integer;
  
   DECLARE Cursor1 refcursor;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- определяется <Торговая сеть>
    --vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

    -- таблица
    CREATE TEMP TABLE _tmpUnit_List (UnitId Integer) ON COMMIT DROP;

    -- парсим подразделения
    vbIndex := 1;
    WHILE SPLIT_PART (inUnitId, ',', vbIndex) <> '' LOOP
        -- добавляем то что нашли
        INSERT INTO _tmpUnit_List (UnitId) SELECT SPLIT_PART (inUnitId, ',', vbIndex) :: Integer;
        -- теперь следуюющий
        vbIndex := vbIndex + 1;
    END LOOP;
    
    -- 
    OPEN Cursor1 FOR
     
    -- Результат
          WITH
          -- все подразделения торговой сети
          tmpUnits AS (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                       FROM ObjectLink AS ObjectLink_Unit_Juridical
                           INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                AND (ObjectLink_Juridical_Retail.ChildObjectId = inRetailId OR inRetailId = 0)
                       WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                        AND (ObjectLink_Unit_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
                        AND inUnitId = '0'
                      )
                       
        , tmpUnit AS (SELECT _tmpUnit_List.UnitId
                      FROM _tmpUnit_List
                     UNION All
                      SELECT tmpUnits.UnitId
                      FROM tmpUnits
                     )            
          -- таблица остатков
        , tmpContainer AS (SELECT Container.Id AS ContainerId
                                , Container.ObjectId  
                                , Container.WhereObjectId 
                                , Container.Amount 
                           FROM Container 
                                INNER JOIN tmpUnit ON Container.WhereObjectId = tmpUnit.Unitid
                           WHERE Container.DescId = zc_Container_Count()
                             AND Container.Amount <> 0
                           GROUP BY Container.Id, Container.ObjectId, Container.Amount, Container.WhereObjectId
                           )
        , tmpRemains_All AS (SELECT tmp.GoodsId
                                  , tmp.UnitId
                                  , SUM (tmp.RemainsStart) AS RemainsStart
                                  , SUM (tmp.RemainsEnd)   AS RemainsEnd
                             FROM (SELECT tmpContainer.ObjectId       AS GoodsId
                                        , tmpContainer.WhereObjectId  AS UnitId
                                        , tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0)  AS RemainsStart
                                        , tmpContainer.Amount - SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS RemainsEnd
                                   FROM tmpContainer                                                        
                                        LEFT JOIN MovementItemContainer AS MIContainer
                                                                        ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                                       AND MIContainer.OperDate >= inStartDate
                                                                       AND MIContainer.DescId = zc_Container_Count()
                                   GROUP BY tmpContainer.ContainerId, tmpContainer.ObjectId, tmpContainer.Amount, tmpContainer.WhereObjectId
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
                            LEFT JOIN ObjectLink AS Price_Goods
                                                 ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
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
                                                                                           
                                  LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                                          ON ObjectHistory_Price.ObjectId = tmpPrice.PriceId 
                                                         AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                                         AND DATE_TRUNC ('DAY', inStartDate) >= ObjectHistory_Price.StartDate AND DATE_TRUNC ('DAY', inStartDate) < ObjectHistory_Price.EndDate
                                  LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                                               ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id
                                                              AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_Price_Value()
                                  -- получаем значения цены из истории значений на конеч. дату                                                          
                                  LEFT JOIN ObjectHistory AS ObjectHistory_PriceEnd
                                                          ON ObjectHistory_PriceEnd.ObjectId = tmpPrice.PriceId 
                                                         AND ObjectHistory_PriceEnd.DescId = zc_ObjectHistory_Price()
                                                         AND DATE_TRUNC ('DAY', inEndDate) >= ObjectHistory_PriceEnd.StartDate AND DATE_TRUNC ('DAY', inEndDate) < ObjectHistory_PriceEnd.EndDate
                                  LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceEnd
                                                               ON ObjectHistoryFloat_PriceEnd.ObjectHistoryId = ObjectHistory_PriceEnd.Id
                                                              AND ObjectHistoryFloat_PriceEnd.DescId = zc_ObjectHistoryFloat_Price_Value()
                                )
        , tmpRemains AS (SELECT tmpRemains_All.GoodsId
                              , SUM (tmpRemains_All.RemainsStart) AS RemainsStart
                              , SUM (tmpRemains_All.RemainsEnd)   AS RemainsEnd
                              , SUM (tmpRemains_All.RemainsStart * tmpPriceRemains.Price_RemainsStart) AS SummaRemainsStart
                              , SUM (tmpRemains_All.RemainsEnd * tmpPriceRemains.Price_RemainsEnd)     AS SummaRemainsEnd
                         FROM tmpRemains_All
                              LEFT JOIN tmpPriceRemains ON tmpPriceRemains.GoodsId = tmpRemains_All.GoodsId
                                                       AND tmpPriceRemains.UnitId   = tmpRemains_All.UnitId
                         GROUP BY tmpRemains_All.GoodsId
                        )
        , tmpIncomeMov AS (SELECT DISTINCT Movement_Income.Id
                           FROM MovementDate AS MovementDate_Branch
                                INNER JOIN Movement AS Movement_Income 
                                                    ON Movement_Income.Id = MovementDate_Branch.MovementId
                                                   AND Movement_Income.DescId = zc_Movement_Income()
                                                   AND Movement_Income.StatusId = zc_Enum_Status_Complete()
                                INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                              ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                                             AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_To.ObjectId
                           WHERE MovementDate_Branch.DescId = zc_MovementDate_Branch()
                             AND MovementDate_Branch.ValueData >= inStartDate AND MovementDate_Branch.ValueData < inEndDate + INTERVAL '1 Day'
                           ) 

        , tmpIncomeMI AS (SELECT MI_Income.*
                          FROM tmpIncomeMov AS Movement_Income
                               INNER JOIN MovementItem AS MI_Income 
                                                       ON MI_Income.MovementId = Movement_Income.Id
                                                      AND MI_Income.isErased   = False
                          ) 
        , tmpMIF_PriceSale AS (SELECT MIFloat_PriceSale.*
                               FROM MovementItemFloat AS MIFloat_PriceSale
                               WHERE MIFloat_PriceSale.DescId = zc_MIFloat_Price()     
                                 AND MIFloat_PriceSale.MovementItemId IN (SELECT tmpIncomeMI.Id FROM tmpIncomeMI)
                                 ) 

        , tmpIncome AS (SELECT MI_Income.ObjectId                     AS GoodsId
                             , SUM (COALESCE (MI_Income.Amount, 0))   AS AmountIncome
                             , SUM ((COALESCE (MI_Income.Amount, 0) * MIFloat_PriceSale.ValueData) ::NUMERIC (16, 2))   AS SummaIncome      
                        FROM tmpIncomeMI AS MI_Income
                             LEFT JOIN tmpMIF_PriceSale AS MIFloat_PriceSale
                                                        ON MIFloat_PriceSale.MovementItemId = MI_Income.Id
                        GROUP BY MI_Income.ObjectId
                        ) 

        , tmpOrderMov AS (SELECT Movement_Order.Id
                          FROM Movement AS Movement_Order
                               INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                             ON MovementLinkObject_To.MovementId = Movement_Order.Id
                                                            AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                               INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_To.ObjectId
                        WHERE Movement_Order.DescId = zc_Movement_OrderExternal()
                          AND Movement_Order.StatusId = zc_Enum_Status_Complete() 
                          AND Movement_Order.OperDate >= inStartDate AND Movement_Order.OperDate < inEndDate + INTERVAL '1 Day'
                        GROUP BY Movement_Order.Id
                       )                          
        , tmpOrder AS (SELECT MI_Order.ObjectId                     AS GoodsId
                            , SUM (COALESCE (MI_Order.Amount, 0))   AS AmountOrder
                            , SUM ((COALESCE (MI_Order.Amount, 0) * MIFloat_Price.ValueData) ::NUMERIC (16, 2))   AS SummaOrder    
                       FROM tmpOrderMov AS Movement_Order
                            INNER JOIN MovementItem AS MI_Order
                                                    ON MI_Order.MovementId = Movement_Order.Id
                                                   AND MI_Order.isErased   = False

                            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                        ON MIFloat_Price.MovementItemId = MI_Order.Id
                                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()  
                       GROUP BY MI_Order.ObjectId
                       )  

        , tmpCheckMov_All AS (SELECT Movement_Check.Id
                              FROM Movement AS Movement_Check
                              WHERE Movement_Check.DescId = zc_Movement_Check()
                                AND Movement_Check.OperDate >= inStartDate AND Movement_Check.OperDate < inEndDate + INTERVAL '1 Day'
                                AND Movement_Check.StatusId = zc_Enum_Status_Complete()
                              GROUP BY Movement_Check.Id
                             )
        , tmpMLO_Unit AS (SELECT MovementLinkObject_Unit.*
                          FROM MovementLinkObject AS MovementLinkObject_Unit
                          WHERE MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                            AND MovementLinkObject_Unit.MovementId IN (SELECT tmpCheckMov_All.Id FROM tmpCheckMov_All)
                            AND MovementLinkObject_Unit.ObjectId IN ( SELECT tmpUnit.UnitId FROM tmpUnit)
                          )

        , tmpCheckMov AS (SELECT Movement_Check.Id
                          FROM tmpCheckMov_All AS Movement_Check
                               INNER JOIN tmpMLO_Unit AS MovementLinkObject_Unit
                                                      ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                          GROUP BY Movement_Check.Id
                          )
        , tmpCheckMI AS (SELECT MI_Check.*
                         FROM tmpCheckMov AS Movement_Check
                              INNER JOIN MovementItem AS MI_Check
                                      ON MI_Check.MovementId = Movement_Check.Id
                                     AND MI_Check.DescId = zc_MI_Master()
                                     AND MI_Check.isErased = FALSE
                         )
        , tmpMIF_Price AS (SELECT MIFloat_Price.*
                           FROM MovementItemFloat AS MIFloat_Price
                           WHERE MIFloat_Price.DescId = zc_MIFloat_Price()     
                             AND MIFloat_Price.MovementItemId IN (SELECT tmpCheckMI.Id FROM tmpCheckMI)
                             ) 
        , tmpMIContainer AS (SELECT MIContainer.*
                             FROM  MovementItemContainer AS MIContainer
                             WHERE MIContainer.DescId = zc_MIContainer_Count()  
                               AND MIContainer.MovementItemId IN (SELECT tmpCheckMI.Id FROM tmpCheckMI)
                             )
        , tmpCheck AS (SELECT MI_Check.ObjectId                                       AS GoodsId
                            , SUM(COALESCE(- MIContainer.Amount, MI_Check.Amount))     AS AmountSale
                            , SUM(COALESCE(- MIContainer.Amount, MI_Check.Amount)*MIFloat_Price.ValueData) AS SummaSale
                      FROM tmpCheckMI AS MI_Check
                         LEFT JOIN tmpMIF_Price AS MIFloat_Price
                                                ON MIFloat_Price.MovementItemId = MI_Check.Id
                         LEFT JOIN tmpMIContainer AS MIContainer
                                                  ON MIContainer.MovementItemId = MI_Check.Id
                      GROUP BY MI_Check.ObjectId
                      HAVING SUM(MI_Check.Amount) <> 0 
                    )
        -- список товаров
        , tmpGoods AS (SELECT DISTINCT tmpRemains.GoodsId
                       FROM tmpRemains
                      UNION 
                       SELECT DISTINCT tmpCheck.GoodsId
                       FROM tmpCheck
                      UNION 
                       SELECT DISTINCT tmpOrder.GoodsId
                       FROM tmpOrder
                      UNION 
                       SELECT DISTINCT tmpIncome.GoodsId
                       FROM tmpIncome
                      )                                                               
     
        -- Маркетинговый контракт
        , GoodsPromo AS (SELECT DISTINCT ObjectLink_Child_retail.ChildObjectId AS GoodsId  -- здесь товар "сети"
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
        -- свойства товаров
        , tmpObjectLink AS (SELECT ObjectLink.*
                            FROM ObjectLink
                            WHERE ObjectLink.ObjectId IN (SELECT DISTINCT tmpGoods.GoodsId FROM tmpGoods)
                              AND ObjectLink.DescId IN (zc_ObjectLink_Goods_ConditionsKeep()
                                                      , zc_ObjectLink_Goods_GoodsGroup()
                                                      , zc_ObjectLink_Goods_NDSKind())
                                                      
                              and 1 = 0
                           )
        , tmpObjectBoolean AS (SELECT ObjectBoolean.*
                               FROM ObjectBoolean
                               WHERE ObjectBoolean.ObjectId IN (SELECT DISTINCT tmpGoods.GoodsId FROM tmpGoods)
                                 AND ObjectBoolean.DescId IN (zc_ObjectBoolean_Goods_Close()
                                                            , zc_ObjectBoolean_Goods_TOP()
                                                            , zc_ObjectBoolean_Goods_First()
                                                            , zc_ObjectBoolean_Goods_Second())
                              and 1 = 0
                              )
        , tmpObjectFloat AS (SELECT ObjectFloat.*
                             FROM ObjectFloat
                             WHERE ObjectFloat.ObjectId IN (SELECT DISTINCT tmpObjectLink.ChildObjectId FROM tmpObjectLink)
                               AND ObjectFloat.DescId = zc_ObjectFloat_NDSKind_NDS()
                              and 1 = 0
                            )
        , tmpObjectDate AS (SELECT ObjectDate.*
                            FROM ObjectDate
                            WHERE ObjectDate.ObjectId IN (SELECT DISTINCT tmpGoods.GoodsId FROM tmpGoods)
                              AND ObjectDate.DescId = zc_ObjectDate_Protocol_Update()
                           )

        , tmpMainParam AS (SELECT ObjectLink_Child.ChildObjectId                                AS GoodsId
                                , COALESCE (ObjectBoolean_Goods_SP.ValueData,False) :: Boolean  AS isSP
                           FROM ObjectLink AS ObjectLink_Child 
                                LEFT JOIN  ObjectLink AS ObjectLink_Main 
                                                      ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                     AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                
                                LEFT JOIN  ObjectBoolean AS ObjectBoolean_Goods_SP 
                                                         ON ObjectBoolean_Goods_SP.ObjectId = ObjectLink_Main.ChildObjectId 
                                                        AND ObjectBoolean_Goods_SP.DescId = zc_ObjectBoolean_Goods_SP()  
                           WHERE ObjectLink_Child.ChildObjectId IN (SELECT DISTINCT tmpGoods.GoodsId FROM tmpGoods)
                             AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                              and 1 = 0
                           )
                      
        -- результат      
        SELECT Object_Goods.Id                                                   AS GoodsId
             , Object_Goods.ObjectCode                                           AS GoodsCode
             , Object_Goods.ValueData                                            AS GoodsName
             , Object_GoodsGroup.ValueData                                       AS GoodsGroupName
             , Object_NDSKind.ValueData                                          AS NDSKindName
             , ObjectFloat_NDSKind_NDS.ValueData                                 AS NDS
             , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar          AS ConditionsKeepName      
             , COALESCE(ObjectBoolean_Goods_Close.ValueData, False)  :: Boolean  AS isClose
             , COALESCE(ObjectDate_Update.ValueData, Null)          ::TDateTime  AS UpdateDate   
             
             , COALESCE(ObjectBoolean_Goods_TOP.ValueData, false)    :: Boolean  AS isTOP
             , COALESCE(ObjectBoolean_Goods_First.ValueData, False)  :: Boolean  AS isFirst
             , COALESCE(ObjectBoolean_Goods_Second.ValueData, False) :: Boolean  AS isSecond
             
             , COALESCE (tmpMainParam.isSP, False)                   :: Boolean  AS isSP
             , CASE WHEN COALESCE(GoodsPromo.GoodsId,0) <> 0 THEN TRUE ELSE FALSE END AS isPromo
                                                                              
             , tmpRemains.RemainsStart                                 :: TFloat AS RemainsStart
             , tmpRemains.RemainsEnd                                   :: TFloat AS RemainsEnd
             , tmpRemains.SummaRemainsStart                            :: TFloat AS SummaRemainsStart
             , tmpRemains.SummaRemainsEnd                              :: TFloat AS SummaRemainsEnd
                          
             , tmpIncome.AmountIncome                                  :: TFloat AS AmountIncome
             , tmpIncome.SummaIncome                                   :: TFloat AS SummaIncome

             , tmpOrder.AmountOrder                                    :: TFloat AS AmountOrder
             , (tmpOrder.SummaOrder * (1 + ObjectFloat_NDSKind_NDS.ValueData/100))  :: TFloat AS SummaOrder               -- c НДС   * (1 + ObjectFloat_NDSKind_NDS.ValueData/100)
             , tmpCheck.AmountSale                                     :: TFloat AS AmountSale
             , tmpCheck.SummaSale                                      :: TFloat AS SummaSale
             
             , CASE WHEN COALESCE (tmpOrder.AmountOrder, 0) <> 0 THEN (tmpIncome.AmountIncome * 100 / tmpOrder.AmountOrder) - 100  ELSE 0 END                   AS AmountPersent
             , CASE WHEN COALESCE (tmpOrder.SummaOrder * (1 + ObjectFloat_NDSKind_NDS.ValueData/100)) <> 0 THEN (tmpIncome.SummaIncome * 100 / (tmpOrder.SummaOrder * (1 + ObjectFloat_NDSKind_NDS.ValueData/100))) - 100  ELSE 0 END SummaPersent
             
             , CASE WHEN COALESCE (tmpRemains.RemainsStart, 0) <> 0 THEN (tmpRemains.RemainsEnd * 100 / tmpRemains.RemainsStart) - 100 ELSE 0 END              AS AmountPersent_Remains
             , CASE WHEN COALESCE (tmpRemains.SummaRemainsStart) <> 0 THEN (tmpRemains.SummaRemainsEnd * 100 / tmpRemains.SummaRemainsStart) - 100 ELSE 0 END  AS SummaPersent_Remains

        FROM tmpGoods

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoods.GoodsId              
             LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId = Object_Goods.Id

             LEFT JOIN tmpRemains ON tmpRemains.GoodsId = tmpGoods.GoodsId 
             LEFT JOIN tmpCheck   ON tmpCheck.GoodsId   = tmpGoods.GoodsId 
             LEFT JOIN tmpIncome  ON tmpIncome.GoodsId  = tmpGoods.GoodsId 
             LEFT JOIN tmpOrder   ON tmpOrder.GoodsId   = tmpGoods.GoodsId 
             -- условия хранения
             LEFT JOIN tmpObjectLink AS ObjectLink_Goods_ConditionsKeep 
                                  ON ObjectLink_Goods_ConditionsKeep.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
             LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId

             LEFT JOIN tmpObjectLink AS ObjectLink_Goods_GoodsGroup
                                  ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
             LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

             LEFT JOIN tmpObjectBoolean AS ObjectBoolean_Goods_Close
                                     ON ObjectBoolean_Goods_Close.ObjectId = Object_Goods.Id
                                    AND ObjectBoolean_Goods_Close.DescId = zc_ObjectBoolean_Goods_Close()  

             LEFT JOIN tmpObjectLink AS ObjectLink_Goods_NDSKind
                                  ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
             LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId

             LEFT JOIN tmpObjectFloat AS ObjectFloat_NDSKind_NDS
                                   ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId 
                                  AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS() 

             LEFT JOIN tmpObjectDate AS ObjectDate_Update
                                  ON ObjectDate_Update.ObjectId = Object_Goods.Id
                                 AND ObjectDate_Update.DescId = zc_ObjectDate_Protocol_Update()  

             LEFT JOIN tmpObjectBoolean AS ObjectBoolean_Goods_TOP
                                     ON ObjectBoolean_Goods_TOP.ObjectId = Object_Goods.Id
                                    AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()  
             LEFT JOIN tmpObjectBoolean AS ObjectBoolean_Goods_First
                                     ON ObjectBoolean_Goods_First.ObjectId = Object_Goods.Id
                                    AND ObjectBoolean_Goods_First.DescId = zc_ObjectBoolean_Goods_First() 
             LEFT JOIN tmpObjectBoolean AS ObjectBoolean_Goods_Second
                                     ON ObjectBoolean_Goods_Second.ObjectId = Object_Goods.Id
                                    AND ObjectBoolean_Goods_Second.DescId = zc_ObjectBoolean_Goods_Second() 

             LEFT JOIN tmpMainParam ON tmpMainParam.GoodsId = Object_Goods.Id
    ;
    RETURN NEXT Cursor1;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 07.01.18         *
 04.09.17         *
*/

-- тест
--select * from gpReport_OverOrder(inStartDate := ('01.08.2017')::TDateTime, inEndDate := ('01.08.2017')::TDateTime , inRetailId := 0, inJuridicalId := 0 , inUnitId := '183294,375626,389328'::TVarChar, inSession := '3'::TVarChar);
-- FETCH ALL "<unnamed portal 14>";----