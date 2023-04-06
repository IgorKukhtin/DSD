-- Function: gpUpdate_Object_ReceiptGoodsChild_byReceiptGoods()

DROP FUNCTION IF EXISTS gpUpdate_Object_ReceiptGoodsChild_byReceiptGoods(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_ReceiptGoodsChild_byReceiptGoods(
 INOUT inReceiptGoodsId      Integer   ,    -- ключ объекта <>
    IN inReceiptGoodsId_mask Integer   ,    -- 
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean; 
   DECLARE vbBrandName TVarChar;
   DECLARE vbModelName TVarChar;
   DECLARE vbModelCode TVarChar;
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ReceiptProdModel());
   vbUserId:= lpGetUserBySession (inSession);

   CREATE TEMP TABLE _tmpReceiptGoodsChild_mask (NPP Integer, Comment TVarChar
                                               , ObjectId Integer, ReceiptLevelId Integer, MaterialOptionsId Integer
                                               , Value NUMERIC (16, 8), Value_servise NUMERIC (16, 8)
                                               , ForCount TFloat) ON COMMIT DROP;
    INSERT INTO _tmpReceiptGoodsChild_mask (NPP, Comment, ObjectId, ReceiptLevelId, MaterialOptionsId, Value, Value_servise, ForCount )
          SELECT ROW_NUMBER() OVER (ORDER BY Object_ReceiptGoodsChild.Id ASC) :: Integer AS NPP
               , Object_ReceiptGoodsChild.ValueData      AS Comment
               , ObjectLink_Object.ChildObjectId         AS ObjectId
               , ObjectLink_ReceiptLevel.ChildObjectId   AS ReceiptLevelId
               , ObjectLink_MaterialOptions.ChildObjectId AS MaterialOptionsId
               , CASE WHEN ObjectDesc.Id <> zc_Object_ReceiptService() THEN ObjectFloat_Value.ValueData / CASE WHEN ObjectFloat_ForCount.ValueData > 1 THEN ObjectFloat_ForCount.ValueData ELSE 1 END ELSE 0 END :: NUMERIC (16, 8) AS Value
               , CASE WHEN ObjectDesc.Id =  zc_Object_ReceiptService() THEN ObjectFloat_Value.ValueData / CASE WHEN ObjectFloat_ForCount.ValueData > 1 THEN ObjectFloat_ForCount.ValueData ELSE 1 END ELSE 0 END :: NUMERIC (16, 8) AS Value_servise
               , ObjectFloat_ForCount.ValueData AS ForCount
          FROM Object AS Object_ReceiptGoodsChild
               INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                     ON ObjectLink_ReceiptGoods.ObjectId = Object_ReceiptGoodsChild.Id
                                    AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                    AND ObjectLink_ReceiptGoods.ChildObjectId = inReceiptGoodsId_mask
     
               LEFT JOIN ObjectLink AS ObjectLink_Object
                                    ON ObjectLink_Object.ObjectId = Object_ReceiptGoodsChild.Id
                                   AND ObjectLink_Object.DescId = zc_ObjectLink_ReceiptGoodsChild_Object()
               LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_Object.ChildObjectId
               LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId

               LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                    ON ObjectLink_MaterialOptions.ObjectId = Object_ReceiptGoodsChild.Id
                                   AND ObjectLink_MaterialOptions.DescId   = zc_ObjectLink_ReceiptGoodsChild_MaterialOptions()
     
               -- значение в сборке
               LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                     ON ObjectFloat_Value.ObjectId = Object_ReceiptGoodsChild.Id
                                    AND ObjectFloat_Value.DescId   = zc_ObjectFloat_ReceiptGoodsChild_Value()
               LEFT JOIN ObjectFloat AS ObjectFloat_ForCount
                                     ON ObjectFloat_ForCount.ObjectId = Object_ReceiptGoodsChild.Id
                                    AND ObjectFloat_ForCount.DescId   = zc_ObjectFloat_ReceiptGoodsChild_ForCount()
     
               LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                    ON ObjectLink_ProdColorPattern.ObjectId = Object_ReceiptGoodsChild.Id
                                   AND ObjectLink_ProdColorPattern.DescId = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()
     
               LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel
                                    ON ObjectLink_ReceiptLevel.ObjectId = Object_ReceiptGoodsChild.Id
                                   AND ObjectLink_ReceiptLevel.DescId   = zc_ObjectLink_ReceiptGoodsChild_ReceiptLevel()
          WHERE Object_ReceiptGoodsChild.DescId = zc_Object_ReceiptGoodsChild()
            AND Object_ReceiptGoodsChild.isErased = FALSE 
            AND ObjectLink_ProdColorPattern.ChildObjectId IS NULL
       ;
       
   CREATE TEMP TABLE _tmpReceiptGoodsChild (Id Integer, NPP Integer, Comment TVarChar
                                          , ObjectId Integer, ReceiptLevelId Integer, MaterialOptionsId Integer , GoodsChildId Integer
                                          , Value NUMERIC (16, 8), Value_servise NUMERIC (16, 8)
                                          , ForCount TFloat) ON COMMIT DROP;
    INSERT INTO _tmpReceiptGoodsChild (Id, NPP, Comment, ObjectId, ReceiptLevelId, MaterialOptionsId, GoodsChildId, Value, Value_servise, ForCount )
          SELECT Object_ReceiptGoodsChild.Id
               , ROW_NUMBER() OVER (ORDER BY Object_ReceiptGoodsChild.Id ASC) :: Integer AS NPP
               , Object_ReceiptGoodsChild.ValueData      AS Comment
               , ObjectLink_Object.ChildObjectId         AS ObjectId
               , ObjectLink_ReceiptLevel.ChildObjectId   AS ReceiptLevelId
               , ObjectLink_MaterialOptions.ChildObjectId AS MaterialOptionsId
               , ObjectLink_GoodsChild.ChildObjectId      AS GoodsChildId
               , CASE WHEN ObjectDesc.Id <> zc_Object_ReceiptService() THEN ObjectFloat_Value.ValueData / CASE WHEN ObjectFloat_ForCount.ValueData > 1 THEN ObjectFloat_ForCount.ValueData ELSE 1 END ELSE 0 END :: NUMERIC (16, 8) AS Value
               , CASE WHEN ObjectDesc.Id =  zc_Object_ReceiptService() THEN ObjectFloat_Value.ValueData / CASE WHEN ObjectFloat_ForCount.ValueData > 1 THEN ObjectFloat_ForCount.ValueData ELSE 1 END ELSE 0 END :: NUMERIC (16, 8) AS Value_servise
               , ObjectFloat_ForCount.ValueData AS ForCount
          FROM Object AS Object_ReceiptGoodsChild
               INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                     ON ObjectLink_ReceiptGoods.ObjectId = Object_ReceiptGoodsChild.Id
                                    AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                    AND ObjectLink_ReceiptGoods.ChildObjectId = inReceiptGoodsId
     
               LEFT JOIN ObjectLink AS ObjectLink_Object
                                    ON ObjectLink_Object.ObjectId = Object_ReceiptGoodsChild.Id
                                   AND ObjectLink_Object.DescId = zc_ObjectLink_ReceiptGoodsChild_Object()
               LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_Object.ChildObjectId
               LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId

               LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                    ON ObjectLink_MaterialOptions.ObjectId = Object_ReceiptGoodsChild.Id
                                   AND ObjectLink_MaterialOptions.DescId   = zc_ObjectLink_ReceiptGoodsChild_MaterialOptions()
     
               -- значение в сборке
               LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                     ON ObjectFloat_Value.ObjectId = Object_ReceiptGoodsChild.Id
                                    AND ObjectFloat_Value.DescId   = zc_ObjectFloat_ReceiptGoodsChild_Value()
               LEFT JOIN ObjectFloat AS ObjectFloat_ForCount
                                     ON ObjectFloat_ForCount.ObjectId = Object_ReceiptGoodsChild.Id
                                    AND ObjectFloat_ForCount.DescId   = zc_ObjectFloat_ReceiptGoodsChild_ForCount()
     
               LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                    ON ObjectLink_ProdColorPattern.ObjectId = Object_ReceiptGoodsChild.Id
                                   AND ObjectLink_ProdColorPattern.DescId = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()
     
               LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel
                                    ON ObjectLink_ReceiptLevel.ObjectId = Object_ReceiptGoodsChild.Id
                                   AND ObjectLink_ReceiptLevel.DescId   = zc_ObjectLink_ReceiptGoodsChild_ReceiptLevel()

               LEFT JOIN ObjectLink AS ObjectLink_GoodsChild
                                    ON ObjectLink_GoodsChild.ObjectId = Object_ReceiptGoodsChild.Id
                                   AND ObjectLink_GoodsChild.DescId   = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()
               LEFT JOIN Object AS Object_GoodsChild ON Object_GoodsChild.Id = ObjectLink_GoodsChild.ChildObjectId
          WHERE Object_ReceiptGoodsChild.DescId = zc_Object_ReceiptGoodsChild()
            AND Object_ReceiptGoodsChild.isErased = FALSE 
            AND ObjectLink_ProdColorPattern.ChildObjectId IS NULL
       ;

        UPDATE Object
         SET isErased = TRUE
        WHERE Object.Id IN (SELECT _tmpReceiptGoodsChild.Id 
                            FROM _tmpReceiptGoodsChild
                                 LEFT JOIN _tmpReceiptGoodsChild_mask ON _tmpReceiptGoodsChild_mask.ObjectId = _tmpReceiptGoodsChild.ObjectId
                            WHERE _tmpReceiptGoodsChild_mask.ObjectId IS NULL
                            )
          AND Object.DescId   = zc_Object_ReceiptGoodsChild()
        ;
 
      
       PERFORM gpInsertUpdate_Object_ReceiptGoodsChild (ioId                 := COALESCE (_tmpReceiptGoodsChild.Id, 0)
                                                      , inComment            := Object.ValueData      ::TVarChar
                                                      , inReceiptGoodsId     := inReceiptGoodsId      ::Integer
                                                      , inObjectId           := Object.Id             ::Integer
                                                      , inProdColorPatternId := Null                  ::Integer
                                                      , inMaterialOptionsId  := _tmpReceiptGoodsChild.MaterialOptionsId  ::Integer
                                                      , inReceiptLevelId_top := 0                     ::Integer --COALESCE (_tmpReceiptGoodsChild.ReceiptLevelId, _tmpReceiptProdModelChild.ReceiptLevelId) ::Integer
                                                      , inReceiptLevelId     := COALESCE (_tmpReceiptGoodsChild_mask.ReceiptLevelId, _tmpReceiptGoodsChild.ReceiptLevelId)  ::Integer
                                                      , inGoodsChildId       := _tmpReceiptGoodsChild.GoodsChildId                                                         ::Integer
                                                      , ioValue              := COALESCE (_tmpReceiptGoodsChild_mask.Value, _tmpReceiptGoodsChild.Value)                   ::TVarChar
                                                      , ioValue_service      := COALESCE (_tmpReceiptGoodsChild_mask.Value_servise, _tmpReceiptGoodsChild.Value_servise)   ::TVarChar
                                                      , ioForCount           := COALESCE (_tmpReceiptGoodsChild_mask.ForCount, _tmpReceiptGoodsChild.ForCount)             ::TFloat
                                                      , inIsEnabled          := TRUE                                                                                       ::Boolean
                                                      , inSession            := inSession             ::TVarChar
                                                       )
       FROM  _tmpReceiptGoodsChild_mask
            LEFT JOIN _tmpReceiptGoodsChild ON _tmpReceiptGoodsChild.ObjectId = _tmpReceiptGoodsChild_mask.ObjectId
            LEFT JOIN Object ON Object.Id = COALESCE (_tmpReceiptGoodsChild_mask.ObjectId, _tmpReceiptGoodsChild.ObjectId)
       Order by _tmpReceiptGoodsChild_mask.Npp
       ; 
       

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
06.04.23          *               
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ReceiptProdModel()
