-- Function: lpInsertUpdate_wms_Object_Pack()
-- 4.1.1.1 Справочник упаковок <Pack>

DROP FUNCTION IF EXISTS lpInsertUpdate_wms_Object_Pack();

CREATE OR REPLACE FUNCTION lpInsertUpdate_wms_Object_Pack()
RETURNS VOID
AS
$BODY$
BEGIN

     -- UPDATE
     UPDATE wms_Object_Pack SET GoodsId     = tmpAll.GoodsId
                              , GoodsKindId = tmpAll.GoodsTypeKindId
                              , UpdateDate  = CURRENT_TIMESTAMP
     FROM (WITH tmpGoods AS (SELECT -- Ящик (E2/E3)
                                    tmp.GoodsPropertyBoxId
                                  , tmp.GoodsTypeKindId
                                  , tmp.GoodsId
                                  , tmp.GoodsKindId
                             FROM lpSelect_wms_Object_SKU() AS tmp
                             WHERE tmp.GoodsPropertyBoxId > 0
                            )
           -- Результат
           SELECT tmpGoods.GoodsPropertyBoxId
                , tmpGoods.GoodsTypeKindId
                , 'unit'   :: TVarChar AS ctn_type -- Тип упаковки: единичная упаковка
                , tmpGoods.GoodsId
                , tmpGoods.GoodsKindId
           FROM tmpGoods
          UNION
           SELECT tmpGoods.GoodsPropertyBoxId
                , tmpGoods.GoodsTypeKindId
                , 'carton' :: TVarChar AS ctn_type -- Тип упаковки: коробочная упаковка
                , tmpGoods.GoodsId
                , tmpGoods.GoodsKindId
           FROM tmpGoods
          ) AS tmpAll
     WHERE wms_Object_Pack.GoodsPropertyBoxId = tmpAll.GoodsPropertyBoxId
       AND wms_Object_Pack.GoodsTypeKindId    = tmpAll.GoodsTypeKindId
       AND wms_Object_Pack.ctn_type           = tmpAll.ctn_type
       AND (wms_Object_Pack.GoodsId           <> tmpAll.GoodsId
         OR wms_Object_Pack.GoodsKindId       <> tmpAll.GoodsKindId
           );

     -- INSERT
     INSERT INTO wms_Object_Pack (GoodsPropertyBoxId, GoodsTypeKindId, ctn_type, GoodsId, GoodsKindId, InsertDate, UpdateDate)
        WITH tmpGoods AS (SELECT -- Ящик (E2/E3)
                                 tmp.GoodsPropertyBoxId
                               , tmp.GoodsTypeKindId
                               , tmp.GoodsId
                               , tmp.GoodsKindId
                          FROM lpSelect_wms_Object_SKU() AS tmp
                          WHERE tmp.GoodsPropertyBoxId > 0
                         )
            , tmpAll AS (SELECT tmpGoods.GoodsPropertyBoxId
                              , tmpGoods.GoodsTypeKindId
                              , 'unit'   :: TVarChar AS ctn_type -- Тип упаковки: единичная упаковка
                              , tmpGoods.GoodsId
                              , tmpGoods.GoodsKindId
                         FROM tmpGoods
                        UNION
                         SELECT tmpGoods.GoodsPropertyBoxId
                              , tmpGoods.GoodsTypeKindId
                              , 'carton' :: TVarChar AS ctn_type -- Тип упаковки: коробочная упаковка
                              , tmpGoods.GoodsId
                              , tmpGoods.GoodsKindId
                         FROM tmpGoods
                        )
        -- Результат
        SELECT tmpAll.GoodsPropertyBoxId
             , tmpAll.GoodsTypeKindId
             , tmpAll.ctn_type
             , tmpAll.GoodsId
             , tmpAll.GoodsKindId
             , CURRENT_TIMESTAMP           AS InsertDate
             , NULL                        AS UpdateDate
        FROM tmpAll
             LEFT JOIN wms_Object_Pack ON wms_Object_Pack.GoodsPropertyBoxId = tmpAll.GoodsPropertyBoxId
                                      AND wms_Object_Pack.GoodsTypeKindId    = tmpAll.GoodsTypeKindId
                                      AND wms_Object_Pack.ctn_type           = tmpAll.ctn_type
        WHERE wms_Object_Pack.GoodsPropertyBoxId IS NULL
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.08.19                                       *
*/
-- тест
-- SELECT * FROM lpInsertUpdate_wms_Object_Pack()

