-- Function: gpSelect_MI_ProductionUnion_Child()

DROP FUNCTION IF EXISTS gpSelect_MI_ProductionUnion_Child (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_ProductionUnion_Child(
    IN inMovementId       Integer      , -- ключ Документа
    IN inShowAll          Boolean      , --
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId Integer
             , ObjectId Integer, ObjectCode Integer, ObjectName TVarChar
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
                           , MovementItem.ObjectId
                           , MILO_ReceiptProdModel.ObjectId AS ReceiptProdModelId
                      FROM tmpIsErased
                           JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = tmpIsErased.isErased
                           LEFT JOIN MovementItemLinkObject AS MILO_ReceiptProdModel
                                                            ON MILO_ReceiptProdModel.MovementItemId = MovementItem.Id
                                                           AND MILO_ReceiptProdModel.DescId = zc_MILinkObject_ReceiptProdModel()
                     )

   , tmpReceiptProdModelChild AS (SELECT tmpMI_Master.Id AS ParentId
                                       , ObjectFloat_Value.ValueData       ::TFloat   AS Value
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

                                       INNER JOIN ObjectLink AS ObjectLink_Object
                                                            ON ObjectLink_Object.ObjectId = Object_ReceiptProdModelChild.Id
                                                           AND ObjectLink_Object.DescId = zc_ObjectLink_ReceiptProdModelChild_Object()
                                       INNER JOIN Object AS Object_Object
                                                        ON Object_Object.Id = ObjectLink_Object.ChildObjectId
                                                       AND Object_Object.DescId = zc_Object_Goods()
                                       LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId
                                  WHERE COALESCE (tmpMI_Master.ReceiptProdModelId,0) <> 0
                                  )

   , tmpReceiptGoodsChild AS (SELECT tmpMI_Master.Id AS ParentId
                                   , ObjectFloat_Value.ValueData       ::TFloat   AS Value
                                   , ObjectDesc.ItemName               ::TVarChar AS DescName
                                   , Object_Object.Id                  ::Integer  AS ObjectId
                                   , Object_Object.ObjectCode          ::Integer  AS ObjectCode
                                   , Object_Object.ValueData           ::TVarChar AS ObjectName
                              FROM tmpMI_Master
                                   LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                                        ON ObjectLink_ReceiptGoods.ChildObjectId = tmpMI_Master.ObjectId
                                                       AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()

                                   LEFT JOIN Object AS Object_ReceiptGoodsChild ON Object_ReceiptGoodsChild.Id = ObjectLink_ReceiptGoods.ObjectId 

                                   LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                         ON ObjectFloat_Value.ObjectId = Object_ReceiptGoodsChild.Id
                                                        AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptGoodsChild_Value()  

                                   LEFT JOIN ObjectLink AS ObjectLink_Object
                                                        ON ObjectLink_Object.ObjectId = Object_ReceiptGoodsChild.Id
                                                       AND ObjectLink_Object.DescId = zc_ObjectLink_ReceiptGoodsChild_Object()
      
                                   INNER JOIN Object AS Object_Object
                                                    ON Object_Object.Id = ObjectLink_Object.ChildObjectId
                                                   AND Object_Object.DescId = zc_Object_Goods()
                                   LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId
                              WHERE COALESCE (tmpMI_Master.ReceiptProdModelId,0) = 0
                              )

   , tmpMI AS (SELECT MovementItem.ObjectId   AS ObjectId
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
       , tmpReceiptProdModelChild.ObjectId       AS ObjectId
       , tmpReceiptProdModelChild.ObjectCode     AS ObjectCode
       , tmpReceiptProdModelChild.ObjectName     AS ObjectName
       , tmpReceiptProdModelChild.Value ::TFloat AS Amount
       , FALSE                                   AS isErased
     FROM tmpReceiptProdModelChild
          LEFT JOIN tmpMI ON tmpMI.Id = tmpReceiptProdModelChild.ParentId
     WHERE tmpMI.ObjectId IS NULL
  UNION ALL
     SELECT
         0 AS Id
       , tmpReceiptGoodsChild.ParentId
       , tmpReceiptGoodsChild.ObjectId       AS ObjectId
       , tmpReceiptGoodsChild.ObjectCode     AS ObjectCode
       , tmpReceiptGoodsChild.ObjectName     AS ObjectName
       , tmpReceiptGoodsChild.Value ::TFloat AS Amount
       , FALSE                               AS isErased
     FROM tmpReceiptGoodsChild
          LEFT JOIN tmpMI ON tmpMI.Id = tmpReceiptGoodsChild.ParentId
     WHERE tmpMI.ObjectId IS NULL
  UNION ALL
     SELECT
         MovementItem.Id
       , MovementItem.ParentId
       , MovementItem.ObjectId      AS ObjectId
       , Object_Object.ObjectCode   AS ObjectCode
       , Object_Object.ValueData    AS ObjectName
       , MovementItem.Amount           ::TFloat
       , MovementItem.isErased

     FROM tmpMI AS MovementItem
          LEFT JOIN Object AS Object_Object ON Object_Object.Id = MovementItem.ObjectId;
   ELSE 
   RETURN QUERY
    WITH
     tmpIsErased AS (SELECT FALSE AS isErased
                                UNION ALL
                               SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                              )
         
   , tmpMI AS (SELECT MovementItem.ObjectId   AS ObjectId
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
       , MovementItem.ObjectId      AS ObjectId
       , Object_Object.ObjectCode   AS ObjectCode
       , Object_Object.ValueData    AS ObjectName
       , MovementItem.Amount           ::TFloat
       , MovementItem.isErased

     FROM tmpMI AS MovementItem
          LEFT JOIN Object AS Object_Object ON Object_Object.Id = MovementItem.ObjectId
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
