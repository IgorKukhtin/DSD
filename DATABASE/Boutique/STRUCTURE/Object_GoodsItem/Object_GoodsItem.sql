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
   IsErased               Boolean NOT NULL DEFAULT false,
   isArc                  Boolean NOT NULL DEFAULT false

   /* Связь с таблицей <ObjectDesc> - класс объекта */
 
   );
/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */
CREATE INDEX idx_Object_GoodsItem_GoodsId ON Object_GoodsItem(GoodsId);
CREATE INDEX idx_Object_GoodsItem_GoodsSizeId ON Object_GoodsItem(GoodsSizeId);


CLUSTER object_pkey ON Object_GoodsItem; 

/*-------------------------------------------------------------------------------*/
/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
 


*/




