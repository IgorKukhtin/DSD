-- Function: gpSelect_Object_Price (TVarChar)
/*
  процедура так же вызывается в программе PROJECT\DSD\DPR\SavePriceToXls.dpr
  unit: SaveToXlsUnit
  row: 167 = qryPrice.SQL.Text := 'Select * from gpSelect_Object_Price...
  exe класть на //91.210.37.210:2511/d$/ (его запускает служба)
*/
DROP FUNCTION IF EXISTS gpSelect_Object_Price(Integer, Boolean,Boolean,TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Price(Integer, TDateTime, Boolean,Boolean,TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Price(Integer, Integer, Boolean,Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Price(
    IN inUnitId      Integer,       -- подразделение
    IN inGoodsId     Integer,       -- Товар
    IN inisShowAll   Boolean,       -- True - показать все товары, False - показать только с ценами
    IN inisShowDel   Boolean,       -- True - показать так же удаленные, False - показать только рабочие
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Price TFloat, MCSValue TFloat
             , MCSPeriod TFloat, MCSDay TFloat, StartDate TDateTime
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupName TVarChar, NDSKindName TVarChar
             , Goods_isTop Boolean, Goods_PercentMarkup TFloat
             , DateChange TDateTime, MCSDateChange TDateTime
             , MCSIsClose Boolean, MCSIsCloseDateChange TDateTime
             , MCSNotRecalc Boolean, MCSNotRecalcDateChange TDateTime
             , Fix Boolean, FixDateChange TDateTime
             , MinExpirationDate TDateTime
             , Remains TFloat, SummaRemains TFloat
             , RemainsNotMCS TFloat, SummaNotMCS TFloat
             , isErased boolean
             , isClose boolean, isFirst boolean , isSecond boolean
             , isPromo boolean
             , isTop boolean, TOPDateChange TDateTime
             , PercentMarkup TFloat, PercentMarkupDateChange TDateTime
             , Color_ExpirationDate Integer
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
               ,NULL::Boolean                    AS Goods_isTop
               ,NULL::TFloat                     AS Goods_PercentMarkup
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
               ,NULL::Boolean                    AS isClose 
               ,NULL::Boolean                    AS isFirst 
               ,NULL::Boolean                    AS isSecond 
               ,NULL::Boolean                    AS isPromo 
               ,NULL::Boolean                    AS isTop 
               ,NULL::TDateTime                  AS TOPDateChange
               ,NULL::TFloat                     AS PercentMarkup 
               ,NULL::TDateTime                  AS PercentMarkupDateChange
               ,zc_Color_Black()                 AS Color_ExpirationDate 
            WHERE 1=0;
    ELSEIF inisShowAll = True
    THEN
        RETURN QUERY
        With 
        tmpContainerRemeins AS (SELECT container.objectid
                                     , Sum(COALESCE(container.Amount,0)) ::TFloat AS Remains
                                     , Container.Id   AS  ContainerId
                                FROM container
                                WHERE container.descid = zc_container_count() 
                                  AND Amount<>0
                                  AND Container.WhereObjectId = inUnitId
                                  AND (Container.objectid = inGoodsId OR inGoodsId = 0)
                                GROUP BY container.objectid, Container.Id
                                HAVING SUM(COALESCE (Container.Amount, 0)) <> 0
                                )
      , tmpRemeins AS (SELECT tmp.Objectid
                            , Sum(tmp.Remains)  ::TFloat  AS Remains
                            , MIN(COALESCE(MIDate_ExpirationDate.ValueData,zc_DateEnd()))::TDateTime AS MinExpirationDate -- Срок годности
                       FROM tmpContainerRemeins AS tmp
                              -- находим партию
                              LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                            ON ContainerLinkObject_MovementItem.Containerid =  tmp.ContainerId
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
                      
                              LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                                ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                                               AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                       GROUP BY tmp.Objectid
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
                                    INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                          ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_retail.ChildObjectId
                                                         AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                         AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                         )
        
            SELECT
                 Object_Price_View.Id                                               AS Id
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
               , Object_Goods_View.isTop                         AS Goods_isTop
               , Object_Goods_View.PercentMarkup                 AS Goods_PercentMarkup
               , Object_Price_View.DateChange                    AS DateChange
               , Object_Price_View.MCSDateChange                 AS MCSDateChange
               , COALESCE(Object_Price_View.MCSIsClose,False)    AS MCSIsClose
               , Object_Price_View.MCSIsCloseDateChange          AS MCSIsCloseDateChange
               , COALESCE(Object_Price_View.MCSNotRecalc,False)  AS MCSNotRecalc
               , Object_Price_View.MCSNotRecalcDateChange        AS MCSNotRecalcDateChange
               , COALESCE(Object_Price_View.Fix,False)           AS Fix

               , Object_Price_View.FixDateChange                 AS FixDateChange
               , Object_Remains.MinExpirationDate                AS MinExpirationDate   --SelectMinPrice_AllGoods.MinExpirationDate AS MinExpirationDate

               , Object_Remains.Remains                          AS Remains
               , (Object_Remains.Remains * COALESCE (Object_Price_View.Price,0)) ::TFloat AS SummaRemains
               
               , CASE WHEN COALESCE (Object_Remains.Remains, 0) > COALESCE (Object_Price_View.MCSValue, 0) THEN COALESCE (Object_Remains.Remains, 0) - COALESCE (Object_Price_View.MCSValue, 0) ELSE 0 END :: TFloat AS RemainsNotMCS
               , CASE WHEN COALESCE (Object_Remains.Remains, 0) > COALESCE (Object_Price_View.MCSValue, 0) THEN (COALESCE (Object_Remains.Remains, 0) - COALESCE (Object_Price_View.MCSValue, 0)) * COALESCE (Object_Price_View.Price, 0) ELSE 0 END :: TFloat AS SummaNotMCS
               
               , Object_Goods_View.isErased                      AS isErased 

               , Object_Goods_View.isClose
               , Object_Goods_View.isFirst
               , Object_Goods_View.isSecond
               , CASE WHEN COALESCE(GoodsPromo.GoodsId,0) <> 0 THEN TRUE ELSE FALSE END AS isPromo

               , Object_Price_View.isTop                   AS isTop
               , Object_Price_View.TopDateChange           AS TopDateChange

               , Object_Price_View.PercentMarkup           AS PercentMarkup
               , Object_Price_View.PercentMarkupDateChange AS PercentMarkupDateChange
               
               , CASE WHEN Object_Remains.MinExpirationDate < CURRENT_DATE + interval '6 MONTH' THEN zc_Color_Blue() 
                      WHEN (Object_Price_View.isTop = TRUE OR Object_Goods_View.isTop = TRUE) THEN 15993821 -- розовый
                      ELSE zc_Color_Black() 
                 END     AS Color_ExpirationDate                --vbAVGDateEnd

            FROM Object_Goods_View
                INNER JOIN ObjectLink ON ObjectLink.ObjectId = Object_Goods_View.Id 
                                     AND ObjectLink.ChildObjectId = vbObjectId
                LEFT OUTER JOIN Object_Price_View ON Object_Goods_View.id = object_price_view.goodsid
                                                 AND Object_Price_View.unitid = inUnitId
                LEFT OUTER JOIN tmpRemeins AS Object_Remains
                                           ON Object_Remains.ObjectId = Object_Goods_View.Id
   
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
                LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId = Object_Goods_View.Id                             
            WHERE (inisShowDel = True OR Object_Goods_View.isErased = False)
              AND (Object_Goods_View.Id = inGoodsId OR inGoodsId = 0)
            ORDER BY GoodsGroupName, GoodsName;
    ELSE
        RETURN QUERY
        WITH 
        tmpContainerRemeins AS (SELECT container.objectid
                                     , Sum(COALESCE(container.Amount,0)) ::TFloat AS Remains
                                     , Container.Id   AS  ContainerId
                                FROM container
                                WHERE container.descid = zc_container_count() 
                                  AND Amount<>0
                                  AND Container.WhereObjectId = inUnitId
                                  AND (Container.objectid = inGoodsId OR inGoodsId = 0)
                                GROUP BY container.objectid, Container.Id
                                HAVING SUM(COALESCE (Container.Amount, 0)) <> 0
                                )
      , tmpRemeins AS (SELECT tmp.Objectid
                            , Sum(tmp.Remains)  ::TFloat  AS Remains
                            , MIN(COALESCE(MIDate_ExpirationDate.ValueData,zc_DateEnd()))::TDateTime AS MinExpirationDate -- Срок годности
                       FROM tmpContainerRemeins AS tmp
                              -- находим партию
                              LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                            ON ContainerLinkObject_MovementItem.Containerid =  tmp.ContainerId
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
                      
                              LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                                ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                                               AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                       GROUP BY tmp.Objectid
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
                                    INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                          ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_retail.ChildObjectId
                                                         AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                         AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
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
               , Object_Goods_View.isTop                   AS Goods_isTop
               , Object_Goods_View.PercentMarkup           AS Goods_PercentMarkup
               , Object_Price_View.DateChange              AS DateChange
               , Object_Price_View.MCSDateChange           AS MCSDateChange
               , Object_Price_View.MCSIsClose              AS MCSIsClose
               , Object_Price_View.MCSIsCloseDateChange    AS MCSIsCloseDateChange
               , Object_Price_View.MCSNotRecalc            AS MCSNotRecalc
               , Object_Price_View.MCSNotRecalcDateChange  AS MCSNotRecalcDateChange
               , Object_Price_View.Fix                     AS Fix
               , Object_Price_View.FixDateChange           AS FixDateChange
               , Object_Remains.MinExpirationDate          AS MinExpirationDate   --, CASE WHEN inGoodsId = 0 THEN SelectMinPrice_AllGoods.MinExpirationDate ELSE SelectMinPrice_List.PartionGoodsDate END AS MinExpirationDate
               , Object_Remains.Remains                    AS Remains
               , (Object_Remains.Remains * COALESCE (Object_Price_View.Price,0)) ::TFloat AS SummaRemains

               , CASE WHEN COALESCE (Object_Remains.Remains, 0) > COALESCE (Object_Price_View.MCSValue, 0) THEN COALESCE (Object_Remains.Remains, 0) - COALESCE (Object_Price_View.MCSValue, 0) ELSE 0 END :: TFloat AS RemainsNotMCS
               , CASE WHEN COALESCE (Object_Remains.Remains, 0) > COALESCE (Object_Price_View.MCSValue, 0) THEN (COALESCE (Object_Remains.Remains, 0) - COALESCE (Object_Price_View.MCSValue, 0)) * COALESCE (Object_Price_View.Price, 0) ELSE 0 END :: TFloat AS SummaNotMCS
                              
               , Object_Goods_View.isErased                AS isErased 

               , Object_Goods_View.isClose
               , Object_Goods_View.isFirst
               , Object_Goods_View.isSecond
               , CASE WHEN COALESCE(GoodsPromo.GoodsId,0) <> 0 THEN TRUE ELSE FALSE END AS isPromo

               , Object_Price_View.isTop                AS isTop
               , Object_Price_View.TopDateChange        AS TopDateChange

               , Object_Price_View.PercentMarkup           AS PercentMarkup
               , Object_Price_View.PercentMarkupDateChange AS PercentMarkupDateChange

               , CASE WHEN Object_Remains.MinExpirationDate < CURRENT_DATE + interval '6 MONTH' THEN zc_Color_Blue() 
                      WHEN (Object_Price_View.isTop = TRUE OR Object_Goods_View.isTop = TRUE) THEN 15993821 -- розовый
                      ELSE zc_Color_Black() 
                 END      AS Color_ExpirationDate                --vbAVGDateEnd
               
            FROM Object_Price_View
                LEFT OUTER JOIN Object_Goods_View ON Object_Goods_View.id = object_price_view.goodsid
                LEFT OUTER JOIN tmpRemeins AS Object_Remains
                                           ON Object_Remains.ObjectId = Object_Price_View.GoodsId

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
                LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId = Object_Goods_View.Id
            WHERE Object_Price_View.unitid = inUnitId
              AND (inisShowDel = True OR Object_Goods_View.isErased = False)
              AND (Object_Goods_View.Id = inGoodsId OR inGoodsId = 0)
            ORDER BY GoodsGroupName, GoodsName;
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_Price(Integer, Boolean,Boolean,TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А. 
 06.09.16         *
 11.07.16         *
 04.07.16         *
 30.06.16         *
 12.04.16         *
 13.03.16         * убираем историю
 23.02.16         *
 22.12.15                                                         *
 29.08.15                                                         * + MCSIsClose, MCSNotRecalc
 09.06.15                        *

*/
/*
-- !!!ERROR - UPDATE!!!
-- update  ObjectHistory set EndDate = coalesce (tmp.StartDate, zc_DateEnd()) from (
with tmp as (
select ObjectHistory_Price.*
     , Row_Number() OVER (PARTITION BY ObjectHistory_Price.ObjectId ORDER BY ObjectHistory_Price.StartDate Asc, ObjectHistory_Price.Id) AS Ord
from ObjectHistory AS ObjectHistory_Price
-- Where ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
)

select  tmp.Id, tmp.ObjectId, tmp.EndDate,  tmp2.StartDate, tmp2.Ord, ObjectHistoryDesc.Code
from tmp
     left join tmp as tmp2 on tmp2.ObjectId = tmp.ObjectId and tmp2.Ord = tmp.Ord + 1 and tmp2.DescId = tmp.DescId
     left join ObjectHistoryDesc on ObjectHistoryDesc. Id = tmp.DescId
where tmp.EndDate <> coalesce (tmp2.StartDate, zc_DateEnd())
 order by 3
-- ) as tmp where tmp.Id = ObjectHistory.Id
-- select * from ObjectHistory   where ObjectId = 558863 order by EndDate, StartDate
-- select ObjectHistoryDesc.Code, ObjectId, StartDate, count (*) from ObjectHistory  join ObjectHistoryDesc on ObjectHistoryDesc. Id = DescId group by ObjectHistoryDesc.Code, ObjectId, StartDate having count (*) > 1
*/
-- тест
-- select * from gpSelect_Object_Price(inUnitId := 183292 , inStartDate := ('24.02.2016 17:24:00')::TDateTime , inisShowAll := 'False' , inisShowDel := 'False' ,  inSession := '3');
