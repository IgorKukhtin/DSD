-- Function: gpSelect_Object_Price_Lite (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Price_Lite(Integer, Integer, Boolean,Boolean,TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Object_Price_Lite(
    IN inUnitId      Integer,       -- подразделение
    IN inGoodsId     Integer,       -- Товар
    IN inisShowAll   Boolean,       -- True - показать все товары, False - показать только с ценами
    IN inisShowDel   Boolean,       -- True - показать так же удаленные, False - показать только рабочие
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Price TFloat, MCSValue TFloat, MCSValue_min TFloat
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupName TVarChar, NDSKindName TVarChar
             , Goods_isTop Boolean, Goods_PercentMarkup TFloat
             , DateChange TDateTime, MCSDateChange TDateTime
             , MCSIsClose Boolean, MCSIsCloseDateChange TDateTime
             , MCSNotRecalc Boolean, MCSNotRecalcDateChange TDateTime
             , Fix Boolean, FixDateChange TDateTime
             , isErased boolean
             , isClose boolean, isFirst boolean , isSecond boolean
             , isTop boolean, TOPDateChange TDateTime
             , PercentMarkup TFloat, PercentMarkupDateChange TDateTime
             , MCSValueOld TFloat
             , StartDateMCSAuto TDateTime, EndDateMCSAuto TDateTime
             , isMCSAuto Boolean, isMCSNotRecalcOld Boolean
             , Remains TFloat
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
    IF COALESCE (inUnitId,0) = 0
    THEN
        RETURN QUERY
            SELECT 
                NULL::Integer                    AS Id
               ,NULL::TFloat                     AS Price
               ,NULL::TFloat                     AS MCSValue
               ,NULL::TFloat                     AS MCSValue_min
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

               ,NULL::Boolean                    AS isErased
               ,NULL::Boolean                    AS isClose 
               ,NULL::Boolean                    AS isFirst 
               ,NULL::Boolean                    AS isSecond 
               ,NULL::Boolean                    AS isTop 
               ,NULL::TDateTime                  AS TOPDateChange
               ,NULL::TFloat                     AS PercentMarkup 
               ,NULL::TDateTime                  AS PercentMarkupDateChange

               ,NULL::TFloat                     AS MCSValueOld
               ,NULL::TDateTime                  AS StartDateMCSAuto
               ,NULL::TDateTime                  AS EndDateMCSAuto
               ,NULL::Boolean                    AS isMCSAuto
               ,NULL::Boolean                    AS isMCSNotRecalcOld
               ,NULL::TFloat                     AS Remains

           WHERE 1=0;
    ELSEIF inisShowAll = True
    THEN
        RETURN QUERY
        WITH 
        -- данные по товарам
        tmpGoods AS (SELECT ObjectLink_Goods_Object.ObjectId                AS GoodsId
                          , Object_Goods.ObjectCode                         AS GoodsCode
                          , Object_Goods.ValueData                          AS GoodsName
                          , Object_GoodsGroup.ValueData                     AS GoodsGroupName
                          , Object_NDSKind.ValueData                        AS NDSKindName
                          , COALESCE (ObjectBoolean_Goods_TOP.ValueData, false) AS isTop
                          , ObjectFloat_Goods_PercentMarkup.ValueData           AS PercentMarkup
                 
                          , Object_Goods.isErased                               AS isErased 
                      
                          , COALESCE (ObjectBoolean_Goods_Close.ValueData, false) AS isClose
                          , COALESCE (ObjectBoolean_First.ValueData, False)       AS isFirst
                          , COALESCE (ObjectBoolean_Second.ValueData, False)      AS isSecond

                     FROM ObjectLink AS ObjectLink_Goods_Object
                        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_Object.ObjectId 

                        LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = ObjectLink_Goods_Object.ObjectId
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                        LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
        
                        LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                               ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
                        LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId

                        LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Close
                               ON ObjectBoolean_Goods_Close.ObjectId = ObjectLink_Goods_Object.ObjectId 
                              AND ObjectBoolean_Goods_Close.DescId = zc_ObjectBoolean_Goods_Close()   

                        LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                               ON ObjectBoolean_Goods_TOP.ObjectId = ObjectLink_Goods_Object.ObjectId 
                              AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()  
            
                        LEFT JOIN ObjectBoolean AS ObjectBoolean_First
                               ON ObjectBoolean_First.ObjectId = ObjectLink_Goods_Object.ObjectId 
                              AND ObjectBoolean_First.DescId = zc_ObjectBoolean_Goods_First() 
        
                        LEFT JOIN ObjectBoolean AS ObjectBoolean_Second
                               ON ObjectBoolean_Second.ObjectId = ObjectLink_Goods_Object.ObjectId 
                              AND ObjectBoolean_Second.DescId = zc_ObjectBoolean_Goods_Second() 
    
                        LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_PercentMarkup
                               ON ObjectFloat_Goods_PercentMarkup.ObjectId = ObjectLink_Goods_Object.ObjectId 
                              AND ObjectFloat_Goods_PercentMarkup.DescId = zc_ObjectFloat_Goods_PercentMarkup()   

                     WHERE ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                       AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId  
                       AND (ObjectLink_Goods_Object.ObjectId = inGoodsId OR inGoodsId = 0)
                       AND (inisShowDel = True OR Object_Goods.isErased = False)
                    )

      -- данные из прай листа
      , tmpPrice AS (SELECT Object_Price.Id                            AS Id
                          , Price_Goods.ChildObjectId                  AS GoodsId
                          , ROUND(Price_Value.ValueData,2)   ::TFloat  AS Price
                          , COALESCE (MCS_Value.ValueData,0) ::TFloat  AS MCSValue
                          , COALESCE(Price_MCSValueMin.ValueData,0) ::TFloat AS MCSValue_min
                          , price_datechange.valuedata                 AS DateChange
                          , MCS_datechange.valuedata                   AS MCSDateChange
                          , COALESCE (MCS_isClose.ValueData,False)     AS MCSIsClose
                          , MCSIsClose_DateChange.valuedata            AS MCSIsCloseDateChange
                          , COALESCE (MCS_NotRecalc.ValueData,False)   AS MCSNotRecalc
                          , MCSNotRecalc_DateChange.valuedata          AS MCSNotRecalcDateChange
                          , COALESCE (Price_Fix.ValueData,False)       AS Fix
                          , Fix_DateChange.valuedata                   AS FixDateChange
                          , COALESCE (Price_Top.ValueData,False)       AS isTop
                          , Price_TOPDateChange.ValueData              AS TopDateChange

                          , COALESCE (Price_PercentMarkup.ValueData, 0) ::TFloat AS PercentMarkup
                          , Price_PercentMarkupDateChange.ValueData              AS PercentMarkupDateChange

                          , COALESCE(Price_MCSValueOld.ValueData,0)    ::TFloat AS MCSValueOld         
                          , MCS_StartDateMCSAuto.ValueData                      AS StartDateMCSAuto
                          , MCS_EndDateMCSAuto.ValueData                        AS EndDateMCSAuto
                          , COALESCE(Price_MCSAuto.ValueData,False)          :: Boolean   AS isMCSAuto
                          , COALESCE(Price_MCSNotRecalcOld.ValueData,False)  :: Boolean   AS isMCSNotRecalcOld
                     FROM Object AS Object_Price
                        INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                ON ObjectLink_Price_Unit.ObjectId = Object_Price.Id
                               AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                               AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
                        LEFT JOIN ObjectFloat AS Price_Value
                               ON Price_Value.ObjectId = Object_Price.Id
                              AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                        LEFT JOIN ObjectDate        AS Price_DateChange
                               ON Price_DateChange.ObjectId = Object_Price.Id
                              AND Price_DateChange.DescId = zc_ObjectDate_Price_DateChange()
                        LEFT JOIN ObjectFloat       AS MCS_Value
                               ON MCS_Value.ObjectId = Object_Price.Id
                              AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                        LEFT JOIN ObjectDate        AS MCS_DateChange
                               ON MCS_DateChange.ObjectId = Object_Price.Id
                              AND MCS_DateChange.DescId = zc_ObjectDate_Price_MCSDateChange()
                        LEFT JOIN ObjectLink        AS Price_Goods
                               ON Price_Goods.ObjectId = Object_Price.Id
                              AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()

                        LEFT JOIN ObjectBoolean      AS MCS_isClose
                               ON MCS_isClose.ObjectId = Object_Price.Id
                              AND MCS_isClose.DescId = zc_ObjectBoolean_Price_MCSIsClose()
                        LEFT JOIN ObjectDate        AS MCSIsClose_DateChange
                               ON MCSIsClose_DateChange.ObjectId = Object_Price.Id
                              AND MCSIsClose_DateChange.DescId = zc_ObjectDate_Price_MCSIsCloseDateChange()
                        LEFT JOIN ObjectBoolean     AS MCS_NotRecalc
                               ON MCS_NotRecalc.ObjectId = Object_Price.Id
                              AND MCS_NotRecalc.DescId = zc_ObjectBoolean_Price_MCSNotRecalc()
                        LEFT JOIN ObjectDate        AS MCSNotRecalc_DateChange
                               ON MCSNotRecalc_DateChange.ObjectId = Object_Price.Id
                              AND MCSNotRecalc_DateChange.DescId = zc_ObjectDate_Price_MCSNotRecalcDateChange()
                        LEFT JOIN ObjectBoolean     AS Price_Fix
                               ON Price_Fix.ObjectId = Object_Price.Id
                              AND Price_Fix.DescId = zc_ObjectBoolean_Price_Fix()
                        LEFT JOIN ObjectDate        AS Fix_DateChange
                               ON Fix_DateChange.ObjectId = Object_Price.Id
                              AND Fix_DateChange.DescId = zc_ObjectDate_Price_FixDateChange()
                        LEFT JOIN ObjectBoolean     AS Price_Top
                               ON Price_Top.ObjectId = Object_Price.Id
                              AND Price_Top.DescId = zc_ObjectBoolean_Price_Top()
                       LEFT JOIN ObjectDate        AS Price_TOPDateChange
                              ON Price_TOPDateChange.ObjectId = Object_Price.Id
                             AND Price_TOPDateChange.DescId = zc_ObjectDate_Price_TOPDateChange()     

                        LEFT JOIN ObjectFloat       AS Price_PercentMarkup
                               ON Price_PercentMarkup.ObjectId = Object_Price.Id
                              AND Price_PercentMarkup.DescId = zc_ObjectFloat_Price_PercentMarkup()
                        LEFT JOIN ObjectDate        AS Price_PercentMarkupDateChange
                               ON Price_PercentMarkupDateChange.ObjectId = Object_Price.Id
                              AND Price_PercentMarkupDateChange.DescId = zc_ObjectDate_Price_PercentMarkupDateChange() 

                        LEFT JOIN ObjectDate        AS MCS_StartDateMCSAuto
                               ON MCS_StartDateMCSAuto.ObjectId = ObjectLink_Price_Unit.ObjectId
                              AND MCS_StartDateMCSAuto.DescId = zc_ObjectDate_Price_StartDateMCSAuto()
                        LEFT JOIN ObjectDate        AS MCS_EndDateMCSAuto
                               ON MCS_EndDateMCSAuto.ObjectId = ObjectLink_Price_Unit.ObjectId
                              AND MCS_EndDateMCSAuto.DescId = zc_ObjectDate_Price_EndDateMCSAuto()
                        LEFT JOIN ObjectFloat       AS Price_MCSValueOld
                               ON Price_MCSValueOld.ObjectId = ObjectLink_Price_Unit.ObjectId
                              AND Price_MCSValueOld.DescId = zc_ObjectFloat_Price_MCSValueOld()
                        LEFT JOIN ObjectBoolean     AS Price_MCSAuto
                               ON Price_MCSAuto.ObjectId = ObjectLink_Price_Unit.ObjectId
                              AND Price_MCSAuto.DescId = zc_ObjectBoolean_Price_MCSAuto()
                        LEFT JOIN ObjectBoolean     AS Price_MCSNotRecalcOld
                               ON Price_MCSNotRecalcOld.ObjectId = ObjectLink_Price_Unit.ObjectId
                              AND Price_MCSNotRecalcOld.DescId = zc_ObjectBoolean_Price_MCSNotRecalcOld()
                        LEFT JOIN ObjectFloat AS Price_MCSValueMin
                                              ON Price_MCSValueMin.ObjectId = ObjectLink_Price_Unit.ObjectId
                                             AND Price_MCSValueMin.DescId = zc_ObjectFloat_Price_MCSValueMin()
                     WHERE Object_Price.DescId = zc_Object_Price()
                    )
      , tmpContainerCount AS (SELECT Container.ObjectId              AS GoodsId
                                   , Sum(Container.Amount)::TFloat   AS Remains
                              FROM Container
                              WHERE Container.DescId = zc_Container_count()
                                AND Container.WhereObjectId = inUnitId
                                AND Container.Amount <> 0
                              GROUP BY Container.ObjectId
                              )      

            SELECT tmpPrice.Id                            AS Id
                 , COALESCE (tmpPrice.Price,0)   ::TFloat AS Price
                 , COALESCE (tmpPrice.MCSValue,0)::TFloat AS MCSValue
                 , COALESCE (tmpPrice.MCSValue_min,0)::TFloat AS MCSValue_min
                              
                 , tmpGoods.GoodsId
                 , tmpGoods.GoodsCode                      AS GoodsCode
                 , tmpGoods.GoodsName                      AS GoodsName
                 , tmpGoods.GoodsGroupName                 AS GoodsGroupName
                 , tmpGoods.NDSKindName                    AS NDSKindName
                 , tmpGoods.isTop                          AS Goods_isTop
                 , tmpGoods.PercentMarkup                  AS Goods_PercentMarkup
                 , tmpPrice.DateChange                     AS DateChange
                 , tmpPrice.MCSDateChange                  AS MCSDateChange
                 , COALESCE (tmpPrice.MCSIsClose,False)    AS MCSIsClose
                 , tmpPrice.MCSIsCloseDateChange           AS MCSIsCloseDateChange
                 , COALESCE (tmpPrice.MCSNotRecalc,False)  AS MCSNotRecalc
                 , tmpPrice.MCSNotRecalcDateChange         AS MCSNotRecalcDateChange
                 , COALESCE (tmpPrice.Fix,False)           AS Fix
                 , tmpPrice.FixDateChange                  AS FixDateChange
                 , tmpGoods.isErased                       AS isErased 
                 , tmpGoods.isClose
                 , tmpGoods.isFirst
                 , tmpGoods.isSecond
                 , tmpPrice.isTop                   AS isTop
                 , tmpPrice.TopDateChange           AS TopDateChange
                 , tmpPrice.PercentMarkup           AS PercentMarkup
                 , tmpPrice.PercentMarkupDateChange AS PercentMarkupDateChange
                       
                 , tmpPrice.MCSValueOld
                 , tmpPrice.StartDateMCSAuto
                 , tmpPrice.EndDateMCSAuto
                 , tmpPrice.isMCSAuto
                 , tmpPrice.isMCSNotRecalcOld       
                 , tmpContainerCount.Remains 
              FROM tmpGoods
                LEFT OUTER JOIN tmpPrice ON  tmpPrice.goodsid = tmpGoods.GoodsId
                LEFT JOIN tmpContainerCount ON tmpContainerCount.goodsid = tmpPrice.goodsid
            ORDER BY GoodsGroupName, GoodsName;
    ELSE
        RETURN QUERY
          WITH      
        -- данные по товарам
        tmpGoods AS (SELECT ObjectLink_Goods_Object.ObjectId                AS GoodsId
                          , Object_Goods.ObjectCode                         AS GoodsCode
                          , Object_Goods.ValueData                          AS GoodsName
                          , Object_GoodsGroup.ValueData                     AS GoodsGroupName
                          , Object_NDSKind.ValueData                        AS NDSKindName
                          , COALESCE (ObjectBoolean_Goods_TOP.ValueData, false) AS isTop
                          , ObjectFloat_Goods_PercentMarkup.ValueData           AS PercentMarkup
                 
                          , Object_Goods.isErased                               AS isErased 
                      
                          , COALESCE (ObjectBoolean_Goods_Close.ValueData, false) AS isClose
                          , COALESCE (ObjectBoolean_First.ValueData, False)       AS isFirst
                          , COALESCE (ObjectBoolean_Second.ValueData, False)      AS isSecond

                     FROM ObjectLink AS ObjectLink_Goods_Object
                        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_Object.ObjectId 

                        LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = ObjectLink_Goods_Object.ObjectId
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                        LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
        
                        LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                               ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
                        LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId

                        LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Close
                               ON ObjectBoolean_Goods_Close.ObjectId = ObjectLink_Goods_Object.ObjectId 
                              AND ObjectBoolean_Goods_Close.DescId = zc_ObjectBoolean_Goods_Close()   

                        LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                               ON ObjectBoolean_Goods_TOP.ObjectId = ObjectLink_Goods_Object.ObjectId 
                              AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()  
            
                        LEFT JOIN ObjectBoolean AS ObjectBoolean_First
                               ON ObjectBoolean_First.ObjectId = ObjectLink_Goods_Object.ObjectId 
                              AND ObjectBoolean_First.DescId = zc_ObjectBoolean_Goods_First() 
        
                        LEFT JOIN ObjectBoolean AS ObjectBoolean_Second
                               ON ObjectBoolean_Second.ObjectId = ObjectLink_Goods_Object.ObjectId 
                              AND ObjectBoolean_Second.DescId = zc_ObjectBoolean_Goods_Second() 
    
                        LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_PercentMarkup
                               ON ObjectFloat_Goods_PercentMarkup.ObjectId = ObjectLink_Goods_Object.ObjectId 
                              AND ObjectFloat_Goods_PercentMarkup.DescId = zc_ObjectFloat_Goods_PercentMarkup()   

                     WHERE ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                       AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId 
                       AND (ObjectLink_Goods_Object.ObjectId = inGoodsId OR inGoodsId = 0)
                       AND (inisShowDel = True OR Object_Goods.isErased = False)
                    )
      -- данные из прай листа
      , tmpPrice AS (SELECT Object_Price.Id                           AS Id
                          , Price_Goods.ChildObjectId                 AS GoodsId
                          , ROUND(Price_Value.ValueData,2)   ::TFloat AS Price
                          , COALESCE (MCS_Value.ValueData,0) ::TFloat AS MCSValue
                          , COALESCE(Price_MCSValueMin.ValueData,0) ::TFloat AS MCSValue_min
                          , price_datechange.valuedata                AS DateChange
                          , MCS_datechange.valuedata                  AS MCSDateChange
                          , COALESCE (MCS_isClose.ValueData,False)    AS MCSIsClose
                          , MCSIsClose_DateChange.valuedata           AS MCSIsCloseDateChange
                          , COALESCE (MCS_NotRecalc.ValueData,False)  AS MCSNotRecalc
                          , MCSNotRecalc_DateChange.valuedata         AS MCSNotRecalcDateChange
                          , COALESCE (Price_Fix.ValueData,False)      AS Fix
                          , Fix_DateChange.valuedata                  AS FixDateChange
                          , COALESCE (Price_Top.ValueData,False)      AS isTop
                          , Price_TOPDateChange.ValueData             AS TopDateChange

                          , COALESCE (Price_PercentMarkup.ValueData, 0) ::TFloat AS PercentMarkup
                          , Price_PercentMarkupDateChange.ValueData              AS PercentMarkupDateChange

                          , COALESCE(Price_MCSValueOld.ValueData,0)    ::TFloat AS MCSValueOld         
                          , MCS_StartDateMCSAuto.ValueData                      AS StartDateMCSAuto
                          , MCS_EndDateMCSAuto.ValueData                        AS EndDateMCSAuto
                          , COALESCE(Price_MCSAuto.ValueData,False)          :: Boolean   AS isMCSAuto
                          , COALESCE(Price_MCSNotRecalcOld.ValueData,False)  :: Boolean   AS isMCSNotRecalcOld
                     FROM Object AS Object_Price
                        INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                    ON ObjectLink_Price_Unit.ObjectId = Object_Price.Id
                                   AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                   AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
                        LEFT JOIN ObjectFloat AS Price_Value
                                    ON Price_Value.ObjectId = Object_Price.Id
                                   AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                        LEFT JOIN ObjectDate        AS Price_DateChange
                                    ON Price_DateChange.ObjectId = Object_Price.Id
                                   AND Price_DateChange.DescId = zc_ObjectDate_Price_DateChange()
                        LEFT JOIN ObjectFloat       AS MCS_Value
                                    ON MCS_Value.ObjectId = Object_Price.Id
                                   AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                        LEFT JOIN ObjectDate        AS MCS_DateChange
                                    ON MCS_DateChange.ObjectId = Object_Price.Id
                                   AND MCS_DateChange.DescId = zc_ObjectDate_Price_MCSDateChange()
                        LEFT JOIN ObjectLink        AS Price_Goods
                                    ON Price_Goods.ObjectId = Object_Price.Id
                                   AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
      
                       LEFT JOIN ObjectBoolean      AS MCS_isClose
                                    ON MCS_isClose.ObjectId = Object_Price.Id
                                   AND MCS_isClose.DescId = zc_ObjectBoolean_Price_MCSIsClose()
                        LEFT JOIN ObjectDate        AS MCSIsClose_DateChange
                                    ON MCSIsClose_DateChange.ObjectId = Object_Price.Id
                                   AND MCSIsClose_DateChange.DescId = zc_ObjectDate_Price_MCSIsCloseDateChange()
                        LEFT JOIN ObjectBoolean     AS MCS_NotRecalc
                                    ON MCS_NotRecalc.ObjectId = Object_Price.Id
                                   AND MCS_NotRecalc.DescId = zc_ObjectBoolean_Price_MCSNotRecalc()
                        LEFT JOIN ObjectDate        AS MCSNotRecalc_DateChange
                                    ON MCSNotRecalc_DateChange.ObjectId = Object_Price.Id
                                   AND MCSNotRecalc_DateChange.DescId = zc_ObjectDate_Price_MCSNotRecalcDateChange()
                        LEFT JOIN ObjectBoolean     AS Price_Fix
                                    ON Price_Fix.ObjectId = Object_Price.Id
                                   AND Price_Fix.DescId = zc_ObjectBoolean_Price_Fix()
                        LEFT JOIN ObjectDate        AS Fix_DateChange
                                    ON Fix_DateChange.ObjectId = Object_Price.Id
                                   AND Fix_DateChange.DescId = zc_ObjectDate_Price_FixDateChange()
                        LEFT JOIN ObjectBoolean     AS Price_Top
                                    ON Price_Top.ObjectId = Object_Price.Id
                                   AND Price_Top.DescId = zc_ObjectBoolean_Price_Top()
                       LEFT JOIN ObjectDate        AS Price_TOPDateChange
                                    ON Price_TOPDateChange.ObjectId = Object_Price.Id
                                   AND Price_TOPDateChange.DescId = zc_ObjectDate_Price_TOPDateChange()     

                        LEFT JOIN ObjectFloat       AS Price_PercentMarkup
                                    ON Price_PercentMarkup.ObjectId = Object_Price.Id
                                   AND Price_PercentMarkup.DescId = zc_ObjectFloat_Price_PercentMarkup()
                        LEFT JOIN ObjectDate        AS Price_PercentMarkupDateChange
                                    ON Price_PercentMarkupDateChange.ObjectId = Object_Price.Id
                                   AND Price_PercentMarkupDateChange.DescId = zc_ObjectDate_Price_PercentMarkupDateChange()   
                        LEFT JOIN ObjectDate        AS MCS_StartDateMCSAuto
                               ON MCS_StartDateMCSAuto.ObjectId = ObjectLink_Price_Unit.ObjectId
                              AND MCS_StartDateMCSAuto.DescId = zc_ObjectDate_Price_StartDateMCSAuto()
                        LEFT JOIN ObjectDate        AS MCS_EndDateMCSAuto
                               ON MCS_EndDateMCSAuto.ObjectId = ObjectLink_Price_Unit.ObjectId
                              AND MCS_EndDateMCSAuto.DescId = zc_ObjectDate_Price_EndDateMCSAuto()
                        LEFT JOIN ObjectFloat       AS Price_MCSValueOld
                               ON Price_MCSValueOld.ObjectId = ObjectLink_Price_Unit.ObjectId
                              AND Price_MCSValueOld.DescId = zc_ObjectFloat_Price_MCSValueOld()
                        LEFT JOIN ObjectBoolean     AS Price_MCSAuto
                               ON Price_MCSAuto.ObjectId = ObjectLink_Price_Unit.ObjectId
                              AND Price_MCSAuto.DescId = zc_ObjectBoolean_Price_MCSAuto()
                        LEFT JOIN ObjectBoolean     AS Price_MCSNotRecalcOld
                               ON Price_MCSNotRecalcOld.ObjectId = ObjectLink_Price_Unit.ObjectId
                              AND Price_MCSNotRecalcOld.DescId = zc_ObjectBoolean_Price_MCSNotRecalcOld()
                        LEFT JOIN ObjectFloat AS Price_MCSValueMin
                                              ON Price_MCSValueMin.ObjectId = ObjectLink_Price_Unit.ObjectId
                                             AND Price_MCSValueMin.DescId = zc_ObjectFloat_Price_MCSValueMin()
                     WHERE Object_Price.DescId = zc_Object_Price()
                    )
      , tmpContainerCount AS (SELECT Container.ObjectId              AS GoodsId
                                   , Sum(Container.Amount)::TFloat   AS Remains
                              FROM Container
                              WHERE Container.DescId = zc_Container_count()
                                AND Container.WhereObjectId = inUnitId
                                AND Container.Amount <> 0
                              GROUP BY Container.ObjectId
                              )      
            SELECT tmpPrice.Id
                 , COALESCE (tmpPrice.Price,0)    :: TFloat AS Price
                 , COALESCE (tmpPrice.MCSValue,0) :: TFloat AS MCSValue
                 , COALESCE (tmpPrice.MCSValue_min,0)::TFloat AS MCSValue_min
                              
                 , tmpGoods.GoodsId
                 , tmpGoods.GoodsCode                     AS GoodsCode
                 , tmpGoods.GoodsName                     AS GoodsName
                 , tmpGoods.GoodsGroupName                AS GoodsGroupName
                 , tmpGoods.NDSKindName                   AS NDSKindName
                 , tmpGoods.isTop                         AS Goods_isTop
                 , tmpGoods.PercentMarkup                 AS Goods_PercentMarkup
                 , tmpPrice.DateChange                    AS DateChange
                 , tmpPrice.MCSDateChange                 AS MCSDateChange
                 , COALESCE (tmpPrice.MCSIsClose,False)    AS MCSIsClose
                 , tmpPrice.MCSIsCloseDateChange          AS MCSIsCloseDateChange
                 , COALESCE (tmpPrice.MCSNotRecalc,False)  AS MCSNotRecalc
                 , tmpPrice.MCSNotRecalcDateChange        AS MCSNotRecalcDateChange
                 , COALESCE (tmpPrice.Fix,False)           AS Fix
                 , tmpPrice.FixDateChange                 AS FixDateChange
                 , tmpGoods.isErased                      AS isErased 
                 , tmpGoods.isClose
                 , tmpGoods.isFirst
                 , tmpGoods.isSecond
                 , tmpPrice.isTop                   AS isTop
                 , tmpPrice.TopDateChange           AS TopDateChange
                 , tmpPrice.PercentMarkup           AS PercentMarkup
                 , tmpPrice.PercentMarkupDateChange AS PercentMarkupDateChange

                 , tmpPrice.MCSValueOld
                 , tmpPrice.StartDateMCSAuto
                 , tmpPrice.EndDateMCSAuto
                 , tmpPrice.isMCSAuto
                 , tmpPrice.isMCSNotRecalcOld
                 , tmpContainerCount.Remains 
            FROM tmpPrice
                JOIN tmpGoods ON tmpGoods.goodsid = tmpPrice.goodsid
                LEFT JOIN tmpContainerCount ON tmpContainerCount.goodsid = tmpPrice.goodsid
            ORDER BY GoodsGroupName, GoodsName;

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 04.12.18         *
 14.06.17 
 05.10.16         * parce
 12.09.16         *
*/

-- тест
--select * from gpSelect_Object_Price_Lite(inUnitId := 183292 , inGoodsId := 0 , inisShowAll := 'False' , inisShowDel := 'False' ,  inSession := '3');
--select * from gpSelect_Object_Price_Lite(inUnitId := 183292 , inGoodsId := 0 , inisShowAll := 'False' , inisShowDel := 'False' ,  inSession := '3');