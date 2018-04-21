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
             , GoodsId Integer, GoodsCode Integer
             , BarCode TVarChar
             ,/* IdBarCode TVarChar,*/ GoodsName TVarChar
             , IntenalSPName TVarChar
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
             , PriceRetSP TFloat, PriceOptSP TFloat, PriceSP TFloat, PaymentSP TFloat, DiffSP2 TFloat
             , MCSValueOld TFloat
             , StartDateMCSAuto TDateTime, EndDateMCSAuto TDateTime
             , isMCSAuto Boolean, isMCSNotRecalcOld Boolean
             , isSP Boolean
             , isErased boolean
             , isClose boolean, isFirst boolean , isSecond boolean
             , isPromo boolean
             , isTop boolean, TOPDateChange TDateTime
             , PercentMarkup TFloat, PercentMarkupDateChange TDateTime
             , CheckPriceDate TDateTime
             , Color_ExpirationDate Integer
             , isCorrectMCS Boolean, isExcludeMCS Boolean
             
             , InvNumber_Full     TVarChar
             , OperDateStart      TDateTime
             , OperDateEnd        TDateTime
             , AmountDiff         TFloat
             , MarginPercentNew   TFloat
             , isChecked          Boolean
             , isError_MarginPercent Boolean
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
               ,NULL::TVarChar                   AS BarCode
               ,NULL::TVarChar                   AS GoodsName
               ,NULL::TVarChar                   AS IntenalSPName
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
               ,NULL::TFloat                     AS PriceRetSP
               ,NULL::TFloat                     AS PriceOptSP
               ,NULL::TFloat                     AS PriceSP
               ,NULL::TFloat                     AS PaymentSP
               ,NULL::TFloat                     AS DiffSP2

               ,NULL::TFloat                     AS MCSValueOld
               ,NULL::TDateTime                  AS StartDateMCSAuto
               ,NULL::TDateTime                  AS EndDateMCSAuto
               ,NULL::Boolean                    AS isMCSAuto
               ,NULL::Boolean                    AS isMCSNotRecalcOld

               ,NULL::Boolean                    AS isSP
               ,NULL::Boolean                    AS isErased
               ,NULL::Boolean                    AS isClose 
               ,NULL::Boolean                    AS isFirst 
               ,NULL::Boolean                    AS isSecond 
               ,NULL::Boolean                    AS isPromo 
               ,NULL::Boolean                    AS isTop 
               ,NULL::TDateTime                  AS TOPDateChange
               ,NULL::TFloat                     AS PercentMarkup 
               ,NULL::TDateTime                  AS PercentMarkupDateChange
               ,NULL::TDateTime                  AS CheckPriceDate
               ,zc_Color_Black()                 AS Color_ExpirationDate 
               
               ,NULL::Boolean                    AS isCorrectMCS
               ,NULL::Boolean                    AS isExcludeMCS 
               
               ,NULL:: TVarChar                  AS InvNumber_Full     
               ,NULL:: TDateTime                 AS OperDateStart      
               ,NULL:: TDateTime                 AS OperDateEnd        
               ,NULL:: TFloat                    AS AmountDiff         
               ,NULL:: TFloat                    AS MarginPercentNew   
               ,NULL:: Boolean                   AS isChecked          
               ,NULL:: Boolean                   AS isError_MarginPercent
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
                            , COALESCE(Price_MCSValueOld.ValueData,0)    ::TFloat AS MCSValueOld         
                            , MCS_StartDateMCSAuto.ValueData                      AS StartDateMCSAuto
                            , MCS_EndDateMCSAuto.ValueData                        AS EndDateMCSAuto
                            , COALESCE(Price_MCSAuto.ValueData,False)          :: Boolean   AS isMCSAuto
                            , COALESCE(Price_MCSNotRecalcOld.ValueData,False)  :: Boolean   AS isMCSNotRecalcOld

                       FROM ObjectLink AS ObjectLink_Price_Unit
                            INNER JOIN ObjectLink AS Price_Goods
                                                  ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                 AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                                 AND (Price_Goods.ChildObjectId = inGoodsId OR inGoodsId = 0)

                            -- ограничение по торговой сети
                            INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                  ON ObjectLink_Goods_Object.ObjectId = Price_Goods.ChildObjectId
                                                 AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                 AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId

                            LEFT JOIN ObjectFloat AS Price_Value
                                                  ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                 AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                            LEFT JOIN ObjectDate AS Price_DateChange
                                                 ON Price_DateChange.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Price_DateChange.DescId = zc_ObjectDate_Price_DateChange()
                            LEFT JOIN ObjectFloat AS MCS_Value
                                                  ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                 AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                            LEFT JOIN ObjectFloat AS Price_MCSValueOld
                                                  ON Price_MCSValueOld.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                 AND Price_MCSValueOld.DescId = zc_ObjectFloat_Price_MCSValueOld()

                            LEFT JOIN ObjectDate AS MCS_DateChange
                                                 ON MCS_DateChange.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND MCS_DateChange.DescId = zc_ObjectDate_Price_MCSDateChange()
                            LEFT JOIN ObjectDate AS MCS_StartDateMCSAuto
                                                 ON MCS_StartDateMCSAuto.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND MCS_StartDateMCSAuto.DescId = zc_ObjectDate_Price_StartDateMCSAuto()
                            LEFT JOIN ObjectDate AS MCS_EndDateMCSAuto
                                                 ON MCS_EndDateMCSAuto.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND MCS_EndDateMCSAuto.DescId = zc_ObjectDate_Price_EndDateMCSAuto()

                            LEFT JOIN ObjectBoolean AS MCS_isClose
                                                    ON MCS_isClose.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                   AND MCS_isClose.DescId = zc_ObjectBoolean_Price_MCSIsClose()
                            LEFT JOIN ObjectDate AS MCSIsClose_DateChange
                                                 ON MCSIsClose_DateChange.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND MCSIsClose_DateChange.DescId = zc_ObjectDate_Price_MCSIsCloseDateChange()
                            LEFT JOIN ObjectBoolean AS MCS_NotRecalc
                                                    ON MCS_NotRecalc.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                   AND MCS_NotRecalc.DescId = zc_ObjectBoolean_Price_MCSNotRecalc()
                            LEFT JOIN ObjectDate AS MCSNotRecalc_DateChange
                                                 ON MCSNotRecalc_DateChange.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND MCSNotRecalc_DateChange.DescId = zc_ObjectDate_Price_MCSNotRecalcDateChange()
                            LEFT JOIN ObjectBoolean AS Price_Fix
                                                    ON Price_Fix.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                   AND Price_Fix.DescId = zc_ObjectBoolean_Price_Fix()
                            LEFT JOIN ObjectDate AS Fix_DateChange
                                                 ON Fix_DateChange.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Fix_DateChange.DescId = zc_ObjectDate_Price_FixDateChange()
                            LEFT JOIN ObjectBoolean AS Price_Top
                                                    ON Price_Top.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                   AND Price_Top.DescId = zc_ObjectBoolean_Price_Top()
                            LEFT JOIN ObjectDate AS Price_TOPDateChange
                                                 ON Price_TOPDateChange.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Price_TOPDateChange.DescId = zc_ObjectDate_Price_TOPDateChange()     

                            LEFT JOIN ObjectFloat AS Price_PercentMarkup
                                                  ON Price_PercentMarkup.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                 AND Price_PercentMarkup.DescId = zc_ObjectFloat_Price_PercentMarkup()
                            LEFT JOIN ObjectDate AS Price_PercentMarkupDateChange
                                                 ON Price_PercentMarkupDateChange.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Price_PercentMarkupDateChange.DescId = zc_ObjectDate_Price_PercentMarkupDateChange()    

                            LEFT JOIN ObjectBoolean AS Price_MCSAuto
                                                    ON Price_MCSAuto.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                   AND Price_MCSAuto.DescId = zc_ObjectBoolean_Price_MCSAuto()
                            LEFT JOIN ObjectBoolean AS Price_MCSNotRecalcOld
                                                    ON Price_MCSNotRecalcOld.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                   AND Price_MCSNotRecalcOld.DescId = zc_ObjectBoolean_Price_MCSNotRecalcOld()
                       WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                         AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
                       )
   -- Выбираем данные из документов "Категории наценки (САУЦ)"
   , tmpMarginCategory AS (SELECT tmp.MovementId
                                , '№ ' ||tmp.InvNumber||' от ' ||TO_CHAR(tmp.OperDate, 'DD.MM.YYYY')   AS InvNumber_Full
                                , tmp.OperDate
                                , tmp.OperDateStart
                                , tmp.OperDateEnd
                                              
                                , tmp.GoodsId
                                , tmp.GoodsCode
                                , tmp.GoodsName
                     
                                , tmp.AmountDiff
                                , tmp.MarginPercent
                                , tmp.MarginPercentNew
                                , tmp.Price
                                , tmp.isChecked
                           FROM lpSelect_MarginCategory_Goods (inUnitId:= inUnitId , inGoodsId:= 0, inOperDate:= CURRENT_DATE , inSession:= inSession) AS tmp
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
                 tmpPrice_View.Id                                                   AS Id
               , COALESCE (tmpPrice_View.Price,0)                         :: TFloat AS Price
               , COALESCE (tmpPrice_View.MCSValue,0)                      :: TFloat AS MCSValue
               , COALESCE (ObjectHistoryFloat_MCSPeriod.ValueData, 0)     :: TFloat AS MCSPeriod
               , COALESCE (ObjectHistoryFloat_MCSDay.ValueData, 0)        :: TFloat AS MCSDay
               , COALESCE (ObjectHistory_Price.StartDate, NULL /*zc_DateStart()*/) :: TDateTime AS StartDate
                              
               , Object_Goods_View.id                            AS GoodsId
               , Object_Goods_View.GoodsCodeInt                  AS GoodsCode
--               , zfFormat_BarCode(zc_BarCodePref_Object(), tmpPrice_View.Id) ::TVarChar  AS IdBarCode
               , COALESCE (tmpGoodsBarCode.BarCode, '')  :: TVarChar AS BarCode
               , Object_Goods_View.GoodsName                     AS GoodsName
               , Object_IntenalSP.ValueData                      AS IntenalSPName
               , Object_Goods_View.GoodsGroupName                AS GoodsGroupName
               , Object_Goods_View.NDSKindName                   AS NDSKindName
               , Object_Goods_View.NDS                           AS NDS
               , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar  AS ConditionsKeepName
               , Object_Goods_View.isTop                         AS Goods_isTop
               , Object_Goods_View.PercentMarkup                 AS Goods_PercentMarkup
               , tmpPrice_View.DateChange                        AS DateChange
               , tmpPrice_View.MCSDateChange                     AS MCSDateChange
               , COALESCE(tmpPrice_View.MCSIsClose,False)        AS MCSIsClose
               , tmpPrice_View.MCSIsCloseDateChange              AS MCSIsCloseDateChange
               , COALESCE(tmpPrice_View.MCSNotRecalc,False)      AS MCSNotRecalc
               , tmpPrice_View.MCSNotRecalcDateChange            AS MCSNotRecalcDateChange
               , COALESCE(tmpPrice_View.Fix,False)               AS Fix

               , tmpPrice_View.FixDateChange                     AS FixDateChange
               , Object_Remains.MinExpirationDate                AS MinExpirationDate   --SelectMinPrice_AllGoods.MinExpirationDate AS MinExpirationDate

               , Object_Remains.Remains                          AS Remains
               , (Object_Remains.Remains * COALESCE (tmpPrice_View.Price,0)) ::TFloat AS SummaRemains
               
               , CASE WHEN COALESCE (Object_Remains.Remains, 0) > COALESCE (tmpPrice_View.MCSValue, 0) THEN COALESCE (Object_Remains.Remains, 0) - COALESCE (tmpPrice_View.MCSValue, 0) ELSE 0 END :: TFloat AS RemainsNotMCS
               , CASE WHEN COALESCE (Object_Remains.Remains, 0) > COALESCE (tmpPrice_View.MCSValue, 0) THEN (COALESCE (Object_Remains.Remains, 0) - COALESCE (tmpPrice_View.MCSValue, 0)) * COALESCE (tmpPrice_View.Price, 0) ELSE 0 END :: TFloat AS SummaNotMCS

               , COALESCE (ObjectFloat_Goods_PriceRetSP.ValueData,0) ::TFloat  AS PriceRetSP
               , COALESCE (ObjectFloat_Goods_PriceOptSP.ValueData,0) ::TFloat  AS PriceOptSP
              /* , CASE WHEN COALESCE (tmpPrice_View.Price,0) < COALESCE (ObjectFloat_Goods_PriceSP.ValueData,0) 
                           THEN COALESCE (tmpPrice_View.Price,0)
                      ELSE
                          ::TFloat  AS PriceSP*/
                          
               , CASE WHEN COALESCE (tmpPrice_View.Price,0) < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)
                      THEN COALESCE (tmpPrice_View.Price,0) -- по нашей цене, т.к. она меньше чем цена возмещения

                 ELSE

                     CASE WHEN COALESCE (ObjectFloat_Goods_PaymentSP.ValueData, 0) = 0
                          THEN 0 -- по 0, т.к. цена доплаты = 0
    
                     WHEN COALESCE (tmpPrice_View.Price,0) < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)
                          THEN 0 -- по 0, т.к. наша меньше чем цена возмещения
    
                     WHEN COALESCE (tmpPrice_View.Price,0) < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0)
                       AND 0 > COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                             - (COALESCE (CEIL (ObjectFloat_Goods_PriceSP.ValueData * 100) / 100, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) - COALESCE (tmpPrice_View.Price,0) 
                               ) -- разница с ценой возмещения и "округлили в большую"
                          THEN 0
    
                     WHEN COALESCE (tmpPrice_View.Price,0) < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0)
                          THEN COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                             - (COALESCE (CEIL (ObjectFloat_Goods_PriceSP.ValueData * 100) / 100, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) - COALESCE (tmpPrice_View.Price,0) 
                               ) -- разница с ценой возмещения и "округлили в большую"
    
                     ELSE COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- иначе всегда цена доплаты "округлили в меньшую"
                     
                     END
                + COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)
     
                 END :: TFloat  AS PriceSP
            
                  --, COALESCE (ObjectFloat_Goods_PaymentSP.ValueData,0)  ::TFloat  AS PaymentSP
               , CASE WHEN COALESCE (ObjectFloat_Goods_PaymentSP.ValueData, 0) = 0
                         THEN 0 -- по 0, т.к. цена доплаты = 0
   
                    WHEN COALESCE (tmpPrice_View.Price,0) < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)
                         THEN 0 -- по 0, т.к. наша меньше чем цена возмещения
   
                    -- WHEN COALESCE (tmpPrice_View.Price,0) < COALESCE (ObjectFloat_Goods_PaymentSP.ValueData, 0)
                    --      THEN COALESCE (tmpPrice_View.Price,0) -- по нашей цене, т.к. она меньше чем цена доплаты
   
                    WHEN COALESCE (tmpPrice_View.Price,0) < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0)
                      AND 0 > COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                            - (COALESCE (CEIL (ObjectFloat_Goods_PriceSP.ValueData * 100) / 100, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) - COALESCE (tmpPrice_View.Price,0) 
                              ) -- разница с ценой возмещения и "округлили в большую"
                         THEN 0
   
                    WHEN COALESCE (tmpPrice_View.Price,0) < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0)
                         THEN COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                            - (COALESCE (CEIL (ObjectFloat_Goods_PriceSP.ValueData * 100) / 100, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) - COALESCE (tmpPrice_View.Price,0) 
                              ) -- разница с ценой возмещения и "округлили в большую"
   
                    ELSE COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- иначе всегда цена доплаты "округлили в меньшую"
                    
                  END   ::TFloat  AS PaymentSP
                  
                   -- из gpSelect_CashRemains_ver2
               ,  (CASE WHEN COALESCE (tmpPrice_View.Price,0) < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)
                             THEN COALESCE (tmpPrice_View.Price,0) -- по нашей цене, т.к. она меньше чем цена возмещения
       
                        ELSE
       
                   CASE WHEN COALESCE (ObjectFloat_Goods_PaymentSP.ValueData, 0) = 0
                             THEN 0 -- по 0, т.к. цена доплаты = 0
       
                        WHEN COALESCE (tmpPrice_View.Price,0) < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)
                             THEN 0 -- по 0, т.к. наша меньше чем цена возмещения
       
                        -- WHEN COALESCE (tmpPrice_View.Price,0) < COALESCE (ObjectFloat_Goods_PaymentSP.ValueData, 0)
                        --      THEN COALESCE (tmpPrice_View.Price,0) -- по нашей цене, т.к. она меньше чем цена доплаты
       
                        WHEN COALESCE (tmpPrice_View.Price,0) < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0)
                          AND 0 > COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                                - (COALESCE (CEIL (ObjectFloat_Goods_PriceSP.ValueData * 100) / 100, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) - COALESCE (tmpPrice_View.Price,0)
                                  ) -- разница с ценой возмещения и "округлили в большую"
                             THEN 0
       
                        WHEN COALESCE (tmpPrice_View.Price,0) < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0)
                             THEN COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                                - (COALESCE (CEIL (ObjectFloat_Goods_PriceSP.ValueData * 100) / 100, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) - COALESCE (tmpPrice_View.Price,0)
                                  ) -- разница с ценой возмещения и "округлили в большую"
       
                        ELSE COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- иначе всегда цена доплаты "округлили в меньшую"
       
                   END
                 + COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)
       
                   END
       
                 - CASE WHEN COALESCE (ObjectFloat_Goods_PaymentSP.ValueData, 0) = 0
                             THEN 0 -- по 0, т.к. цена доплаты = 0
       
                        WHEN COALESCE (tmpPrice_View.Price,0) < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)
                             THEN 0 -- по 0, т.к. наша меньше чем цена возмещения
       
                        -- WHEN COALESCE (tmpPrice_View.Price,0) < COALESCE (ObjectFloat_Goods_PaymentSP.ValueData, 0)
                        --      THEN COALESCE (tmpPrice_View.Price,0) -- по нашей цене, т.к. она меньше чем цена доплаты
       
                        WHEN COALESCE (tmpPrice_View.Price,0) < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0)
                          AND 0 > COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                                - (COALESCE (CEIL (ObjectFloat_Goods_PriceSP.ValueData * 100) / 100, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) - COALESCE (tmpPrice_View.Price,0)
                                  ) -- разница с ценой возмещения и "округлили в большую"
                             THEN 0
       
                        WHEN COALESCE (tmpPrice_View.Price,0) < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0)
                             THEN COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                                - (COALESCE (CEIL (ObjectFloat_Goods_PriceSP.ValueData * 100) / 100, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) - COALESCE (tmpPrice_View.Price,0)
                                  ) -- разница с ценой возмещения и "округлили в большую"
       
                        ELSE COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- иначе всегда цена доплаты "округлили в меньшую"
       
                   END
                  ) :: TFloat AS DiffSP2

               , tmpPrice_View.MCSValueOld
               , tmpPrice_View.StartDateMCSAuto
               , tmpPrice_View.EndDateMCSAuto
               , tmpPrice_View.isMCSAuto                           :: Boolean
               , tmpPrice_View.isMCSNotRecalcOld

               , COALESCE (ObjectBoolean_Goods_SP.ValueData,False) :: Boolean  AS isSP
               , Object_Goods_View.isErased                      AS isErased 

               , Object_Goods_View.isClose
               , Object_Goods_View.isFirst
               , Object_Goods_View.isSecond
               , CASE WHEN COALESCE(GoodsPromo.GoodsId,0) <> 0 THEN TRUE ELSE FALSE END AS isPromo

               , tmpPrice_View.isTop                   AS isTop
               , tmpPrice_View.TopDateChange           AS TopDateChange

               , tmpPrice_View.PercentMarkup           AS PercentMarkup
               , tmpPrice_View.PercentMarkupDateChange AS PercentMarkupDateChange
               , ObjectDate_CheckPrice.ValueData       AS CheckPriceDate
               
               , CASE WHEN ObjectBoolean_Goods_SP.ValueData = TRUE THEN 25088 --zc_Color_GreenL()
                      WHEN Object_Remains.MinExpirationDate < CURRENT_DATE  + zc_Interval_ExpirationDate() THEN zc_Color_Blue() 
                      WHEN (tmpPrice_View.isTop = TRUE OR Object_Goods_View.isTop = TRUE) THEN 15993821 -- розовый
                      ELSE zc_Color_Black() 
                 END     AS Color_ExpirationDate                --vbAVGDateEnd

               , CASE WHEN DATE_PART ('DAY', (CURRENT_DATE - ObjectDate_LastPrice.ValueData)) <= 30 
                       AND Object_Remains.Remains = 0 
                       AND COALESCE (tmpPrice_View.MCSValue,0) = 0
                      THEN TRUE
                      ELSE FALSE
                 END                        ::Boolean  AS isCorrectMCS
                 
               , CASE WHEN DATE_PART ('DAY', (CURRENT_DATE - ObjectDate_CheckPrice.ValueData)) <= 11  THEN TRUE
                      WHEN COALESCE (ObjectDate_CheckPrice.ValueData, NULL) = NULL THEN FALSE
                      ELSE FALSE
                 END                        ::Boolean  AS isExcludeMCS 

               , tmpMarginCategory.InvNumber_Full     :: TVarChar
               , tmpMarginCategory.OperDateStart      :: TDateTime
               , tmpMarginCategory.OperDateEnd        :: TDateTime
                             
               , tmpMarginCategory.AmountDiff         :: TFloat
               , tmpMarginCategory.MarginPercentNew   :: TFloat
               , COALESCE (tmpMarginCategory.isChecked, FALSE)  :: Boolean AS isChecked
               , CASE WHEN tmpMarginCategory.MarginPercentNew <> tmpPrice_View.PercentMarkup AND tmpPrice_View.isTop = FALSE THEN TRUE ELSE FALSE END AS isError_MarginPercent

            FROM Object_Goods_View
                INNER JOIN ObjectLink ON ObjectLink.ObjectId = Object_Goods_View.Id 
                                     AND ObjectLink.ChildObjectId = vbObjectId
                LEFT OUTER JOIN tmpPrice_View ON tmpPrice_View.Goodsid = Object_Goods_View.Id

                LEFT OUTER JOIN tmpRemeins AS Object_Remains
                                           ON Object_Remains.ObjectId = Object_Goods_View.Id
   
                LEFT JOIN ObjectDate AS ObjectDate_CheckPrice
                                     ON ObjectDate_CheckPrice.ObjectId = tmpPrice_View.Id
                                    AND ObjectDate_CheckPrice.DescId = zc_ObjectDate_Price_CheckPrice()

                -- получаем значения цены и НТЗ из истории значений на дату                                                           
                LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                        ON ObjectHistory_Price.ObjectId = tmpPrice_View.Id 
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
        
               LEFT JOIN tmpMarginCategory ON tmpMarginCategory.GoodsId = Object_Goods_View.Id
               
               LEFT JOIN tmpGoodsBarCode ON tmpGoodsBarCode.GoodsMainId = ObjectLink_Main.ChildObjectId
               
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
                               , COALESCE(Price_MCSValueOld.ValueData,0)    ::TFloat AS MCSValueOld         
                               , MCS_StartDateMCSAuto.ValueData                      AS StartDateMCSAuto
                               , MCS_EndDateMCSAuto.ValueData                        AS EndDateMCSAuto
                               , COALESCE(Price_MCSAuto.ValueData,False)          :: Boolean   AS isMCSAuto
                               , COALESCE(Price_MCSNotRecalcOld.ValueData,False)  :: Boolean   AS isMCSNotRecalcOld
                               , ObjectDate_CheckPrice.ValueData                     AS CheckPrice

                          FROM ObjectLink AS ObjectLink_Price_Unit
                               INNER JOIN ObjectLink AS Price_Goods
                                                     ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                    AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                                    AND (Price_Goods.ChildObjectId = inGoodsId OR inGoodsId = 0)
   
                               -- ограничение по торговой сети
                               INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                     ON ObjectLink_Goods_Object.ObjectId = Price_Goods.ChildObjectId
                                                    AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                    AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId

                               LEFT JOIN ObjectFloat AS Price_Value
                                                     ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                    AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                               LEFT JOIN ObjectDate AS Price_DateChange
                                                    ON Price_DateChange.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                   AND Price_DateChange.DescId = zc_ObjectDate_Price_DateChange()
                               LEFT JOIN ObjectFloat AS MCS_Value
                                                     ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                    AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                               LEFT JOIN ObjectFloat AS Price_MCSValueOld
                                                     ON Price_MCSValueOld.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                    AND Price_MCSValueOld.DescId = zc_ObjectFloat_Price_MCSValueOld()
   
                               LEFT JOIN ObjectDate AS MCS_DateChange
                                                    ON MCS_DateChange.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                   AND MCS_DateChange.DescId = zc_ObjectDate_Price_MCSDateChange()
                               LEFT JOIN ObjectDate AS MCS_StartDateMCSAuto
                                                    ON MCS_StartDateMCSAuto.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                   AND MCS_StartDateMCSAuto.DescId = zc_ObjectDate_Price_StartDateMCSAuto()
                               LEFT JOIN ObjectDate AS MCS_EndDateMCSAuto
                                                    ON MCS_EndDateMCSAuto.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                   AND MCS_EndDateMCSAuto.DescId = zc_ObjectDate_Price_EndDateMCSAuto()
   
                               LEFT JOIN ObjectDate AS ObjectDate_CheckPrice
                                                    ON ObjectDate_CheckPrice.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                   AND ObjectDate_CheckPrice.DescId = zc_ObjectDate_Price_CheckPrice()
   
                               LEFT JOIN ObjectBoolean AS MCS_isClose
                                                       ON MCS_isClose.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                      AND MCS_isClose.DescId = zc_ObjectBoolean_Price_MCSIsClose()
                               LEFT JOIN ObjectDate AS MCSIsClose_DateChange
                                                    ON MCSIsClose_DateChange.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                   AND MCSIsClose_DateChange.DescId = zc_ObjectDate_Price_MCSIsCloseDateChange()
                               LEFT JOIN ObjectBoolean AS MCS_NotRecalc
                                                       ON MCS_NotRecalc.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                      AND MCS_NotRecalc.DescId = zc_ObjectBoolean_Price_MCSNotRecalc()
                               LEFT JOIN ObjectDate AS MCSNotRecalc_DateChange
                                                    ON MCSNotRecalc_DateChange.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                   AND MCSNotRecalc_DateChange.DescId = zc_ObjectDate_Price_MCSNotRecalcDateChange()
                               LEFT JOIN ObjectBoolean AS Price_Fix
                                                       ON Price_Fix.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                      AND Price_Fix.DescId = zc_ObjectBoolean_Price_Fix()
                               LEFT JOIN ObjectDate AS Fix_DateChange
                                                    ON Fix_DateChange.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                   AND Fix_DateChange.DescId = zc_ObjectDate_Price_FixDateChange()
                               LEFT JOIN ObjectBoolean AS Price_Top
                                                       ON Price_Top.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                      AND Price_Top.DescId = zc_ObjectBoolean_Price_Top()
                               LEFT JOIN ObjectDate AS Price_TOPDateChange
                                                    ON Price_TOPDateChange.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                   AND Price_TOPDateChange.DescId = zc_ObjectDate_Price_TOPDateChange()     
   
                               LEFT JOIN ObjectFloat AS Price_PercentMarkup
                                                     ON Price_PercentMarkup.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                    AND Price_PercentMarkup.DescId = zc_ObjectFloat_Price_PercentMarkup()
                               LEFT JOIN ObjectDate AS Price_PercentMarkupDateChange
                                                    ON Price_PercentMarkupDateChange.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                   AND Price_PercentMarkupDateChange.DescId = zc_ObjectDate_Price_PercentMarkupDateChange()    
   
                               LEFT JOIN ObjectBoolean AS Price_MCSAuto
                                                       ON Price_MCSAuto.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                      AND Price_MCSAuto.DescId = zc_ObjectBoolean_Price_MCSAuto()
                               LEFT JOIN ObjectBoolean AS Price_MCSNotRecalcOld
                                                       ON Price_MCSNotRecalcOld.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                      AND Price_MCSNotRecalcOld.DescId = zc_ObjectBoolean_Price_MCSNotRecalcOld()

                          WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                            AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
                          )
      -- объединяем товары прайса с товарами, которые есть на остатке. (если цена = 0, а остаток есть нужно показать такие товары)
      , tmpPrice_All AS (SELECT tmpPrice.Id
                              , tmpPrice.Price 
                              , tmpPrice.MCSValue 
                              , COALESCE (tmpPrice.GoodsId, tmpRemeins.ObjectId) AS GoodsId
                              , tmpPrice.DateChange 
                              , tmpPrice.MCSDateChange 
                              , COALESCE(tmpPrice.MCSIsClose, False)             AS MCSIsClose
                              , tmpPrice.MCSIsCloseDateChange                    
                              , COALESCE(tmpPrice.MCSNotRecalc, False)           AS MCSNotRecalc 
                              , tmpPrice.MCSNotRecalcDateChange                  
                              , COALESCE(tmpPrice.Fix, False)                    AS Fix
                              , tmpPrice.FixDateChange                           
                              , COALESCE(tmpPrice.isTop, False)                  AS isTop   
                              , tmpPrice.TopDateChange 
                              , tmpPrice.PercentMarkup 
                              , tmpPrice.PercentMarkupDateChange 
                              , tmpPrice.MCSValueOld         
                              , tmpPrice.StartDateMCSAuto
                              , tmpPrice.EndDateMCSAuto
                              , COALESCE(tmpPrice.isMCSAuto, False)          :: Boolean   AS isMCSAuto
                              , COALESCE(tmpPrice.isMCSNotRecalcOld, False)  :: Boolean   AS isMCSNotRecalcOld
                              , tmpPrice.CheckPrice
                              , tmpRemeins.Remains
                              , tmpRemeins.MinExpirationDate 
                        FROM tmpPrice_View AS tmpPrice
                             FULL JOIN tmpRemeins ON tmpRemeins.ObjectId = tmpPrice.GoodsId
                        )
      -- Выбираем данные из документов "Категории наценки (САУЦ)"
      , tmpMarginCategory AS (SELECT tmp.MovementId
                                   , '№ ' ||tmp.InvNumber||' от ' ||TO_CHAR(tmp.OperDate, 'DD.MM.YYYY')   AS InvNumber_Full
                                   , tmp.OperDate
                                   , tmp.OperDateStart
                                   , tmp.OperDateEnd
                                                 
                                   , tmp.GoodsId
                                   , tmp.GoodsCode
                                   , tmp.GoodsName
                        
                                   , tmp.AmountDiff
                                   , tmp.MarginPercent
                                   , tmp.MarginPercentNew
                                   , tmp.Price
                                   , tmp.isChecked
                              FROM lpSelect_MarginCategory_Goods (inUnitId:= inUnitId , inGoodsId:= 0, inOperDate:= CURRENT_DATE , inSession:= inSession) AS tmp
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
                       AND ObjectLink_Goods_Object.ObjectId IN (SELECT DISTINCT tmpPrice_All.Goodsid FROM tmpPrice_All)
                     )  
      , tmpGoods_All AS (SELECT  Object_Goods.Id                AS Id
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
                         
                              LEFT JOIN Object AS Object_Goods 
                                               ON Object_Goods.Id = tmpGoods.GoodsId 

                              LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                   ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpGoods.GoodsId
                                                  AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()

                              LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
        
                              LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                                   ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
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
                         
                              LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_PercentMarkup
                                                     ON ObjectFloat_Goods_PercentMarkup.ObjectId = tmpGoods.GoodsId 
                                                    AND ObjectFloat_Goods_PercentMarkup.DescId = zc_ObjectFloat_Goods_PercentMarkup()  
                          )
                    

            -- Результат     
            SELECT
                 tmpPrice_All.Id                                                       AS Id
               , COALESCE (tmpPrice_All.Price,0)                          :: TFloat    AS Price
               , COALESCE (tmpPrice_All.MCSValue,0)                       :: TFloat    AS MCSValue
               , COALESCE (ObjectHistoryFloat_MCSPeriod.ValueData, 0)     :: TFloat    AS MCSPeriod
               , COALESCE (ObjectHistoryFloat_MCSDay.ValueData, 0)        :: TFloat    AS MCSDay
               , COALESCE (ObjectHistory_Price.StartDate, NULL /*zc_DateStart()*/) :: TDateTime AS StartDate
                                        
               , Object_Goods_View.id                      AS GoodsId
               , Object_Goods_View.GoodsCodeInt            AS GoodsCode
