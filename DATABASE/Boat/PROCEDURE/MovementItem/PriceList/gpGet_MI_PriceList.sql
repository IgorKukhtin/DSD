-- Function: gpGet_MI_PriceList()

DROP FUNCTION IF EXISTS gpGet_MI_PriceList (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_PriceList(
    IN inMovementId        Integer    , -- Ключ объекта <Документ>
    IN inGoodsId           Integer    , -- вариант когда выбирают товар из справочника
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Article TVarChar
             , GoodsGroupNameFull TVarChar, GoodsGroupName TVarChar
             , DiscountPartnerId Integer, DiscountPartnerName TVarChar
             , MeasureId Integer, MeasureName TVarChar
             , MeasureParentId Integer, MeasureParentName TVarChar
             , Amount        TFloat
             , MeasureMult   TFloat
             , PriceParent   TFloat
             , EmpfPriceParent TFloat
             , MinCount      TFloat
             , MinCountMult  TFloat
             , WeightParent  TFloat
             , CatalogPage TVarChar
             , isOutlet Boolean
              )
AS
$BODY$
  DECLARE vbUserId   Integer;
  DECLARE vbUnitId   Integer;
  DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     RETURN QUERY
       WITH
            tmpMI AS (SELECT MI.ObjectId AS GoodsId
                           , MI.Amount
                           , MI.Id
                      FROM MovementItem AS MI
                      WHERE MI.MovementId = inMovementId
                        AND MI.DescId     = zc_MI_Master()
                        AND MI.ObjectId   = inGoodsId
                        AND MI.isErased   = FALSE
                      Limit 1 -- 
                      )

           SELECT COALESCE (MovementItem.Id,0)     :: Integer AS Id
                , Object_Goods.Id                             AS GoodsId
                , Object_Goods.ObjectCode                     AS GoodsCode
                , Object_Goods.ValueData                      AS GoodsName
                , ObjectString_Article.ValueData              AS Article
                , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                , Object_GoodsGroup.ValueData                 AS GoodsGroupName

                , Object_DiscountPartner.Id        AS DiscountPartnerId
                , Object_DiscountPartner.ValueData AS DiscountPartnerName
                , Object_Measure.Id                AS MeasureId
                , Object_Measure.ValueData         AS MeasureName
                , Object_MeasureParent.Id          AS MeasureParentId
                , Object_MeasureParent.ValueData   AS MeasureParentName

                , MovementItem.Amount          ::TFloat
                , COALESCE (MIFloat_MeasureMult.ValueData, 0) ::TFloat    AS MeasureMult
                , COALESCE (MIFloat_PriceParent.ValueData, 0) ::TFloat    AS PriceParent
                , COALESCE (MIFloat_EmpfPriceParent.ValueData, 0)::TFloat AS EmpfPriceParent
                
                , COALESCE (MIFloat_MinCount.ValueData, 0)    ::TFloat    AS MinCount
                , COALESCE (MIFloat_MinCountMult.ValueData, 0)::TFloat    AS MinCountMult
                , COALESCE (MIFloat_WeightParent.ValueData, 0)::TFloat    AS WeightParent

                , MIString_CatalogPage.ValueData ::TVarChar AS CatalogPage
                , COALESCE (MIBoolean_Outlet.ValueData, FALSE) ::Boolean  AS isOutlet
           FROM Object AS Object_Goods
                LEFT JOIN tmpMI AS MovementItem
                                ON MovementItem.GoodsId    = Object_Goods.Id

                LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                     ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                    AND ObjectLink_Goods_GoodsGroup.DescId   = zc_ObjectLink_Goods_GoodsGroup()
                LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                       ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                      AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

                LEFT JOIN ObjectString AS ObjectString_Article
                                       ON ObjectString_Article.ObjectId = Object_Goods.Id
                                      AND ObjectString_Article.DescId = zc_ObjectString_Article()

                LEFT JOIN MovementItemFloat AS MIFloat_EmpfPriceParent
                                            ON MIFloat_EmpfPriceParent.MovementItemId = MovementItem.Id
                                           AND MIFloat_EmpfPriceParent.DescId = zc_MIFloat_EmpfPriceParent()
                LEFT JOIN MovementItemFloat AS MIFloat_MeasureMult
                                            ON MIFloat_MeasureMult.MovementItemId = MovementItem.Id
                                           AND MIFloat_MeasureMult.DescId = zc_MIFloat_MeasureMult()
                LEFT JOIN MovementItemFloat AS MIFloat_PriceParent
                                            ON MIFloat_PriceParent.MovementItemId = MovementItem.Id
                                           AND MIFloat_PriceParent.DescId = zc_MIFloat_PriceParent()
                LEFT JOIN MovementItemFloat AS MIFloat_MinCount
                                            ON MIFloat_MinCount.MovementItemId = MovementItem.Id
                                           AND MIFloat_MinCount.DescId = zc_MIFloat_MinCount()
                LEFT JOIN MovementItemFloat AS MIFloat_MinCountMult
                                            ON MIFloat_MinCountMult.MovementItemId = MovementItem.Id
                                           AND MIFloat_MinCountMult.DescId = zc_MIFloat_MinCountMult()
                LEFT JOIN MovementItemFloat AS MIFloat_WeightParent
                                            ON MIFloat_WeightParent.MovementItemId = MovementItem.Id
                                           AND MIFloat_WeightParent.DescId = zc_MIFloat_WeightParent()

                LEFT JOIN MovementItemBoolean AS MIBoolean_Outlet
                                              ON MIBoolean_Outlet.MovementItemId = MovementItem.Id
                                             AND MIBoolean_Outlet.DescId = zc_MIBoolean_Outlet()

                LEFT JOIN MovementItemString AS MIString_CatalogPage
                                             ON MIString_CatalogPage.MovementItemId = MovementItem.Id
                                            AND MIString_CatalogPage.DescId = zc_MIString_CatalogPage()

                LEFT JOIN MovementItemLinkObject AS MILO_DiscountPartner
                                                 ON MILO_DiscountPartner.MovementItemId = MovementItem.Id
                                                AND MILO_DiscountPartner.DescId = zc_MILinkObject_DiscountPartner()
                LEFT JOIN Object AS Object_DiscountPartner ON Object_DiscountPartner.Id = MILO_DiscountPartner.ObjectId

                LEFT JOIN MovementItemLinkObject AS MILO_Measure
                                                 ON MILO_Measure.MovementItemId = MovementItem.Id
                                                AND MILO_Measure.DescId = zc_MILinkObject_Measure()
                LEFT JOIN MovementItemLinkObject AS MILO_MeasureParent
                                                 ON MILO_MeasureParent.MovementItemId = MovementItem.Id
                                                AND MILO_MeasureParent.DescId = zc_MILinkObject_MeasureParent()

                LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = MILO_Measure.ObjectId
                LEFT JOIN Object AS Object_MeasureParent ON Object_MeasureParent.Id = MILO_MeasureParent.ObjectId


           WHERE Object_Goods.Id = inGoodsId
             AND inGoodsId <> 0

          UNION
           SELECT 0    :: Integer  AS Id
                , 0                AS GoodsId
                , 0                AS GoodsCode
                , '' ::TVarChar    AS GoodsName
                , '' ::TVarChar    AS Article
                , '' ::TVarChar    AS GoodsGroupNameFull
                , '' ::TVarChar    AS GoodsGroupName

                , 0                AS DiscountPartnerId
                , '' ::TVarChar    AS DiscountPartnerName
                , 0                AS MeasureId
                , '' ::TVarChar    AS MeasureName
                , 0                AS MeasureParentId
                , '' ::TVarChar    AS MeasureParentName

                , 0  ::TFloat      AS Amount
                , 0  ::TFloat      AS MeasureMult
                , 0  ::TFloat      AS PriceParent
                , 0  ::TFloat      AS EmpfPriceParent
                
                , 0  ::TFloat      AS MinCount
                , 0  ::TFloat      AS MinCountMult
                , 0  ::TFloat      AS WeightParent

                , '' ::TVarChar    AS CatalogPage
                , FALSE ::Boolean  AS isOutlet
                
           WHERE inGoodsId = 0
          ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*                                                                             
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.05.22         *
*/

-- тест
-- SELECT * FROM gpGet_MI_PriceList (inMovementId := 604 , inGoodsId := 16242 , inSession := '5');
