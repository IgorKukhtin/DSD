-- Function: gpSelect_MovementItem_PriceList()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PriceList (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PriceList(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat, Price TFloat
             , PartionGoodsDate TDateTime, Remains TFloat, GoodsJuridicalName TVarChar
             , AreaName TVarChar
             , isSupplierFailures Boolean, DateUpdate TDateTime, UserUpdate TVarChar
             , SupplierFailuresColor Integer
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_PriceList());
     vbUserId := inSession;

     IF inShowAll THEN

     RETURN QUERY
       WITH tmpSupplierFailures AS (SELECT MovementItem.ObjectId                AS GoodsId 
                                         , COALESCE(MIBoolean_SupplierFailures.ValueData, False) AS isSupplierFailures
                                         , MIDate_Update.ValueData              AS DateUpdate
                                         , Object_Update.ValueData              AS UserUpdate
                                    FROM MovementItem
                                       
                                         LEFT JOIN MovementItemBoolean AS MIBoolean_SupplierFailures
                                                                       ON MIBoolean_SupplierFailures.MovementItemId = MovementItem.Id
                                                                      AND MIBoolean_SupplierFailures.DescId = zc_MIBoolean_SupplierFailures()
                                         
                                         LEFT JOIN MovementItemDate AS MIDate_Update
                                                                    ON MIDate_Update.MovementItemId =  MovementItem.Id
                                                                   AND MIDate_Update.DescId = zc_MIDate_Update()

                                         LEFT JOIN MovementItemLinkObject AS MILinkObject_Update
                                                                          ON MILinkObject_Update.MovementItemId = MovementItem.Id
                                                                         AND MILinkObject_Update.DescId = zc_MILinkObject_Update()
                                         LEFT JOIN Object AS Object_Update ON Object_Update.Id = MILinkObject_Update.ObjectId
                                    WHERE MovementItem.MovementId = inMovementId
                                      AND MovementItem.DescId = zc_MI_Child())

       SELECT
             0                          AS Id
           , tmpGoods.GoodsId           AS GoodsId
           , tmpGoods.GoodsCode         AS GoodsCode
           , tmpGoods.GoodsName         AS GoodsName
           , CAST (NULL AS TFloat)      AS Amount
           , CAST (NULL AS TFloat)      AS Price
           , CAST (NULL AS TDateTime)   AS PartionGoodsDate
           , 0.00::TFloat               AS Remains
           , ''::TVarChar               AS GoodsJuridicalName
           , ''::TVarChar               AS AreaName
           , False                      AS isSupplierFailures
           , NULL::TDateTime            AS DateUpdate
           , ''::TVarChar               AS UserUpdate
           , zc_Color_White()           AS SupplierFailuresColor
           , FALSE                      AS isErased

       FROM (SELECT Object_Goods.Id              AS GoodsId
                  , Object_Goods.ObjectCode      AS GoodsCode
                  , Object_Goods.ValueData       AS GoodsName
             FROM Object AS Object_Goods
             WHERE Object_Goods.DescId = zc_Object_Goods() AND Object_Goods.isErased = FALSE
            ) AS tmpGoods

            LEFT JOIN (SELECT MovementItem.ObjectId                         AS GoodsId
                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                      ) AS tmpMI ON tmpMI.GoodsId     = tmpGoods.GoodsId

       WHERE tmpMI.GoodsId IS NULL

      UNION ALL
       SELECT
             MovementItem.Id                      AS Id
           , Object_Goods.Id                      AS GoodsId
           , Object_Goods.ObjectCode              AS GoodsCode
           , Object_Goods.ValueData               AS GoodsName
           , MovementItem.Amount                  AS Amount
           , COALESCE(MIFloat_Price.ValueData,0)::TFloat  AS Price
           , MIDate_PartionGoods.ValueData        AS PartionGoodsDate
           , MIFloat_Remains.ValueData            AS Remains
           , Object_JuridicalGoods.ValueData      AS GoodsJuridicalName
           , Object_Area.ValueData                AS AreaName
           , COALESCE(tmpSupplierFailures.isSupplierFailures, False) AS isSupplierFailures
           , tmpSupplierFailures.DateUpdate
           , tmpSupplierFailures.UserUpdate
           , CASE WHEN COALESCE(tmpSupplierFailures.isSupplierFailures, False) = TRUE 
                  THEN zfCalc_Color (255, 165, 0) -- orange
                  ELSE zc_Color_White()
              END  AS SupplierFailuresColor
           , MovementItem.isErased                AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                       ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                      AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

            LEFT JOIN MovementItemFloat AS MIFloat_Remains
                                        ON MIFloat_Remains.MovementItemId =  MovementItem.Id
                                       AND MIFloat_Remains.DescId = zc_MIFloat_Remains()

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId =  MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                             ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
            LEFT JOIN Object AS Object_JuridicalGoods ON Object_JuridicalGoods.Id = MILinkObject_Goods.ObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Area 
                                 ON ObjectLink_Goods_Area.ObjectId = Object_JuridicalGoods.Id
                                AND ObjectLink_Goods_Area.DescId = zc_ObjectLink_Goods_Area()
            LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Goods_Area.ChildObjectId

            LEFT JOIN MovementItemBoolean AS MIBoolean_SupplierFailures
                                          ON MIBoolean_SupplierFailures.MovementItemId =  MovementItem.Id
                                         AND MIBoolean_SupplierFailures.DescId = zc_MIBoolean_SupplierFailures()

            LEFT JOIN MovementItemDate AS MIDate_Update
                                       ON MIDate_Update.MovementItemId =  MovementItem.Id
                                      AND MIDate_Update.DescId = zc_MIDate_Update()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Update
                                             ON MILinkObject_Update.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Update.DescId = zc_MILinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MILinkObject_Update.ObjectId
            ;

     ELSE

     RETURN QUERY
       WITH tmpSupplierFailures AS (SELECT MovementItem.ObjectId                AS GoodsId 
                                         , COALESCE(MIBoolean_SupplierFailures.ValueData, False) AS isSupplierFailures
                                         , MIDate_Update.ValueData              AS DateUpdate
                                         , Object_Update.ValueData              AS UserUpdate
                                    FROM MovementItem
                                       
                                         LEFT JOIN MovementItemBoolean AS MIBoolean_SupplierFailures
                                                                       ON MIBoolean_SupplierFailures.MovementItemId = MovementItem.Id
                                                                      AND MIBoolean_SupplierFailures.DescId = zc_MIBoolean_SupplierFailures()
                                         
                                         LEFT JOIN MovementItemDate AS MIDate_Update
                                                                    ON MIDate_Update.MovementItemId =  MovementItem.Id
                                                                   AND MIDate_Update.DescId = zc_MIDate_Update()

                                         LEFT JOIN MovementItemLinkObject AS MILinkObject_Update
                                                                          ON MILinkObject_Update.MovementItemId = MovementItem.Id
                                                                         AND MILinkObject_Update.DescId = zc_MILinkObject_Update()
                                         LEFT JOIN Object AS Object_Update ON Object_Update.Id = MILinkObject_Update.ObjectId
                                    WHERE MovementItem.MovementId = inMovementId
                                      AND MovementItem.DescId = zc_MI_Child())
                                      
       SELECT
             MovementItem.Id                      AS Id
           , Object_Goods.Id                      AS GoodsId
           , Object_Goods.ObjectCode              AS GoodsCode
           , Object_Goods.ValueData               AS GoodsName
           , MovementItem.Amount                  AS Amount
           , COALESCE(MIFloat_Price.ValueData,0)::TFloat  AS Price
           , MIDate_PartionGoods.ValueData        AS PartionGoodsDate
           , MIFloat_Remains.ValueData            AS Remains
           , Object_JuridicalGoods.ValueData      AS GoodsJuridicalName
           , Object_Area.ValueData                AS AreaName
           , COALESCE(tmpSupplierFailures.isSupplierFailures, False) AS isSupplierFailures
           , tmpSupplierFailures.DateUpdate
           , tmpSupplierFailures.UserUpdate
           , CASE WHEN COALESCE(tmpSupplierFailures.isSupplierFailures, False) = TRUE 
                  THEN zfCalc_Color (255, 165, 0) -- orange
                  ELSE zc_Color_White()
              END  AS SupplierFailuresColor
           , MovementItem.isErased                AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased

            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                       ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                      AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                             ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()

            LEFT JOIN MovementItemFloat AS MIFloat_Remains
                                        ON MIFloat_Remains.MovementItemId =  MovementItem.Id
                                       AND MIFloat_Remains.DescId = zc_MIFloat_Remains()

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId =  MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN Object AS Object_JuridicalGoods ON Object_JuridicalGoods.Id = MILinkObject_Goods.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Area 
                                 ON ObjectLink_Goods_Area.ObjectId = Object_JuridicalGoods.Id
                                AND ObjectLink_Goods_Area.DescId = zc_ObjectLink_Goods_Area()
            LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Goods_Area.ChildObjectId

            LEFT JOIN tmpSupplierFailures ON tmpSupplierFailures.GoodsId =  MILinkObject_Goods.ObjectId
            ;

     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_PriceList (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 21.10.17         * add AreaName
 19.02.16         *
 01.07.14                                                       *

*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_PriceList (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_PriceList (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')