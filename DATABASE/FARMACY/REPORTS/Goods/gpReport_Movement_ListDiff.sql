-- Function:  gpReport_Movement_Income()

DROP FUNCTION IF EXISTS gpReport_Movement_ListDiff (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Movement_ListDiff(
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inJuridicalId      Integer  ,
    IN inUnitId           Integer  ,  -- Подразделение
    IN inRetailId         Integer  ,  -- ссылка на торг.сеть
    IN inDiffKindId       Integer  ,
    IN inisUnitList       Boolean  ,  -- 
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsId        Integer, 
               GoodsCode      Integer, 
               GoodsName      TVarChar,
               GoodsGroupName TVarChar,
               DiffKindId     Integer,
               DiffKindName   TVarChar,
               Price          TFloat,
               Amount         TFloat,
               Summa          TFloat,
               AmountSale     TFloat,
               SummaSale      TFloat,
               AmountIncome   TFloat,
               SummaIncome    TFloat,
               AmountDiff     TFloat,
               SummaDiff      TFloat,
               RemainsStart      TFloat,
               RemainsEnd        TFloat,
               SummaRemainsStart TFloat,
               SummaRemainsEnd   TFloat,
               isTOP    Boolean,
               isFirst  Boolean,
               isSecond Boolean,
               isClose  Boolean,
               isPromo  Boolean,
               isSP     Boolean
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

      -- Виды отказов
      , tmpDiffKind AS (SELECT Object_DiffKind.Id                     AS Id
                             , Object_DiffKind.ObjectCode             AS Code
                             , Object_DiffKind.ValueData              AS Name
                             , COALESCE (ObjectBoolean_DiffKind_Close.ValueData, FALSE) AS isClose
                        FROM Object AS Object_DiffKind
                             LEFT JOIN ObjectBoolean AS ObjectBoolean_DiffKind_Close
                                                     ON ObjectBoolean_DiffKind_Close.ObjectId = Object_DiffKind.Id
                                                    AND ObjectBoolean_DiffKind_Close.DescId = zc_ObjectBoolean_DiffKind_Close()   
                        WHERE Object_DiffKind.DescId = zc_Object_DiffKind()
                          AND Object_DiffKind.isErased = FALSE
                        )

      , tmpMovement AS (SELECT Movement_ListDiff.Id             AS Id
                                     , MovementLinkObject_Unit.ObjectId AS UnitId
                                FROM Movement AS Movement_ListDiff
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                   ON MovementLinkObject_Unit.MovementId = Movement_ListDiff.Id
                                                                  AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                     INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
                                WHERE Movement_ListDiff.DescId = zc_Movement_ListDiff()
                                  AND Movement_ListDiff.OperDate >= inStartDate
                                  AND Movement_ListDiff.OperDate < inEndDate + INTERVAL '1 DAY'
                              )

      , tmpData_MI AS (SELECT /*COALESCE (MIFloat_OrderId.ValueData       :: Integer AS MovementId_Order
                            , */MovementItem.ObjectId                                AS GoodsId
                            , MILO_DiffKind.ObjectId                               AS DiffKindId
                            , MI_Float_Price.ValueData                             AS Price
                            , SUM (MovementItem.Amount)                            AS Amount
                            , SUM (MI_Float_Price.ValueData * MovementItem.Amount) AS Summa
                       FROM tmpMovement
                            INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                   AND MovementItem.isErased   = FALSE
                            LEFT JOIN MovementItemLinkObject AS MILO_DiffKind
                                                             ON MILO_DiffKind.MovementItemId = MovementItem.Id
                                                            AND MILO_DiffKind.DescId = zc_MILinkObject_DiffKind()
                            LEFT JOIN MovementItemFloat AS MIFloat_OrderId
                                                        ON MIFloat_OrderId.MovementItemId = MovementItem.Id
                                                       AND MIFloat_OrderId.DescId         = zc_MIFloat_MovementId()
                            LEFT JOIN MovementItemFloat AS MI_Float_Price
                                                        ON MI_Float_Price.MovementItemId = MovementItem.Id
                                                       AND MI_Float_Price.DescId = zc_MIFloat_Price()
                       WHERE MILO_DiffKind.ObjectId = inDiffKindId OR inDiffKindId = 0
                       GROUP BY /*COALESCE (MIFloat_OrderId.ValueData
                              , */MovementItem.ObjectId
                              , MILO_DiffKind.ObjectId
                              , MI_Float_Price.ValueData
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
                                                       --  AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                         )

       -- Товары соц-проект (документ)
        , tmpGoodsSP AS (SELECT DISTINCT tmp.GoodsId, TRUE AS isSP
                         FROM lpSelect_MovementItem_GoodsSPUnit_onDate (inStartDate:= inStartDate, inEndDate:= inEndDate, inUnitId := inUnitId) AS tmp
                         )

      -- продажи
      , tmpCheck AS (SELECT --MIContainer.WhereObjectId_analyzer          AS UnitId
                            MIContainer.ObjectId_analyzer               AS GoodsId
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Check() THEN COALESCE (-1 * MIContainer.Amount, 0) ELSE 0 END) AS Amount
                          , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Check() THEN COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0) ELSE 0 END) AS SummaSale

                     FROM MovementItemContainer AS MIContainer
                          INNER JOIN tmpUnit ON tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer
                          INNER JOIN (SELECT DISTINCT tmpData_MI.GoodsId FROM tmpData_MI) AS tmpGoods ON tmpGoods.GoodsId = MIContainer.ObjectId_analyzer
                     WHERE MIContainer.DescId = zc_MIContainer_Count()
                       AND MIContainer.MovementDescId = zc_Movement_Check()
                       AND MIContainer.OperDate >= inStartDate AND MIContainer.OperDate < inEndDate + INTERVAL '1 DAY'
                     GROUP BY MIContainer.ObjectId_analyzer 
                            --, MIContainer.WhereObjectId_analyzer
                     HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
                     )
      , tmpIncome AS (SELECT -- MovementLinkObject_To.ObjectId          AS UnitId
                             MI_Income.ObjectId                      AS GoodsId
                           , SUM(COALESCE (MI_Income.Amount, 0))     AS AmountIncome  
                           , SUM(COALESCE (MI_Income.Amount, 0) * COALESCE(MIFloat_PriceSale.ValueData,0))  AS SummSale_Income    
                      FROM Movement AS Movement_Income
                           INNER JOIN MovementDate AS MovementDate_Branch
                                                   ON MovementDate_Branch.MovementId = Movement_Income.Id
                                                  AND MovementDate_Branch.DescId = zc_MovementDate_Branch()
                                                  AND MovementDate_Branch.ValueData >= inStartDate AND MovementDate_Branch.ValueData < inEndDate + INTERVAL '1 DAY'
                            
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                         ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                       -- AND MovementLinkObject_To.ObjectId = 183292
                           INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_To.ObjectId
                          
                           LEFT JOIN MovementItem AS MI_Income 
                                                  ON MI_Income.MovementId = Movement_Income.Id
                                                 AND MI_Income.isErased   = False
                           INNER JOIN (SELECT DISTINCT tmpData_MI.GoodsId FROM tmpData_MI) AS tmpGoods ON tmpGoods.GoodsId = MI_Income.ObjectId

                           LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                       ON MIFloat_PriceSale.MovementItemId = MI_Income.Id
                                                      AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()

                       WHERE Movement_Income.DescId = zc_Movement_Income()
                         AND Movement_Income.StatusId = zc_Enum_Status_Complete() 
                       GROUP BY MI_Income.ObjectId
                    )   


          -- таблица остатков
        , tmpContainer AS (SELECT Container.Id            AS ContainerId
                                , Container.ObjectId      AS GoodsId
                                , Container.WhereObjectId AS UnitId
                                , Container.Amount        AS Amount
                           FROM Container 
                           WHERE Container.DescId = zc_Container_Count()
                             AND Container.WhereObjectId IN (SELECT tmpUnit.UnitId FROM tmpUnit)
                             AND Container.Amount <> 0
                             AND Container.ObjectId IN (SELECT DISTINCT tmpData_MI.GoodsId FROM tmpData_MI)
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
                                                                 -- AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                                                 -- AND inStartDate >= ObjectHistory_Price.StartDate AND inStartDate < ObjectHistory_Price.EndDate
                                  LEFT JOIN tmpOHFloat_Start AS ObjectHistoryFloat_Price
                                                             ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id
                                                            --AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_Price_Value()
                                  -- получаем значения цены из истории значений на конеч. дату                                                          
                                  LEFT JOIN tmpOH_Price_End AS ObjectHistory_PriceEnd
                                                          ON ObjectHistory_PriceEnd.ObjectId = tmpPrice.PriceId 
                                                       --  AND ObjectHistory_PriceEnd.DescId = zc_ObjectHistory_Price()
                                                       --  AND inEndDate >= ObjectHistory_PriceEnd.StartDate AND inEndDate < ObjectHistory_PriceEnd.EndDate
                                  LEFT JOIN tmpOHFloat_End AS ObjectHistoryFloat_PriceEnd
                                                           ON ObjectHistoryFloat_PriceEnd.ObjectHistoryId = ObjectHistory_PriceEnd.Id
                                                          --AND ObjectHistoryFloat_PriceEnd.DescId = zc_ObjectHistoryFloat_Price_Value()
                                )
        , tmpRemains AS (SELECT /*tmpRemains_All.UnitId
                              , */tmpRemains_All.GoodsId
                              , SUM (tmpRemains_All.RemainsStart) AS RemainsStart
                              , SUM (tmpRemains_All.RemainsEnd)   AS RemainsEnd
                              , SUM (tmpRemains_All.RemainsStart * tmpPriceRemains.Price_RemainsStart) AS SummaRemainsStart
                              , SUM (tmpRemains_All.RemainsEnd * tmpPriceRemains.Price_RemainsEnd)     AS SummaRemainsEnd
                         FROM tmpRemains_All
                              LEFT JOIN tmpPriceRemains ON tmpPriceRemains.GoodsId = tmpRemains_All.GoodsId
                                                       AND tmpPriceRemains.UnitId  = tmpRemains_All.UnitId
                         GROUP BY /*tmpRemains_All.UnitId
                                , */tmpRemains_All.GoodsId
                        )
