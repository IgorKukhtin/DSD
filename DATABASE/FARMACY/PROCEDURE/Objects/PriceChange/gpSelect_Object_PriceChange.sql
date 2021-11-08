-- Function: gpSelect_Object_PriceChange (TVarChar)
DROP FUNCTION IF EXISTS gpSelect_Object_PriceChange(Integer, Integer, Boolean,Boolean,TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_PriceChange(Integer, Integer, Integer, Boolean,Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PriceChange(
    IN inRetailId    Integer,       -- торг.сеть
    IN inUnitId      Integer,       -- подразделение
    IN inGoodsId     Integer,       -- Товар
    IN inisShowAll   Boolean,       -- True - показать все товары, False - показать только с ценами
    IN inisShowDel   Boolean,       -- True - показать так же удаленные, False - показать только рабочие
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , PriceChange TFloat, FixValue TFloat, PercentMarkup TFloat
             , FixPercent TFloat
             , FixDiscount TFloat
             , Multiplicity TFloat
             , DateChange TDateTime, StartDate TDateTime, FixEndDate TDateTime
             , GoodsId Integer, GoodsCode Integer
             , BarCode TVarChar
             , GoodsName TVarChar
             , GoodsGroupName TVarChar, NDSKindName TVarChar, NDS TFloat
             , ConditionsKeepName TVarChar
             , Goods_isTop Boolean, Goods_PercentMarkup TFloat
             , MinExpirationDate TDateTime
             , Remains TFloat, SummaRemains TFloat
             , Color_ExpirationDate Integer
             , isClose Boolean, isFirst Boolean, isSecond Boolean
             , isErased Boolean
             ) AS
$BODY$
DECLARE
    vbUserId Integer;
    vbObjectId Integer;
    vbRetailId Integer;
    vbStartDate TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Street());
    vbUserId:= lpGetUserBySession (inSession);
    -- Ограничение на просмотр товарного справочника
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    vbStartDate:= DATE_TRUNC ('DAY', CURRENT_DATE);

    -- определяем сеть . если заданна то берем ее, если выбранно подр. то опред. сеть по подразделению
    IF COALESCE (inRetailId, 0) <> 0
    THEN
         vbRetailId := inRetailId;
    ELSE
        IF COALESCE (inUnitId,0) <> 0
        THEN
            vbRetailId := (SELECT ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                           FROM ObjectLink AS ObjectLink_Unit_Juridical
                               INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                     ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                    AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                           WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                             AND ObjectLink_Unit_Juridical.ObjectId = inUnitId
                            );
        ELSE
            vbRetailId := vbObjectId;
        END IF;
    END IF;
    
    
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
          WHERE inUnitId <> 0
          ;

    -- Результат
    IF COALESCE (inRetailId, 0) = 0 AND COALESCE (inUnitId, 0) = 0
    THEN
        RETURN QUERY
            SELECT
                NULL::Integer                    AS Id
               ,NULL::TFloat                     AS PriceChange
               ,NULL::TFloat                     AS FixValue
               ,NULL::TFloat                     AS PercentMarkup
               ,NULL::TFloat                     AS FixPercent
               ,NULL::TFloat                     AS FixDiscount
               ,NULL::TFloat                     AS Multiplicity
               ,NULL::TDateTime                  AS DateChange
               ,NULL::TDateTime                  AS StartDate
               ,NULL::TDateTime                  AS FixEndDate
               ,NULL::Integer                    AS GoodsId
               ,NULL::Integer                    AS GoodsCode
               ,NULL::TVarChar                   AS BarCode
               ,NULL::TVarChar                   AS GoodsName
               ,NULL::TVarChar                   AS GoodsGroupName
               ,NULL::TVarChar                   AS NDSKindName
               ,NULL::TFloat                     AS NDS
               ,NULL::TVarChar                   AS ConditionsKeepName
               ,NULL::Boolean                    AS Goods_isTop
               ,NULL::TFloat                     AS Goods_PercentMarkup
               ,NULL::TDateTime                  AS MinExpirationDate
               ,NULL::TFloat                     AS Remains
               ,NULL::TFloat                     AS SummaRemains

               ,zc_Color_Black()  ::Integer      AS Color_ExpirationDate

               ,NULL::Boolean                    AS isClose
               ,NULL::Boolean                    AS isFirst
               ,NULL::Boolean                    AS isSecond
               ,NULL::Boolean                    AS isErased

            WHERE 1=0
           ;

    ELSEIF inisShowAll = TRUE
    THEN

       CREATE TEMP TABLE tmpObject_Goods_View ON COMMIT DROP AS (

            WITH tmpObject_Goods AS (
             SELECT 
                 ObjectLink_Goods_Object.ObjectId                 AS ObjectId 
               , ObjectLink_Goods_Object.ChildObjectId 
             FROM ObjectLink AS ObjectLink_Goods_Object

                  INNER JOIN ObjectLink ON ObjectLink.ObjectId      = ObjectLink_Goods_Object.ObjectId 
                                       AND ObjectLink.ChildObjectId = vbRetailId --vbObjectId

             WHERE ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object())

             SELECT 
                 ObjectLink_Goods_Object.ObjectId                 AS Id
               , Object_Goods.ObjectCode                          AS GoodsCodeInt
               , ObjectString.ValueData                           AS GoodsCode
               , Object_Goods.ValueData                           AS GoodsName
               , Object_Goods.isErased                            AS isErased
               , ObjectLink_Goods_Area.ChildObjectId              AS AreaId
               , ObjectLink_Goods_Object.ChildObjectId            AS ObjectId
               , ObjectLink_Goods_GoodsGroup.ChildObjectId        AS GoodsGroupId
               , Object_GoodsGroup.ValueData                      AS GoodsGroupName
               , ObjectLink_Goods_Measure.ChildObjectId           AS MeasureId
               , Object_Measure.ValueData                         AS MeasureName
               , ObjectLink_Goods_NDSKind.ChildObjectId           AS NDSKindId
               , Object_NDSKind.ValueData                         AS NDSKindName
               , ObjectFloat_NDSKind_NDS.ValueData                AS NDS
               , ObjectString_Goods_Maker.ValueData               AS MakerName
               , COALESCE (ObjectBoolean_Goods_Close.ValueData, FALSE)    AS isClose
               , COALESCE (ObjectBoolean_Goods_TOP.ValueData, FALSE)      AS isTOP
               , COALESCE (ObjectBoolean_First.ValueData, FALSE)          AS isFirst
               , COALESCE (ObjectBoolean_Second.ValueData, FALSE)         AS isSecond
               , ObjectFloat_Goods_PercentMarkup.ValueData        AS PercentMarkup
               , ObjectLink_Main.ChildObjectId                    AS GoodsMainId
           FROM tmpObject_Goods AS ObjectLink_Goods_Object
           
                LEFT JOIN Object AS Object_Goods 
                                 ON Object_Goods.Id = ObjectLink_Goods_Object.ObjectId 

                LEFT JOIN ObjectString ON ObjectString.ObjectId = ObjectLink_Goods_Object.ObjectId
                                      AND ObjectString.DescId = zc_ObjectString_Goods_Code()
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Area
                                     ON ObjectLink_Goods_Area.ObjectId = ObjectLink_Goods_Object.ObjectId
                                    AND ObjectLink_Goods_Area.DescId   = zc_ObjectLink_Goods_Area()

                LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                     ON ObjectLink_Goods_GoodsGroup.ObjectId = ObjectLink_Goods_Object.ObjectId
                                    AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()

                LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
            
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                     ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                    AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

                LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                     ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                                    AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
                LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId

                LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                      ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId 
                                     AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()   

                LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                                       ON ObjectString_Goods_Maker.ObjectId = ObjectLink_Goods_Object.ObjectId 
                                      AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker()   

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


               -- получается GoodsMainId
               LEFT JOIN  ObjectLink AS ObjectLink_Child ON ObjectLink_Child.ChildObjectId = ObjectLink_Goods_Object.ObjectId 
                                                        AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
               LEFT JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                       AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
            WHERE (inisShowDel = TRUE OR Object_Goods.isErased = FALSE)
              AND (ObjectLink_Goods_Object.ObjectId = inGoodsId OR inGoodsId = 0)
           );
           
        ANALYSE tmpObject_Goods_View;
        
        RETURN QUERY
        WITH
        tmpPriceChange AS (SELECT Object_PriceChange.Id                              AS Id
                                , ObjectLink_PriceChange_Goods.ChildObjectId         AS GoodsId
                                , ROUND (PriceChange_Value.ValueData, 2) :: TFloat   AS PriceChange
                                , ObjectFloat_FixValue.ValueData                     AS FixValue
                                , COALESCE (PriceChange_PercentMarkup.ValueData, 0) :: TFloat AS PercentMarkup
                                , COALESCE (PriceChange_FixPercent.ValueData, 0)    :: TFloat AS FixPercent
                                , COALESCE (PriceChange_FixDiscount.ValueData, 0)   :: TFloat AS FixDiscount
                                , COALESCE (PriceChange_Multiplicity.ValueData, 0)  :: TFloat AS Multiplicity
                                , PriceChange_DateChange.ValueData                   AS DateChange
                                , PriceChange_FixEndDate.ValueData                AS FixEndDate
                           FROM ObjectLink AS ObjectLink_PriceChange_Retail
                                INNER JOIN ObjectLink AS ObjectLink_PriceChange_Goods
                                                      ON ObjectLink_PriceChange_Goods.ObjectId       = ObjectLink_PriceChange_Retail.ObjectId
                                                     AND ObjectLink_PriceChange_Goods.DescId         = zc_ObjectLink_PriceChange_Goods()
                                                     AND (ObjectLink_PriceChange_Goods.ChildObjectId = inGoodsId OR inGoodsId = 0)
                                INNER JOIN Object AS Object_PriceChange ON Object_PriceChange.Id       = ObjectLink_PriceChange_Retail.ObjectId
                                                                       AND (Object_PriceChange.isErased = FALSE OR inisShowDel = TRUE)
                                LEFT JOIN ObjectFloat AS PriceChange_Value
                                                      ON PriceChange_Value.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                     AND PriceChange_Value.DescId = zc_ObjectFloat_PriceChange_Value()
                                LEFT JOIN ObjectDate AS PriceChange_DateChange
                                                     ON PriceChange_DateChange.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                    AND PriceChange_DateChange.DescId = zc_ObjectDate_PriceChange_DateChange()
                                LEFT JOIN ObjectDate AS PriceChange_FixEndDate
                                                     ON PriceChange_FixEndDate.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                    AND PriceChange_FixEndDate.DescId = zc_ObjectDate_PriceChange_FixEndDate()
                                LEFT JOIN ObjectFloat AS ObjectFloat_FixValue
                                                      ON ObjectFloat_FixValue.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                     AND ObjectFloat_FixValue.DescId = zc_ObjectFloat_PriceChange_FixValue()
                                LEFT JOIN ObjectFloat AS PriceChange_PercentMarkup
                                                      ON PriceChange_PercentMarkup.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                     AND PriceChange_PercentMarkup.DescId = zc_ObjectFloat_PriceChange_PercentMarkup()
                                LEFT JOIN ObjectFloat AS PriceChange_FixPercent
                                                      ON PriceChange_FixPercent.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                     AND PriceChange_FixPercent.DescId = zc_ObjectFloat_PriceChange_FixPercent()
                                LEFT JOIN ObjectFloat AS PriceChange_FixDiscount
                                                      ON PriceChange_FixDiscount.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                     AND PriceChange_FixDiscount.DescId = zc_ObjectFloat_PriceChange_FixDiscount()
                                LEFT JOIN ObjectFloat AS PriceChange_Multiplicity
                                                      ON PriceChange_Multiplicity.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                     AND PriceChange_Multiplicity.DescId = zc_ObjectFloat_PriceChange_Multiplicity()
                           WHERE ObjectLink_PriceChange_Retail.DescId        = zc_ObjectLink_PriceChange_Retail()
                             AND ObjectLink_PriceChange_Retail.ChildObjectId = inRetailId
                             AND inUnitId = 0
                          UNION
                           SELECT Object_PriceChange.Id                              AS Id
                                , ObjectLink_PriceChange_Goods.ChildObjectId         AS GoodsId
                                , ROUND (PriceChange_Value.ValueData, 2) :: TFloat   AS PriceChange
                                , ObjectFloat_FixValue.ValueData                     AS FixValue
                                , COALESCE (PriceChange_PercentMarkup.ValueData, 0) :: TFloat AS PercentMarkup
                                , COALESCE (PriceChange_FixPercent.ValueData, 0)    :: TFloat AS FixPercent
                                , COALESCE (PriceChange_FixDiscount.ValueData, 0)   :: TFloat AS FixDiscount
                                , COALESCE (PriceChange_Multiplicity.ValueData, 0)  :: TFloat AS Multiplicity
                                , PriceChange_DateChange.ValueData                   AS DateChange
                                , PriceChange_FixEndDate.ValueData                   AS FixEndDate
                           FROM ObjectLink AS ObjectLink_PriceChange_Unit
                                INNER JOIN ObjectLink AS ObjectLink_PriceChange_Goods
                                                      ON ObjectLink_PriceChange_Goods.ObjectId       = ObjectLink_PriceChange_Unit.ObjectId
                                                     AND ObjectLink_PriceChange_Goods.DescId         = zc_ObjectLink_PriceChange_Goods()
                                                     AND (ObjectLink_PriceChange_Goods.ChildObjectId = inGoodsId OR inGoodsId = 0)
                                INNER JOIN Object AS Object_PriceChange ON Object_PriceChange.Id       = ObjectLink_PriceChange_Unit.ObjectId
                                                                       AND (Object_PriceChange.isErased = FALSE OR inisShowDel = TRUE)
                                LEFT JOIN ObjectFloat AS PriceChange_Value
                                                      ON PriceChange_Value.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                     AND PriceChange_Value.DescId = zc_ObjectFloat_PriceChange_Value()
                                LEFT JOIN ObjectDate AS PriceChange_DateChange
                                                     ON PriceChange_DateChange.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                    AND PriceChange_DateChange.DescId = zc_ObjectDate_PriceChange_DateChange()
                                LEFT JOIN ObjectDate AS PriceChange_FixEndDate
                                                     ON PriceChange_FixEndDate.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                    AND PriceChange_FixEndDate.DescId = zc_ObjectDate_PriceChange_FixEndDate()
                                LEFT JOIN ObjectFloat AS ObjectFloat_FixValue
                                                      ON ObjectFloat_FixValue.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                     AND ObjectFloat_FixValue.DescId = zc_ObjectFloat_PriceChange_FixValue()
                                LEFT JOIN ObjectFloat AS PriceChange_PercentMarkup
                                                      ON PriceChange_PercentMarkup.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                     AND PriceChange_PercentMarkup.DescId = zc_ObjectFloat_PriceChange_PercentMarkup()
                                LEFT JOIN ObjectFloat AS PriceChange_FixPercent
                                                      ON PriceChange_FixPercent.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                     AND PriceChange_FixPercent.DescId = zc_ObjectFloat_PriceChange_FixPercent()
                                LEFT JOIN ObjectFloat AS PriceChange_FixDiscount
                                                      ON PriceChange_FixDiscount.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                     AND PriceChange_FixDiscount.DescId = zc_ObjectFloat_PriceChange_FixDiscount()
                                LEFT JOIN ObjectFloat AS PriceChange_Multiplicity
                                                      ON PriceChange_Multiplicity.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                     AND PriceChange_Multiplicity.DescId = zc_ObjectFloat_PriceChange_Multiplicity()
                           WHERE ObjectLink_PriceChange_Unit.DescId        = zc_ObjectLink_PriceChange_Unit()
                             AND ObjectLink_PriceChange_Unit.ChildObjectId = inUnitId
                             AND inUnitId <> 0
                          )
      , tmpContainerAll AS (SELECT Container.ObjectId
                                 , Container.Amount 
                                 , Container.Id  
                            FROM tmpObject_Goods_View
                                 INNER JOIN Container ON Container.ObjectId = tmpObject_Goods_View.Id 
                                 INNER JOIN tmpUnit ON tmpUnit.UnitId = Container.WhereObjectId
                            WHERE Container.descid = zc_Container_Count()
                              AND Container.Amount <> 0
                              AND (Container.ObjectId = inGoodsId OR inGoodsId = 0)
                              AND (inGoodsId > 0
                                OR Container.ObjectId IN (SELECT tmpPriceChange.GoodsId FROM tmpPriceChange))
                            )
      , tmpContainerRemains AS (SELECT Container.ObjectId
                                     , SUM (COALESCE (Container.Amount, 0)) :: TFloat AS Remains
                                     , Container.Id                                   AS ContainerId
                                FROM tmpContainerAll AS Container 
                                GROUP BY Container.ObjectId, Container.Id
                                HAVING SUM (COALESCE (Container.Amount, 0)) <> 0
                                )
      , tmpRemains AS (SELECT tmp.ObjectId
                            , SUM (tmp.Remains) :: TFloat AS Remains
                            , MIN (COALESCE (MIDate_ExpirationDate.ValueData,zc_DateEnd())) :: TDateTime AS MinExpirationDate -- Срок годности
                       FROM tmpContainerRemains AS tmp
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
                       GROUP BY tmp.ObjectId
                      )
     -- Штрих-коды производителя
      , tmpGoodsBarCode AS (SELECT ObjectLink_Main_BarCode.ChildObjectId                                                  AS GoodsMainId
                                 , STRING_AGG (Object_Goods_BarCode.ValueData, ',' ORDER BY Object_Goods_BarCode.ID desc) AS BarCode
                                 --, Object_Goods_BarCode.ValueData        AS BarCode
                            FROM ObjectLink AS ObjectLink_Main_BarCode
                                 JOIN ObjectLink AS ObjectLink_Child_BarCode
                                                 ON ObjectLink_Child_BarCode.ObjectId = ObjectLink_Main_BarCode.ObjectId
                                                AND ObjectLink_Child_BarCode.DescId = zc_ObjectLink_LinkGoods_Goods()
                                 JOIN ObjectLink AS ObjectLink_Goods_Object_BarCode
                                                 ON ObjectLink_Goods_Object_BarCode.ObjectId = ObjectLink_Child_BarCode.ChildObjectId
                                                AND ObjectLink_Goods_Object_BarCode.DescId = zc_ObjectLink_Goods_Object()
                                                AND ObjectLink_Goods_Object_BarCode.ChildObjectId = zc_Enum_GlobalConst_BarCode()
                                 LEFT JOIN Object AS Object_Goods_BarCode ON Object_Goods_BarCode.Id = ObjectLink_Goods_Object_BarCode.ObjectId
                            WHERE ObjectLink_Main_BarCode.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                              AND ObjectLink_Main_BarCode.ChildObjectId > 0
                              AND TRIM (Object_Goods_BarCode.ValueData) <> ''
                            GROUP BY ObjectLink_Main_BarCode.ChildObjectId
                           )
      , tmpOH_PriceChange AS (SELECT ObjectHistory_PriceChange.*
                              FROM ObjectHistory AS ObjectHistory_PriceChange
                              WHERE ObjectHistory_PriceChange.DescId = zc_ObjectHistory_PriceChange()
                                AND ObjectHistory_PriceChange.EndDate = zc_DateEnd()
                                -- AND ObjectHistory_PriceChange.ObjectId IN (SELECT DISTINCT tmpPriceChange_All.Id FROM tmpPriceChange_All) 
                              )

            -- Результат
            SELECT
                 tmpPriceChange.Id                                   AS Id
               , COALESCE (tmpPriceChange.PriceChange,0)   :: TFloat AS PriceChange
               , COALESCE (tmpPriceChange.FixValue,0)      :: TFloat AS FixValue
               , COALESCE (tmpPriceChange.PercentMarkup,0) :: TFloat AS PercentMarkup
               , COALESCE (tmpPriceChange.FixPercent,0)    :: TFloat AS FixPercent
               , COALESCE (tmpPriceChange.FixDiscount,0)   :: TFloat AS FixDiscount
               , COALESCE (tmpPriceChange.Multiplicity,0)  :: TFloat AS Multiplicity

               , tmpPriceChange.DateChange                                          AS DateChange
               , COALESCE (ObjectHistory_PriceChange.StartDate, NULL)  :: TDateTime AS StartDate
               , tmpPriceChange.FixEndDate                                          AS FixEndDate

               , Object_Goods_View.id                            AS GoodsId
               , Object_Goods_View.GoodsCodeInt                  AS GoodsCode
               , COALESCE (tmpGoodsBarCode.BarCode, '')  :: TVarChar AS BarCode
               , Object_Goods_View.GoodsName                     AS GoodsName
               , Object_Goods_View.GoodsGroupName                AS GoodsGroupName
               , Object_Goods_View.NDSKindName                   AS NDSKindName
               , Object_Goods_View.NDS                           AS NDS
               , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar  AS ConditionsKeepName
               , Object_Goods_View.isTop                         AS Goods_isTop
               , Object_Goods_View.PercentMarkup                 AS Goods_PercentMarkup

               , Object_Remains.MinExpirationDate                AS MinExpirationDate

               , Object_Remains.Remains                          AS Remains
               , (Object_Remains.Remains * COALESCE (tmpPriceChange.PriceChange,0)) ::TFloat AS SummaRemains

               , CASE WHEN Object_Remains.MinExpirationDate < CURRENT_DATE  + zc_Interval_ExpirationDate() THEN zc_Color_Blue()
                      WHEN Object_Goods_View.isTop = TRUE THEN 15993821 -- розовый
                      ELSE zc_Color_Black()
                 END AS Color_ExpirationDate

               , Object_Goods_View.isClose
               , Object_Goods_View.isFirst
               , Object_Goods_View.isSecond
               , Object_Goods_View.isErased                      AS isErased


            FROM tmpObject_Goods_View AS Object_Goods_View

                LEFT OUTER JOIN tmpPriceChange ON tmpPriceChange.GoodsId = Object_Goods_View.Id

                LEFT OUTER JOIN tmpRemains AS Object_Remains
                                           ON Object_Remains.ObjectId = Object_Goods_View.Id

                LEFT JOIN tmpOH_PriceChange AS ObjectHistory_PriceChange ON ObjectHistory_PriceChange.ObjectId = tmpPriceChange.Id 

                -- условия хранения
                LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep
                                     ON ObjectLink_Goods_ConditionsKeep.ObjectId = Object_Goods_View.Id
                                    AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
                LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId

                LEFT JOIN tmpGoodsBarCode ON tmpGoodsBarCode.GoodsMainId = Object_Goods_View.GoodsMainId

           
           ;
    ELSE
        RETURN QUERY
        WITH
        tmpPriceChange1 AS (SELECT Object_PriceChange.Id                         AS Id
                                 , PriceChange_Goods.ChildObjectId               AS GoodsId
                            FROM ObjectLink AS ObjectLink_PriceChange_Retail
                                 INNER JOIN ObjectLink AS PriceChange_Goods
                                                       ON PriceChange_Goods.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                      AND PriceChange_Goods.DescId   = zc_ObjectLink_PriceChange_Goods()
                                                      AND (PriceChange_Goods.ChildObjectId = inGoodsId OR inGoodsId = 0)
                                 INNER JOIN Object AS Object_PriceChange ON Object_PriceChange.Id       = ObjectLink_PriceChange_Retail.ObjectId
                                                                        AND (Object_PriceChange.isErased = FALSE OR inisShowDel = TRUE)
                            WHERE ObjectLink_PriceChange_Retail.ChildObjectId = inRetailId
                              AND ObjectLink_PriceChange_Retail.DescId        = zc_ObjectLink_PriceChange_Retail()
                              AND inUnitId = 0
                          UNION
                           SELECT Object_PriceChange.Id                              AS Id
                                , ObjectLink_PriceChange_Goods.ChildObjectId         AS GoodsId
                           FROM ObjectLink AS ObjectLink_PriceChange_Unit
                                INNER JOIN ObjectLink AS ObjectLink_PriceChange_Goods
                                                      ON ObjectLink_PriceChange_Goods.ObjectId       = ObjectLink_PriceChange_Unit.ObjectId
                                                     AND ObjectLink_PriceChange_Goods.DescId         = zc_ObjectLink_PriceChange_Goods()
                                                     AND (ObjectLink_PriceChange_Goods.ChildObjectId = inGoodsId OR inGoodsId = 0)
                                INNER JOIN Object AS Object_PriceChange ON Object_PriceChange.Id       = ObjectLink_PriceChange_Unit.ObjectId
                                                                       AND (Object_PriceChange.isErased = FALSE OR inisShowDel = TRUE)
                           WHERE ObjectLink_PriceChange_Unit.DescId        = zc_ObjectLink_PriceChange_Unit()
                             AND ObjectLink_PriceChange_Unit.ChildObjectId = inUnitId
                             AND inUnitId <> 0
                           )

      , tmpPriceChange AS (SELECT tmpPriceChange.Id                             AS Id
                                , tmpPriceChange.GoodsId                        AS GoodsId
                                , ROUND(PriceChange_Value.ValueData,2)::TFloat  AS PriceChange
                                , ObjectFloat_FixValue.ValueData                AS FixValue
                                , COALESCE(PriceChange_PercentMarkup.ValueData, 0) :: TFloat AS PercentMarkup
                                , COALESCE (PriceChange_FixPercent.ValueData, 0)   :: TFloat AS FixPercent
                                , COALESCE (PriceChange_FixDiscount.ValueData, 0)  :: TFloat AS FixDiscount
                                , COALESCE (PriceChange_Multiplicity.ValueData, 0) :: TFloat AS Multiplicity
                                , PriceChange_datechange.valuedata              AS DateChange
                                , PriceChange_FixEndDate.valuedata              AS FixEndDate
                           FROM tmpPriceChange1 AS tmpPriceChange
                                LEFT JOIN ObjectFloat AS PriceChange_Value
                                                      ON PriceChange_Value.ObjectId = tmpPriceChange.Id
                                                     AND PriceChange_Value.DescId = zc_ObjectFloat_PriceChange_Value()
                                LEFT JOIN ObjectFloat AS ObjectFloat_FixValue
                                                      ON ObjectFloat_FixValue.ObjectId = tmpPriceChange.Id
                                                     AND ObjectFloat_FixValue.DescId = zc_ObjectFloat_PriceChange_FixValue()
                                LEFT JOIN ObjectFloat AS PriceChange_PercentMarkup
                                                      ON PriceChange_PercentMarkup.ObjectId = tmpPriceChange.Id
                                                     AND PriceChange_PercentMarkup.DescId = zc_ObjectFloat_PriceChange_PercentMarkup()

                                LEFT JOIN ObjectDate AS PriceChange_DateChange
                                                     ON PriceChange_DateChange.ObjectId = tmpPriceChange.Id
                                                    AND PriceChange_DateChange.DescId = zc_ObjectDate_PriceChange_DateChange()
                                LEFT JOIN ObjectDate AS PriceChange_FixEndDate
                                                     ON PriceChange_FixEndDate.ObjectId = tmpPriceChange.Id
                                                    AND PriceChange_FixEndDate.DescId = zc_ObjectDate_PriceChange_FixEndDate()
                                LEFT JOIN ObjectFloat AS PriceChange_FixPercent
                                                      ON PriceChange_FixPercent.ObjectId = tmpPriceChange.Id
                                                     AND PriceChange_FixPercent.DescId = zc_ObjectFloat_PriceChange_FixPercent()
                                LEFT JOIN ObjectFloat AS PriceChange_FixDiscount
                                                      ON PriceChange_FixDiscount.ObjectId = tmpPriceChange.Id
                                                     AND PriceChange_FixDiscount.DescId = zc_ObjectFloat_PriceChange_FixDiscount()
                                LEFT JOIN ObjectFloat AS PriceChange_Multiplicity
                                                      ON PriceChange_Multiplicity.ObjectId = tmpPriceChange.Id
                                                     AND PriceChange_Multiplicity.DescId = zc_ObjectFloat_PriceChange_Multiplicity()
                          )

      , tmpContainerRemains AS (SELECT Container.ObjectId
                                     , SUM (COALESCE (Container.Amount,0)) ::TFloat AS Remains
                                     , Container.Id   AS  ContainerId
                                FROM tmpPriceChange
                                     INNER JOIN Container ON Container.ObjectId = tmpPriceChange.GoodsId
                                     INNER JOIN tmpUnit ON tmpUnit.UnitId = Container.WhereObjectId
                                WHERE Container.DescId = zc_Container_Count()
                                  AND Container.Amount<>0
                                  AND (Container.ObjectId = inGoodsId OR inGoodsId = 0)
                                GROUP BY Container.ObjectId, Container.Id
                                HAVING SUM (COALESCE (Container.Amount, 0)) <> 0
                                )
      , tmpCLO AS (SELECT ContainerLinkObject_MovementItem.*
                   FROM ContainerlinkObject AS ContainerLinkObject_MovementItem
                   WHERE ContainerLinkObject_MovementItem.Containerid IN (SELECT DISTINCT tmpContainerRemains.ContainerId FROM tmpContainerRemains)
                     AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                    )
      , tmpRemains1 AS (SELECT tmp.ObjectId
                             , tmp.Remains
                             , Object_PartionMovementItem.ObjectCode ::Integer
                       FROM tmpContainerRemains AS tmp
                              -- находим партию
                              LEFT JOIN tmpCLO AS ContainerLinkObject_MovementItem
                                                            ON ContainerLinkObject_MovementItem.Containerid =  tmp.ContainerId
                                                          -- AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                              LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId

                       )
      , tmpMIFloat_MovementItem AS (SELECT MIFloat_MovementItem.*
                                    FROM MovementItemFloat AS MIFloat_MovementItem
                                    WHERE MIFloat_MovementItem.MovementItemId IN (SELECT tmpRemains1.ObjectCode FROM tmpRemains1)
                                      AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                    )

      , tmpRemains2 AS (SELECT tmp.ObjectId
                             , (tmp.Remains)  ::TFloat  AS Remains
                             , MIFloat_MovementItem.ValueData :: Integer AS MI_Id_find
                             , MI_Income.Id                              AS MI_Id
                        FROM tmpRemains1 AS tmp
                               -- элемент прихода
                               LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = tmp.ObjectCode
                               -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                               LEFT JOIN tmpMIFloat_MovementItem AS MIFloat_MovementItem
                                                           ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                          AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                        )

      , tmpMIDate_ExpirationDate AS (SELECT MIDate_ExpirationDate.*
                                     FROM MovementItemDate  AS MIDate_ExpirationDate
                                     WHERE MIDate_ExpirationDate.MovementItemId IN (SELECT DISTINCT COALESCE (tmpRemains2.MI_Id_find, tmpRemains2.MI_Id) FROM tmpRemains2)   --Object_PartionMovementItem.ObjectCode
                                       AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                                     )
      , tmpRemains3 AS (SELECT tmp.ObjectId
                             , (tmp.Remains)  ::TFloat  AS Remains
                             , (COALESCE(MIDate_ExpirationDate.ValueData,zc_DateEnd()))::TDateTime AS MinExpirationDate -- Срок годности
                        FROM tmpRemains2 AS tmp
                               -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                               LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = tmp.MI_Id_find

                               LEFT OUTER JOIN tmpMIDate_ExpirationDate AS MIDate_ExpirationDate
                                                                        ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id, tmp.MI_Id)  --Object_PartionMovementItem.ObjectCode
                        )


      , tmpRemains AS (SELECT tmp.ObjectId
                            , Sum(tmp.Remains)  ::TFloat  AS Remains
                            , MIN(tmp.MinExpirationDate) ::TDateTime AS MinExpirationDate -- Срок годности
                       FROM tmpRemains3 AS tmp
                       GROUP BY tmp.ObjectId
                       )
      -- объединяем товары прайса с товарами, которые есть на остатке. ?????(если цена = 0, а остаток есть нужно показать такие товары)?????
      , tmpPriceChange_All AS (SELECT tmpPriceChange.Id
                                    , tmpPriceChange.PriceChange
                                    , tmpPriceChange.FixValue
                                    , COALESCE (tmpPriceChange.GoodsId, tmpRemains.ObjectId) AS GoodsId
                                    , tmpPriceChange.DateChange
                                    , tmpPriceChange.FixEndDate
                                    , tmpPriceChange.PercentMarkup
                                    , tmpPriceChange.FixPercent
                                    , tmpPriceChange.FixDiscount
                                    , tmpPriceChange.Multiplicity
                                    , tmpRemains.Remains
                                    , tmpRemains.MinExpirationDate
                               FROM tmpPriceChange AS tmpPriceChange
                                    FULL JOIN tmpRemains ON tmpRemains.ObjectId = tmpPriceChange.GoodsId
                               )

        -- Штрих-коды производителя
      , tmpGoodsBarCode AS (SELECT ObjectLink_Main_BarCode.ChildObjectId                                                  AS GoodsMainId
                                 , STRING_AGG (Object_Goods_BarCode.ValueData, ',' ORDER BY Object_Goods_BarCode.ID desc) AS BarCode
                                 --, Object_Goods_BarCode.ValueData        AS BarCode
                            FROM ObjectLink AS ObjectLink_Main_BarCode
                                 JOIN ObjectLink AS ObjectLink_Child_BarCode
                                                 ON ObjectLink_Child_BarCode.ObjectId = ObjectLink_Main_BarCode.ObjectId
                                                AND ObjectLink_Child_BarCode.DescId = zc_ObjectLink_LinkGoods_Goods()
                                 JOIN ObjectLink AS ObjectLink_Goods_Object_BarCode
                                                 ON ObjectLink_Goods_Object_BarCode.ObjectId = ObjectLink_Child_BarCode.ChildObjectId
                                                AND ObjectLink_Goods_Object_BarCode.DescId = zc_ObjectLink_Goods_Object()
                                                AND ObjectLink_Goods_Object_BarCode.ChildObjectId = zc_Enum_GlobalConst_BarCode()
                                 LEFT JOIN Object AS Object_Goods_BarCode ON Object_Goods_BarCode.Id = ObjectLink_Goods_Object_BarCode.ObjectId
                            WHERE ObjectLink_Main_BarCode.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                              AND ObjectLink_Main_BarCode.ChildObjectId > 0
                              AND TRIM (Object_Goods_BarCode.ValueData) <> ''
                            GROUP BY ObjectLink_Main_BarCode.ChildObjectId
                           )

      , tmpGoods AS (SELECT ObjectLink_Goods_Object.ObjectId AS GoodsId
                     FROM ObjectLink AS ObjectLink_Goods_Object
                     WHERE ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                       AND ObjectLink_Goods_Object.ChildObjectId = vbRetailId --vbObjectId
                       AND ObjectLink_Goods_Object.ObjectId IN (SELECT DISTINCT tmpPriceChange_All.GoodsId FROM tmpPriceChange_All)
                     )

      , tmpGoods_All AS (SELECT  Object_Goods.Id                                  AS Id
                               , Object_Goods.ObjectCode                          AS GoodsCodeInt
                               , Object_Goods.ValueData                           AS GoodsName
                               , Object_Goods.isErased                            AS isErased
                               , Object_GoodsGroup.ValueData                      AS GoodsGroupName
                               , ObjectLink_Goods_NDSKind.ChildObjectId           AS NDSKindId
                               , Object_NDSKind.ValueData                         AS NDSKindName
                               , ObjectFloat_NDSKind_NDS.ValueData                AS NDS
                               , COALESCE(ObjectBoolean_Goods_Close.ValueData, false)   AS isClose
                               , COALESCE(ObjectBoolean_Goods_TOP.ValueData, false)     AS isTOP
                               , COALESCE(ObjectBoolean_First.ValueData, False)         AS isFirst
                               , COALESCE(ObjectBoolean_Second.ValueData, False)        AS isSecond

                               , ObjectFloat_Goods_PercentMarkup.ValueData        AS PercentMarkup

                         FROM tmpGoods
                              LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoods.GoodsId

                              LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                   ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpGoods.GoodsId
                                                  AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()

                              LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                              LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                                   ON ObjectLink_Goods_NDSKind.ObjectId = tmpGoods.GoodsId
                                                  AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
                              LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId

                              LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                    ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId
                                                   AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()

                              LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Close
                                                      ON ObjectBoolean_Goods_Close.ObjectId = tmpGoods.GoodsId
                                                     AND ObjectBoolean_Goods_Close.DescId = zc_ObjectBoolean_Goods_Close()

                              LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                      ON ObjectBoolean_Goods_TOP.ObjectId = tmpGoods.GoodsId
                                                     AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()

                              LEFT JOIN ObjectBoolean AS ObjectBoolean_First
                                                      ON ObjectBoolean_First.ObjectId = tmpGoods.GoodsId
                                                     AND ObjectBoolean_First.DescId = zc_ObjectBoolean_Goods_First()
                              LEFT JOIN ObjectBoolean AS ObjectBoolean_Second
                                                      ON ObjectBoolean_Second.ObjectId = tmpGoods.GoodsId
                                                     AND ObjectBoolean_Second.DescId = zc_ObjectBoolean_Goods_Second()

                              LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PercentMarkup
                                                    ON ObjectFloat_Goods_PercentMarkup.ObjectId = tmpGoods.GoodsId
                                                   AND ObjectFloat_Goods_PercentMarkup.DescId = zc_ObjectFloat_Goods_PercentMarkup()
                          )

        -- условия хранения
      , tmpGoods_ConditionsKeep AS (SELECT ObjectLink_Goods_ConditionsKeep.*
                                    FROM ObjectLink AS ObjectLink_Goods_ConditionsKeep
                                    WHERE ObjectLink_Goods_ConditionsKeep.ObjectId IN (SELECT DISTINCT tmpPriceChange_All.GoodsId FROM tmpPriceChange_All)
                                      AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
                                   )
      , tmpOH_PriceChange AS (SELECT ObjectHistory_PriceChange.*
                              FROM ObjectHistory AS ObjectHistory_PriceChange
                              WHERE ObjectHistory_PriceChange.DescId = zc_ObjectHistory_PriceChange()
                                AND ObjectHistory_PriceChange.EndDate = zc_DateEnd()
                                -- AND ObjectHistory_PriceChange.ObjectId IN (SELECT DISTINCT tmpPriceChange_All.Id FROM tmpPriceChange_All) 
                              )
            -- Результат
            SELECT tmpPriceChange_All.Id                                        AS Id
                 , COALESCE (tmpPriceChange_All.PriceChange,0)     :: TFloat    AS PriceChange
                 , COALESCE (tmpPriceChange_All.FixValue,0)        :: TFloat    AS FixValue
                 , COALESCE (tmpPriceChange_All.PercentMarkup, 0)  :: TFloat    AS PercentMarkup
                 , COALESCE (tmpPriceChange_All.FixPercent, 0)     :: TFloat    AS FixPercent
                 , COALESCE (tmpPriceChange_All.FixDiscount, 0)    :: TFloat    AS FixDiscount
                 , COALESCE (tmpPriceChange_All.Multiplicity, 0)   :: TFloat    AS Multiplicity
                 , tmpPriceChange_All.DateChange                                AS DateChange
                 , COALESCE (ObjectHistory_PriceChange.StartDate, NULL) :: TDateTime AS StartDate
                 , tmpPriceChange_All.FixEndDate                                AS FixEndDate

                 , Object_Goods_View.id                      AS GoodsId
                 , Object_Goods_View.GoodsCodeInt            AS GoodsCode
                 , tmpGoodsBarCode.BarCode     :: TVarChar AS BarCode
                 , Object_Goods_View.GoodsName               AS GoodsName
                 , Object_Goods_View.GoodsGroupName          AS GoodsGroupName
                 , Object_Goods_View.NDSKindName             AS NDSKindName
                 , Object_Goods_View.NDS                     AS NDS
                 , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar  AS ConditionsKeepName
                 , Object_Goods_View.isTop                   AS Goods_isTop
                 , Object_Goods_View.PercentMarkup           AS Goods_PercentMarkup

                 , tmpPriceChange_All.MinExpirationDate      AS MinExpirationDate
                 , tmpPriceChange_All.Remains                AS Remains
                 , (tmpPriceChange_All.Remains * COALESCE (tmpPriceChange_All.PriceChange,0)) ::TFloat AS SummaRemains

                 , CASE WHEN tmpPriceChange_All.MinExpirationDate < CURRENT_DATE  + zc_Interval_ExpirationDate() THEN zc_Color_Blue()
                        WHEN Object_Goods_View.isTop = TRUE THEN 15993821 -- розовый
                        ELSE zc_Color_Black()
                   END AS Color_ExpirationDate

                 , Object_Goods_View.isClose
                 , Object_Goods_View.isFirst
                 , Object_Goods_View.isSecond
                 , Object_Goods_View.isErased                                    AS isErased

            FROM tmpPriceChange_All
               LEFT JOIN tmpGoods_All AS Object_Goods_View ON Object_Goods_View.id = tmpPriceChange_All.GoodsId
               LEFT JOIN tmpOH_PriceChange AS ObjectHistory_PriceChange ON ObjectHistory_PriceChange.ObjectId = tmpPriceChange_All.Id 

               -- условия хранения
               LEFT JOIN tmpGoods_ConditionsKeep AS ObjectLink_Goods_ConditionsKeep
                                                 ON ObjectLink_Goods_ConditionsKeep.ObjectId = Object_Goods_View.Id
               LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId

               -- получается GoodsMainId
               LEFT JOIN ObjectLink AS ObjectLink_Child ON ObjectLink_Child.ChildObjectId = tmpPriceChange_All.GoodsId
                                                        AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
               LEFT JOIN ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                       AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
               LEFT JOIN tmpGoodsBarCode ON tmpGoodsBarCode.GoodsMainId = ObjectLink_Main.ChildObjectId

            WHERE (inisShowDel = TRUE OR Object_Goods_View.isErased = FALSE)
              AND (Object_Goods_View.Id = inGoodsId OR inGoodsId = 0)
           ;

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.  Шаблий О.В.
 30.04.21                                                                      * FixEndDate
 04.12.19                                                                      * FixDiscount
 13.03.19         * Multiplicity
 07.02.19         *
 27.09.18         * add inUnitId
 16.08.18         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_PriceChange (inRetailId:= 4, inUnitId:= 0, inGoodsId:= 0, inisShowAll:= FALSE, inisShowDel:= FALSE, inSession:= '3');
-- select * from gpSelect_Object_PriceChange(inRetailId := 4 , inUnitId := 0 , inGoodsId := 0 , inisShowAll := 'True' , inisShowDel := 'False' ,  inSession := '3');
