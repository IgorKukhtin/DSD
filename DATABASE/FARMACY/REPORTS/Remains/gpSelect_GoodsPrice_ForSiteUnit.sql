-- Function: gpSelect_GoodsPrice_ForSite()

--DROP FUNCTION IF EXISTS gpSelect_GoodsPrice_ForSite_Ol (Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_GoodsPrice_ForSite (Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsPrice_ForSite(
    IN inCategoryId         Integer     ,  -- Группа
    IN inSortType           Integer     ,  -- Тип сортировка
    IN inSortLang           TVarChar    ,  -- По названию
    IN inStart              Integer     ,  -- Смещение
    IN inLimit              Integer     ,  -- Количество строк
    IN inProductId          Integer     ,  -- Только указанный товар
    IN inSearch             TVarChar    ,  -- Фильтр для ILIKE
    IN inUnitId             Integer     ,  -- Подразделение
    IN inisDiscountExternal Boolean     ,  -- Показывать товар участвующий в дисконтной программе
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id                Integer    -- Id товара

             , Name              TVarChar   -- Название русское
             , NameUkr           TVarChar   -- Название украинское если (есть)

             , Price             TFloat     -- Интернет цена
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
                                     COALESCE(tmpGoodsDiscount.isStealthBonuses, FALSE) OR 
                                     (COALESCE (Object_Goods_Retail.DiscontAmountSite, 0) > 0 OR
                                     COALESCE (Object_Goods_Retail.DiscontPercentSite, 0) > 0) 
                                     AND Object_Goods_Retail.DiscontSiteStart IS NOT NULL
                                     AND Object_Goods_Retail.DiscontSiteEnd IS NOT NULL  
                                     AND Object_Goods_Retail.DiscontSiteStart <= CURRENT_DATE
                                     AND Object_Goods_Retail.DiscontSiteEnd >= CURRENT_DATE  AS isStealthBonuses
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
          , tmpObject_Price AS (SELECT CASE WHEN PriceSite_DiscontStart.ValueData IS NOT NULL
                                             AND PriceSite_DiscontEnd.ValueData IS NOT NULL  
                                             AND PriceSite_DiscontStart.ValueData <= CURRENT_DATE
                                             AND PriceSite_DiscontEnd.ValueData >= CURRENT_DATE
                                             AND COALESCE (PriceSite_DiscontAmount.ValueData, 0) > 0
                                            THEN ROUND(CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                                             AND ObjectFloat_Goods_Price.ValueData > 0
                                                                 THEN ObjectFloat_Goods_Price.ValueData
                                                            ELSE ObjectFloat_Price_Value.ValueData
                                                       END - COALESCE (PriceSite_DiscontAmount.ValueData, 0), 2)
                                            WHEN PriceSite_DiscontStart.ValueData IS NOT NULL
                                             AND PriceSite_DiscontEnd.ValueData IS NOT NULL  
                                             AND PriceSite_DiscontStart.ValueData <= CURRENT_DATE
                                             AND PriceSite_DiscontEnd.ValueData >= CURRENT_DATE
                                             AND COALESCE (PriceSite_DiscontPercent.ValueData, 0) > 0 
                                            THEN ROUND(CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                                             AND ObjectFloat_Goods_Price.ValueData > 0
                                                                 THEN ObjectFloat_Goods_Price.ValueData
                                                            ELSE ObjectFloat_Price_Value.ValueData
                                                       END * (100 - COALESCE (PriceSite_DiscontPercent.ValueData, 0)) / 100, 1)
                                            ELSE CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                                       AND ObjectFloat_Goods_Price.ValueData > 0
                                                           THEN ObjectFloat_Goods_Price.ValueData
                                                      ELSE ObjectFloat_Price_Value.ValueData
                                                 END 
                                            END::TFloat :: TFloat                           AS Price
                             , Price_Goods.ChildObjectId               AS GoodsId
                        FROM ObjectLink AS ObjectLink_Price_Unit
                           LEFT JOIN ObjectLink AS Price_Goods
                                                ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                               AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                           LEFT JOIN ObjectFloat AS ObjectFloat_Price_Value
                                                 ON ObjectFloat_Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND ObjectFloat_Price_Value.DescId = zc_ObjectFloat_Price_Value()
                           -- Фикс цена для всей Сети
                           LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                  ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                                 AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                   ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                                  AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                           LEFT JOIN ObjectDate AS PriceSite_DiscontStart
                                                ON PriceSite_DiscontStart.ObjectId = Price_Goods.ChildObjectId
                                               AND PriceSite_DiscontStart.DescId = zc_ObjectDate_Goods_DiscontSiteStart()
                           LEFT JOIN ObjectDate AS PriceSite_DiscontEnd
                                                ON PriceSite_DiscontEnd.ObjectId = Price_Goods.ChildObjectId
                                               AND PriceSite_DiscontEnd.DescId = zc_ObjectDate_Goods_DiscontSiteEnd()
                           LEFT JOIN ObjectFloat AS PriceSite_DiscontAmount
                                                 ON PriceSite_DiscontAmount.ObjectId = Price_Goods.ChildObjectId
                                                AND PriceSite_DiscontAmount.DescId = zc_ObjectFloat_Goods_DiscontAmountSite()
                           LEFT JOIN ObjectFloat AS PriceSite_DiscontPercent
                                                 ON PriceSite_DiscontPercent.ObjectId = Price_Goods.ChildObjectId
                                                AND PriceSite_DiscontPercent.DescId = zc_ObjectFloat_Goods_DiscontPercentSite()
                        WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                          AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
                        )
          , tmpContainerPD AS (SELECT Container.ObjectId           AS GoodsId
                                    , SUM(CASE WHEN ObjectDate_ExpirationDate.ValueData <= CURRENT_DATE THEN Container.Amount ELSE 0 END)         AS Remains 
                                    , SUM(CASE WHEN NOT (ObjectDate_ExpirationDate.ValueData <= CURRENT_DATE)  THEN Container.Amount ELSE 0 END)  AS RemainsPD 
                               FROM Container
                                    INNER JOIN tmpPrice_Site ON tmpPrice_Site.GoodsId = Container.ObjectId
                                    INNER JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                                  AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                                    INNER JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                          ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId  
                                                         AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                                                         AND ObjectDate_ExpirationDate.ValueData <= vbDate_6

                                    INNER JOIN Object_Goods_Retail AS RetailAll ON RetailAll.Id  = Container.ObjectId  
                                    INNER JOIN Object_Goods_Main AS RetailMain ON RetailMain.Id  = RetailAll.GoodsMainId

                               WHERE Container.DescId = zc_Container_CountPartionDate()
                                 AND COALESCE(RetailMain.GoodsGroupId, 0) <> 394744
                                 AND Container.Amount <> 0
                                 AND (Container.WhereObjectId = inUnitId OR COALESCE (inUnitId, 0) = 0)
                                 AND Container.WhereObjectId in (SELECT tmpUnit.Id FROM tmpUnit)
                               GROUP BY Container.ObjectId  
                               HAVING SUM(Container.Amount) > 0
                               )
          , tmpContainerAll AS (SELECT Container.ObjectId           AS GoodsId
                                     , SUM(Container.Amount)        AS Remains 
                                FROM Container
                                     INNER JOIN tmpPrice_Site ON tmpPrice_Site.GoodsId = Container.ObjectId
                                WHERE Container.DescId = zc_Container_Count()
                                  AND (Container.WhereObjectId = inUnitId OR COALESCE (inUnitId, 0) = 0)
                                  AND Container.WhereObjectId in (SELECT tmpUnit.Id FROM tmpUnit)
                                GROUP BY Container.ObjectId  
                                HAVING SUM(Container.Amount) > 0
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
                     -- Товары дисконтной программы
          , tmpUnitDiscount AS (SELECT ObjectLink_DiscountExternal.ChildObjectId     AS DiscountExternalId
                                     , ObjectLink_Unit.ChildObjectId                  AS UnitId
                                FROM Object AS Object_DiscountExternalTools
                                      LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                                           ON ObjectLink_DiscountExternal.ObjectId = Object_DiscountExternalTools.Id
                                                          AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountExternalTools_DiscountExternal()
                                      LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                           ON ObjectLink_Unit.ObjectId = Object_DiscountExternalTools.Id
                                                          AND ObjectLink_Unit.DescId = zc_ObjectLink_DiscountExternalTools_Unit()
                                 WHERE Object_DiscountExternalTools.DescId = zc_Object_DiscountExternalTools()
                                   AND Object_DiscountExternalTools.isErased = False
                                   AND ObjectLink_Unit.ChildObjectId = inUnitId
                                 )
                              
          -- Товары дисконтной программы
          , tmpGoodsUnitDiscount AS (SELECT tmpUnitDiscount.UnitId                                 AS UnitId
                                          , ObjectLink_BarCode_Goods.ChildObjectId                 AS GoodsId
                                          , tmpUnitDiscount.DiscountExternalId                     AS DiscountExternalId
                                          , COALESCE (ObjectBoolean_DiscountSite.ValueData, False) AS isDiscountSite
                                                       
                                          , MAX(ObjectFloat_MaxPrice.ValueData)                    AS MaxPrice 
                                          , MAX(ObjectFloat_DiscountProcent.ValueData)             AS DiscountProcent 
                                                                                   
                                      FROM Object AS Object_BarCode

                                           LEFT JOIN ObjectBoolean AS ObjectBoolean_DiscountSite
                                                                    ON ObjectBoolean_DiscountSite.ObjectId = Object_BarCode.Id
                                                                   AND ObjectBoolean_DiscountSite.DescId = zc_ObjectBoolean_BarCode_DiscountSite()
                                                                   AND ObjectBoolean_DiscountSite.ValueData = True

                                           LEFT JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                                                ON ObjectLink_BarCode_Goods.ObjectId = Object_BarCode.Id
                                                               AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
                                               
                                           LEFT JOIN ObjectLink AS ObjectLink_BarCode_Object
                                                                ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                                                               AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()
                                           LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_BarCode_Object.ChildObjectId           

                                           LEFT JOIN tmpUnitDiscount ON tmpUnitDiscount.DiscountExternalId = ObjectLink_BarCode_Object.ChildObjectId 

                                           LEFT JOIN ObjectFloat AS ObjectFloat_MaxPrice
                                                                 ON ObjectFloat_MaxPrice.ObjectId = Object_BarCode.Id
                                                                AND ObjectFloat_MaxPrice.DescId = zc_ObjectFloat_BarCode_MaxPrice()
                                           LEFT JOIN ObjectFloat AS ObjectFloat_DiscountProcent
                                                                 ON ObjectFloat_DiscountProcent.ObjectId = Object_BarCode.Id
                                                                AND ObjectFloat_DiscountProcent.DescId = zc_ObjectFloat_BarCode_DiscountProcent()

                                     WHERE Object_BarCode.DescId = zc_Object_BarCode()
                                       AND Object_BarCode.isErased = False
                                       AND Object_Object.isErased = False
                                       AND COALESCE (tmpUnitDiscount.DiscountExternalId, 0) <> 0
                                       AND ObjectLink_BarCode_Goods.ChildObjectId in (SELECT DISTINCT tmpPrice_Site.GoodsId FROM tmpPrice_Site)
                                     GROUP BY tmpUnitDiscount.UnitId
                                            , ObjectLink_BarCode_Goods.ChildObjectId
                                            , ObjectBoolean_DiscountSite.ValueData
                                            , tmpUnitDiscount.DiscountExternalId 
                              )
       , tmpRemainsDiscount AS (SELECT Container.ObjectId         AS GoodsId
                                     , Container.WhereObjectId    AS UnitId
                                     , SUM(Container.Amount)      AS Amount
                                FROM (SELECT DISTINCT tmpGoodsUnitDiscount.GoodsId, tmpGoodsUnitDiscount.DiscountExternalId FROM tmpGoodsUnitDiscount) AS GoodsDiscount
                                
                                     JOIN Container ON Container.ObjectId = GoodsDiscount.GoodsId
                                                   AND Container.Amount >= 1
                                                   AND Container.DescId = zc_Container_Count() 
                                                   AND Container.WhereObjectId = inUnitId
   
                                     JOIN containerlinkobject AS CLI_MI
                                                          ON CLI_MI.containerid = Container.Id
                                                         AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
                                     LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                                     -- элемент прихода
                                     LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                     -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                     LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                                 ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                                AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                     -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                     LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                                                                          -- AND 1=0
                                     LEFT OUTER JOIN MovementItemDate AS MIDate_ExpirationDate
                                                                      ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                                                     AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                                     LEFT OUTER JOIN Movement AS Movement_Income
                                                              ON Movement_Income.Id = COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)  --Object_PartionMovementItem.ObjectCode

                                     LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                  ON MovementLinkObject_From.MovementId = COALESCE (MI_Income_find.MovementId ,MI_Income.MovementId)
                                                                 AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                        
                                     LEFT JOIN Container AS ContainerPD
                                                         ON ContainerPD.ParentId = Container.Id
                                                        AND ContainerPD.Amount > 0
                                                        AND ContainerPD.DescId = zc_Container_CountPartionDate()
                                                        
                                     LEFT JOIN gpSelect_Object_DiscountExternalSupplier(inSession := inSession) AS DiscountExternalSupplier
                                                                                                                ON DiscountExternalSupplier.isErased = False
                                                                                                               AND DiscountExternalSupplier.DiscountExternalId =  GoodsDiscount.DiscountExternalId
                                                                                                               AND DiscountExternalSupplier.JuridicalId = MovementLinkObject_From.ObjectId
                                                        
                               WHERE COALESCE (ContainerPD.Id, 0) = 0
                                 AND COALESCE (DiscountExternalSupplier.DiscountExternalId, 0) <> 0
                               GROUP BY Container.ObjectId
                                      , Container.WhereObjectId
         )
                           

        SELECT Price_Site.GoodsId                                           AS Id

             , Price_Site.Name                                              AS Name
             , Price_Site.NameUkr                                           AS NameUkr

             , COALESCE (NULLIF(CASE WHEN COALESCE (RemainsDiscount.GoodsId, 0) = 0 OR COALESCE (inUnitId, 0) = 0 OR COALESCE(tmpContainerAll.Remains - COALESCE (tmpContainerPD.Remains, 0), 0) <= 0
                                     THEN NULL
                                     WHEN COALESCE(tmpObject_Price.Price, 0) > 0 AND COALESCE (GoodsDiscount.DiscountProcent, 0) > 0 AND GoodsDiscount.isDiscountSite = TRUE
                                     THEN ROUND(CASE WHEN COALESCE(GoodsDiscount.MaxPrice, 0) = 0 OR tmpObject_Price.Price < GoodsDiscount.MaxPrice
                                                     THEN tmpObject_Price.Price ELSE GoodsDiscount.MaxPrice END * (100 - GoodsDiscount.DiscountProcent) / 100, 1)
                                     ELSE NULL END, 0),
               zfCalc_PriceCash(CASE WHEN COALESCE (inUnitId, 0) <> 0 AND COALESCE(tmpContainerAll.Remains - COALESCE (tmpContainerPD.Remains, 0), 0) <= 0
                                THEN Null
                                WHEN COALESCE (inUnitId, 0) <> 0
                                THEN tmpObject_Price.Price
                                ELSE Price_Site.Price END, 
                                CASE WHEN tmpGoodsSP.GoodsId IS NULL THEN FALSE ELSE TRUE END OR
                                COALESCE(tmpGoodsDiscount.GoodsDiscountId, 0) <> 0)) ::TFloat    AS Price
             , (tmpContainerAll.Remains - COALESCE (tmpContainerPD.Remains, 0))::TFloat          AS Remains

             , Price_Site.isStealthBonuses                                  AS isDiscountExternal

             , COALESCE(tmpContainerPDSum.RemainsPD, 0) <> 0                AS isPartionDate

             , Price_Site.FormDispensingId
             , Object_FormDispensing.ValueData                              AS FormDispensingName
             , ObjectString_FormDispensing_NameUkr.ValueData                AS NameUkr
             , Price_Site.NumberPlates
             , Price_Site.QtyPackage
             , Price_Site.Multiplicity
             
        FROM tmpPrice_Site AS Price_Site         

             LEFT JOIN tmpContainerAll ON tmpContainerAll.GoodsId = Price_Site.GoodsId
             
             LEFT JOIN tmpContainerPD ON tmpContainerPD.GoodsId = Price_Site.GoodsId
             
             LEFT JOIN tmpObject_Price ON tmpObject_Price.GoodsId = Price_Site.GoodsId
             
             -- Соц Проект
             LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = Price_Site.GoodsMainId
                                 AND tmpGoodsSP.Ord     = 1 -- № п/п - на всякий случай

             LEFT JOIN tmpGoodsDiscount ON tmpGoodsDiscount.GoodsMainId = Price_Site.GoodsMainId

             LEFT JOIN tmpContainerPDSum ON tmpContainerPDSum.GoodsId = Price_Site.GoodsId

             LEFT JOIN Object AS Object_FormDispensing ON Object_FormDispensing.Id = Price_Site.FormDispensingId
             LEFT JOIN ObjectString AS ObjectString_FormDispensing_NameUkr
                                    ON ObjectString_FormDispensing_NameUkr.ObjectId = Object_FormDispensing.Id
                                   AND ObjectString_FormDispensing_NameUkr.DescId = zc_ObjectString_FormDispensing_NameUkr()   

             LEFT JOIN tmpGoodsUnitDiscount AS GoodsDiscount
                                            ON GoodsDiscount.GoodsId = Price_Site.GoodsId  
                                           AND GoodsDiscount.UnitId = inUnitId
             LEFT JOIN tmpRemainsDiscount AS RemainsDiscount
                                          ON RemainsDiscount.GoodsId = Price_Site.GoodsId  
                                         AND RemainsDiscount.UnitId = inUnitId

        ORDER BY CASE WHEN COALESCE (tmpContainerAll.Remains, 0) = 0 THEN 1 ELSE 0 END 
               , CASE WHEN inSortType = 0 THEN Price_Site.Price END
               , CASE WHEN inSortType = 1 THEN Price_Site.Price END DESC
               , CASE WHEN inSortType = 2 THEN CASE WHEN lower(inSortLang) = 'uk' THEN Price_Site.NameUkr ELSE Price_Site.Name END END
               , CASE WHEN inSortType = 3 THEN CASE WHEN lower(inSortLang) = 'uk' THEN Price_Site.NameUkr ELSE Price_Site.Name END END DESC
               , Price_Site.Name
        LIMIT inLimit OFFSET inStart                                                                                                                 
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
--
 
SELECT * FROM gpSelect_GoodsPrice_ForSite (inCategoryId := 0 , inSortType := 0, inSortLang := 'uk', inStart := 0, inLimit := 100, inProductId := 0, inSearch := 'Гептрал', inUnitId := 13711869, inisDiscountExternal := True , inSession:= zfCalc_UserSite());