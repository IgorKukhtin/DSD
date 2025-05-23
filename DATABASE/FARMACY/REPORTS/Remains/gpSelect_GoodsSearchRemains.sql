-- Function: gpSelect_Movement_Income()

--DROP FUNCTION IF EXISTS gpSelect_GoodsSearchRemains (TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_GoodsSearchRemains (TVarChar, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsSearchRemains(
    IN inCodeSearch     TVarChar,    -- ����� ������� �� ����
    IN inGoodsSearch    TVarChar,    -- ����� �������
    IN inisRetail       Boolean,     -- ������ �� ����
    IN inSession        TVarChar     -- ������ ������������
)
RETURNS TABLE (Id integer, GoodsCode Integer, GoodsName TVarChar
             , NDSkindName TVarChar
             , NDS TFloat
             , GoodsGroupName TVarChar
             , UnitId integer, UnitName TVarChar
             , AreaName TVarChar
             , RetailName TVarChar
             , Address_Unit TVarChar
             , Phone_Unit TVarChar
             , ProvinceCityName_Unit TVarChar
             , JuridicalName_Unit TVarChar
             , Phone TVarChar
             , Amount TFloat
             , AmountIncome TFloat
             , AmountReserve TFloat
             , AmountAll TFloat
             , Price  TFloat
             , PriceSale  TFloat
             , SummaSale TFloat
             , DateChange TDateTime
             , PriceSaleIncome  TFloat
             , MinExpirationDate TDateTime
             , DailyCheck TFloat
             , DailySale TFloat
             , DeferredSend TFloat
             , DeferredSendIn TFloat
             , PriceSite TFloat
             , DateChangeSite TDateTime
             , TPAmount TFloat
             , Color_calc Integer
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbRemainsDate TDateTime;
   DECLARE vbisAdmin Boolean;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    -- ����������� �� �������� ��������� �����������
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    vbRemainsDate = CURRENT_TIMESTAMP;
    vbisAdmin := EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
                 AND vbUserId NOT IN (183242);
                 
    --raise notice 'Value 1: %', CLOCK_TIMESTAMP();
                 
    -- ���� �� �������
    CREATE TEMP TABLE tmpPriceChange ON COMMIT DROP AS
     SELECT DISTINCT ObjectLink_PriceChange_Goods.ChildObjectId        AS GoodsId
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
       AND COALESCE (ObjectLink_PriceChange_PartionDateKind_Retail.ChildObjectId, 0) = 0;
                                 
    ANALYSE tmpPriceChange;
               
    --raise notice 'Value 2: %', CLOCK_TIMESTAMP();
                   
    -- ���� �� �������
    CREATE TEMP TABLE tmpPriceChangeUnit ON COMMIT DROP AS
    SELECT DISTINCT ObjectLink_PriceChange_Goods.ChildObjectId                 AS GoodsId
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
               AND COALESCE (ObjectLink_PriceChange_PartionDateKind_Unit.ChildObjectId, 0) = 0;
                                     
    ANALYSE tmpPriceChangeUnit;
    
    --raise notice 'Value 3: %', CLOCK_TIMESTAMP();
    
    -- ����� ������                                  
    CREATE TEMP TABLE tmpPromoBonus ON COMMIT DROP AS
    SELECT PromoBonus.GoodsID
         , PromoBonus.UnitID
         , PromoBonus.MarginPercent
         , PromoBonus.PromoBonus 
         , PromoBonus.BonusInetOrder 
    FROM gpSelect_PromoBonus_MarginPercent(inUnitId := 0,  inSession := inSession) AS PromoBonus 
    WHERE PromoBonus.BonusInetOrder > 0 or PromoBonus.PromoBonus > 0;

    ANALYSE tmpPromoBonus;
    
    --raise notice 'Value 4: %', CLOCK_TIMESTAMP();
    
    CREATE TEMP TABLE tmpGoods ON COMMIT DROP AS
     SELECT Goods_Retail.Id
          , Goods_Main.ObjectCode
          , Goods_Main.Name
          , Goods_Main.GoodsGroupId
          , Goods_Main.NDSKindId
     FROM Object_Goods_Main AS Goods_Main
          INNER JOIN Object_Goods_Retail AS Goods_Retail
                                         ON Goods_Main.Id  = Goods_Retail.GoodsMainId
                                        AND (Goods_Retail.RetailId = vbObjectId OR inisRetail = FALSE) 
     WHERE (','||inCodeSearch||',' ILIKE '%,'||CAST(Goods_Main.ObjectCode AS TVarChar)||',%' AND inCodeSearch <> '')
        OR (upper(Goods_Main.Name) ILIKE UPPER('%'||inGoodsSearch||'%')  AND inGoodsSearch <> '' AND inCodeSearch = '');
                        
    ANALYSE tmpGoods;                 

    --raise notice 'Value 5: %', CLOCK_TIMESTAMP();

    CREATE TEMP TABLE containerAll ON COMMIT DROP AS
     SELECT Container.descid
          , Container.Id                AS ContainerId
          , Container.ParentId
          , Container.Amount
          , Container.ObjectID          AS GoodsId
          , Container.WhereObjectId     AS UnitId
     FROM Container
     WHERE Container.ObjectID in (SELECT tmpGoods.Id FROM tmpGoods)
       AND Container.descid IN (zc_Container_Count(), zc_Container_CountPartionDate())
       AND Container.WhereObjectId IN (SELECT T1.ID FROM gpSelect_Object_Unit(False, False, '3') AS T1);
                         
    ANALYSE containerAll; 
    
    --raise notice 'Value 6: %', CLOCK_TIMESTAMP();
    
    CREATE TEMP TABLE tmpPrice_View ON COMMIT DROP AS
    WITH tmpPrice AS (SELECT Price_Goods.ObjectId        AS Id
                           , Price_Goods.ChildObjectId   AS GoodsId
                      FROM ObjectLink AS Price_Goods
                      WHERE Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                        AND Price_Goods.ChildObjectId IN (SELECT tmpGoods.Id FROM tmpGoods )
                     )
                     
    SELECT Price_Goods.Id              AS Id
         , Price_Unit.ChildObjectId    AS UnitId
         , Price_Goods.GoodsId         AS GoodsId
         , CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                 AND ObjectFloat_Goods_Price.ValueData > 0
                THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                WHEN COALESCE (tmpPriceChangeUnit.PriceChange, tmpPriceChange.PriceChange, 0) > 0 
                THEN COALESCE (tmpPriceChangeUnit.PriceChange, tmpPriceChange.PriceChange, 0)
                WHEN COALESCE (tmpPriceChangeUnit.FixPercent, tmpPriceChange.FixPercent, 0) > 0 
                THEN Round(Price_Value.ValueData  * (100.0 - COALESCE (tmpPriceChangeUnit.FixPercent, tmpPriceChange.FixPercent, 0)) / 100.0, 2)
                WHEN COALESCE (tmpPriceChangeUnit.FixDiscount, tmpPriceChange.FixDiscount, 0) > 0 
                 AND Price_Value.ValueData  > COALESCE (tmpPriceChangeUnit.FixDiscount, tmpPriceChange.FixDiscount, 0)
                THEN Round(Price_Value.ValueData  - COALESCE (tmpPriceChangeUnit.FixDiscount, tmpPriceChange.FixDiscount, 0), 2)
                WHEN COALESCE (tmpPromoBonus.PromoBonus, 0) > 0
                THEN Round(Price_Value.ValueData * 100.0 / (100.0 + tmpPromoBonus.MarginPercent) * 
                          (100.0 - tmpPromoBonus.PromoBonus + tmpPromoBonus.MarginPercent) / 100, 2)
                ELSE ROUND (Price_Value.ValueData, 2)
           END :: TFloat                           AS PriceSale
         , CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                 AND ObjectFloat_Goods_Price.ValueData > 0
                THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                ELSE ROUND (Price_Value.ValueData, 2)
           END :: TFloat                           AS Price
         , Price_DateChange.ValueData              AS DateChange 
    FROM tmpPrice AS Price_Goods
         LEFT JOIN ObjectLink AS Price_Unit
                ON Price_Unit.ObjectId = Price_Goods.Id
               AND Price_Unit.DescId = zc_ObjectLink_Price_Unit()
         LEFT JOIN ObjectFloat AS Price_Value
                               ON Price_Value.ObjectId = Price_Unit.ObjectId
                              AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
         LEFT JOIN ObjectDate AS Price_DateChange
                              ON Price_DateChange.ObjectId = Price_Unit.ObjectId
                             AND Price_DateChange.DescId = zc_ObjectDate_Price_DateChange()
           -- ���� ���� ��� ���� ����
         LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.GoodsId
                               AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
         LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                 ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.GoodsId
                                AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                                
         LEFT JOIN tmpPriceChangeUnit ON tmpPriceChangeUnit.GoodsId = Price_Goods.GoodsId  
                                     AND tmpPriceChangeUnit.UnitId = Price_Unit.ChildObjectId
         LEFT JOIN tmpPriceChange ON tmpPriceChange.GoodsId = Price_Goods.GoodsId  
                                 AND COALESCE (tmpPriceChangeUnit.GoodsId, 0) = 0

         -- ��� ���� �����
         LEFT JOIN tmpPromoBonus ON tmpPromoBonus.GoodsId = Price_Goods.GoodsId
                                AND tmpPromoBonus.UnitId = Price_Unit.ChildObjectId;
                          
    ANALYSE tmpPrice_View;
    
    --raise notice 'Value 7: %', CLOCK_TIMESTAMP();
            
    CREATE TEMP TABLE containerCount ON COMMIT DROP AS
     SELECT Container.ContainerId       AS ContainerId
          , Container.Amount
          , Container.GoodsId           AS GoodsId
          , Container.UnitId            AS UnitId
     FROM containerAll AS Container
     WHERE Container.descid = zc_container_count();
                           
    ANALYSE containerCount;
    
    --raise notice 'Value 8: %', CLOCK_TIMESTAMP();
    
    CREATE TEMP TABLE containerPD ON COMMIT DROP AS
    SELECT Container.ParentId
         , MIN(COALESCE (ObjectDate_ExpirationDate.ValueData, zc_DateEnd()))  AS ExpirationDate
    FROM containerAll AS Container

         LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.ContainerId
                                      AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

         LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                              ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId 
                             AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                                                 
    WHERE Container.DescId = zc_Container_CountPartionDate()
      AND Container.Amount > 0
    GROUP BY Container.ParentId;
                         
    ANALYSE containerPD;
    
    --raise notice 'Value 9: %', CLOCK_TIMESTAMP();
    
    CREATE TEMP TABLE tmpMIC ON COMMIT DROP AS
     SELECT MIContainer.ContainerId
          , MIContainer.Amount
          , MIContainer.MovementDescId
     FROM MovementItemContainer AS MIContainer
     WHERE MIContainer.ContainerId IN (SELECT containerCount.ContainerId FROM containerCount)
       AND MIContainer.OperDate >= CURRENT_TIMESTAMP - INTERVAL '1 day'
       AND MIContainer.MovementDescId in (zc_Movement_Check(), zc_Movement_Sale());
                      
    ANALYSE tmpMIC;
    
    --raise notice 'Value 10: %', CLOCK_TIMESTAMP();
    
    CREATE TEMP TABLE tmpData ON COMMIT DROP AS
    WITH
        tmpCLO AS (SELECT * FROM ContainerlinkObject  AS ContainerLinkObject_MovementItem
                   WHERE ContainerLinkObject_MovementItem.Containerid IN (SELECT containerCount.ContainerId FROM containerCount))

      , tmpData_Inc AS (SELECT containerCount.Amount
                             , containerCount.GoodsId
                             , containerCount.UnitId
                             , COALESCE (MIFloat_MovementItem.ValueData :: Integer,Object_PartionMovementItem.ObjectCode)    AS MI_Income
                             , containerPD.ExpirationDate
                        FROM containerCount

                            -- ������� ������ ��� ����������� ����� �������� �������
                            LEFT JOIN tmpCLO AS ContainerLinkObject_MovementItem
                                                          ON ContainerLinkObject_MovementItem.Containerid =  containerCount.ContainerId
                                                         AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                            LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                            -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                            LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                        ON MIFloat_MovementItem.MovementItemId = Object_PartionMovementItem.ObjectCode
                                                       AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                                       
                            LEFT JOIN containerPD ON containerPD.ParentId = containerCount.ContainerId
                        WHERE containerCount.Amount > 0
                        )
      , tmpMID AS (SELECT * FROM MovementItemDate  AS MIDate_ExpirationDate
                   WHERE MIDate_ExpirationDate.MovementItemId IN (SELECT tmpData_Inc.MI_Income FROM tmpData_Inc))

      , tmpData_all AS (SELECT SUM(tmpData_Inc.Amount)    AS Amount
                             , tmpData_Inc.GoodsId
                             , tmpData_Inc.UnitId
                             , min (COALESCE(tmpData_Inc.ExpirationDate, MIDate_ExpirationDate.ValueData, zc_DateEnd()))::TDateTime AS MinExpirationDate -- ���� ��������
                        FROM tmpData_Inc

                            LEFT OUTER JOIN tmpMID  AS MIDate_ExpirationDate
                                                              ON MIDate_ExpirationDate.MovementItemId = tmpData_Inc.MI_Income
                                                             AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                        GROUP BY tmpData_Inc.GoodsId, tmpData_Inc.UnitId
                        )
    SELECT tmpData_all.UnitId
         , tmpData_all.GoodsId
         , SUM (tmpData_all.Amount)   AS Amount
         , min (tmpData_all.MinExpirationDate) AS MinExpirationDate
    FROM  tmpData_all
    GROUP BY tmpData_all.GoodsId
           , tmpData_all.UnitId
    HAVING (SUM (tmpData_all.Amount) <> 0);   
                    
    ANALYSE tmpData;

    -- ���������
    RETURN QUERY
        WITH
        containerCheck AS (SELECT
                                 ContainerCount.GoodsId
                               , ContainerCount.UnitId
                               , COALESCE(SUM(-1.0 * MIContainer.Amount), 0) AS DailyCheck
                          FROM ContainerCount
                              LEFT JOIN tmpMIC AS MIContainer
                                                              ON MIContainer.ContainerId = ContainerCount.ContainerId
                                                             AND MIContainer.MovementDescId = zc_Movement_Check()
                          GROUP BY ContainerCount.GoodsId , ContainerCount.UnitId
                      )
      , containerSale AS (SELECT
                                 ContainerCount.GoodsId
                               , ContainerCount.UnitId
                               , COALESCE(SUM(-1.0 * MIContainer.Amount), 0) AS DailySale
                          FROM ContainerCount
                              LEFT JOIN tmpMIC AS MIContainer
                                                              ON MIContainer.ContainerId = ContainerCount.ContainerId
                                                             AND MIContainer.MovementDescId = zc_Movement_Sale()
                          GROUP BY ContainerCount.GoodsId , ContainerCount.UnitId
                      )
      , tmpIncome AS (SELECT MovementLinkObject_To.ObjectId          AS UnitId
                           , MI_Income.ObjectId                      AS GoodsId
                           , SUM(COALESCE (MI_Income.Amount, 0))     AS AmountIncome
                           , SUM(COALESCE (MI_Income.Amount, 0) * COALESCE(MIFloat_PriceSale.ValueData,0))  AS SummSale
                      FROM Movement AS Movement_Income
                           INNER JOIN MovementDate AS MovementDate_Branch
                                                   ON MovementDate_Branch.MovementId = Movement_Income.Id
                                                  AND MovementDate_Branch.DescId = zc_MovementDate_Branch()
                                                  AND date_trunc('day', MovementDate_Branch.ValueData) between date_trunc('day', CURRENT_TIMESTAMP)-interval '1 month' AND date_trunc('day', CURRENT_TIMESTAMP)

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                         ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                           LEFT JOIN MovementItem AS MI_Income
                                                  ON MI_Income.MovementId = Movement_Income.Id
                                                 AND MI_Income.isErased   = False

                           LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                       ON MIFloat_PriceSale.MovementItemId = MI_Income.Id
                                                      AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()

                           -- left join  Object ON Object.id = MI_Income.ObjectId
                           -- left join  Object AS Object1 ON Object1.id = MovementLinkObject_To.ObjectId
                       WHERE Movement_Income.DescId = zc_Movement_Income()
                         AND Movement_Income.StatusId = zc_Enum_Status_UnComplete()
                       GROUP BY MI_Income.ObjectId
                              , MovementLinkObject_To.ObjectId
                    )

          -- ���������� �����������
      , tmpMovementID AS (SELECT
                                 Movement.Id
                               , Movement.DescId
                          FROM Movement
                          WHERE Movement.DescId IN (zc_Movement_Send(), zc_Movement_Check())
                            AND Movement.StatusId = zc_Enum_Status_UnComplete()
                            AND Movement.OperDate > CURRENT_DATE - INTERVAL '100 DAY'
                        )
     , tmpMovementSend AS (SELECT
                                  Movement.Id
                                , MovementLinkObject_To.ObjectId                 AS UnitID
                           FROM tmpMovementID AS Movement

                                INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                                           ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                          AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                                          AND MovementBoolean_Deferred.ValueData = TRUE

                                INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                              ON MovementLinkObject_To.MovementId = Movement.Id
                                                             AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                           WHERE Movement.DescId = zc_Movement_Send()
                           )
     , tmpDeferredSend AS (SELECT
                                  Container.WhereObjectId             AS UnitID
                                , Container.ObjectId                  AS GoodsId
                                , SUM(- MovementItemContainer.Amount) AS Amount
                           FROM tmpMovementSend AS Movement

                                INNER JOIN MovementItemContainer ON MovementItemContainer.MovementId = Movement.Id
                                                                AND MovementItemContainer.DescId = zc_Container_Count()

                               INNER JOIN Container ON Container.Id = MovementItemContainer.ContainerId

                           GROUP BY Container.WhereObjectId
                                  , Container.ObjectId
                         )
     , tmpDeferredSendIn AS (SELECT
                                  Movement.UnitID                     AS UnitID
                                , Container.ObjectId                  AS GoodsId
                                , SUM(- MovementItemContainer.Amount) AS Amount
                           FROM tmpMovementSend AS Movement

                                INNER JOIN MovementItemContainer ON MovementItemContainer.MovementId = Movement.Id
                                                                AND MovementItemContainer.DescId = zc_Container_Count()

                               INNER JOIN Container ON Container.Id = MovementItemContainer.ContainerId

                           GROUP BY Movement.UnitID
                                  , Container.ObjectId
                         )
       -- ���������� ����
      , tmpMovReserve AS (SELECT Movement.Id
                               , MovementLinkObject_Unit.ObjectId AS UnitId
                          FROM MovementBoolean AS MovementBoolean_Deferred
                             INNER JOIN tmpMovementID AS Movement 
                                                      ON Movement.Id     = MovementBoolean_Deferred.MovementId
                                                     AND Movement.DescId = zc_Movement_Check()
                             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                          WHERE MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                            AND MovementBoolean_Deferred.ValueData = TRUE
                         UNION ALL
                          SELECT Movement.Id
                               , MovementLinkObject_Unit.ObjectId AS UnitId
                          FROM MovementString AS MovementString_CommentError
                             INNER JOIN tmpMovementID AS Movement 
                                                      ON Movement.Id     = MovementString_CommentError.MovementId
                                                     AND Movement.DescId = zc_Movement_Check()
                             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                         WHERE MovementString_CommentError.DescId = zc_MovementString_CommentError()
                           AND MovementString_CommentError.ValueData <> ''
                         )
      , tmpReserve AS (SELECT tmpMovReserve.UnitId             AS UnitId
                            , MovementItem.ObjectId            AS GoodsId
                            , Sum(MovementItem.Amount)::TFloat AS Amount
                       FROM tmpMovReserve
                            INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovReserve.Id
                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                   AND MovementItem.isErased   = FALSE
                       GROUP BY MovementItem.ObjectId, tmpMovReserve.UnitId
                       )



      , tmpUnitAll AS (SELECT *
                       FROM Object AS Object_Unit
                       WHERE Object_Unit.DescId = zc_Object_Unit()
                       )
      , tmpObjectLink AS (SELECT *
                          FROM ObjectLink
                          WHERE ObjectLink.ObjectId IN (SELECT DISTINCT tmpUnitAll.Id FROM tmpUnitAll)
                            AND ObjectLink.DescId IN (zc_ObjectLink_Unit_Area()
                                                    , zc_ObjectLink_Unit_Juridical()
                                                    , zc_ObjectLink_Unit_ProvinceCity())
                          )
      , tmpUnit AS (SELECT Object_Unit.Id                               AS UnitId
                         , Object_Unit.ValueData                        AS UnitName
                         , Object_Area.ValueData                        AS AreaName
                         , Object_Retail.ValueData                      AS RetailName
                         , Object_ProvinceCity.ValueData                AS ProvinceCityName_Unit
                         , Object_Juridical.ValueData                   AS JuridicalName_Unit
                         , ObjectString_Phone.ValueData                 AS Phone
                         , ObjectString_Unit_Address.ValueData          AS Address_Unit
                         , ObjectString_Unit_Phone.ValueData            AS Phone_Unit
                    FROM tmpUnitAll AS Object_Unit
                         LEFT JOIN tmpObjectLink AS ObjectLink_Unit_Area
                                                 ON ObjectLink_Unit_Area.ObjectId = Object_Unit.Id
                                                AND ObjectLink_Unit_Area.DescId = zc_ObjectLink_Unit_Area()
                         LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Unit_Area.ChildObjectId

                         LEFT JOIN tmpObjectLink AS ObjectLink_Unit_Juridical
                                                 ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                         LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

                         LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                         LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

                         LEFT JOIN tmpObjectLink AS ObjectLink_Unit_ProvinceCity
                                                 ON ObjectLink_Unit_ProvinceCity.ObjectId = Object_Unit.Id
                                                AND ObjectLink_Unit_ProvinceCity.DescId = zc_ObjectLink_Unit_ProvinceCity()
                         LEFT JOIN Object AS Object_ProvinceCity ON Object_ProvinceCity.Id = ObjectLink_Unit_ProvinceCity.ChildObjectId

                         LEFT JOIN ObjectString AS ObjectString_Unit_Address
                                                ON ObjectString_Unit_Address.ObjectId = Object_Unit.Id
                                               AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address()
                         LEFT JOIN ObjectString AS ObjectString_Unit_Phone
                                                ON ObjectString_Unit_Phone.ObjectId = Object_Unit.Id
                                               AND ObjectString_Unit_Phone.DescId = zc_ObjectString_Unit_Phone()

                         LEFT JOIN ObjectLink AS ContactPerson_ContactPerson_Object
                                              ON ContactPerson_ContactPerson_Object.ChildObjectId = Object_Unit.Id
                                             AND ContactPerson_ContactPerson_Object.DescId = zc_ObjectLink_ContactPerson_Object()

                         LEFT JOIN ObjectString AS ObjectString_Phone
                                                ON ObjectString_Phone.ObjectId = ContactPerson_ContactPerson_Object.ObjectId
                                               AND ObjectString_Phone.DescId = zc_ObjectString_ContactPerson_Phone()
                    )

      , tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                            , ObjectFloat_NDSKind_NDS.ValueData
                      FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                      WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                      )
      , tmpGoodsParams AS (SELECT tmpGoods.Id                                      AS GoodsId
                                , tmpGoods.ObjectCode                              AS GoodsCode
                                , tmpGoods.Name                                    AS GoodsName
                                , Object_GoodsGroup.ValueData                      AS GoodsGroupName
                                , Object_NDSKind.ValueData                         AS NDSKindName
                                , ObjectFloat_NDSKind_NDS.ValueData                AS NDS
                               FROM tmpGoods

                                 LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = tmpGoods.GoodsGroupId

                                 LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = tmpGoods.NDSKindId

                                 LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                                      ON ObjectFloat_NDSKind_NDS.ObjectId = tmpGoods.NDSKindId
                           )

      , tmpPrice_Site AS (SELECT Object_PriceSite.Id                        AS Id
                               , ROUND(Price_Value.ValueData,2)::TFloat     AS Price
                               , Price_Goods.ChildObjectId                  AS GoodsId
                               , PriceSite_DateChange.ValueData             AS DateChange 
                          FROM Object AS Object_PriceSite
                               INNER JOIN ObjectLink AS Price_Goods
                                       ON Price_Goods.ObjectId = Object_PriceSite.Id
                                      AND Price_Goods.DescId = zc_ObjectLink_PriceSite_Goods()
                               LEFT JOIN ObjectFloat AS Price_Value
                                      ON Price_Value.ObjectId = Object_PriceSite.Id
                                     AND Price_Value.DescId = zc_ObjectFloat_PriceSite_Value()
                               LEFT JOIN ObjectDate AS PriceSite_DateChange
                                                    ON PriceSite_DateChange.ObjectId = Object_PriceSite.Id
                                                   AND PriceSite_DateChange.DescId = zc_ObjectDate_PriceSite_DateChange()
                          WHERE Object_PriceSite.DescId = zc_Object_PriceSite()
                            AND Price_Goods.ChildObjectId NOT IN (SELECT DISTINCT ObjectLink_BarCode_Goods.ChildObjectId  AS GoodsId
                                                                  FROM Object AS Object_BarCode
                                                                       LEFT JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                                                                            ON ObjectLink_BarCode_Goods.ObjectId = Object_BarCode.Id
                                                                                           AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
                                                                       LEFT JOIN ObjectLink AS ObjectLink_BarCode_Object
                                                                                            ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                                                                                           AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()
                                                                       LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_BarCode_Object.ChildObjectId           

                                                                  WHERE Object_BarCode.DescId = zc_Object_BarCode()
                                                                    AND Object_BarCode.isErased = False
                                                                    AND Object_Object.isErased = False)
                         )
         -- ���������� ����������� ���������
      , tmpMovementTP AS (SELECT MovementItemMaster.ObjectId              AS GoodsId
                               , MovementLinkObject_Unit.ObjectId         AS UnitId
                               , SUM(-MovementItemMaster.Amount)::TFloat  AS Amount
                          FROM Movement AS Movement

                               INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                             ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                            AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                               
                               INNER JOIN MovementItem AS MovementItemMaster
                                                       ON MovementItemMaster.MovementId = Movement.Id
                                                      AND MovementItemMaster.DescId     = zc_MI_Master()
                                                      AND MovementItemMaster.isErased   = FALSE
                                                      AND MovementItemMaster.Amount     < 0
                                                         
                               INNER JOIN MovementItemBoolean AS MIBoolean_Deferred
                                                              ON MIBoolean_Deferred.MovementItemId = MovementItemMaster.Id
                                                             AND MIBoolean_Deferred.DescId         = zc_MIBoolean_Deferred()
                                                             AND MIBoolean_Deferred.ValueData      = TRUE
                                                               
                          WHERE Movement.DescId = zc_Movement_TechnicalRediscount()
                            AND Movement.StatusId = zc_Enum_Status_UnComplete()
                          GROUP BY MovementItemMaster.ObjectId
                                 , MovementLinkObject_Unit.ObjectId) 


        --���������
        SELECT tmpGoodsParams.GoodsId
             , tmpGoodsParams.GoodsCode
             , tmpGoodsParams.GoodsName
             , tmpGoodsParams.NDSkindName
             , tmpGoodsParams.NDS
             , tmpGoodsParams.GoodsGroupName
             , Object_Unit.UnitId
             , Object_Unit.UnitName
             , Object_Unit.AreaName
             , Object_Unit.RetailName
             , Object_Unit.Address_Unit
             , Object_Unit.Phone_Unit
             , Object_Unit.ProvinceCityName_Unit
             , Object_Unit.JuridicalName_Unit
             , Object_Unit.Phone
             , COALESCE (tmpData.Amount,0)         :: TFloat AS Amount
             , COALESCE (tmpIncome.AmountIncome,0)                                   :: TFloat AS AmountIncome
             , COALESCE (tmpReserve.Amount, 0)                                       :: TFloat AS AmountReserve
             , (COALESCE (tmpData.Amount,0) + COALESCE (tmpIncome.AmountIncome,0) +
               COALESCE (tmpDeferredSendIn.Amount, 0))                               :: TFloat AS AmountAll
             , COALESCE (Object_Price.Price, 0)                                      :: TFloat AS Price
             , COALESCE (Object_Price.PriceSale, 0)                                  :: TFloat AS PriceSale
             , (tmpData.Amount * COALESCE (Object_Price.PriceSale, 0))               :: TFloat AS SummaSale
             , Object_Price.DateChange                                                         AS DateChange 
             , CASE WHEN COALESCE(tmpIncome.AmountIncome,0) <> 0 THEN COALESCE (tmpIncome.SummSale,0) / COALESCE (tmpIncome.AmountIncome,0) ELSE 0 END  :: TFloat AS PriceSaleIncome
             , tmpData.MinExpirationDate  ::TDateTime
             , containerCheck.DailyCheck:: TFloat
             , containerSale.DailySale:: TFloat
             , tmpDeferredSend.Amount:: TFloat AS DeferredSend
             , tmpDeferredSendIn.Amount:: TFloat AS DeferredSendIn
             , tmpPrice_Site.Price                      AS PriceSite
             , tmpPrice_Site.DateChange                 AS DateChangeSite
             , Reserve_TP.Amount                        AS TPAmount
             , CASE WHEN vbisAdmin AND COALESCE (tmpData.Amount,0) < (COALESCE (containerCheck.DailyCheck,0) + COALESCE (containerSale.DailySale,0)) THEN zc_Color_Red()
                    WHEN vbisAdmin AND COALESCE (tmpData.Amount,0) > (COALESCE (containerCheck.DailyCheck,0) + COALESCE (containerSale.DailySale,0)) * 3 THEN zc_Color_Greenl()
                    ELSE zc_Color_White() END      AS Color_calc

        FROM tmpGoods
            LEFT JOIN tmpUnit AS Object_Unit ON 1=1
            LEFT JOIN tmpData ON tmpData.GoodsId = tmpGoods.Id
                             AND tmpData.UnitId  = Object_Unit.UnitId

            LEFT JOIN tmpIncome ON tmpIncome.GoodsId = tmpGoods.Id
                               AND tmpIncome.UnitId  = Object_Unit.UnitId

            LEFT JOIN tmpReserve ON tmpReserve.GoodsId = tmpGoods.Id
                                AND tmpReserve.UnitId  = Object_Unit.UnitId

            LEFT JOIN tmpGoodsParams ON tmpGoodsParams.GoodsId = tmpGoods.Id

            LEFT OUTER JOIN tmpPrice_View AS Object_Price
                                          ON Object_Price.GoodsId = tmpGoods.Id
                                         AND Object_Price.UnitId  = Object_Unit.UnitId

            LEFT JOIN containerCheck ON containerCheck.GoodsId = tmpGoods.Id
                                    AND containerCheck.UnitId  = Object_Unit.UnitId

            LEFT JOIN containerSale ON containerSale.GoodsId = tmpGoods.Id
                                    AND containerSale.UnitId  = Object_Unit.UnitId

            LEFT JOIN tmpDeferredSend ON tmpDeferredSend.GoodsId = tmpGoods.Id
                                     AND tmpDeferredSend.UnitId  = Object_Unit.UnitId

            LEFT JOIN tmpDeferredSendIn ON tmpDeferredSendIn.GoodsId = tmpGoods.Id
                                       AND tmpDeferredSendIn.UnitId  = Object_Unit.UnitId

            LEFT JOIN tmpPrice_Site ON tmpPrice_Site.GoodsId = tmpGoods.Id

            LEFT OUTER JOIN tmpMovementTP AS Reserve_TP ON Reserve_TP.GoodsId = tmpGoods.Id
                                                       AND Reserve_TP.UnitId = Object_Unit.UnitId

          WHERE COALESCE(tmpData.Amount,0)<>0 OR COALESCE(tmpIncome.AmountIncome,0)<>0 OR COALESCE(tmpDeferredSend.Amount,0)<>0 OR COALESCE(tmpDeferredSendIn.Amount,0)<>0
          ORDER BY Object_Unit.UnitName
                 , tmpGoodsParams.GoodsGroupName
                 , tmpGoodsParams.GoodsName
           ;
           
     --raise notice 'Value 20: %', CLOCK_TIMESTAMP();

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.09.19         *
 11.12.18         * AmountReserve
 28.08.18         *
 05.01.18         *
 08.07.16         *
 11.05.16         *
 18.04.16         *
*/

-- ����
-- SELECT * FROM gpSelect_GoodsSearchRemains ('4282', '������', inSession := '3')
-- select * from gpSelect_GoodsSearchRemains(inCodeSearch := '' , inGoodsSearch := '����� �����' ,  inSession := '3'); 36584

select * from gpSelect_GoodsSearchRemains(inCodeSearch := '14660' , inGoodsSearch := '' , inisRetail := 'False' ,  inSession := '3');