-- Function: gpSelect_GoodsPrice_ForSite()

--DROP FUNCTION IF EXISTS gpSelect_GoodsPrice_ForSite (Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_GoodsPrice_ForSite (Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsPrice_ForSite(
    IN inCategoryId         Integer     ,  -- ������
    IN inSortType           Integer     ,  -- ��� ����������
    IN inSortLang           TVarChar    ,  -- �� ��������
    IN inStart              Integer     ,  -- ��������
    IN inLimit              Integer     ,  -- ���������� �����
    IN inProductId          Integer     ,  -- ������ ��������� �����
    IN inSearch             TVarChar    ,  -- ������ ��� ILIKE
    IN inisDiscountExternal Boolean     ,  -- ���������� ����� ����������� � ���������� ���������
    IN inSession            TVarChar       -- ������ ������������
)
RETURNS TABLE (Id                Integer    -- Id ������

             , Name              TVarChar   -- �������� �������
             , NameUkr           TVarChar   -- �������� ���������� ���� (����)

             , Price             TFloat     -- �������� ����
             
             , PriceUnitMin      TFloat     -- ����������� ���� �������������
             , PriceUnitMax      TFloat     -- ������������ ���� �������������
             , Remains           TFloat     -- ������� �� ����
             
             , isDiscountExternal boolean   -- ����� ��������� � ���������� ���������
             , isPartionDate      boolean   -- ���� ����� �� ������ ��������

             , FormDispensingId Integer     -- ����� �������
             , FormDispensingName TVarChar
             , FormDispensingNameUkr TVarChar
             , NumberPlates Integer         -- ���-�� ������� � ��������  
             , QtyPackage Integer           -- ���-�� � ��������
             , Multiplicity TFloat          -- ����������� ��������� ��� �������
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

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    -- vbUserId:= lpGetUserBySession (inSession);
    vbUserId:= inSession :: Integer;

    -- ������������ <�������� ����>
    vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', ABS (vbUserId));

    -- �������� ��� ���������� �� ������
    SELECT Date_6, Date_3, Date_1, Date_0
    INTO vbDate_6, vbDate_3, vbDate_1, vbDate_0
    FROM lpSelect_PartionDateKind_SetDate ();
    
    inStart := COALESCE (inStart, 0);
    if COALESCE (inLimit, 0) <= 0
    THEN
      inLimit := 100000;
    END IF;

--raise notice 'Value 1: %', CLOCK_TIMESTAMP();

    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpUnit'))
    THEN
      DROP TABLE tmpUnit;
    END IF;

    CREATE TEMP TABLE tmpUnit ON COMMIT DROP AS
    SELECT tmp.Id 
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
                              AND OL_Unit_Area.DescId   = zc_ObjectLink_Unit_Area();
                              
    ANALYSE tmpUnit;

--raise notice 'Value 2: %', CLOCK_TIMESTAMP();


    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpGoodsDiscount'))
    THEN
      DROP TABLE tmpGoodsDiscount;
    END IF;

    CREATE TEMP TABLE tmpGoodsDiscount ON COMMIT DROP AS
    SELECT Object_Goods_Retail.GoodsMainId                           AS GoodsMainId
         , Object_Object.Id                                          AS GoodsDiscountId
         , Object_Object.ValueData                                   AS GoodsDiscountName
         , COALESCE(ObjectBoolean_GoodsForProject.ValueData, False)  AS isGoodsForProject
         , COALESCE(ObjectBoolean_StealthBonuses.ValueData, False)   AS isStealthBonuses 

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

    WHERE Object_BarCode.DescId = zc_Object_BarCode()
      AND Object_BarCode.isErased = False
    GROUP BY Object_Goods_Retail.GoodsMainId
           , Object_Object.Id
           , Object_Object.ValueData
           , COALESCE(ObjectBoolean_GoodsForProject.ValueData, False)
           , COALESCE(ObjectBoolean_StealthBonuses.ValueData, False);
                              
    ANALYSE tmpGoodsDiscount;

--raise notice 'Value 3: %', CLOCK_TIMESTAMP();

    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpPrice_Site'))
    THEN
      DROP TABLE tmpPrice_Site;
    END IF;

    CREATE TEMP TABLE tmpPrice_Site ON COMMIT DROP AS
    SELECT ROUND(Price_Value.ValueData,2)::TFloat     AS Price
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
           COALESCE(tmpGoodsDiscount.isStealthBonuses, FALSE)) = FALSE);
                              
    ANALYSE tmpPrice_Site;

--raise notice 'Value 4: %', CLOCK_TIMESTAMP();

    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpContainerRemainsPD'))
    THEN
      DROP TABLE tmpContainerRemainsPD;
    END IF;

    CREATE TEMP TABLE tmpContainerRemainsPD ON COMMIT DROP AS
    SELECT Container.ObjectId           AS GoodsId
         , SUM(Container.Amount)        AS Remains 
    FROM Container
         INNER JOIN tmpPrice_Site ON tmpPrice_Site.GoodsId = Container.ObjectId
         INNER JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                       AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

         INNER JOIN ObjectDate AS ObjectDate_ExpirationDate
                               ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId  
                              AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                              AND ObjectDate_ExpirationDate.ValueData <= CURRENT_DATE

         LEFT JOIN Object_Goods_Retail AS RetailAll ON RetailAll.Id  = Container.ObjectId  
         LEFT JOIN Object_Goods_Main AS RetailMain ON RetailMain.Id  = RetailAll.GoodsMainId
                                           
    WHERE Container.DescId = zc_Container_CountPartionDate()
      AND Container.Amount <> 0
      AND Container.WhereObjectId in (SELECT tmpUnit.Id FROM tmpUnit)
      AND COALESCE(RetailMain.GoodsGroupId, 0) <> 394744
    GROUP BY Container.ObjectId  
    HAVING SUM(Container.Amount) > 0;
                              
    ANALYSE tmpContainerRemainsPD;

--raise notice 'Value 5: % %', CLOCK_TIMESTAMP(), vbDate_6;
                                     
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpContainerRemains'))
    THEN
      DROP TABLE tmpContainerRemains;
    END IF;

    CREATE TEMP TABLE tmpContainerRemains ON COMMIT DROP AS
    SELECT Container.ObjectId           AS GoodsId
         , SUM(Container.Amount)        AS Remains 
    FROM Container
         INNER JOIN tmpPrice_Site ON tmpPrice_Site.GoodsId = Container.ObjectId
    WHERE Container.DescId = zc_Container_Count()
      AND Container.Amount <> 0
      AND Container.WhereObjectId in (SELECT tmpUnit.Id FROM tmpUnit)
    GROUP BY Container.ObjectId  
    HAVING SUM(Container.Amount) > 0;
                              
    ANALYSE tmpContainerRemains;
    
--raise notice 'Value 6: %', CLOCK_TIMESTAMP();


    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpData'))
    THEN
      DROP TABLE tmpData;
    END IF;

    CREATE TEMP TABLE tmpData ON COMMIT DROP AS
    SELECT Price_Site.GoodsId
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
                             
         , ROW_NUMBER() OVER (ORDER BY CASE WHEN (COALESCE (tmpContainerRemains.Remains, 0) - COALESCE (tmpContainerRemainsPD.Remains, 0)) <= 0 THEN 1 ELSE 0 END 
                                     , CASE WHEN inSortType = 0 THEN Price_Site.Price END
                                     , CASE WHEN inSortType = 1 THEN Price_Site.Price END DESC
                                     , CASE WHEN inSortType = 2 THEN CASE WHEN lower(inSortLang) = 'uk' THEN Price_Site.NameUkr ELSE Price_Site.Name END END
                                     , CASE WHEN inSortType = 3 THEN CASE WHEN lower(inSortLang) = 'uk' THEN Price_Site.NameUkr ELSE Price_Site.Name END END DESC
                                     , CASE WHEN Price_Site.Name ILIKE inSearch||'%' OR
                                                 Price_Site.NameUkr ILIKE inSearch||'%' THEN 0 ELSE 1 END 
                                     , Price_Site.Name) AS Ord
                              
    FROM tmpPrice_Site AS tmpGoods 
                        
         LEFT JOIN tmpPrice_Site AS Price_Site ON Price_Site.GoodsId = tmpGoods.GoodsId      

         LEFT JOIN tmpContainerRemains ON tmpContainerRemains.GoodsId = Price_Site.GoodsId

         LEFT JOIN tmpContainerRemainsPD ON tmpContainerRemainsPD.GoodsId = Price_Site.GoodsId
                                            
    ORDER BY CASE WHEN (COALESCE (tmpContainerRemains.Remains, 0) - COALESCE (tmpContainerRemainsPD.Remains, 0)) <= 0 THEN 1 ELSE 0 END 
           , CASE WHEN inSortType = 0 THEN Price_Site.Price END
           , CASE WHEN inSortType = 1 THEN Price_Site.Price END DESC
           , CASE WHEN inSortType = 2 THEN CASE WHEN lower(inSortLang) = 'uk' THEN Price_Site.NameUkr ELSE Price_Site.Name END END
           , CASE WHEN inSortType = 3 THEN CASE WHEN lower(inSortLang) = 'uk' THEN Price_Site.NameUkr ELSE Price_Site.Name END END DESC
           , CASE WHEN Price_Site.Name ILIKE inSearch||'%' OR
                       Price_Site.NameUkr ILIKE inSearch||'%' THEN 0 ELSE 1 END 
           , Price_Site.Name
    LIMIT inLimit OFFSET inStart;
                              
    ANALYSE tmpData;
    
--raise notice 'Value 7: %', CLOCK_TIMESTAMP();      
    
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpContainer'))
    THEN
      DROP TABLE tmpContainer;
    END IF;

    CREATE TEMP TABLE tmpContainer ON COMMIT DROP AS
    SELECT Container.WhereObjectId      AS UnitId
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
    HAVING SUM(Container.Amount) > 0;
                              
    ANALYSE tmpContainer;
    
--raise notice 'Value 8: %', CLOCK_TIMESTAMP();
    
                                    
    -- ���������
    RETURN QUERY
    WITH  -- ������ ���������� ���������
          tmpUnitDiscount AS (SELECT ObjectLink_DiscountExternal.ChildObjectId     AS DiscountExternalId
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
                                 )
          -- ������ ���������� ���������
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
                                       AND ObjectLink_BarCode_Goods.ChildObjectId in (SELECT DISTINCT tmpData.GoodsId FROM tmpData)
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
   
                                     JOIN containerlinkobject AS CLI_MI
                                                          ON CLI_MI.containerid = Container.Id
                                                         AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
                                     LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
                                     -- ������� �������
                                     LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                     -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                                     LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                                 ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                                AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                     -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
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
                                                        
                                     LEFT JOIN gpSelect_Object_DiscountExternalSupplier(inIsErased := False, inSession := inSession) AS DiscountExternalSupplier
                                                                                                                ON DiscountExternalSupplier.isErased = False
                                                                                                               AND DiscountExternalSupplier.DiscountExternalId =  GoodsDiscount.DiscountExternalId
                                                                                                               AND DiscountExternalSupplier.JuridicalId = MovementLinkObject_From.ObjectId
                                                        
                               WHERE COALESCE (ContainerPD.Id, 0) = 0
                                 AND COALESCE (DiscountExternalSupplier.DiscountExternalId, 0) <> 0
                               GROUP BY Container.ObjectId
                                      , Container.WhereObjectId)
          , tmpPriceChange AS (SELECT DISTINCT ObjectLink_PriceChange_Goods.ChildObjectId        AS GoodsId
                                    , PriceChange_Value_Retail.ValueData                         AS PriceChange
                                    , PriceChange_FixPercent_Retail.ValueData                    AS FixPercent
                                    , PriceChange_FixDiscount_Retail.ValueData                   AS FixDiscount
                                    , PriceChange_Multiplicity_Retail.ValueData                  AS Multiplicity
                               FROM Object AS Object_PriceChange
       
                                    -- ������ �� ����
                                    LEFT JOIN ObjectLink AS ObjectLink_PriceChange_Retail
                                                         ON ObjectLink_PriceChange_Retail.ObjectId = Object_PriceChange.Id
                                                        AND ObjectLink_PriceChange_Retail.DescId = zc_ObjectLink_PriceChange_Retail()
                                                        AND ObjectLink_PriceChange_Retail.ChildObjectId = vbObjectId
                                    -- ���� �� ������� �� ����
                                    LEFT JOIN ObjectFloat AS PriceChange_Value_Retail
                                                          ON PriceChange_Value_Retail.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                         AND PriceChange_Value_Retail.DescId = zc_ObjectFloat_PriceChange_Value()
                                    -- ������� ������ �� ����.
                                    LEFT JOIN ObjectFloat AS PriceChange_FixPercent_Retail
                                                          ON PriceChange_FixPercent_Retail.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                         AND PriceChange_FixPercent_Retail.DescId = zc_ObjectFloat_PriceChange_FixPercent()
                                    -- ����� ������ �� ����.
                                    LEFT JOIN ObjectFloat AS PriceChange_FixDiscount_Retail
                                                          ON PriceChange_FixDiscount_Retail.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                         AND PriceChange_FixDiscount_Retail.DescId = zc_ObjectFloat_PriceChange_FixDiscount()
                                    -- ��������� ������� �� ����.
                                    LEFT JOIN ObjectFloat AS PriceChange_Multiplicity_Retail
                                                          ON PriceChange_Multiplicity_Retail.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                         AND PriceChange_Multiplicity_Retail.DescId = zc_ObjectFloat_PriceChange_Multiplicity()
                                    -- ���� ��������� �������� ������ �� ����.
                                    LEFT JOIN ObjectDate AS PriceChange_FixEndDate_Retail
                                                         ON PriceChange_FixEndDate_Retail.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                        AND PriceChange_FixEndDate_Retail.DescId = zc_ObjectDate_PriceChange_FixEndDate()

                                    LEFT JOIN ObjectLink AS ObjectLink_PriceChange_PartionDateKind_Retail
                                                          ON ObjectLink_PriceChange_PartionDateKind_Retail.ObjectId  = ObjectLink_PriceChange_Retail.ObjectId
                                                         AND ObjectLink_PriceChange_PartionDateKind_Retail.DescId    = zc_ObjectLink_PriceChange_PartionDateKind()

                                    LEFT JOIN ObjectLink AS ObjectLink_PriceChange_Goods
                                                         ON ObjectLink_PriceChange_Goods.ObjectId = ObjectLink_PriceChange_Retail.ObjectId
                                                        AND ObjectLink_PriceChange_Goods.DescId = zc_ObjectLink_PriceChange_Goods()

                               WHERE Object_PriceChange.DescId = zc_Object_PriceChange()
                                 AND Object_PriceChange.isErased = FALSE
                                 AND (COALESCE (PriceChange_Value_Retail.ValueData, 0) <> 0 OR
                                     COALESCE (PriceChange_FixPercent_Retail.ValueData, 0) <> 0 OR
                                     COALESCE (PriceChange_FixDiscount_Retail.ValueData, 0) <> 0)
                                 AND COALESCE (PriceChange_Multiplicity_Retail.ValueData, 0) IN (0, 1)
                                 AND COALESCE (PriceChange_FixEndDate_Retail.ValueData, CURRENT_DATE) >= CURRENT_DATE   
                                 AND COALESCE (ObjectLink_PriceChange_PartionDateKind_Retail.ChildObjectId, 0) = 0 
                              )
          , tmpPriceChangeUnit AS (SELECT DISTINCT ObjectLink_PriceChange_Goods.ChildObjectId        AS GoodsId
                                        , ObjectLink_PriceChange_Unit.ChildObjectId                  AS UnitId
                                        , PriceChange_Value_Unit.ValueData                           AS PriceChange
                                        , PriceChange_FixPercent_Unit.ValueData                      AS FixPercent
                                        , PriceChange_FixDiscount_Unit.ValueData                     AS FixDiscount
                                        , PriceChange_Multiplicity_Unit.ValueData                    AS Multiplicity
                                   FROM Object AS Object_PriceChange
                                        -- ������ �� �������
                                        LEFT JOIN ObjectLink AS ObjectLink_PriceChange_Unit
                                                             ON ObjectLink_PriceChange_Unit.ObjectId = Object_PriceChange.Id
                                                            AND ObjectLink_PriceChange_Unit.DescId = zc_ObjectLink_PriceChange_Unit()
                                                            AND ObjectLink_PriceChange_Unit.ChildObjectId <> 0
                                        -- ���� �� ������� �� �������.
                                        LEFT JOIN ObjectFloat AS PriceChange_Value_Unit
                                                              ON PriceChange_Value_Unit.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                             AND PriceChange_Value_Unit.DescId = zc_ObjectFloat_PriceChange_Value()
                                                             AND COALESCE (PriceChange_Value_Unit.ValueData, 0) <> 0
                                        -- ������� ������ �� �������.
                                        LEFT JOIN ObjectFloat AS PriceChange_FixPercent_Unit
                                                              ON PriceChange_FixPercent_Unit.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                             AND PriceChange_FixPercent_Unit.DescId = zc_ObjectFloat_PriceChange_FixPercent()
                                                             AND COALESCE (PriceChange_FixPercent_Unit.ValueData, 0) <> 0
                                        -- ����� ������ �� �������.
                                        LEFT JOIN ObjectFloat AS PriceChange_FixDiscount_Unit
                                                              ON PriceChange_FixDiscount_Unit.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                             AND PriceChange_FixDiscount_Unit.DescId = zc_ObjectFloat_PriceChange_FixDiscount()
                                                             AND COALESCE (PriceChange_FixDiscount_Unit.ValueData, 0) <> 0
                                        -- ��������� �������
                                        LEFT JOIN ObjectFloat AS PriceChange_Multiplicity_Unit
                                                              ON PriceChange_Multiplicity_Unit.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                             AND PriceChange_Multiplicity_Unit.DescId = zc_ObjectFloat_PriceChange_Multiplicity()
                                                             AND COALESCE (PriceChange_Multiplicity_Unit.ValueData, 0) <> 0
                                        -- ���� ��������� �������� ������
                                        LEFT JOIN ObjectDate AS PriceChange_FixEndDate_Unit
                                                             ON PriceChange_FixEndDate_Unit.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                            AND PriceChange_FixEndDate_Unit.DescId = zc_ObjectDate_PriceChange_FixEndDate()
                                                                
                                        LEFT JOIN ObjectLink AS ObjectLink_PriceChange_PartionDateKind_Unit
                                                             ON ObjectLink_PriceChange_PartionDateKind_Unit.ObjectId  = ObjectLink_PriceChange_Unit.ObjectId
                                                            AND ObjectLink_PriceChange_PartionDateKind_Unit.DescId    = zc_ObjectLink_PriceChange_PartionDateKind()

                                        LEFT JOIN ObjectLink AS ObjectLink_PriceChange_Goods
                                                             ON ObjectLink_PriceChange_Goods.ObjectId = ObjectLink_PriceChange_Unit.ObjectId
                                                            AND ObjectLink_PriceChange_Goods.DescId = zc_ObjectLink_PriceChange_Goods()
                                                                
                                   WHERE Object_PriceChange.DescId = zc_Object_PriceChange()
                                     AND Object_PriceChange.isErased = FALSE
                                     AND (COALESCE (PriceChange_Value_Unit.ValueData, 0) <> 0 OR
                                         COALESCE (PriceChange_FixPercent_Unit.ValueData, 0) <> 0 OR
                                         COALESCE (PriceChange_FixDiscount_Unit.ValueData, 0) <> 0)
                                     AND COALESCE (PriceChange_Multiplicity_Unit.ValueData, 0) IN (0, 1)
                                     AND COALESCE (PriceChange_FixEndDate_Unit.ValueData, CURRENT_DATE) >= CURRENT_DATE   
                                     AND COALESCE (ObjectLink_PriceChange_PartionDateKind_Unit.ChildObjectId, 0) = 0 
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
                                                         AND ObjectDate_ExpirationDate.ValueData <= vbDate_6

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
          , tmpPromoBonus AS (SELECT PromoBonus.GoodsID
                                   , PromoBonus.UnitID
                                   , PromoBonus.MarginPercent
                                   , PromoBonus.BonusInetOrder 
                              FROM gpSelect_PromoBonus_MarginPercent(inUnitId := 0,  inSession := inSession) AS PromoBonus 
                              WHERE PromoBonus.BonusInetOrder > 0)
          , tmpContainerAll AS (SELECT Price_Goods.ChildObjectId            AS GoodsId
                                     , MIN(COALESCE (NULLIF(CASE WHEN COALESCE (RemainsDiscount.GoodsId, 0) = 0
                                                                 THEN NULL
                                                                 WHEN COALESCE(Price_Value.ValueData, 0) > 0 AND COALESCE (GoodsDiscount.DiscountProcent, 0) > 0 AND GoodsDiscount.isDiscountSite = TRUE
                                                                 THEN ROUND(CASE WHEN COALESCE(GoodsDiscount.MaxPrice, 0) = 0 OR Price_Value.ValueData < GoodsDiscount.MaxPrice
                                                                                 THEN Price_Value.ValueData ELSE GoodsDiscount.MaxPrice END * (100 - GoodsDiscount.DiscountProcent) / 100, 1)
                                                                 ELSE NULL END, 0),
                                           CASE WHEN tmpPrice_Site.DiscontSiteStart IS NOT NULL
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
                                                          WHEN COALESCE (tmpPriceChangeUnit.PriceChange, tmpPriceChange.PriceChange, 0) = 0 
                                                            AND tmpPrice_Site.IsTop = FALSE AND COALESCE (tmpPromoBonus.BonusInetOrder, 0) > 0
                                                          THEN Round(Price_Value.ValueData * 100.0 / (100.0 + tmpPromoBonus.MarginPercent) * 
                                                                     (100.0 - tmpPromoBonus.BonusInetOrder + tmpPromoBonus.MarginPercent) / 100, 2)
                                                          ELSE ROUND (CASE WHEN COALESCE (tmpPriceChangeUnit.PriceChange, tmpPriceChange.PriceChange, 0) > 0 
                                                                           THEN COALESCE (tmpPriceChangeUnit.PriceChange, tmpPriceChange.PriceChange, 0)
                                                                           WHEN COALESCE (tmpPriceChangeUnit.FixPercent, tmpPriceChange.FixPercent, 0) > 0 
                                                                           THEN Price_Value.ValueData * (100.0 - COALESCE (tmpPriceChangeUnit.FixPercent, tmpPriceChange.FixPercent, 0)) / 100.0
                                                                           WHEN COALESCE (tmpPriceChangeUnit.FixDiscount, tmpPriceChange.FixDiscount, 0) > 0 AND Price_Value.ValueData > COALESCE (tmpPriceChangeUnit.FixDiscount, tmpPriceChange.FixDiscount, 0)
                                                                           THEN Price_Value.ValueData - COALESCE (tmpPriceChangeUnit.FixDiscount, tmpPriceChange.FixDiscount, 0) 
                                                                           ELSE Price_Value.ValueData END, 2) END
                                                END))           AS PriceMin
                                     , MAX(COALESCE (NULLIF(CASE WHEN COALESCE (RemainsDiscount.GoodsId, 0) = 0
                                                                 THEN NULL
                                                                 WHEN COALESCE(Price_Value.ValueData, 0) > 0 AND COALESCE (GoodsDiscount.DiscountProcent, 0) > 0 AND GoodsDiscount.isDiscountSite = TRUE
                                                                 THEN ROUND(CASE WHEN COALESCE(GoodsDiscount.MaxPrice, 0) = 0 OR Price_Value.ValueData < GoodsDiscount.MaxPrice
                                                                                 THEN Price_Value.ValueData ELSE GoodsDiscount.MaxPrice END * (100 - GoodsDiscount.DiscountProcent) / 100, 1)
                                                                 ELSE NULL END, 0),
                                           CASE WHEN tmpPrice_Site.DiscontSiteStart IS NOT NULL
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
                                                          WHEN COALESCE (tmpPriceChangeUnit.PriceChange, tmpPriceChange.PriceChange, 0) = 0 
                                                            AND tmpPrice_Site.IsTop = FALSE AND COALESCE (tmpPromoBonus.BonusInetOrder, 0) > 0
                                                          THEN Round(Price_Value.ValueData * 100.0 / (100.0 + tmpPromoBonus.MarginPercent) * 
                                                                     (100.0 - tmpPromoBonus.BonusInetOrder + tmpPromoBonus.MarginPercent) / 100, 2)
                                                          ELSE ROUND (CASE WHEN COALESCE (tmpPriceChangeUnit.PriceChange, tmpPriceChange.PriceChange, 0) > 0 
                                                                           THEN COALESCE (tmpPriceChangeUnit.PriceChange, tmpPriceChange.PriceChange, 0)
                                                                           WHEN COALESCE (tmpPriceChangeUnit.FixPercent, tmpPriceChange.FixPercent, 0) > 0 
                                                                           THEN Price_Value.ValueData * (100.0 - COALESCE (tmpPriceChangeUnit.FixPercent, tmpPriceChange.FixPercent, 0)) / 100.0
                                                                           WHEN COALESCE (tmpPriceChangeUnit.FixDiscount, tmpPriceChange.FixDiscount, 0) > 0 AND Price_Value.ValueData > COALESCE (tmpPriceChangeUnit.FixDiscount, tmpPriceChange.FixDiscount, 0)
                                                                           THEN Price_Value.ValueData - COALESCE (tmpPriceChangeUnit.FixDiscount, tmpPriceChange.FixDiscount, 0)
                                                                           ELSE Price_Value.ValueData END, 2) END
                                                END))           AS PriceMax
                                FROM ObjectLink AS Price_Goods
                                
                                     INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                                           ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                          AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                                         
                                     INNER JOIN tmpContainer ON tmpContainer.UnitId = ObjectLink_Price_Unit.ChildObjectId
                                                            AND tmpContainer.GoodsId = Price_Goods.ChildObjectId

                                     LEFT JOIN ObjectFloat AS Price_Value
                                                           ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                          AND Price_Value.DescId = zc_ObjectFloat_Price_Value()

                                     -- ���� ���� ��� ���� ����
                                     LEFT JOIN tmpPrice_Site  ON tmpPrice_Site.GoodsId = Price_Goods.ChildObjectId
                                     
                                     LEFT JOIN tmpContainerPD ON tmpContainerPD.GoodsId = Price_Goods.ChildObjectId
                                                             AND tmpContainerPD.UnitId = ObjectLink_Price_Unit.ChildObjectId

                                     LEFT JOIN tmpGoodsUnitDiscount AS GoodsDiscount
                                                                    ON GoodsDiscount.GoodsId = Price_Goods.ChildObjectId
                                                                   AND GoodsDiscount.UnitId = ObjectLink_Price_Unit.ChildObjectId
                                     LEFT JOIN tmpRemainsDiscount AS RemainsDiscount
                                                                  ON RemainsDiscount.GoodsId = Price_Goods.ChildObjectId
                                                                 AND RemainsDiscount.UnitId = ObjectLink_Price_Unit.ChildObjectId

                                     LEFT JOIN tmpPriceChangeUnit ON tmpPriceChangeUnit.GoodsId = Price_Goods.ChildObjectId
                                                                 AND tmpPriceChangeUnit.UnitId = ObjectLink_Price_Unit.ChildObjectId
                                     LEFT JOIN tmpPriceChange ON tmpPriceChange.GoodsId = Price_Goods.ChildObjectId
                                                             AND COALESCE (tmpPriceChangeUnit.GoodsId, 0) = 0
                                                             
                                     LEFT JOIN tmpPromoBonus ON tmpPromoBonus.GoodsId = Price_Goods.ChildObjectId
                                                            AND tmpPromoBonus.UnitId = ObjectLink_Price_Unit.ChildObjectId
                                     
                                WHERE Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                  AND Price_Goods.ChildObjectId in (SELECT tmpData.GoodsId FROM tmpData)    
                                  AND tmpContainer.Remains > COALESCE (tmpContainerPD.RemainsAll, 0)
                                GROUP BY Price_Goods.ChildObjectId 
                                )
          , tmpGoodsSP AS (SELECT MovementItem.ObjectId         AS GoodsId
                                                                -- � �/� - �� ������ ������
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
 
                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId     = zc_MI_Master()
                                                       AND MovementItem.isErased   = FALSE

                                INNER JOIN MovementItemFloat AS MIFloat_PriceSP
                                                             ON MIFloat_PriceSP.MovementItemId = MovementItem.Id
                                                            AND MIFloat_PriceSP.DescId = zc_MIFloat_PriceSP()
                                                            AND MIFloat_PriceSP.ValueData > 0
 
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
                          
             -- ��� ������
             LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = Price_Site.GoodsMainId
                                 AND tmpGoodsSP.Ord     = 1 -- � �/� - �� ������ ������

             LEFT JOIN tmpGoodsDiscount ON tmpGoodsDiscount.GoodsMainId = Price_Site.GoodsMainId
             
             LEFT JOIN tmpContainerPDSum ON tmpContainerPDSum.GoodsId = Price_Site.GoodsId

             LEFT JOIN Object AS Object_FormDispensing ON Object_FormDispensing.Id = Price_Site.FormDispensingId
             LEFT JOIN ObjectString AS ObjectString_FormDispensing_NameUkr
                                    ON ObjectString_FormDispensing_NameUkr.ObjectId = Object_FormDispensing.Id
                                   AND ObjectString_FormDispensing_NameUkr.DescId = zc_ObjectString_FormDispensing_NameUkr()  
                                   
        ORDER BY Price_Site.Ord
                                   
       ;    
       
--raise notice 'Value 20: %', CLOCK_TIMESTAMP();
          

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 26.10.21                                                       *
*/

-- ����
-- select *, null as img_url from gpSelect_GoodsPrice_ForSite(394759, 1, 'uk', 0, 8, 0, '', zfCalc_UserSite())


-- select *, null as img_url from gpSelect_GoodsPrice_ForSite(0, 1, 'ru', 0, 8, 0, '�������', True, zfCalc_UserSite())

/*  select id, name as title, nameukr as  title_uk, price, remains as quantity, null as img_url, 
            priceunitmin, priceunitmax, isdiscountexternal, numberplates, qtypackage, formdispensingname, 
            ispartiondate
            from gpSelect_GoodsPrice_ForSite(0,  -1, 'uk', 0, 8, 0, '�������� ���', true, zfCalc_UserSite())*/
            
            
select * from gpSelect_GoodsPrice_ForSite(0,  -1, 'uk', 0, 100, 0, '����', True, zfCalc_UserSite())