SELECT MovementItem.ObjectId
                 , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
, Object_Goods.ObjectCode
, Object_Goods.ValueData
, Object_GoodsKind.ValueData
                 FROM MovementItem
                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                      
                      LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
                      LEFT JOIN Object AS Object_GoodsKind on Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId
                 WHERE MovementItem.MovementId = 11243524 
                   AND MovementItem.Amount <> 0
                   AND MovementItem.DescId = 1
                   AND MovementItem.isErased = false
                 group by MovementItem.ObjectId
               ,    COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
, Object_Goods.ObjectCode
, Object_Goods.ValueData
, Object_GoodsKind.ValueData
                   
having count (*) > 1