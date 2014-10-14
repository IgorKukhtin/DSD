update GoodsProperty SET GoodsName = Code||' '||GoodsName
FROM GoodsProperty WHERE GoodsName in 


(SELECT GoodsName FROM "DBA"."GoodsProperty"
group by GoodsName
having count(*)>1);