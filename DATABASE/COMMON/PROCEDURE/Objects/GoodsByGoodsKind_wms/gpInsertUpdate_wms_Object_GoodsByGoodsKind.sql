-- Function: gpInsertUpdate_wms_Object_GoodsByGoodsKind (Integer, Integer, Integer)

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
   
/*
    -- заливаем в линейную табл. - данные из zc_Object_GoodsByGoodsKind
    CREATE TEMP TABLE _tmpGoodsByGoodsKind (ObjectId Integer, GoodsId Integer, GoodsKindId Integer, MeasureId Integer, GoodsTypeKindId_Sh Integer, GoodsTypeKindId_Nom Integer, GoodsTypeKindId_Ves Integer
                                          , WeightMin TFloat, WeightMax TFloat, NormInDays TFloat, Height TFloat, Length TFloat, Width TFloat, WmsCode Integer
                                          , GoodsPropertyBoxId Integer, BoxId Integer, BoxWeight TFloat, WeightOnBox TFloat, CountOnBox TFloat
                                          , WmsCellNum Integer
                                          , sku_id_Sh   TVarChar, sku_id_Nom   TVarChar, sku_id_Ves   TVarChar
                                          , sku_code_Sh TVarChar, sku_code_Nom TVarChar, sku_code_Ves TVarChar
                                          , isErased Boolean
                                           ) ON COMMIT DROP;
          INSERT INTO _tmpGoodsByGoodsKind (ObjectId, GoodsId, GoodsKindId, MeasureId, GoodsTypeKindId_Sh, GoodsTypeKindId_Nom, GoodsTypeKindId_Ves
                                          , WeightMin, WeightMax, NormInDays, Height, Length, Width, WmsCode
                                          , GoodsPropertyBoxId, BoxId, BoxWeight, WeightOnBox, CountOnBox
                                          , WmsCellNum
                                          , sku_id_Sh,   sku_id_Nom,   sku_id_Ves
                                          , sku_code_Sh, sku_code_Nom, sku_code_Ves
                                          , isErased
                                           )
          -- Результат
          SELECT tmp.Id AS ObjectId
               , tmp.GoodsId
               , tmp.GoodsKindId
               , tmp.MeasureId
               , CASE WHEN COALESCE (tmp.isGoodsTypeKind_Sh,   FALSE) <> FALSE THEN zc_Enum_GoodsTypeKind_Sh()  ELSE NULL END AS GoodsTypeKindId_Sh
               , CASE WHEN COALESCE (tmp.isGoodsTypeKind_Nom,  FALSE) <> FALSE THEN zc_Enum_GoodsTypeKind_Nom() ELSE NULL END AS GoodsTypeKindId_Nom
               , CASE WHEN COALESCE (tmp.isGoodsTypeKind_Ves,  FALSE) <> FALSE THEN zc_Enum_GoodsTypeKind_Ves() ELSE NULL END AS GoodsTypeKindId_Ves
               , tmp.WeightMin
               , tmp.WeightMax
               , tmp.NormInDays
               , tmp.Height
               , tmp.Length
               , tmp.Width
               , tmp.WmsCode
               , tmp.GoodsPropertyBoxId
               , CASE WHEN tmp.BoxId IN (zc_Box_E2(), zc_Box_E3()) THEN tmp.BoxId       ELSE NULL END :: Integer AS BoxId
               , CASE WHEN tmp.BoxId IN (zc_Box_E2(), zc_Box_E3()) THEN tmp.BoxWeight   ELSE NULL END :: TFloat  AS BoxWeight
               , CASE WHEN tmp.BoxId IN (zc_Box_E2(), zc_Box_E3()) THEN tmp.WeightOnBox ELSE NULL END :: TFloat  AS WeightOnBox
               , CASE WHEN tmp.BoxId IN (zc_Box_E2(), zc_Box_E3()) THEN tmp.CountOnBox  ELSE NULL END :: TFloat  AS CountOnBox
               , tmp.WmsCellNum
               , tmp.Id * 10 + 1 AS sku_id_Sh
               , tmp.Id * 10 + 2 AS sku_id_Nom
               , tmp.Id * 10 + 3 AS sku_id_Ves
               , tmp.WmsCodeCalc_Sh AS sku_code_Sh, tmp.WmsCodeCalc_Nom AS sku_code_Nom, tmp.WmsCodeCalc_Ves AS sku_code_Ves
               , Object_GoodsByGoodsKind.isErased
          FROM gpSelect_Object_GoodsByGoodsKind_VMC (0, 0 , 0, 0, 0, 0, inSession) AS tmp
               LEFT JOIN Object AS Object_GoodsByGoodsKind ON Object_GoodsByGoodsKind.Id = tmp.Id
          WHERE tmp.GoodsId > 0 AND tmp.GoodsKindId > 0 
         ;
  */         
          -- Обновляем существующие ObjectId
          UPDATE wms_Object_GoodsByGoodsKind
           SET GoodsId               = tmp.GoodsId            
             , GoodsKindId           = tmp.GoodsKindId        
             , MeasureId             = tmp.MeasureId          
             , GoodsTypeKindId_Sh    = tmp.GoodsTypeKindId_Sh 
             , GoodsTypeKindId_Nom   = tmp.GoodsTypeKindId_Nom
             , GoodsTypeKindId_Ves   = tmp.GoodsTypeKindId_Ves
             , WeightMin             = tmp.WeightMin          
             , WeightMax             = tmp.WeightMax          
             , NormInDays            = tmp.NormInDays         
             , Height                = tmp.Height             
             , Length                = tmp.Length             
             , Width                 = tmp.Width              
             , WmsCode               = tmp.WmsCode
             , GoodsPropertyBoxId    = tmp.GoodsPropertyBoxId
             , BoxId                 = tmp.BoxId              
             , BoxWeight             = tmp.BoxWeight          
             , WeightOnBox           = tmp.WeightOnBox        
             , CountOnBox            = tmp.CountOnBox         
             , WmsCellNum            = tmp.WmsCellNum
             , sku_id_Sh             = tmp.sku_id_Sh
             , sku_id_Nom            = tmp.sku_id_Nom
             , sku_id_Ves            = tmp.sku_id_Ves
             , sku_code_Sh           = tmp.sku_code_Sh
             , sku_code_Nom          = tmp.sku_code_Nom
             , sku_code_Ves          = tmp.sku_code_Ves
             , isErased              = tmp.isErased           
        --FROM _tmpGoodsByGoodsKind AS tmp
          -- Результат
          FROM
         (SELECT tmp.Id AS ObjectId
               , tmp.GoodsId
               , tmp.GoodsKindId
               , tmp.MeasureId
               , CASE WHEN COALESCE (tmp.isGoodsTypeKind_Sh,   FALSE) <> FALSE THEN zc_Enum_GoodsTypeKind_Sh()  ELSE NULL END AS GoodsTypeKindId_Sh
               , CASE WHEN COALESCE (tmp.isGoodsTypeKind_Nom,  FALSE) <> FALSE THEN zc_Enum_GoodsTypeKind_Nom() ELSE NULL END AS GoodsTypeKindId_Nom
               , CASE WHEN COALESCE (tmp.isGoodsTypeKind_Ves,  FALSE) <> FALSE THEN zc_Enum_GoodsTypeKind_Ves() ELSE NULL END AS GoodsTypeKindId_Ves
               , tmp.WeightMin
               , tmp.WeightMax
               , tmp.NormInDays
               , tmp.Height
               , tmp.Length
               , tmp.Width
               , tmp.WmsCode
               , tmp.GoodsPropertyBoxId
               , CASE WHEN tmp.BoxId IN (zc_Box_E2(), zc_Box_E3()) THEN tmp.BoxId       ELSE NULL END :: Integer AS BoxId
               , CASE WHEN tmp.BoxId IN (zc_Box_E2(), zc_Box_E3()) THEN tmp.BoxWeight   ELSE NULL END :: TFloat  AS BoxWeight
               , CASE WHEN tmp.BoxId IN (zc_Box_E2(), zc_Box_E3()) THEN tmp.WeightOnBox ELSE NULL END :: TFloat  AS WeightOnBox
               , CASE WHEN tmp.BoxId IN (zc_Box_E2(), zc_Box_E3()) THEN tmp.CountOnBox  ELSE NULL END :: TFloat  AS CountOnBox
               , tmp.WmsCellNum
               , tmp.Id * 10 + 1 AS sku_id_Sh
               , tmp.Id * 10 + 2 AS sku_id_Nom
               , tmp.Id * 10 + 3 AS sku_id_Ves
               , tmp.WmsCodeCalc_Sh AS sku_code_Sh, tmp.WmsCodeCalc_Nom AS sku_code_Nom, tmp.WmsCodeCalc_Ves AS sku_code_Ves
               , Object_GoodsByGoodsKind.isErased
          FROM gpSelect_Object_GoodsByGoodsKind_VMC (0, 0 , 0, 0, 0, 0, inSession) AS tmp
               LEFT JOIN Object AS Object_GoodsByGoodsKind ON Object_GoodsByGoodsKind.Id = tmp.Id
          WHERE tmp.GoodsId > 0 AND tmp.GoodsKindId > 0 
         ) AS tmp
          WHERE tmp.ObjectId = wms_Object_GoodsByGoodsKind.ObjectId;
     
     -- добавляем новые ObjectId
     INSERT INTO wms_Object_GoodsByGoodsKind (ObjectId
                                            , GoodsId
                                            , GoodsKindId
                                            , MeasureId
                                            , GoodsTypeKindId_Sh
                                            , GoodsTypeKindId_Nom
                                            , GoodsTypeKindId_Ves
                                            , WeightMin
                                            , WeightMax
                                            , NormInDays
                                            , Height
                                            , Length
                                            , Width
                                            , WmsCode
                                            , GoodsPropertyBoxId
                                            , BoxId
                                            , BoxWeight
                                            , WeightOnBox
                                            , CountOnBox
                                            , WmsCellNum
                                            , sku_id_Sh
                                            , sku_id_Nom
                                            , sku_id_Ves
                                            , sku_code_Sh
                                            , sku_code_Nom
                                            , sku_code_Ves
                                            , isErased
                                             )
       WITH _tmpGoodsByGoodsKind AS
         (SELECT tmp.Id AS ObjectId
               , tmp.GoodsId
               , tmp.GoodsKindId
               , tmp.MeasureId
               , CASE WHEN COALESCE (tmp.isGoodsTypeKind_Sh,   FALSE) <> FALSE THEN zc_Enum_GoodsTypeKind_Sh()  ELSE NULL END AS GoodsTypeKindId_Sh
               , CASE WHEN COALESCE (tmp.isGoodsTypeKind_Nom,  FALSE) <> FALSE THEN zc_Enum_GoodsTypeKind_Nom() ELSE NULL END AS GoodsTypeKindId_Nom
               , CASE WHEN COALESCE (tmp.isGoodsTypeKind_Ves,  FALSE) <> FALSE THEN zc_Enum_GoodsTypeKind_Ves() ELSE NULL END AS GoodsTypeKindId_Ves
               , tmp.WeightMin
               , tmp.WeightMax
               , tmp.NormInDays
               , tmp.Height
               , tmp.Length
               , tmp.Width
               , tmp.WmsCode
               , tmp.GoodsPropertyBoxId
               , CASE WHEN tmp.BoxId IN (zc_Box_E2(), zc_Box_E3()) THEN tmp.BoxId       ELSE NULL END :: Integer AS BoxId
               , CASE WHEN tmp.BoxId IN (zc_Box_E2(), zc_Box_E3()) THEN tmp.BoxWeight   ELSE NULL END :: TFloat  AS BoxWeight
               , CASE WHEN tmp.BoxId IN (zc_Box_E2(), zc_Box_E3()) THEN tmp.WeightOnBox ELSE NULL END :: TFloat  AS WeightOnBox
               , CASE WHEN tmp.BoxId IN (zc_Box_E2(), zc_Box_E3()) THEN tmp.CountOnBox  ELSE NULL END :: TFloat  AS CountOnBox
               , tmp.WmsCellNum
               , tmp.Id * 10 + 1 AS sku_id_Sh
               , tmp.Id * 10 + 2 AS sku_id_Nom
               , tmp.Id * 10 + 3 AS sku_id_Ves
               , tmp.WmsCodeCalc_Sh AS sku_code_Sh, tmp.WmsCodeCalc_Nom AS sku_code_Nom, tmp.WmsCodeCalc_Ves AS sku_code_Ves
               , Object_GoodsByGoodsKind.isErased
          FROM gpSelect_Object_GoodsByGoodsKind_VMC (0, 0 , 0, 0, 0, 0, inSession) AS tmp
               LEFT JOIN Object AS Object_GoodsByGoodsKind ON Object_GoodsByGoodsKind.Id = tmp.Id
          WHERE tmp.GoodsId > 0 AND tmp.GoodsKindId > 0 
         )
      SELECT tmp.ObjectId
           , tmp.GoodsId
           , tmp.GoodsKindId
           , tmp.MeasureId
           , tmp.GoodsTypeKindId_Sh
           , tmp.GoodsTypeKindId_Nom
           , tmp.GoodsTypeKindId_Ves
           , tmp.WeightMin
           , tmp.WeightMax
           , tmp.NormInDays
           , tmp.Height
           , tmp.Length
           , tmp.Width
           , tmp.WmsCode
           , tmp.GoodsPropertyBoxId
           , tmp.BoxId
           , tmp.BoxWeight
           , tmp.WeightOnBox
           , tmp.CountOnBox
           , tmp.WmsCellNum
           , tmp.sku_id_Sh,   tmp.sku_id_Nom,   tmp.sku_id_Ves
           , tmp.sku_code_Sh, tmp.sku_code_Nom, tmp.sku_code_Ves
           , tmp.isErased
      FROM _tmpGoodsByGoodsKind AS tmp
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
