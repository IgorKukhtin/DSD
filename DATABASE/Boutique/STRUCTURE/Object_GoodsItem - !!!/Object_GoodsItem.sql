/*
  Создание 
    - таблицы Object_GoodsItem (oбъекты)
    - связей
    - индексов
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE Object_GoodsItem(
   Id                     SERIAL NOT NULL PRIMARY KEY, 
   GoodsId                Integer NOT NULL,
   GoodsSizeId            Integer NOT NULL,
   IsErased               Boolean NOT NULL DEFAULT FALSE,
   isArc                  Boolean NOT NULL DEFAULT FALSE

   /* Связь с таблицей <ObjectDesc> - класс объекта */
 
   );
/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */
CREATE INDEX idx_Object_GoodsItem_GoodsId ON Object_GoodsItem(GoodsId);
CREATE INDEX idx_Object_GoodsItem_GoodsSizeId ON Object_GoodsItem(GoodsSizeId);
CREATE UNIQUE INDEX idx_Object_GoodsItem_GoodsId_GoodsSizeId ON Object_GoodsItem (GoodsId, GoodsSizeId); 

/*-------------------------------------------------------------------------------*/
/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
 


*/




