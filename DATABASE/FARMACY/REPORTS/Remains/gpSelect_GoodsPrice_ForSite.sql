-- Function: gpSelect_GoodsPrice_ForSite()

--DROP FUNCTION IF EXISTS gpSelect_GoodsPrice_ForSite (Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_GoodsPrice_ForSite (Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsPrice_ForSite(
    IN inCategoryId         Integer     ,  -- Группа
    IN inSortType           Integer     ,  -- Тип сортировка
    IN inSortLang           TVarChar    ,  -- По названию
    IN inStart              Integer     ,  -- Смещение
    IN inLimit              Integer     ,  -- Количество строк
    IN inProductId          Integer     ,  -- Только указанный товар
    IN inSearch             TVarChar    ,  -- Фильтр для ILIKE
    IN inisDiscountExternal Boolean     ,  -- Показывать товар участвующий в дисконтной программе
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id                Integer    -- Id товара

             , Name              TVarChar   -- Название русское
             , NameUkr           TVarChar   -- Название украинское если (есть)

             , Price             TFloat     -- Интернет цена
             
             , PriceUnitMin      TFloat     -- Минимальная цена подразделений
             , PriceUnitMax      TFloat     -- Максимальная цена подразделений
             , Remains           TFloat     -- Остаток по сети
             
             , isDiscountExternal boolean   -- Товар участвует в дисконтной программе
             , isPartionDate      boolean   -- Есть товар со сроком годности

             , FormDispensingId Integer     -- Форма отпуска
             , FormDispensingName TVarChar
             , FormDispensingNameUkr TVarChar
             , NumberPlates Integer         -- Кол-во пластин в упаковке  
             , QtyPackage Integer           -- Кол-во в упаковке
             , Multiplicity TFloat          -- Минимальная кратность при отпуске
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;

   DECLARE vbDate_6 TDateTime;
   DECLARE vbDate_3 TDateTime;
   DECLARE vbDate_1 TDateTime;
   DECLARE vbDate_0 TDateTime;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    -- vbUserId:= lpGetUserBySession (inSession);
    vbUserId:= inSession :: Integer;

    -- определяется <Торговая сеть>
    vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', ABS (vbUserId));

    -- значения для разделения по срокам
    SELECT Date_6, Date_3, Date_1, Date_0
    INTO vbDate_6, vbDate_3, vbDate_1, vbDate_0
    FROM lpSelect_PartionDateKind_SetDate ();
    
    inStart := COALESCE (inStart, 0);
    if COALESCE (inLimit, 0) <= 0
    THEN
      inLimit := 100000;
    END IF;

    -- Результат
    RETURN QUERY
       WITH 
            tmpUnit AS (SELECT tmp.Id 
                        FROM gpSelect_Object_Unit_Active (inNotUnitId := 0, inSession := inSession) AS tmp
                             INNER JOIN ObjectLink AS OL_Unit_Juridical
                                                   ON OL_Unit_Juridical.ObjectId = tmp.Id
                                                  AND OL_Unit_Juridical.DescId   = zc_ObjectLink_Unit_Juridical()
                             INNER JOIN ObjectLink AS OL_Juridical_Retail
                                                   ON OL_Juridical_Retail.ObjectId = OL_Unit_Juridical.ChildObjectId
                                                   AND OL_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()
                                                  AND OL_Juridical_Retail.ChildObjectId = 4
                             INNER JOIN ObjectLink AS OL_Unit_Area
                                                   ON OL_Unit_Area.ObjectId = tmp.Id
                                                  AND OL_Unit_Area.DescId   = zc_ObjectLink_Unit_Area()
                        )
          , tmpGoodsDiscount AS (SELECT Object_Goods_Retail.GoodsMainId                           AS GoodsMainId
                                      , Object_Object.Id                                          AS GoodsDiscountId
                                      , Object_Object.ValueData                                   AS GoodsDiscountName
                                      , COALESCE(ObjectBoolean_GoodsForProject.ValueData, False)  AS isGoodsForProject
                                      , COALESCE(ObjectBoolean_StealthBonuses.ValueData, False)   AS isStealthBonuses 
                                      /*, MAX(COALESCE(ObjectFloat_MaxPrice.ValueData, 0))::TFloat  AS MaxPrice 
                                      , MAX(ObjectFloat_DiscountProcent.ValueData)::TFloat        AS DiscountProcent*/ 
                                 FROM Object AS Object_BarCode
                                      INNER JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                                            ON ObjectLink_BarCode_Goods.ObjectId = Object_BarCode.Id
                                                           AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
                                      INNER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = ObjectLink_BarCode_Goods.ChildObjectId

                                      LEFT JOIN ObjectLink AS ObjectLink_BarCode_Object
                                                           ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                                                          AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()
                                      LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_BarCode_Object.ChildObjectId

                                      LEFT JOIN ObjectBoolean AS ObjectBoolean_GoodsForProject
                                                              ON ObjectBoolean_GoodsForProject.ObjectId = Object_Object.Id
                                                             AND ObjectBoolean_GoodsForProject.DescId = zc_ObjectBoolean_DiscountExternal_GoodsForProject()
                                      LEFT JOIN ObjectBoolean AS ObjectBoolean_StealthBonuses
                                                              ON ObjectBoolean_StealthBonuses.ObjectId = Object_BarCode.Id
                                                             AND ObjectBoolean_StealthBonuses.DescId = zc_ObjectBoolean_BarCode_StealthBonuses()

                                      /*LEFT JOIN ObjectFloat AS ObjectFloat_MaxPrice
                                                            ON ObjectFloat_MaxPrice.ObjectId = Object_BarCode.Id
                                                           AND ObjectFloat_MaxPrice.DescId = zc_ObjectFloat_BarCode_MaxPrice()
                                      LEFT JOIN ObjectFloat AS ObjectFloat_DiscountProcent
                                                            ON ObjectFloat_DiscountProcent.ObjectId = Object_BarCode.Id
                                                           AND ObjectFloat_DiscountProcent.DescId = zc_ObjectFloat_BarCode_DiscountProcent()*/
                                                                   
                                 WHERE Object_BarCode.DescId = zc_Object_BarCode()
                                   AND Object_BarCode.isErased = False
                                 GROUP BY Object_Goods_Retail.GoodsMainId
                                        , Object_Object.Id
                                        , Object_Object.ValueData
                                        , COALESCE(ObjectBoolean_GoodsForProject.ValueData, False)
                                        , COALESCE(ObjectBoolean_StealthBonuses.ValueData, False))
          , tmpPrice_Site AS (SELECT ROUND(Price_Value.ValueData,2)::TFloat     AS Price
                                   , Object_Goods_Retail.Id                     AS GoodsId
                                   , Object_Goods_Main.Name                     AS Name
                                   , Object_Goods_Main.NameUkr                  AS NameUkr
                                   , COALESCE(Object_Goods_Retail.Price, 0)     AS PriceTop 
                                   , Object_Goods_Retail.isTop                  AS isTop 
                                   , Object_Goods_Main.Id                       AS GoodsMainId
                                   , Object_Goods_Retail.DiscontSiteStart
                                   , Object_Goods_Retail.DiscontSiteEnd
                                   , Object_Goods_Retail.DiscontAmountSite
                                   , Object_Goods_Retail.DiscontPercentSite
                                   , Object_Goods_Main.FormDispensingId
                                   , Object_Goods_Main.NumberPlates
                                   , Object_Goods_Main.QtyPackage
                                   , Object_Goods_Main.Multiplicity
                                   , COALESCE(Object_Goods_Retail.SummaWages, 0) <> 0 OR 
                                     COALESCE(Object_Goods_Retail.PercentWages, 0) <> 0 OR
                                     COALESCE(Object_Goods_Main.isStealthBonuses, FALSE) OR
                                     COALESCE(tmpGoodsDiscount.isStealthBonuses, FALSE OR 
                                     (COALESCE (Object_Goods_Retail.DiscontAmountSite, 0) > 0 OR
                                     COALESCE (Object_Goods_Retail.DiscontPercentSite, 0) > 0) 
                                     AND Object_Goods_Retail.DiscontSiteStart IS NOT NULL
                                     AND Object_Goods_Retail.DiscontSiteEnd IS NOT NULL  
                                     AND Object_Goods_Retail.DiscontSiteStart <= CURRENT_DATE
                                     AND Object_Goods_Retail.DiscontSiteEnd >= CURRENT_DATE)  AS isStealthBonuses
                              FROM Object_Goods_Main AS Object_Goods_Main

                                   LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.GoodsMainId  = Object_Goods_Main.Id
                                                                AND Object_Goods_Retail.RetailId     = 4

                                   LEFT JOIN tmpGoodsDiscount ON tmpGoodsDiscount.GoodsMainId = Object_Goods_Main.Id

                                   LEFT JOIN ObjectLink AS Price_Goods
                                          ON Price_Goods.ChildObjectId = Object_Goods_Retail.Id
                                         AND Price_Goods.DescId = zc_ObjectLink_PriceSite_Goods()
                                         AND COALESCE (tmpGoodsDiscount.GoodsMainId, 0) = 0

                                   LEFT JOIN ObjectFloat AS Price_Value
                                          ON Price_Value.ObjectId = Price_Goods.ObjectId
                                         AND Price_Value.DescId = zc_ObjectFloat_PriceSite_Value()
                                         
                              WHERE Object_Goods_Main.isPublished = True
                                AND (Object_Goods_Main.GoodsGroupId = inCategoryId OR COALESCE(inCategoryId, 0) = 0)
                                AND (Object_Goods_Retail.Id = inProductId OR COALESCE(inProductId, 0) = 0)
                                AND (COALESCE (inSearch, '') = '' OR 
                                    Object_Goods_Main.Name ILIKE '%'||inSearch||'%' OR
                                    Object_Goods_Main.NameUkr ILIKE '%'||inSearch||'%')
                                AND (COALESCE(inisDiscountExternal, False) = TRUE OR 
                                    (COALESCE(Object_Goods_Retail.SummaWages, 0) <> 0 OR 
                                     COALESCE(Object_Goods_Retail.PercentWages, 0) <> 0 OR
                                     COALESCE(Object_Goods_Main.isStealthBonuses, FALSE) OR
                                     COALESCE(tmpGoodsDiscount.isStealthBonuses, FALSE)) = FALSE)
                              )
          , tmpContainerRemainsPD AS (SELECT Container.ObjectId           AS GoodsId
                                           , SUM(Container.Amount)        AS Remains 
                                      FROM Container
                                           INNER JOIN tmpPrice_Site ON tmpPrice_Site.GoodsId = Container.ObjectId
                                           INNER JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                                         AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                                           INNER JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                                 ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId  
                                                                AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                                                                AND ObjectDate_ExpirationDate.ValueData <= CURRENT_DATE

                                           INNER JOIN Object_Goods_Retail AS RetailAll ON RetailAll.Id  = Container.ObjectId  
                                           INNER JOIN Object_Goods_Main AS RetailMain ON RetailMain.Id  = RetailAll.GoodsMainId
                                           
                                      WHERE Container.DescId = zc_Container_CountPartionDate()
                                        AND Container.Amount <> 0
                                        AND Container.WhereObjectId in (SELECT tmpUnit.Id FROM tmpUnit)
                                        AND COALESCE(RetailMain.GoodsGroupId, 0) <> 394744
                                      GROUP BY Container.ObjectId  
                                      HAVING SUM(Container.Amount) > 0
                                     )
          , tmpContainerRemains AS (SELECT Container.ObjectId           AS GoodsId
                                         , SUM(Container.Amount)        AS Remains 
                                    FROM Container
                                         INNER JOIN tmpPrice_Site ON tmpPrice_Site.GoodsId = Container.ObjectId
                                    WHERE Container.DescId = zc_Container_Count()
                                      AND Container.Amount <> 0
                                      AND Container.WhereObjectId in (SELECT tmpUnit.Id FROM tmpUnit)
                                    GROUP BY Container.ObjectId  
                                    HAVING SUM(Container.Amount) > 0
                                    )
          , tmpData AS (SELECT Price_Site.GoodsId
                             , Price_Site.GoodsMainId

                             , Price_Site.Name                                              AS Name
                             , Price_Site.NameUkr                                           AS NameUkr

                             , Price_Site.Price                                             AS Price

                             , (tmpContainerRemains.Remains - COALESCE (tmpContainerRemainsPD.Remains, 0))::TFloat AS Remains

                             , tmpGoods.isStealthBonuses
                             , tmpGoods.FormDispensingId
                             , tmpGoods.NumberPlates
                             , tmpGoods.QtyPackage
                             , tmpGoods.Multiplicity
                              
                        FROM tmpPrice_Site AS tmpGoods 
                        
                             LEFT JOIN tmpPrice_Site AS Price_Site ON Price_Site.GoodsId = tmpGoods.GoodsId      

                             LEFT JOIN tmpContainerRemains ON tmpContainerRemains.GoodsId = Price_Site.GoodsId

                             LEFT JOIN tmpContainerRemainsPD ON tmpContainerRemainsPD.GoodsId = Price_Site.GoodsId
                                            
                        ORDER BY CASE WHEN COALESCE (tmpContainerRemains.Remains, 0) = 0 THEN 1 ELSE 0 END 
                               , CASE WHEN inSortType = 0 THEN Price_Site.Price END
                               , CASE WHEN inSortType = 1 THEN Price_Site.Price END DESC
                               , CASE WHEN inSortType = 2 THEN CASE WHEN lower(inSortLang) = 'uk' THEN Price_Site.NameUkr ELSE Price_Site.Name END END
                               , CASE WHEN inSortType = 3 THEN CASE WHEN lower(inSortLang) = 'uk' THEN Price_Site.NameUkr ELSE Price_Site.Name END END DESC
                               , Price_Site.Name
                        LIMIT inLimit OFFSET inStart      
                        )
          , tmpContainerPD AS (SELECT Container.WhereObjectId      AS UnitId
                                    , Container.ObjectId           AS GoodsId
                                    , SUM(Container.Amount)        AS RemainsAll 
                                    , SUM(CASE WHEN ObjectDate_ExpirationDate.ValueData <= CURRENT_DATE THEN Container.Amount ELSE 0 END)         AS Remains 
                                    , SUM(CASE WHEN NOT (ObjectDate_ExpirationDate.ValueData <= CURRENT_DATE) AND
                                          COALESCE(ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = FALSE  THEN Container.Amount ELSE 0 END)  AS RemainsPD 
                               FROM Container
                                    INNER JOIN tmpData ON tmpData.GoodsId = Container.ObjectId
                                    INNER JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                                  AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                                    INNER JOIN Object_Goods_Retail AS RetailAll ON RetailAll.Id  = Container.ObjectId  
                                    INNER JOIN Object_Goods_Main AS RetailMain ON RetailMain.Id  = RetailAll.GoodsMainId

                                    INNER JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                          ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId  
                                                         AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                                                         AND ObjectDate_ExpirationDate.ValueData < vbDate_6

                                    LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                                            ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = ContainerLinkObject.ObjectId  
                                                           AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5()
                                           
                               WHERE Container.DescId = zc_Container_CountPartionDate()
                                 AND Container.Amount <> 0
                                 AND Container.WhereObjectId in (SELECT tmpUnit.Id FROM tmpUnit)
                                 AND COALESCE(RetailMain.GoodsGroupId, 0) <> 394744
                               GROUP BY Container.WhereObjectId
                                      , Container.ObjectId  
                               HAVING SUM(Container.Amount) > 0
                               )
          , tmpContainer AS (SELECT Container.WhereObjectId      AS UnitId
                                  , Container.ObjectId           AS GoodsId
                                  , SUM(Container.Amount)        AS Remains 
                             FROM Container
                                  INNER JOIN tmpData ON tmpData.GoodsId = Container.ObjectId
                             WHERE Container.DescId = zc_Container_Count()
                               AND Container.Amount <> 0
                              -- AND Container.ObjectId in (SELECT tmpData.GoodsId FROM tmpData)
                               AND Container.WhereObjectId in (SELECT tmpUnit.Id FROM tmpUnit)
                             GROUP BY Container.WhereObjectId
                                    , Container.ObjectId  
                             HAVING SUM(Container.Amount) > 0
                             )
          , tmpContainerAll AS (SELECT Price_Goods.ChildObjectId            AS GoodsId
                                     , MIN(CASE WHEN tmpPrice_Site.DiscontSiteStart IS NOT NULL
                                                 AND tmpPrice_Site.DiscontSiteEnd IS NOT NULL  
                                                 AND tmpPrice_Site.DiscontSiteStart <= CURRENT_DATE
                                                 AND tmpPrice_Site.DiscontSiteEnd >= CURRENT_DATE
                                                 AND COALESCE (tmpPrice_Site.DiscontAmountSite, 0) > 0
                                                THEN ROUND(CASE WHEN tmpPrice_Site.IsTop = TRUE
                                                                 AND tmpPrice_Site.PriceTop > 0
                                                                THEN ROUND (tmpPrice_Site.PriceTop, 2)
                                                                ELSE ROUND (Price_Value.ValueData, 2) END - COALESCE (tmpPrice_Site.DiscontAmountSite, 0), 2)
                                                WHEN tmpPrice_Site.DiscontSiteStart IS NOT NULL
                                                 AND tmpPrice_Site.DiscontSiteEnd IS NOT NULL  
                                                 AND tmpPrice_Site.DiscontSiteStart <= CURRENT_DATE
                                                 AND tmpPrice_Site.DiscontSiteEnd >= CURRENT_DATE
                                                 AND COALESCE (tmpPrice_Site.DiscontPercentSite, 0) > 0 
                                                THEN ROUND(CASE WHEN tmpPrice_Site.IsTop = TRUE
                                                                 AND tmpPrice_Site.PriceTop > 0
                                                                THEN ROUND (tmpPrice_Site.PriceTop, 2)
                                                                ELSE ROUND (Price_Value.ValueData, 2) END * (100 - COALESCE (tmpPrice_Site.DiscontPercentSite, 0)) / 100, 1)
                                                ELSE CASE WHEN tmpPrice_Site.IsTop = TRUE
                                                           AND tmpPrice_Site.PriceTop > 0
                                                          THEN ROUND (tmpPrice_Site.PriceTop, 2)
                                                          ELSE ROUND (Price_Value.ValueData, 2) END
                                                END)           AS PriceMin
                                     , MAX(CASE WHEN tmpPrice_Site.DiscontSiteStart IS NOT NULL
                                                 AND tmpPrice_Site.DiscontSiteEnd IS NOT NULL  
                                                 AND tmpPrice_Site.DiscontSiteStart <= CURRENT_DATE
                                                 AND tmpPrice_Site.DiscontSiteEnd >= CURRENT_DATE
                                                 AND COALESCE (tmpPrice_Site.DiscontAmountSite, 0) > 0
                                                THEN ROUND(CASE WHEN tmpPrice_Site.IsTop = TRUE
                                                                 AND tmpPrice_Site.PriceTop > 0
                                                                THEN ROUND (tmpPrice_Site.PriceTop, 2)
                                                                ELSE ROUND (Price_Value.ValueData, 2) END - COALESCE (tmpPrice_Site.DiscontAmountSite, 0), 2)
                                                WHEN tmpPrice_Site.DiscontSiteStart IS NOT NULL
                                                 AND tmpPrice_Site.DiscontSiteEnd IS NOT NULL  
                                                 AND tmpPrice_Site.DiscontSiteStart <= CURRENT_DATE
                                                 AND tmpPrice_Site.DiscontSiteEnd >= CURRENT_DATE
                                                 AND COALESCE (tmpPrice_Site.DiscontPercentSite, 0) > 0 
                                                THEN ROUND(CASE WHEN tmpPrice_Site.IsTop = TRUE
                                                                 AND tmpPrice_Site.PriceTop > 0
                                                                THEN ROUND (tmpPrice_Site.PriceTop, 2)
                                                                ELSE ROUND (Price_Value.ValueData, 2) END * (100 - COALESCE (tmpPrice_Site.DiscontPercentSite	, 0)) / 100, 1)
                                                ELSE CASE WHEN tmpPrice_Site.IsTop = TRUE
                                                           AND tmpPrice_Site.PriceTop > 0
                                                          THEN ROUND (tmpPrice_Site.PriceTop, 2)
                                                          ELSE ROUND (Price_Value.ValueData, 2) END
                                                END)           AS PriceMax
                                FROM ObjectLink AS Price_Goods
                                
                                     INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                                           ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                          AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                                         
                                     INNER JOIN tmpContainer ON tmpContainer.UnitId = ObjectLink_Price_Unit.ChildObjectId
                                                            AND tmpContainer.GoodsId = Price_Goods.ChildObjectId

                                     LEFT JOIN ObjectFloat AS Price_Value
                                                           ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                          AND Price_Value.DescId = zc_ObjectFloat_Price_Value()

                                     -- Фикс цена для всей Сети
                                     LEFT JOIN tmpPrice_Site  ON tmpPrice_Site.GoodsId = Price_Goods.ChildObjectId
                                     
                                     LEFT JOIN tmpContainerPD ON tmpContainerPD.GoodsId = Price_Goods.ChildObjectId
                                                             AND tmpContainerPD.UnitId = ObjectLink_Price_Unit.ChildObjectId
                                     
                                WHERE Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                  AND Price_Goods.ChildObjectId in (SELECT tmpData.GoodsId FROM tmpData)    
                                  AND tmpContainer.Remains > COALESCE (tmpContainerPD.RemainsAll, 0)
                                GROUP BY Price_Goods.ChildObjectId 
                                )
          , tmpGoodsSP AS (SELECT MovementItem.ObjectId         AS GoodsId
                                                                -- № п/п - на всякий случай
                                , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY Movement.OperDate DESC) AS Ord
                           FROM Movement
                                INNER JOIN MovementDate AS MovementDate_OperDateStart
                                                        ON MovementDate_OperDateStart.MovementId = Movement.Id
                                                       AND MovementDate_OperDateStart.DescId     = zc_MovementDate_OperDateStart()
                                                       AND MovementDate_OperDateStart.ValueData  <= CURRENT_DATE
 
                                INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                                        ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                                       AND MovementDate_OperDateEnd.DescId     = zc_MovementDate_OperDateEnd()
                                                       AND MovementDate_OperDateEnd.ValueData  >= CURRENT_DATE
                                INNER JOIN MovementLinkObject AS MLO_MedicalProgramSP
                                                              ON MLO_MedicalProgramSP.MovementId = Movement.Id
                                                             AND MLO_MedicalProgramSP.DescId = zc_MovementLink_MedicalProgramSP()
 
                                LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                      AND MovementItem.DescId     = zc_MI_Master()
                                                      AND MovementItem.isErased   = FALSE
 
 
                           WHERE Movement.DescId = zc_Movement_GoodsSP()
                             AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                          )                                
          , tmpContainerPDSum AS (SELECT Container.GoodsId           AS GoodsId
                                       , SUM(Container.RemainsPD)    AS RemainsPD
                                  FROM tmpContainerPD AS Container
                                  GROUP BY Container.GoodsId
                                  HAVING SUM(Container.RemainsPD) > 0
                                  )                           

        SELECT Price_Site.GoodsId                                           AS Id

             , Price_Site.Name                                              AS Name
             , Price_Site.NameUkr                                           AS NameUkr

             , zfCalc_PriceCash(Price_Site.Price, 
                                CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                                COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)                 AS Price
             , zfCalc_PriceCash(tmpContainerAll.PriceMin, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)                    AS PriceMin
             , zfCalc_PriceCash(tmpContainerAll.PriceMax, 
                             CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                             COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)                    AS PriceMax

             , Price_Site.Remains                                           AS Remains
             
             , Price_Site.isStealthBonuses                                  AS isDiscountExternal

             , COALESCE(tmpContainerPDSum.RemainsPD, 0) <> 0                AS isPartionDate

             , Price_Site.FormDispensingId
             , Object_FormDispensing.ValueData                              AS FormDispensingName
             , ObjectString_FormDispensing_NameUkr.ValueData                AS NameUkr
             , Price_Site.NumberPlates
             , Price_Site.QtyPackage
             , Price_Site.Multiplicity
             
        FROM tmpData AS Price_Site         

             LEFT JOIN tmpContainerAll ON tmpContainerAll.GoodsId = Price_Site.GoodsId
                          
             -- Соц Проект
             LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = Price_Site.GoodsMainId
                                 AND tmpGoodsSP.Ord     = 1 -- № п/п - на всякий случай

             LEFT JOIN tmpGoodsDiscount ON tmpGoodsDiscount.GoodsMainId = Price_Site.GoodsMainId
             
             LEFT JOIN tmpContainerPDSum ON tmpContainerPDSum.GoodsId = Price_Site.GoodsId

             LEFT JOIN Object AS Object_FormDispensing ON Object_FormDispensing.Id = Price_Site.FormDispensingId
             LEFT JOIN ObjectString AS ObjectString_FormDispensing_NameUkr
                                    ON ObjectString_FormDispensing_NameUkr.ObjectId = Object_FormDispensing.Id
                                   AND ObjectString_FormDispensing_NameUkr.DescId = zc_ObjectString_FormDispensing_NameUkr()   
       ;       

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 26.10.21                                                       *
*/

-- тест
-- select *, null as img_url from gpSelect_GoodsPrice_ForSite(394759, 1, 'uk', 0, 8, 0, '', zfCalc_UserSite())


-- select *, null as img_url from gpSelect_GoodsPrice_ForSite(0, 1, 'ru', 0, 8, 0, 'Гептрал', True, zfCalc_UserSite())

/*  select id, name as title, nameukr as  title_uk, price, remains as quantity, null as img_url, 
            priceunitmin, priceunitmax, isdiscountexternal, numberplates, qtypackage, formdispensingname, 
            ispartiondate
            from gpSelect_GoodsPrice_ForSite(0,  -1, 'uk', 0, 8, 0, 'Бустрикс вак', true, zfCalc_UserSite())*/
            
            
select * from gpSelect_GoodsPrice_ForSite(0,  -1, 'uk', 0, 8, 0, 'Аффида', false, zfCalc_UserSite())