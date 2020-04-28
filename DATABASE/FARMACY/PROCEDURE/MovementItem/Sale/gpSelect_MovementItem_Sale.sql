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
             , NDS TFloat
             , Amount TFloat, AmountDeferred TFloat, AmountRemains TFloat
             , Price TFloat, PriceSale TFloat, ChangePercent TFloat
             , Summ TFloat
             , isSP Boolean
             , isResolution_224 Boolean
             , isErased Boolean
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbUnitId Integer;
    DECLARE vbSPKindId Integer;
    DECLARE vbStatusId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Sale());
    vbUserId:= lpGetUserBySession (inSession);

    -- ������������ �������������
    SELECT MovementLinkObject_Unit.ObjectId
         , MovementLinkObject_SPKind.ObjectId
         , Movement.StatusId
    INTO vbUnitId, vbSPKindId, vbStatusId
    FROM Movement
         INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()                                       
         LEFT JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                      ON MovementLinkObject_SPKind.MovementId = Movement.Id
                                     AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
    WHERE Movement.ID = inMovementId;

    -- ���������
    IF inShowAll THEN
        -- ��������� �����
        RETURN QUERY
            WITH
                tmpRemains AS(SELECT Container.ObjectId                  AS GoodsId
                                   , SUM(Container.Amount)::TFloat       AS Amount
                              FROM Container
                              WHERE Container.DescId = zc_Container_Count()
                                AND Container.WhereObjectId = vbUnitId
                                AND Container.Amount <> 0
                              GROUP BY Container.ObjectId
                              HAVING SUM(Container.Amount)<>0
                              )
               , MovementItem_Sale AS (SELECT
                                          MovementItem.Id                    AS Id
                                        , MovementItem.ObjectId              AS GoodsId
                                        , MovementItem.Amount                AS Amount
                                        , MIFloat_Price.ValueData            AS Price
                                        , COALESCE (MIFloat_PriceSale.ValueData, MIFloat_Price.ValueData) AS PriceSale
                                        , MIFloat_ChangePercent.ValueData    AS ChangePercent
                                        , MIFloat_Summ.ValueData             AS Summ
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
                                    )
              , MovementItemContainer AS (SELECT MovementItemContainer.MovementItemId     AS Id
                                               , SUM(-MovementItemContainer.Amount)       AS Amount
                                               , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) AS M_IncomeId
                                      FROM  MovementItemContainer
                                           LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                                         ON ContainerLinkObject_MovementItem.ContainerId = MovementItemContainer.ContainerId
                                                                        AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                           LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                                           -- ������� �������
                                           LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                           -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                                           LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                                       ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                                      AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                           -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
                                           LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                                     
                                      WHERE MovementItemContainer.MovementId = inMovementId
                                        AND vbStatusId = zc_Enum_Status_UnComplete() 
                                      GROUP BY MovementItemContainer.MovementItemId
                                             , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId)
                                      )
                                      
              , tmpPrice AS (SELECT Price_Goods.ChildObjectId               AS GoodsId
                                  , ROUND(Price_Value.ValueData, 2) ::TFloat AS Price
                             FROM ObjectLink AS ObjectLink_Price_Unit
                                  LEFT JOIN ObjectFloat AS Price_Value
                                         ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                        AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                                  LEFT JOIN ObjectLink AS Price_Goods
                                         ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                        AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                              WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                             )

              , tmpGoods AS (SELECT DISTINCT tmpRemains.GoodsId FROM tmpRemains
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
                                        , MovementItem_Sale.isSP 
                                        , MovementItem_Sale.IsErased
                                   FROM tmpRemains
                                       FULL OUTER JOIN MovementItem_Sale ON tmpRemains.GoodsId = MovementItem_Sale.GoodsId
                                   )

              , tmp_PartionNDS_all AS (SELECT Container.Id       AS MI_Id
                                            , CASE WHEN COALESCE (MovementBoolean_UseNDSKind.ValueData, FALSE) = TRUE
                                                     AND COALESCE(MovementLinkObject_NDSKind.ObjectId, 0) <> 0
                                                   THEN MovementLinkObject_NDSKind.ObjectId
                                                   ELSE NULL
                                              END  AS NDSKindId
                                       FROM MovementItemContainer AS Container
                                        LEFT OUTER JOIN MovementBoolean AS MovementBoolean_UseNDSKind
                                                                        ON MovementBoolean_UseNDSKind.MovementId = Container.M_IncomeId
                                                                       AND MovementBoolean_UseNDSKind.DescId = zc_MovementBoolean_UseNDSKind()
                                        LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                                     ON MovementLinkObject_NDSKind.MovementId = Container.M_IncomeId
                                                                    AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                                  )

              , tmp_PartionNDS AS(SELECT tmp_PartionNDS_all.MI_Id
                                     , ObjectFloat_NDSKind_NDS.ValueData ::TFloat AS NDS
                                FROM tmp_PartionNDS_all
                                     LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                           ON ObjectFloat_NDSKind_NDS.ObjectId = tmp_PartionNDS_all.NDSKindId
                                                          AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                                WHERE tmp_PartionNDS_all.NDSKindId IS NOT NULL
                                )

            --
            SELECT COALESCE(tmpRemainsFull.Id,0)                         AS Id
                 , Object_Goods.Id                                       AS GoodsId
                 , Object_Goods.ObjectCode                               AS GoodsCode
                 , Object_Goods.ValueData                                AS GoodsName
                 , tmpMarion.MorionCode        :: Integer
                 , ObjectLink_Goods_GoodsGroup.GoodsGroupName         :: TVarChar
                 , ObjectLink_Goods_ConditionsKeep.ConditionsKeepName :: TVarChar
                 , COALESCE (tmp_PartionNDS.NDS, ObjectLink_Goods_NDS.NDS) :: TFloat AS NDS
                 , tmpRemainsFull.Amount                                 AS Amount
                 , MovementItemContainer.Amount::TFloat                  AS AmountDeferred
                 , NULLIF(COALESCE(tmpRemainsFull.Remains, 0) +
                   COALESCE(MovementItemContainer.Amount, 0), 0)::TFloat AS AmountRemains
                 , COALESCE(tmpRemainsFull.Price, tmpPrice.Price)        AS Price
                 , COALESCE(tmpRemainsFull.PriceSale, tmpPrice.Price)    AS PriceSale
                 , CASE WHEN vbSPKindId = zc_Enum_SPKind_1303() THEN COALESCE (tmpRemainsFull.ChangePercent, 100) ELSE tmpRemainsFull.ChangePercent END :: TFloat AS ChangePercent
                 , tmpRemainsFull.Summ
                 , tmpRemainsFull.isSP        ::Boolean
                 , tmpMarion.isResolution_224 ::Boolean
                 , COALESCE(tmpRemainsFull.IsErased,FALSE)               AS isErased
            FROM tmpRemainsFull
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpRemainsFull.GoodsId
                LEFT JOIN MovementItemContainer ON MovementItemContainer.Id = tmpRemainsFull.Id 
                LEFT JOIN tmpPrice ON tmpPrice.GoodsId = tmpRemainsFull.GoodsId

                -- ������ ������
                LEFT JOIN tmpObjectLink_GoodsGroup AS ObjectLink_Goods_GoodsGroup
                                                   ON ObjectLink_Goods_GoodsGroup.GoodsId = tmpRemainsFull.GoodsId
                -- ������� ��������
                LEFT JOIN tmpObjectLink_ConditionsKeep AS ObjectLink_Goods_ConditionsKeep 
                                                       ON ObjectLink_Goods_ConditionsKeep.GoodsId = tmpRemainsFull.GoodsId
                -- ���
                LEFT JOIN tmpObjectLink_NDS AS ObjectLink_Goods_NDS 
                                            ON ObjectLink_Goods_NDS.GoodsId = tmpRemainsFull.GoodsId
                -- ��� ������
                LEFT JOIN tmpMarion ON tmpMarion.GoodsId = tmpRemainsFull.GoodsId
                
                LEFT JOIN tmp_PartionNDS ON tmp_PartionNDS.MI_Id = COALESCE(tmpRemainsFull.Id,0)

            WHERE Object_Goods.isErased = FALSE
               OR tmpRemainsFull.id is not null;
    ELSE
        -- ��������� ������
        RETURN QUERY
            WITH
                MovementItem_Sale AS (SELECT MovementItem.Id                    AS Id
                                           , MovementItem.ObjectId              AS GoodsId
                                           , MovementItem.Amount                AS Amount
                                           , MIFloat_Price.ValueData            AS Price
                                           , COALESCE (MIFloat_PriceSale.ValueData, MIFloat_Price.ValueData) AS PriceSale
                                           , MIFloat_ChangePercent.ValueData    AS ChangePercent
                                           , MIFloat_Summ.ValueData             AS Summ
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
                                      )
              , tmpRemains AS (SELECT Container.ObjectId                  AS GoodsId
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
                                               , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) AS M_IncomeId
                                      FROM MovementItemContainer
                                           LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                                         ON ContainerLinkObject_MovementItem.ContainerId = MovementItemContainer.ContainerId
                                                                        AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                           LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                                           -- ������� �������
                                           LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                           -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                                           LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                                       ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                                      AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                           -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
                                           LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                                      WHERE MovementItemContainer.MovementId = inMovementId
                                        AND vbStatusId = zc_Enum_Status_UnComplete() 
                                      GROUP BY MovementItemContainer.MovementItemID
                                             , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId)
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

              , tmp_PartionNDS_all AS (SELECT Container.Id       AS MI_Id
                                            , CASE WHEN COALESCE (MovementBoolean_UseNDSKind.ValueData, FALSE) = TRUE
                                                     AND COALESCE(MovementLinkObject_NDSKind.ObjectId, 0) <> 0
                                                   THEN MovementLinkObject_NDSKind.ObjectId
                                                   ELSE NULL
                                              END  AS NDSKindId
                                       FROM MovementItemContainer AS Container
                                        LEFT OUTER JOIN MovementBoolean AS MovementBoolean_UseNDSKind
                                                                        ON MovementBoolean_UseNDSKind.MovementId = Container.M_IncomeId
                                                                       AND MovementBoolean_UseNDSKind.DescId = zc_MovementBoolean_UseNDSKind()
                                        LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                                     ON MovementLinkObject_NDSKind.MovementId = Container.M_IncomeId
                                                                    AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                                  )

              , tmp_PartionNDS AS (SELECT tmp_PartionNDS_all.MI_Id
                                     , ObjectFloat_NDSKind_NDS.ValueData ::TFloat AS NDS
                                FROM tmp_PartionNDS_all
                                     LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                           ON ObjectFloat_NDSKind_NDS.ObjectId = tmp_PartionNDS_all.NDSKindId
                                                          AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                                WHERE tmp_PartionNDS_all.NDSKindId IS NOT NULL
                                )


            SELECT
                MovementItem_Sale.Id          AS Id
              , MovementItem_Sale.GoodsId     AS GoodsId
              , Object_Goods.ObjectCode       AS GoodsCode
              , Object_Goods.ValueData        AS GoodsName
              , tmpMarion.MorionCode        :: Integer
              , ObjectLink_Goods_GoodsGroup.GoodsGroupName         :: TVarChar
              , ObjectLink_Goods_ConditionsKeep.ConditionsKeepName :: TVarChar
              , COALESCE (tmp_PartionNDS.NDS, ObjectLink_Goods_NDS.NDS) :: TFloat AS NDS
              , MovementItem_Sale.Amount      AS Amount
              , MovementItemContainer.Amount::TFloat                  AS AmountDeferred
              , NULLIF(COALESCE(tmpRemains.Amount, 0) +
                COALESCE(MovementItemContainer.Amount, 0), 0)::TFloat AS AmountRemains
              , MovementItem_Sale.Price       AS Price
              , MovementItem_Sale.PriceSale
              , MovementItem_Sale.ChangePercent
              , MovementItem_Sale.Summ
              , MovementItem_Sale.isSP
              , tmpMarion.isResolution_224 ::Boolean
              , MovementItem_Sale.IsErased    AS isErased
            FROM MovementItem_Sale
                LEFT OUTER JOIN tmpRemains ON tmpRemains.GoodsId = MovementItem_Sale.GoodsId
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE(MovementItem_Sale.GoodsId,tmpRemains.GoodsId)
                LEFT JOIN MovementItemContainer ON MovementItemContainer.Id = MovementItem_Sale.Id 
                -- ������ ������
                LEFT JOIN tmpObjectLink_GoodsGroup AS ObjectLink_Goods_GoodsGroup
                                                   ON ObjectLink_Goods_GoodsGroup.GoodsId = Object_Goods.Id
                -- ������� ��������
                LEFT JOIN tmpObjectLink_ConditionsKeep AS ObjectLink_Goods_ConditionsKeep 
                                                       ON ObjectLink_Goods_ConditionsKeep.GoodsId = Object_Goods.Id
                -- ���
                LEFT JOIN tmpObjectLink_NDS AS ObjectLink_Goods_NDS 
                                            ON ObjectLink_Goods_NDS.GoodsId = Object_Goods.Id
                -- ��� ������
                LEFT JOIN tmpMarion ON tmpMarion.GoodsId = Object_Goods.Id
                LEFT JOIN tmp_PartionNDS ON tmp_PartionNDS.MI_Id = MovementItem_Sale.Id
                ;
     END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.   ������ �.�.
 27.04.20         * add tmp_PartionNDS
 21.01.20                                                                         * �����������
 24.11.19         *
 18.01.17         *
 22.02.17         *
 13.10.15                                                          *
*/
-- select * from gpSelect_MovementItem_Sale (inMovementId := 16414253  , inShowAll := 'true' , inIsErased := 'true' ,  inSession := '3');  --16407772  
