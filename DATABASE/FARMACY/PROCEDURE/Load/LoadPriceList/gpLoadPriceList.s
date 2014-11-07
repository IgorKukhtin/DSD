UPDATE OBJECT SET valuedata = LoadPriceListItem.GoodsName 

FROM Object_Goods_View, LoadPriceListItem

WHERE Object.Id = Object_Goods_View.Id


AND CommonCode = GoodsCodeInt

AND ObjectId = zc_Enum_GlobalConst_Marion();

SELECT count(lpInsertUpdate_ObjectString(zc_ObjectString_Goods_Maker(), OBJECT.Id, LoadPriceListItem.ProducerName ) )

FROM OBJECT, Object_Goods_View, LoadPriceListItem

WHERE Object.Id = Object_Goods_View.Id


AND CommonCode = GoodsCodeInt

AND ObjectId = zc_Enum_GlobalConst_Marion() AND LoadPriceListItem.ProducerName <>'';
