-- Function: gpSelect_MovementItem_Sale()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Sale (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Sale(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
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
             , isErased Boolean
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbUnitId Integer;
    DECLARE vbSPKindId Integer;
    DECLARE vbStatusId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Sale());
    vbUserId:= lpGetUserBySession (inSession);

    -- определяется подразделение
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

    -- Результат
    IF inShowAll THEN
        -- Результат такой
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
              , MovementItemContainer AS (SELECT MovementItemContainer.MovementItemID     AS Id
                                               , SUM(-MovementItemContainer.Amount)       AS Amount
                                      FROM  MovementItemContainer
                                      WHERE MovementItemContainer.MovementId = inMovementId
                                        AND vbStatusId = zc_Enum_Status_UnComplete() 
                                      GROUP BY MovementItemContainer.MovementItemID
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
                                   , MAX (Object_LinkGoods_Marion.GoodsCodeint) AS MorionCode
                              FROM (SELECT DISTINCT tmpRemains.GoodsId FROM tmpRemains) AS tmpGoods
                                   JOIN Object_LinkGoods_View ON Object_LinkGoods_View.GoodsId = tmpGoods.GoodsId 
                                   JOIN Object_LinkGoods_View AS Object_LinkGoods_Marion -- связь товара в прайсе с главным товаром
                                                              ON Object_LinkGoods_Marion.GoodsMainId = Object_LinkGoods_View.GoodsMainId
                                                             AND Object_LinkGoods_Marion.ObjectId = zc_Enum_GlobalConst_Marion() --tmpMI_Master.JuridicalId
                              GROUP BY tmpGoods.GoodsId
                              )
            --
            SELECT COALESCE(MovementItem_Sale.Id,0)                      AS Id
                 , Object_Goods.Id                                       AS GoodsId
                 , Object_Goods.ObjectCode                               AS GoodsCode
                 , Object_Goods.ValueData                                AS GoodsName
                 , tmpMarion.MorionCode        :: Integer
                 , ObjectLink_Goods_GoodsGroup.GoodsGroupName         :: TVarChar
                 , ObjectLink_Goods_ConditionsKeep.ConditionsKeepName :: TVarChar
                 , ObjectLink_Goods_NDS.NDS    :: TFloat
                 , MovementItem_Sale.Amount                              AS Amount
                 , MovementItemContainer.Amount::TFloat                  AS AmountDeferred
                 , NULLIF(COALESCE(tmpRemains.Amount, 0) +
                   COALESCE(MovementItemContainer.Amount, 0), 0)::TFloat AS AmountRemains
                 , COALESCE(MovementItem_Sale.Price, tmpPrice.Price)     AS Price
                 , COALESCE(MovementItem_Sale.PriceSale, tmpPrice.Price) AS PriceSale
                 , CASE WHEN vbSPKindId = zc_Enum_SPKind_1303() THEN COALESCE (MovementItem_Sale.ChangePercent, 100) ELSE MovementItem_Sale.ChangePercent END :: TFloat AS ChangePercent
                 , MovementItem_Sale.Summ
                 , MovementItem_Sale.isSP ::Boolean
                 , COALESCE(MovementItem_Sale.IsErased,FALSE)            AS isErased
            FROM tmpRemains
                FULL OUTER JOIN MovementItem_Sale ON tmpRemains.GoodsId = MovementItem_Sale.GoodsId
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE(MovementItem_Sale.GoodsId,tmpRemains.GoodsId)
                LEFT JOIN MovementItemContainer ON MovementItemContainer.Id = MovementItem_Sale.Id 
                LEFT JOIN tmpPrice ON tmpPrice.GoodsId =  COALESCE(MovementItem_Sale.GoodsId,tmpRemains.GoodsId)

                -- группа товара
                LEFT JOIN tmpObjectLink_GoodsGroup AS ObjectLink_Goods_GoodsGroup
                                                   ON ObjectLink_Goods_GoodsGroup.GoodsId = Object_Goods.Id
                -- условия хранения
                LEFT JOIN tmpObjectLink_ConditionsKeep AS ObjectLink_Goods_ConditionsKeep 
                                                       ON ObjectLink_Goods_ConditionsKeep.GoodsId = Object_Goods.Id
                -- НДС
                LEFT JOIN tmpObjectLink_NDS AS ObjectLink_Goods_NDS 
                                            ON ObjectLink_Goods_NDS.GoodsId = Object_Goods.Id
                -- код Марион
                LEFT JOIN tmpMarion ON tmpMarion.GoodsId = Object_Goods.Id
            WHERE Object_Goods.isErased = FALSE
               OR MovementItem_Sale.id is not null;
    ELSE
        -- Результат другой
        RETURN QUERY
            WITH
                tmpRemains AS (SELECT Container.ObjectId                  AS GoodsId
                                    , SUM(Container.Amount)::TFloat       AS Amount
                               FROM Container
                               WHERE Container.DescId = zc_Container_Count()
                                 AND Container.WhereObjectId = vbUnitId
                                 AND Container.Amount <> 0
                               GROUP BY Container.ObjectId
                               HAVING SUM(Container.Amount)<>0
                              )
              , MovementItem_Sale AS (SELECT MovementItem.Id                    AS Id
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
              , MovementItemContainer AS (SELECT MovementItemContainer.MovementItemID     AS Id
                                               , SUM(-MovementItemContainer.Amount)       AS Amount
                                      FROM  MovementItemContainer
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
                                   , MAX (Object_LinkGoods_Marion.GoodsCodeint) AS MorionCode
                              FROM (SELECT DISTINCT MovementItem_Sale.GoodsId FROM MovementItem_Sale) AS tmpGoods
                                   JOIN Object_LinkGoods_View ON Object_LinkGoods_View.GoodsId = tmpGoods.GoodsId 
                                   JOIN Object_LinkGoods_View AS Object_LinkGoods_Marion -- связь товара в прайсе с главным товаром
                                                              ON Object_LinkGoods_Marion.GoodsMainId = Object_LinkGoods_View.GoodsMainId
                                                             AND Object_LinkGoods_Marion.ObjectId = zc_Enum_GlobalConst_Marion() --tmpMI_Master.JuridicalId
                              GROUP BY tmpGoods.GoodsId
                              )


            SELECT
                MovementItem_Sale.Id          AS Id
              , MovementItem_Sale.GoodsId     AS GoodsId
              , Object_Goods.ObjectCode       AS GoodsCode
              , Object_Goods.ValueData        AS GoodsName
              , tmpMarion.MorionCode        :: Integer
              , ObjectLink_Goods_GoodsGroup.GoodsGroupName         :: TVarChar
              , ObjectLink_Goods_ConditionsKeep.ConditionsKeepName :: TVarChar
              , ObjectLink_Goods_NDS.NDS    :: TFloat
              , MovementItem_Sale.Amount      AS Amount
              , MovementItemContainer.Amount::TFloat                  AS AmountDeferred
              , NULLIF(COALESCE(tmpRemains.Amount, 0) +
                COALESCE(MovementItemContainer.Amount, 0), 0)::TFloat AS AmountRemains
              , MovementItem_Sale.Price       AS Price
              , MovementItem_Sale.PriceSale
              , MovementItem_Sale.ChangePercent
              , MovementItem_Sale.Summ
              , MovementItem_Sale.isSP
              , MovementItem_Sale.IsErased    AS isErased
            FROM MovementItem_Sale
                LEFT OUTER JOIN tmpRemains ON tmpRemains.GoodsId = MovementItem_Sale.GoodsId
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE(MovementItem_Sale.GoodsId,tmpRemains.GoodsId)
                LEFT JOIN MovementItemContainer ON MovementItemContainer.Id = MovementItem_Sale.Id 
                -- группа товара
                LEFT JOIN tmpObjectLink_GoodsGroup AS ObjectLink_Goods_GoodsGroup
                                                   ON ObjectLink_Goods_GoodsGroup.GoodsId = Object_Goods.Id
                -- условия хранения
                LEFT JOIN tmpObjectLink_ConditionsKeep AS ObjectLink_Goods_ConditionsKeep 
                                                       ON ObjectLink_Goods_ConditionsKeep.GoodsId = Object_Goods.Id
                -- НДС
                LEFT JOIN tmpObjectLink_NDS AS ObjectLink_Goods_NDS 
                                            ON ObjectLink_Goods_NDS.GoodsId = Object_Goods.Id
                -- код Марион
                LEFT JOIN tmpMarion ON tmpMarion.GoodsId = Object_Goods.Id
                ;
     END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.
 24.11.19         *
 18.01.17         *
 22.02.17         *
 13.10.15                                                          *
*/
-- select * from gpSelect_MovementItem_Sale (inMovementId := 16414253  , inShowAll := 'true' , inIsErased := 'true' ,  inSession := '3');  --16407772  