-- Function: gpUpdate_Object_ReceiptProdModelChild_byReceiptGoods()

DROP FUNCTION IF EXISTS gpUpdate_Object_ReceiptProdModelChild_byReceiptGoods(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_ReceiptProdModelChild_byReceiptGoods(
 INOUT inReceiptProdModelId  Integer   ,    -- ключ объекта <>
    IN inReceiptGoodsId      Integer   ,    -- 
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

   CREATE TEMP TABLE _tmpReceiptGoodsChild (NPP Integer, Comment TVarChar
                                          , ObjectId Integer, ReceiptLevelId Integer
                                          , Value NUMERIC (16, 8), Value_servise NUMERIC (16, 8)
                                          , ForCount TFloat) ON COMMIT DROP;
    INSERT INTO _tmpReceiptGoodsChild (NPP, Comment, ObjectId, ReceiptLevelId, Value, Value_servise, ForCount )
          SELECT ROW_NUMBER() OVER (ORDER BY Object_ReceiptGoodsChild.Id ASC) :: Integer AS NPP
               , Object_ReceiptGoodsChild.ValueData      AS Comment
               , ObjectLink_Object.ChildObjectId         AS ObjectId
               , ObjectLink_ReceiptLevel.ChildObjectId   AS ReceiptLevelId
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

     -- элементы ReceiptProdModelChild
     CREATE TEMP TABLE _tmpReceiptProdModelChild ON COMMIT DROP AS
        SELECT Object_ReceiptProdModelChild.Id           AS Id
             , ObjectLink_Object.ChildObjectId           AS ObjectId
             , ObjectLink_ReceiptLevel.ChildObjectId     AS ReceiptLevelId
               -- значение
             , CASE WHEN ObjectDesc.Id <> zc_Object_ReceiptService() THEN ObjectFloat_Value.ValueData / CASE WHEN ObjectFloat_ForCount.ValueData > 1 THEN ObjectFloat_ForCount.ValueData ELSE 1 END ELSE 0 END :: NUMERIC (16, 8) AS Value
             , CASE WHEN ObjectDesc.Id =  zc_Object_ReceiptService() THEN ObjectFloat_Value.ValueData / CASE WHEN ObjectFloat_ForCount.ValueData > 1 THEN ObjectFloat_ForCount.ValueData ELSE 1 END ELSE 0 END :: NUMERIC (16, 8) AS Value_servise
             , COALESCE (ObjectFloat_ForCount.ValueData,0) AS ForCount
             , COALESCE (ObjectBoolean_Check.ValueData, FALSE) AS isCheck
        FROM Object AS Object_ReceiptProdModelChild

             INNER JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                   ON ObjectLink_ReceiptProdModel.ObjectId = Object_ReceiptProdModelChild.Id
                                  AND ObjectLink_ReceiptProdModel.DescId = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()
                                  AND ObjectLink_ReceiptProdModel.ChildObjectId = inReceiptProdModelId

             LEFT JOIN ObjectLink AS ObjectLink_Object
                                  ON ObjectLink_Object.ObjectId = Object_ReceiptProdModelChild.Id
                                 AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptProdModelChild_Object()
             LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_Object.ChildObjectId
             LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId

             -- нашли его в сборке узлов
             LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoods_Object
                                  ON ObjectLink_ReceiptGoods_Object.ChildObjectId = Object_ReceiptProdModelChild.Id
                                 AND ObjectLink_ReceiptGoods_Object.DescId        = zc_ObjectLink_ReceiptGoods_Object()
             -- из чего состоит
             LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoodsChild_ReceiptGoods
                                  ON ObjectLink_ReceiptGoodsChild_ReceiptGoods.ChildObjectId = ObjectLink_ReceiptGoods_Object.ObjectId
                                 AND ObjectLink_ReceiptGoodsChild_ReceiptGoods.DescId        = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
             -- без такой структуры
             LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                  ON ObjectLink_ProdColorPattern.ObjectId      = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                 AND ObjectLink_ProdColorPattern.DescId        = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()
             
             LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                   ON ObjectFloat_Value.ObjectId = Object_ReceiptProdModelChild.Id
                                  AND ObjectFloat_Value.DescId   = zc_ObjectFloat_ReceiptProdModelChild_Value()
             LEFT JOIN ObjectFloat AS ObjectFloat_ForCount
                                   ON ObjectFloat_ForCount.ObjectId = Object_ReceiptProdModelChild.Id
                                  AND ObjectFloat_ForCount.DescId   = zc_ObjectFloat_ReceiptProdModelChild_ForCount()
             LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel
                                  ON ObjectLink_ReceiptLevel.ObjectId = Object_ReceiptProdModelChild.Id
                                 AND ObjectLink_ReceiptLevel.DescId   = zc_ObjectLink_ReceiptProdModelChild_ReceiptLevel()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_Check
                                     ON ObjectBoolean_Check.ObjectId = Object_ReceiptProdModelChild.Id
                                    AND ObjectBoolean_Check.DescId   = zc_ObjectBoolean_Check()

        WHERE Object_ReceiptProdModelChild.DescId   = zc_Object_ReceiptProdModelChild()
          AND Object_ReceiptProdModelChild.isErased = FALSE
          AND ObjectLink_ProdColorPattern.ChildObjectId IS NULL
        ;


        UPDATE Object
         SET isErased = TRUE
        WHERE Object.Id IN (SELECT _tmpReceiptProdModelChild.Id 
                            FROM _tmpReceiptProdModelChild
                                 LEFT JOIN _tmpReceiptGoodsChild ON _tmpReceiptGoodsChild.ObjectId = _tmpReceiptProdModelChild.ObjectId
                            WHERE _tmpReceiptGoodsChild.ObjectId IS NULL
                            )
          AND Object.DescId   = zc_Object_ReceiptProdModelChild()
        ;
       

       PERFORM gpInsertUpdate_Object_ReceiptProdModelChild (ioId                 := COALESCE (_tmpReceiptProdModelChild.Id, 0)
                                                          , inComment            := Object.ValueData      ::TVarChar
                                                          , inReceiptProdModelId := inReceiptProdModelId  ::Integer
                                                          , inObjectId           := Object.Id             ::Integer
                                                          , inReceiptLevelId_top := 0                     ::Integer --COALESCE (_tmpReceiptGoodsChild.ReceiptLevelId, _tmpReceiptProdModelChild.ReceiptLevelId) ::Integer
                                                          , inReceiptLevelId     := COALESCE (_tmpReceiptGoodsChild.ReceiptLevelId, _tmpReceiptProdModelChild.ReceiptLevelId) ::Integer
                                                          , ioValue              := COALESCE (_tmpReceiptGoodsChild.Value, _tmpReceiptProdModelChild.Value)                   ::TVarChar
                                                          , ioValue_service      := COALESCE (_tmpReceiptGoodsChild.Value_servise, _tmpReceiptProdModelChild.Value_servise)   ::TVarChar
                                                          , ioForCount           := COALESCE (_tmpReceiptGoodsChild.ForCount, _tmpReceiptProdModelChild.ForCount)             ::TFloat
                                                          , ioIsCheck            := COALESCE (_tmpReceiptProdModelChild.isCheck, FALSE)                                       ::Boolean
                                                          , inSession            := inSession             ::TVarChar
                                                           )
       FROM  _tmpReceiptGoodsChild
            LEFT JOIN _tmpReceiptProdModelChild ON _tmpReceiptProdModelChild.ObjectId = _tmpReceiptGoodsChild.ObjectId
            LEFT JOIN Object ON Object.Id = COALESCE (_tmpReceiptGoodsChild.ObjectId, _tmpReceiptProdModelChild.ObjectId)
       Order by _tmpReceiptGoodsChild.Npp
       ; 
       

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
05.03.23          *               
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ReceiptProdModel()
