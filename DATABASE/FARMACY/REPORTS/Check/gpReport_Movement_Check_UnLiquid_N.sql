-- Function:  gpReport_Movement_Check_UnLiquid()

DROP FUNCTION IF EXISTS gpReport_Movement_Check_UnLiquid (Integer, TDateTime, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION  gpReport_Movement_Check_UnLiquid(
    IN inUnitId           Integer  ,  -- Подразделение
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS  SETOF refcursor
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbStartDate1 TDateTime;
   DECLARE vbStartDate3 TDateTime;
   DECLARE vbStartDate6 TDateTime;

   DECLARE Cursor1 refcursor;
   DECLARE Cursor2 refcursor;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    -- Ограничение на просмотр товарного справочника
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);


    -- отбросили время
    inStartDate:= DATE_TRUNC ('DAY', inStartDate);
    inEndDate  := DATE_TRUNC ('DAY', inEndDate);

    vbStartDate1 := inStartDate - INTERVAL '1 Month'; 
    vbStartDate3 := inStartDate - INTERVAL '3 Month';--3
    vbStartDate6 := inStartDate - INTERVAL '6 Month';--6

    CREATE TEMP TABLE _tmpCheck (GoodsId Integer, UnitId Integer, Amount_Sale TFloat, Summa_Sale TFloat, Amount_Sale1 TFloat, Summa_Sale1 TFloat, Amount_Sale3 TFloat, Summa_Sale3 TFloat, Amount_Sale6 TFloat, Summa_Sale6 TFloat, Amount TFloat, PRIMARY KEY (GoodsId,UnitId)) ON COMMIT DROP;
      INSERT INTO _tmpCheck (GoodsId, UnitId, Amount_Sale, Summa_Sale, Amount_Sale1, Summa_Sale1, Amount_Sale3, Summa_Sale3, Amount_Sale6, Summa_Sale6, Amount)
                         SELECT MIContainer.ObjectId_analyzer          AS GoodsId
                              , MIContainer.WhereObjectId_analyzer     AS UnitId
                              , SUM (CASE WHEN MIContainer.OperDate >= inStartDate AND MIContainer.OperDate < inEndDate + INTERVAL '1 DAY' THEN COALESCE (-1 * MIContainer.Amount, 0) ELSE 0 END) AS Amount_Sale
                              , SUM (CASE WHEN MIContainer.OperDate >= inStartDate AND MIContainer.OperDate < inEndDate + INTERVAL '1 DAY' THEN COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0) ELSE 0 END) AS Summa_Sale

                              , SUM (CASE WHEN MIContainer.OperDate >= vbStartDate1 AND MIContainer.OperDate < inStartDate THEN COALESCE (-1 * MIContainer.Amount, 0) ELSE 0 END) AS Amount_Sale1
                              , SUM (CASE WHEN MIContainer.OperDate >= vbStartDate1 AND MIContainer.OperDate < inStartDate THEN COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0) ELSE 0 END) AS Summa_Sale1

                              , SUM (CASE WHEN MIContainer.OperDate >= vbStartDate3 AND MIContainer.OperDate < inStartDate THEN COALESCE (-1 * MIContainer.Amount, 0) ELSE 0 END) AS Amount_Sale3
                              , SUM (CASE WHEN MIContainer.OperDate >= vbStartDate3 AND MIContainer.OperDate < inStartDate THEN COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0) ELSE 0 END) AS Summa_Sale3

                              , SUM (CASE WHEN MIContainer.OperDate < inStartDate THEN COALESCE (-1 * MIContainer.Amount, 0) ELSE 0 END) AS Amount_Sale6
                              , SUM (CASE WHEN MIContainer.OperDate < inStartDate THEN COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0) ELSE 0 END) AS Summa_Sale6
                              , SUM (COALESCE (-1 * MIContainer.Amount, 0)) AS Amount
                          FROM MovementItemContainer AS MIContainer
                          WHERE MIContainer.DescId = zc_MIContainer_Count()
                            AND MIContainer.MovementDescId = zc_Movement_Check()
                            AND MIContainer.WhereObjectId_analyzer <> inUnitId  
                            AND MIContainer.OperDate >= vbStartDate6 AND MIContainer.OperDate < inEndDate + INTERVAL '1 Day'
                           -- AND MIContainer.OperDate >= '03.06.2016' AND MIContainer.OperDate < '01.12.2016'
                          GROUP BY MIContainer.ObjectId_analyzer, MIContainer.WhereObjectId_analyzer
                          HAVING sum(COALESCE (-1 * MIContainer.Amount, 0)) <> 0
                        ; 

    -- таблица результат неликвидных товаров для выбранного подразделния
    CREATE TEMP TABLE _tmpData (UnitId Integer, GoodsId Integer, MinExpirationDate TDateTime, OperDate_LastIncome TDateTime, Term TFloat
                              , Amount_LastIncome TFloat, RemainsStart TFloat, RemainsEnd TFloat
                              , Amount_Sale TFloat, Summa_Sale TFloat
                              , Amount_Sale1 TFloat, Summa_Sale1 TFloat
                              , Amount_Sale3 TFloat, Summa_Sale3 TFloat
                              , Amount_Sale6 TFloat, Summa_Sale6 TFloat
                              , isSaleAnother Boolean)  ON COMMIT DROP;
      INSERT INTO _tmpData (UnitId, GoodsId, MinExpirationDate, OperDate_LastIncome, Term, Amount_LastIncome, RemainsStart, RemainsEnd
                          , Amount_Sale, Summa_Sale, Amount_Sale1, Summa_Sale1, Amount_Sale3, Summa_Sale3, Amount_Sale6, Summa_Sale6, isSaleAnother) 
      WITH 
      -- таблица остатков
      tmpContainer AS (SELECT Container.ObjectId   AS GoodsId
                            , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0)  AS RemainsStart
                            , Container.Amount - SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN COALESCE (MIContainer.Amount, 0) ELSE 0 END) AS RemainsEnd
                            , Container.Id         AS ContainerId
                       FROM Container
                            INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                  ON ObjectLink_Unit_Juridical.ObjectId = Container.WhereObjectId
                                                 AND ObjectLink_Unit_Juridical.DescId   = zc_ObjectLink_Unit_Juridical()
                            INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                  ON ObjectLink_Juridical_Retail.ObjectId      = ObjectLink_Unit_Juridical.ChildObjectId
                                                 AND ObjectLink_Juridical_Retail.DescId        = zc_ObjectLink_Juridical_Retail()
                                                 AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId
                            LEFT JOIN MovementItemContainer AS MIContainer
                                                            ON MIContainer.ContainerId = Container.Id
                                                           AND MIContainer.OperDate    >= inStartDate
                       WHERE Container.DescId        = zc_Container_Count()
                         AND Container.WhereObjectId = inUnitId
                       GROUP BY Container.Id
                              , Container.ObjectId
                              , Container.Amount
                       HAVING Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
                      )

   -- связываем с партиями
    , tmpRemains_1 AS ( SELECT tmpContainer.GoodsId
                             , Sum(tmpContainer.RemainsStart) as RemainsStart
                             , Sum(tmpContainer.RemainsEnd)   as RemainsEnd
             
                             , tmpContainer.ContainerId

                             , ROW_NUMBER() OVER (PARTITION BY tmpContainer.GoodsId ORDER BY COALESCE (Movement_Income.OperDate, NULL) DESC) AS Ord
                             , COALESCE (Movement_Income.OperDate, NULL)                  AS OperDate_Income
                             , COALESCE (MI_Income_find.Amount ,MI_Income.Amount)         AS Amount_Income
                             , COALESCE (MIDate_ExpirationDate.ValueData,zc_DateEnd())    AS MinExpirationDate -- Срок годности
                        FROM tmpContainer
                             -- находим партию
                             LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                    ON ContainerLinkObject_MovementItem.Containerid = tmpContainer.ContainerId
                                   AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                             LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                             -- элемент прихода
                             LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                             -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                             LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                    ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                   AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                             -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                             LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
        
                             LEFT JOIN MovementItemDate AS MIDate_ExpirationDate
                                    ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id) 
                                   AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()

                             LEFT JOIN Movement AS Movement_Income ON Movement_Income.Id = COALESCE (MI_Income_find.MovementId ,MI_Income.MovementId) 
                       
                        GROUP BY tmpContainer.ContainerId, tmpContainer.GoodsId
                               , COALESCE (Movement_Income.OperDate, NULL)
                               , COALESCE (MI_Income_find.Amount ,MI_Income.Amount)
                               , COALESCE (MIDate_ExpirationDate.ValueData,zc_DateEnd()) 
                )
              -- таблица остатков
    , tmpRemains AS (SELECT tmp.GoodsId
                          , SUM(tmp.RemainsStart)       AS RemainsStart
                          , SUM(tmp.RemainsEnd)         AS RemainsEnd
                          , MIN(tmp.MinExpirationDate)  AS MinExpirationDate -- Срок годности
                          , MAX(tmp.OperDate_Income)    AS MaxOperDateIncome
                          , SUM(CASE WHEN Ord = 1 THEN tmp.Amount_Income ELSE 0 END)          AS Amount_Income
                     FROM tmpRemains_1 AS tmp
                     GROUP BY tmp.GoodsId
                    )

    -- находим последние приходы товаров за выбранный период
    , tmpIncomeLast AS (SELECT tmp.GoodsId
                             , tmp.MaxOperDate      
                             , tmp.MinExpirationDate
                             , tmp.Amount
                        FROM (
                              SELECT MI_Income.ObjectId       AS GoodsId
                                   , Movement_Income.OperDate       AS MaxOperDate
                                   , COALESCE (MIDate_ExpirationDate.ValueData, zc_DateStart()) AS MinExpirationDate
                                   , MI_Income.Amount
                                   , ROW_NUMBER() OVER (PARTITION BY MI_Income.ObjectId ORDER BY Movement_Income.OperDate desc, COALESCE (MIDate_ExpirationDate.ValueData, zc_DateStart())) AS ord
                              FROM Movement AS Movement_Income
                                   -- куда был приход
                                   INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                 ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                                                AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                AND MovementLinkObject_To.ObjectId = inUnitId
                                   INNER JOIN MovementItem AS MI_Income 
                                                           ON MI_Income.MovementId = Movement_Income.Id
                                                          AND MI_Income.isErased   = False
                                   INNER JOIN tmpRemains ON tmpRemains.GoodsId = MI_Income.ObjectId
                                   LEFT JOIN MovementItemDate AS MIDate_ExpirationDate
                                                              ON MIDate_ExpirationDate.MovementItemId = MI_Income.Id
                                                             AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()  

                              WHERE Movement_Income.DescId = zc_Movement_Income()
                                AND Movement_Income.StatusId = zc_Enum_Status_Complete() 
                                AND Movement_Income.OperDate >= inStartDate AND Movement_Income.OperDate < inEndDate + interval '1 day'
                              --AND Movement_Income.OperDate >= '01.01.2016' AND Movement_Income.OperDate< '01.02.2016'
                              ) AS tmp
                        WHERE tmp.ord = 1
                      )

     -- чеки, определение периода прожажи  --  ,  tmpCheck_ALL 
    , tmpCheck AS (SELECT MIContainer.ObjectId_analyzer AS GoodsId
                        , SUM (CASE WHEN MIContainer.OperDate >= inStartDate AND MIContainer.OperDate < inEndDate + INTERVAL '1 DAY' THEN COALESCE (-1 * MIContainer.Amount, 0) ELSE 0 END) AS Amount_Sale
                        , SUM (CASE WHEN MIContainer.OperDate >= inStartDate AND MIContainer.OperDate < inEndDate + INTERVAL '1 DAY' THEN COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0) ELSE 0 END) AS Summa_Sale

                        , SUM (CASE WHEN MIContainer.OperDate >= vbStartDate1 AND MIContainer.OperDate < inStartDate THEN COALESCE (-1 * MIContainer.Amount, 0) ELSE 0 END) AS Amount_Sale1
                        , SUM (CASE WHEN MIContainer.OperDate >= vbStartDate1 AND MIContainer.OperDate < inStartDate THEN COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0) ELSE 0 END) AS Summa_Sale1

                        , SUM (CASE WHEN MIContainer.OperDate >= vbStartDate3 AND MIContainer.OperDate < inStartDate THEN COALESCE (-1 * MIContainer.Amount, 0) ELSE 0 END) AS Amount_Sale3
                        , SUM (CASE WHEN MIContainer.OperDate >= vbStartDate3 AND MIContainer.OperDate < inStartDate THEN COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0) ELSE 0 END) AS Summa_Sale3

                        , SUM (CASE WHEN MIContainer.OperDate < inStartDate THEN COALESCE (-1 * MIContainer.Amount, 0) ELSE 0 END) AS Amount_Sale6
                        , SUM (CASE WHEN MIContainer.OperDate < inStartDate THEN COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0) ELSE 0 END) AS Summa_Sale6
                    FROM MovementItemContainer AS MIContainer
                    WHERE MIContainer.DescId = zc_MIContainer_Count()
                      AND MIContainer.MovementDescId = zc_Movement_Check()
                      AND MIContainer.WhereObjectId_analyzer = inUnitId  
                      AND MIContainer.OperDate >= vbStartDate6 AND MIContainer.OperDate < inEndDate + INTERVAL '1 Day'
                     -- AND MIContainer.OperDate >= '03.06.2016' AND MIContainer.OperDate < '01.12.2016'
                    GROUP BY MIContainer.ObjectId_analyzer
                    HAVING sum(COALESCE (-1 * MIContainer.Amount, 0)) <> 0
                  ) 

        --результат
        SELECT inUnitId                                                                               AS UnitId
             , tmpRemains.GoodsId                                                                     AS GoodsId
             , COALESCE (tmpIncomeLast.MinExpirationDate ,tmpRemains.MinExpirationDate) :: TDateTime  AS MinExpirationDate
             , COALESCE (tmpIncomeLast.MaxOperDate, tmpRemains.MaxOperDateIncome)       :: TDateTime  AS OperDate_LastIncome
             , DATE_PART('day', (COALESCE (tmpIncomeLast.MinExpirationDate ,tmpRemains.MinExpirationDate) - inStartDate) / 30) :: TFloat AS Term
             , tmpRemains.Amount_Income                                                 :: TFloat     AS Amount_LastIncome
  
             , tmpRemains.RemainsStart                                                  :: TFloat     AS RemainsStart
             , tmpRemains.RemainsEnd                                                    :: TFloat     AS RemainsEnd
  
             , tmpCheck.Amount_Sale                                                     :: TFloat     AS Amount_Sale
             , tmpCheck.Summa_Sale                                                      :: TFloat     AS Summa_Sale
                                                                                                      
             , tmpCheck.Amount_Sale1                                                    :: TFloat     AS Amount_Sale1
             , tmpCheck.Summa_Sale1                                                     :: TFloat     AS Summa_Sale1
             , tmpCheck.Amount_Sale3                                                    :: TFloat     AS Amount_Sale3
             , tmpCheck.Summa_Sale3                                                     :: TFloat     AS Summa_Sale3
             , tmpCheck.Amount_Sale6                                                    :: TFloat     AS Amount_Sale6
             , tmpCheck.Summa_Sale6                                                     :: TFloat     AS Summa_Sale6
     
             , CASE WHEN (COALESCE (tmpCheck.Amount_Sale6,0)=0) AND COALESCE(tmp.Amount,0) <> 0 THEN TRUE ELSE FALSE END AS isSaleAnother
        FROM tmpRemains
             LEFT JOIN tmpCheck ON tmpCheck.GoodsId = tmpRemains.GoodsId
             LEFT JOIN tmpIncomeLast ON tmpIncomeLast.GoodsId = tmpRemains.GoodsId
             LEFT JOIN (SELECT _tmpCheck.GoodsId, SUM (_tmpCheck.Amount) AS Amount FROM _tmpCheck GROUP BY _tmpCheck.GoodsId) AS tmp ON tmp.GoodsId = tmpRemains.GoodsId
        WHERE COALESCE (tmpCheck.Amount_Sale1, 0) = 0 OR COALESCE (tmpCheck.Amount_Sale3, 0) = 0 OR COALESCE (tmpCheck.Amount_Sale6, 0) = 0
        ;

    -- таблица неликвидных товаров, которые нужно перемещать и точки куда перемещать
    -- Таблица -данных по перемещениям
    CREATE TEMP TABLE tmpDataTo (GoodsId Integer, UnitId Integer, RemainsMCS_result TFloat, PRIMARY KEY (UnitId, GoodsId)) ON COMMIT DROP;
      INSERT INTO tmpDataTo (GoodsId, UnitId, RemainsMCS_result)
      WITH 
      --неликвидныe товарs, которые можно перемещать
      tmpDataFrom AS (SELECT _tmpData.*
                      FROM  _tmpData
                      WHERE _tmpData.Term > 6 AND _tmpData.isSaleAnother = TRUE AND _tmpData.RemainsEnd > 0
                      )
      -- точки , где товар продавается в каждом из 3 периодов - за 1 мес, за 3 мес, за 6мес. 
    , tmpDataTo AS (SELECT *
                    FROM _tmpCheck
                    WHERE _tmpCheck.Amount_Sale6 > 0/*_tmpCheck.Amount_Sale1 <> _tmpCheck.Amount_Sale3
                      AND _tmpCheck.Amount_Sale3 <> _tmpCheck.Amount_Sale6*/
                      AND (_tmpCheck.Amount_Sale1 + _tmpCheck.Amount_Sale3 + _tmpCheck.Amount_Sale6) <> 0
                    )
    
    , tmpDataAll AS (SELECT tmpDataTo.UnitId           AS UnitId
                          , tmpDataTo.GoodsId          AS GoodsId
                          , tmpDataTo.Amount_Sale6     AS RemainsMCS_To
                          , tmpDataFrom.RemainsEnd     AS RemainsMCS_From
                            -- "накопительная" сумма "не хватает" = все предыдущие + текущая запись , !!!обязательно сортировка аналогичная с № п/п!!!
                          , SUM (tmpDataTo.Amount_Sale6) OVER (PARTITION BY tmpDataTo.GoodsId ORDER BY tmpDataTo.Amount_Sale6 DESC, tmpDataTo.UnitId DESC) AS RemainsMCS_period
                            -- № п/п, начинаем с максимального количества "не хватает"
                          , ROW_NUMBER() OVER (PARTITION BY tmpDataTo.GoodsId ORDER BY tmpDataTo.Amount_Sale6 DESC, tmpDataTo.UnitId DESC) AS Ord
                     FROM tmpDataFrom
                          INNER JOIN tmpDataTo ON tmpDataTo.GoodsId = tmpDataFrom.GoodsId
                    )
                    
    
        SELECT tmpDataAll.GoodsId
             , tmpDataAll.UnitId
             
             , CASE -- для первого - учитывается ТОЛЬКО "не хватает"
                    WHEN Ord = 1 THEN CASE WHEN RemainsMCS_to <= RemainsMCS_from THEN RemainsMCS_to ELSE RemainsMCS_from END
                    -- для остальных - учитывается "накопительная" сумма "не хватает" !!!минус!!! то что в текущей записи
                    WHEN RemainsMCS_from - (RemainsMCS_period - RemainsMCS_to) > 0 -- сколько осталось "излишков" если всем предыдущим уже распределили
                         THEN CASE -- если "не хватает" меньше сколько осталось "излишков"
                                   WHEN RemainsMCS_to <= RemainsMCS_from - (RemainsMCS_period - RemainsMCS_to)
                                        THEN RemainsMCS_to
                                   ELSE -- иначе остаток "излишков"
                                        RemainsMCS_from - (RemainsMCS_period - RemainsMCS_to)
                              END
                    ELSE 0
               END AS RemainsMCS_result
        FROM tmpDataAll
        WHERE  CASE -- для первого - учитывается ТОЛЬКО "не хватает"
                    WHEN Ord = 1 THEN CASE WHEN RemainsMCS_to <= RemainsMCS_from THEN RemainsMCS_to ELSE RemainsMCS_from END
                    -- для остальных - учитывается "накопительная" сумма "не хватает" !!!минус!!! то что в текущей записи
                    WHEN RemainsMCS_from - (RemainsMCS_period - RemainsMCS_to) > 0 -- сколько осталось "излишков" если всем предыдущим уже распределили
                         THEN CASE -- если "не хватает" меньше сколько осталось "излишков"
                                   WHEN RemainsMCS_to <= RemainsMCS_from - (RemainsMCS_period - RemainsMCS_to)
                                        THEN RemainsMCS_to
                                   ELSE -- иначе остаток "излишков"
                                        RemainsMCS_from - (RemainsMCS_period - RemainsMCS_to)
                              END
                    ELSE 0
               END <> 0
              ;
                      
     -- Результат
     OPEN Cursor1 FOR
      WITH
      -- для остатка получаем значение цены
      tmpPriceRemains AS (SELECT _tmpData.GoodsId
                               , COALESCE (ObjectHistoryFloat_Price.ValueData, 0)       Price_Remains
                               , COALESCE (ObjectHistoryFloat_PriceEnd.ValueData, 0)    Price_RemainsEnd
                          FROM _tmpData
                             LEFT OUTER JOIN Object_Price_View ON object_price_view.GoodsId = _tmpData.GoodsId
                                                              AND Object_Price_View.unitid = inUnitId
                             -- получаем значения цены из истории значений на начало дня                                                          
                             LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                                     ON ObjectHistory_Price.ObjectId = Object_Price_View.Id 
                                                    AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                                    AND DATE_TRUNC ('DAY', inStartDate) >= ObjectHistory_Price.StartDate AND DATE_TRUNC ('DAY', inStartDate) < ObjectHistory_Price.EndDate
                             LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                                          ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id
                                                         AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_Price_Value()
                             -- получаем значения цены из истории значений на конеч. дату                                                          
                             LEFT JOIN ObjectHistory AS ObjectHistory_PriceEnd
                                                     ON ObjectHistory_PriceEnd.ObjectId = Object_Price_View.Id 
                                                    AND ObjectHistory_PriceEnd.DescId = zc_ObjectHistory_Price()
                                                    AND DATE_TRUNC ('DAY', inEndDate) >= ObjectHistory_PriceEnd.StartDate AND DATE_TRUNC ('DAY', inEndDate) < ObjectHistory_PriceEnd.EndDate
                             LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceEnd
                                                          ON ObjectHistoryFloat_PriceEnd.ObjectHistoryId = ObjectHistory_PriceEnd.Id
                                                         AND ObjectHistoryFloat_PriceEnd.DescId = zc_ObjectHistoryFloat_Price_Value()
                       --   where 1 = 0
                           )
      , tmpChildTo AS (SELECT tmpDataTo.GoodsId
                            , SUM (tmpDataTo.RemainsMCS_result) AS RemainsMCS_result
                       FROM tmpDataTo
                       GROUP BY tmpDataTo.GoodsId
                      )
        --результат
        SELECT
             Object_Goods_View.Id                               AS GoodsId
           , Object_Goods_View.GoodsCodeInt       ::Integer     AS GoodsCode
           , Object_Goods_View.GoodsName                        AS GoodsName
           , Object_Goods_View.GoodsGroupName                   AS GoodsGroupName
           , Object_Goods_View.NDSKindName
           , _tmpData.MinExpirationDate           :: TDateTime  AS MinExpirationDate
           , _tmpData.OperDate_LastIncome         :: TDateTime  AS OperDate_LastIncome
           , _tmpData.Amount_LastIncome           :: TFloat     AS Amount_LastIncome
           , tmpPriceRemains.Price_Remains        :: TFloat     AS Price_Remains
           , tmpPriceRemains.Price_RemainsEnd     :: TFloat     AS Price_RemainsEnd

           , _tmpData.RemainsStart                :: TFloat AS RemainsStart
           , _tmpData.RemainsEnd                  :: TFloat AS RemainsEnd
           , CASE WHEN _tmpData.Amount_Sale <> 0 THEN _tmpData.Summa_Sale / _tmpData.Amount_Sale ELSE 0 END :: TFloat AS Price_Sale

           , (_tmpData.RemainsStart * tmpPriceRemains.Price_Remains)  :: TFloat AS Summa_Remains
           , (_tmpData.RemainsEnd * tmpPriceRemains.Price_RemainsEnd) :: TFloat AS Summa_RemainsEnd

           , _tmpData.Amount_Sale                 :: TFloat AS Amount_Sale
           , _tmpData.Summa_Sale                  :: TFloat AS Summa_Sale
                                             
           , _tmpData.Amount_Sale1                :: TFloat AS Amount_Sale1
           , _tmpData.Summa_Sale1                 :: TFloat AS Summa_Sale1
           , _tmpData.Amount_Sale3                :: TFloat AS Amount_Sale3
           , _tmpData.Summa_Sale3                 :: TFloat AS Summa_Sale3
           , _tmpData.Amount_Sale6                :: TFloat AS Amount_Sale6
           , _tmpData.Summa_Sale6                 :: TFloat AS Summa_Sale6
   
           , tmpChildTo.RemainsMCS_result         :: TFloat AS RemainsMCS_result
   
           , _tmpData.isSaleAnother                         AS isSaleAnother
        FROM _tmpData
             LEFT JOIN tmpPriceRemains ON tmpPriceRemains.GoodsId = _tmpData.GoodsId
             LEFT JOIN Object_Goods_View ON Object_Goods_View.Id = _tmpData.GoodsId
             LEFT JOIN tmpChildTo ON tmpChildTo.GoodsId = _tmpData.GoodsId
        --WHERE COALESCE (tmpCheck.Amount_Sale1, 0) = 0 OR COALESCE (tmpCheck.Amount_Sale3, 0) = 0 OR COALESCE (tmpCheck.Amount_Sale6, 0) =0
        ORDER BY GoodsGroupName, GoodsName;

     RETURN NEXT Cursor1;


    -- Результат 2
     OPEN Cursor2 FOR
      SELECT
             tmpCheck.GoodsId                          AS GoodsId
           , Object_Unit.ValueData                     AS UnitName
           , tmpCheck.Amount_Sale            :: TFloat AS Amount_Sale
           , tmpCheck.Summa_Sale             :: TFloat AS Summa_Sale
                                           
           , tmpCheck.Amount_Sale1           :: TFloat AS Amount_Sale1
           , tmpCheck.Summa_Sale1            :: TFloat AS Summa_Sale1
           , tmpCheck.Amount_Sale3           :: TFloat AS Amount_Sale3
           , tmpCheck.Summa_Sale3            :: TFloat AS Summa_Sale3
           , tmpCheck.Amount_Sale6           :: TFloat AS Amount_Sale6
           , tmpCheck.Summa_Sale6            :: TFloat AS Summa_Sale6
                                           
           , tmpDataTo.RemainsMCS_result     :: TFloat AS RemainsMCS_result
      FROM _tmpCheck AS tmpCheck
           LEFT JOIN tmpDataTo ON tmpDataTo.GoodsId = tmpCheck.GoodsId AND tmpDataTo.UnitId = tmpCheck.UnitId
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpCheck.UnitId
      WHERE COALESCE (tmpCheck.Amount_Sale1, 0) <> 0 OR COALESCE (tmpCheck.Amount_Sale3, 0) <> 0 OR COALESCE (tmpCheck.Amount_Sale6, 0) <> 0
      ;

     RETURN NEXT Cursor2;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 16.01.17         *
 06.10.16         * parce
 05.09.16         *
*/

-- тест
--SELECT * FROM gpReport_Movement_Check_UnLiquid(inUnitId := 183292 , inStartDate := ('01.02.2016')::TDateTime , inEndDate := ('02.02.2016')::TDateTime , inSession := '3');
-- SELECT * FROM gpReport_Movement_Check_UnLiquid (inUnitId:= 0, inStartDate:= '20150801'::TDateTime, inEndDate:= '20150810'::TDateTime,inSession:= '3' ::TVarChar)
--select * from gpReport_Movement_Check_UnLiquid(inUnitId := 183292 , inStartDate := ('31.12.2016')::TDateTime , inEndDate := ('31.12.2016')::TDateTime ,  inSession := '3' ::TVarChar);