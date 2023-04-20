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
                                               , ObjectId Integer, ReceiptLevelId Integer, MaterialOptionsId Integer, ProdColorPatternId Integer, GoodsChildId Integer
                                               , Value TFloat, Value_servise TFloat
                                               , ForCount TFloat
                                                ) ON COMMIT DROP;
    INSERT INTO _tmpReceiptGoodsChild_mask (NPP, Comment, ObjectId, ReceiptLevelId, MaterialOptionsId, ProdColorPatternId, GoodsChildId, Value, Value_servise, ForCount )
          SELECT ObjectFloat_NPP.ValueData :: Integer      AS NPP
               , Object_ReceiptGoodsChild.ValueData        AS Comment
               , ObjectLink_Object.ChildObjectId           AS ObjectId
               , ObjectLink_ReceiptLevel.ChildObjectId     AS ReceiptLevelId
               , ObjectLink_MaterialOptions.ChildObjectId  AS MaterialOptionsId
               , ObjectLink_ProdColorPattern.ChildObjectId AS ProdColorPatternId
               , ObjectLink_GoodsChild.ChildObjectId       AS GoodsChildId
               , CASE WHEN ObjectDesc.Id <> zc_Object_ReceiptService() THEN ObjectFloat_Value.ValueData ELSE 0 END AS Value
               , CASE WHEN ObjectDesc.Id =  zc_Object_ReceiptService() THEN ObjectFloat_Value.ValueData ELSE 0 END AS Value_servise
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

               -- NPP
               INNER JOIN ObjectFloat AS ObjectFloat_NPP
                                      ON ObjectFloat_NPP.ObjectId  = Object_ReceiptGoodsChild.Id
                                     AND ObjectFloat_NPP.DescId    = zc_ObjectFloat_ReceiptGoodsChild_NPP()
                                     AND ObjectFloat_NPP.ValueData > 0

               -- значение в сборке
               LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                     ON ObjectFloat_Value.ObjectId = Object_ReceiptGoodsChild.Id
                                    AND ObjectFloat_Value.DescId   = zc_ObjectFloat_ReceiptGoodsChild_Value()
               LEFT JOIN ObjectFloat AS ObjectFloat_ForCount
                                     ON ObjectFloat_ForCount.ObjectId = Object_ReceiptGoodsChild.Id
                                    AND ObjectFloat_ForCount.DescId   = zc_ObjectFloat_ReceiptGoodsChild_ForCount()

               -- эту структуру отбросим позже
               LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                    ON ObjectLink_ProdColorPattern.ObjectId = Object_ReceiptGoodsChild.Id
                                   AND ObjectLink_ProdColorPattern.DescId = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()

               LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel
                                    ON ObjectLink_ReceiptLevel.ObjectId = Object_ReceiptGoodsChild.Id
                                   AND ObjectLink_ReceiptLevel.DescId   = zc_ObjectLink_ReceiptGoodsChild_ReceiptLevel()

               LEFT JOIN ObjectLink AS ObjectLink_GoodsChild
                                    ON ObjectLink_GoodsChild.ObjectId = Object_ReceiptGoodsChild.Id
                                   AND ObjectLink_GoodsChild.DescId   = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()

          WHERE Object_ReceiptGoodsChild.DescId = zc_Object_ReceiptGoodsChild()
            AND Object_ReceiptGoodsChild.isErased = FALSE
       ;


   CREATE TEMP TABLE _tmpReceiptGoodsChild (Id Integer, NPP Integer, Comment TVarChar
                                          , ObjectId Integer, ReceiptLevelId Integer, MaterialOptionsId Integer, ProdColorPatternId Integer, GoodsChildId Integer
                                          , Value TFloat, Value_servise TFloat
                                          , ForCount TFloat
                                           ) ON COMMIT DROP;
    INSERT INTO _tmpReceiptGoodsChild (Id, NPP, Comment, ObjectId, ReceiptLevelId, MaterialOptionsId, ProdColorPatternId, GoodsChildId, Value, Value_servise, ForCount )
          SELECT Object_ReceiptGoodsChild.Id
               , ObjectFloat_NPP.ValueData      :: Integer AS NPP
               , Object_ReceiptGoodsChild.ValueData        AS Comment
               , ObjectLink_Object.ChildObjectId           AS ObjectId
               , ObjectLink_ReceiptLevel.ChildObjectId     AS ReceiptLevelId
               , ObjectLink_MaterialOptions.ChildObjectId  AS MaterialOptionsId
               , ObjectLink_ProdColorPattern.ChildObjectId AS ProdColorPatternId
               , ObjectLink_GoodsChild.ChildObjectId       AS GoodsChildId
               , CASE WHEN ObjectDesc.Id <> zc_Object_ReceiptService() THEN ObjectFloat_Value.ValueData ELSE 0 END AS Value
               , CASE WHEN ObjectDesc.Id =  zc_Object_ReceiptService() THEN ObjectFloat_Value.ValueData ELSE 0 END AS Value_servise
               , ObjectFloat_ForCount.ValueData AS ForCount
          FROM Object AS Object_ReceiptGoodsChild
               INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                     ON ObjectLink_ReceiptGoods.ObjectId = Object_ReceiptGoodsChild.Id
                                    AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                    AND ObjectLink_ReceiptGoods.ChildObjectId = inReceiptGoodsId

               -- NPP
               INNER JOIN ObjectFloat AS ObjectFloat_NPP
                                      ON ObjectFloat_NPP.ObjectId  = Object_ReceiptGoodsChild.Id
                                     AND ObjectFloat_NPP.DescId    = zc_ObjectFloat_ReceiptGoodsChild_NPP()
                                     AND ObjectFloat_NPP.ValueData > 0

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

               -- эту структуру отбросим позже
               LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                    ON ObjectLink_ProdColorPattern.ObjectId = Object_ReceiptGoodsChild.Id
                                   AND ObjectLink_ProdColorPattern.DescId = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()

               LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel
                                    ON ObjectLink_ReceiptLevel.ObjectId = Object_ReceiptGoodsChild.Id
                                   AND ObjectLink_ReceiptLevel.DescId   = zc_ObjectLink_ReceiptGoodsChild_ReceiptLevel()

               LEFT JOIN ObjectLink AS ObjectLink_GoodsChild
                                    ON ObjectLink_GoodsChild.ObjectId = Object_ReceiptGoodsChild.Id
                                   AND ObjectLink_GoodsChild.DescId   = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()

          WHERE Object_ReceiptGoodsChild.DescId  = zc_Object_ReceiptGoodsChild()
            AND Object_ReceiptGoodsChild.isErased = FALSE
       ;

        -- удаляем те NPP которых нет
        UPDATE Object SET isErased = TRUE
        WHERE Object.Id IN (SELECT _tmpReceiptGoodsChild.Id
                            FROM _tmpReceiptGoodsChild
                                 LEFT JOIN _tmpReceiptGoodsChild_mask ON _tmpReceiptGoodsChild_mask.NPP = _tmpReceiptGoodsChild.NPP
                            WHERE _tmpReceiptGoodsChild_mask.ObjectId IS NULL
                              -- без этой структуры
                              AND _tmpReceiptGoodsChild.ProdColorPatternId IS NULL
                           UNION
                            SELECT _tmpReceiptGoodsChild.Id
                            FROM _tmpReceiptGoodsChild
                                 -- если в новых данных есть такой NPP
                                 INNER JOIN _tmpReceiptGoodsChild_mask ON _tmpReceiptGoodsChild_mask.NPP = _tmpReceiptGoodsChild.NPP
                                                                      -- с такой структурой
                                                                      AND _tmpReceiptGoodsChild_mask.ProdColorPatternId > 0
                            -- без этой структуры
                            WHERE _tmpReceiptGoodsChild.ProdColorPatternId IS NULL
                           )
          AND Object.DescId = zc_Object_ReceiptGoodsChild()
       ;
        -- меняем только NPP + Value + ForCount для этой структуры
        PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ReceiptGoodsChild_NPP(),      _tmpReceiptGoodsChild.Id, _tmpReceiptGoodsChild_mask.NPP :: TFloat)
                --
              , lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ReceiptGoodsChild_Value(),    _tmpReceiptGoodsChild.Id, _tmpReceiptGoodsChild_mask.Value)
              , lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ReceiptGoodsChild_ForCount(), _tmpReceiptGoodsChild.Id, _tmpReceiptGoodsChild_mask.ForCount)
        FROM _tmpReceiptGoodsChild
             JOIN _tmpReceiptGoodsChild_mask ON _tmpReceiptGoodsChild_mask.ProdColorPatternId = _tmpReceiptGoodsChild.ProdColorPatternId
        WHERE _tmpReceiptGoodsChild.ProdColorPatternId > 0
       ;

        -- меняем ВСЕ
        PERFORM gpInsertUpdate_Object_ReceiptGoodsChild (ioId                 := COALESCE (_tmpReceiptGoodsChild.Id, 0)
                                                       , inComment            := COALESCE (_tmpReceiptGoodsChild_mask.Comment, '')
                                                       , inNPP                := _tmpReceiptGoodsChild_mask.NPP
                                                       , inReceiptGoodsId     := inReceiptGoodsId
                                                       , inObjectId           := _tmpReceiptGoodsChild_mask.ObjectId
                                                       , inProdColorPatternId := NULL
                                                       , inMaterialOptionsId  := _tmpReceiptGoodsChild_mask.MaterialOptionsId
                                                       , inReceiptLevelId_top := 0
                                                       , inReceiptLevelId     := _tmpReceiptGoodsChild_mask.ReceiptLevelId
                                                       , inGoodsChildId       := _tmpReceiptGoodsChild_find.GoodsChildId
                                                       , ioValue              := _tmpReceiptGoodsChild_mask.Value         :: TVarChar
                                                       , ioValue_service      := _tmpReceiptGoodsChild_mask.Value_servise :: TVarChar
                                                       , ioForCount           := _tmpReceiptGoodsChild_mask.ForCount
                                                       , inIsEnabled          := TRUE
                                                       , inSession            := inSession             ::TVarChar
                                                        ) AS Id
        FROM _tmpReceiptGoodsChild_mask
             LEFT JOIN _tmpReceiptGoodsChild ON _tmpReceiptGoodsChild.NPP                = _tmpReceiptGoodsChild_mask.NPP
                                            AND _tmpReceiptGoodsChild.ProdColorPatternId IS NULL
             -- находим LEVEL - child
             LEFT JOIN (SELECT MAX (_tmpReceiptGoodsChild.GoodsChildId) AS GoodsChildId FROM _tmpReceiptGoodsChild WHERE _tmpReceiptGoodsChild.GoodsChildId > 0
                       ) AS _tmpReceiptGoodsChild_find
                         ON -- только для тех где установлен LEVEL - child
                            _tmpReceiptGoodsChild_mask.GoodsChildId > 0
        -- без этой структуры
        WHERE _tmpReceiptGoodsChild_mask.ProdColorPatternId IS NULL
       ;



  /*RAISE EXCEPTION 'Ошибка.<%> '
       , (select count(*)
          FROM Object AS Object_ReceiptGoodsChild
               INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                     ON ObjectLink_ReceiptGoods.ObjectId = Object_ReceiptGoodsChild.Id
                                    AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                    AND ObjectLink_ReceiptGoods.ChildObjectId = inReceiptGoodsId

               -- NPP
               LEFT JOIN ObjectFloat AS ObjectFloat_NPP
                                     ON ObjectFloat_NPP.ObjectId  = Object_ReceiptGoodsChild.Id
                                    AND ObjectFloat_NPP.DescId    = zc_ObjectFloat_ReceiptGoodsChild_NPP()

               -- эту структуру отбросим позже
               LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                    ON ObjectLink_ProdColorPattern.ObjectId = Object_ReceiptGoodsChild.Id
                                   AND ObjectLink_ProdColorPattern.DescId = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()

          WHERE Object_ReceiptGoodsChild.DescId  = zc_Object_ReceiptGoodsChild()
            AND Object_ReceiptGoodsChild.isErased = FALSE
            AND ObjectLink_ProdColorPattern.ChildObjectId > 0
    );*/


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
06.04.23          *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_ReceiptGoodsChild_byReceiptGoods()
