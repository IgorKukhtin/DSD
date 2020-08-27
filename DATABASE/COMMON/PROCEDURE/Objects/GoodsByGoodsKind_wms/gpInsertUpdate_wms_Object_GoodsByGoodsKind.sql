-- !!! Расчет sku_id !!!

-- Function: gpInsertUpdate_wms_Object_GoodsByGoodsKind (TVarChar)

DROP FUNCTION IF EXISTS  gpInsertUpdate_wms_Object_GoodsByGoodsKind (TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_wms_Object_GoodsByGoodsKind(
    IN inSession             TVarChar
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_wms_Object_GoodsByGoodsKind());

          -- 1.1. Обновляем существующие ObjectId
          UPDATE wms_Object_GoodsByGoodsKind
           SET GoodsId               = tmp.GoodsId
             , GoodsKindId           = tmp.GoodsKindId
             , MeasureId             = tmp.MeasureId
               --
             , GoodsTypeKindId_Sh    = tmp.GoodsTypeKindId_Sh
             , GoodsTypeKindId_Nom   = tmp.GoodsTypeKindId_Nom
             , GoodsTypeKindId_Ves   = tmp.GoodsTypeKindId_Ves
               -- замена кода - на категорию "Штучный"
             , GoodsId_link_sh       = tmp.GoodsId_Sh
             , GoodsKindId_link_sh   = tmp.GoodsKindId_Sh
               -- средний вес 1ед.
             , WeightAvg_Sh          = tmp.WeightAvg_Sh
             , WeightAvg_Nom         = tmp.WeightAvg_Nom
             , WeightAvg_Ves         = tmp.WeightAvg_Ves
               -- % отклонения веса 1ед.
             , Tax_Sh                = tmp.Tax_Sh
             , Tax_Nom               = tmp.Tax_Nom
             , Tax_Ves               = tmp.Tax_Ves
               -- мин/макс вес 1ед.
             , WeightMin_Sh          = tmp.WeightMin_Sh
             , WeightMax_Sh          = tmp.WeightMax_Sh
             , WeightMin_Nom         = tmp.WeightMin_Nom
             , WeightMax_Nom         = tmp.WeightMax_Nom
             , WeightMin_Ves         = tmp.WeightMin_Ves
             , WeightMax_Ves         = tmp.WeightMax_Ves
               -- Вес нетто в ящ. (E2/E3)
             , WeightOnBox_Sh        = tmp.WeightOnBox_Sh
             , WeightOnBox_Nom       = tmp.WeightOnBox_Nom
             , WeightOnBox_Ves       = tmp.WeightOnBox_Ves

               -- calc = средниний вес 1ед. по всем категориям
             , WeightMin             = tmp.WeightMin
             , WeightMax             = tmp.WeightMax

               -- Cрок годности, дн.
             , NormInDays            = tmp.NormInDays
               -- Высота + Длина + Ширина
             , Height                = tmp.Height
             , Length                = tmp.Length
             , Width                 = tmp.Width
               -- Код ВМС - для sku_code
             , WmsCode               = tmp.WmsCode
               --
             , GoodsPropertyBoxId    = tmp.GoodsPropertyBoxId
             , BoxId                 = tmp.BoxId
             , BoxWeight             = tmp.BoxWeight

               -- !!!Вес нетто в ящ (E2/E3) - по всем категориям
             , WeightOnBox           = tmp.WeightOnBox
               -- Кол-во ед. в ящ. (E2/E3) - !!!самый приоритетный!!!
             , CountOnBox            = tmp.CountOnBox

               -- № Ячейки на складе ВМС
             , WmsCellNum            = tmp.WmsCellNum

               -- sku_id ВМС - шт. + номинал + неноминал
             , sku_id_Sh             = tmp.sku_id_Sh
             , sku_id_Nom            = tmp.sku_id_Nom
             , sku_id_Ves            = tmp.sku_id_Ves
               -- sku_code ВМС - шт. + номинал + неноминал
             , sku_code_Sh           = tmp.sku_code_Sh
             , sku_code_Nom          = tmp.sku_code_Nom
             , sku_code_Ves          = tmp.sku_code_Ves
               --
             , isErased              = tmp.isErased

          FROM (-- 1.1.
                WITH _tmpGoodsByGoodsKind AS
                        (SELECT tmp.Id AS ObjectId -- это GoodsByGoodsKind.Id
                                --
                              , tmp.GoodsId
                              , tmp.GoodsKindId
                              , tmp.MeasureId
                                -- GoodsTypeKindId
                              , CASE WHEN COALESCE (tmp.isGoodsTypeKind_Sh,   FALSE) <> FALSE THEN zc_Enum_GoodsTypeKind_Sh()  ELSE NULL END AS GoodsTypeKindId_Sh
                              , CASE WHEN COALESCE (tmp.isGoodsTypeKind_Nom,  FALSE) <> FALSE THEN zc_Enum_GoodsTypeKind_Nom() ELSE NULL END AS GoodsTypeKindId_Nom
                              , CASE WHEN COALESCE (tmp.isGoodsTypeKind_Ves,  FALSE) <> FALSE THEN zc_Enum_GoodsTypeKind_Ves() ELSE NULL END AS GoodsTypeKindId_Ves
                                -- замена кода - на категорию "Штучный"
                              , tmp.GoodsId_Sh
                              , tmp.GoodsKindId_Sh
                                -- средний вес 1ед.
                              , tmp.WeightAvg_Sh
                              , tmp.WeightAvg_Nom
                              , tmp.WeightAvg_Ves
                                -- % отклонения веса 1ед.
                              , tmp.Tax_Sh
                              , tmp.Tax_Nom
                              , tmp.Tax_Ves
                                -- мин/макс вес 1ед.
                              , tmp.WeightMin_Sh
                              , tmp.WeightMax_Sh
                              , tmp.WeightMin_Nom
                              , tmp.WeightMax_Nom
                              , tmp.WeightMin_Ves
                              , tmp.WeightMax_Ves
                                -- Вес нетто в ящ. (E2/E3)
                              , tmp.WeightOnBox_Sh
                              , tmp.WeightOnBox_Nom
                              , tmp.WeightOnBox_Ves
                 
                                -- calc = средниний вес 1ед. по всем категориям
                            --, tmp.WeightMin
                            --, tmp.WeightMax
                                --
                              , tmp.NormInDays
         
                              , tmp.Height
                              , tmp.Length
                              , tmp.Width
         
                                -- Код ВМС - для sku_code
                              , tmp.WmsCode
         
                                --
                              , CASE WHEN tmp.BoxId IN (zc_Box_E2(), zc_Box_E3()) THEN tmp.GoodsPropertyBoxId  ELSE tmp.GoodsPropertyBoxId_2 END :: Integer AS GoodsPropertyBoxId
                              , CASE WHEN tmp.BoxId IN (zc_Box_E2(), zc_Box_E3()) THEN tmp.BoxId       ELSE tmp.BoxId_2     END :: Integer AS BoxId
                              , CASE WHEN tmp.BoxId IN (zc_Box_E2(), zc_Box_E3()) THEN tmp.BoxWeight   ELSE tmp.BoxWeight_2 END :: TFloat  AS BoxWeight
         
                                -- !!!***Вес нетто в ящ (E2/E3) - по всем категориям
                            --, CASE WHEN tmp.BoxId IN (zc_Box_E2(), zc_Box_E3()) THEN tmp.WeightOnBox ELSE NULL END :: TFloat  AS WeightOnBox
                                -- Кол-во ед. в ящ. (E2/E3) - !!!самый приоритетный!!!
                              , CASE WHEN tmp.BoxId IN (zc_Box_E2(), zc_Box_E3()) AND tmp.CountOnBox > 0 THEN tmp.CountOnBox  ELSE tmp.CountOnBox_2 END :: TFloat  AS CountOnBox
         
                                -- № Ячейки на складе ВМС
                              , tmp.WmsCellNum
         
                               -- !!! sku_id = GoodsByGoodsKindId + ... !!!
                              , tmp.Id * 10 + 1 AS sku_id_Sh
                              , tmp.Id * 10 + 2 AS sku_id_Nom
                              , tmp.Id * 10 + 3 AS sku_id_Ves
                                -- sku_code
                              , tmp.WmsCodeCalc_Sh AS sku_code_Sh, tmp.WmsCodeCalc_Nom AS sku_code_Nom, tmp.WmsCodeCalc_Ves AS sku_code_Ves
         
                                --
                              , Object_GoodsByGoodsKind.isErased
         
                         FROM gpSelect_Object_GoodsByGoodsKind_VMC (0, 0 , 0, 0, 0, 0, inSession) AS tmp
                              LEFT JOIN Object AS Object_GoodsByGoodsKind ON Object_GoodsByGoodsKind.Id = tmp.Id
                         WHERE tmp.GoodsId > 0 AND tmp.GoodsKindId > 0
                        )
                -- 1.2.Результат
                SELECT -- GoodsByGoodsKindId
                       tmp.ObjectId
                     , tmp.GoodsId
                     , tmp.GoodsKindId
                     , tmp.MeasureId
                     , tmp.GoodsTypeKindId_Sh
                     , tmp.GoodsTypeKindId_Nom
                     , tmp.GoodsTypeKindId_Ves
          
                       -- замена кода - на категорию "Штучный"
                     , tmp.GoodsId_Sh
                     , tmp.GoodsKindId_Sh
          
                       -- средний вес 1ед.
                     , tmp.WeightAvg_Sh
                     , tmp.WeightAvg_Nom
                     , tmp.WeightAvg_Ves
          
                       -- % отклонения веса 1ед.
                     , tmp.Tax_Sh
                     , tmp.Tax_Nom
                     , tmp.Tax_Ves
                       -- мин/макс вес 1ед.
                     , tmp.WeightMin_Sh
                     , tmp.WeightMax_Sh
                     , tmp.WeightMin_Nom
                     , tmp.WeightMax_Nom
                     , tmp.WeightMin_Ves
                     , tmp.WeightMax_Ves
                       -- Вес нетто в ящ. (E2/E3)
                     , tmp.WeightOnBox_Sh
                     , tmp.WeightOnBox_Nom
                     , tmp.WeightOnBox_Ves
          
                       -- calc = средниний вес 1ед. по всем категориям
                     , (tmp.WeightMin_Sh + tmp.WeightMin_Nom + tmp.WeightMin_Ves)
                     / CASE WHEN tmp.WeightMin_Sh = 0 AND tmp.WeightMin_Nom = 0 AND tmp.WeightMin_Ves = 0
                                 THEN 1
                            ELSE CASE WHEN tmp.WeightMin_Sh  > 0  THEN 1 ELSE 0 END
                               + CASE WHEN tmp.WeightMin_Nom > 0  THEN 1 ELSE 0 END
                               + CASE WHEN tmp.WeightMin_Ves > 0  THEN 1 ELSE 0 END
                       END AS WeightMin
                     , (tmp.WeightMax_Sh + tmp.WeightMax_Nom + tmp.WeightMax_Ves)
                     / CASE WHEN tmp.WeightMax_Sh = 0 AND tmp.WeightMax_Nom = 0 AND tmp.WeightMax_Ves = 0
                                 THEN 1
                            ELSE CASE WHEN tmp.WeightMax_Sh  > 0  THEN 1 ELSE 0 END
                               + CASE WHEN tmp.WeightMax_Nom > 0  THEN 1 ELSE 0 END
                               + CASE WHEN tmp.WeightMax_Ves > 0  THEN 1 ELSE 0 END
                       END AS WeightMax
          
                       -- Cрок годности, дн.
                     , tmp.NormInDays
                       -- Высота + Длина + Ширина
                     , tmp.Height
                     , tmp.Length
                     , tmp.Width
                       -- Код ВМС - для sku_code
                     , tmp.WmsCode
                       --
                     , tmp.GoodsPropertyBoxId
                     , tmp.BoxId
                     , tmp.BoxWeight
          
                       -- !!!***calc = Вес нетто в ящ (E2/E3) - по всем категориям
                     , (tmp.WeightOnBox_Sh + tmp.WeightOnBox_Nom + tmp.WeightOnBox_Ves)
                     / CASE WHEN tmp.WeightOnBox_Sh = 0 AND tmp.WeightOnBox_Nom = 0 AND tmp.WeightOnBox_Ves = 0
                                 THEN 1
                            ELSE CASE WHEN tmp.WeightOnBox_Sh  > 0  THEN 1 ELSE 0 END
                               + CASE WHEN tmp.WeightOnBox_Nom > 0  THEN 1 ELSE 0 END
                               + CASE WHEN tmp.WeightOnBox_Ves > 0  THEN 1 ELSE 0 END
                       END AS WeightOnBox
                       -- Кол-во ед. в ящ. (E2/E3) - !!!самый приоритетный!!!
                     , tmp.CountOnBox
          
                       -- *** НЕ замена - WmsCellNum для Шт.
                     , tmp.WmsCellNum
                       -- ***замена - sku_id для Шт.
                     , COALESCE (wms_Object_GoodsByGoodsKind_sh.sku_id_Sh, tmp.sku_id_Sh) AS sku_id_Sh
                       --
                     , tmp.sku_id_Nom,   tmp.sku_id_Ves
                       -- ***замена - sku_code для Шт.
                     , COALESCE (wms_Object_GoodsByGoodsKind_sh.sku_code_Sh, tmp.sku_code_Sh) AS sku_code_Sh
                       --
                     , tmp.sku_code_Nom, tmp.sku_code_Ves
                     , tmp.isErased
                FROM _tmpGoodsByGoodsKind AS tmp
                     LEFT JOIN _tmpGoodsByGoodsKind AS wms_Object_GoodsByGoodsKind_sh
                                                    ON wms_Object_GoodsByGoodsKind_sh.GoodsId            = tmp.GoodsId
                                                   AND wms_Object_GoodsByGoodsKind_sh.GoodsKindId        = tmp.GoodsKindId
                                                   AND wms_Object_GoodsByGoodsKind_sh.GoodsTypeKindId_Sh = tmp.GoodsTypeKindId_Sh
                                                   AND tmp.GoodsTypeKindId_Sh                            > 0
          
               ) AS tmp
          WHERE tmp.ObjectId = wms_Object_GoodsByGoodsKind.ObjectId;

     -- 2. добавляем новые ObjectId
     INSERT INTO wms_Object_GoodsByGoodsKind (ObjectId
                                            , GoodsId
                                            , GoodsKindId
                                            , MeasureId
                                            , GoodsTypeKindId_Sh
                                            , GoodsTypeKindId_Nom
                                            , GoodsTypeKindId_Ves
                                              -- замена кода - на категорию "Штучный"
                                            , GoodsId_link_sh
                                            , GoodsKindId_link_sh
                                              -- средний вес 1ед.
                                            , WeightAvg_Sh
                                            , WeightAvg_Nom
                                            , WeightAvg_Ves
                                              -- % отклонения веса 1ед.
                                            , Tax_Sh
                                            , Tax_Nom
                                            , Tax_Ves
                                              -- мин/макс вес 1ед.
                                            , WeightMin_Sh
                                            , WeightMax_Sh
                                            , WeightMin_Nom
                                            , WeightMax_Nom
                                            , WeightMin_Ves
                                            , WeightMax_Ves
                                              -- Вес нетто в ящ. (E2/E3)
                                            , WeightOnBox_Sh
                                            , WeightOnBox_Nom
                                            , WeightOnBox_Ves
                                              -- calc = средниний вес 1ед. по всем категориям
                                            , WeightMin
                                            , WeightMax
                                              --
                                            , NormInDays
                                              --
                                            , Height
                                            , Length
                                            , Width
                                              --
                                            , WmsCode
                                              --
                                            , GoodsPropertyBoxId
                                            , BoxId
                                            , BoxWeight
                                              --
                                            , WeightOnBox
                                            , CountOnBox
                                              --
                                            , WmsCellNum
                                              --
                                            , sku_id_Sh
                                            , sku_id_Nom
                                            , sku_id_Ves
                                              --
                                            , sku_code_Sh
                                            , sku_code_Nom
                                            , sku_code_Ves
                                              --
                                            , isErased
                                             )
       -- 2.1.
       WITH _tmpGoodsByGoodsKind AS
               (SELECT tmp.Id AS ObjectId -- это GoodsByGoodsKind.Id
                       --
                     , tmp.GoodsId
                     , tmp.GoodsKindId
                     , tmp.MeasureId
                       -- GoodsTypeKindId
                     , CASE WHEN COALESCE (tmp.isGoodsTypeKind_Sh,   FALSE) <> FALSE THEN zc_Enum_GoodsTypeKind_Sh()  ELSE NULL END AS GoodsTypeKindId_Sh
                     , CASE WHEN COALESCE (tmp.isGoodsTypeKind_Nom,  FALSE) <> FALSE THEN zc_Enum_GoodsTypeKind_Nom() ELSE NULL END AS GoodsTypeKindId_Nom
                     , CASE WHEN COALESCE (tmp.isGoodsTypeKind_Ves,  FALSE) <> FALSE THEN zc_Enum_GoodsTypeKind_Ves() ELSE NULL END AS GoodsTypeKindId_Ves
                       -- замена кода - на категорию "Штучный"
                     , tmp.GoodsId_Sh
                     , tmp.GoodsKindId_Sh
                       -- средний вес 1ед.
                     , tmp.WeightAvg_Sh
                     , tmp.WeightAvg_Nom
                     , tmp.WeightAvg_Ves
                       -- % отклонения веса 1ед.
                     , tmp.Tax_Sh
                     , tmp.Tax_Nom
                     , tmp.Tax_Ves
                       -- мин/макс вес 1ед.
                     , tmp.WeightMin_Sh
                     , tmp.WeightMax_Sh
                     , tmp.WeightMin_Nom
                     , tmp.WeightMax_Nom
                     , tmp.WeightMin_Ves
                     , tmp.WeightMax_Ves
                       -- Вес нетто в ящ. (E2/E3)
                     , tmp.WeightOnBox_Sh
                     , tmp.WeightOnBox_Nom
                     , tmp.WeightOnBox_Ves
        
                       -- calc = средниний вес 1ед. по всем категориям
                   --, tmp.WeightMin
                   --, tmp.WeightMax
                       --
                     , tmp.NormInDays

                     , tmp.Height
                     , tmp.Length
                     , tmp.Width

                       -- Код ВМС - для sku_code
                     , tmp.WmsCode

                       --
                     , CASE WHEN tmp.BoxId IN (zc_Box_E2(), zc_Box_E3()) THEN tmp.GoodsPropertyBoxId  ELSE tmp.GoodsPropertyBoxId_2 END :: Integer AS GoodsPropertyBoxId
                     , CASE WHEN tmp.BoxId IN (zc_Box_E2(), zc_Box_E3()) THEN tmp.BoxId       ELSE tmp.BoxId_2     END :: Integer AS BoxId
                     , CASE WHEN tmp.BoxId IN (zc_Box_E2(), zc_Box_E3()) THEN tmp.BoxWeight   ELSE tmp.BoxWeight_2 END :: TFloat  AS BoxWeight

                       -- !!!***Вес нетто в ящ (E2/E3) - по всем категориям
                   --, CASE WHEN tmp.BoxId IN (zc_Box_E2(), zc_Box_E3()) THEN tmp.WeightOnBox ELSE NULL END :: TFloat  AS WeightOnBox
                       -- Кол-во ед. в ящ. (E2/E3) - !!!самый приоритетный!!!
                     , CASE WHEN tmp.BoxId IN (zc_Box_E2(), zc_Box_E3()) THEN tmp.CountOnBox  ELSE tmp.CountOnBox_2 END :: TFloat  AS CountOnBox

                       -- № Ячейки на складе ВМС
                     , tmp.WmsCellNum

                      -- !!! sku_id = GoodsByGoodsKindId + ... !!!
                     , tmp.Id * 10 + 1 AS sku_id_Sh
                     , tmp.Id * 10 + 2 AS sku_id_Nom
                     , tmp.Id * 10 + 3 AS sku_id_Ves
                       -- sku_code
                     , tmp.WmsCodeCalc_Sh AS sku_code_Sh, tmp.WmsCodeCalc_Nom AS sku_code_Nom, tmp.WmsCodeCalc_Ves AS sku_code_Ves

                       --
                     , Object_GoodsByGoodsKind.isErased

                FROM gpSelect_Object_GoodsByGoodsKind_VMC (0, 0 , 0, 0, 0, 0, inSession) AS tmp
                     LEFT JOIN Object AS Object_GoodsByGoodsKind ON Object_GoodsByGoodsKind.Id = tmp.Id
                WHERE tmp.GoodsId > 0 AND tmp.GoodsKindId > 0
               )
      -- 2.2. Результат
      SELECT tmp.ObjectId
           , tmp.GoodsId
           , tmp.GoodsKindId
           , tmp.MeasureId
           , tmp.GoodsTypeKindId_Sh
           , tmp.GoodsTypeKindId_Nom
           , tmp.GoodsTypeKindId_Ves

             -- замена кода - на категорию "Штучный"
           , tmp.GoodsId_Sh
           , tmp.GoodsKindId_Sh

             -- средний вес 1ед.
           , tmp.WeightAvg_Sh
           , tmp.WeightAvg_Nom
           , tmp.WeightAvg_Ves

             -- % отклонения веса 1ед.
           , tmp.Tax_Sh
           , tmp.Tax_Nom
           , tmp.Tax_Ves
             -- мин/макс вес 1ед.
           , tmp.WeightMin_Sh
           , tmp.WeightMax_Sh
           , tmp.WeightMin_Nom
           , tmp.WeightMax_Nom
           , tmp.WeightMin_Ves
           , tmp.WeightMax_Ves
             -- Вес нетто в ящ. (E2/E3)
           , tmp.WeightOnBox_Sh
           , tmp.WeightOnBox_Nom
           , tmp.WeightOnBox_Ves

             -- calc = средниний вес 1ед. по всем категориям
           , (tmp.WeightMin_Sh + tmp.WeightMin_Nom + tmp.WeightMin_Ves)
           / CASE WHEN tmp.WeightMin_Sh = 0 AND tmp.WeightMin_Nom = 0 AND tmp.WeightMin_Ves = 0
                       THEN 1
                  ELSE CASE WHEN tmp.WeightMin_Sh  > 0  THEN 1 ELSE 0 END
                     + CASE WHEN tmp.WeightMin_Nom > 0  THEN 1 ELSE 0 END
                     + CASE WHEN tmp.WeightMin_Ves > 0  THEN 1 ELSE 0 END
             END AS WeightMin
           , (tmp.WeightMax_Sh + tmp.WeightMax_Nom + tmp.WeightMax_Ves)
           / CASE WHEN tmp.WeightMax_Sh = 0 AND tmp.WeightMax_Nom = 0 AND tmp.WeightMax_Ves = 0
                       THEN 1
                  ELSE CASE WHEN tmp.WeightMax_Sh  > 0  THEN 1 ELSE 0 END
                     + CASE WHEN tmp.WeightMax_Nom > 0  THEN 1 ELSE 0 END
                     + CASE WHEN tmp.WeightMax_Ves > 0  THEN 1 ELSE 0 END
             END AS WeightMax

             -- Cрок годности, дн.
           , tmp.NormInDays
             -- Высота + Длина + Ширина
           , tmp.Height
           , tmp.Length
           , tmp.Width
             -- Код ВМС - для sku_code
           , tmp.WmsCode
             --
           , tmp.GoodsPropertyBoxId
           , tmp.BoxId
           , tmp.BoxWeight

             -- !!!***calc = Вес нетто в ящ (E2/E3) - по всем категориям
           , (tmp.WeightOnBox_Sh + tmp.WeightOnBox_Nom + tmp.WeightOnBox_Ves)
           / CASE WHEN tmp.WeightOnBox_Sh = 0 AND tmp.WeightOnBox_Nom = 0 AND tmp.WeightOnBox_Ves = 0
                       THEN 1
                  ELSE CASE WHEN tmp.WeightOnBox_Sh  > 0  THEN 1 ELSE 0 END
                     + CASE WHEN tmp.WeightOnBox_Nom > 0  THEN 1 ELSE 0 END
                     + CASE WHEN tmp.WeightOnBox_Ves > 0  THEN 1 ELSE 0 END
             END AS WeightOnBox
             -- Кол-во ед. в ящ. (E2/E3) - !!!самый приоритетный!!!
           , tmp.CountOnBox

             -- *** НЕ замена - WmsCellNum для Шт.
           , tmp.WmsCellNum
             -- ***замена - sku_id для Шт.
           , COALESCE (wms_Object_GoodsByGoodsKind_sh.sku_id_Sh, tmp.sku_id_Sh) AS sku_id_Sh
             --
           , tmp.sku_id_Nom,   tmp.sku_id_Ves
             -- ***замена - sku_code для Шт.
           , COALESCE (wms_Object_GoodsByGoodsKind_sh.sku_code_Sh, tmp.sku_code_Sh) AS sku_code_Sh
             --
           , tmp.sku_code_Nom, tmp.sku_code_Ves
           , tmp.isErased
      FROM _tmpGoodsByGoodsKind AS tmp
           LEFT JOIN _tmpGoodsByGoodsKind AS wms_Object_GoodsByGoodsKind_sh
                                          ON wms_Object_GoodsByGoodsKind_sh.GoodsId            = tmp.GoodsId
                                         AND wms_Object_GoodsByGoodsKind_sh.GoodsKindId        = tmp.GoodsKindId
                                         AND wms_Object_GoodsByGoodsKind_sh.GoodsTypeKindId_Sh = tmp.GoodsTypeKindId_Sh
                                         AND tmp.GoodsTypeKindId_Sh                            > 0

           LEFT JOIN wms_Object_GoodsByGoodsKind ON wms_Object_GoodsByGoodsKind.ObjectId = tmp.ObjectId
      WHERE wms_Object_GoodsByGoodsKind.ObjectId IS NULL
      ;

   -- сохранили протокол
   -- PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.08.19         * WmsCellNum
 23.05.19         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_wms_Object_GoodsByGoodsKind (zfCalc_UserAdmin())
