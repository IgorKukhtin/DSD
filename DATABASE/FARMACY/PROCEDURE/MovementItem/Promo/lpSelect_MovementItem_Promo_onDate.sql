--- Function: lpSelect_MovementItem_Promo_onDate()


DROP FUNCTION IF EXISTS lpSelect_MovementItem_Promo_onDate (TDateTime);

CREATE OR REPLACE FUNCTION lpSelect_MovementItem_Promo_onDate(
    IN inOperDate    TDateTime     -- 
)
RETURNS TABLE (MovementId Integer
             , JuridicalId Integer
             , isNotUseSUN boolean
             , GoodsId Integer
             , ChangePercent TFloat
             , MakerID Integer
             , InvNumber TVarChar
             , RelatedProductId Integer
             , GoodsGroupPromoName TVarChar
              )
AS
$BODY$
BEGIN
           -- Результат
           RETURN QUERY
           WITH 
                
            tmpMovement AS (SELECT Movement.Id                                        AS MovementId
                              , Movement.InvNumber                                    AS InvNumber
                              , MovementLinkObject_Maker.ObjectId                     AS MakerID
                              , COALESCE (MovementFloat_ChangePercent.ValueData, 0)   AS ChangePercent
                              , MovementDate_EndPromo.ValueData                       AS EndPromo 
                              , MovementLinkMovement_RelatedProduct.MovementChildId   AS RelatedProductId
                              , COALESCE(MovementBoolean_NotUseSUN.ValueData, FALSE)  AS isNotUseSUN
                         FROM Movement
                              INNER JOIN MovementDate AS MovementDate_StartPromo
                                                      ON MovementDate_StartPromo.MovementId = Movement.Id
                                                     AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
                                                     AND MovementDate_StartPromo.ValueData <= inOperDate
                              INNER JOIN MovementDate AS MovementDate_EndPromo
                                                      ON MovementDate_EndPromo.MovementId = Movement.Id
                                                     AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()
                                                     AND MovementDate_EndPromo.ValueData >= inOperDate
                              LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                                      ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                                     AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_Maker
                                                           ON MovementLinkObject_Maker.MovementId = Movement.Id
                                                          AND MovementLinkObject_Maker.DescId = zc_MovementLinkObject_Maker()
                              LEFT JOIN MovementLinkMovement AS MovementLinkMovement_RelatedProduct
                                                             ON MovementLinkMovement_RelatedProduct.MovementId = Movement.Id
                                                            AND MovementLinkMovement_RelatedProduct.DescId = zc_MovementLinkMovement_RelatedProduct()                                                     
                              LEFT JOIN MovementBoolean AS MovementBoolean_NotUseSUN
                                                        ON MovementBoolean_NotUseSUN.MovementId = Movement.Id
                                                       AND MovementBoolean_NotUseSUN.DescId = zc_MovementBoolean_NotUseSUN()

                         WHERE Movement.StatusId = zc_Enum_Status_Complete()
                           AND Movement.DescId = zc_Movement_Promo()), 
            tmpMI AS (SELECT Movement.MovementId               AS MovementId
                           , Movement.InvNumber                AS InvNumber
                           , Movement.MakerID                  AS MakerID
                           , Movement.isNotUseSUN              AS isNotUseSUN
                           , MI_Juridical.ObjectId             AS JuridicalId
                           , MI_Goods.ObjectId                 AS GoodsId
                           , Movement.ChangePercent            AS ChangePercent
                           , Movement.RelatedProductId         AS RelatedProductId
                           , Object_GoodsGroupPromo.ValueData  AS GoodsGroupPromoName
                           , ROW_NUMBER() OVER (PARTITION BY MI_Juridical.ObjectId, MI_Goods.ObjectId ORDER BY MI_Juridical.ObjectId, MI_Goods.ObjectId, Movement.EndPromo DESC, Movement.MovementId DESC) AS Ord
                      FROM tmpMovement AS Movement
  
                           INNER JOIN MovementItem AS MI_Goods ON MI_Goods.MovementId = Movement.MovementId
                                                              AND MI_Goods.DescId = zc_MI_Master()
                                                              AND MI_Goods.isErased = FALSE
                                                              
                           LEFT JOIN MovementItem AS MI_Juridical ON MI_Juridical.MovementId = Movement.MovementId
                                                                 AND MI_Juridical.DescId = zc_MI_Child()
                                                                 AND MI_Juridical.isErased = FALSE

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupPromo 
                                                ON ObjectLink_Goods_GoodsGroupPromo.ObjectId = MI_Goods.ObjectId 
                                               AND ObjectLink_Goods_GoodsGroupPromo.DescId = zc_ObjectLink_Goods_GoodsGroupPromo()
                           LEFT JOIN Object AS Object_GoodsGroupPromo ON Object_GoodsGroupPromo.Id = ObjectLink_Goods_GoodsGroupPromo.ChildObjectId

                     )
                        
            SELECT tmp.MovementId
                 , tmp.JuridicalId
                 , tmp.isNotUseSUN
                 , tmp.GoodsId        -- здесь товар "сети"
                 , tmp.ChangePercent :: TFloat AS ChangePercent
                 , tmp.MakerID
                 , tmp.InvNumber                AS InvNumber
                 , tmp.RelatedProductId         AS RelatedProductId
                 , tmp.GoodsGroupPromoName      AS GoodsGroupPromoName
            FROM tmpMI AS tmp
            WHERE tmp.Ord = 1 -- т.е. выбираем "последний"
            ;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.  Шаблий О.В.
 14.10.18                                                                       *
 12.04.17         *
 28.04.16                                        *
*/

-- SELECT * FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= CURRENT_DATE);