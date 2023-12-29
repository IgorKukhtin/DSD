-- Function: gpGet_MI_Send_PartionCell_edit()

DROP FUNCTION IF EXISTS gpGet_MI_Send_PartionCell_edit (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Send_PartionCell_edit(
    IN inMovementId        Integer,       -- ключ Документа
    IN inMovementItemId    Integer,       -- 
    IN inSession           TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             
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
               )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ProductionUnion());
     vbUserId:= lpGetUserBySession (inSession);


     RETURN QUERY
     SELECT  MovementItem.Id                      AS Id
           , Object_Goods.Id                      AS GoodsId
           , Object_Goods.ValueData               AS GoodsName
           , Object_GoodsKind.Id                  AS GoodsKindId
           , Object_GoodsKind.ValueData           AS GoodsKindName
           
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
     FROM MovementItem
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

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
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.Id = inMovementItemId
       AND MovementItem.DescId = zc_MI_Master();


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.12.23         *
*/

-- тест
-- SELECT * FROM gpGet_MI_Send_PartionCell_edit (inMovementId := 0, inOperDate := '01.01.2014', inSession:= '2')
