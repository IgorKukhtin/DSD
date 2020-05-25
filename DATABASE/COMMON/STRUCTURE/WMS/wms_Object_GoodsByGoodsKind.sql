/*
  Создание 
    - таблицы wms_Object_GoodsByGoodsKind (oбъекты)
    - связей
    - индексов
*/
-- DROP TABLE wms_Object_GoodsByGoodsKind

/*-------------------------------------------------------------------------------*/

CREATE TABLE wms_Object_GoodsByGoodsKind(
   ObjectId            Integer  NOT NULL PRIMARY KEY, 
   GoodsId             Integer ,
   GoodsKindId	       Integer ,
   MeasureId           Integer ,
   GoodsTypeKindId_Sh  Integer ,
   GoodsTypeKindId_Nom Integer ,
   GoodsTypeKindId_Ves Integer ,

   GoodsId_link_sh     Integer , -- ***Товар (из категории "Штучный")
   GoodsKindId_link_sh Integer , -- ***Вид товара (из категории "Штучный")

   WeightAvg_Sh        TFloat  , -- ***средний вес 1ед. для категории шт.
   WeightAvg_Nom       TFloat  , -- ***средний вес 1ед. для категории номинал
   WeightAvg_Ves       TFloat  , -- ***средний вес 1ед. для категории неноминал
   Tax_Sh              TFloat  , -- ***% отклонения веса 1ед. для категории шт.
   Tax_Nom             TFloat  , -- ***% отклонения веса 1ед. для категории номинал
   Tax_Ves             TFloat  , -- ***% отклонения веса 1ед. для категории неноминал

   WeightMin_Sh        TFloat  , -- ***calc = мин вес 1ед. для категории шт.
   WeightMax_Sh        TFloat  , -- ***calc = макс вес 1ед. для категории шт.
   WeightMin_Nom       TFloat  , -- ***calc = мин вес 1ед. для категории номинал
   WeightMax_Nom       TFloat  , -- ***calc = макс вес 1ед. для категории номинал
   WeightMin_Ves       TFloat  , -- ***calc = мин вес 1ед. для категории неноминал
   WeightMax_Ves       TFloat  , -- ***calc = макс вес 1ед. для категории неноминал

   WeightOnBox_Sh      TFloat  , -- ***calc = Вес нетто в ящ. (E2/E3) для категории шт.
   WeightOnBox_Nom     TFloat  , -- ***calc = Вес нетто в ящ. (E2/E3) для категории 
   WeightOnBox_Ves     TFloat  , -- ***calc = Вес нетто в ящ. (E2/E3) для категории 

   WeightMin           TFloat  , -- calc = мин. средниний вес 1ед. по всем категориям
   WeightMax           TFloat  , -- calc = макс. средниний вес 1ед. по всем категориям
   
   NormInDays          TFloat  , -- Cрок годности, дн.

   Height              TFloat  , -- Высота
   Length              TFloat  , -- Длина
   Width               TFloat  , -- Ширина

   WmsCode             Integer , -- Код ВМС - для sku_code

   GoodsPropertyBoxId  Integer , -- ключ для  BoxId + GoodsId + GoodsKindId
   BoxId               Integer , -- 
   BoxWeight           TFloat  , -- Вес самого ящ. (E2/E3)

   WeightOnBox         TFloat  , -- !!!calc = Вес нетто в ящ (E2/E3) - по всем категориям
   CountOnBox          TFloat  , -- Кол-во ед. в ящ. (E2/E3) - !!!самый приоритетный!!!

   WmsCellNum          Integer , -- № Ячейки на складе ВМС

   sku_id_Sh           TVarChar, -- sku_id ВМС - шт.
   sku_id_Nom          TVarChar, -- sku_id ВМС - номинал
   sku_id_Ves          TVarChar, -- sku_id ВМС - неноминал

   sku_code_Sh         TVarChar, -- sku_code - шт.
   sku_code_Nom        TVarChar, -- sku_code - номинал
   sku_code_Ves        TVarChar, -- sku_code - неноминал

   isErased            Boolean  
  );
/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */
CREATE UNIQUE INDEX idx_wms_Object_GoodsByGoodsKind_ObjectId            ON wms_Object_GoodsByGoodsKind (ObjectId);
CREATE UNIQUE INDEX idx_wms_Object_GoodsByGoodsKind_GoodsId_GoodsKindId ON wms_Object_GoodsByGoodsKind (GoodsId, GoodsKindId);

/*-------------------------------------------------------------------------------*/
/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.08.19                                       *
 23.05.19         *
*/
