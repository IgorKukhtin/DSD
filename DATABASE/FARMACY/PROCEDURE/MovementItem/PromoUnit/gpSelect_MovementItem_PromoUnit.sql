-- Function: gpSelect_MovementItem_PromoUnit()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PromoUnit (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PromoUnit(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat, AmountPlanMax TFloat
             , Price TFloat
             , Summ TFloat, SummPlanMax TFloat 
             , Comment TVarChar
             , isFixedPercent Boolean
             , AddBonusPercent TFloat
             , MakerPromoName  TVarChar
             , isErased Boolean
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbObjectId Integer;
    DECLARE vbUnitId Integer;
    DECLARE vbUnitCategoryId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_PromoUnit());
    vbUserId:= lpGetUserBySession (inSession);

    -- поиск <Торговой сети>
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    vbUnitId := (SELECT ML.ObjectId FROM MovementLinkObject AS ML WHERE  ML.MovementId = inMovementId AND ML.DescId = zc_MovementLinkObject_Unit());
    vbUnitCategoryId := (SELECT ML.ObjectId FROM MovementLinkObject AS ML WHERE  ML.MovementId = inMovementId AND ML.DescId = zc_MovementLinkObject_UnitCategory());
    
     -- Маркетинговый контракт
     CREATE TEMP TABLE _tmpGoodsPromo ON COMMIT DROP AS (
      WITH GoodsPromoAll AS (SELECT tmp.GoodsId                     AS GoodsId  -- главный товар
                                  , Object_Maker.ValueData          AS MakerPromoName
                                  , tmp.GoodsGroupPromoName
                                  , ROW_NUMBER() OVER (PARTITION BY tmp.GoodsId ORDER BY tmp.MovementId DESC) AS Ord
                             FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= CURRENT_DATE) AS tmp   --CURRENT_DATE
                                  INNER JOIN Object AS Object_Maker
                                                    ON Object_Maker.Id = tmp.MakerId
                             )

      SELECT GoodsPromoAll.GoodsId
           , GoodsPromoAll.MakerPromoName
           , GoodsPromoAll.GoodsGroupPromoName
      FROM GoodsPromoAll 
      WHERE GoodsPromoAll.Ord = 1);
      
     ANALYSE _tmpGoodsPromo;
    
    -- Результат
    IF inShowAll THEN
        -- Результат такой
        RETURN QUERY
            WITH 
            tmpPrice AS (SELECT Price_Goods.ChildObjectId               AS GoodsId
                              , ROUND(SUM(CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                                AND ObjectFloat_Goods_Price.ValueData > 0
                                               THEN ObjectFloat_Goods_Price.ValueData
                                               ELSE Price_Value.ValueData END) / COUNT(*), 2)::TFloat  AS Price 
                         FROM ObjectLink AS ObjectLink_Price_Unit
                              LEFT JOIN ObjectLink AS Price_Goods
                                     ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                    AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                              LEFT JOIN ObjectFloat AS Price_Value
                                     ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                    AND Price_Value.DescId =  zc_ObjectFloat_Price_Value()
                              -- Фикс цена для всей Сети
                              LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                     ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                                    AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                              LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                      ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                                     AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                         WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                           AND (ObjectLink_Price_Unit.ChildObjectId = vbUnitId     
                            OR ObjectLink_Price_Unit.ChildObjectId in (SELECT ObjectLink.ObjectId 
                                                                       FROM ObjectLink 
                                                                       WHERE ObjectLink.DescId = zc_ObjectLink_Unit_Category() 
                                                                         AND ObjectLink.ChildObjectId = vbUnitCategoryId))
                         GROUP BY Price_Goods.ChildObjectId
                         )

        , MI_PromoUnit AS (SELECT MI_PromoUnit.Id
                                , MI_PromoUnit.ObjectId       AS GoodsId
                                , MI_PromoUnit.Amount
                                , MIFloat_AmountPlanMax.ValueData  ::TFloat AS AmountPlanMax
                                , MIFloat_Price.ValueData AS Price
                                , COALESCE(MI_PromoUnit.Amount,0) * COALESCE(MIFloat_Price.ValueData,0) AS Summ
                                , COALESCE(MIFloat_AmountPlanMax.ValueData,0) * COALESCE(MIFloat_Price.ValueData,0) AS SummPlanMax
                                , MIString_Comment.ValueData       ::TVarChar AS Comment
                                , COALESCE (MIBoolean_FixedPercent.ValueData, FALSE)                                AS isFixedPercent
                                , MIFloat_AddBonusPercent.ValueData                                                 AS AddBonusPercent
                                , MI_PromoUnit.IsErased
                         FROM MovementItem AS MI_PromoUnit
                             LEFT JOIN MovementItemString AS MIString_Comment
                                                          ON MIString_Comment.MovementItemId = MI_PromoUnit.Id
                                                         AND MIString_Comment.DescId = zc_MIString_Comment()
                             LEFT JOIN MovementItemFloat AS MIFloat_AmountPlanMax
                                                         ON MIFloat_AmountPlanMax.MovementItemId = MI_PromoUnit.Id
                                                        AND MIFloat_AmountPlanMax.DescId = zc_MIFloat_AmountPlanMax()

                             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                         ON MIFloat_Price.MovementItemId = MI_PromoUnit.Id
                                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
                             LEFT JOIN MovementItemFloat AS MIFloat_AddBonusPercent
                                                         ON MIFloat_AddBonusPercent.MovementItemId = MI_PromoUnit.Id
                                                        AND MIFloat_AddBonusPercent.DescId = zc_MIFloat_AddBonusPercent()

                             LEFT JOIN MovementItemBoolean AS MIBoolean_FixedPercent
                                                           ON MIBoolean_FixedPercent.MovementItemId = MI_PromoUnit.Id
                                                          AND MIBoolean_FixedPercent.DescId = zc_MIBoolean_FixedPercent()
                         WHERE MI_PromoUnit.MovementId = inMovementId
                           AND MI_PromoUnit.DescId = zc_MI_Master()
                           AND (MI_PromoUnit.isErased = FALSE or inIsErased = TRUE)
                         )

            SELECT COALESCE(MI_PromoUnit.Id,0)           AS Id
                 , Object_Goods.Id                       AS GoodsId
                 , Object_Goods.ObjectCode               AS GoodsCode
                 , Object_Goods.ValueData                AS GoodsName
                 , MI_PromoUnit.Amount                   AS Amount
                 , MI_PromoUnit.AmountPlanMax            AS AmountPlanMax
                 , COALESCE(MI_PromoUnit.Price,tmpPrice.Price) ::TFloat   AS Price
                 , MI_PromoUnit.Summ              ::TFloat   AS Summ
                 , MI_PromoUnit.SummPlanMax       ::TFloat   AS SummPlanMax
                 , COALESCE(MI_PromoUnit.Comment, '') ::TVarChar AS Comment
                 , COALESCE(MI_PromoUnit.isFixedPercent, False) ::BOOLEAN AS isFixedPercent
                 , MI_PromoUnit.AddBonusPercent              AS AddBonusPercent
                 , GoodsPromo.MakerPromoName                                                                  AS MakerPromoName 
                 , COALESCE(MI_PromoUnit.IsErased,FALSE)     AS isErased
            FROM tmpPrice
                FULL OUTER JOIN MI_PromoUnit ON tmpPrice.GoodsId = MI_PromoUnit.GoodsId
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE(MI_PromoUnit.GoodsId,tmpPrice.GoodsId)
                LEFT JOIN _tmpGoodsPromo AS GoodsPromo ON GoodsPromo.GoodsId = Object_Goods.Id
            WHERE Object_Goods.isErased = FALSE 
               OR MI_PromoUnit.id is not null;
    ELSE
        -- Результат другой
        RETURN QUERY
           SELECT MI_PromoUnit.Id
                , MI_PromoUnit.ObjectId                AS GoodsId
                , Object_Goods.ObjectCode              AS GoodsCode
                , Object_Goods.ValueData               AS GoodsName
                , MI_PromoUnit.Amount              ::TFloat 
                , MIFloat_AmountPlanMax.ValueData  ::TFloat AS AmountPlanMax
                , MIFloat_Price.ValueData          ::TFloat AS Price
                , (COALESCE(MI_PromoUnit.Amount,0) * COALESCE(MIFloat_Price.ValueData,0))           ::TFloat AS Summ
                , (COALESCE(MIFloat_AmountPlanMax.ValueData,0) * COALESCE(MIFloat_Price.ValueData,0)) ::TFloat AS SummPlanMax
                , MIString_Comment.ValueData       ::TVarChar AS Comment
                , COALESCE (MIBoolean_FixedPercent.ValueData, FALSE)                                         AS isFixedPercent
                , MIFloat_AddBonusPercent.ValueData                                                          AS AddBonusPercent
                , GoodsPromo.MakerPromoName                                                                  AS MakerPromoName 
                , MI_PromoUnit.IsErased
           FROM MovementItem AS MI_PromoUnit
              LEFT JOIN MovementItemString AS MIString_Comment
                                           ON MIString_Comment.MovementItemId = MI_PromoUnit.Id
                                          AND MIString_Comment.DescId = zc_MIString_Comment()

              LEFT JOIN MovementItemFloat AS MIFloat_AmountPlanMax
                                          ON MIFloat_AmountPlanMax.MovementItemId = MI_PromoUnit.Id
                                         AND MIFloat_AmountPlanMax.DescId = zc_MIFloat_AmountPlanMax()
              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                          ON MIFloat_Price.MovementItemId = MI_PromoUnit.Id
                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()
              LEFT JOIN MovementItemFloat AS MIFloat_AddBonusPercent
                                          ON MIFloat_AddBonusPercent.MovementItemId = MI_PromoUnit.Id
                                         AND MIFloat_AddBonusPercent.DescId = zc_MIFloat_AddBonusPercent()

              LEFT JOIN MovementItemBoolean AS MIBoolean_FixedPercent
                                            ON MIBoolean_FixedPercent.MovementItemId = MI_PromoUnit.Id
                                           AND MIBoolean_FixedPercent.DescId = zc_MIBoolean_FixedPercent()

              LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MI_PromoUnit.ObjectId              
              
              LEFT JOIN _tmpGoodsPromo AS GoodsPromo ON GoodsPromo.GoodsId = MI_PromoUnit.ObjectId
              
           WHERE MI_PromoUnit.MovementId = inMovementId
             AND MI_PromoUnit.DescId = zc_MI_Master()
             AND (MI_PromoUnit.isErased = FALSE or inIsErased = TRUE);
     END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.
 12.06.17         *
 04.02.17         *
*/

--

select * from gpSelect_MovementItem_PromoUnit(inMovementId := 30890062 , inShowAll := 'True' , inIsErased := 'False' ,  inSession := '3');