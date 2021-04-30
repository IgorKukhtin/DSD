-- Function: gpSelect_Object_PriceChangeHistory (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_PriceChangeHistory(Integer, TDateTime, Boolean,Boolean,TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_PriceChangeHistory(Integer, Integer, TDateTime, Boolean,Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PriceChangeHistory(
    IN inRetailId    Integer,       -- торг.сеть
    IN inUnitId      Integer,       -- подразделение
    IN inStartDate   TDateTime ,    -- Дата действия
    IN inisShowAll   Boolean,        --True - показать все товары, False - показать только с ценами
    IN inisShowDel   Boolean,       --True - показать так же удаленные, False - показать только рабочие
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, PriceChange TFloat, FixValue TFloat, FixPercent TFloat
             , Multiplicity TFloat
             , PercentMarkupStart TFloat, StartDate TDateTime, FixEndDate TDateTime
             , PriceChangeEnd TFloat, FixValueEnd TFloat, FixPercentEnd TFloat
             , PercentMarkupEnd TFloat
             , StartDateEnd TDateTime
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupName TVarChar, NDSKindName TVarChar, NDS TFloat
             , ConditionsKeepName TVarChar
             , Goods_isTop Boolean, Goods_PercentMarkup TFloat
             , DateChange TDateTime
             , Remains TFloat, SummaRemains TFloat
             , RemainsEnd TFloat, SummaRemainsEnd TFloat
             , PercentMarkup TFloat
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

    CREATE TEMP TABLE tmpUnit (UnitId Integer) ON COMMIT DROP;
    INSERT INTO tmpUnit (UnitId)
          -- все подразделения торговой сети
          SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
          FROM ObjectLink AS ObjectLink_Unit_Juridical
              INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                    ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                   AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                   AND (ObjectLink_Juridical_Retail.ChildObjectId = inRetailId OR inRetailId = 0)
          WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
            AND inUnitId = 0
          UNION
          SELECT inUnitId AS UnitId
          WHERE inUnitId <> 0;

    IF inRetailId is null
    THEN
        inRetailId := 0;
    END IF;


    -- Результат
    IF COALESCE(inRetailId,0) = 0 AND COALESCE (inUnitId, 0) = 0
    THEN
        RETURN QUERY
            SELECT 
                 NULL::Integer     AS Id
               , NULL::TFloat      AS PriceChange
               , NULL::TFloat      AS FixValue
               , NULL::TFloat      AS FixPercent
               , NULL::TFloat      AS Multiplicity
               , NULL::TFloat      AS PercentMarkupStart
               , NULL::TDateTime   AS StartDate
               , NULL::TFloat      AS PriceChangeEnd
               , NULL::TFloat      AS FixValueEnd
               , NULL::TFloat      AS FixPercentEnd
               , NULL::TFloat      AS PercentMarkupEnd
               , NULL::TDateTime   AS StartDateEnd
               , NULL::Integer     AS GoodsId
               , NULL::Integer     AS GoodsCode
               , NULL::TVarChar    AS GoodsName
               , NULL::TVarChar    AS GoodsGroupName
               , NULL::TVarChar    AS NDSKindName
               , NULL::TFloat      AS NDS
               , NULL::TVarChar    AS ConditionsKeepName
               , NULL::Boolean     AS Goods_isTop
               , NULL::TFloat      AS Goods_PercentMarkup
               , NULL::TDateTime   AS DateChange
               , NULL::TFloat      AS Remains
               , NULL::TFloat      AS SummaRemains
               , NULL::TFloat      AS RemainsEnd
               , NULL::TFloat      AS SummaRemainsEnd
               , NULL::TFloat      AS PercentMarkup 
               , NULL::TDateTime   AS FixEndDate
               , NULL::Boolean     AS isErased
            WHERE 1=0;
    ELSEIF inisShowAll = True
    THEN
        RETURN QUERY
        With 
        tmpRemains AS ( SELECT tmp.ObjectId
                             , SUM(tmp.Remains)     AS Remains
                             , SUM(tmp.RemainsEnd)  AS RemainsEnd
                        FROM (SELECT Container.ObjectId
                                   , COALESCE(Container.Amount,0) - COALESCE(SUM(MIContainer.Amount), 0)   AS Remains
                                   , (COALESCE(Container.Amount,0) - SUM (CASE WHEN MIContainer.OperDate >= DATE_TRUNC ('DAY', inStartDate )+interval '1 day' then COALESCE(MIContainer.Amount, 0) ELSE 0 END)) AS RemainsEnd
                              FROM Container
                                   INNER JOIN tmpUnit ON tmpUnit.UnitId = Container.WhereObjectId
                                   LEFT JOIN MovementItemContainer AS MIContainer 
                                                                   ON MIContainer.ContainerId = Container.Id
                                                                  AND MIContainer.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                              WHERE Container.descid = zc_Container_Count()
                        and 1=0
                              GROUP BY Container.ObjectId,COALESCE(Container.Amount,0), Container.Id
                             ) AS tmp
                        GROUP BY tmp.ObjectId
                       )

      , tmpPriceChange AS (SELECT ObjectLink_PriceChange_Retail.ObjectId        AS Id
                                , ROUND(PriceChange_Value.ValueData,2)::TFloat  AS PriceChange 
                                , ObjectFloat_FixValue.ValueData                AS FixValue 
                                , ObjectFloat_FixPercent.ValueData              AS FixPercent
                                , PriceChange_Goods.ChildObjectId               AS GoodsId
                                , PriceChange_datechange.valuedata              AS DateChange 
                                , COALESCE(PriceChange_PercentMarkup.ValueData, 0) ::TFloat AS PercentMarkup 
                                , COALESCE (PriceChange_Multiplicity.ValueData, 0) ::TFloat AS Multiplicity
                                , PriceChange_FixEndDate.ValueData              AS FixEndDate
                           FROM ObjectLink AS ObjectLink_PriceChange_Retail
                               LEFT JOIN ObjectLink AS PriceChange_Goods
                                                    ON PriceChange_Goods.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                   AND PriceChange_Goods.DescId = zc_ObjectLink_PriceChange_Goods()
                               LEFT JOIN ObjectFloat AS PriceChange_Value
                                                     ON PriceChange_Value.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                    AND PriceChange_Value.DescId = zc_ObjectFloat_PriceChange_Value()
                               LEFT JOIN ObjectFloat AS PriceChange_PercentMarkup
                                                     ON PriceChange_PercentMarkup.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                    AND PriceChange_PercentMarkup.DescId = zc_ObjectFloat_PriceChange_PercentMarkup()

                               LEFT JOIN ObjectDate AS PriceChange_DateChange
                                                    ON PriceChange_DateChange.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                   AND PriceChange_DateChange.DescId = zc_ObjectDate_PriceChange_DateChange()
                                LEFT JOIN ObjectDate AS PriceChange_FixEndDate
                                                     ON PriceChange_FixEndDate.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                    AND PriceChange_FixEndDate.DescId = zc_ObjectDate_PriceChange_FixEndDate()

                               LEFT JOIN ObjectFloat AS ObjectFloat_FixValue
                                                     ON ObjectFloat_FixValue.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                    AND ObjectFloat_FixValue.DescId = zc_ObjectFloat_PriceChange_FixValue()
                               LEFT JOIN ObjectFloat AS ObjectFloat_FixPercent
                                                     ON ObjectFloat_FixPercent.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                    AND ObjectFloat_FixPercent.DescId = zc_ObjectFloat_PriceChange_FixPercent()
                               LEFT JOIN ObjectFloat AS PriceChange_Multiplicity
                                                     ON PriceChange_Multiplicity.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                    AND PriceChange_Multiplicity.DescId = zc_ObjectFloat_PriceChange_Multiplicity()

                           WHERE ObjectLink_PriceChange_Retail.DescId = zc_ObjectLink_PriceChange_Retail()
                             AND ObjectLink_PriceChange_Retail.ChildObjectId = inRetailId
                             AND inUnitId = 0
                          UNION
                           SELECT ObjectLink_PriceChange_Unit.ObjectId               AS Id
                                , ROUND(PriceChange_Value.ValueData,2)::TFloat  AS PriceChange 
                                , ObjectFloat_FixValue.ValueData                AS FixValue 
                                , ObjectFloat_FixPercent.ValueData              AS FixPercent
                                , PriceChange_Goods.ChildObjectId               AS GoodsId
                                , PriceChange_datechange.valuedata              AS DateChange 
                                , COALESCE(PriceChange_PercentMarkup.ValueData, 0) ::TFloat AS PercentMarkup
                                , COALESCE (PriceChange_Multiplicity.ValueData, 0) ::TFloat AS Multiplicity
                                , PriceChange_FixEndDate.ValueData                   AS FixEndDate
                           FROM ObjectLink AS ObjectLink_PriceChange_Unit
                               LEFT JOIN ObjectLink AS PriceChange_Goods
                                                    ON PriceChange_Goods.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                   AND PriceChange_Goods.DescId = zc_ObjectLink_PriceChange_Goods()
                               LEFT JOIN ObjectFloat AS PriceChange_Value
                                                     ON PriceChange_Value.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                    AND PriceChange_Value.DescId = zc_ObjectFloat_PriceChange_Value()
                               LEFT JOIN ObjectFloat AS PriceChange_PercentMarkup
                                                     ON PriceChange_PercentMarkup.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                    AND PriceChange_PercentMarkup.DescId = zc_ObjectFloat_PriceChange_PercentMarkup()

                               LEFT JOIN ObjectDate AS PriceChange_DateChange
                                                    ON PriceChange_DateChange.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                   AND PriceChange_DateChange.DescId = zc_ObjectDate_PriceChange_DateChange()
                               LEFT JOIN ObjectDate AS PriceChange_FixEndDate
                                                    ON PriceChange_FixEndDate.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                   AND PriceChange_FixEndDate.DescId = zc_ObjectDate_PriceChange_FixEndDate()

                               LEFT JOIN ObjectFloat AS ObjectFloat_FixValue
                                                     ON ObjectFloat_FixValue.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                    AND ObjectFloat_FixValue.DescId = zc_ObjectFloat_PriceChange_FixValue()
                               LEFT JOIN ObjectFloat AS ObjectFloat_FixPercent
                                                     ON ObjectFloat_FixPercent.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                    AND ObjectFloat_FixPercent.DescId = zc_ObjectFloat_PriceChange_FixPercent()
                               LEFT JOIN ObjectFloat AS PriceChange_Multiplicity
                                                     ON PriceChange_Multiplicity.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                    AND PriceChange_Multiplicity.DescId = zc_ObjectFloat_PriceChange_Multiplicity()
                           WHERE ObjectLink_PriceChange_Unit.DescId        = zc_ObjectLink_PriceChange_Unit()
                             AND ObjectLink_PriceChange_Unit.ChildObjectId = inUnitId
                             AND inUnitId <> 0
                           )
        
            SELECT tmpPriceChange.Id                                                              AS Id
                 , COALESCE (ObjectHistoryFloat_PriceChange.ValueData, 0)            :: TFloat    AS PriceChange
                 , COALESCE (ObjectHistoryFloat_FixValue.ValueData, 0)               :: TFloat    AS FixValue
                 , COALESCE (ObjectHistoryFloat_FixPercent.ValueData, 0)             :: TFloat    AS FixPercent
                 , COALESCE (ObjectHistoryFloat_Multiplicity.ValueData, 0)           :: TFloat    AS Multiplicity
                 , COALESCE (ObjectHistoryFloat_PercentMarkup.ValueData, 0)          :: TFloat    AS PercentMarkupStart
                 , COALESCE (ObjectHistory_PriceChange.StartDate, NULL)              :: TDateTime AS StartDate
                 , ObjectHistoryDate_FixEndDate.ValueData                            :: TDateTime AS FixEndDate

                 , COALESCE (ObjectHistoryFloat_PriceChangeEnd.ValueData, 0)         :: TFloat    AS PriceChangeEnd
                 , COALESCE (ObjectHistoryFloat_FixValueEnd.ValueData, 0)            :: TFloat    AS FixValueEnd
                 , COALESCE (ObjectHistoryFloat_FixPercentEnd.ValueData, 0)          :: TFloat    AS FixPercentEnd
                 , COALESCE (ObjectHistoryFloat_PercentMarkupEnd.ValueData, 0)       :: TFloat    AS PercentMarkupEnd
                 , COALESCE (ObjectHistory_PriceChangeEnd.StartDate, NULL)           :: TDateTime AS StartDateEnd

                 , Object_Goods_View.id                            AS GoodsId
                 , Object_Goods_View.GoodsCodeInt                  AS GoodsCode
                 , Object_Goods_View.GoodsName                     AS GoodsName
                 , Object_Goods_View.GoodsGroupName                AS GoodsGroupName
                 , Object_Goods_View.NDSKindName                   AS NDSKindName
                 , Object_Goods_View.NDS                           AS NDS
                 , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar  AS ConditionsKeepName
                 , Object_Goods_View.isTop                         AS Goods_isTop
                 , Object_Goods_View.PercentMarkup                 AS Goods_PercentMarkup
                 , tmpPriceChange.DateChange                       AS DateChange

                 , Object_Remains.Remains  :: TFloat               AS Remains
                 , (Object_Remains.Remains * COALESCE (ObjectHistoryFloat_PriceChange.ValueData, 0))       ::TFloat AS SummaRemains

                 , Object_Remains.RemainsEnd        :: TFloat      AS RemainsEnd
                 , (Object_Remains.RemainsEnd * COALESCE (ObjectHistoryFloat_PriceChangeEnd.ValueData, 0)) ::TFloat AS SummaRemainsEnd

                 , tmpPriceChange.PercentMarkup                    AS PercentMarkup
                 , Object_Goods_View.isErased                      AS isErased 

            FROM Object_Goods_View
                INNER JOIN ObjectLink ON ObjectLink.ObjectId = Object_Goods_View.Id 
                                     AND ObjectLink.ChildObjectId = inRetailId --vbObjectId
                LEFT OUTER JOIN tmpPriceChange ON tmpPriceChange.GoodsId = Object_Goods_View.id
                                   
                LEFT OUTER JOIN tmpRemains AS Object_Remains ON Object_Remains.ObjectId = Object_Goods_View.Id
   
                -- получаем значения цены из истории значений на начало дня                                                          
                LEFT JOIN ObjectHistory AS ObjectHistory_PriceChange
                                        ON ObjectHistory_PriceChange.ObjectId = tmpPriceChange.Id 
                                       AND ObjectHistory_PriceChange.DescId = zc_ObjectHistory_PriceChange()
                                       AND DATE_TRUNC ('DAY', inStartDate) >= ObjectHistory_PriceChange.StartDate AND DATE_TRUNC ('DAY', inStartDate) < ObjectHistory_PriceChange.EndDate

                -- получаем значения расчетная цена из истории значений на дату
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceChange
                                             ON ObjectHistoryFloat_PriceChange.ObjectHistoryId = ObjectHistory_PriceChange.Id
                                            AND ObjectHistoryFloat_PriceChange.DescId = zc_ObjectHistoryFloat_PriceChange_Value()

                -- получаем значения фиксированная цена из истории значений на дату
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_FixValue
                                             ON ObjectHistoryFloat_FixValue.ObjectHistoryId = ObjectHistory_PriceChange.Id
                                            AND ObjectHistoryFloat_FixValue.DescId = zc_ObjectHistoryFloat_PriceChange_FixValue()                

                -- получаем значения фиксированный % скидки из истории значений на дату
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_FixPercent
                                             ON ObjectHistoryFloat_FixPercent.ObjectHistoryId = ObjectHistory_PriceChange.Id
                                            AND ObjectHistoryFloat_FixPercent.DescId = zc_ObjectHistoryFloat_PriceChange_FixPercent()

                -- получаем значения % наценки из истории значений на дату
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PercentMarkup
                                             ON ObjectHistoryFloat_PercentMarkup.ObjectHistoryId = ObjectHistory_PriceChange.Id
                                            AND ObjectHistoryFloat_PercentMarkup.DescId = zc_ObjectHistoryFloat_PriceChange_PercentMarkup()
                                            
                -- получаем значения цены истории значений на конец дня (на сл.день 00:00)
                LEFT JOIN ObjectHistory AS ObjectHistory_PriceChangeEnd
                                        ON ObjectHistory_PriceChangeEnd.ObjectId = tmpPriceChange.Id 
                                       AND ObjectHistory_PriceChangeEnd.DescId = zc_ObjectHistory_PriceChange()
                                       AND DATE_TRUNC ('DAY', inStartDate) +interval '1 day' >= ObjectHistory_PriceChangeEnd.StartDate AND DATE_TRUNC ('DAY', inStartDate) +interval '1 day' < ObjectHistory_PriceChangeEnd.EndDate

                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceChangeEnd
                                             ON ObjectHistoryFloat_PriceChangeEnd.ObjectHistoryId = ObjectHistory_PriceChangeEnd.Id
                                            AND ObjectHistoryFloat_PriceChangeEnd.DescId = zc_ObjectHistoryFloat_PriceChange_Value()
            
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_FixValueEnd
                                             ON ObjectHistoryFloat_FixValueEnd.ObjectHistoryId = ObjectHistory_PriceChangeEnd.Id
                                            AND ObjectHistoryFloat_FixValueEnd.DescId = zc_ObjectHistoryFloat_PriceChange_FixValue()                

                -- получаем значения фиксированный % скидки из истории значений на конец дня (на сл.день 00:00)
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_FixPercentEnd
                                             ON ObjectHistoryFloat_FixPercentEnd.ObjectHistoryId = ObjectHistory_PriceChangeEnd.Id
                                            AND ObjectHistoryFloat_FixPercentEnd.DescId = zc_ObjectHistoryFloat_PriceChange_FixPercent()

                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PercentMarkupEnd
                                             ON ObjectHistoryFloat_PercentMarkupEnd.ObjectHistoryId = ObjectHistory_PriceChangeEnd.Id
                                            AND ObjectHistoryFloat_PercentMarkupEnd.DescId = zc_ObjectHistoryFloat_PriceChange_PercentMarkup()

                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Multiplicity
                                             ON ObjectHistoryFloat_Multiplicity.ObjectHistoryId = ObjectHistory_PriceChangeEnd.Id
                                            AND ObjectHistoryFloat_Multiplicity.DescId = zc_ObjectHistoryFloat_PriceChange_Multiplicity()

                LEFT JOIN ObjectHistoryDate AS ObjectHistoryDate_FixEndDate
                                            ON ObjectHistoryDate_FixEndDate.ObjectHistoryId = ObjectHistory_PriceChangeEnd.Id
                                           AND ObjectHistoryDate_FixEndDate.DescId = zc_ObjectHistoryDate_PriceChange_FixEndDate()

                -- условия хранения
                LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep 
                                     ON ObjectLink_Goods_ConditionsKeep.ObjectId = Object_Goods_View.Id
                                    AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
                LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId

            WHERE (inisShowDel = True OR Object_Goods_View.isErased = False)
            ORDER BY
                GoodsGroupName, GoodsName;
    ELSE
        RETURN QUERY
        WITH 
        tmpRemains AS ( SELECT tmp.ObjectId
                             , SUM(tmp.Remains)     AS Remains
                             , SUM(tmp.RemainsEnd)  AS RemainsEnd
                        FROM (SELECT Container.ObjectId
                                   , COALESCE(Container.Amount,0) - COALESCE(SUM(MIContainer.Amount), 0)   AS Remains
                                   , (COALESCE(Container.Amount,0) - SUM (CASE WHEN MIContainer.OperDate >= DATE_TRUNC ('DAY', inStartDate )+interval '1 day' then COALESCE(MIContainer.Amount, 0) ELSE 0 END)) AS RemainsEnd
                              FROM Container
                                   INNER JOIN tmpUnit ON tmpUnit.UnitId = Container.WhereObjectId
                                   LEFT JOIN MovementItemContainer AS MIContainer 
                                                                   ON MIContainer.ContainerId = Container.Id
                                                                  AND MIContainer.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                              WHERE Container.descid = zc_Container_Count() 
and 1=0
                              GROUP BY Container.ObjectId,COALESCE(Container.Amount,0), Container.Id
                             ) AS tmp
                        GROUP BY tmp.ObjectId
                       )

      , tmpPriceChange AS (SELECT ObjectLink_PriceChange_Retail.ObjectId        AS Id
                                , ROUND(PriceChange_Value.ValueData,2)::TFloat  AS PriceChange 
                                , ObjectFloat_FixValue.ValueData                AS FixValue 
                                , ObjectFloat_FixPercent.ValueData              AS FixPercent 
                                , PriceChange_Goods.ChildObjectId               AS GoodsId
                                , PriceChange_datechange.valuedata              AS DateChange 
                                , COALESCE(PriceChange_PercentMarkup.ValueData, 0) ::TFloat AS PercentMarkup
                                , COALESCE (PriceChange_Multiplicity.ValueData, 0) ::TFloat AS Multiplicity
                                , PriceChange_FixEndDate.ValueData                   AS FixEndDate
                           FROM ObjectLink AS ObjectLink_PriceChange_Retail
                               LEFT JOIN ObjectLink AS PriceChange_Goods
                                                    ON PriceChange_Goods.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                   AND PriceChange_Goods.DescId = zc_ObjectLink_PriceChange_Goods()
                               LEFT JOIN ObjectFloat AS PriceChange_Value
                                                     ON PriceChange_Value.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                    AND PriceChange_Value.DescId = zc_ObjectFloat_PriceChange_Value()
                               LEFT JOIN ObjectFloat AS PriceChange_PercentMarkup
                                                     ON PriceChange_PercentMarkup.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                    AND PriceChange_PercentMarkup.DescId = zc_ObjectFloat_PriceChange_PercentMarkup()

                               LEFT JOIN ObjectDate AS PriceChange_DateChange
                                                    ON PriceChange_DateChange.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                   AND PriceChange_DateChange.DescId = zc_ObjectDate_PriceChange_DateChange()
                               LEFT JOIN ObjectDate AS PriceChange_FixEndDate
                                                    ON PriceChange_FixEndDate.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                   AND PriceChange_FixEndDate.DescId = zc_ObjectDate_PriceChange_FixEndDate()

                               LEFT JOIN ObjectFloat AS ObjectFloat_FixValue
                                                     ON ObjectFloat_FixValue.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                    AND ObjectFloat_FixValue.DescId = zc_ObjectFloat_PriceChange_FixValue()

                               LEFT JOIN ObjectFloat AS ObjectFloat_FixPercent
                                                     ON ObjectFloat_FixPercent.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                    AND ObjectFloat_FixPercent.DescId = zc_ObjectFloat_PriceChange_FixPercent()
                               LEFT JOIN ObjectFloat AS PriceChange_Multiplicity
                                                     ON PriceChange_Multiplicity.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                    AND PriceChange_Multiplicity.DescId = zc_ObjectFloat_PriceChange_Multiplicity()
                           WHERE ObjectLink_PriceChange_Retail.DescId = zc_ObjectLink_PriceChange_Retail()
                             AND ObjectLink_PriceChange_Retail.ChildObjectId = inRetailId
                             AND inUnitId = 0
                          UNION
                           SELECT ObjectLink_PriceChange_Unit.ObjectId          AS Id
                                , ROUND(PriceChange_Value.ValueData,2)::TFloat  AS PriceChange 
                                , ObjectFloat_FixValue.ValueData                AS FixValue 
                                , ObjectFloat_FixPercent.ValueData                AS FixPercent 
                                , PriceChange_Goods.ChildObjectId               AS GoodsId
                                , PriceChange_datechange.valuedata              AS DateChange 
                                , COALESCE(PriceChange_PercentMarkup.ValueData, 0) ::TFloat AS PercentMarkup
                                , COALESCE (PriceChange_Multiplicity.ValueData, 0) ::TFloat AS Multiplicity 
                                , PriceChange_FixEndDate.ValueData                   AS FixEndDate
                           FROM ObjectLink AS ObjectLink_PriceChange_Unit
                               LEFT JOIN ObjectLink AS PriceChange_Goods
                                                    ON PriceChange_Goods.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                   AND PriceChange_Goods.DescId = zc_ObjectLink_PriceChange_Goods()
                               LEFT JOIN ObjectFloat AS PriceChange_Value
                                                     ON PriceChange_Value.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                    AND PriceChange_Value.DescId = zc_ObjectFloat_PriceChange_Value()
                               LEFT JOIN ObjectFloat AS PriceChange_PercentMarkup
                                                     ON PriceChange_PercentMarkup.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                    AND PriceChange_PercentMarkup.DescId = zc_ObjectFloat_PriceChange_PercentMarkup()

                               LEFT JOIN ObjectDate AS PriceChange_DateChange
                                                    ON PriceChange_DateChange.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                   AND PriceChange_DateChange.DescId = zc_ObjectDate_PriceChange_DateChange()
                               LEFT JOIN ObjectDate AS PriceChange_FixEndDate
                                                    ON PriceChange_FixEndDate.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                   AND PriceChange_FixEndDate.DescId = zc_ObjectDate_PriceChange_FixEndDate()

                               LEFT JOIN ObjectFloat AS ObjectFloat_FixValue
                                                     ON ObjectFloat_FixValue.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                    AND ObjectFloat_FixValue.DescId = zc_ObjectFloat_PriceChange_FixValue()
                               LEFT JOIN ObjectFloat AS ObjectFloat_FixPercent
                                                     ON ObjectFloat_FixPercent.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                    AND ObjectFloat_FixPercent.DescId = zc_ObjectFloat_PriceChange_FixPercent()
                               LEFT JOIN ObjectFloat AS PriceChange_Multiplicity
                                                     ON PriceChange_Multiplicity.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                    AND PriceChange_Multiplicity.DescId = zc_ObjectFloat_PriceChange_Multiplicity()
                           WHERE ObjectLink_PriceChange_Unit.DescId        = zc_ObjectLink_PriceChange_Unit()
                             AND ObjectLink_PriceChange_Unit.ChildObjectId = inUnitId
                             AND inUnitId <> 0
                           )
        
            SELECT tmpPriceChange.Id                                                              AS Id
                 , COALESCE (ObjectHistoryFloat_PriceChange.ValueData, 0)            :: TFloat    AS PriceChange
                 , COALESCE (ObjectHistoryFloat_FixValue.ValueData, 0)               :: TFloat    AS FixValue
                 , COALESCE (ObjectHistoryFloat_FixPercent.ValueData, 0)             :: TFloat    AS FixPercent
                 , COALESCE (ObjectHistoryFloat_Multiplicity.ValueData, 0)           :: TFloat    AS Multiplicity
                 , COALESCE (ObjectHistoryFloat_PercentMarkup.ValueData, 0)          :: TFloat    AS PercentMarkupStart
                 , COALESCE (ObjectHistory_PriceChange.StartDate, NULL)              :: TDateTime AS StartDate
                 , ObjectHistoryDate_FixEndDate.ValueData                            :: TDateTime AS FixEndDate

                 , COALESCE (ObjectHistoryFloat_PriceChangeEnd.ValueData, 0)         :: TFloat    AS PriceChangeEnd
                 , COALESCE (ObjectHistoryFloat_FixValueEnd.ValueData, 0)            :: TFloat    AS FixValueEnd
                 , COALESCE (ObjectHistoryFloat_FixPercentEnd.ValueData, 0)          :: TFloat    AS FixPercentEnd
                 , COALESCE (ObjectHistoryFloat_PercentMarkupEnd.ValueData, 0)       :: TFloat    AS PercentMarkupEnd
                 , COALESCE (ObjectHistory_PriceChangeEnd.StartDate, NULL)           :: TDateTime AS StartDateEnd

                 , Object_Goods_View.id                      AS GoodsId
                 , Object_Goods_View.GoodsCodeInt            AS GoodsCode
                 , Object_Goods_View.GoodsName               AS GoodsName
                 , Object_Goods_View.GoodsGroupName          AS GoodsGroupName
                 , Object_Goods_View.NDSKindName             AS NDSKindName
                 , Object_Goods_View.NDS                     AS NDS
                 , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar  AS ConditionsKeepName
                 , Object_Goods_View.isTop                   AS Goods_isTop
                 , Object_Goods_View.PercentMarkup           AS Goods_PercentMarkup
                 , tmpPriceChange.DateChange                 AS DateChange

                 , Object_Remains.Remains                                                                 :: TFloat AS Remains
                 , (Object_Remains.Remains * COALESCE (ObjectHistoryFloat_PriceChange.ValueData, 0))      :: TFloat AS SummaRemains

                 , Object_Remains.RemainsEnd                                                              :: TFloat AS RemainsEnd
                 , (Object_Remains.RemainsEnd * COALESCE (ObjectHistoryFloat_PriceChangeEnd.ValueData, 0)) ::TFloat AS SummaRemainsEnd

                 , tmpPriceChange.PercentMarkup              AS PercentMarkup
                 , Object_Goods_View.isErased                AS isErased 

            FROM tmpPriceChange
                LEFT OUTER JOIN Object_Goods_View ON Object_Goods_View.id = tmpPriceChange.GoodsId
                LEFT OUTER JOIN tmpRemains AS Object_Remains ON Object_Remains.ObjectId = Object_Goods_View.Id
   
                -- получаем значения цены из истории значений на начало дня                                                          
                LEFT JOIN ObjectHistory AS ObjectHistory_PriceChange
                                        ON ObjectHistory_PriceChange.ObjectId = tmpPriceChange.Id 
                                       AND ObjectHistory_PriceChange.DescId = zc_ObjectHistory_PriceChange()
                                       AND DATE_TRUNC ('DAY', inStartDate) >= ObjectHistory_PriceChange.StartDate AND DATE_TRUNC ('DAY', inStartDate) < ObjectHistory_PriceChange.EndDate

                -- получаем значения расчетная цена из истории значений на дату
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceChange
                                             ON ObjectHistoryFloat_PriceChange.ObjectHistoryId = ObjectHistory_PriceChange.Id
                                            AND ObjectHistoryFloat_PriceChange.DescId = zc_ObjectHistoryFloat_PriceChange_Value()

                -- получаем значения фиксированная цена из истории значений на дату
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_FixValue
                                             ON ObjectHistoryFloat_FixValue.ObjectHistoryId = ObjectHistory_PriceChange.Id
                                            AND ObjectHistoryFloat_FixValue.DescId = zc_ObjectHistoryFloat_PriceChange_FixValue()                

                -- получаем значения фиксированный % скидки из истории значений на дату
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_FixPercent
                                             ON ObjectHistoryFloat_FixPercent.ObjectHistoryId = ObjectHistory_PriceChange.Id
                                            AND ObjectHistoryFloat_FixPercent.DescId = zc_ObjectHistoryFloat_PriceChange_FixPercent() 

                -- получаем значения % наценки из истории значений на дату
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PercentMarkup
                                             ON ObjectHistoryFloat_PercentMarkup.ObjectHistoryId = ObjectHistory_PriceChange.Id
                                            AND ObjectHistoryFloat_PercentMarkup.DescId = zc_ObjectHistoryFloat_PriceChange_PercentMarkup()
                                            
                -- получаем значения цены истории значений на конец дня (на сл.день 00:00)
                LEFT JOIN ObjectHistory AS ObjectHistory_PriceChangeEnd
                                        ON ObjectHistory_PriceChangeEnd.ObjectId = tmpPriceChange.Id 
                                       AND ObjectHistory_PriceChangeEnd.DescId = zc_ObjectHistory_PriceChange()
                                       AND DATE_TRUNC ('DAY', inStartDate) +interval '1 day' >= ObjectHistory_PriceChangeEnd.StartDate AND DATE_TRUNC ('DAY', inStartDate) +interval '1 day' < ObjectHistory_PriceChangeEnd.EndDate

                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceChangeEnd
                                             ON ObjectHistoryFloat_PriceChangeEnd.ObjectHistoryId = ObjectHistory_PriceChangeEnd.Id
                                            AND ObjectHistoryFloat_PriceChangeEnd.DescId = zc_ObjectHistoryFloat_PriceChange_Value()
            
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_FixValueEnd
                                             ON ObjectHistoryFloat_FixValueEnd.ObjectHistoryId = ObjectHistory_PriceChangeEnd.Id
                                            AND ObjectHistoryFloat_FixValueEnd.DescId = zc_ObjectHistoryFloat_PriceChange_FixValue()                

                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_FixPercentEnd
                                             ON ObjectHistoryFloat_FixPercentEnd.ObjectHistoryId = ObjectHistory_PriceChangeEnd.Id
                                            AND ObjectHistoryFloat_FixPercentEnd.DescId = zc_ObjectHistoryFloat_PriceChange_FixPercent()  

                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PercentMarkupEnd
                                             ON ObjectHistoryFloat_PercentMarkupEnd.ObjectHistoryId = ObjectHistory_PriceChangeEnd.Id
                                            AND ObjectHistoryFloat_PercentMarkupEnd.DescId = zc_ObjectHistoryFloat_PriceChange_PercentMarkup()

                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Multiplicity
                                             ON ObjectHistoryFloat_Multiplicity.ObjectHistoryId = ObjectHistory_PriceChangeEnd.Id
                                            AND ObjectHistoryFloat_Multiplicity.DescId = zc_ObjectHistoryFloat_PriceChange_Multiplicity()

                LEFT JOIN ObjectHistoryDate AS ObjectHistoryDate_FixEndDate
                                            ON ObjectHistoryDate_FixEndDate.ObjectHistoryId = ObjectHistory_PriceChangeEnd.Id
                                           AND ObjectHistoryDate_FixEndDate.DescId = zc_ObjectHistoryDate_PriceChange_FixEndDate()
                -- условия хранения
                LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep 
                                     ON ObjectLink_Goods_ConditionsKeep.ObjectId = Object_Goods_View.Id
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
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.03.19         *
 07.02.19         *
 27.09.18         * add inUnitId
 16.08.18         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_PriceChangeHistory(inRetailId:= 4, inUnitId:= 0, inStartDate:= '01.01.2018' ::TDateTime, inisShowAll := 'true' :: Boolean, inisShowDel := 'FALSE' :: Boolean, inSession := '3' :: TVarChar);

select * from gpSelect_Object_PriceChangeHistory(inRetailId := 4 , inUnitId := 0 , inStartDate := ('30.04.2021 14:10:17')::TDateTime , inisShowAll := 'False' , inisShowDel := 'False' ,  inSession := '3');
