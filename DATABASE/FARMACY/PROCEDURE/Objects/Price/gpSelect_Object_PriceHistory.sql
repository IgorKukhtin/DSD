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
             , GoodsGroupName TVarChar, NDSKindName TVarChar, NDS TFloat
             , ConditionsKeepName TVarChar
             , Goods_isTop Boolean, Goods_PercentMarkup TFloat
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
    -- Контролшь использования подразделения
    inUnitId := gpGet_CheckingUser_Unit(inUnitId, inSession);

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
               ,NULL::TFloat                     AS NDS
               ,NULL::TVarChar                   AS ConditionsKeepName
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

   , tmpPrice_View AS (SELECT ObjectLink_Price_Unit.ObjectId          AS Id
                            , ROUND(Price_Value.ValueData,2)::TFloat  AS Price 
                            , MCS_Value.ValueData                     AS MCSValue 
                            , Price_Goods.ChildObjectId               AS GoodsId
                            , price_datechange.valuedata              AS DateChange 
                            , MCS_datechange.valuedata                AS MCSDateChange 
                            , COALESCE(MCS_isClose.ValueData,False)   AS MCSIsClose 
                            , MCSIsClose_DateChange.valuedata         AS MCSIsCloseDateChange
                            , COALESCE(MCS_NotRecalc.ValueData,False) AS MCSNotRecalc 
                            , MCSNotRecalc_DateChange.valuedata       AS MCSNotRecalcDateChange 
                            , COALESCE(Price_Fix.ValueData,False)     AS Fix 
                            , Fix_DateChange.valuedata                AS FixDateChange 
                            , COALESCE(Price_Top.ValueData,False)     AS isTop   
                            , Price_TOPDateChange.ValueData           AS TopDateChange 
                            , COALESCE(Price_PercentMarkup.ValueData, 0) ::TFloat AS PercentMarkup 
                            , Price_PercentMarkupDateChange.ValueData             AS PercentMarkupDateChange 
                       FROM ObjectLink        AS ObjectLink_Price_Unit
                            LEFT JOIN ObjectLink       AS Price_Goods
                                   ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                  AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                            LEFT JOIN ObjectFloat       AS Price_Value
                                   ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                  AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                            LEFT JOIN ObjectDate        AS Price_DateChange
                                   ON Price_DateChange.ObjectId = ObjectLink_Price_Unit.ObjectId
                                  AND Price_DateChange.DescId = zc_ObjectDate_Price_DateChange()
                            LEFT JOIN ObjectFloat       AS MCS_Value
                                    ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                   AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                            LEFT JOIN ObjectDate        AS MCS_DateChange
                                    ON MCS_DateChange.ObjectId = ObjectLink_Price_Unit.ObjectId
                                   AND MCS_DateChange.DescId = zc_ObjectDate_Price_MCSDateChange()
                            LEFT JOIN ObjectBoolean      AS MCS_isClose
                                    ON MCS_isClose.ObjectId = ObjectLink_Price_Unit.ObjectId
                                   AND MCS_isClose.DescId = zc_ObjectBoolean_Price_MCSIsClose()
                            LEFT JOIN ObjectDate        AS MCSIsClose_DateChange
                                    ON MCSIsClose_DateChange.ObjectId = ObjectLink_Price_Unit.ObjectId
                                   AND MCSIsClose_DateChange.DescId = zc_ObjectDate_Price_MCSIsCloseDateChange()
                            LEFT JOIN ObjectBoolean     AS MCS_NotRecalc
                                    ON MCS_NotRecalc.ObjectId = ObjectLink_Price_Unit.ObjectId
                                   AND MCS_NotRecalc.DescId = zc_ObjectBoolean_Price_MCSNotRecalc()
                            LEFT JOIN ObjectDate        AS MCSNotRecalc_DateChange
                                    ON MCSNotRecalc_DateChange.ObjectId = ObjectLink_Price_Unit.ObjectId
                                   AND MCSNotRecalc_DateChange.DescId = zc_ObjectDate_Price_MCSNotRecalcDateChange()
                            LEFT JOIN ObjectBoolean     AS Price_Fix
                                    ON Price_Fix.ObjectId = ObjectLink_Price_Unit.ObjectId
                                   AND Price_Fix.DescId = zc_ObjectBoolean_Price_Fix()
                            LEFT JOIN ObjectDate        AS Fix_DateChange
                                    ON Fix_DateChange.ObjectId = ObjectLink_Price_Unit.ObjectId
                                   AND Fix_DateChange.DescId = zc_ObjectDate_Price_FixDateChange()
                            LEFT JOIN ObjectBoolean     AS Price_Top
                                    ON Price_Top.ObjectId = ObjectLink_Price_Unit.ObjectId
                                   AND Price_Top.DescId = zc_ObjectBoolean_Price_Top()
                            LEFT JOIN ObjectDate        AS Price_TOPDateChange
                                    ON Price_TOPDateChange.ObjectId = ObjectLink_Price_Unit.ObjectId
                                   AND Price_TOPDateChange.DescId = zc_ObjectDate_Price_TOPDateChange()     
                            LEFT JOIN ObjectFloat       AS Price_PercentMarkup
                                    ON Price_PercentMarkup.ObjectId = ObjectLink_Price_Unit.ObjectId
                                   AND Price_PercentMarkup.DescId = zc_ObjectFloat_Price_PercentMarkup()
                            LEFT JOIN ObjectDate        AS Price_PercentMarkupDateChange
                                    ON Price_PercentMarkupDateChange.ObjectId = ObjectLink_Price_Unit.ObjectId
                                   AND Price_PercentMarkupDateChange.DescId = zc_ObjectDate_Price_PercentMarkupDateChange()    
                       WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                         AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
                       )
        
            SELECT
                tmpPrice_View.Id                            AS Id
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
               , Object_Goods_View.NDS                           AS NDS
               , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar  AS ConditionsKeepName
               , Object_Goods_View.isTop                         AS Goods_isTop
               , Object_Goods_View.PercentMarkup                 AS Goods_PercentMarkup
               , tmpPrice_View.DateChange                    AS DateChange
               , tmpPrice_View.MCSDateChange                 AS MCSDateChange
               , COALESCE(tmpPrice_View.MCSIsClose,False)    AS MCSIsClose
               , tmpPrice_View.MCSIsCloseDateChange          AS MCSIsCloseDateChange
               , COALESCE(tmpPrice_View.MCSNotRecalc,False)  AS MCSNotRecalc
               , tmpPrice_View.MCSNotRecalcDateChange        AS MCSNotRecalcDateChange
               , COALESCE(tmpPrice_View.Fix,False)           AS Fix
               , tmpPrice_View.FixDateChange                 AS FixDateChange
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
               
               , tmpPrice_View.isTop                AS isTop
               , tmpPrice_View.TopDateChange        AS TopDateChange

               , tmpPrice_View.PercentMarkup           AS PercentMarkup
               , tmpPrice_View.PercentMarkupDateChange AS PercentMarkupDateChange

               , Object_Goods_View.isErased                      AS isErased 
               
            FROM Object_Goods_View
                INNER JOIN ObjectLink ON ObjectLink.ObjectId = Object_Goods_View.Id 
                                     AND ObjectLink.ChildObjectId = vbObjectId
                LEFT OUTER JOIN tmpPrice_View ON tmpPrice_View.GoodsId = Object_Goods_View.id
                                   
                LEFT OUTER JOIN tmpRemeins AS Object_Remains
                                           ON Object_Remains.ObjectId = Object_Goods_View.Id
   
                LEFT JOIN lpSelectMinPrice_AllGoods(inUnitId := inUnitId,
                                                    inObjectId := vbObjectId, 
                                                    inUserId := vbUserId) AS SelectMinPrice_AllGoods
                                                                          ON SelectMinPrice_AllGoods.GoodsId = Object_Goods_View.Id

                -- получаем значения цены и НТЗ из истории значений на начало дня                                                          
                LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                        ON ObjectHistory_Price.ObjectId = tmpPrice_View.Id 
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
                                        ON ObjectHistory_PriceEnd.ObjectId = tmpPrice_View.Id 

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
                -- условия хранения
                LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep 
                                     ON ObjectLink_Goods_ConditionsKeep.ObjectId = Object_Goods_View.Id
                                    AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
                LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId

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

   , tmpPrice_View AS (SELECT ObjectLink_Price_Unit.ObjectId          AS Id
                            , ROUND(Price_Value.ValueData,2)::TFloat  AS Price 
                            , MCS_Value.ValueData                     AS MCSValue 
                            , Price_Goods.ChildObjectId               AS GoodsId
                            , price_datechange.valuedata              AS DateChange 
                            , MCS_datechange.valuedata                AS MCSDateChange 
                            , COALESCE(MCS_isClose.ValueData,False)   AS MCSIsClose 
                            , MCSIsClose_DateChange.valuedata         AS MCSIsCloseDateChange
                            , COALESCE(MCS_NotRecalc.ValueData,False) AS MCSNotRecalc 
                            , MCSNotRecalc_DateChange.valuedata       AS MCSNotRecalcDateChange 
                            , COALESCE(Price_Fix.ValueData,False)     AS Fix 
                            , Fix_DateChange.valuedata                AS FixDateChange 
                            , COALESCE(Price_Top.ValueData,False)     AS isTop   
                            , Price_TOPDateChange.ValueData           AS TopDateChange 
                            , COALESCE(Price_PercentMarkup.ValueData, 0) ::TFloat AS PercentMarkup 
                            , Price_PercentMarkupDateChange.ValueData             AS PercentMarkupDateChange 
                       FROM ObjectLink        AS ObjectLink_Price_Unit
                            LEFT JOIN ObjectLink       AS Price_Goods
                                   ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                  AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                            LEFT JOIN ObjectFloat       AS Price_Value
                                   ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                  AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                            LEFT JOIN ObjectDate        AS Price_DateChange
                                   ON Price_DateChange.ObjectId = ObjectLink_Price_Unit.ObjectId
                                  AND Price_DateChange.DescId = zc_ObjectDate_Price_DateChange()
                            LEFT JOIN ObjectFloat       AS MCS_Value
                                    ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                   AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                            LEFT JOIN ObjectDate        AS MCS_DateChange
                                    ON MCS_DateChange.ObjectId = ObjectLink_Price_Unit.ObjectId
                                   AND MCS_DateChange.DescId = zc_ObjectDate_Price_MCSDateChange()
                            LEFT JOIN ObjectBoolean      AS MCS_isClose
                                    ON MCS_isClose.ObjectId = ObjectLink_Price_Unit.ObjectId
                                   AND MCS_isClose.DescId = zc_ObjectBoolean_Price_MCSIsClose()
                            LEFT JOIN ObjectDate        AS MCSIsClose_DateChange
                                    ON MCSIsClose_DateChange.ObjectId = ObjectLink_Price_Unit.ObjectId
                                   AND MCSIsClose_DateChange.DescId = zc_ObjectDate_Price_MCSIsCloseDateChange()
                            LEFT JOIN ObjectBoolean     AS MCS_NotRecalc
                                    ON MCS_NotRecalc.ObjectId = ObjectLink_Price_Unit.ObjectId
                                   AND MCS_NotRecalc.DescId = zc_ObjectBoolean_Price_MCSNotRecalc()
                            LEFT JOIN ObjectDate        AS MCSNotRecalc_DateChange
                                    ON MCSNotRecalc_DateChange.ObjectId = ObjectLink_Price_Unit.ObjectId
                                   AND MCSNotRecalc_DateChange.DescId = zc_ObjectDate_Price_MCSNotRecalcDateChange()
                            LEFT JOIN ObjectBoolean     AS Price_Fix
                                    ON Price_Fix.ObjectId = ObjectLink_Price_Unit.ObjectId
                                   AND Price_Fix.DescId = zc_ObjectBoolean_Price_Fix()
                            LEFT JOIN ObjectDate        AS Fix_DateChange
                                    ON Fix_DateChange.ObjectId = ObjectLink_Price_Unit.ObjectId
                                   AND Fix_DateChange.DescId = zc_ObjectDate_Price_FixDateChange()
                            LEFT JOIN ObjectBoolean     AS Price_Top
                                    ON Price_Top.ObjectId = ObjectLink_Price_Unit.ObjectId
                                   AND Price_Top.DescId = zc_ObjectBoolean_Price_Top()
                            LEFT JOIN ObjectDate        AS Price_TOPDateChange
                                    ON Price_TOPDateChange.ObjectId = ObjectLink_Price_Unit.ObjectId
                                   AND Price_TOPDateChange.DescId = zc_ObjectDate_Price_TOPDateChange()     
                            LEFT JOIN ObjectFloat       AS Price_PercentMarkup
                                    ON Price_PercentMarkup.ObjectId = ObjectLink_Price_Unit.ObjectId
                                   AND Price_PercentMarkup.DescId = zc_ObjectFloat_Price_PercentMarkup()
                            LEFT JOIN ObjectDate        AS Price_PercentMarkupDateChange
                                    ON Price_PercentMarkupDateChange.ObjectId = ObjectLink_Price_Unit.ObjectId
                                   AND Price_PercentMarkupDateChange.DescId = zc_ObjectDate_Price_PercentMarkupDateChange()    
                       WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                         AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
                       )
        
            SELECT
                 tmpPrice_View.Id                          AS Id
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
               , Object_Goods_View.NDS                     AS NDS
               , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar  AS ConditionsKeepName
               , Object_Goods_View.isTop                   AS Goods_isTop
               , Object_Goods_View.PercentMarkup           AS Goods_PercentMarkup
               , tmpPrice_View.DateChange                  AS DateChange
               , tmpPrice_View.MCSDateChange               AS MCSDateChange
               , tmpPrice_View.MCSIsClose                  AS MCSIsClose
               , tmpPrice_View.MCSIsCloseDateChange        AS MCSIsCloseDateChange
               , tmpPrice_View.MCSNotRecalc                AS MCSNotRecalc
               , tmpPrice_View.MCSNotRecalcDateChange      AS MCSNotRecalcDateChange
               , tmpPrice_View.Fix                         AS Fix
               , tmpPrice_View.FixDateChange               AS FixDateChange
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
                              
               , tmpPrice_View.isTop                       AS isTop
               , tmpPrice_View.TopDateChange               AS TopDateChange

               , tmpPrice_View.PercentMarkup               AS PercentMarkup
               , tmpPrice_View.PercentMarkupDateChange     AS PercentMarkupDateChange
 
               , Object_Goods_View.isErased                AS isErased 
               
            FROM tmpPrice_View
                LEFT OUTER JOIN Object_Goods_View ON Object_Goods_View.id = tmpPrice_View.GoodsId
                LEFT OUTER JOIN tmpRemeins AS Object_Remains
                                           ON Object_Remains.ObjectId = tmpPrice_View.GoodsId

                LEFT JOIN lpSelectMinPrice_AllGoods(inUnitId := inUnitId,
                                                     inObjectId := vbObjectId, 
                                                     inUserId := vbUserId) AS SelectMinPrice_AllGoods 
                                                                           ON SelectMinPrice_AllGoods.GoodsId = Object_Goods_View.Id
                -- получаем значения цены и НТЗ из истории значений на дату                                                           
                LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                        ON ObjectHistory_Price.ObjectId = tmpPrice_View.Id 
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
                                        ON ObjectHistory_PriceEnd.ObjectId = tmpPrice_View.Id 
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
                                               
                -- условия хранения
                LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep 
                                     ON ObjectLink_Goods_ConditionsKeep.ObjectId = Object_Goods_View.id
                                    AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
                LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId
             
            WHERE (inisShowDel = True OR Object_Goods_View.isErased = False)
            ORDER BY GoodsGroupName, GoodsName;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.  Шаблий О.В. 
 11.08.18                                                                       *
 05.01.18         *
 12.06.17         *
 12.11.17         *
 04.07.16         *
 30.06.16         *
 13.03.16         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_PriceHistory(inUnitId := 183292 , inStartDate := ('24.02.2016 17:24:00')::TDateTime , inisShowAll := 'False' , inisShowDel := 'False' ,  inSession := '3')
--limit 1000;
