-- Function: gpInsertUpdate_Object_GoodsByGoodsKind_wms (Integer, Integer, Integer)

DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind_wms (TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsByGoodsKind_wms(
    IN inSession             TVarChar 
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKind());
   
   --выбираем данные из zc_Object_GoodsByGoodsKind
    CREATE TEMP TABLE tmpGoodsByGoodsKind (ObjectId Integer, GoodsId Integer, GoodsKindId Integer, MeasureId Integer, GoodsTypeKindId_Sh Integer, GoodsTypeKindId_Nom Integer, GoodsTypeKindId_Ves Integer
                                         , WeightMin TFloat, WeightMax TFloat, NormInDays TFloat, Height TFloat, Length TFloat, Width TFloat, WmsCode Integer, BoxId Integer, BoxWeight TFloat, WeightOnBox TFloat, CountOnBox TFloat, isErased Boolean) ON COMMIT DROP;
          INSERT INTO tmpGoodsByGoodsKind (ObjectId, GoodsId, GoodsKindId, MeasureId, GoodsTypeKindId_Sh, GoodsTypeKindId_Nom, GoodsTypeKindId_Ves
                                         , WeightMin, WeightMax, NormInDays, Height, Length, Width, WmsCode, BoxId, BoxWeight, WeightOnBox, CountOnBox, isErased)
          SELECT tmp.Id AS ObjectId
               , tmp.GoodsId
               , tmp.GoodsKindId
               , tmp.MeasureId
               , CASE WHEN COALESCE (tmp.isGoodsTypeKind_Sh, FALSE)   <> FALSE THEN zc_Enum_GoodsTypeKind_Sh()  ELSE NULL END AS GoodsTypeKindId_Sh
               , CASE WHEN COALESCE (tmp.isGoodsTypeKind_Nom,  FALSE) <> FALSE THEN zc_Enum_GoodsTypeKind_Nom() ELSE NULL END AS GoodsTypeKindId_Nom
               , CASE WHEN COALESCE (tmp.isGoodsTypeKind_Ves,  FALSE) <> FALSE THEN zc_Enum_GoodsTypeKind_Ves() ELSE NULL END AS GoodsTypeKindId_Ves
               , tmp.WeightMin
               , tmp.WeightMax
               , tmp.NormInDays
               , tmp.Height
               , tmp.Length
               , tmp.Width
               , tmp.WmsCode
               , CASE WHEN tmp.BoxId IN (zc_Box_E2(), zc_Box_E3()) THEN tmp.BoxId       ELSE NULL END AS BoxId
               , CASE WHEN tmp.BoxId IN (zc_Box_E2(), zc_Box_E3()) THEN tmp.BoxWeight   ELSE NULL END :: TFloat AS BoxWeight
               , CASE WHEN tmp.BoxId IN (zc_Box_E2(), zc_Box_E3()) THEN tmp.WeightOnBox ELSE NULL END :: TFloat AS WeightOnBox
               , CASE WHEN tmp.BoxId IN (zc_Box_E2(), zc_Box_E3()) THEN tmp.CountOnBox  ELSE NULL END :: TFloat AS CountOnBox
               , Object_GoodsByGoodsKind.isErased
          FROM gpSelect_Object_GoodsByGoodsKind_VMC (0,0,0,0,0,0,inSession) AS tmp
               LEFT JOIN Object AS Object_GoodsByGoodsKind ON Object_GoodsByGoodsKind.Id = tmp.Id;
           
          -- Обновляем те записи которые уже есть в таблице
          UPDATE Object_GoodsByGoodsKind
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
             , BoxId                 = tmp.BoxId              
             , BoxWeight             = tmp.BoxWeight          
             , WeightOnBox           = tmp.WeightOnBox        
             , CountOnBox            = tmp.CountOnBox         
             , isErased              = tmp.isErased           
          FROM tmpGoodsByGoodsKind AS tmp
          WHERE tmp.ObjectId = Object_GoodsByGoodsKind.ObjectId;         
     
     -- добавляем новые строки
     INSERT INTO Object_GoodsByGoodsKind (ObjectId
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
                                        , BoxId
                                        , BoxWeight
                                        , WeightOnBox
                                        , CountOnBox
                                        , isErased)
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
           , tmp.BoxId
           , tmp.BoxWeight
           , tmp.WeightOnBox
           , tmp.CountOnBox
           , tmp.isErased
      FROM tmpGoodsByGoodsKind AS tmp
           LEFT JOIN Object_GoodsByGoodsKind ON Object_GoodsByGoodsKind.ObjectId = tmp.ObjectId
      WHERE Object_GoodsByGoodsKind.ObjectId IS NULL
      ;

   -- сохранили протокол
   --PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  
 23.05.19         *
*/

-- тест
-- 