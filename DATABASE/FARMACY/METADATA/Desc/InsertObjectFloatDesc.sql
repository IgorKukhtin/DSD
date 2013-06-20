INSERT INTO ObjectFloatDesc (id, DescId, Code ,itemname)
SELECT zc_ObjectFloat_Goods_NDS(), zc_Object_Goods(), 'Goods_NDS','НДС товара' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Id = zc_ObjectFloat_Goods_NDS());

INSERT INTO ObjectFloatDesc (id, DescId, Code ,itemname)
SELECT zc_ObjectFloat_Goods_PartyCount(), zc_Object_Goods(), 'Goods_PartyCount','Партия минимальная' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Id = zc_ObjectFloat_Goods_PartyCount());

INSERT INTO ObjectFloatDesc (id, DescId, Code ,itemname)
SELECT zc_ObjectFloat_Goods_Price(), zc_Object_Goods(), 'Goods_Price','Цена' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Id = zc_ObjectFloat_Goods_Price());

INSERT INTO ObjectFloatDesc (id, DescId, Code ,itemname)
SELECT zc_ObjectFloat_Goods_PercentReprice(), zc_Object_Goods(), 'Goods_PercentReprice','Наценка' WHERE NOT EXISTS (SELECT * FROM ObjectFloatDesc WHERE Id = zc_ObjectFloat_Goods_PercentReprice());
