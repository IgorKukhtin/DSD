-- Function: gpSelect_MI_OrderGoodsDetail_Child()

DROP FUNCTION IF EXISTS gpSelect_MI_OrderGoodsDetail_Child (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MI_OrderGoodsDetail_Child (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderGoodsDetail_Child(
    IN inParentId    Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inisErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , ParentId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindName TVarChar
             , GoodsGroupNameFull TVarChar
             , MeasureName TVarChar
             , Amount TFloat

             , GoodsGroupNameFull_parent TVarChar
             , GoodsCode_parent Integer, GoodsName_parent TVarChar
             , GoodsKindName_parent TVarChar
             , MeasureName_parent TVarChar

             , ReceiptCode Integer, ReceiptCode_str TVarChar, ReceiptName TVarChar
             , ReceiptBasisCode Integer, ReceiptBasisCode_str TVarChar, ReceiptBasisName TVarChar

             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId       Integer;
  DECLARE vbMovementId   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderGoodsDetail());
     vbUserId:= lpGetUserBySession (inSession);


     -- Нашли документ
     vbMovementId := (SELECT Movement.Id FROM Movement WHERE Movement.ParentId = inParentId AND Movement.DescId = zc_Movement_OrderGoodsDetail());

     -- Результат
     RETURN QUERY
     SELECT CASE WHEN inShowAll = TRUE THEN MovementItem.Id ELSE 0 END AS Id
          , CASE WHEN inShowAll = TRUE THEN MovementItem.ParentId ELSE 0 END AS ParentId
          , Object_Goods.Id          		AS GoodsId
          , Object_Goods.ObjectCode  		AS GoodsCode
          , Object_Goods.ValueData   		AS GoodsName
          , Object_GoodsKind.ValueData          AS GoodsKindName
          , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
          , Object_Measure.ValueData            AS MeasureName
          , SUM (COALESCE (MovementItem.Amount,0)) :: TFloat AS Amount

          , CASE WHEN inShowAll = TRUE THEN ObjectString_Goods_GoodsGroupFull_parent.ValueData ELSE '' END ::TVarChar AS GoodsGroupNameFull_parent
          , CASE WHEN inShowAll = TRUE THEN Object_Goods_parent.ObjectCode  	         ELSE 0  END AS GoodsCode_parent
          , CASE WHEN inShowAll = TRUE THEN Object_Goods_parent.ValueData   	         ELSE '' END ::TVarChar AS GoodsName_parent
          , CASE WHEN inShowAll = TRUE THEN Object_GoodsKind_parent.ValueData            ELSE '' END ::TVarChar AS GoodsKindName_parent
          , CASE WHEN inShowAll = TRUE THEN Object_Measure_parent.ValueData              ELSE '' END ::TVarChar AS MeasureName_parent

          , CASE WHEN inShowAll = TRUE THEN Object_Receipt.ObjectCode                    ELSE 0  END AS ReceiptCode
          , CASE WHEN inShowAll = TRUE THEN ObjectString_Receipt_Code.ValueData          ELSE '' END ::TVarChar AS ReceiptCode_str
          , CASE WHEN inShowAll = TRUE THEN Object_Receipt.ValueData                     ELSE '' END ::TVarChar AS ReceiptName

          , CASE WHEN inShowAll = TRUE THEN Object_ReceiptBasis.ObjectCode               ELSE 0 END AS ReceiptBasisCode
          , CASE WHEN inShowAll = TRUE THEN ObjectString_ReceiptBasis_Code.ValueData     ELSE '' END ::TVarChar AS ReceiptBasisCode_str
          , CASE WHEN inShowAll = TRUE THEN Object_ReceiptBasis.ValueData                ELSE '' END ::TVarChar AS ReceiptBasisName

          , CASE WHEN inShowAll = TRUE THEN MovementItem.isErased ELSE FALSE END ::Boolean AS isErased

     FROM MovementItem
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

          LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                           ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                          AND MILO_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILO_GoodsKind.ObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                 ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId =  Object_Goods.Id
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN MovementItem AS MI_parent
                                 ON MI_parent.Id = MovementItem.ParentId
                                AND inShowAll = TRUE   -- показываем данные мастер по галке "показать детально"
          LEFT JOIN Object AS Object_Goods_parent ON Object_Goods_parent.Id = MI_parent.ObjectId

          LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind_parent
                                           ON MILO_GoodsKind_parent.MovementItemId = MI_parent.Id
                                          AND MILO_GoodsKind_parent.DescId         = zc_MILinkObject_GoodsKind()
          LEFT JOIN Object AS Object_GoodsKind_parent ON Object_GoodsKind_parent.Id = MILO_GoodsKind_parent.ObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull_parent
                                 ON ObjectString_Goods_GoodsGroupFull_parent.ObjectId = Object_Goods_parent.Id
                                AND ObjectString_Goods_GoodsGroupFull_parent.DescId   = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_parent
                               ON ObjectLink_Goods_Measure_parent.ObjectId =  Object_Goods_parent.Id
                              AND ObjectLink_Goods_Measure_parent.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure_parent ON Object_Measure_parent.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN MovementItemLinkObject AS MILO_Receipt
                                           ON MILO_Receipt.MovementItemId = MI_parent.Id
                                          AND MILO_Receipt.DescId = zc_MILinkObject_Receipt()
          LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = MILO_Receipt.ObjectId
          LEFT JOIN ObjectString AS ObjectString_Receipt_Code
                                 ON ObjectString_Receipt_Code.ObjectId = Object_Receipt.Id
                                AND ObjectString_Receipt_Code.DescId   = zc_ObjectString_Receipt_Code()

          LEFT JOIN MovementItemLinkObject AS MILO_ReceiptBasis
                                           ON MILO_ReceiptBasis.MovementItemId = MI_parent.Id
                                          AND MILO_ReceiptBasis.DescId = zc_MILinkObject_ReceiptBasis()
          LEFT JOIN Object AS Object_ReceiptBasis ON Object_ReceiptBasis.Id = MILO_ReceiptBasis.ObjectId
          LEFT JOIN ObjectString AS ObjectString_ReceiptBasis_Code
                                 ON ObjectString_ReceiptBasis_Code.ObjectId = Object_ReceiptBasis.Id
                                AND ObjectString_ReceiptBasis_Code.DescId   = zc_ObjectString_Receipt_Code()

     WHERE MovementItem.MovementId = vbMovementId
       AND MovementItem.DescId     = zc_MI_Child()
       AND (MovementItem.isErased  = FALSE OR inisErased = TRUE)
     GROUP BY CASE WHEN inShowAll = TRUE THEN MovementItem.Id ELSE 0 END 
            , CASE WHEN inShowAll = TRUE THEN MovementItem.ParentId ELSE 0 END
            , Object_Goods.Id
            , Object_Goods.ObjectCode
            , Object_Goods.ValueData
            , Object_GoodsKind.ValueData
            , ObjectString_Goods_GoodsGroupFull.ValueData
            , Object_Measure.ValueData  
            , CASE WHEN inShowAll = TRUE THEN ObjectString_Goods_GoodsGroupFull_parent.ValueData ELSE '' END
            , CASE WHEN inShowAll = TRUE THEN Object_Goods_parent.ObjectCode  	 ELSE 0  END
            , CASE WHEN inShowAll = TRUE THEN Object_Goods_parent.ValueData   	 ELSE '' END
            , CASE WHEN inShowAll = TRUE THEN Object_GoodsKind_parent.ValueData  ELSE '' END
            , CASE WHEN inShowAll = TRUE THEN Object_Measure_parent.ValueData    ELSE '' END
            , CASE WHEN inShowAll = TRUE THEN Object_Receipt.ObjectCode          ELSE 0  END
            , CASE WHEN inShowAll = TRUE THEN ObjectString_Receipt_Code.ValueData      ELSE '' END
            , CASE WHEN inShowAll = TRUE THEN Object_Receipt.ValueData                 ELSE '' END
            , CASE WHEN inShowAll = TRUE THEN Object_ReceiptBasis.ObjectCode           ELSE 0 END
            , CASE WHEN inShowAll = TRUE THEN ObjectString_ReceiptBasis_Code.ValueData ELSE '' END
            , CASE WHEN inShowAll = TRUE THEN Object_ReceiptBasis.ValueData            ELSE '' END
            , CASE WHEN inShowAll = TRUE THEN MovementItem.isErased ELSE FALSE END
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.10.21         *
 15.09.21         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_OrderGoodsDetail_Child (inParentId := 21114328, inisErased:= FALSE, inSession:= '5')
