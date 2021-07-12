-- Function: gpSelect_MI_ProductionUnion_Child()

DROP FUNCTION IF EXISTS gpSelect_MI_ProductionUnion_Child (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_ProductionUnion_Child(
    IN inMovementId       Integer      , -- ключ Документа
    IN inShowAll          Boolean      , --
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры

     vbUserId:= lpGetUserBySession (inSession);

    IF inShowAll
    THEN
     RETURN QUERY
     WITH
     tmpIsErased AS (SELECT FALSE AS isErased
                                UNION ALL
                               SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                              )
   , tmpMI_Master AS (SELECT MovementItem.Id
                           , MILO_ReceiptProdModel.ObjectId AS ReceiptProdModelId
                      FROM tmpIsErased
                           JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = tmpIsErased.isErased
                           INNER JOIN MovementItemLinkObject AS MILO_ReceiptProdModel
                                                             ON MILO_ReceiptProdModel.MovementItemId = MovementItem.Id
                                                            AND MILO_ReceiptProdModel.DescId = zc_MILinkObject_ReceiptProdModel()
                     )

   , tmpReceiptProdModelChild AS (SELECT tmpMI_Master.Id AS ParentId
                                       , Object_ReceiptProdModelChild.Id              AS Id 
                                       , Object_ReceiptProdModelChild.ValueData       AS Comment

                                       , ObjectFloat_Value.ValueData       ::TFloat   AS Value

                                       , ObjectLink_ReceiptProdModel.ChildObjectId ::Integer  AS ReceiptProdModelId

                                       , ObjectDesc.ItemName               ::TVarChar AS DescName
                                       , Object_Object.Id                  ::Integer  AS ObjectId
                                       , Object_Object.ObjectCode          ::Integer  AS ObjectCode
                                       , Object_Object.ValueData           ::TVarChar AS ObjectName
                                  FROM tmpMI_Master

                                       INNER JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                                             ON ObjectLink_ReceiptProdModel.ChildObjectId = tmpMI_Master.ReceiptProdModelId  --Object_ReceiptProdModelChild.Id
                                                            AND ObjectLink_ReceiptProdModel.DescId = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()
                                       LEFT JOIN Object AS Object_ReceiptProdModelChild
                                                        ON Object_ReceiptProdModelChild.Id = ObjectLink_ReceiptProdModel.ObjectId
                                                       AND Object_ReceiptProdModelChild.DescId = zc_Object_ReceiptProdModelChild()
                                                       AND Object_ReceiptProdModelChild.isErased = FALSE
                             
                                       LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                             ON ObjectFloat_Value.ObjectId = Object_ReceiptProdModelChild.Id
                                                            AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptProdModelChild_Value() 

                                       LEFT JOIN ObjectLink AS ObjectLink_Object
                                                            ON ObjectLink_Object.ObjectId = Object_ReceiptProdModelChild.Id
                                                           AND ObjectLink_Object.DescId = zc_ObjectLink_ReceiptProdModelChild_Object()
                                       LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_Object.ChildObjectId
                                       LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId
                                  )
          
   , tmpMI AS (SELECT MovementItem.ObjectId   AS GoodsId
                    , MovementItem.Amount
                    , MovementItem.Id
                    , MovementItem.ParentId
                    , MovementItem.isErased
               FROM tmpIsErased
                    JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                     AND MovementItem.DescId     = zc_MI_Child()
                                     AND MovementItem.isErased   = tmpIsErased.isErased
              )

     SELECT
         0 AS Id
       , tmpReceiptProdModelChild.ParentId
       , tmpReceiptProdModelChild.ObjectId       AS GoodsId
       , tmpReceiptProdModelChild.ObjectCode     AS GoodsCode
       , Object_Goods.ObjectName                 AS GoodsName
       , tmpReceiptProdModelChild.Value ::TFloat AS Amount
       , FALSE                                   AS isErased
     FROM tmpReceiptProdModelChild
          LEFT JOIN tmpMI ON tmpMI.Id = tmpReceiptProdModelChild.ParentId
     WHERE tmpMI.GoodsId IS NULL
  UNION ALL
     SELECT
         MovementItem.Id
       , MovementItem.ParentId
       , MovementItem.GoodsId      AS GoodsId
       , Object_Goods.ObjectCode   AS GoodsCode
       , Object_Goods.ValueData    AS GoodsName
       , MovementItem.Amount           ::TFloat
       , MovementItem.isErased

     FROM tmpMI AS MovementItem
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsId;
   ELSE 
   RETURN QUERY
    WITH
     tmpIsErased AS (SELECT FALSE AS isErased
                                UNION ALL
                               SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                              )
         
   , tmpMI AS (SELECT MovementItem.ObjectId   AS GoodsId
                    , MovementItem.Amount
                    , MovementItem.Id
                    , MovementItem.ParentId
                    , MovementItem.isErased
               FROM tmpIsErased
                    JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                     AND MovementItem.DescId     = zc_MI_Child()
                                     AND MovementItem.isErased   = tmpIsErased.isErased
              )


     SELECT
         MovementItem.Id
       , MovementItem.ParentId
       , MovementItem.GoodsId      AS GoodsId
       , Object_Goods.ObjectCode   AS GoodsCode
       , Object_Goods.ValueData    AS GoodsName
       , MovementItem.Amount           ::TFloat
       , MovementItem.isErased

     FROM tmpMI AS MovementItem
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsId
            ;
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.07.21         *
*/

-- тест
-- SELECT * from gpSelect_MI_ProductionUnion_Child (inMovementId:= 224, inIsErased:= true, inSession:= zfCalc_UserAdmin());
