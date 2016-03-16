-- Function: gpSelect_Object_Price (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Price(Integer, Boolean,Boolean,TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Price(Integer, TDateTime, Boolean,Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Price(
    IN inUnitId      Integer,       -- подразделение
    IN inisShowAll   Boolean,        --True - показать все товары, False - показать только с ценами
    IN inisShowDel   Boolean,       --True - показать так же удаленные, False - показать только рабочие
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Price TFloat, MCSValue TFloat
             , MCSPeriod TFloat, MCSDay TFloat, StartDate TDateTime
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupName TVarChar, NDSKindName TVarChar
             , DateChange TDateTime, MCSDateChange TDateTime
             , MCSIsClose Boolean, MCSIsCloseDateChange TDateTime
             , MCSNotRecalc Boolean, MCSNotRecalcDateChange TDateTime
             , Fix Boolean, FixDateChange TDateTime
             , MinExpirationDate TDateTime
             , Remains TFloat, SummaRemains TFloat
             , RemainsNotMCS TFloat, SummaNotMCS TFloat
             , isErased boolean
             ) AS
$BODY$
DECLARE
    vbUserId Integer;
    vbObjectId Integer;
    vbStartDate TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Street());
    vbUserId:= lpGetUserBySession (inSession);
    -- Ограничение на просмотр товарного справочника
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    vbStartDate:= DATE_TRUNC ('DAY', CURRENT_DATE);

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
               ,NULL::Integer                    AS GoodsId
               ,NULL::Integer                    AS GoodsCode
               ,NULL::TVarChar                   AS GoodsName
               ,NULL::TVarChar                   AS GoodsGroupName
               ,NULL::TVarChar                   AS NDSKindName
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
               ,NULL::Boolean                    AS isErased
            WHERE 1=0;
    ELSEIF inisShowAll = True
    THEN
        RETURN QUERY
        With 
        tmpRemeins AS (SELECT container.objectid ,
                              Sum(COALESCE(container.Amount,0)) ::TFloat AS Remains
                       FROM container
                       WHERE container.descid = zc_container_count() 
                         AND Amount<>0
                         AND Container.WhereObjectId = inUnitId
                       GROUP BY container.objectid
                       )
        
            SELECT
                Object_Price_View.Id                                                AS Id
               , COALESCE (Object_Price_View.Price,0)                     :: TFloat AS Price
               , COALESCE (Object_Price_View.MCSValue,0)                  :: TFloat AS MCSValue
               , COALESCE (ObjectHistoryFloat_MCSPeriod.ValueData, 0)     :: TFloat AS MCSPeriod
               , COALESCE (ObjectHistoryFloat_MCSDay.ValueData, 0)        :: TFloat AS MCSDay
               , COALESCE (ObjectHistory_Price.StartDate, NULL /*zc_DateStart()*/) :: TDateTime AS StartDate
                              
               , Object_Goods_View.id                            AS GoodsId
               , Object_Goods_View.GoodsCodeInt                  AS GoodsCode
               , Object_Goods_View.GoodsName                     AS GoodsName
               , Object_Goods_View.GoodsGroupName                AS GoodsGroupName
               , Object_Goods_View.NDSKindName                   AS NDSKindName
               , Object_Price_View.DateChange                    AS DateChange
               , Object_Price_View.MCSDateChange                 AS MCSDateChange
               , COALESCE(Object_Price_View.MCSIsClose,False)    AS MCSIsClose
               , Object_Price_View.MCSIsCloseDateChange          AS MCSIsCloseDateChange
               , COALESCE(Object_Price_View.MCSNotRecalc,False)  AS MCSNotRecalc
               , Object_Price_View.MCSNotRecalcDateChange        AS MCSNotRecalcDateChange
               , COALESCE(Object_Price_View.Fix,False)           AS Fix
               , Object_Price_View.FixDateChange                 AS FixDateChange
               , SelectMinPrice_AllGoods.MinExpirationDate       AS MinExpirationDate

               , Object_Remains.Remains                          AS Remains
               , (Object_Remains.Remains * COALESCE (Object_Price_View.Price,0)) ::TFloat AS SummaRemains
               
               , CASE WHEN COALESCE (Object_Remains.Remains, 0) > COALESCE (Object_Price_View.MCSValue, 0) THEN COALESCE (Object_Remains.Remains, 0) - COALESCE (Object_Price_View.MCSValue, 0) ELSE 0 END :: TFloat AS RemainsNotMCS
               , CASE WHEN COALESCE (Object_Remains.Remains, 0) > COALESCE (Object_Price_View.MCSValue, 0) THEN (COALESCE (Object_Remains.Remains, 0) - COALESCE (Object_Price_View.MCSValue, 0)) * COALESCE (Object_Price_View.Price, 0) ELSE 0 END :: TFloat AS SummaNotMCS
               
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

                -- получаем значения цены и НТЗ из истории значений на дату                                                           
                LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                        ON ObjectHistory_Price.ObjectId = Object_Price_View.Id 
                                       AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                     --  AND vbStartDate >= ObjectHistory_Price.StartDate AND vbStartDate < ObjectHistory_Price.EndDate
                                       AND ObjectHistory_Price.EndDate = zc_DateEnd()
                -- получаем значения Количество дней для анализа НТЗ из истории значений на дату    
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MCSPeriod
                                             ON ObjectHistoryFloat_MCSPeriod.ObjectHistoryId = ObjectHistory_Price.Id
                                            AND ObjectHistoryFloat_MCSPeriod.DescId = zc_ObjectHistoryFloat_Price_MCSPeriod()
                -- получаем значения Страховой запас дней НТЗ из истории значений на дату    
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MCSDay
                                             ON ObjectHistoryFloat_MCSDay.ObjectHistoryId = ObjectHistory_Price.Id
                                            AND ObjectHistoryFloat_MCSDay.DescId = zc_ObjectHistoryFloat_Price_MCSDay() 
                                            
            WHERE (inisShowDel = True OR Object_Goods_View.isErased = False)
            ORDER BY GoodsGroupName, GoodsName;
    ELSE
        RETURN QUERY
        WITH 
        tmpRemeins AS (SELECT container.objectid ,
                              SUM(COALESCE(container.Amount,0)) ::TFloat AS Remains
                       FROM container
                       WHERE container.descid = zc_container_count() 
                         AND Amount<>0
                         AND Container.WhereObjectId = inUnitId
                       GROUP BY container.objectid
                       )
        
            SELECT
                 Object_Price_View.Id                      AS Id
               , COALESCE (Object_Price_View.Price,0)                     :: TFloat    AS Price
               , COALESCE (Object_Price_View.MCSValue,0)                  :: TFloat    AS MCSValue
               , COALESCE (ObjectHistoryFloat_MCSPeriod.ValueData, 0)     :: TFloat    AS MCSPeriod
               , COALESCE (ObjectHistoryFloat_MCSDay.ValueData, 0)        :: TFloat    AS MCSDay
               , COALESCE (ObjectHistory_Price.StartDate, NULL /*zc_DateStart()*/) :: TDateTime AS StartDate
                                        
               , Object_Goods_View.id                      AS GoodsId
               , Object_Goods_View.GoodsCodeInt            AS GoodsCode
               , Object_Goods_View.GoodsName               AS GoodsName
               , Object_Goods_View.GoodsGroupName          AS GoodsGroupName
               , Object_Goods_View.NDSKindName             AS NDSKindName
               , Object_Price_View.DateChange              AS DateChange
               , Object_Price_View.MCSDateChange           AS MCSDateChange
               , Object_Price_View.MCSIsClose              AS MCSIsClose
               , Object_Price_View.MCSIsCloseDateChange    AS MCSIsCloseDateChange
               , Object_Price_View.MCSNotRecalc            AS MCSNotRecalc
               , Object_Price_View.MCSNotRecalcDateChange  AS MCSNotRecalcDateChange
               , Object_Price_View.Fix                     AS Fix
               , Object_Price_View.FixDateChange           AS FixDateChange
               , SelectMinPrice_AllGoods.MinExpirationDate AS MinExpirationDate
               , Object_Remains.Remains                    AS Remains
               , (Object_Remains.Remains * COALESCE (Object_Price_View.Price,0)) ::TFloat AS SummaRemains

               , CASE WHEN COALESCE (Object_Remains.Remains, 0) > COALESCE (Object_Price_View.MCSValue, 0) THEN COALESCE (Object_Remains.Remains, 0) - COALESCE (Object_Price_View.MCSValue, 0) ELSE 0 END :: TFloat AS RemainsNotMCS
               , CASE WHEN COALESCE (Object_Remains.Remains, 0) > COALESCE (Object_Price_View.MCSValue, 0) THEN (COALESCE (Object_Remains.Remains, 0) - COALESCE (Object_Price_View.MCSValue, 0)) * COALESCE (Object_Price_View.Price, 0) ELSE 0 END :: TFloat AS SummaNotMCS
                              
               , Object_Goods_View.isErased                AS isErased 
               
            FROM Object_Price_View
                LEFT OUTER JOIN Object_Goods_View ON Object_Goods_View.id = object_price_view.goodsid
                LEFT OUTER JOIN tmpRemeins AS Object_Remains
                                           ON Object_Remains.ObjectId = Object_Price_View.GoodsId

                LEFT JOIN lpSelectMinPrice_AllGoods(inUnitId := inUnitId,
                                                     inObjectId := vbObjectId, 
                                                     inUserId := vbUserId) AS SelectMinPrice_AllGoods 
                                                                           ON SelectMinPrice_AllGoods.GoodsId = Object_Goods_View.Id
                --
                LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                        ON ObjectHistory_Price.ObjectId = Object_Price_View.Id 
                                       AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
--                                       AND vbStartDate >= ObjectHistory_Price.StartDate AND vbStartDate < ObjectHistory_Price.EndDate
                                       AND ObjectHistory_Price.EndDate = zc_DateEnd()
                -- получаем значения Количество дней для анализа НТЗ из истории значений на дату                    
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MCSPeriod
                                             ON ObjectHistoryFloat_MCSPeriod.ObjectHistoryId = ObjectHistory_Price.Id
                                            AND ObjectHistoryFloat_MCSPeriod.DescId = zc_ObjectHistoryFloat_Price_MCSPeriod()
                -- получаем значения Страховой запас дней НТЗ из истории значений на дату    
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_MCSDay
                                             ON ObjectHistoryFloat_MCSDay.ObjectHistoryId = ObjectHistory_Price.Id
                                            AND ObjectHistoryFloat_MCSDay.DescId = zc_ObjectHistoryFloat_Price_MCSDay() 
                
            WHERE Object_Price_View.unitid = inUnitId
              AND (inisShowDel = True OR Object_Goods_View.isErased = False)
            ORDER BY GoodsGroupName, GoodsName;
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_Price(Integer, Boolean,Boolean,TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А. 
 13.03.16         * убираем историю
 23.02.16         *
 22.12.15                                                         *
 29.08.15                                                         * + MCSIsClose, MCSNotRecalc
 09.06.15                        *

*/

-- тест
--select * from gpSelect_Object_Price(inUnitId := 183292 , inStartDate := ('24.02.2016 17:24:00')::TDateTime , inisShowAll := 'False' , inisShowDel := 'False' ,  inSession := '3');
