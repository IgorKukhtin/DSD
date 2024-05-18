-- Function: gpUpdate_Object_ReceiptGoodsChild_byReceiptGoods()

DROP FUNCTION IF EXISTS gpUpdate_Object_ReceiptGoodsChild_byReceiptGoods (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_ReceiptGoodsChild_byReceiptGoods (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_ReceiptGoodsChild_byReceiptGoods(
 INOUT inReceiptGoodsId      Integer   ,    -- ключ объекта <>
    IN inReceiptGoodsId_mask Integer   ,    --
    IN inGoodsChildId_mask   Integer   ,    --
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

   -- Откуда переносим
   CREATE TEMP TABLE _tmpReceiptGoodsChild_mask (Id Integer, NPP Integer, Comment TVarChar
                                               , ObjectId Integer, ReceiptLevelId Integer, MaterialOptionsId Integer, ProdColorPatternId Integer, GoodsChildId Integer
                                               , Value TFloat, Value_service TFloat
                                               , ForCount TFloat
                                                ) ON COMMIT DROP;
    INSERT INTO _tmpReceiptGoodsChild_mask (Id, NPP, Comment, ObjectId, ReceiptLevelId, MaterialOptionsId, ProdColorPatternId, GoodsChildId, Value, Value_service, ForCount)
      WITH tmpData_all AS (SELECT Object_ReceiptGoodsChild.Id               AS Id
                                , COALESCE (ObjectFloat_NPP.ValueData, 0)   AS NPP
                                , Object_ReceiptGoodsChild.ValueData        AS Comment
                                , ObjectLink_Object.ChildObjectId           AS ObjectId
                                , ObjectLink_ReceiptLevel.ChildObjectId     AS ReceiptLevelId
                                , ObjectLink_MaterialOptions.ChildObjectId  AS MaterialOptionsId
                                , COALESCE (ObjectLink_ProdColorPattern.ChildObjectId, 0) AS ProdColorPatternId
                                , CASE WHEN ObjectLink_GoodsChild.ChildObjectId > 0 THEN inGoodsChildId_mask ELSE 0 END AS GoodsChildId
                                , CASE WHEN ObjectDesc.Id <> zc_Object_ReceiptService() THEN ObjectFloat_Value.ValueData ELSE 0 END AS Value
                                , CASE WHEN ObjectDesc.Id =  zc_Object_ReceiptService() THEN ObjectFloat_Value.ValueData ELSE 0 END AS Value_service
                                , ObjectFloat_ForCount.ValueData AS ForCount
                           FROM Object AS Object_ReceiptGoodsChild
                                INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                                      ON ObjectLink_ReceiptGoods.ObjectId = Object_ReceiptGoodsChild.Id
                                                     AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                                     -- Откуда переносим
                                                     AND ObjectLink_ReceiptGoods.ChildObjectId = inReceiptGoodsId_mask
                 
                                LEFT JOIN ObjectLink AS ObjectLink_Object
                                                     ON ObjectLink_Object.ObjectId = Object_ReceiptGoodsChild.Id
                                                    AND ObjectLink_Object.DescId = zc_ObjectLink_ReceiptGoodsChild_Object()
                                LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_Object.ChildObjectId
                                LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId
                 
                                LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                                     ON ObjectLink_MaterialOptions.ObjectId = Object_ReceiptGoodsChild.Id
                                                    AND ObjectLink_MaterialOptions.DescId   = zc_ObjectLink_ReceiptGoodsChild_MaterialOptions()
                 
                                -- NPP из Excel
                                LEFT JOIN ObjectFloat AS ObjectFloat_NPP
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
                          )
      , tmpData_sum AS (SELECT MAX (tmpData_all.Id)              AS Id
                             , MAX (tmpData_all.NPP)             AS NPP
                             , MAX (tmpData_all.Comment)         AS Comment
                             , tmpData_all.ObjectId              AS ObjectId
                             , MAX (tmpData_all.ReceiptLevelId)  AS ReceiptLevelId
                             , tmpData_all.MaterialOptionsId     AS MaterialOptionsId
                             , tmpData_all.ProdColorPatternId    AS ProdColorPatternId
                             , tmpData_all.GoodsChildId          AS GoodsChildId
                             , SUM (tmpData_all.Value)           AS Value
                             , SUM (tmpData_all.Value_service)   AS Value_service
                             , MAX (tmpData_all.ForCount)        AS ForCount
                        FROM tmpData_all
                        GROUP BY tmpData_all.ObjectId
                               , tmpData_all.MaterialOptionsId
                               , tmpData_all.ProdColorPatternId
                               , tmpData_all.GoodsChildId
                       )
          --
          SELECT tmpData_sum.Id
               , tmpData_sum.NPP
               , tmpData_sum.Comment
               , tmpData_sum.ObjectId
               , tmpData_sum.ReceiptLevelId
               , tmpData_sum.MaterialOptionsId
               , tmpData_sum.ProdColorPatternId
               , tmpData_sum.GoodsChildId
               , tmpData_sum.Value
               , tmpData_sum.Value_service
               , tmpData_sum.ForCount
          FROM tmpData_sum
          WHERE tmpData_sum.NPP > 0
         UNION ALL
          SELECT tmpData_sum.Id
                 -- сквозная для всех, перенумеруем с последнего + 1
               , ROW_NUMBER() OVER (ORDER BY tmpData_sum.Id ASC) + COALESCE ((SELECT MAX (tmpData_sum.NPP) FROM tmpData_sum), 0) AS NPP
               , tmpData_sum.Comment
               , tmpData_sum.ObjectId
               , tmpData_sum.ReceiptLevelId
               , tmpData_sum.MaterialOptionsId
               , tmpData_sum.ProdColorPatternId
               , tmpData_sum.GoodsChildId
               , tmpData_sum.Value
               , tmpData_sum.Value_service
               , tmpData_sum.ForCount
          FROM tmpData_sum
          WHERE tmpData_sum.NPP = 0
         ;

   -- Куда переносим
   CREATE TEMP TABLE _tmpReceiptGoodsChild (Id Integer, NPP Integer, Comment TVarChar
                                          , ObjectId Integer, ReceiptLevelId Integer, MaterialOptionsId Integer, ProdColorPatternId Integer, GoodsChildId Integer
                                          , Value TFloat, Value_service TFloat
                                          , ForCount TFloat
                                           ) ON COMMIT DROP;
    INSERT INTO _tmpReceiptGoodsChild (Id, NPP, Comment, ObjectId, ReceiptLevelId, MaterialOptionsId, ProdColorPatternId, GoodsChildId, Value, Value_service, ForCount)
      WITH tmpData_all AS (SELECT Object_ReceiptGoodsChild.Id               AS Id
                                , COALESCE (ObjectFloat_NPP.ValueData, 0)   AS NPP
                                , Object_ReceiptGoodsChild.ValueData        AS Comment
                                , ObjectLink_Object.ChildObjectId           AS ObjectId
                                , ObjectLink_ReceiptLevel.ChildObjectId     AS ReceiptLevelId
                                , ObjectLink_MaterialOptions.ChildObjectId  AS MaterialOptionsId
                                , COALESCE (ObjectLink_ProdColorPattern.ChildObjectId, 0) AS ProdColorPatternId
                                  -- замена на новый GoodsChildId
                                , CASE WHEN ObjectLink_GoodsChild.ChildObjectId > 0 THEN inGoodsChildId_mask ELSE 0 END AS GoodsChildId
                                  --
                                , CASE WHEN ObjectDesc.Id <> zc_Object_ReceiptService() THEN ObjectFloat_Value.ValueData ELSE 0 END AS Value
                                , CASE WHEN ObjectDesc.Id =  zc_Object_ReceiptService() THEN ObjectFloat_Value.ValueData ELSE 0 END AS Value_service
                                , ObjectFloat_ForCount.ValueData AS ForCount
                           FROM Object AS Object_ReceiptGoodsChild
                                INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                                      ON ObjectLink_ReceiptGoods.ObjectId = Object_ReceiptGoodsChild.Id
                                                     AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                                     -- Куда переносим
                                                     AND ObjectLink_ReceiptGoods.ChildObjectId = inReceiptGoodsId
                 
                                LEFT JOIN ObjectLink AS ObjectLink_Object
                                                     ON ObjectLink_Object.ObjectId = Object_ReceiptGoodsChild.Id
                                                    AND ObjectLink_Object.DescId = zc_ObjectLink_ReceiptGoodsChild_Object()
                                LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_Object.ChildObjectId
                                LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId
                 
                                LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                                     ON ObjectLink_MaterialOptions.ObjectId = Object_ReceiptGoodsChild.Id
                                                    AND ObjectLink_MaterialOptions.DescId   = zc_ObjectLink_ReceiptGoodsChild_MaterialOptions()
                 
                                -- NPP из Excel
                                LEFT JOIN ObjectFloat AS ObjectFloat_NPP
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
                          )
      , tmpData_sum AS (SELECT MAX (tmpData_all.Id)              AS Id
                             , MAX (tmpData_all.NPP)             AS NPP
                             , MAX (tmpData_all.Comment)         AS Comment
                             , tmpData_all.ObjectId              AS ObjectId
                             , MAX (tmpData_all.ReceiptLevelId)  AS ReceiptLevelId
                             , tmpData_all.MaterialOptionsId     AS MaterialOptionsId
                             , tmpData_all.ProdColorPatternId    AS ProdColorPatternId
                             , tmpData_all.GoodsChildId          AS GoodsChildId
                             , SUM (tmpData_all.Value)           AS Value
                             , SUM (tmpData_all.Value_service)   AS Value_service
                             , MAX (tmpData_all.ForCount)        AS ForCount
                        FROM tmpData_all
                        GROUP BY tmpData_all.ObjectId
                               , tmpData_all.MaterialOptionsId
                               , tmpData_all.ProdColorPatternId
                               , tmpData_all.GoodsChildId
                       )
          --
          SELECT tmpData_sum.Id
               , tmpData_sum.NPP
               , tmpData_sum.Comment
               , tmpData_sum.ObjectId
               , tmpData_sum.ReceiptLevelId
               , tmpData_sum.MaterialOptionsId
               , tmpData_sum.ProdColorPatternId
               , tmpData_sum.GoodsChildId
               , tmpData_sum.Value
               , tmpData_sum.Value_service
               , tmpData_sum.ForCount
          FROM tmpData_sum
          WHERE tmpData_sum.NPP > 0
         UNION ALL
          SELECT tmpData_sum.Id
                 -- сквозная для всех, перенумеруем с последнего + 1
               , ROW_NUMBER() OVER (ORDER BY tmpData_sum.Id ASC) + COALESCE ((SELECT MAX (tmpData_sum.NPP) FROM tmpData_sum), 0) AS NPP
               , tmpData_sum.Comment
               , tmpData_sum.ObjectId
               , tmpData_sum.ReceiptLevelId
               , tmpData_sum.MaterialOptionsId
               , tmpData_sum.ProdColorPatternId
               , tmpData_sum.GoodsChildId
               , tmpData_sum.Value
               , tmpData_sum.Value_service
               , tmpData_sum.ForCount
          FROM tmpData_sum
          WHERE tmpData_sum.NPP = 0
       ;

        -- удаляем те NPP которых нет
        UPDATE Object SET isErased = TRUE
        WHERE Object.Id IN (SELECT _tmpReceiptGoodsChild.Id
                            FROM _tmpReceiptGoodsChild
                                 LEFT JOIN _tmpReceiptGoodsChild_mask ON _tmpReceiptGoodsChild_mask.NPP = _tmpReceiptGoodsChild.NPP
                            WHERE _tmpReceiptGoodsChild_mask.ObjectId IS NULL
                              -- без этой структуры
                              AND _tmpReceiptGoodsChild.ProdColorPatternId = 0
                           UNION
                            SELECT _tmpReceiptGoodsChild.Id
                            FROM _tmpReceiptGoodsChild
                                 -- если в новых данных есть такой NPP
                                 INNER JOIN _tmpReceiptGoodsChild_mask ON _tmpReceiptGoodsChild_mask.NPP = _tmpReceiptGoodsChild.NPP
                                                                      -- с такой структурой
                                                                      AND _tmpReceiptGoodsChild_mask.ProdColorPatternId > 0
                            -- без этой структуры
                            WHERE _tmpReceiptGoodsChild.ProdColorPatternId = 0
                           )
          AND Object.DescId = zc_Object_ReceiptGoodsChild()
       ;

        -- меняем только NPP + Value + ForCount для этой структуры
        PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ReceiptGoodsChild_NPP(),      _tmpReceiptGoodsChild.Id, _tmpReceiptGoodsChild_mask.NPP :: TFloat)
                --
              , lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ReceiptGoodsChild_Value(),    _tmpReceiptGoodsChild.Id, _tmpReceiptGoodsChild_mask.Value)
              , lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ReceiptGoodsChild_ForCount(), _tmpReceiptGoodsChild.Id, _tmpReceiptGoodsChild_mask.ForCount)
                --
              , lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptGoodsChild_GoodsChild(), _tmpReceiptGoodsChild.Id, _tmpReceiptGoodsChild_mask.GoodsChildId)
        FROM _tmpReceiptGoodsChild
             -- одинаковый товар
             JOIN _tmpReceiptGoodsChild_mask ON _tmpReceiptGoodsChild_mask.ObjectId = _tmpReceiptGoodsChild.ObjectId
             -- нашли ProdColorGroup
             INNER JOIN ObjectLink AS ObjectLink_ProdColorGroup_mask
                                   ON ObjectLink_ProdColorGroup_mask.ObjectId = _tmpReceiptGoodsChild_mask.ProdColorPatternId
                                  AND ObjectLink_ProdColorGroup_mask.DescId   = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
             -- нашли ProdColorGroup
             INNER JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                   ON ObjectLink_ProdColorGroup.ObjectId = _tmpReceiptGoodsChild.ProdColorPatternId
                                  AND ObjectLink_ProdColorGroup.DescId   = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
        -- одинаковая структура - ProdColorGroup
        WHERE ObjectLink_ProdColorGroup_mask.ChildObjectId = ObjectLink_ProdColorGroup.ChildObjectId
       ;


        -- Проверка
        IF EXISTS (SELECT 1
                   FROM _tmpReceiptGoodsChild_mask
                        JOIN _tmpReceiptGoodsChild ON _tmpReceiptGoodsChild.ObjectId = _tmpReceiptGoodsChild_mask.ObjectId
                   WHERE COALESCE (_tmpReceiptGoodsChild_mask.GoodsChildId, 0) <> COALESCE (_tmpReceiptGoodsChild.GoodsChildId, 0)
                     AND _tmpReceiptGoodsChild.ProdColorPatternId = 0
                  )
        THEN
            RAISE EXCEPTION 'Ошибка.Для <%> %было значение для сборка Узел-1 = <%>.%Новое значение = <%>.(%)'
                , (SELECT lfGet_Object_ValueData_article (_tmpReceiptGoodsChild_mask.ObjectId)
                   FROM _tmpReceiptGoodsChild_mask
                        JOIN _tmpReceiptGoodsChild ON _tmpReceiptGoodsChild.ObjectId = _tmpReceiptGoodsChild_mask.ObjectId
                   WHERE COALESCE (_tmpReceiptGoodsChild_mask.GoodsChildId, 0) <> COALESCE (_tmpReceiptGoodsChild.GoodsChildId, 0)
                   ORDER BY _tmpReceiptGoodsChild_mask.ObjectId
                   LIMIT 1
                  )
                , CHR (13)
                , (SELECT lfGet_Object_ValueData_article (_tmpReceiptGoodsChild.GoodsChildId)
                   FROM _tmpReceiptGoodsChild_mask
                        JOIN _tmpReceiptGoodsChild ON _tmpReceiptGoodsChild.ObjectId = _tmpReceiptGoodsChild_mask.ObjectId
                   WHERE COALESCE (_tmpReceiptGoodsChild_mask.GoodsChildId, 0) <> COALESCE (_tmpReceiptGoodsChild.GoodsChildId, 0)
                   ORDER BY _tmpReceiptGoodsChild_mask.ObjectId
                   LIMIT 1
                  )
                , CHR (13)
                , (SELECT lfGet_Object_ValueData_article (_tmpReceiptGoodsChild_mask.GoodsChildId)
                   FROM _tmpReceiptGoodsChild_mask
                        JOIN _tmpReceiptGoodsChild ON _tmpReceiptGoodsChild.ObjectId = _tmpReceiptGoodsChild_mask.ObjectId
                   WHERE COALESCE (_tmpReceiptGoodsChild_mask.GoodsChildId, 0) <> COALESCE (_tmpReceiptGoodsChild.GoodsChildId, 0)
                   ORDER BY _tmpReceiptGoodsChild_mask.ObjectId
                   LIMIT 1
                  )
                , (SELECT _tmpReceiptGoodsChild_mask.Id
                   FROM _tmpReceiptGoodsChild_mask
                        JOIN _tmpReceiptGoodsChild ON _tmpReceiptGoodsChild.ObjectId = _tmpReceiptGoodsChild_mask.ObjectId
                   WHERE COALESCE (_tmpReceiptGoodsChild_mask.GoodsChildId, 0) <> COALESCE (_tmpReceiptGoodsChild.GoodsChildId, 0)
                   ORDER BY _tmpReceiptGoodsChild_mask.ObjectId
                   LIMIT 1
                  )
                 ;
        END IF;

        -- меняем ВСЕ
        PERFORM gpInsertUpdate_Object_ReceiptGoodsChild (ioId                 := COALESCE (_tmpReceiptGoodsChild.Id, 0)
                                                       , inComment            := COALESCE (_tmpReceiptGoodsChild_mask.Comment, '')
                                                       , inNPP                := _tmpReceiptGoodsChild_mask.NPP
                                                       , inNPP_service        := 0
                                                       , inReceiptGoodsId     := inReceiptGoodsId
                                                       , inObjectId           := _tmpReceiptGoodsChild_mask.ObjectId
                                                       , inProdColorPatternId := NULL
                                                       , inMaterialOptionsId  := _tmpReceiptGoodsChild_mask.MaterialOptionsId
                                                       , inReceiptLevelId_top := 0
                                                       , inReceiptLevelId     := _tmpReceiptGoodsChild_mask.ReceiptLevelId
                                                       , inGoodsChildId       := _tmpReceiptGoodsChild_mask.GoodsChildId
                                                       , inGoodsChildId_top   := NULL
                                                       , ioValue              := _tmpReceiptGoodsChild_mask.Value         :: TVarChar
                                                       , ioValue_service      := _tmpReceiptGoodsChild_mask.Value_service :: TVarChar
                                                       , ioForCount           := _tmpReceiptGoodsChild_mask.ForCount
                                                       , inIsEnabled          := TRUE
                                                       , inSession            := inSession             ::TVarChar
                                                        ) AS Id
        FROM _tmpReceiptGoodsChild_mask
             LEFT JOIN _tmpReceiptGoodsChild ON _tmpReceiptGoodsChild.NPP                = _tmpReceiptGoodsChild_mask.NPP
                                            -- без этой структуры
                                            AND _tmpReceiptGoodsChild.ProdColorPatternId = 0
        -- без этой структуры
        WHERE _tmpReceiptGoodsChild_mask.ProdColorPatternId = 0
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
