-- Function: gpSelect_Object_PriceChange (TVarChar)
DROP FUNCTION IF EXISTS gpSelect_Object_PriceChange(Integer, Integer, Boolean,Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PriceChange(
    IN inRetailId    Integer,       -- подразделение
    IN inGoodsId     Integer,       -- Товар
    IN inisShowAll   Boolean,       -- True - показать все товары, False - показать только с ценами
    IN inisShowDel   Boolean,       -- True - показать так же удаленные, False - показать только рабочие
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , PriceChange TFloat, FixValue TFloat, PercentMarkup TFloat
             , PriceChange_OH TFloat, FixValue_OH TFloat, PercentMarkup_OH TFloat
             , DateChange TDateTime, StartDate TDateTime
             , GoodsId Integer, GoodsCode Integer
             , BarCode TVarChar
             , GoodsName TVarChar
             , IntenalSPName TVarChar
             , GoodsGroupName TVarChar, NDSKindName TVarChar, NDS TFloat
             , ConditionsKeepName TVarChar
             , Goods_isTop Boolean, Goods_PercentMarkup TFloat
             , MinExpirationDate TDateTime
             , Remains TFloat, SummaRemains TFloat
             , PriceRetSP TFloat, PriceOptSP TFloat
             , PriceSP   TFloat
             , PaymentSP TFloat
             , isSP Boolean
             , isErased boolean
             , isClose boolean, isFirst boolean , isSecond boolean
             , isPromo boolean
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

    CREATE TEMP TABLE tmpUnit (UnitId Integer) ON COMMIT DROP;
    INSERT INTO tmpUnit (UnitId)
          -- все подразделения торговой сети
          SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
          FROM ObjectLink AS ObjectLink_Unit_Juridical
              INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                    ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                   AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                   AND (ObjectLink_Juridical_Retail.ChildObjectId = inRetailId OR inRetailId = 0)
          WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical();

    IF inRetailId is null
    THEN
        inRetailId := 0;
    END IF;
    -- Результат
    IF COALESCE(inRetailId,0) = 0
    THEN
        RETURN QUERY
            SELECT 
                NULL::Integer                    AS Id
               ,NULL::TFloat                     AS PriceChange
               ,NULL::TFloat                     AS FixValue
               ,NULL::TFloat                     AS PercentMarkup
               ,NULL::TFloat                     AS PriceChange
               ,NULL::TFloat                     AS FixValue
               ,NULL::TFloat                     AS PercentMarkup
               ,NULL::TDateTime                  AS DateChange
               ,NULL::TDateTime                  AS StartDate
               ,NULL::Integer                    AS GoodsId
               ,NULL::Integer                    AS GoodsCode
               ,NULL::TVarChar                   AS BarCode
               ,NULL::TVarChar                   AS GoodsName
               ,NUll::TVarChar                   AS IntenalSPName
               ,NULL::TVarChar                   AS GoodsGroupName
               ,NULL::TVarChar                   AS NDSKindName
               ,NULL::TFloat                     AS NDS
               ,NULL::TVarChar                   AS ConditionsKeepName
               ,NULL::Boolean                    AS Goods_isTop
               ,NULL::TFloat                     AS Goods_PercentMarkup
               ,NULL::TDateTime                  AS MinExpirationDate
               ,NULL::TFloat                     AS Remains
               ,NULL::TFloat                     AS SummaRemains
               ,NULL::TFloat                     AS PriceRetSP
               ,NULL::TFloat                     AS PriceOptSP
               ,NULL::TFloat                     AS PriceSP
               ,NULL::TFloat                     AS PaymentSP
               ,NULL::Boolean                    AS isSP
               ,NULL::Boolean                    AS isErased
               ,NULL::Boolean                    AS isClose 
               ,NULL::Boolean                    AS isFirst 
               ,NULL::Boolean                    AS isSecond 
               ,NULL::Boolean                    AS isPromo 

               ,zc_Color_Black()  ::Integer      AS Color_ExpirationDate 

            WHERE 1=0;
    ELSEIF inisShowAll = True
    THEN
        RETURN QUERY
        With 
        tmpContainerRemains AS (SELECT Container.ObjectId
                                     , Sum(COALESCE(Container.Amount,0)) ::TFloat AS Remains
                                     , Container.Id                               AS ContainerId
                                FROM Container
                                     INNER JOIN tmpUnit ON tmpUnit.UnitId = Container.WhereObjectId
                                WHERE Container.descid = zc_Container_Count() 
                                  AND Amount<>0
                                  AND (Container.ObjectId = inGoodsId OR inGoodsId = 0)
and 1=0
                                GROUP BY Container.ObjectId, Container.Id
                                HAVING SUM(COALESCE (Container.Amount, 0)) <> 0
                                )
      , tmpRemains AS (SELECT tmp.ObjectId
                            , Sum(tmp.Remains)  ::TFloat  AS Remains
                            , MIN(COALESCE(MIDate_ExpirationDate.ValueData,zc_DateEnd()))::TDateTime AS MinExpirationDate -- Срок годности
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
      , tmpPriceChange AS (SELECT ObjectLink_PriceChange_Retail.ObjectId          AS Id
                                , PriceChange_Goods.ChildObjectId                 AS GoodsId
                                , ROUND(PriceChange_Value.ValueData,2)  ::TFloat  AS PriceChange 
                                , ObjectFloat_FixValue.ValueData                  AS FixValue 
                                , COALESCE(PriceChange_PercentMarkup.ValueData, 0) ::TFloat AS PercentMarkup 
                                , PriceChange_DateChange.ValueData                AS DateChange 
                           FROM ObjectLink AS ObjectLink_PriceChange_Retail
                                INNER JOIN ObjectLink AS PriceChange_Goods
                                                      ON PriceChange_Goods.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                     AND PriceChange_Goods.DescId = zc_ObjectLink_PriceChange_Goods()
                                                     AND (PriceChange_Goods.ChildObjectId = inGoodsId OR inGoodsId = 0)
                                -- ограничение по торговой сети
                                /*INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                      ON ObjectLink_Goods_Object.ObjectId = PriceChange_Goods.ChildObjectId
                                                     AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                     AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                                */
                                LEFT JOIN ObjectFloat AS PriceChange_Value
                                                      ON PriceChange_Value.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                     AND PriceChange_Value.DescId = zc_ObjectFloat_PriceChange_Value()
                                LEFT JOIN ObjectDate AS PriceChange_DateChange
                                                     ON PriceChange_DateChange.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                    AND PriceChange_DateChange.DescId = zc_ObjectDate_PriceChange_DateChange()
                                LEFT JOIN ObjectFloat AS ObjectFloat_FixValue
                                                      ON ObjectFloat_FixValue.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                     AND ObjectFloat_FixValue.DescId = zc_ObjectFloat_PriceChange_FixValue()
    
                                LEFT JOIN ObjectFloat AS PriceChange_PercentMarkup
                                                      ON PriceChange_PercentMarkup.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                     AND PriceChange_PercentMarkup.DescId = zc_ObjectFloat_PriceChange_PercentMarkup()
                           WHERE ObjectLink_PriceChange_Retail.DescId = zc_ObjectLink_PriceChange_Retail()
                             AND ObjectLink_PriceChange_Retail.ChildObjectId = inRetailId
                       )
                           
   -- Штрих-коды производителя
   , tmpGoodsBarCode AS (SELECT ObjectLink_Main_BarCode.ChildObjectId AS GoodsMainId
                              , Object_Goods_BarCode.ValueData        AS BarCode
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
                        )
                       
   
            -- Результат
            SELECT
                 tmpPriceChange.Id                                                  AS Id
               , COALESCE (tmpPriceChange.PriceChange,0)                  :: TFloat AS PriceChange
               , COALESCE (tmpPriceChange.FixValue,0)                     :: TFloat AS FixValue
               , COALESCE (tmpPriceChange.PercentMarkup,0)                :: TFloat AS PercentMarkup
               
               , COALESCE (ObjectHistoryFloat_Value.ValueData,0)          :: TFloat AS PriceChange_OH
               , COALESCE (ObjectHistoryFloat_FixValue.ValueData, 0)      :: TFloat AS FixValue_OH
               , COALESCE (ObjectHistoryFloat_PercentMarkup.ValueData, 0) :: TFloat AS PercentMarkup_OH

               , tmpPriceChange.DateChange                                          AS DateChange
               , COALESCE (ObjectHistory_PriceChange.StartDate, NULL)  :: TDateTime AS StartDate
                              
               , Object_Goods_View.id                            AS GoodsId
               , Object_Goods_View.GoodsCodeInt                  AS GoodsCode
               , COALESCE (tmpGoodsBarCode.BarCode, '')  :: TVarChar AS BarCode
               , Object_Goods_View.GoodsName                     AS GoodsName
               , Object_IntenalSP.ValueData                      AS IntenalSPName
               , Object_Goods_View.GoodsGroupName                AS GoodsGroupName
               , Object_Goods_View.NDSKindName                   AS NDSKindName
               , Object_Goods_View.NDS                           AS NDS
               , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar  AS ConditionsKeepName
               , Object_Goods_View.isTop                         AS Goods_isTop
               , Object_Goods_View.PercentMarkup                 AS Goods_PercentMarkup
               
               , Object_Remains.MinExpirationDate                AS MinExpirationDate

               , Object_Remains.Remains                          AS Remains
               , (Object_Remains.Remains * COALESCE (tmpPriceChange.PriceChange,0)) ::TFloat AS SummaRemains
               
               , COALESCE (ObjectFloat_Goods_PriceRetSP.ValueData,0) ::TFloat  AS PriceRetSP
               , COALESCE (ObjectFloat_Goods_PriceOptSP.ValueData,0) ::TFloat  AS PriceOptSP

               , COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)        :: TFloat AS PriceSP
               , COALESCE (ObjectFloat_Goods_PaymentSP.ValueData, 0)      :: TFloat AS PaymentSP
               
               , COALESCE (ObjectBoolean_Goods_SP.ValueData,False) :: Boolean  AS isSP
               , Object_Goods_View.isErased                      AS isErased 

               , Object_Goods_View.isClose
               , Object_Goods_View.isFirst
               , Object_Goods_View.isSecond
               , CASE WHEN COALESCE(GoodsPromo.GoodsId,0) <> 0 THEN TRUE ELSE FALSE END AS isPromo

               , CASE WHEN ObjectBoolean_Goods_SP.ValueData = TRUE THEN 25088 --zc_Color_GreenL()
                      WHEN Object_Remains.MinExpirationDate < CURRENT_DATE  + zc_Interval_ExpirationDate() THEN zc_Color_Blue() 
                      WHEN Object_Goods_View.isTop = TRUE THEN 15993821 -- розовый
                      ELSE zc_Color_Black() 
                 END     AS Color_ExpirationDate

            FROM Object_Goods_View
                INNER JOIN ObjectLink ON ObjectLink.ObjectId = Object_Goods_View.Id 
                                     AND ObjectLink.ChildObjectId = vbObjectId
                LEFT OUTER JOIN tmpPriceChange ON tmpPriceChange.Goodsid = Object_Goods_View.Id

                LEFT OUTER JOIN tmpRemains AS Object_Remains
                                           ON Object_Remains.ObjectId = Object_Goods_View.Id
   
                -- получаем значения цены из истории значений на дату                                                           
                LEFT JOIN ObjectHistory AS ObjectHistory_PriceChange
                                        ON ObjectHistory_PriceChange.ObjectId = tmpPriceChange.Id 
                                       AND ObjectHistory_PriceChange.DescId = zc_ObjectHistory_PriceChange()
                                       AND ObjectHistory_PriceChange.EndDate = zc_DateEnd()
                -- получаем значения из истории значений на дату    
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                             ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory_PriceChange.Id
                                            AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_PriceChange_Value()
                -- получаем значения из истории значений на дату    
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_FixValue
                                             ON ObjectHistoryFloat_FixValue.ObjectHistoryId = ObjectHistory_PriceChange.Id
                                            AND ObjectHistoryFloat_FixValue.DescId = zc_ObjectHistoryFloat_PriceChange_FixValue()
                -- получаем значения из истории значений на дату    
                LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PercentMarkup
                                             ON ObjectHistoryFloat_PercentMarkup.ObjectHistoryId = ObjectHistory_PriceChange.Id
                                            AND ObjectHistoryFloat_PercentMarkup.DescId = zc_ObjectHistoryFloat_PriceChange_PercentMarkup() 
               
                LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId = Object_Goods_View.Id     
                -- условия хранения
                LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep 
                                     ON ObjectLink_Goods_ConditionsKeep.ObjectId = Object_Goods_View.Id
                                    AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
                LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId                        

               -- получается GoodsMainId
               LEFT JOIN  ObjectLink AS ObjectLink_Child ON ObjectLink_Child.ChildObjectId = Object_Goods_View.Id
                                                        AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
               LEFT JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                       AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

               LEFT JOIN  ObjectBoolean AS ObjectBoolean_Goods_SP 
                                        ON ObjectBoolean_Goods_SP.ObjectId = ObjectLink_Main.ChildObjectId 
                                       AND ObjectBoolean_Goods_SP.DescId = zc_ObjectBoolean_Goods_SP()

               LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PriceRetSP
                                     ON ObjectFloat_Goods_PriceRetSP.ObjectId = ObjectLink_Main.ChildObjectId 
                                    AND ObjectFloat_Goods_PriceRetSP.DescId = zc_ObjectFloat_Goods_PriceRetSP() 
               LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PriceOptSP
                                     ON ObjectFloat_Goods_PriceOptSP.ObjectId = ObjectLink_Main.ChildObjectId
                                    AND ObjectFloat_Goods_PriceOptSP.DescId = zc_ObjectFloat_Goods_PriceOptSP() 
               LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PriceSP
                                     ON ObjectFloat_Goods_PriceSP.ObjectId = ObjectLink_Main.ChildObjectId 
                                    AND ObjectFloat_Goods_PriceSP.DescId = zc_ObjectFloat_Goods_PriceSP()   
               LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PaymentSP
                                     ON ObjectFloat_Goods_PaymentSP.ObjectId = ObjectLink_Main.ChildObjectId 
                                    AND ObjectFloat_Goods_PaymentSP.DescId = zc_ObjectFloat_Goods_PaymentSP() 

               LEFT JOIN ObjectLink AS ObjectLink_Goods_IntenalSP
                                    ON ObjectLink_Goods_IntenalSP.ObjectId = ObjectLink_Main.ChildObjectId
                                   AND ObjectLink_Goods_IntenalSP.DescId = zc_ObjectLink_Goods_IntenalSP()
               LEFT JOIN Object AS Object_IntenalSP ON Object_IntenalSP.Id = ObjectLink_Goods_IntenalSP.ChildObjectId
               
               LEFT JOIN ObjectDate AS ObjectDate_LastPrice
                                    ON ObjectDate_LastPrice.ObjectId = ObjectLink_Main.ChildObjectId
                                   AND ObjectDate_LastPrice.DescId = zc_ObjectDate_Goods_LastPrice()
        
               LEFT JOIN tmpGoodsBarCode ON tmpGoodsBarCode.GoodsMainId = ObjectLink_Main.ChildObjectId
               
            WHERE (inisShowDel = True OR Object_Goods_View.isErased = False)
              AND (Object_Goods_View.Id = inGoodsId OR inGoodsId = 0)
            ORDER BY GoodsGroupName, GoodsName;
    ELSE
        RETURN QUERY
        WITH 
        tmpContainerRemains AS (SELECT Container.ObjectId
                                     , Sum(COALESCE(Container.Amount,0)) ::TFloat AS Remains
                                     , Container.Id   AS  ContainerId
                                FROM Container
                                     INNER JOIN tmpUnit ON tmpUnit.UnitId = Container.WhereObjectId
                                WHERE Container.descid = zc_Container_count() 
                                  AND Amount<>0
                                  AND (Container.ObjectId = inGoodsId OR inGoodsId = 0)
and 1=0
                                GROUP BY Container.ObjectId, Container.Id
                                HAVING SUM(COALESCE (Container.Amount, 0)) <> 0
                                )
/*      , tmpRemains AS (SELECT tmp.ObjectId
                            , Sum(tmp.Remains)  ::TFloat  AS Remains
                            , MIN(COALESCE(MIDate_ExpirationDate.ValueData,zc_DateEnd()))::TDateTime AS MinExpirationDate -- Срок годности
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
*/
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
      , tmpPriceChange1 AS (SELECT ObjectLink_PriceChange_Retail.ObjectId        AS Id
                                , PriceChange_Goods.ChildObjectId               AS GoodsId
                           FROM ObjectLink AS ObjectLink_PriceChange_Retail
                                INNER JOIN ObjectLink AS PriceChange_Goods
                                                      ON PriceChange_Goods.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                     AND PriceChange_Goods.DescId = zc_ObjectLink_PriceChange_Goods()
                                                     AND (PriceChange_Goods.ChildObjectId = inGoodsId OR inGoodsId = 0)

                                -- ограничение по торговой сети
                                INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                      ON ObjectLink_Goods_Object.ObjectId = PriceChange_Goods.ChildObjectId
                                                     AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                     AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId

                           WHERE ObjectLink_PriceChange_Retail.DescId = zc_ObjectLink_PriceChange_Retail()
                             AND ObjectLink_PriceChange_Retail.ChildObjectId = inRetailId
                           )

      , tmpPriceChange AS (SELECT tmpPriceChange.Id                             AS Id
                                , tmpPriceChange.GoodsId                        AS GoodsId
                                , ROUND(PriceChange_Value.ValueData,2)::TFloat  AS PriceChange 
                                , ObjectFloat_FixValue.ValueData                AS FixValue 
                                , COALESCE(PriceChange_PercentMarkup.ValueData, 0) ::TFloat AS PercentMarkup 
                                , PriceChange_datechange.valuedata              AS DateChange 
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
                          )

      -- объединяем товары прайса с товарами, которые есть на остатке. (если цена = 0, а остаток есть нужно показать такие товары)
      , tmpPriceChange_All AS (SELECT tmpPriceChange.Id
                                    , tmpPriceChange.PriceChange 
                                    , tmpPriceChange.FixValue 
                                    , COALESCE (tmpPriceChange.GoodsId, tmpRemains.ObjectId) AS GoodsId
                                    , tmpPriceChange.DateChange 
                                    , tmpPriceChange.PercentMarkup 
                                    , tmpRemains.Remains
                                    , tmpRemains.MinExpirationDate 
                               FROM tmpPriceChange AS tmpPriceChange
                                    FULL JOIN tmpRemains ON tmpRemains.ObjectId = tmpPriceChange.GoodsId
                               )

      -- Штрих-коды производителя
      , tmpGoodsBarCode AS (SELECT ObjectLink_Main_BarCode.ChildObjectId AS GoodsMainId
                                 , Object_Goods_BarCode.ValueData        AS BarCode
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
                           )
                        
      , tmpGoods AS (SELECT ObjectLink_Goods_Object.ObjectId AS GoodsId
                     FROM ObjectLink AS ObjectLink_Goods_Object
                     WHERE ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                       AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                       AND ObjectLink_Goods_Object.ObjectId IN (SELECT DISTINCT tmpPriceChange_All.Goodsid FROM tmpPriceChange_All)
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

      , tmpGoodsMainParam AS (SELECT tmpPriceChange_All.GoodsId
                                   , COALESCE (ObjectBoolean_Goods_SP.ValueData,False) :: Boolean  AS isSP
                                   , COALESCE (ObjectFloat_Goods_PriceRetSP.ValueData,0) ::TFloat  AS PriceRetSP
                                   , COALESCE (ObjectFloat_Goods_PriceOptSP.ValueData,0) ::TFloat  AS PriceChangeOptS
                                   , COALESCE (ObjectFloat_Goods_PriceSP.ValueData,0)    ::TFloat  AS PriceSP
                                   , COALESCE (ObjectFloat_Goods_PaymentSP.ValueData,0)  ::TFloat  AS PaymentSP
                                   , Object_IntenalSP.ValueData                                    AS IntenalSPName
                                   , ObjectDate_LastPrice.ValueData                                AS Date_LastPrice
                                   , COALESCE (tmpGoodsBarCode.BarCode, '')            :: TVarChar AS BarCode
                              FROM tmpPriceChange_All
                                   -- получается GoodsMainId
                                   LEFT JOIN ObjectLink AS ObjectLink_Child ON ObjectLink_Child.ChildObjectId = tmpPriceChange_All.Goodsid
                                                                            AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                                   LEFT JOIN ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                           AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                    
                                   LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_SP 
                                                            ON ObjectBoolean_Goods_SP.ObjectId = ObjectLink_Main.ChildObjectId 
                                                           AND ObjectBoolean_Goods_SP.DescId = zc_ObjectBoolean_Goods_SP()
                    
                                   LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PriceRetSP
                                                         ON ObjectFloat_Goods_PriceRetSP.ObjectId = ObjectLink_Main.ChildObjectId 
                                                        AND ObjectFloat_Goods_PriceRetSP.DescId = zc_ObjectFloat_Goods_PriceRetSP() 
                                   LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PriceOptSP
                                                         ON ObjectFloat_Goods_PriceOptSP.ObjectId = ObjectLink_Main.ChildObjectId
                                                        AND ObjectFloat_Goods_PriceOptSP.DescId = zc_ObjectFloat_Goods_PriceOptSP() 
                                   LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PriceSP
                                                         ON ObjectFloat_Goods_PriceSP.ObjectId = ObjectLink_Main.ChildObjectId 
                                                        AND ObjectFloat_Goods_PriceSP.DescId = zc_ObjectFloat_Goods_PriceSP()   
                                   LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PaymentSP
                                                         ON ObjectFloat_Goods_PaymentSP.ObjectId = ObjectLink_Main.ChildObjectId 
                                                        AND ObjectFloat_Goods_PaymentSP.DescId = zc_ObjectFloat_Goods_PaymentSP() 
                    
                                   LEFT JOIN ObjectLink AS ObjectLink_Goods_IntenalSP
                                                        ON ObjectLink_Goods_IntenalSP.ObjectId = ObjectLink_Main.ChildObjectId
                                                       AND ObjectLink_Goods_IntenalSP.DescId = zc_ObjectLink_Goods_IntenalSP()
                                   LEFT JOIN Object AS Object_IntenalSP ON Object_IntenalSP.Id = ObjectLink_Goods_IntenalSP.ChildObjectId
                            
                                   LEFT JOIN ObjectDate AS ObjectDate_LastPrice
                                                        ON ObjectDate_LastPrice.ObjectId = ObjectLink_Main.ChildObjectId
                                                       AND ObjectDate_LastPrice.DescId = zc_ObjectDate_Goods_LastPrice()
    
                                   LEFT JOIN tmpGoodsBarCode ON tmpGoodsBarCode.GoodsMainId = ObjectLink_Main.ChildObjectId
                              )

        -- условия хранения
      , tmpGoods_ConditionsKeep AS (SELECT ObjectLink_Goods_ConditionsKeep.*
                                    FROM ObjectLink AS ObjectLink_Goods_ConditionsKeep 
                                    WHERE ObjectLink_Goods_ConditionsKeep.ObjectId IN (SELECT DISTINCT tmpPriceChange_All.Goodsid FROM tmpPriceChange_All)
                                      AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
                                   )
      , tmpOH_PriceChange AS (SELECT ObjectHistory_PriceChange.*
                              FROM ObjectHistory AS ObjectHistory_PriceChange
                              WHERE ObjectHistory_PriceChange.ObjectId IN (SELECT DISTINCT tmpPriceChange_All.Id FROM tmpPriceChange_All) 
                                AND ObjectHistory_PriceChange.DescId = zc_ObjectHistory_PriceChange()
                                AND ObjectHistory_PriceChange.EndDate = zc_DateEnd()
                              )
      , tmpOH_Float AS (SELECT ObjectHistoryFloat.*
                        FROM ObjectHistoryFloat
                        WHERE ObjectHistoryFloat.DescId IN (zc_ObjectHistoryFloat_PriceChange_Value()
                                                          , zc_ObjectHistoryFloat_PriceChange_PercentMarkup()
                                                          , zc_ObjectHistoryFloat_PriceChange_FixValue())
                          AND ObjectHistoryFloat.ObjectHistoryId IN (SELECT DISTINCT tmpOH_PriceChange.Id FROM tmpOH_PriceChange)
                       )

            -- Результат     
            SELECT tmpPriceChange_All.Id                                                       AS Id
                 , COALESCE (tmpPriceChange_All.PriceChange,0)                    :: TFloat    AS PriceChange
                 , COALESCE (tmpPriceChange_All.FixValue,0)                       :: TFloat    AS FixValue
                 , COALESCE (tmpPriceChange_All.PercentMarkup, 0)                 :: TFloat    AS PercentMarkup
                 , COALESCE (ObjectHistoryFloat_Value.ValueData, 0)               :: TFloat    AS PriceChange_OH
                 , COALESCE (ObjectHistoryFloat_FixValue.ValueData, 0)            :: TFloat    AS FixValue_OH
                 , COALESCE (ObjectHistoryFloat_PercentMarkup.ValueData, 0)       :: TFloat    AS PercentMarkup_OH
                 , tmpPriceChange_All.DateChange                                               AS DateChange
                 , COALESCE (ObjectHistory_PriceChange.StartDate, NULL)           :: TDateTime AS StartDate
                                          
                 , Object_Goods_View.id                      AS GoodsId
                 , Object_Goods_View.GoodsCodeInt            AS GoodsCode
                 , tmpGoodsMainParam.BarCode     :: TVarChar AS BarCode
                 , Object_Goods_View.GoodsName               AS GoodsName
                 , tmpGoodsMainParam.IntenalSPName           AS IntenalSPName
                 , Object_Goods_View.GoodsGroupName          AS GoodsGroupName
                 , Object_Goods_View.NDSKindName             AS NDSKindName
                 , Object_Goods_View.NDS                     AS NDS
                 , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar  AS ConditionsKeepName
                 , Object_Goods_View.isTop                   AS Goods_isTop
                 , Object_Goods_View.PercentMarkup           AS Goods_PercentMarkup

                 , tmpPriceChange_All.MinExpirationDate      AS MinExpirationDate
                 , tmpPriceChange_All.Remains                AS Remains
                 , (tmpPriceChange_All.Remains * COALESCE (tmpPriceChange_All.PriceChange,0)) ::TFloat AS SummaRemains
                                
                 , tmpGoodsMainParam.PriceRetSP      ::TFloat  AS PriceRetSP
                 , tmpGoodsMainParam.PriceChangeOptS ::TFloat  AS PriceOptSP
                 , tmpGoodsMainParam.PriceSP         ::TFloat  AS PriceSP
                 , tmpGoodsMainParam.PaymentSP       ::TFloat  AS PaymentSP
  
                 , tmpGoodsMainParam.isSP :: Boolean  AS isSP
                 , Object_Goods_View.isErased                                    AS isErased 
  
                 , Object_Goods_View.isClose
                 , Object_Goods_View.isFirst
                 , Object_Goods_View.isSecond
                 , CASE WHEN COALESCE(GoodsPromo.GoodsId,0) <> 0 THEN TRUE ELSE FALSE END AS isPromo
  
                 , CASE WHEN tmpGoodsMainParam.isSP = TRUE THEN 25088 --zc_Color_GreenL()
                        WHEN tmpPriceChange_All.MinExpirationDate < CURRENT_DATE  + zc_Interval_ExpirationDate() THEN zc_Color_Blue() 
                        WHEN Object_Goods_View.isTop = TRUE THEN 15993821 -- розовый
                        ELSE zc_Color_Black() 
                   END      AS Color_ExpirationDate
 
            FROM tmpPriceChange_All
               LEFT JOIN tmpGoods_All AS Object_Goods_View ON Object_Goods_View.id = tmpPriceChange_All.Goodsid

               LEFT JOIN tmpOH_PriceChange AS ObjectHistory_PriceChange
                                       ON ObjectHistory_PriceChange.ObjectId = tmpPriceChange_All.Id 
               -- получаем значения из истории значений на дату                    
               LEFT JOIN tmpOH_Float AS ObjectHistoryFloat_Value
                                     ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory_PriceChange.Id
                                    AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_PriceChange_Value()
               -- получаем значения из истории значений на дату                    
               LEFT JOIN tmpOH_Float AS ObjectHistoryFloat_FixValue
                                     ON ObjectHistoryFloat_FixValue.ObjectHistoryId = ObjectHistory_PriceChange.Id
                                    AND ObjectHistoryFloat_FixValue.DescId = zc_ObjectHistoryFloat_PriceChange_FixValue()
               -- получаем значения Страховой запас дней НТЗ из истории значений на дату    
               LEFT JOIN tmpOH_Float AS ObjectHistoryFloat_PercentMarkup
                                     ON ObjectHistoryFloat_PercentMarkup.ObjectHistoryId = ObjectHistory_PriceChange.Id
                                    AND ObjectHistoryFloat_PercentMarkup.DescId = zc_ObjectHistoryFloat_PriceChange_PercentMarkup() 
 
               LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId = Object_Goods_View.Id
 
               -- условия хранения
               LEFT JOIN tmpGoods_ConditionsKeep AS ObjectLink_Goods_ConditionsKeep 
                                                 ON ObjectLink_Goods_ConditionsKeep.ObjectId = Object_Goods_View.Id
               LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId

               -- данные из GoodsMainId
               LEFT JOIN tmpGoodsMainParam ON tmpGoodsMainParam.GoodsId = Object_Goods_View.Id
               
            WHERE (inisShowDel = True OR Object_Goods_View.isErased = False)
              AND (Object_Goods_View.Id = inGoodsId OR inGoodsId = 0)
            ORDER BY GoodsGroupName, GoodsName;
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.  Шаблий О.В.
 16.08.18         *
*/

-- тест
--select * from gpSelect_Object_PriceChange(inRetailId := 5630261 , inGoodsId := 0 , inisShowAll := 'True' , inisShowDel := 'False' ,  inSession := '3');