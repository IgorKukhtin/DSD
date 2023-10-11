-- Function: gpSelect_MovementItem_Sale()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Sale (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Sale(
    IN inMovementId  Integer      , -- ���� ���������
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , MorionCode Integer
             , GoodsGroupName TVarChar
             , ConditionsKeepName TVarChar
             , NDSKindId Integer, NDSKindCode Integer, NDSKindName TVarChar, NDS TFloat
             , Amount TFloat, AmountDeferred TFloat, AmountRemains TFloat
             , Price TFloat, PriceSale TFloat, ChangePercent TFloat
             , Summ TFloat, SummIC TFloat
             , isSP Boolean
             , isResolution_224 Boolean
             , UKTZED TVarChar
             , isErased Boolean
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbUnitId Integer;
    DECLARE vbSPKindId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbRetailId Integer;   
    DECLARE vbisNP Boolean;   
    DECLARE vbInsuranceCompaniesId Integer;   
    DECLARE vbChangePercent TFloat;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Sale());
    vbUserId:= lpGetUserBySession (inSession);

    -- ������������ �������������
    SELECT MovementLinkObject_Unit.ObjectId
         , MovementLinkObject_SPKind.ObjectId
         , Movement.StatusId
         , COALESCE(ObjectLink_Juridical_Retail.ChildObjectId, 4)
         , COALESCE (MovementBoolean_NP.ValueData, FALSE)
         , MLO_InsuranceCompanies.ObjectId  
         , CASE WHEN COALESCE(MLO_InsuranceCompanies.ObjectId, 0) > 0 
                THEN COALESCE(MovementFloat_ChangePercent.ValueData, 100)
                ELSE NULL END :: TFloat
    INTO vbUnitId, vbSPKindId, vbStatusId, vbRetailId, vbisNP, vbInsuranceCompaniesId, vbChangePercent
    FROM Movement
         INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()                                       
         LEFT JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                      ON MovementLinkObject_SPKind.MovementId = Movement.Id
                                     AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()

         LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                              ON ObjectLink_Unit_Juridical.ObjectId = MovementLinkObject_Unit.ObjectId
                             AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
         
         LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

         LEFT JOIN MovementBoolean AS MovementBoolean_NP
                                   ON MovementBoolean_NP.MovementId = Movement.Id
                                  AND MovementBoolean_NP.DescId = zc_MovementBoolean_NP()

         LEFT JOIN MovementLinkObject AS MLO_InsuranceCompanies
                                      ON MLO_InsuranceCompanies.MovementId = Movement.Id
                                     AND MLO_InsuranceCompanies.DescId = zc_MovementLinkObject_InsuranceCompanies()

         LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                 ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
                                     
    WHERE Movement.ID = inMovementId;
    
    CREATE TEMP TABLE MovementItem_Sale ON COMMIT DROP AS
     (SELECT MovementItem.Id                    AS Id
           , MovementItem.ObjectId              AS GoodsId
           , MovementItem.Amount                AS Amount
           , MIFloat_Price.ValueData            AS Price
           , COALESCE (MIFloat_PriceSale.ValueData, MIFloat_Price.ValueData) AS PriceSale
           , MIFloat_ChangePercent.ValueData    AS ChangePercent
           , MIFloat_Summ.ValueData             AS Summ
           , CASE WHEN COALESCE(vbInsuranceCompaniesId, 0) = 0
                  THEN Null
                  ELSE ROUND(MovementItem.Amount * COALESCE (MIFloat_PriceSale.ValueData, 0), 2) -
                       COALESCE (MIFloat_Summ.ValueData, 0) END::TFloat AS SummIC
           , MIBoolean_Sp.ValueData             AS isSp
           , MovementItem.isErased              AS isErased
      FROM  MovementItem
          LEFT JOIN MovementItemBoolean AS MIBoolean_SP
                                        ON MIBoolean_SP.MovementItemId = MovementItem.Id
                                       AND MIBoolean_SP.DescId = zc_MIBoolean_SP()
          LEFT JOIN MovementItemFloat AS MIFloat_Price
                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
          LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                      ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                     AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
          LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                      ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                     AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
          LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                      ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                     AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
      WHERE MovementItem.MovementId = inMovementId
        AND MovementItem.DescId = zc_MI_Master()
        AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
      );
                                      
    ANALYSE MovementItem_Sale;    

    -- ���������
    IF inShowAll 
    THEN
    
        CREATE TEMP TABLE tmpPromoBonus ON COMMIT DROP AS 
         SELECT MI.GoodsId               AS GoodsId
              , MI.MarginPercent         AS MarginPercent
              , MI.PromoBonus            AS PromoBonus
         FROM gpSelect_PromoBonus_MarginPercent(vbUnitId, inSession) AS MI;

        ANALYZE tmpPromoBonus;
        
        -- ���� �� �������
        CREATE TEMP TABLE tmpPriceChange ON COMMIT DROP AS 
        SELECT DISTINCT ObjectLink_PriceChange_Goods.ChildObjectId                                                             AS GoodsId
                      , COALESCE (PriceChange_Value_Unit.ValueData, PriceChange_Value_Retail.ValueData)                        AS PriceChange
                      , COALESCE (PriceChange_FixPercent_Unit.ValueData, PriceChange_FixPercent_Retail.ValueData)::TFloat      AS FixPercent
                      , COALESCE (PriceChange_FixDiscount_Unit.ValueData, PriceChange_FixDiscount_Retail.ValueData)::TFloat    AS FixDiscount
                      , COALESCE (PriceChange_Multiplicity_Unit.ValueData, PriceChange_Multiplicity_Retail.ValueData) ::TFloat AS Multiplicity
                      , COALESCE (PriceChange_FixEndDate_Unit.ValueData, PriceChange_FixEndDate_Retail.ValueData)              AS FixEndDate
                      , COALESCE (ObjectLink_PriceChange_PartionDateKind_Unit.ChildObjectId, ObjectLink_PriceChange_PartionDateKind_Retail.ChildObjectId) AS PartionDateKindId
                 FROM Object AS Object_PriceChange
                      -- ������ �� �������
                      LEFT JOIN ObjectLink AS ObjectLink_PriceChange_Unit
                                           ON ObjectLink_PriceChange_Unit.ObjectId = Object_PriceChange.Id
                                          AND ObjectLink_PriceChange_Unit.DescId = zc_ObjectLink_PriceChange_Unit()
                                          AND ObjectLink_PriceChange_Unit.ChildObjectId = vbUnitId
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
                                                                  

                      -- ������ �� ����
                      LEFT JOIN ObjectLink AS ObjectLink_PriceChange_Retail
                                           ON ObjectLink_PriceChange_Retail.ObjectId = Object_PriceChange.Id
                                          AND ObjectLink_PriceChange_Retail.DescId = zc_ObjectLink_PriceChange_Retail()
                                          AND ObjectLink_PriceChange_Retail.ChildObjectId = vbRetailId
                      -- ���� �� ������� �� ����
                      LEFT JOIN ObjectFloat AS PriceChange_Value_Retail
                                            ON PriceChange_Value_Retail.ObjectId = COALESCE (ObjectLink_PriceChange_Unit.ObjectId, ObjectLink_PriceChange_Retail.ObjectId)
                                           AND PriceChange_Value_Retail.DescId = zc_ObjectFloat_PriceChange_Value()
                                           AND COALESCE (PriceChange_Value_Retail.ValueData, 0) <> 0
                      -- ������� ������ �� ����.
                      LEFT JOIN ObjectFloat AS PriceChange_FixPercent_Retail
                                            ON PriceChange_FixPercent_Retail.ObjectId = COALESCE (ObjectLink_PriceChange_Unit.ObjectId, ObjectLink_PriceChange_Retail.ObjectId)
                                           AND PriceChange_FixPercent_Retail.DescId = zc_ObjectFloat_PriceChange_FixPercent()
                                           AND COALESCE (PriceChange_FixPercent_Retail.ValueData, 0) <> 0
                      -- ����� ������ �� ����.
                      LEFT JOIN ObjectFloat AS PriceChange_FixDiscount_Retail
                                            ON PriceChange_FixDiscount_Retail.ObjectId = COALESCE (ObjectLink_PriceChange_Unit.ObjectId, ObjectLink_PriceChange_Retail.ObjectId)
                                           AND PriceChange_FixDiscount_Retail.DescId = zc_ObjectFloat_PriceChange_FixDiscount()
                                           AND COALESCE (PriceChange_FixDiscount_Retail.ValueData, 0) <> 0
                      -- ��������� ������� �� ����.
                      LEFT JOIN ObjectFloat AS PriceChange_Multiplicity_Retail
                                            ON PriceChange_Multiplicity_Retail.ObjectId = COALESCE (ObjectLink_PriceChange_Unit.ObjectId, ObjectLink_PriceChange_Retail.ObjectId)
                                           AND PriceChange_Multiplicity_Retail.DescId = zc_ObjectFloat_PriceChange_Multiplicity()
                                           AND COALESCE (PriceChange_Multiplicity_Retail.ValueData, 0) <> 0
                      -- ���� ��������� �������� ������ �� ����.
                      LEFT JOIN ObjectDate AS PriceChange_FixEndDate_Retail
                                           ON PriceChange_FixEndDate_Retail.ObjectId = COALESCE (ObjectLink_PriceChange_Unit.ObjectId, ObjectLink_PriceChange_Retail.ObjectId)
                                          AND PriceChange_FixEndDate_Retail.DescId = zc_ObjectDate_PriceChange_FixEndDate()

                      LEFT JOIN ObjectLink AS ObjectLink_PriceChange_PartionDateKind_Retail
                                            ON ObjectLink_PriceChange_PartionDateKind_Retail.ObjectId  = COALESCE (ObjectLink_PriceChange_Unit.ObjectId, ObjectLink_PriceChange_Retail.ObjectId)
                                           AND ObjectLink_PriceChange_PartionDateKind_Retail.DescId    = zc_ObjectLink_PriceChange_PartionDateKind()

                      LEFT JOIN ObjectLink AS ObjectLink_PriceChange_Goods
                                           ON ObjectLink_PriceChange_Goods.ObjectId = COALESCE (ObjectLink_PriceChange_Unit.ObjectId, ObjectLink_PriceChange_Retail.ObjectId)
                                          AND ObjectLink_PriceChange_Goods.DescId = zc_ObjectLink_PriceChange_Goods()

                 WHERE Object_PriceChange.DescId = zc_Object_PriceChange()
                   AND Object_PriceChange.isErased = FALSE
                   AND (COALESCE (PriceChange_Value_Retail.ValueData, 0) <> 0 OR COALESCE (PriceChange_Value_Unit.ValueData, 0) <> 0 OR
                       COALESCE (PriceChange_FixPercent_Unit.ValueData, PriceChange_FixPercent_Retail.ValueData, 0) <> 0 OR
                       COALESCE (PriceChange_FixDiscount_Unit.ValueData, PriceChange_FixDiscount_Retail.ValueData, 0) <> 0) -- �������� ������ ���� <> 0
                   AND COALESCE (PriceChange_Multiplicity_Unit.ValueData, PriceChange_Multiplicity_Retail.ValueData, 0) IN (0, 1)
                 ;

        ANALYZE tmpPriceChange;

        -- ���� �����
        CREATE TEMP TABLE tmpForSiteMobile ON COMMIT DROP AS 
        SELECT p.Id, p.Price_unit_sale
        FROM gpSelect_GoodsOnUnit_ForSiteMobile (vbUnitId::Text, '', zfCalc_UserSite()) AS p;
        
        ANALYZE tmpForSiteMobile;
        
        
        CREATE TEMP TABLE tmpRemains ON COMMIT DROP AS 
        SELECT Container.ObjectId                  AS GoodsId
             , SUM(Container.Amount)::TFloat       AS Amount
        FROM Container
        WHERE Container.DescId = zc_Container_Count()
          AND Container.WhereObjectId = vbUnitId
          AND Container.Amount <> 0
        GROUP BY Container.ObjectId
        HAVING SUM(Container.Amount)<>0;

        ANALYZE tmpRemains;

        CREATE TEMP TABLE MovementItemContainer ON COMMIT DROP AS 
        SELECT MovementItemContainer.MovementItemId     AS Id
                 , SUM(-MovementItemContainer.Amount)       AS Amount
        FROM  MovementItemContainer
        WHERE MovementItemContainer.MovementId = inMovementId
          AND vbStatusId = zc_Enum_Status_UnComplete() 
        GROUP BY MovementItemContainer.MovementItemId;
                                      
        ANALYZE MovementItemContainer;

        CREATE TEMP TABLE tmpPrice ON COMMIT DROP AS 
         SELECT Price_Goods.ChildObjectId                                 AS GoodsId
              , CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                      AND ObjectFloat_Goods_Price.ValueData > 0
                     THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                     WHEN COALESCE (vbInsuranceCompaniesId, 0) = 0
                     THEN ROUND (Price_Value.ValueData, 2)
                     ELSE ROUND (CASE WHEN COALESCE (tmpPriceChange.PriceChange, 0) > 0 
                                      THEN COALESCE (tmpPriceChange.PriceChange, 0)
                                      WHEN COALESCE (tmpPriceChange.FixPercent, 0) > 0 
                                      THEN Price_Value.ValueData  * (100.0 - COALESCE (tmpPriceChange.FixPercent, 0)) / 100.0
                                      WHEN COALESCE (tmpPriceChange.FixDiscount, 0) > 0 AND 
                                           Price_Value.ValueData > COALESCE (tmpPriceChange.FixDiscount, 0)
                                      THEN Price_Value.ValueData - COALESCE (tmpPriceChange.FixDiscount, 0)
                                      WHEN COALESCE (tmpPromoBonus.PromoBonus, 0) > 0
                                      THEN Price_Value.ValueData * 100.0 / (100.0 + tmpPromoBonus.MarginPercent) * 
                                          (100.0 - tmpPromoBonus.PromoBonus + tmpPromoBonus.MarginPercent) / 100
                                      ELSE Price_Value.ValueData END, 2)
                     END :: TFloat                                        AS Price
              , COALESCE(ObjectBoolean_Goods_TOP.ValueData, False)        AS isTop
         FROM ObjectLink AS ObjectLink_Price_Unit
              LEFT JOIN ObjectFloat AS Price_Value
                     ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                    AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
              LEFT JOIN ObjectLink AS Price_Goods
                     ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                    AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
              -- ���� ���� ��� ���� ����
              LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                     ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                    AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
              LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                      ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                     AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()

              -- ���� �� �������
              LEFT JOIN tmpPriceChange ON tmpPriceChange.GoodsId = Price_Goods.ChildObjectId

              -- ��� ���� �����
              LEFT JOIN tmpPromoBonus ON tmpPromoBonus.GoodsId = Price_Goods.ChildObjectId
                                    
          WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
            AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId;

        ANALYZE tmpPrice;

        -- ��������� �����
        RETURN QUERY
            WITH
                tmpGoods AS (SELECT DISTINCT tmpRemains.GoodsId FROM tmpRemains
                         UNION 
                             SELECT DISTINCT MovementItem_Sale.GoodsId FROM MovementItem_Sale
                             )
              , tmpObjectLink_GoodsGroup AS (SELECT ObjectLink.ObjectId AS GoodsId
                                                  , Object_GoodsGroup.ValueData         AS GoodsGroupName
                                             FROM ObjectLink
                                                  LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink.ChildObjectId 
                                             WHERE ObjectLink.ObjectId IN (SELECT DISTINCT tmpGoods.GoodsId FROM tmpGoods)
                                               AND ObjectLink.DescId = zc_ObjectLink_Goods_GoodsGroup()
                                            )
              , tmpObjectLink_ConditionsKeep AS (SELECT ObjectLink.ObjectId AS GoodsId
                                                      , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar  AS ConditionsKeepName
                                                 FROM ObjectLink
                                                      LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink.ChildObjectId 
                                                 WHERE ObjectLink.ObjectId IN (SELECT DISTINCT tmpGoods.GoodsId FROM tmpGoods)
                                                   AND ObjectLink.DescId = zc_ObjectLink_Goods_ConditionsKeep()
                                                 )
              , tmpObjectLink_NDS AS (SELECT ObjectLink.ObjectId AS GoodsId
                                           , ObjectFloat_NDSKind_NDS.ValueData ::TFloat AS NDS
                                      FROM ObjectLink
                                           LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                                 ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink.ChildObjectId 
                                                                AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                                      WHERE ObjectLink.ObjectId IN (SELECT DISTINCT tmpGoods.GoodsId FROM tmpGoods)
                                        AND ObjectLink.DescId = zc_ObjectLink_Goods_NDSKind()
                                      )

              , tmpMarion AS (SELECT tmpGoods.GoodsId
                                   , Object_Goods_Main.MorionCode AS MorionCode
                                   , Object_Goods_Main.isResolution_224
                              FROM (SELECT DISTINCT tmpRemains.GoodsId FROM tmpRemains) AS tmpGoods
                                   JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = tmpGoods.GoodsId 
                                   JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                              )
              , tmpRemainsFull AS (SELECT MovementItem_Sale.Id                                   AS Id
                                        , COALESCE(MovementItem_Sale.GoodsId,tmpRemains.GoodsId) AS GoodsId
                                        , tmpRemains.Amount                                      AS Remains
                                        , MovementItem_Sale.Amount                               AS Amount
                                        , MovementItem_Sale.Price                                AS Price
                                        , MovementItem_Sale.PriceSale                            AS PriceSale 
                                        , MovementItem_Sale.ChangePercent                        AS ChangePercent
                                        , MovementItem_Sale.Summ
                                        , MovementItem_Sale.SummIC
                                        , MovementItem_Sale.isSP 
                                        , MovementItem_Sale.IsErased
                                   FROM tmpRemains
                                       FULL OUTER JOIN MovementItem_Sale ON tmpRemains.GoodsId = MovementItem_Sale.GoodsId
                                   )

            --
            SELECT COALESCE(tmpRemainsFull.Id,0)                         AS Id
                 , tmpRemainsFull.GoodsId                                AS GoodsId
                 , Object_Goods_Main.ObjectCode                          AS GoodsCode
                 , Object_Goods_Main.Name                                AS GoodsName
                 , tmpMarion.MorionCode        :: Integer
                 , ObjectLink_Goods_GoodsGroup.GoodsGroupName         :: TVarChar
                 , ObjectLink_Goods_ConditionsKeep.ConditionsKeepName :: TVarChar

                 , Object_NDSKind.Id                                     AS NDSKindId
                 , Object_NDSKind.ObjectCode                             AS NDSKindCode
                 , Object_NDSKind.ValueData                              AS NDSKindName
                 , ObjectFloat_NDSKind_NDS.ValueData                     AS NDS

                 , tmpRemainsFull.Amount                                 AS Amount
                 , MovementItemContainer.Amount::TFloat                  AS AmountDeferred
                 , NULLIF(COALESCE(tmpRemainsFull.Remains, 0) +
                   COALESCE(MovementItemContainer.Amount, 0), 0)::TFloat AS AmountRemains
                 , COALESCE(tmpForSiteMobile.Price_unit_sale, 
                            tmpRemainsFull.Price, tmpPrice.Price)        AS Price
                 , COALESCE(tmpForSiteMobile.Price_unit_sale, 
                            tmpRemainsFull.PriceSale, tmpPrice.Price)    AS PriceSale
                 , CASE WHEN vbSPKindId IN (zc_Enum_SPKind_1303(), zc_Enum_SPKind_InsuranceCompanies()) 
                        THEN COALESCE (tmpRemainsFull.ChangePercent, vbChangePercent, 100) 
                        ELSE tmpRemainsFull.ChangePercent END :: TFloat  AS ChangePercent
                 , tmpRemainsFull.Summ
                 , tmpRemainsFull.SummIC
                 , tmpRemainsFull.isSP        ::Boolean
                 , tmpMarion.isResolution_224 ::Boolean
                 , Object_Goods_Main.CodeUKTZED                          AS UKTZED
                 , COALESCE(tmpRemainsFull.IsErased,FALSE)               AS isErased
            FROM tmpRemainsFull
                LEFT JOIN MovementItemContainer ON MovementItemContainer.Id = tmpRemainsFull.Id 
                LEFT JOIN tmpPrice ON tmpPrice.GoodsId = tmpRemainsFull.GoodsId

                -- ������ ������
                LEFT JOIN tmpObjectLink_GoodsGroup AS ObjectLink_Goods_GoodsGroup
                                                   ON ObjectLink_Goods_GoodsGroup.GoodsId = tmpRemainsFull.GoodsId
                -- ������� ��������
                LEFT JOIN tmpObjectLink_ConditionsKeep AS ObjectLink_Goods_ConditionsKeep 
                                                       ON ObjectLink_Goods_ConditionsKeep.GoodsId = tmpRemainsFull.GoodsId
                -- ���
                LEFT JOIN MovementItemLinkObject AS MILinkObject_NDSKind
                                                 ON MILinkObject_NDSKind.MovementItemId = tmpRemainsFull.Id
                                                AND MILinkObject_NDSKind.DescId = zc_MILinkObject_NDSKind()
                LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = tmpRemainsFull.GoodsId
                LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

                LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = COALESCE (MILinkObject_NDSKind.ObjectId, 
                                          CASE WHEN Object_Goods_Main.isResolution_224 = TRUE THEN zc_Enum_NDSKind_Special_0() ELSE Object_Goods_Main.NDSKindId END)
                LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                      ON ObjectFloat_NDSKind_NDS.ObjectId = Object_NDSKind.Id
                                     AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                -- ��� ������
                LEFT JOIN tmpMarion ON tmpMarion.GoodsId = tmpRemainsFull.GoodsId
                                                        
                LEFT JOIN tmpForSiteMobile ON tmpForSiteMobile.Id = tmpRemainsFull.GoodsId
                                          AND COALESCE(vbInsuranceCompaniesId, 0) <> 0
                
            WHERE Object_Goods_Retail.isErased = FALSE
               OR tmpRemainsFull.id is not null;
    ELSE
        -- ��������� ������
        RETURN QUERY
            WITH
                tmpRemains AS (SELECT Container.ObjectId                  AS GoodsId
                                    , SUM(Container.Amount)::TFloat       AS Amount
                               FROM Container
                               WHERE Container.DescId = zc_Container_Count()
                                 AND Container.WhereObjectId = vbUnitId
                                 AND Container.Amount <> 0
                                 AND Container.ObjectId in (SELECT DISTINCT MovementItem_Sale.GoodsId FROM MovementItem_Sale)
                               GROUP BY Container.ObjectId
                               HAVING SUM(Container.Amount)<>0
                              )
              , MovementItemContainer AS (SELECT MovementItemContainer.MovementItemID     AS Id
                                               , SUM(-MovementItemContainer.Amount)       AS Amount
                                      FROM MovementItemContainer
                                      WHERE MovementItemContainer.MovementId = inMovementId
                                        AND vbStatusId = zc_Enum_Status_UnComplete() 
                                      GROUP BY MovementItemContainer.MovementItemID
                                      )

              , tmpObjectLink_GoodsGroup AS (SELECT ObjectLink.ObjectId AS GoodsId
                                                  , Object_GoodsGroup.ValueData         AS GoodsGroupName
                                             FROM ObjectLink
                                                  LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink.ChildObjectId 
                                             WHERE ObjectLink.ObjectId IN (SELECT DISTINCT MovementItem_Sale.GoodsId FROM MovementItem_Sale)
                                               AND ObjectLink.DescId = zc_ObjectLink_Goods_GoodsGroup()
                                            )
              , tmpObjectLink_ConditionsKeep AS (SELECT ObjectLink.ObjectId AS GoodsId
                                                      , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar  AS ConditionsKeepName
                                                 FROM ObjectLink
                                                      LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink.ChildObjectId 
                                                 WHERE ObjectLink.ObjectId IN (SELECT DISTINCT MovementItem_Sale.GoodsId FROM MovementItem_Sale)
                                                   AND ObjectLink.DescId = zc_ObjectLink_Goods_ConditionsKeep()
                                                 )

              , tmpObjectLink_NDS AS (SELECT ObjectLink.ObjectId AS GoodsId
                                           , ObjectFloat_NDSKind_NDS.ValueData ::TFloat AS NDS
                                      FROM ObjectLink
                                           LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                                 ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink.ChildObjectId 
                                                                AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                                      WHERE ObjectLink.ObjectId IN (SELECT DISTINCT MovementItem_Sale.GoodsId FROM MovementItem_Sale)
                                        AND ObjectLink.DescId = zc_ObjectLink_Goods_NDSKind()
                                      )
              , tmpMarion AS (SELECT tmpGoods.GoodsId
                                   , Object_Goods_Main.MorionCode AS MorionCode
                                   , Object_Goods_Main.isResolution_224
                              FROM (SELECT DISTINCT MovementItem_Sale.GoodsId FROM MovementItem_Sale) AS tmpGoods
                                   JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = tmpGoods.GoodsId 
                                   JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                              )

            SELECT
                MovementItem_Sale.Id          AS Id
              , MovementItem_Sale.GoodsId     AS GoodsId
              , Object_Goods_Main.ObjectCode  AS GoodsCode
              , Object_Goods_Main.Name        AS GoodsName
              , tmpMarion.MorionCode        :: Integer
              , ObjectLink_Goods_GoodsGroup.GoodsGroupName         :: TVarChar
              , ObjectLink_Goods_ConditionsKeep.ConditionsKeepName :: TVarChar

              , Object_NDSKind.Id                                    AS NDSKindId
              , Object_NDSKind.ObjectCode                            AS NDSKindCode
              , Object_NDSKind.ValueData                             AS NDSKindName
              , ObjectFloat_NDSKind_NDS.ValueData                    AS NDS

              , MovementItem_Sale.Amount      AS Amount
              , MovementItemContainer.Amount::TFloat                  AS AmountDeferred
              , NULLIF(COALESCE(tmpRemains.Amount, 0) +
                COALESCE(MovementItemContainer.Amount, 0), 0)::TFloat AS AmountRemains
              , MovementItem_Sale.Price       AS Price
              , MovementItem_Sale.PriceSale
              , MovementItem_Sale.ChangePercent
              , MovementItem_Sale.Summ
              , MovementItem_Sale.SummIC
              , MovementItem_Sale.isSP
              , tmpMarion.isResolution_224 ::Boolean
              , Object_Goods_Main.CodeUKTZED  AS UKTZED
              , MovementItem_Sale.IsErased    AS isErased
            FROM MovementItem_Sale
                LEFT OUTER JOIN tmpRemains ON tmpRemains.GoodsId = MovementItem_Sale.GoodsId
                LEFT JOIN MovementItemContainer ON MovementItemContainer.Id = MovementItem_Sale.Id 
                -- ������ ������
                LEFT JOIN tmpObjectLink_GoodsGroup AS ObjectLink_Goods_GoodsGroup
                                                   ON ObjectLink_Goods_GoodsGroup.GoodsId = MovementItem_Sale.GoodsId
                -- ������� ��������
                LEFT JOIN tmpObjectLink_ConditionsKeep AS ObjectLink_Goods_ConditionsKeep 
                                                       ON ObjectLink_Goods_ConditionsKeep.GoodsId = MovementItem_Sale.GoodsId
                -- ���
                LEFT JOIN MovementItemLinkObject AS MILinkObject_NDSKind
                                                 ON MILinkObject_NDSKind.MovementItemId = MovementItem_Sale.Id
                                                AND MILinkObject_NDSKind.DescId = zc_MILinkObject_NDSKind()
                LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.Id =  MovementItem_Sale.GoodsId
                LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

                LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = COALESCE (MILinkObject_NDSKind.ObjectId, 
                                          CASE WHEN Object_Goods_Main.isResolution_224 = TRUE THEN zc_Enum_NDSKind_Special_0() ELSE Object_Goods_Main.NDSKindId END)
                LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                      ON ObjectFloat_NDSKind_NDS.ObjectId = Object_NDSKind.Id 
                                     AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()   
                -- ��� ������
                LEFT JOIN tmpMarion ON tmpMarion.GoodsId = MovementItem_Sale.GoodsId

                ;
     END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.   ������ �.�.
 11.05.20                                                                         *               
 27.04.20         * add tmp_PartionNDS
 21.01.20                                                                         * �����������
 24.11.19         *
 18.01.17         *
 22.02.17         *
 13.10.15                                                          *
*/
-- 

select * from gpSelect_MovementItem_Sale (inMovementId := 30678777  , inShowAll := 'True' , inIsErased := 'False' ,  inSession := '3');