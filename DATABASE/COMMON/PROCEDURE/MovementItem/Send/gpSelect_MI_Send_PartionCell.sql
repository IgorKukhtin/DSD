 -- Function: gpSelect_MI_Send_PartionCell()

DROP FUNCTION IF EXISTS gpSelect_MI_Send_PartionCell (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_Send_PartionCell(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar 
             , GoodsKindId Integer, GoodsKindName  TVarChar
             , PartionGoodsDate TDateTime
             , Amount TFloat
             , PartionCell_Amount_1  TFloat
             , PartionCell_Amount_2  TFloat
             , PartionCell_Amount_3  TFloat
             , PartionCell_Amount_4  TFloat
             , PartionCell_Amount_5  TFloat 
             , PartionCell_Last      TFloat
            
             , isPartionCell_Close_1 Boolean
             , isPartionCell_Close_2 Boolean
             , isPartionCell_Close_3 Boolean
             , isPartionCell_Close_4 Boolean
             , isPartionCell_Close_5 Boolean
              
             , PartionCellId_1     Integer
             , PartionCellCode_1   Integer
             , PartionCellName_1   TVarChar
  
             , PartionCellId_2     Integer 
             , PartionCellCode_2   Integer 
             , PartionCellName_2   TVarChar
  
             , PartionCellId_3     Integer 
             , PartionCellCode_3   Integer 
             , PartionCellName_3   TVarChar
  
             , PartionCellId_4     Integer 
             , PartionCellCode_4   Integer 
             , PartionCellName_4   TVarChar
  
             , PartionCellId_5     Integer 
             , PartionCellCode_5   Integer 
             , PartionCellName_5   TVarChar
             , isPeresort Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbUnitId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Send());
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат такой
     RETURN QUERY
       SELECT
             MovementItem.Id                      AS Id
           , Object_Goods.Id                      AS GoodsId
           , Object_Goods.ObjectCode              AS GoodsCode
           , Object_Goods.ValueData               AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName
           , Object_GoodsKind.Id                   AS GoodsKindId
           , Object_GoodsKind.ValueData            AS GoodsKindName
           , MIDate_PartionGoods.ValueData   :: TDateTime AS PartionGoodsDate
           , MovementItem.Amount                   AS Amount
           
           , MIFloat_PartionCell_Amount_1.ValueData  ::TFloat AS PartionCell_Amount_1
           , MIFloat_PartionCell_Amount_2.ValueData  ::TFloat AS PartionCell_Amount_2
           , MIFloat_PartionCell_Amount_3.ValueData  ::TFloat AS PartionCell_Amount_3
           , MIFloat_PartionCell_Amount_4.ValueData  ::TFloat AS PartionCell_Amount_4
           , MIFloat_PartionCell_Amount_5.ValueData  ::TFloat AS PartionCell_Amount_5
           
           , MIFloat_PartionCell_Last.ValueData  ::TFloat AS PartionCell_Last
          
           , COALESCE (MIBoolean_PartionCell_Close_1.ValueData, FALSE) ::Boolean AS isPartionCell_Close_1
           , COALESCE (MIBoolean_PartionCell_Close_2.ValueData, FALSE) ::Boolean AS isPartionCell_Close_2
           , COALESCE (MIBoolean_PartionCell_Close_3.ValueData, FALSE) ::Boolean AS isPartionCell_Close_3
           , COALESCE (MIBoolean_PartionCell_Close_4.ValueData, FALSE) ::Boolean AS isPartionCell_Close_4
           , COALESCE (MIBoolean_PartionCell_Close_5.ValueData, FALSE) ::Boolean AS isPartionCell_Close_5
            
           , Object_PartionCell_1.Id            AS PartionCellId_1
           , Object_PartionCell_1.ObjectCode    AS PartionCellCode_1
           , Object_PartionCell_1.ValueData     AS PartionCellName_1

           , Object_PartionCell_2.Id            AS PartionCellId_2
           , Object_PartionCell_2.ObjectCode    AS PartionCellCode_2
           , Object_PartionCell_2.ValueData     AS PartionCellName_2

           , Object_PartionCell_3.Id            AS PartionCellId_3
           , Object_PartionCell_3.ObjectCode    AS PartionCellCode_3
           , Object_PartionCell_3.ValueData     AS PartionCellName_3

           , Object_PartionCell_4.Id            AS PartionCellId_4
           , Object_PartionCell_4.ObjectCode    AS PartionCellCode_4
           , Object_PartionCell_4.ValueData     AS PartionCellName_4

           , Object_PartionCell_5.Id            AS PartionCellId_5
           , Object_PartionCell_5.ObjectCode    AS PartionCellCode_5
           , Object_PartionCell_5.ValueData     AS PartionCellName_5


           , MovementItem.isErased                 AS isErased
           
       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                       ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                      AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_1
                                             ON MILinkObject_PartionCell_1.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_1.DescId = zc_MILinkObject_PartionCell_1()
            LEFT JOIN Object AS Object_PartionCell_1 ON Object_PartionCell_1.Id = MILinkObject_PartionCell_1.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_2
                                             ON MILinkObject_PartionCell_2.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_2.DescId = zc_MILinkObject_PartionCell_2()
            LEFT JOIN Object AS Object_PartionCell_2 ON Object_PartionCell_2.Id = MILinkObject_PartionCell_2.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_3
                                             ON MILinkObject_PartionCell_3.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_3.DescId = zc_MILinkObject_PartionCell_3()
            LEFT JOIN Object AS Object_PartionCell_3 ON Object_PartionCell_3.Id = MILinkObject_PartionCell_3.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_4
                                             ON MILinkObject_PartionCell_4.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_4.DescId = zc_MILinkObject_PartionCell_4()
            LEFT JOIN Object AS Object_PartionCell_4 ON Object_PartionCell_4.Id = MILinkObject_PartionCell_4.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_5
                                             ON MILinkObject_PartionCell_5.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_5.DescId = zc_MILinkObject_PartionCell_5()
            LEFT JOIN Object AS Object_PartionCell_5 ON Object_PartionCell_5.Id = MILinkObject_PartionCell_5.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_PartionCell_Amount_1
                                        ON MIFloat_PartionCell_Amount_1.MovementItemId = MovementItem.Id
                                       AND MIFloat_PartionCell_Amount_1.DescId         = zc_MIFloat_PartionCell_Amount_1()
            LEFT JOIN MovementItemFloat AS MIFloat_PartionCell_Amount_2
                                        ON MIFloat_PartionCell_Amount_2.MovementItemId = MovementItem.Id
                                       AND MIFloat_PartionCell_Amount_2.DescId         = zc_MIFloat_PartionCell_Amount_2()
            LEFT JOIN MovementItemFloat AS MIFloat_PartionCell_Amount_3
                                        ON MIFloat_PartionCell_Amount_3.MovementItemId = MovementItem.Id
                                       AND MIFloat_PartionCell_Amount_3.DescId         = zc_MIFloat_PartionCell_Amount_3()
            LEFT JOIN MovementItemFloat AS MIFloat_PartionCell_Amount_4
                                        ON MIFloat_PartionCell_Amount_4.MovementItemId = MovementItem.Id
                                       AND MIFloat_PartionCell_Amount_4.DescId         = zc_MIFloat_PartionCell_Amount_4()
            LEFT JOIN MovementItemFloat AS MIFloat_PartionCell_Amount_5
                                        ON MIFloat_PartionCell_Amount_5.MovementItemId = MovementItem.Id
                                       AND MIFloat_PartionCell_Amount_5.DescId         = zc_MIFloat_PartionCell_Amount_5()

            LEFT JOIN MovementItemFloat AS MIFloat_PartionCell_Last
                                        ON MIFloat_PartionCell_Last.MovementItemId = MovementItem.Id
                                       AND MIFloat_PartionCell_Last.DescId         = zc_MIFloat_PartionCell_Last()
                                                  
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Close_1
                                          ON MIBoolean_PartionCell_Close_1.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Close_1.DescId = zc_MIBoolean_PartionCell_Close_1()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Close_2
                                          ON MIBoolean_PartionCell_Close_2.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Close_2.DescId = zc_MIBoolean_PartionCell_Close_2()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Close_3
                                          ON MIBoolean_PartionCell_Close_3.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Close_3.DescId = zc_MIBoolean_PartionCell_Close_3()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Close_4
                                          ON MIBoolean_PartionCell_Close_4.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Close_4.DescId = zc_MIBoolean_PartionCell_Close_4()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Close_5
                                          ON MIBoolean_PartionCell_Close_5.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Close_5.DescId = zc_MIBoolean_PartionCell_Close_5()

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.12.23         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_Send_PartionCell (inMovementId:= 25173, inIsErased:= FALSE, inSession:= '9818')