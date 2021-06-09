-- Function: gpSelect_Object_PriceSite (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_PriceSite (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PriceSite(
    IN inGoodsId     Integer,       -- Товар
    IN inisShowAll   Boolean,       -- True - показать все товары, False - показать только с ценами
    IN inisShowDel   Boolean,       -- True - показать так же удаленные, False - показать только рабочие
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Price TFloat, StartDate TDateTime
             , GoodsId Integer, GoodsCode Integer
             , BarCode  TVarChar
             , GoodsName TVarChar
             , IntenalSPName TVarChar
             , GoodsGroupName TVarChar, NDSKindName TVarChar, NDS TFloat
             , ConditionsKeepName TVarChar
             , Goods_isTop Boolean, Goods_PercentMarkup TFloat
             , DateChange TDateTime
             , Fix Boolean, FixDateChange TDateTime
             , MinExpirationDate TDateTime
             , Reserved TFloat, SummaReserved TFloat
             , Remains TFloat, SummaRemains TFloat
             , PriceSiteRetSP TFloat, PriceSiteOptSP TFloat, PriceSiteSP TFloat, PaymentSP TFloat, DiffSP2 TFloat
             , isSP Boolean
             , isErased boolean
             , isClose boolean, isFirst boolean , isSecond boolean
             , isPromo boolean
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

    
    -- Результат
    IF inisShowAll = True
    THEN
        RETURN QUERY
        With 
        
        tmpMovement AS (SELECT MovementLinkObject_Unit.ObjectId AS UnitId
                             FROM Movement 
                             
                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                               ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                              AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()    
                                                               
                             WHERE Movement.OperDate >= CURRENT_DATE - INTERVAL '10 DAY'
                               AND Movement.DescId = zc_Movement_Check()
                               AND Movement.StatusId = zc_Enum_Status_Complete()
                             )
      , tmpUnit AS (SELECT DISTINCT tmpMovement.UnitId FROM tmpMovement)              
      ----
      , tmpContainerPDAll AS (SELECT Container.ParentId
                                   , ContainerLinkObject.ObjectId                                      AS PartionGoodsId
                              FROM Container

                                   LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                                 AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                              WHERE Container.DescId = zc_Container_CountPartionDate()
                                AND Container.Amount > 0 
                                AND Container.WhereObjectId in (SELECT tmpUnit.UnitId FROM tmpUnit)
                                AND (Container.objectid = inGoodsId OR inGoodsId = 0)
                              )

      , tmpContainerPD AS (SELECT Container.ParentId
                                , COALESCE (MIN(ObjectDate_ExpirationDate.ValueData), zc_DateEnd())  AS ExpirationDate
                                 FROM tmpContainerPDAll AS Container
                                      LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                           ON ObjectDate_ExpirationDate.ObjectId = Container.PartionGoodsId
                                                          AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                                 GROUP BY Container.ParentId
                                 )
      , tmpContainerRemeins AS (SELECT Container.ObjectId
                                     , SUM (COALESCE(container.Amount,0)) ::TFloat AS Remains
                                     , Container.Id   AS  ContainerId
                                FROM Container
                                WHERE Container.descid = zc_Container_Count() 
                                  AND Container.Amount <> 0
                                  AND Container.WhereObjectId in (SELECT tmpUnit.UnitId FROM tmpUnit)
                                  AND (Container.objectid = inGoodsId OR inGoodsId = 0)
                                GROUP BY Container.ObjectId, Container.Id
                                HAVING SUM(COALESCE (Container.Amount, 0)) <> 0
                                )
      , tmpRemeins AS (SELECT tmp.ObjectId
                            , SUM (tmp.Remains)      ::TFloat AS Remains
                            , MIN(COALESCE(ContainerPD.ExpirationDate, MIDate_ExpirationDate.ValueData,zc_DateEnd()))::TDateTime AS MinExpirationDate -- Срок годности
                       FROM tmpContainerRemeins AS tmp
                              -- если есть сроковые контейннра то берем дату из нии
                              LEFT JOIN tmpContainerPD AS ContainerPD
                                                       ON ContainerPD.ParentId = tmp.ContainerId
                              -- находим партию                              
                              LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                            ON ContainerLinkObject_MovementItem.Containerid = tmp.ContainerId
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
      , tmpPriceSite_View AS (SELECT Object_PriceSite.Id                              AS Id
                                , PriceSite_Goods.ChildObjectId                    AS GoodsId
                                , ROUND (PriceSite_Value.ValueData, 2)             AS Price
                                , PriceSite_datechange.valuedata                   AS DateChange 
                                , COALESCE(PriceSite_Fix.ValueData,False)          AS Fix 
                                , Fix_DateChange.valuedata                         AS FixDateChange 
                                , COALESCE(PriceSite_PercentMarkup.ValueData, 0) ::TFloat AS PercentMarkup 
                                , PriceSite_PercentMarkupDateChange.ValueData             AS PercentMarkupDateChange 
                           FROM Object AS Object_PriceSite
                           
                                INNER JOIN ObjectLink AS PriceSite_Goods
                                                      ON PriceSite_Goods.ObjectId = Object_PriceSite.Id
                                                     AND PriceSite_Goods.DescId = zc_ObjectLink_PriceSite_Goods()
                                                     AND (PriceSite_Goods.ChildObjectId = inGoodsId OR inGoodsId = 0)

                                -- ограничение по торговой сети
                                INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                      ON ObjectLink_Goods_Object.ObjectId = PriceSite_Goods.ChildObjectId
                                                     AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                     AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId

                                LEFT JOIN ObjectFloat AS PriceSite_Value
                                                      ON PriceSite_Value.ObjectId = Object_PriceSite.Id
                                                     AND PriceSite_Value.DescId = zc_ObjectFloat_PriceSite_Value()
                                LEFT JOIN ObjectDate AS PriceSite_DateChange
                                                     ON PriceSite_DateChange.ObjectId = Object_PriceSite.Id
                                                    AND PriceSite_DateChange.DescId = zc_ObjectDate_PriceSite_DateChange()
                                                    
                                LEFT JOIN ObjectBoolean AS PriceSite_Fix
                                                        ON PriceSite_Fix.ObjectId = Object_PriceSite.Id
                                                       AND PriceSite_Fix.DescId = zc_ObjectBoolean_PriceSite_Fix()
                                LEFT JOIN ObjectDate AS Fix_DateChange
                                                     ON Fix_DateChange.ObjectId = Object_PriceSite.Id
                                                    AND Fix_DateChange.DescId = zc_ObjectDate_PriceSite_FixDateChange()
                                                    
                                LEFT JOIN ObjectFloat AS PriceSite_PercentMarkup
                                                      ON PriceSite_PercentMarkup.ObjectId = Object_PriceSite.Id
                                                     AND PriceSite_PercentMarkup.DescId = zc_ObjectFloat_PriceSite_PercentMarkup()
                                LEFT JOIN ObjectDate AS PriceSite_PercentMarkupDateChange
                                                     ON PriceSite_PercentMarkupDateChange.ObjectId = Object_PriceSite.Id
                                                    AND PriceSite_PercentMarkupDateChange.DescId = zc_ObjectDate_PriceSite_PercentMarkupDateChange()    

                           WHERE Object_PriceSite.DescId = zc_Object_PriceSite()
                           )
                           
   -- Штрих-коды производителя
   , tmpGoodsBarCode AS (SELECT ObjectLink_Main_BarCode.ChildObjectId AS GoodsMainId
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
                        
   -- выбираем отложенные Чеки (как в кассе колонка VIP) 
   , tmpMovementChek AS (SELECT Movement.Id
                         FROM MovementBoolean AS MovementBoolean_Deferred
                              INNER JOIN Movement ON Movement.Id     = MovementBoolean_Deferred.MovementId
                                                 AND Movement.DescId = zc_Movement_Check()
                                                 AND Movement.StatusId = zc_Enum_Status_UnComplete()
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                           AND MovementLinkObject_Unit.ObjectId  in (SELECT tmpUnit.UnitId FROM tmpUnit)
                         WHERE MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                           AND MovementBoolean_Deferred.ValueData = TRUE
                        UNION
                         SELECT Movement.Id
                         FROM MovementString AS MovementString_CommentError
                              INNER JOIN Movement ON Movement.Id     = MovementString_CommentError.MovementId
                                                 AND Movement.DescId = zc_Movement_Check()
                                                 AND Movement.StatusId = zc_Enum_Status_UnComplete()
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                           AND MovementLinkObject_Unit.ObjectId  in (SELECT tmpUnit.UnitId FROM tmpUnit)
                        WHERE MovementString_CommentError.DescId = zc_MovementString_CommentError()
                          AND MovementString_CommentError.ValueData <> ''
                        )
   , tmpReserve AS (SELECT MovementItem.ObjectId             AS GoodsId
                         , SUM (MovementItem.Amount)::TFloat AS Amount
                    FROM tmpMovementChek
                         INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovementChek.Id
                                                AND MovementItem.DescId     = zc_MI_Master()
                                                AND MovementItem.isErased   = FALSE
                    GROUP BY MovementItem.ObjectId
                    )

     -- Товары соц-проект (документ)
   , tmpMI_GoodsSP AS (SELECT DISTINCT tmp.*, TRUE AS isSP
                       FROM lpSelect_MovementItem_GoodsSP_onDate (inStartDate:= CURRENT_DATE, inEndDate:= CURRENT_DATE) AS tmp
                       )
     -- параметры из документа GoodsSP
   , tmpGoodsSP AS (SELECT DISTINCT tmpMI_GoodsSP.GoodsId
                         , COALESCE(Object_IntenalSP.Id ,0)           ::Integer  AS IntenalSPId
                         , COALESCE(Object_IntenalSP.ValueData,'')    ::TVarChar AS IntenalSPName
                         , MIFloat_PriceSiteOptSP.ValueData                          AS PriceSiteOptSP
                         , MIFloat_PriceSiteRetSP.ValueData                          AS PriceSiteRetSP
                         , MIFloat_PriceSiteSP.ValueData                             AS PriceSiteSP
                         , MIFloat_PaymentSP.ValueData                           AS PaymentSP
                         , tmpMI_GoodsSP.isSP
                    FROM tmpMI_GoodsSP
                         LEFT JOIN MovementItemFloat AS MIFloat_PriceSiteRetSP
                                                     ON MIFloat_PriceSiteRetSP.MovementItemId = tmpMI_GoodsSP.MovementItemId
                                                    AND MIFloat_PriceSiteRetSP.DescId = zc_MIFloat_PriceRetSP()                         
                         LEFT JOIN MovementItemFloat AS MIFloat_PriceSiteOptSP
                                                     ON MIFloat_PriceSiteOptSP.MovementItemId = tmpMI_GoodsSP.MovementItemId
                                                    AND MIFloat_PriceSiteOptSP.DescId = zc_MIFloat_PriceOptSP()
                         LEFT JOIN MovementItemFloat AS MIFloat_PriceSiteSP
                                                     ON MIFloat_PriceSiteSP.MovementItemId = tmpMI_GoodsSP.MovementItemId
                                                    AND MIFloat_PriceSiteSP.DescId = zc_MIFloat_PriceSP()
                         LEFT JOIN MovementItemFloat AS MIFloat_PaymentSP
                                                     ON MIFloat_PaymentSP.MovementItemId = tmpMI_GoodsSP.MovementItemId
                                                    AND MIFloat_PaymentSP.DescId = zc_MIFloat_PaymentSP()
                         LEFT JOIN MovementItemLinkObject AS MI_IntenalSP
                                                          ON MI_IntenalSP.MovementItemId = tmpMI_GoodsSP.MovementItemId
                                                         AND MI_IntenalSP.DescId = zc_MILinkObject_IntenalSP()
                         LEFT JOIN Object AS Object_IntenalSP ON Object_IntenalSP.Id = MI_IntenalSP.ObjectId
                    )   -- все товары сети
   , tmpGoodsAll AS (SELECT *
                     FROM Object_Goods_View
                     WHERE Object_Goods_View.ObjectId = vbObjectId
                      AND (inisShowDel = True OR Object_Goods_View.isErased = False)
                      AND (Object_Goods_View.Id = inGoodsId OR inGoodsId = 0)
                    )
   -- получаем коды главных товаров
   , tmpGoodsMain AS (SELECT ObjectLink_Main.ChildObjectId  AS GoodsMainId
                           , ObjectLink_Child.ChildObjectId AS GoodsId
                      FROM ObjectLink AS ObjectLink_Child 
                           JOIN ObjectLink AS ObjectLink_Main 
                                           ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                          AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                      WHERE ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                        AND ObjectLink_Child.ChildObjectId IN (SELECT DISTINCT tmpGoodsAll.Id FROM tmpGoodsAll)
                     )
   --условия хранения
   , tmpOL_ConditionsKeep AS (SELECT ObjectLink_Goods_ConditionsKeep.ObjectId
                                   , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar  AS ConditionsKeepName
                              FROM ObjectLink AS ObjectLink_Goods_ConditionsKeep
                                   LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId        
                              WHERE ObjectLink_Goods_ConditionsKeep.ObjectId IN (SELECT DISTINCT tmpGoodsAll.Id FROM tmpGoodsAll)
                                AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
                              )

   , tmpObjectHistory_PriceSite AS (SELECT *
                                FROM ObjectHistory AS ObjectHistory_PriceSite
                                WHERE ObjectHistory_PriceSite.ObjectId IN (SELECT DISTINCT tmpPriceSite_View.Id FROM tmpPriceSite_View)
                                  AND ObjectHistory_PriceSite.DescId = zc_ObjectHistory_PriceSite()
                                  AND ObjectHistory_PriceSite.EndDate = zc_DateEnd()
                               )
                                     
            -- Результат
            SELECT
                 tmpPriceSite_View.Id                                                   AS Id
               , COALESCE (tmpPriceSite_View.Price,0)                         :: TFloat AS Price
               , COALESCE (ObjectHistory_PriceSite.StartDate, NULL /*zc_DateStart()*/) :: TDateTime AS StartDate
                              
               , Object_Goods_View.id                            AS GoodsId
               , Object_Goods_View.GoodsCodeInt                  AS GoodsCode
--               , zfFormat_BarCode(zc_BarCodePref_Object(), tmpPriceSite_View.Id) ::TVarChar  AS IdBarCode
               , COALESCE (tmpGoodsBarCode.BarCode, '')  :: TVarChar AS BarCode
               , Object_Goods_View.GoodsName                     AS GoodsName
               , tmpGoodsSP.IntenalSPName                        AS IntenalSPName
               , Object_Goods_View.GoodsGroupName                AS GoodsGroupName
               , Object_Goods_View.NDSKindName                   AS NDSKindName
               , Object_Goods_View.NDS                           AS NDS
               , COALESCE(tmpOL_ConditionsKeep.ConditionsKeepName, '') ::TVarChar  AS ConditionsKeepName --, COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar  AS ConditionsKeepName
               , Object_Goods_View.isTop                         AS Goods_isTop
               , Object_Goods_View.PercentMarkup                 AS Goods_PercentMarkup
               , tmpPriceSite_View.DateChange                        AS DateChange
               , COALESCE(tmpPriceSite_View.Fix,False)               AS Fix
               , tmpPriceSite_View.FixDateChange                     AS FixDateChange
               , Object_Remains.MinExpirationDate                AS MinExpirationDate   --SelectMinPriceSite_AllGoods.MinExpirationDate AS MinExpirationDate

               , COALESCE (tmpReserve.Amount, 0)                                     :: TFloat   AS Reserved       -- кол-во в отложенных чеках
               , (COALESCE (tmpReserve.Amount, 0)* COALESCE (tmpPriceSite_View.Price,0)) :: TFloat   AS SummaReserved  -- Сумма отложенных чеков

               , Object_Remains.Remains                          AS Remains
               , (Object_Remains.Remains * COALESCE (tmpPriceSite_View.Price,0)) ::TFloat AS SummaRemains

               , COALESCE (tmpGoodsSP.PriceSiteRetSP, 0) ::TFloat  AS PriceSiteRetSP
               , COALESCE (tmpGoodsSP.PriceSiteOptSP, 0) ::TFloat  AS PriceSiteOptSP
              /* , CASE WHEN COALESCE (tmpPriceSite_View.Price,0) < COALESCE (tmpGoodsSP.PriceSiteSP,0) 
                           THEN COALESCE (tmpPriceSite_View.Price,0)
                      ELSE
                          ::TFloat  AS PriceSiteSP*/
                          
               , CASE WHEN COALESCE (tmpPriceSite_View.Price,0) < COALESCE (tmpGoodsSP.PriceSiteSP, 0)
                      THEN COALESCE (tmpPriceSite_View.Price,0) -- по нашей цене, т.к. она меньше чем цена возмещения

                 ELSE

                     CASE WHEN COALESCE (tmpGoodsSP.PaymentSP, 0) = 0
                          THEN 0 -- по 0, т.к. цена доплаты = 0
    
                     WHEN COALESCE (tmpPriceSite_View.Price,0) < COALESCE (tmpGoodsSP.PriceSiteSP, 0)
                          THEN 0 -- по 0, т.к. наша меньше чем цена возмещения
    
                     WHEN COALESCE (tmpPriceSite_View.Price,0) < COALESCE (tmpGoodsSP.PriceSiteSP, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0)
                       AND 0 > COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                             - (COALESCE (CEIL (tmpGoodsSP.PriceSiteSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) - COALESCE (tmpPriceSite_View.Price,0) 
                               ) -- разница с ценой возмещения и "округлили в большую"
                          THEN 0
    
                     WHEN COALESCE (tmpPriceSite_View.Price,0) < COALESCE (tmpGoodsSP.PriceSiteSP, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0)
                          THEN COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                             - (COALESCE (CEIL (tmpGoodsSP.PriceSiteSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) - COALESCE (tmpPriceSite_View.Price,0) 
                               ) -- разница с ценой возмещения и "округлили в большую"
    
                     ELSE COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- иначе всегда цена доплаты "округлили в меньшую"
                     
                     END
                + COALESCE (tmpGoodsSP.PriceSiteSP, 0)
     
                 END :: TFloat  AS PriceSiteSP
            
                  --, COALESCE (tmpGoodsSP.PaymentSP,0)  ::TFloat  AS PaymentSP
               , CASE WHEN COALESCE (tmpGoodsSP.PaymentSP, 0) = 0
                         THEN 0 -- по 0, т.к. цена доплаты = 0
   
                    WHEN COALESCE (tmpPriceSite_View.Price,0) < COALESCE (tmpGoodsSP.PriceSiteSP, 0)
                         THEN 0 -- по 0, т.к. наша меньше чем цена возмещения
   
                    -- WHEN COALESCE (tmpPriceSite_View.Price,0) < COALESCE (tmpGoodsSP.PaymentSP, 0)
                    --      THEN COALESCE (tmpPriceSite_View.Price,0) -- по нашей цене, т.к. она меньше чем цена доплаты
   
                    WHEN COALESCE (tmpPriceSite_View.Price,0) < COALESCE (tmpGoodsSP.PriceSiteSP, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0)
                      AND 0 > COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                            - (COALESCE (CEIL (tmpGoodsSP.PriceSiteSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) - COALESCE (tmpPriceSite_View.Price,0) 
                              ) -- разница с ценой возмещения и "округлили в большую"
                         THEN 0
   
                    WHEN COALESCE (tmpPriceSite_View.Price,0) < COALESCE (tmpGoodsSP.PriceSiteSP, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0)
                         THEN COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                            - (COALESCE (CEIL (tmpGoodsSP.PriceSiteSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) - COALESCE (tmpPriceSite_View.Price,0) 
                              ) -- разница с ценой возмещения и "округлили в большую"
   
                    ELSE COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- иначе всегда цена доплаты "округлили в меньшую"
                    
                  END   ::TFloat  AS PaymentSP
                  
                   -- из gpSelect_CashRemains_ver2
               ,  (CASE WHEN COALESCE (tmpPriceSite_View.Price,0) < COALESCE (tmpGoodsSP.PriceSiteSP, 0)
                             THEN COALESCE (tmpPriceSite_View.Price,0) -- по нашей цене, т.к. она меньше чем цена возмещения
       
                        ELSE
       
                   CASE WHEN COALESCE (tmpGoodsSP.PaymentSP, 0) = 0
                             THEN 0 -- по 0, т.к. цена доплаты = 0
       
                        WHEN COALESCE (tmpPriceSite_View.Price,0) < COALESCE (tmpGoodsSP.PriceSiteSP, 0)
                             THEN 0 -- по 0, т.к. наша меньше чем цена возмещения
       
                        -- WHEN COALESCE (tmpPriceSite_View.Price,0) < COALESCE (tmpGoodsSP.PaymentSP, 0)
                        --      THEN COALESCE (tmpPriceSite_View.Price,0) -- по нашей цене, т.к. она меньше чем цена доплаты
       
                        WHEN COALESCE (tmpPriceSite_View.Price,0) < COALESCE (tmpGoodsSP.PriceSiteSP, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0)
                          AND 0 > COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                                - (COALESCE (CEIL (tmpGoodsSP.PriceSiteSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) - COALESCE (tmpPriceSite_View.Price,0)
                                  ) -- разница с ценой возмещения и "округлили в большую"
                             THEN 0
       
                        WHEN COALESCE (tmpPriceSite_View.Price,0) < COALESCE (tmpGoodsSP.PriceSiteSP, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0)
                             THEN COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                                - (COALESCE (CEIL (tmpGoodsSP.PriceSiteSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) - COALESCE (tmpPriceSite_View.Price,0)
                                  ) -- разница с ценой возмещения и "округлили в большую"
       
                        ELSE COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- иначе всегда цена доплаты "округлили в меньшую"
       
                   END
                 + COALESCE (tmpGoodsSP.PriceSiteSP, 0)
       
                   END
       
                 - CASE WHEN COALESCE (tmpGoodsSP.PaymentSP, 0) = 0
                             THEN 0 -- по 0, т.к. цена доплаты = 0
       
                        WHEN COALESCE (tmpPriceSite_View.Price,0) < COALESCE (tmpGoodsSP.PriceSiteSP, 0)
                             THEN 0 -- по 0, т.к. наша меньше чем цена возмещения
       
                        -- WHEN COALESCE (tmpPriceSite_View.Price,0) < COALESCE (tmpGoodsSP.PaymentSP, 0)
                        --      THEN COALESCE (tmpPriceSite_View.Price,0) -- по нашей цене, т.к. она меньше чем цена доплаты
       
                        WHEN COALESCE (tmpPriceSite_View.Price,0) < COALESCE (tmpGoodsSP.PriceSiteSP, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0)
                          AND 0 > COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                                - (COALESCE (CEIL (tmpGoodsSP.PriceSiteSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) - COALESCE (tmpPriceSite_View.Price,0)
                                  ) -- разница с ценой возмещения и "округлили в большую"
                             THEN 0
       
                        WHEN COALESCE (tmpPriceSite_View.Price,0) < COALESCE (tmpGoodsSP.PriceSiteSP, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0)
                             THEN COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                                - (COALESCE (CEIL (tmpGoodsSP.PriceSiteSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) - COALESCE (tmpPriceSite_View.Price,0)
                                  ) -- разница с ценой возмещения и "округлили в большую"
       
                        ELSE COALESCE (FLOOR (tmpGoodsSP.PaymentSP * 100) / 100, 0) -- иначе всегда цена доплаты "округлили в меньшую"
       
                   END
                  ) :: TFloat AS DiffSP2

               , COALESCE (tmpGoodsSP.isSP, False)     ::Boolean AS isSP
               , Object_Goods_View.isErased                      AS isErased 

               , Object_Goods_View.isClose
               , Object_Goods_View.isFirst
               , Object_Goods_View.isSecond
               , CASE WHEN COALESCE(GoodsPromo.GoodsId,0) <> 0 THEN TRUE ELSE FALSE END AS isPromo

               , tmpPriceSite_View.PercentMarkup           AS PercentMarkup
               , tmpPriceSite_View.PercentMarkupDateChange AS PercentMarkupDateChange
               
               , CASE WHEN COALESCE (tmpGoodsSP.isSP, False) = TRUE THEN 25088 --zc_Color_GreenL()
                      WHEN Object_Remains.MinExpirationDate < CURRENT_DATE  + zc_Interval_ExpirationDate() THEN zc_Color_Red() --zc_Color_Blue() 
                      WHEN Object_Goods_View.isTop = TRUE THEN zc_Color_Blue() --15993821 -- розовый
                      ELSE zc_Color_Black() 
                 END     AS Color_ExpirationDate                --vbAVGDateEnd
                 
            FROM tmpGoodsAll AS Object_Goods_View

                LEFT OUTER JOIN tmpPriceSite_View ON tmpPriceSite_View.GoodsId = Object_Goods_View.Id

                LEFT OUTER JOIN tmpRemeins AS Object_Remains
                                           ON Object_Remains.ObjectId = Object_Goods_View.Id
   
                -- получаем значения цены и НТЗ из истории значений на дату                                                           
                LEFT JOIN tmpObjectHistory_PriceSite AS ObjectHistory_PriceSite
                                                 ON ObjectHistory_PriceSite.ObjectId = tmpPriceSite_View.Id 

                LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId = Object_Goods_View.Id     
                -- условия хранения
                LEFT JOIN tmpOL_ConditionsKeep ON tmpOL_ConditionsKeep.ObjectId = Object_Goods_View.Id

               -- получается GoodsMainId
               LEFT JOIN tmpGoodsMain ON tmpGoodsMain.GoodsId = Object_Goods_View.Id

               LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = tmpGoodsMain.GoodsMainId
               
               LEFT JOIN ObjectDate AS ObjectDate_LastPrice
                                    ON ObjectDate_LastPrice.ObjectId = tmpGoodsMain.GoodsMainId
                                   AND ObjectDate_LastPrice.DescId = zc_ObjectDate_Goods_LastPrice()
                       
               LEFT JOIN tmpGoodsBarCode ON tmpGoodsBarCode.GoodsMainId = tmpGoodsMain.GoodsMainId

               -- кол-во отложенные чеки
               LEFT JOIN tmpReserve ON tmpReserve.GoodsId = Object_Goods_View.Id

            WHERE (inisShowDel = True OR Object_Goods_View.isErased = False)
              AND (Object_Goods_View.Id = inGoodsId OR inGoodsId = 0)
            ORDER BY GoodsGroupName, GoodsName;
    ELSE
        RETURN QUERY
        WITH

        tmpMovement AS (SELECT MovementLinkObject_Unit.ObjectId AS UnitId
                             FROM Movement 
                             
                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                               ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                              AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()    
                                                               
                             WHERE Movement.OperDate >= CURRENT_DATE - INTERVAL '10 DAY'
                               AND Movement.DescId = zc_Movement_Check()
                               AND Movement.StatusId = zc_Enum_Status_Complete()
                             )
      , tmpUnit AS (SELECT DISTINCT tmpMovement.UnitId FROM tmpMovement)              
      ----
      , tmpContainerPDAll AS (SELECT Container.ParentId
                                   , ContainerLinkObject.ObjectId        AS PartionGoodsId
                              FROM Container

                                   LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                                 AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                              WHERE Container.DescId = zc_Container_CountPartionDate()
                                AND Container.Amount > 0 
                                AND Container.WhereObjectId  in (SELECT tmpUnit.UnitId FROM tmpUnit)
                                AND (Container.objectid = inGoodsId OR inGoodsId = 0)
                              )

      , tmpContainerPD AS (SELECT Container.ParentId
                                , COALESCE (MIN(ObjectDate_ExpirationDate.ValueData), zc_DateEnd())  AS ExpirationDate
                           FROM tmpContainerPDAll AS Container
                                LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                     ON ObjectDate_ExpirationDate.ObjectId = Container.PartionGoodsId
                                                    AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                           GROUP BY Container.ParentId
                           )
      , tmpContainerRemeins AS (SELECT Container.ObjectId
                                     , Container.Id                                       AS  ContainerId
                                     , SUM (COALESCE (Container.Amount,0))       ::TFloat AS Remains
                                FROM Container
                                WHERE Container.descid = zc_container_count() 
                                  AND Container.Amount <> 0
                                  AND Container.WhereObjectId  in (SELECT tmpUnit.UnitId FROM tmpUnit)
                                  AND (Container.objectid = inGoodsId OR inGoodsId = 0)
                                GROUP BY container.objectid, Container.Id
                                HAVING SUM(COALESCE (Container.Amount, 0)) <> 0
                                )
      , tmpCLO AS (SELECT ContainerLinkObject_MovementItem.*
                   FROM ContainerlinkObject AS ContainerLinkObject_MovementItem
                   WHERE ContainerLinkObject_MovementItem.Containerid IN (SELECT DISTINCT tmpContainerRemeins.ContainerId FROM tmpContainerRemeins)
                     AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                    )
      , tmpRemeins1 AS (SELECT tmp.Objectid
                             , tmp.Remains
                             , Object_PartionMovementItem.ObjectCode ::Integer
                             , ContainerPD.ExpirationDate
                       FROM tmpContainerRemeins AS tmp
                              -- если есть сроковые контейннра то берем дату из нии
                              LEFT JOIN tmpContainerPD AS ContainerPD
                                                        ON ContainerPD.ParentId = tmp.ContainerId
                              -- находим партию
                              LEFT JOIN tmpCLO AS ContainerLinkObject_MovementItem
                                                            ON ContainerLinkObject_MovementItem.Containerid =  tmp.ContainerId
                                                          -- AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                              LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                            
                       )
      , tmpMIFloat_MovementItem AS (SELECT MIFloat_MovementItem.*
                                    FROM MovementItemFloat AS MIFloat_MovementItem
                                    WHERE MIFloat_MovementItem.MovementItemId IN (SELECT tmpRemeins1.ObjectCode FROM tmpRemeins1)
                                      AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId() 
                                    )
      
     , tmpRemeins2 AS (SELECT tmp.Objectid
                            , (tmp.Remains)  ::TFloat  AS Remains
                            , 0 /*MIFloat_MovementItem.ValueData :: Integer*/ AS MI_Id_find
                            , 0 /*MI_Income.Id */                             AS MI_Id
                            , tmp.ExpirationDate
                       FROM tmpRemeins1 AS tmp
/*                              -- элемент прихода
                              LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = tmp.ObjectCode
                              -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                              LEFT JOIN tmpMIFloat_MovementItem AS MIFloat_MovementItem
                                                          ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                         AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
*/                       )

      , tmpMIDate_ExpirationDate AS (SELECT MIDate_ExpirationDate.*
                                     FROM MovementItemDate  AS MIDate_ExpirationDate
                                     WHERE MIDate_ExpirationDate.MovementItemId IN (SELECT DISTINCT COALESCE (tmpRemeins2.MI_Id_find, tmpRemeins2.MI_Id) FROM tmpRemeins2)   --Object_PartionMovementItem.ObjectCode
                                       AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                                     )
      , tmpRemeins3 AS (SELECT tmp.Objectid
                             , (tmp.Remains)      ::TFloat AS Remains
                             , NULL /*(COALESCE(tmp.ExpirationDate, MIDate_ExpirationDate.ValueData,zc_DateEnd()))::TDateTime*/ AS MinExpirationDate -- Срок годности
                        FROM tmpRemeins2 AS tmp
                               -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
/*                               LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = tmp.MI_Id_find
                       
                               LEFT OUTER JOIN tmpMIDate_ExpirationDate AS MIDate_ExpirationDate
                                                                        ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id, tmp.MI_Id)  --Object_PartionMovementItem.ObjectCode
*/                        )
 
      , tmpRemeins AS (SELECT tmp.Objectid
                            , SUM (tmp.Remains)      ::TFloat AS Remains
                            , MIN (tmp.MinExpirationDate) ::TDateTime AS MinExpirationDate -- Срок годности
                       FROM tmpRemeins3 AS tmp
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
      ,  tmpPriceSite AS (SELECT Object_PriceSite.Id             AS Id
                           , PriceSite_Goods.ChildObjectId     AS GoodsId
                      FROM Object AS Object_PriceSite
                           INNER JOIN ObjectLink AS PriceSite_Goods
                                                 ON PriceSite_Goods.ObjectId = Object_PriceSite.Id
                                                AND PriceSite_Goods.DescId = zc_ObjectLink_PriceSite_Goods()
                                                AND (PriceSite_Goods.ChildObjectId = inGoodsId OR inGoodsId = 0)

                           -- ограничение по торговой сети
                           INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                 ON ObjectLink_Goods_Object.ObjectId = PriceSite_Goods.ChildObjectId
                                                AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId

                      WHERE Object_PriceSite.DescId = zc_Object_PriceSite()
                           )

       , tmpPriceSite_View AS (SELECT Object_PriceSite.Id                              AS Id
                                , PriceSite_Goods.ChildObjectId                    AS GoodsId
                                , ROUND (PriceSite_Value.ValueData, 2)             AS Price
                                , PriceSite_datechange.valuedata                   AS DateChange 
                                , COALESCE(PriceSite_Fix.ValueData,False)          AS Fix 
                                , Fix_DateChange.valuedata                         AS FixDateChange 
                                , COALESCE(PriceSite_PercentMarkup.ValueData, 0) ::TFloat AS PercentMarkup 
                                , PriceSite_PercentMarkupDateChange.ValueData             AS PercentMarkupDateChange 
                           FROM Object AS Object_PriceSite
                           
                                INNER JOIN ObjectLink AS PriceSite_Goods
                                                      ON PriceSite_Goods.ObjectId = Object_PriceSite.Id
                                                     AND PriceSite_Goods.DescId = zc_ObjectLink_PriceSite_Goods()
                                                     AND (PriceSite_Goods.ChildObjectId = inGoodsId OR inGoodsId = 0)

                                -- ограничение по торговой сети
                                INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                      ON ObjectLink_Goods_Object.ObjectId = Object_PriceSite.Id
                                                     AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                     AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId

                                LEFT JOIN ObjectFloat AS PriceSite_Value
                                                      ON PriceSite_Value.ObjectId = Object_PriceSite.Id
                                                     AND PriceSite_Value.DescId = zc_ObjectFloat_PriceSite_Value()
                                LEFT JOIN ObjectDate AS PriceSite_DateChange
                                                     ON PriceSite_DateChange.ObjectId = Object_PriceSite.Id
                                                    AND PriceSite_DateChange.DescId = zc_ObjectDate_PriceSite_DateChange()
                                                    
                                LEFT JOIN ObjectBoolean AS PriceSite_Fix
                                                        ON PriceSite_Fix.ObjectId = Object_PriceSite.Id
                                                       AND PriceSite_Fix.DescId = zc_ObjectBoolean_PriceSite_Fix()
                                LEFT JOIN ObjectDate AS Fix_DateChange
                                                     ON Fix_DateChange.ObjectId = Object_PriceSite.Id
                                                    AND Fix_DateChange.DescId = zc_ObjectDate_PriceSite_FixDateChange()
                                                    
                                LEFT JOIN ObjectFloat AS PriceSite_PercentMarkup
                                                      ON PriceSite_PercentMarkup.ObjectId = Object_PriceSite.Id
                                                     AND PriceSite_PercentMarkup.DescId = zc_ObjectFloat_PriceSite_PercentMarkup()
                                LEFT JOIN ObjectDate AS PriceSite_PercentMarkupDateChange
                                                     ON PriceSite_PercentMarkupDateChange.ObjectId = Object_PriceSite.Id
                                                    AND PriceSite_PercentMarkupDateChange.DescId = zc_ObjectDate_PriceSite_PercentMarkupDateChange()    

                           WHERE Object_PriceSite.DescId = zc_Object_PriceSite()
                           )

      -- объединяем товары прайса с товарами, которые есть на остатке. (если цена = 0, а остаток есть нужно показать такие товары)
      , tmpPriceSite_All AS (SELECT tmpPriceSite.Id
                              , tmpPriceSite.Price
                              , COALESCE (tmpPriceSite.GoodsId, tmpRemeins.ObjectId) AS GoodsId
                              , tmpPriceSite.DateChange 
                              , COALESCE(tmpPriceSite.Fix, False)                    AS Fix
                              , tmpPriceSite.FixDateChange                           
                              , tmpPriceSite.PercentMarkup 
                              , tmpPriceSite.PercentMarkupDateChange 
                              , tmpRemeins.Remains
                              , tmpRemeins.MinExpirationDate 
                        FROM tmpPriceSite_View AS tmpPriceSite
                             FULL JOIN tmpRemeins ON tmpRemeins.ObjectId = tmpPriceSite.GoodsId
                        )

      -- Штрих-коды производителя
      , tmpGoodsBarCode AS (SELECT ObjectLink_Main_BarCode.ChildObjectId AS GoodsMainId
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
                       AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                       AND ObjectLink_Goods_Object.ObjectId IN (SELECT DISTINCT tmpPriceSite_All.Goodsid FROM tmpPriceSite_All)
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

    -- Товары соц-проект (документ)
  , tmpMI_GoodsSP AS (SELECT DISTINCT tmp.*, TRUE AS isSP
                      FROM lpSelect_MovementItem_GoodsSP_onDate (inStartDate:= CURRENT_DATE, inEndDate:= CURRENT_DATE) AS tmp
                   )
    -- параметры из документа GoodsSP
  , tmpGoodsSP AS (SELECT DISTINCT tmpMI_GoodsSP.GoodsId
                        , COALESCE(Object_IntenalSP.Id ,0)           ::Integer  AS IntenalSPId
                        , COALESCE(Object_IntenalSP.ValueData,'')    ::TVarChar AS IntenalSPName
                        , MIFloat_PriceSiteOptSP.ValueData                          AS PriceSiteOptSP
                        , MIFloat_PriceSiteRetSP.ValueData                          AS PriceSiteRetSP
                        , MIFloat_PriceSiteSP.ValueData                             AS PriceSiteSP
                        , MIFloat_PaymentSP.ValueData                           AS PaymentSP
                        , tmpMI_GoodsSP.isSP
                   FROM tmpMI_GoodsSP
                        LEFT JOIN MovementItemFloat AS MIFloat_PriceSiteRetSP
                                                    ON MIFloat_PriceSiteRetSP.MovementItemId = tmpMI_GoodsSP.MovementItemId
                                                   AND MIFloat_PriceSiteRetSP.DescId = zc_MIFloat_PriceRetSP()                         
                        LEFT JOIN MovementItemFloat AS MIFloat_PriceSiteOptSP
                                                    ON MIFloat_PriceSiteOptSP.MovementItemId = tmpMI_GoodsSP.MovementItemId
                                                   AND MIFloat_PriceSiteOptSP.DescId = zc_MIFloat_PriceOptSP()
                        LEFT JOIN MovementItemFloat AS MIFloat_PriceSiteSP
                                                    ON MIFloat_PriceSiteSP.MovementItemId = tmpMI_GoodsSP.MovementItemId
                                                   AND MIFloat_PriceSiteSP.DescId = zc_MIFloat_PriceSP()
                        LEFT JOIN MovementItemFloat AS MIFloat_PaymentSP
                                                    ON MIFloat_PaymentSP.MovementItemId = tmpMI_GoodsSP.MovementItemId
                                                   AND MIFloat_PaymentSP.DescId = zc_MIFloat_PaymentSP()
                        LEFT JOIN MovementItemLinkObject AS MI_IntenalSP
                                                         ON MI_IntenalSP.MovementItemId = tmpMI_GoodsSP.MovementItemId
                                                        AND MI_IntenalSP.DescId = zc_MILinkObject_IntenalSP()
                        LEFT JOIN Object AS Object_IntenalSP ON Object_IntenalSP.Id = MI_IntenalSP.ObjectId
                   )

  , tmpGoodsMainParam AS (SELECT tmpPriceSite_All.GoodsId
                               , COALESCE (tmpGoodsSP.isSP, False)      ::Boolean AS isSP
                               , COALESCE (tmpGoodsSP.PriceSiteRetSP,0)     ::TFloat  AS PriceSiteRetSP
                               , COALESCE (tmpGoodsSP.PriceSiteOptSP,0)     ::TFloat  AS PriceSiteOptS
                               , COALESCE (tmpGoodsSP.PriceSiteSP,0)        ::TFloat  AS PriceSiteSP
                               , COALESCE (tmpGoodsSP.PaymentSP,0)      ::TFloat  AS PaymentSP
                               , tmpGoodsSP.IntenalSPName                         AS IntenalSPName
                               , ObjectDate_LastPrice.ValueData                   AS Date_LastPriceSite
                               , COALESCE (tmpGoodsBarCode.BarCode, '') :: TVarChar AS BarCode
                          FROM tmpPriceSite_All
                               -- получается GoodsMainId
                               LEFT JOIN ObjectLink AS ObjectLink_Child ON ObjectLink_Child.ChildObjectId = tmpPriceSite_All.Goodsid
                                                                        AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                               LEFT JOIN ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                       AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

                               LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = ObjectLink_Main.ChildObjectId
                               /*LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_SP 
                                                        ON ObjectBoolean_Goods_SP.ObjectId = ObjectLink_Main.ChildObjectId 
                                                       AND ObjectBoolean_Goods_SP.DescId = zc_ObjectBoolean_Goods_SP()
                               LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PriceSiteRetSP
                                                     ON ObjectFloat_Goods_PriceSiteRetSP.ObjectId = ObjectLink_Main.ChildObjectId 
                                                    AND ObjectFloat_Goods_PriceSiteRetSP.DescId = zc_ObjectFloat_Goods_PriceSiteRetSP() 
                               LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PriceSiteOptSP
                                                     ON ObjectFloat_Goods_PriceSiteOptSP.ObjectId = ObjectLink_Main.ChildObjectId
                                                    AND ObjectFloat_Goods_PriceSiteOptSP.DescId = zc_ObjectFloat_Goods_PriceSiteOptSP() 
                               LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PriceSiteSP
                                                     ON ObjectFloat_Goods_PriceSiteSP.ObjectId = ObjectLink_Main.ChildObjectId 
                                                    AND ObjectFloat_Goods_PriceSiteSP.DescId = zc_ObjectFloat_Goods_PriceSiteSP()   
                               LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PaymentSP
                                                     ON ObjectFloat_Goods_PaymentSP.ObjectId = ObjectLink_Main.ChildObjectId 
                                                    AND ObjectFloat_Goods_PaymentSP.DescId = zc_ObjectFloat_Goods_PaymentSP() 
                               LEFT JOIN ObjectLink AS ObjectLink_Goods_IntenalSP
                                                    ON ObjectLink_Goods_IntenalSP.ObjectId = ObjectLink_Main.ChildObjectId
                                                   AND ObjectLink_Goods_IntenalSP.DescId = zc_ObjectLink_Goods_IntenalSP()
                               LEFT JOIN Object AS Object_IntenalSP ON Object_IntenalSP.Id = ObjectLink_Goods_IntenalSP.ChildObjectId
                               */
                               LEFT JOIN ObjectDate AS ObjectDate_LastPrice
                                                    ON ObjectDate_LastPrice.ObjectId = ObjectLink_Main.ChildObjectId
                                                   AND ObjectDate_LastPrice.DescId = zc_ObjectDate_Goods_LastPrice()

                               LEFT JOIN tmpGoodsBarCode ON tmpGoodsBarCode.GoodsMainId = ObjectLink_Main.ChildObjectId
                         )

        -- условия хранения
         , tmpGoods_ConditionsKeep AS (SELECT ObjectLink_Goods_ConditionsKeep.*
                                       FROM ObjectLink AS ObjectLink_Goods_ConditionsKeep 
                                       WHERE ObjectLink_Goods_ConditionsKeep.ObjectId IN (SELECT DISTINCT tmpPriceSite_All.Goodsid FROM tmpPriceSite_All)
                                         AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
                                      )
       , tmpOH_PriceSite AS (SELECT ObjectHistory_PriceSite.*
                         FROM ObjectHistory AS ObjectHistory_PriceSite
                         WHERE ObjectHistory_PriceSite.ObjectId IN (SELECT DISTINCT tmpPriceSite_All.Id FROM tmpPriceSite_All) 
                           AND ObjectHistory_PriceSite.DescId = zc_ObjectHistory_PriceSite()
                           --AND vbStartDate >= ObjectHistory_PriceSite.StartDate AND vbStartDate < ObjectHistory_PriceSite.EndDate
                           AND ObjectHistory_PriceSite.EndDate = zc_DateEnd()
                         )

   -- выбираем отложенные Чеки (как в кассе колонка VIP) 
   , tmpMovementChek AS (SELECT Movement.Id
                         FROM MovementBoolean AS MovementBoolean_Deferred
                              INNER JOIN Movement ON Movement.Id     = MovementBoolean_Deferred.MovementId
                                                 AND Movement.DescId = zc_Movement_Check()
                                                 AND Movement.StatusId = zc_Enum_Status_UnComplete()
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                           AND MovementLinkObject_Unit.ObjectId  in (SELECT tmpUnit.UnitId FROM tmpUnit)
                         WHERE MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                           AND MovementBoolean_Deferred.ValueData = TRUE
                        UNION
                         SELECT Movement.Id
                         FROM MovementString AS MovementString_CommentError
                              INNER JOIN Movement ON Movement.Id     = MovementString_CommentError.MovementId
                                                 AND Movement.DescId = zc_Movement_Check()
                                                 AND Movement.StatusId = zc_Enum_Status_UnComplete()
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                           AND MovementLinkObject_Unit.ObjectId  in (SELECT tmpUnit.UnitId FROM tmpUnit)
                        WHERE MovementString_CommentError.DescId = zc_MovementString_CommentError()
                          AND MovementString_CommentError.ValueData <> ''
                        )
   , tmpReserve AS (SELECT MovementItem.ObjectId             AS GoodsId
                         , SUM (MovementItem.Amount)::TFloat AS Amount
                    FROM tmpMovementChek
                         INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovementChek.Id
                                                AND MovementItem.DescId     = zc_MI_Master()
                                                AND MovementItem.isErased   = FALSE
                    GROUP BY MovementItem.ObjectId
                    )


            -- Результат     
            SELECT tmpPriceSite_All.Id                                                      AS Id
               , COALESCE (tmpPriceSite_All.Price,0)                          :: TFloat    AS Price
               , COALESCE (ObjectHistory_PriceSite.StartDate, NULL)           :: TDateTime AS StartDate
                                        
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
               , tmpPriceSite_All.DateChange                   AS DateChange
               , tmpPriceSite_All.Fix                          AS Fix
               , tmpPriceSite_All.FixDateChange                AS FixDateChange
               , tmpPriceSite_All.MinExpirationDate            AS MinExpirationDate   --, CASE WHEN inGoodsId = 0 THEN SelectMinPriceSite_AllGoods.MinExpirationDate ELSE SelectMinPriceSite_List.PartionGoodsDate END AS MinExpirationDate

               , COALESCE (tmpReserve.Amount, 0)                                     :: TFloat AS Reserved           -- кол-во в отложенных чеках
               , (COALESCE (tmpReserve.Amount, 0) * COALESCE (tmpPriceSite_All.Price,0)) :: TFloat AS SummaReserved      -- Сумма отложенных чеков

               , tmpPriceSite_All.Remains                      AS Remains
               , (tmpPriceSite_All.Remains * COALESCE (tmpPriceSite_All.Price,0)) ::TFloat AS SummaRemains
                                             
               , tmpGoodsMainParam.PriceSiteRetSP ::TFloat  AS PriceSiteRetSP
               , tmpGoodsMainParam.PriceSiteOptS ::TFloat  AS PriceSiteOptSP
              -- , tmpGoodsMainParam.PriceSiteSP    ::TFloat  AS PriceSiteSP
              -- , tmpGoodsMainParam.PaymentSP  ::TFloat  AS PaymentSP

               , CASE WHEN COALESCE (tmpPriceSite_All.Price,0) < COALESCE (tmpGoodsMainParam.PriceSiteSP, 0)
                      THEN COALESCE (tmpPriceSite_All.Price,0) -- по нашей цене, т.к. она меньше чем цена возмещения

                 ELSE

                 CASE WHEN COALESCE (tmpGoodsMainParam.PaymentSP, 0) = 0
                      THEN 0 -- по 0, т.к. цена доплаты = 0

                 WHEN COALESCE (tmpPriceSite_All.Price,0) < COALESCE (tmpGoodsMainParam.PriceSiteSP, 0)
                      THEN 0 -- по 0, т.к. наша меньше чем цена возмещения

                 WHEN COALESCE (tmpPriceSite_All.Price,0) < COALESCE (tmpGoodsMainParam.PriceSiteSP, 0) + COALESCE (FLOOR (tmpGoodsMainParam.PaymentSP * 100) / 100, 0)
                   AND 0 > COALESCE (FLOOR (tmpGoodsMainParam.PaymentSP * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                         - (COALESCE (CEIL (tmpGoodsMainParam.PriceSiteSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsMainParam.PaymentSP * 100) / 100, 0) - COALESCE (tmpPriceSite_All.Price,0) 
                           ) -- разница с ценой возмещения и "округлили в большую"
                      THEN 0

                 WHEN COALESCE (tmpPriceSite_All.Price,0) < COALESCE (tmpGoodsMainParam.PriceSiteSP, 0) + COALESCE (FLOOR (tmpGoodsMainParam.PaymentSP * 100) / 100, 0)
                      THEN COALESCE (FLOOR (tmpGoodsMainParam.PaymentSP * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                         - (COALESCE (CEIL (tmpGoodsMainParam.PriceSiteSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsMainParam.PaymentSP * 100) / 100, 0) - COALESCE (tmpPriceSite_All.Price, 0) 
                           ) -- разница с ценой возмещения и "округлили в большую"

                 ELSE COALESCE (FLOOR (tmpGoodsMainParam.PaymentSP * 100) / 100, 0) -- иначе всегда цена доплаты "округлили в меньшую"
                 
            END
          + COALESCE (tmpGoodsMainParam.PriceSiteSP, 0)

            END :: TFloat  AS PriceSiteSP
               --, tmpGoodsMainParam.PaymentSP  ::TFloat  AS PaymentSP
            , CASE WHEN COALESCE (tmpGoodsMainParam.PaymentSP, 0) = 0
                      THEN 0 -- по 0, т.к. цена доплаты = 0

                 WHEN COALESCE (tmpPriceSite_All.Price,0) < COALESCE (tmpGoodsMainParam.PriceSiteSP, 0)
                      THEN 0 -- по 0, т.к. наша меньше чем цена возмещения

                 -- WHEN COALESCE (tmpPriceSite_All.Price,0) < COALESCE (tmpGoodsMainParam.PaymentSP, 0)
                 --      THEN COALESCE (tmpPriceSite_All.Price,0) -- по нашей цене, т.к. она меньше чем цена доплаты

                 WHEN COALESCE (tmpPriceSite_All.Price,0) < COALESCE (tmpGoodsMainParam.PriceSiteSP, 0) + COALESCE (FLOOR (tmpGoodsMainParam.PaymentSP * 100) / 100, 0)
                   AND 0 > COALESCE (FLOOR (tmpGoodsMainParam.PaymentSP * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                         - (COALESCE (CEIL (tmpGoodsMainParam.PriceSiteSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsMainParam.PaymentSP * 100) / 100, 0) - COALESCE (tmpPriceSite_All.Price,0) 
                           ) -- разница с ценой возмещения и "округлили в большую"
                      THEN 0

                 WHEN COALESCE (tmpPriceSite_All.Price,0) < COALESCE (tmpGoodsMainParam.PriceSiteSP, 0) + COALESCE (FLOOR (tmpGoodsMainParam.PaymentSP * 100) / 100, 0)
                      THEN COALESCE (FLOOR (tmpGoodsMainParam.PaymentSP * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                         - (COALESCE (CEIL (tmpGoodsMainParam.PriceSiteSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsMainParam.PaymentSP * 100) / 100, 0) - COALESCE (tmpPriceSite_All.Price,0) 
                           ) -- разница с ценой возмещения и "округлили в большую"

                 ELSE COALESCE (FLOOR (tmpGoodsMainParam.PaymentSP * 100) / 100, 0) -- иначе всегда цена доплаты "округлили в меньшую"
                 
               END   ::TFloat  AS PaymentSP

                   -- из gpSelect_CashRemains_ver2
               ,  (CASE WHEN COALESCE (tmpPriceSite_All.Price,0) < COALESCE (tmpGoodsMainParam.PriceSiteSP, 0)
                             THEN COALESCE (tmpPriceSite_All.Price,0) -- по нашей цене, т.к. она меньше чем цена возмещения
       
                        ELSE
       
                   CASE WHEN COALESCE (tmpGoodsMainParam.PaymentSP, 0) = 0
                             THEN 0 -- по 0, т.к. цена доплаты = 0
       
                        WHEN COALESCE (tmpPriceSite_All.Price,0) < COALESCE (tmpGoodsMainParam.PriceSiteSP, 0)
                             THEN 0 -- по 0, т.к. наша меньше чем цена возмещения
       
                        -- WHEN COALESCE (tmpPriceSite_All.Price,0) < COALESCE (tmpGoodsMainParam.PaymentSP, 0)
                        --      THEN COALESCE (tmpPriceSite_All.Price,0) -- по нашей цене, т.к. она меньше чем цена доплаты
       
                        WHEN COALESCE (tmpPriceSite_All.Price,0) < COALESCE (tmpGoodsMainParam.PriceSiteSP, 0) + COALESCE (FLOOR (tmpGoodsMainParam.PaymentSP * 100) / 100, 0)
                          AND 0 > COALESCE (FLOOR (tmpGoodsMainParam.PaymentSP * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                                - (COALESCE (CEIL (tmpGoodsMainParam.PriceSiteSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsMainParam.PaymentSP * 100) / 100, 0) - COALESCE (tmpPriceSite_All.Price,0)
                                  ) -- разница с ценой возмещения и "округлили в большую"
                             THEN 0
       
                        WHEN COALESCE (tmpPriceSite_All.Price,0) < COALESCE (tmpGoodsMainParam.PriceSiteSP, 0) + COALESCE (FLOOR (tmpGoodsMainParam.PaymentSP * 100) / 100, 0)
                             THEN COALESCE (FLOOR (tmpGoodsMainParam.PaymentSP * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                                - (COALESCE (CEIL (tmpGoodsMainParam.PriceSiteSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsMainParam.PaymentSP * 100) / 100, 0) - COALESCE (tmpPriceSite_All.Price,0)
                                  ) -- разница с ценой возмещения и "округлили в большую"
       
                        ELSE COALESCE (FLOOR (tmpGoodsMainParam.PaymentSP * 100) / 100, 0) -- иначе всегда цена доплаты "округлили в меньшую"
       
                   END
                 + COALESCE (tmpGoodsMainParam.PriceSiteSP, 0)
       
                   END
       
                 - CASE WHEN COALESCE (tmpGoodsMainParam.PaymentSP, 0) = 0
                             THEN 0 -- по 0, т.к. цена доплаты = 0
       
                        WHEN COALESCE (tmpPriceSite_All.Price,0) < COALESCE (tmpGoodsMainParam.PriceSiteSP, 0)
                             THEN 0 -- по 0, т.к. наша меньше чем цена возмещения
       
                        -- WHEN COALESCE (tmpPriceSite_All.Price,0) < COALESCE (tmpGoodsMainParam.PaymentSP, 0)
                        --      THEN COALESCE (tmpPriceSite_All.Price,0) -- по нашей цене, т.к. она меньше чем цена доплаты
       
                        WHEN COALESCE (tmpPriceSite_All.Price,0) < COALESCE (tmpGoodsMainParam.PriceSiteSP, 0) + COALESCE (FLOOR (tmpGoodsMainParam.PaymentSP * 100) / 100, 0)
                          AND 0 > COALESCE (FLOOR (tmpGoodsMainParam.PaymentSP * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                                - (COALESCE (CEIL (tmpGoodsMainParam.PriceSiteSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsMainParam.PaymentSP * 100) / 100, 0) - COALESCE (tmpPriceSite_All.Price,0)
                                  ) -- разница с ценой возмещения и "округлили в большую"
                             THEN 0
       
                        WHEN COALESCE (tmpPriceSite_All.Price,0) < COALESCE (tmpGoodsMainParam.PriceSiteSP, 0) + COALESCE (FLOOR (tmpGoodsMainParam.PaymentSP * 100) / 100, 0)
                             THEN COALESCE (FLOOR (tmpGoodsMainParam.PaymentSP * 100) / 100, 0) -- "округлили в меньшую" и цену доплаты уменьшим на ...
                                - (COALESCE (CEIL (tmpGoodsMainParam.PriceSiteSP * 100) / 100, 0) + COALESCE (FLOOR (tmpGoodsMainParam.PaymentSP * 100) / 100, 0) - COALESCE (tmpPriceSite_All.Price,0)
                                  ) -- разница с ценой возмещения и "округлили в большую"
       
                        ELSE COALESCE (FLOOR (tmpGoodsMainParam.PaymentSP * 100) / 100, 0) -- иначе всегда цена доплаты "округлили в меньшую"
       
                   END
                  ) :: TFloat AS DiffSP2

               , tmpGoodsMainParam.isSP :: Boolean  AS isSP
               , Object_Goods_View.isErased                                    AS isErased 

               , Object_Goods_View.isClose
               , Object_Goods_View.isFirst
               , Object_Goods_View.isSecond
               , CASE WHEN COALESCE(GoodsPromo.GoodsId,0) <> 0 THEN TRUE ELSE FALSE END AS isPromo

               , tmpPriceSite_All.PercentMarkup            AS PercentMarkup
               , tmpPriceSite_All.PercentMarkupDateChange  AS PercentMarkupDateChange

               , CASE WHEN tmpGoodsMainParam.isSP = TRUE THEN 25088 --zc_Color_GreenL()
                      WHEN tmpPriceSite_All.MinExpirationDate < CURRENT_DATE  + zc_Interval_ExpirationDate() THEN zc_Color_Red() -- zc_Color_Blue() 
                      WHEN Object_Goods_View.isTop = TRUE THEN zc_Color_Blue()  --15993821 -- розовый
                      ELSE zc_Color_Black() 
                 END      AS Color_ExpirationDate                --vbAVGDateEnd
               
            FROM tmpPriceSite_All
               LEFT JOIN tmpGoods_All AS Object_Goods_View ON Object_Goods_View.id = tmpPriceSite_All.GoodsId

               LEFT JOIN tmpOH_PriceSite AS ObjectHistory_PriceSite
                                       ON ObjectHistory_PriceSite.ObjectId = tmpPriceSite_All.Id 
 
               LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId = Object_Goods_View.Id
 
               -- условия хранения
               LEFT JOIN tmpGoods_ConditionsKeep AS ObjectLink_Goods_ConditionsKeep 
                                                 ON ObjectLink_Goods_ConditionsKeep.ObjectId = Object_Goods_View.Id
               LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId

               -- данные из GoodsMainId
               LEFT JOIN tmpGoodsMainParam ON tmpGoodsMainParam.GoodsId = Object_Goods_View.Id
               
               -- кол-во отложенные чеки
               LEFT JOIN tmpReserve ON tmpReserve.GoodsId = Object_Goods_View.Id

            WHERE (inisShowDel = True OR Object_Goods_View.isErased = False)
              AND (Object_Goods_View.Id = inGoodsId OR inGoodsId = 0)
            ORDER BY GoodsGroupName, GoodsName;
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 09.06.21                                                       *

*/
-- тест
-- 
SELECT * FROM gpSelect_Object_PriceSite(inGoodsId := 0 , inisShowAll := 'False' , inisShowDel := 'False' ,  inSession := '3');