--               , zfFormat_BarCode(zc_BarCodePref_Object(), tmpPrice_All.Id) ::TVarChar AS IdBarCode
               , COALESCE (tmpGoodsBarCode.BarCode, '')  :: TVarChar AS BarCode
               , Object_Goods_View.GoodsName               AS GoodsName
               , Object_IntenalSP.ValueData                AS IntenalSPName
               , Object_Goods_View.GoodsGroupName          AS GoodsGroupName
               , Object_Goods_View.NDSKindName             AS NDSKindName
               , Object_Goods_View.NDS                     AS NDS
               , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar  AS ConditionsKeepName
               , Object_Goods_View.isTop                   AS Goods_isTop
               , Object_Goods_View.PercentMarkup           AS Goods_PercentMarkup
               , tmpPrice_All.DateChange                   AS DateChange
               , tmpPrice_All.MCSDateChange                AS MCSDateChange
               , tmpPrice_All.MCSIsClose                   AS MCSIsClose
               , tmpPrice_All.MCSIsCloseDateChange         AS MCSIsCloseDateChange
               , tmpPrice_All.MCSNotRecalc                 AS MCSNotRecalc
               , tmpPrice_All.MCSNotRecalcDateChange       AS MCSNotRecalcDateChange
               , tmpPrice_All.Fix                          AS Fix
               , tmpPrice_All.FixDateChange                AS FixDateChange
               , tmpPrice_All.MinExpirationDate            AS MinExpirationDate   --, CASE WHEN inGoodsId = 0 THEN SelectMinPrice_AllGoods.MinExpirationDate ELSE SelectMinPrice_List.PartionGoodsDate END AS MinExpirationDate
               , tmpPrice_All.Remains                      AS Remains
               , (tmpPrice_All.Remains * COALESCE (tmpPrice_All.Price,0)) ::TFloat AS SummaRemains

               , CASE WHEN COALESCE (tmpPrice_All.Remains, 0) > COALESCE (tmpPrice_All.MCSValue, 0) THEN COALESCE (tmpPrice_All.Remains, 0) - COALESCE (tmpPrice_All.MCSValue, 0) ELSE 0 END :: TFloat AS RemainsNotMCS
               , CASE WHEN COALESCE (tmpPrice_All.Remains, 0) > COALESCE (tmpPrice_All.MCSValue, 0) THEN (COALESCE (tmpPrice_All.Remains, 0) - COALESCE (tmpPrice_All.MCSValue, 0)) * COALESCE (tmpPrice_All.Price, 0) ELSE 0 END :: TFloat AS SummaNotMCS
                              
               , COALESCE (ObjectFloat_Goods_PriceRetSP.ValueData,0) ::TFloat  AS PriceRetSP
               , COALESCE (ObjectFloat_Goods_PriceOptSP.ValueData,0) ::TFloat  AS PriceOptSP
              -- , COALESCE (ObjectFloat_Goods_PriceSP.ValueData,0)    ::TFloat  AS PriceSP
              -- , COALESCE (ObjectFloat_Goods_PaymentSP.ValueData,0)  ::TFloat  AS PaymentSP

               , CASE WHEN COALESCE (tmpPrice_All.Price,0) < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)
                      THEN COALESCE (tmpPrice_All.Price,0) -- по нашей цене, т.к. она меньше чем цена возмещения

                 ELSE

                 CASE WHEN COALESCE (ObjectFloat_Goods_PaymentSP.ValueData, 0) = 0
                      THEN 0 -- по 0, т.к. цена доплаты = 0

                 WHEN COALESCE (tmpPrice_All.Price,0) < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)
                      THEN 0 -- по 0, т.к. наша меньше чем цена возмещения

                 WHEN COALESCE (tmpPrice_All.Price,0) < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0)
                   AND 0 > COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                         - (COALESCE (CEIL (ObjectFloat_Goods_PriceSP.ValueData * 100) / 100, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) - COALESCE (tmpPrice_All.Price,0) 
                           ) -- разница с ценой возмещения и "округлили в большую"
                      THEN 0

                 WHEN COALESCE (tmpPrice_All.Price,0) < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0)
                      THEN COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                         - (COALESCE (CEIL (ObjectFloat_Goods_PriceSP.ValueData * 100) / 100, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) - COALESCE (tmpPrice_All.Price,0) 
                           ) -- разница с ценой возмещения и "округлили в большую"

                 ELSE COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- иначе всегда цена доплаты "округлили в меньшую"
                 
            END
          + COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)

            END :: TFloat  AS PriceSP
               --, COALESCE (ObjectFloat_Goods_PaymentSP.ValueData,0)  ::TFloat  AS PaymentSP
            , CASE WHEN COALESCE (ObjectFloat_Goods_PaymentSP.ValueData, 0) = 0
                      THEN 0 -- по 0, т.к. цена доплаты = 0

                 WHEN COALESCE (tmpPrice_All.Price,0) < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)
                      THEN 0 -- по 0, т.к. наша меньше чем цена возмещения

                 -- WHEN COALESCE (tmpPrice_All.Price,0) < COALESCE (ObjectFloat_Goods_PaymentSP.ValueData, 0)
                 --      THEN COALESCE (tmpPrice_All.Price,0) -- по нашей цене, т.к. она меньше чем цена доплаты

                 WHEN COALESCE (tmpPrice_All.Price,0) < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0)
                   AND 0 > COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                         - (COALESCE (CEIL (ObjectFloat_Goods_PriceSP.ValueData * 100) / 100, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) - COALESCE (tmpPrice_All.Price,0) 
                           ) -- разница с ценой возмещения и "округлили в большую"
                      THEN 0

                 WHEN COALESCE (tmpPrice_All.Price,0) < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0)
                      THEN COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                         - (COALESCE (CEIL (ObjectFloat_Goods_PriceSP.ValueData * 100) / 100, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) - COALESCE (tmpPrice_All.Price,0) 
                           ) -- разница с ценой возмещения и "округлили в большую"

                 ELSE COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- иначе всегда цена доплаты "округлили в меньшую"
                 
               END   ::TFloat  AS PaymentSP

                   -- из gpSelect_CashRemains_ver2
               ,  (CASE WHEN COALESCE (tmpPrice_All.Price,0) < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)
                             THEN COALESCE (tmpPrice_All.Price,0) -- по нашей цене, т.к. она меньше чем цена возмещения
       
                        ELSE
       
                   CASE WHEN COALESCE (ObjectFloat_Goods_PaymentSP.ValueData, 0) = 0
                             THEN 0 -- по 0, т.к. цена доплаты = 0
       
                        WHEN COALESCE (tmpPrice_All.Price,0) < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)
                             THEN 0 -- по 0, т.к. наша меньше чем цена возмещения
       
                        -- WHEN COALESCE (tmpPrice_All.Price,0) < COALESCE (ObjectFloat_Goods_PaymentSP.ValueData, 0)
                        --      THEN COALESCE (tmpPrice_All.Price,0) -- по нашей цене, т.к. она меньше чем цена доплаты
       
                        WHEN COALESCE (tmpPrice_All.Price,0) < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0)
                          AND 0 > COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                                - (COALESCE (CEIL (ObjectFloat_Goods_PriceSP.ValueData * 100) / 100, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) - COALESCE (tmpPrice_All.Price,0)
                                  ) -- разница с ценой возмещения и "округлили в большую"
                             THEN 0
       
                        WHEN COALESCE (tmpPrice_All.Price,0) < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0)
                             THEN COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                                - (COALESCE (CEIL (ObjectFloat_Goods_PriceSP.ValueData * 100) / 100, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) - COALESCE (tmpPrice_All.Price,0)
                                  ) -- разница с ценой возмещения и "округлили в большую"
       
                        ELSE COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- иначе всегда цена доплаты "округлили в меньшую"
       
                   END
                 + COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)
       
                   END
       
                 - CASE WHEN COALESCE (ObjectFloat_Goods_PaymentSP.ValueData, 0) = 0
                             THEN 0 -- по 0, т.к. цена доплаты = 0
       
                        WHEN COALESCE (tmpPrice_All.Price,0) < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0)
                             THEN 0 -- по 0, т.к. наша меньше чем цена возмещения
       
                        -- WHEN COALESCE (tmpPrice_All.Price,0) < COALESCE (ObjectFloat_Goods_PaymentSP.ValueData, 0)
                        --      THEN COALESCE (tmpPrice_All.Price,0) -- по нашей цене, т.к. она меньше чем цена доплаты
       
                        WHEN COALESCE (tmpPrice_All.Price,0) < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0)
                          AND 0 > COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                                - (COALESCE (CEIL (ObjectFloat_Goods_PriceSP.ValueData * 100) / 100, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) - COALESCE (tmpPrice_All.Price,0)
                                  ) -- разница с ценой возмещения и "округлили в большую"
                             THEN 0
       
                        WHEN COALESCE (tmpPrice_All.Price,0) < COALESCE (ObjectFloat_Goods_PriceSP.ValueData, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0)
                             THEN COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                                - (COALESCE (CEIL (ObjectFloat_Goods_PriceSP.ValueData * 100) / 100, 0) + COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) - COALESCE (tmpPrice_All.Price,0)
                                  ) -- разница с ценой возмещения и "округлили в большую"
       
                        ELSE COALESCE (FLOOR (ObjectFloat_Goods_PaymentSP.ValueData * 100) / 100, 0) -- иначе всегда цена доплаты "округлили в меньшую"
       
                   END
                  ) :: TFloat AS DiffSP2

               , tmpPrice_All.MCSValueOld
               , tmpPrice_All.StartDateMCSAuto
               , tmpPrice_All.EndDateMCSAuto
               , tmpPrice_All.isMCSAuto                            :: Boolean
               , tmpPrice_All.isMCSNotRecalcOld

               , COALESCE (ObjectBoolean_Goods_SP.ValueData,False) :: Boolean  AS isSP
               , Object_Goods_View.isErased                                    AS isErased 

               , Object_Goods_View.isClose
               , Object_Goods_View.isFirst
               , Object_Goods_View.isSecond
               , CASE WHEN COALESCE(GoodsPromo.GoodsId,0) <> 0 THEN TRUE ELSE FALSE END AS isPromo

               , tmpPrice_All.isTop                    AS isTop
               , tmpPrice_All.TopDateChange            AS TopDateChange

               , tmpPrice_All.PercentMarkup            AS PercentMarkup
               , tmpPrice_All.PercentMarkupDateChange  AS PercentMarkupDateChange
               , tmpPrice_All.CheckPrice               AS CheckPriceDate

               , CASE WHEN ObjectBoolean_Goods_SP.ValueData = TRUE THEN 25088 --zc_Color_GreenL()
                      WHEN tmpPrice_All.MinExpirationDate < CURRENT_DATE  + zc_Interval_ExpirationDate() THEN zc_Color_Blue() 
                      WHEN (tmpPrice_All.isTop = TRUE OR Object_Goods_View.isTop = TRUE) THEN 15993821 -- розовый
                      ELSE zc_Color_Black() 
                 END      AS Color_ExpirationDate                --vbAVGDateEnd
               
               , CASE WHEN DATE_PART ('DAY', (CURRENT_DATE - ObjectDate_LastPrice.ValueData)) <= 30 
                       AND tmpPrice_All.Remains = 0 
                       AND COALESCE (tmpPrice_All.MCSValue,0) = 0
                      THEN TRUE
                      ELSE FALSE
                 END                        ::Boolean  AS isCorrectMCS
                 
               , CASE WHEN DATE_PART ('DAY', (CURRENT_DATE - tmpPrice_All.CheckPrice)) <= 11  THEN TRUE
                      WHEN COALESCE (tmpPrice_All.CheckPrice, NULL) = NULL THEN FALSE
                      ELSE FALSE
                 END                        ::Boolean  AS isExcludeMCS 

               , tmpMarginCategory.InvNumber_Full     :: TVarChar
               , tmpMarginCategory.OperDateStart      :: TDateTime
               , tmpMarginCategory.OperDateEnd        :: TDateTime
                             
               , tmpMarginCategory.AmountDiff         :: TFloat
               , tmpMarginCategory.MarginPercentNew   :: TFloat
               , COALESCE (tmpMarginCategory.isChecked, FALSE)  :: Boolean AS isChecked
               , CASE WHEN tmpMarginCategory.MarginPercentNew <> tmpPrice_All.PercentMarkup AND tmpPrice_All.isTop = FALSE THEN TRUE ELSE FALSE END AS isError_MarginPercent
            FROM tmpPrice_All
               LEFT JOIN tmpGoods_All /*Object_Goods_View*/ AS Object_Goods_View ON Object_Goods_View.id = tmpPrice_All.Goodsid
            --   LEFT OUTER JOIN tmpRemeins AS Object_Remains ON Object_Remains.ObjectId = tmpPrice_View.GoodsId

               LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                       ON ObjectHistory_Price.ObjectId = tmpPrice_All.Id 
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

               LEFT JOIN tmpMarginCategory ON tmpMarginCategory.GoodsId = Object_Goods_View.Id

               LEFT JOIN tmpGoodsBarCode ON tmpGoodsBarCode.GoodsMainId = ObjectLink_Main.ChildObjectId
            WHERE (inisShowDel = True OR Object_Goods_View.isErased = False)
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
 05.01.18         *
 06.12.17         *
 07.09.17         *
 15.08.17         *
 12.06.17         * 
 09.06.17         *
 06.04.17         *
 12.01.17         *
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
-- update  ObjectHistory set EndDate = coalesce (tmp.nextStartDate, zc_DateEnd()) from (
 with tmp as (
 select ObjectHistory_Price.*
      , Row_Number() OVER (PARTITION BY ObjectHistory_Price.ObjectId ORDER BY ObjectHistory_Price.StartDate Asc, ObjectHistory_Price.Id) AS Ord
 from ObjectHistory AS ObjectHistory_Price
 Where ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
-- Where ObjectHistory_Price.DescId = zc_ObjectHistory_PriceListItem()
-- Where ObjectId = 265141
)

select  tmp.Id, tmp.ObjectId, tmp.StartDate as oldStartDate, tmp.EndDate as oldEndDate,  tmp2.StartDate as nextStartDate, tmp2.Ord, ObjectHistoryDesc.Code
from tmp
     left join tmp as tmp2 on tmp2.ObjectId = tmp.ObjectId and tmp2.Ord = tmp.Ord + 1 and tmp2.DescId = tmp.DescId
     left join ObjectHistoryDesc on ObjectHistoryDesc. Id = tmp.DescId
where tmp.EndDate <> coalesce (tmp2.StartDate, zc_DateEnd())
 order by 3

--  ) as tmp where tmp.Id = ObjectHistory.Id

-- select * from ObjectHistory   where ObjectId = 558863 order by EndDate, StartDate
-- select ObjectHistoryDesc.Code, ObjectId, StartDate, count (*) from ObjectHistory  join ObjectHistoryDesc on ObjectHistoryDesc. Id = DescId group by ObjectHistoryDesc.Code, ObjectId, StartDate having count (*) > 1
*/
-- тест
-- select * from gpSelect_Object_Price(inUnitId := 183292 , inStartDate := ('24.02.2016 17:24:00')::TDateTime , inisShowAll := 'False' , inisShowDel := 'False' ,  inSession := '3');
--select * from gpSelect_Object_Price(inUnitId := 183292 , inGoodsId := 0 , inisShowAll := 'False' , inisShowDel := 'False' ,  inSession := '3');