--------------------------

        -- Результат   
        SELECT
             Object_Goods_View.Id                      AS GoodsId
           , Object_Goods_View.GoodsCodeInt  ::Integer AS GoodsCode
           , Object_Goods_View.GoodsName               AS GoodsName
           , Object_Goods_View.GoodsGroupName          AS GoodsGroupName
           , tmpDiffKind.Id                     AS DiffKindId
           , tmpDiffKind.Name                   AS DiffKindName
           , tmpData.Price             ::TFloat AS Price
           , tmpData.Amount            ::TFloat AS Amount
           , tmpData.Summa             ::TFloat AS Summa
           
           , tmpCheck.Amount           ::TFloat AS AmountSale
           , tmpCheck.SummaSale        ::TFloat AS SummaSale
           , tmpIncome.AmountIncome    ::TFloat AS AmountIncome
           , tmpIncome.SummSale_Income ::TFloat AS SummaIncome

           , (COALESCE (tmpData.Amount,0) - COALESCE (tmpCheck.Amount,0))    :: TFloat AS AmountDiff
           , (COALESCE (tmpData.Summa, 0) - COALESCE (tmpCheck.SummaSale,0)) :: TFloat AS SummaDiff

           , tmpRemains.RemainsStart      :: TFloat
           , tmpRemains.RemainsEnd        :: TFloat
           , tmpRemains.SummaRemainsStart :: TFloat
           , tmpRemains.SummaRemainsEnd   :: TFloat

           , COALESCE(ObjectBoolean_Goods_TOP.ValueData, false)    :: Boolean AS isTOP
           , COALESCE(ObjectBoolean_Goods_First.ValueData, False)  :: Boolean AS isFirst
           , COALESCE(ObjectBoolean_Goods_Second.ValueData, False) :: Boolean AS isSecond
           , COALESCE(ObjectBoolean_Goods_Close.ValueData, False)  :: Boolean AS isClose
           , CASE WHEN COALESCE (GoodsPromo.GoodsId,0) <> 0 THEN TRUE ELSE FALSE END AS isPromo
           , COALESCE (tmpGoodsSP.isSP, False)                     :: Boolean AS isSP
        FROM tmpData_MI AS tmpData
            LEFT JOIN Object_Goods_View ON Object_Goods_View.Id = tmpData.GoodsId
            
            LEFT JOIN tmpDiffKind ON tmpDiffKind.Id = tmpData.DiffKindId

            LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId = tmpData.GoodsId

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                        ON ObjectBoolean_Goods_TOP.ObjectId = tmpData.GoodsId
                                       AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()  
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_First
                                        ON ObjectBoolean_Goods_First.ObjectId = tmpData.GoodsId
                                       AND ObjectBoolean_Goods_First.DescId = zc_ObjectBoolean_Goods_First() 
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Second
                                        ON ObjectBoolean_Goods_Second.ObjectId = tmpData.GoodsId
                                       AND ObjectBoolean_Goods_Second.DescId = zc_ObjectBoolean_Goods_Second() 
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Close
                                        ON ObjectBoolean_Goods_Close.ObjectId = tmpData.GoodsId
                                       AND ObjectBoolean_Goods_Close.DescId = zc_ObjectBoolean_Goods_Close()  
            -- получается GoodsMainId
            LEFT JOIN ObjectLink AS ObjectLink_Child 
                                 ON ObjectLink_Child.ChildObjectId = tmpData.GoodsId
                                AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
            LEFT JOIN ObjectLink AS ObjectLink_Main
                                 ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

            LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = ObjectLink_Main.ChildObjectId
            LEFT JOIN tmpCheck   ON tmpCheck.GoodsId   = tmpData.GoodsId
            LEFT JOIN tmpIncome  ON tmpIncome.GoodsId  = tmpData.GoodsId
            
            LEFT JOIN tmpRemains ON tmpRemains.GoodsId = tmpData.GoodsId

        ORDER BY GoodsGroupName
               , GoodsName;
----

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 31.03.19                                                      * ограничение по сети
 11.02.19         * признак Товары соц-проект берем и документа
 21.12.18         *
*/

-- тест
-- select * from gpReport_Movement_ListDiff(inStartDate := ('01.12.2018')::TDateTime, inEndDate := ('12.12.2018')::TDateTime, inJuridicalId := 0, inUnitId := 0 , inRetailId:= 0 , inDiffKindId := 0, inisUnitList := TRUE ,  inSession := '3');