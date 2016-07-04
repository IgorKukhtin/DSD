-- Function: gpSelect_Object_PriceHistory (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_PriceHistory(Integer, TDateTime, Boolean,Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PriceHistory(
    IN inUnitId      Integer,       -- подразделение
    IN inStartDate   TDateTime ,    -- Дата действия
    IN inisShowAll   Boolean,        --True - показать все товары, False - показать только с ценами
    IN inisShowDel   Boolean,       --True - показать так же удаленные, False - показать только рабочие
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Price TFloat, MCSValue TFloat
             , MCSPeriod TFloat, MCSDay TFloat, StartDate TDateTime
             , MCSPeriodEnd TFloat, MCSDayEnd TFloat, StartDateEnd TDateTime
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupName TVarChar, NDSKindName TVarChar
             , Goods_isTop Boolean
             , DateChange TDateTime, MCSDateChange TDateTime
             , MCSIsClose Boolean, MCSIsCloseDateChange TDateTime
             , MCSNotRecalc Boolean, MCSNotRecalcDateChange TDateTime
             , Fix Boolean, FixDateChange TDateTime
             , MinExpirationDate TDateTime
             , Remains TFloat, SummaRemains TFloat
             , RemainsNotMCS TFloat, SummaNotMCS TFloat
             
             , PriceEnd TFloat, MCSValueEnd TFloat
             , RemainsEnd TFloat, SummaRemainsEnd TFloat
             , RemainsNotMCSEnd TFloat, SummaNotMCSEnd TFloat
             , isTop boolean, TOPDateChange TDateTime
             , PercentMarkup TFloat, PercentMarkupDateChange TDateTime
             , isErased boolean
             ) AS
$BODY$
DECLARE
    vbUserId Integer;
    vbObjectId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Street());
    vbUserId:= lpGetUserBySession (inSession);
    -- Ограничение на просмотр товарного справочника
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    IF inUnitId is null
    THEN
        inUnitId := 0;
    END IF;
    -- Результат
    IF COALESCE(inUnitId,0) = 0
    THEN
        RETURN QUERY
            SELECT 
                NULL::Integer                    AS Id
               ,NULL::TFloat                     AS Price
               ,NULL::TFloat                     AS MCSValue
               ,NULL::TFloat                     AS MCSPeriod
               ,NULL::TFloat                     AS MCSDay              
               ,NULL::TDateTime                  AS StartDate
               ,NULL::TFloat                     AS MCSPeriodEnd
               ,NULL::TFloat                     AS MCSDayEnd              
               ,NULL::TDateTime                  AS StartDateEnd
               
               ,NULL::Integer                    AS GoodsId
               ,NULL::Integer                    AS GoodsCode
               ,NULL::TVarChar                   AS GoodsName
               ,NULL::TVarChar                   AS GoodsGroupName
               ,NULL::TVarChar                   AS NDSKindName
               ,NULL::Boolean                    AS Goods_isTop
               ,NULL::TDateTime                  AS DateChange
               ,NULL::TDateTime                  AS MCSDateChange
               ,NULL::Boolean                    AS MCSIsClose
               ,NULL::TDateTime                  AS MCSIsCloseDateChange
               ,NULL::Boolean                    AS MCSNotRecalc
               ,NULL::TDateTime                  AS MCSNotRecalcDateChange
               ,NULL::Boolean                    AS Fix
               ,NULL::TDateTime                  AS FixDateChange
               ,NULL::TDateTime                  AS MinExpirationDate
               ,NULL::TFloat                     AS Remains
               ,NULL::TFloat                     AS SummaRemains
               ,NULL::TFloat                     AS RemainsNotMCS
               ,NULL::TFloat                     AS SummaNotMCS

               , NULL::TFloat AS PriceEnd
               , NULL::TFloat AS MCSValueEnd

               , NULL::TFloat AS RemainsEnd
               , NULL::TFloat AS SummaRemainsEnd
               , NULL::TFloat AS RemainsNotMCSEnd
               , NULL::TFloat AS SummaNotMCSEnd
                              
               ,NULL::Boolean                    AS isTop 
               ,NULL::TDateTime                  AS TOPDateChange

               ,NULL::TFloat                     AS PercentMarkup 
               ,NULL::TDateTime                  AS PercentMarkupDateChange

               ,NULL::Boolean                    AS isErased
            WHERE 1=0;
    ELSEIF inisShowAll = True
    THEN
        RETURN QUERY
        With 
        tmpRemeins AS ( SELECT tmp.objectid,
                               SUM(tmp.Remains)     AS Remains,
                               SUM(tmp.RemainsEnd)  AS RemainsEnd
                        FROM (SELECT container.objectid,
                                    COALESCE(container.Amount,0) - COALESCE(SUM(MIContainer.Amount), 0)   AS Remains , 
                                    (COALESCE(container.Amount,0) - SUM (CASE WHEN MIContainer.OperDate >= DATE_TRUNC ('DAY', inStartDate )+interval '1 day' then COALESCE(MIContainer.Amount, 0) ELSE 0 END)) AS RemainsEnd
                              FROM container
                                    LEFT JOIN MovementItemContainer AS MIContainer 
                                                                    ON MIContainer.ContainerId = container.Id
                                                                   AND MIContainer.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                              WHERE container.descid = zc_container_count() 
                                AND Container.WhereObjectId = inUnitId
                              GROUP BY container.objectid,COALESCE(container.Amount,0), container.Id
                             ) AS tmp
                        GROUP BY tmp.objectid
                       )
        
            SELECT
                Object_Price_View.Id                            AS Id
               , COALESCE (ObjectHistoryFloat_Price.ValueData, 0)                  :: TFloat    AS Price
               , COALESCE (ObjectHistoryFloat_MCSValue.ValueData, 0)               :: TFloat    AS MCSValue
               , COALESCE (ObjectHistoryFloat_MCSPeriod.ValueData, 0)              :: TFloat    AS MCSPeriod
               , COALESCE (ObjectHistoryFloat_MCSDay.ValueData, 0)                 :: TFloat    AS MCSDay
               , COALESCE (ObjectHistory_Price.StartDate, NULL /*zc_DateStart()*/) :: TDateTime AS StartDate
               
               , COALESCE (ObjectHistoryFloat_MCSPeriodEnd.ValueData, 0)              :: TFloat    AS MCSPeriodEnd
               , COALESCE (ObjectHistoryFloat_MCSDayEnd.ValueData, 0)                 :: TFloat    AS MCSDayEnd
               , COALESCE (ObjectHistory_PriceEnd.StartDate, NULL /*zc_DateStart()*/) :: TDateTime AS StartDateEnd
                              
               , Object_Goods_View.id                            AS GoodsId
               , Object_Goods_View.GoodsCodeInt                  AS GoodsCode
               , Object_Goods_View.GoodsName                     AS GoodsName
               , Object_Goods_View.GoodsGroupName                AS GoodsGroupName
               , Object_Goods_View.NDSKindName                   AS NDSKindName
               , Object_Goods_View.isTop                         AS Goods_isTop
               , Object_Price_View.DateChange                    AS DateChange
               , Object_Price_View.MCSDateChange                 AS MCSDateChange
               , COALESCE(Object_Price_View.MCSIsClose,False)    AS MCSIsClose
               , Object_Price_View.MCSIsCloseDateChange          AS MCSIsCloseDateChange
               , COALESCE(Object_Price_View.MCSNotRecalc,False)  AS MCSNotRecalc
               , Object_Price_View.MCSNotRecalcDateChange        AS MCSNotRecalcDateChange
               , COALESCE(Object_Price_View.Fix,False)           AS Fix
               , Object_Price_View.FixDateChange                 AS FixDateChange
               , SelectMinPrice_AllGoods.MinExpirationDate       AS MinExpirationDate

               , Object_Remains.Remains  :: TFloat               AS Remains
               , (Object_Remains.Remains * COALESCE (ObjectHistoryFloat_Price.ValueData, 0))       ::TFloat AS SummaRemains

               , CASE WHEN COALESCE (Object_Remains.Remains, 0) > COALESCE (ObjectHistoryFloat_MCSValue.ValueData, 0) THEN COALESCE (Object_Remains.Remains, 0) - COALESCE (ObjectHistoryFloat_MCSValue.ValueData, 0) ELSE 0 END :: TFloat AS RemainsNotMCS
               , CASE WHEN COALESCE (Object_Remains.Remains, 0) > COALESCE (ObjectHistoryFloat_MCSValue.ValueData, 0) THEN (COALESCE (Object_Remains.Remains, 0) - COALESCE (ObjectHistoryFloat_MCSValue.ValueData, 0)) * COALESCE (ObjectHistoryFloat_Price.ValueData, 0) ELSE 0 END :: TFloat AS SummaNotMCS

               , COALESCE (ObjectHistoryFloat_PriceEnd.ValueData, 0)                  :: TFloat    AS PriceEnd
               , COALESCE (ObjectHistoryFloat_MCSValueEnd.ValueData, 0)               :: TFloat    AS MCSValueEnd

               , Object_Remains.RemainsEnd        :: TFloat      AS RemainsEnd
               , (Object_Remains.RemainsEnd * COALESCE (ObjectHistoryFloat_PriceEnd.ValueData, 0)) ::TFloat AS SummaRemainsEnd
               , CASE WHEN COALESCE (Object_Remains.RemainsEnd, 0) > COALESCE (ObjectHistoryFloat_MCSValueEnd.ValueData, 0) THEN COALESCE (Object_Remains.RemainsEnd, 0) - COALESCE (ObjectHistoryFloat_MCSValueEnd.ValueData, 0) ELSE 0 END :: TFloat AS RemainsNotMCSEnd
               , CASE WHEN COALESCE (Object_Remains.RemainsEnd, 0) > COALESCE (ObjectHistoryFloat_MCSValueEnd.ValueData, 0) THEN (COALESCE (Object_Remains.RemainsEnd, 0) - COALESCE (ObjectHistoryFloat_MCSValueEnd.ValueData, 0)) * COALESCE (ObjectHistoryFloat_PriceEnd.ValueData, 0) ELSE 0 END :: TFloat AS SummaNotMCSEnd
               
               , Object_Price_View.isTop                AS isTop
               , Object_Price_View.TopDateChange        AS TopDateChange

               , Object_Price_View.PercentMarkup           AS PercentMarkup
               , Object_Price_View.PercentMarkupDateChange AS PercentMarkupDateChange

               , Object_Goods_View.isErased                      AS isErased 
               
            FROM Object_Goods_View
                INNER JOIN ObjectLink ON ObjectLink.ObjectId = Object_Goods_View.Id 
                                     AND ObjectLink.ChildObjectId = vbObjectId
                LEFT OUTER JOIN Object_Price_View ON Object_Goods_View.id = object_price_view.goodsid
                                                 AND Object_Price_View.unitid = inUnitId
                LEFT OUTER JOIN tmpRemeins AS Object_Remains
                                           ON Object_Remains.ObjectId = Object_Goods_View.Id
   
                LEFT JOIN lpSelectMinPrice_AllGoods(inUnitId := inUnitId,
                                                    inObjectId := vbObjectId, 
                                                    inUserId := vbUserId) AS SelectMinPrice_AllGoods
                                                                          ON SelectMinPrice_AllGoods.GoodsId = Object_Goods_View.Id

                -- получаем значения цены и НТЗ из истории значений на начало дня                                                          
                LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                        ON ObjectHistory_Price.ObjectId = Object_Price_View.Id 
                                       AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                       AND DATE_TRUNC ('DAY', inStartDate) >= ObjectHistory_Price.StartDate AND DATE_TRUNC ('DAY', inStartDate) < ObjectHistory_Price.EndDate
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                             ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id
                                            AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_Price_Value()
            
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MCSValue
                                             ON ObjectHistoryFloat_MCSValue.ObjectHistoryId = ObjectHistory_Price.Id
                                            AND ObjectHistoryFloat_MCSValue.DescId = zc_ObjectHistoryFloat_Price_MCSValue()                

                -- получаем значения Количество дней для анализа НТЗ из истории значений на дату    
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MCSPeriod
                                             ON ObjectHistoryFloat_MCSPeriod.ObjectHistoryId = ObjectHistory_Price.Id
                                            AND ObjectHistoryFloat_MCSPeriod.DescId = zc_ObjectHistoryFloat_Price_MCSPeriod()
                -- получаем значения Страховой запас дней НТЗ из истории значений на дату    
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MCSDay
                                             ON ObjectHistoryFloat_MCSDay.ObjectHistoryId = ObjectHistory_Price.Id
                                            AND ObjectHistoryFloat_MCSDay.DescId = zc_ObjectHistoryFloat_Price_MCSDay() 
                                            
                -- получаем значения цены и НТЗ из истории значений на конец дня (на сл.день 00:00)
                LEFT JOIN ObjectHistory AS ObjectHistory_PriceEnd
                                        ON ObjectHistory_PriceEnd.ObjectId = Object_Price_View.Id 

                                       AND ObjectHistory_PriceEnd.DescId = zc_ObjectHistory_Price()
                                        AND DATE_TRUNC ('DAY', inStartDate) +interval '1 day' >= ObjectHistory_PriceEnd.StartDate AND DATE_TRUNC ('DAY', inStartDate) +interval '1 day' < ObjectHistory_PriceEnd.EndDate
                                       --AND '10.02.2016' >= ObjectHistory_Price.StartDate AND '10.02.2016' < ObjectHistory_Price.EndDate
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceEnd
                                             ON ObjectHistoryFloat_PriceEnd.ObjectHistoryId = ObjectHistory_PriceEnd.Id
                                            AND ObjectHistoryFloat_PriceEnd.DescId = zc_ObjectHistoryFloat_Price_Value()
            
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MCSValueEnd
                                             ON ObjectHistoryFloat_MCSValueEnd.ObjectHistoryId = ObjectHistory_PriceEnd.Id
                                            AND ObjectHistoryFloat_MCSValueEnd.DescId = zc_ObjectHistoryFloat_Price_MCSValue()                

                -- получаем значения Количество дней для анализа НТЗ из истории значений на дату  (00:00)
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MCSPeriodEnd
                                             ON ObjectHistoryFloat_MCSPeriodEnd.ObjectHistoryId = ObjectHistory_PriceEnd.Id
                                            AND ObjectHistoryFloat_MCSPeriodEnd.DescId = zc_ObjectHistoryFloat_Price_MCSPeriod()
                -- получаем значения Страховой запас дней НТЗ из истории значений на дату    
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MCSDayEnd
                                             ON ObjectHistoryFloat_MCSDayEnd.ObjectHistoryId = ObjectHistory_PriceEnd.Id
                                            AND ObjectHistoryFloat_MCSDayEnd.DescId = zc_ObjectHistoryFloat_Price_MCSDay() 

            WHERE (inisShowDel = True
                    OR
                    Object_Goods_View.isErased = False
                  )
            ORDER BY
                GoodsGroupName, GoodsName;
    ELSE
        RETURN QUERY
        WITH 
        tmpRemeins AS ( SELECT tmp.objectid,
                               SUM(tmp.Remains)     AS Remains,
                               SUM(tmp.RemainsEnd)  AS RemainsEnd
                        FROM (SELECT container.objectid,
                                    COALESCE(container.Amount,0) - COALESCE(SUM(MIContainer.Amount), 0)   AS Remains , 
                                    (COALESCE(container.Amount,0) - SUM (CASE WHEN MIContainer.OperDate >= DATE_TRUNC ('DAY', inStartDate )+interval '1 day' then COALESCE(MIContainer.Amount, 0) ELSE 0 END)) AS RemainsEnd
                              FROM container
                                    LEFT JOIN MovementItemContainer AS MIContainer 
                                                                    ON MIContainer.ContainerId = container.Id
                                                                   AND MIContainer.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                              WHERE container.descid = zc_container_count() 
                                AND Container.WhereObjectId = inUnitId
                              GROUP BY container.objectid,COALESCE(container.Amount,0), container.Id
                             ) AS tmp
                        GROUP BY tmp.objectid
                       )
        
            SELECT
                 Object_Price_View.Id                      AS Id
               , COALESCE (ObjectHistoryFloat_Price.ValueData, 0)                  :: TFloat    AS Price
               , COALESCE (ObjectHistoryFloat_MCSValue.ValueData, 0)               :: TFloat    AS MCSValue
               , COALESCE (ObjectHistoryFloat_MCSPeriod.ValueData, 0)              :: TFloat    AS MCSPeriod
               , COALESCE (ObjectHistoryFloat_MCSDay.ValueData, 0)                 :: TFloat    AS MCSDay
               , COALESCE (ObjectHistory_Price.StartDate, NULL /*zc_DateStart()*/) :: TDateTime AS StartDate

               , COALESCE (ObjectHistoryFloat_MCSPeriodEnd.ValueData, 0)              :: TFloat    AS MCSPeriodEnd
               , COALESCE (ObjectHistoryFloat_MCSDayEnd.ValueData, 0)                 :: TFloat    AS MCSDayEnd
               , COALESCE (ObjectHistory_PriceEnd.StartDate, NULL /*zc_DateStart()*/) :: TDateTime AS StartDateEnd
                                        
               , Object_Goods_View.id                      AS GoodsId
               , Object_Goods_View.GoodsCodeInt            AS GoodsCode
               , Object_Goods_View.GoodsName               AS GoodsName
               , Object_Goods_View.GoodsGroupName          AS GoodsGroupName
               , Object_Goods_View.NDSKindName             AS NDSKindName
               , Object_Goods_View.isTop                   AS Goods_isTop
               , Object_Price_View.DateChange              AS DateChange
               , Object_Price_View.MCSDateChange           AS MCSDateChange
               , Object_Price_View.MCSIsClose              AS MCSIsClose
               , Object_Price_View.MCSIsCloseDateChange    AS MCSIsCloseDateChange
               , Object_Price_View.MCSNotRecalc            AS MCSNotRecalc
               , Object_Price_View.MCSNotRecalcDateChange  AS MCSNotRecalcDateChange
               , Object_Price_View.Fix                     AS Fix
               , Object_Price_View.FixDateChange           AS FixDateChange
               , SelectMinPrice_AllGoods.MinExpirationDate AS MinExpirationDate
               
               , Object_Remains.Remains           :: TFloat         AS Remains
               , (Object_Remains.Remains * COALESCE (ObjectHistoryFloat_Price.ValueData, 0)) ::TFloat AS SummaRemains

               , CASE WHEN COALESCE (Object_Remains.Remains, 0) > COALESCE (ObjectHistoryFloat_MCSValue.ValueData, 0) THEN COALESCE (Object_Remains.Remains, 0) - COALESCE (ObjectHistoryFloat_MCSValue.ValueData, 0) ELSE 0 END :: TFloat AS RemainsNotMCS
               , CASE WHEN COALESCE (Object_Remains.Remains, 0) > COALESCE (ObjectHistoryFloat_MCSValue.ValueData, 0) THEN (COALESCE (Object_Remains.Remains, 0) - COALESCE (ObjectHistoryFloat_MCSValue.ValueData, 0)) * COALESCE (ObjectHistoryFloat_Price.ValueData, 0) ELSE 0 END :: TFloat AS SummaNotMCS

               , COALESCE (ObjectHistoryFloat_PriceEnd.ValueData, 0)                  :: TFloat    AS PriceEnd
               , COALESCE (ObjectHistoryFloat_MCSValueEnd.ValueData, 0)               :: TFloat    AS MCSValueEnd

               , Object_Remains.RemainsEnd     :: TFloat                  AS RemainsEnd
               , (Object_Remains.RemainsEnd * COALESCE (ObjectHistoryFloat_PriceEnd.ValueData, 0)) ::TFloat AS SummaRemainsEnd
               , CASE WHEN COALESCE (Object_Remains.RemainsEnd, 0) > COALESCE (ObjectHistoryFloat_MCSValueEnd.ValueData, 0) THEN COALESCE (Object_Remains.RemainsEnd, 0) - COALESCE (ObjectHistoryFloat_MCSValueEnd.ValueData, 0) ELSE 0 END :: TFloat AS RemainsNotMCSEnd
               , CASE WHEN COALESCE (Object_Remains.RemainsEnd, 0) > COALESCE (ObjectHistoryFloat_MCSValueEnd.ValueData, 0) THEN (COALESCE (Object_Remains.RemainsEnd, 0) - COALESCE (ObjectHistoryFloat_MCSValueEnd.ValueData, 0)) * COALESCE (ObjectHistoryFloat_PriceEnd.ValueData, 0) ELSE 0 END :: TFloat AS SummaNotMCSEnd
                              
               , Object_Price_View.isTop                   AS isTop
               , Object_Price_View.TopDateChange           AS TopDateChange

               , Object_Price_View.PercentMarkup           AS PercentMarkup
               , Object_Price_View.PercentMarkupDateChange AS PercentMarkupDateChange

               , Object_Goods_View.isErased                AS isErased 
               
            FROM Object_Price_View
                LEFT OUTER JOIN Object_Goods_View ON Object_Goods_View.id = object_price_view.goodsid
                LEFT OUTER JOIN tmpRemeins AS Object_Remains
                                           ON Object_Remains.ObjectId = Object_Price_View.GoodsId

                LEFT JOIN lpSelectMinPrice_AllGoods(inUnitId := inUnitId,
                                                     inObjectId := vbObjectId, 
                                                     inUserId := vbUserId) AS SelectMinPrice_AllGoods 
                                                                           ON SelectMinPrice_AllGoods.GoodsId = Object_Goods_View.Id
                -- получаем значения цены и НТЗ из истории значений на дату                                                           
                LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                        ON ObjectHistory_Price.ObjectId = Object_Price_View.Id 
                                       AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                       AND  DATE_TRUNC ('DAY', inStartDate) >= ObjectHistory_Price.StartDate AND  DATE_TRUNC ('DAY', inStartDate) < ObjectHistory_Price.EndDate
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                             ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id
                                            AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_Price_Value()
            
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MCSValue
                                             ON ObjectHistoryFloat_MCSValue.ObjectHistoryId = ObjectHistory_Price.Id
                                            AND ObjectHistoryFloat_MCSValue.DescId = zc_ObjectHistoryFloat_Price_MCSValue()                
              
                -- получаем значения Количество дней для анализа НТЗ из истории значений на дату  (00:00)
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MCSPeriod
                                             ON ObjectHistoryFloat_MCSPeriod.ObjectHistoryId = ObjectHistory_Price.Id
                                            AND ObjectHistoryFloat_MCSPeriod.DescId = zc_ObjectHistoryFloat_Price_MCSPeriod()
                -- получаем значения Страховой запас дней НТЗ из истории значений на дату    
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MCSDay
                                             ON ObjectHistoryFloat_MCSDay.ObjectHistoryId = ObjectHistory_Price.Id
                                            AND ObjectHistoryFloat_MCSDay.DescId = zc_ObjectHistoryFloat_Price_MCSDay() 

                -- получаем значения цены и НТЗ из истории значений на конец дня (на сл.день 00:00)
                LEFT JOIN ObjectHistory AS ObjectHistory_PriceEnd
                                        ON ObjectHistory_PriceEnd.ObjectId = Object_Price_View.Id 
                                       AND ObjectHistory_PriceEnd.DescId = zc_ObjectHistory_Price()
                                       AND DATE_TRUNC ('DAY', inStartDate) +interval '1 day' >= ObjectHistory_PriceEnd.StartDate AND DATE_TRUNC ('DAY', inStartDate) +interval '1 day' < ObjectHistory_PriceEnd.EndDate
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceEnd
                                             ON ObjectHistoryFloat_PriceEnd.ObjectHistoryId = ObjectHistory_PriceEnd.Id
                                            AND ObjectHistoryFloat_PriceEnd.DescId = zc_ObjectHistoryFloat_Price_Value()
            
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MCSValueEnd
                                             ON ObjectHistoryFloat_MCSValueEnd.ObjectHistoryId = ObjectHistory_PriceEnd.Id
                                            AND ObjectHistoryFloat_MCSValueEnd.DescId = zc_ObjectHistoryFloat_Price_MCSValue()                

                -- получаем значения Количество дней для анализа НТЗ из истории значений на дату  (00:00)
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MCSPeriodEnd
                                             ON ObjectHistoryFloat_MCSPeriodEnd.ObjectHistoryId = ObjectHistory_PriceEnd.Id
                                            AND ObjectHistoryFloat_MCSPeriodEnd.DescId = zc_ObjectHistoryFloat_Price_MCSPeriod()
                -- получаем значения Страховой запас дней НТЗ из истории значений на дату    
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MCSDayEnd
                                             ON ObjectHistoryFloat_MCSDayEnd.ObjectHistoryId = ObjectHistory_PriceEnd.Id
                                            AND ObjectHistoryFloat_MCSDayEnd.DescId = zc_ObjectHistoryFloat_Price_MCSDay() 
                                                            
            WHERE Object_Price_View.unitid = inUnitId
              AND (inisShowDel = True OR Object_Goods_View.isErased = False)
            ORDER BY GoodsGroupName, GoodsName;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А. 
 04.07.16         *
 30.06.16         *
 13.03.16         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_PriceHistory(inUnitId := 183292 , inStartDate := ('24.02.2016 17:24:00')::TDateTime , inisShowAll := 'False' , inisShowDel := 'False' ,  inSession := '3');
