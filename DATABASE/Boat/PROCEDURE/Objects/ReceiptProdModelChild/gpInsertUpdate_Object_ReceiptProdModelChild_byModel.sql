-- Function: gpInsertUpdate_Object_ReceiptProdModelChild_byModel()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptProdModelChild_byModel(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReceiptProdModelChild_byModel(
 INOUT inReceiptProdModelId  Integer   ,    -- ключ объекта <>
    IN inModelId_mask        Integer   ,    -- модель из которой копируем узлы
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean; 
   DECLARE vbReceiptProdModelId_mask Integer;
           vbModelId Integer;
           vbModelName TVarChar;
           vbModelName_mask TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ReceiptProdModel());
   vbUserId:= lpGetUserBySession (inSession);

   --проверка
   IF COALESCE (inModelId_mask, 0) = 0
   THEN 
       RAISE EXCEPTION 'Ошибка.Не выбрана <Модель> для копирования';
   END IF;
   
    --находим ReceiptProdModel из которого нужно копировать
    SELECT ObjectLink_Model.ObjectId  AS ReceiptProdModelId 
         , Object.ValueData AS ModelName
   INTO vbReceiptProdModelId_mask, vbModelName_mask
    FROM ObjectLink AS ObjectLink_Model
         LEFT JOIN Object ON Object.Id = ObjectLink_Model.ChildObjectId
    WHERE ObjectLink_Model.ChildObjectId = inModelId_mask
      AND ObjectLink_Model.DescId = zc_ObjectLink_ReceiptProdModel_Model();

    --проверка
    IF COALESCE (vbReceiptProdModelId_mask, 0) = 0
    THEN 
        RAISE EXCEPTION 'Ошибка.Не найден <Шаблон сборки модели> для <%>', lfGet_Object_ValueData (inModelId_mask);
    END IF;

    --находим ProdModel текущего шаблона
    SELECT ObjectLink_Model.ChildObjectId AS ModelId
         , Object.ValueData     AS ModelName 
   INTO vbModelId, vbModelName        
    FROM ObjectLink AS ObjectLink_Model
         LEFT JOIN Object ON Object.Id = ObjectLink_Model.ChildObjectId
    WHERE ObjectLink_Model.ObjectId = inReceiptProdModelId
      AND ObjectLink_Model.DescId = zc_ObjectLink_ReceiptProdModel_Model();   


     -- элементы ReceiptProdModelChild  - текушего элемента, который нужно дополнить или обновить
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

    -- элементы ReceiptProdModelChild  - которыми нужно дополнить или обновить 
    CREATE TEMP TABLE _tmpReceiptProdModelChild_mask ON COMMIT DROP AS
       SELECT Object_ReceiptProdModelChild.Id           AS Id
            , ObjectLink_Object.ChildObjectId           AS ObjectId
            , Object_Object.ValueData                   AS ObjectName
            , ObjectLink_ReceiptLevel.ChildObjectId     AS ReceiptLevelId
              -- значение
            , CASE WHEN ObjectDesc.Id <> zc_Object_ReceiptService() THEN ObjectFloat_Value.ValueData / CASE WHEN ObjectFloat_ForCount.ValueData > 1 THEN ObjectFloat_ForCount.ValueData ELSE 1 END ELSE 0 END :: NUMERIC (16, 8) AS Value
            , CASE WHEN ObjectDesc.Id =  zc_Object_ReceiptService() THEN ObjectFloat_Value.ValueData / CASE WHEN ObjectFloat_ForCount.ValueData > 1 THEN ObjectFloat_ForCount.ValueData ELSE 1 END ELSE 0 END :: NUMERIC (16, 8) AS Value_servise
            , COALESCE (ObjectFloat_ForCount.ValueData,0) AS ForCount
            , COALESCE (ObjectBoolean_Check.ValueData, FALSE) AS isCheck  
            --
            , REPLACE (REPLACE (Object_Object.ValueData, vbModelName_mask, vbModelName), LEFT (vbModelName_mask,3), LEFT (vbModelName,3) ) ::TVarChar AS ObjectName_new --Название с учетом названия модели, по нему будем искать сущ. товар, или создавать новый
            , 0 AS ObjectId_new
       FROM Object AS Object_ReceiptProdModelChild
 
            INNER JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                  ON ObjectLink_ReceiptProdModel.ObjectId = Object_ReceiptProdModelChild.Id
                                 AND ObjectLink_ReceiptProdModel.DescId = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()
                                 AND ObjectLink_ReceiptProdModel.ChildObjectId = vbReceiptProdModelId_mask

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

       --пробуем найти существующие ObjectId 
       UPDATE _tmpReceiptProdModelChild_mask
       SET ObjectId_new = Object_Goods.Id
       FROM Object AS Object_Goods
       WHERE Object_Goods.ValueData ILIKE _tmpReceiptProdModelChild_mask.ObjectName_new
         AND Object_Goods.DescId = zc_Object_Goods();
       
       
       UPDATE _tmpReceiptProdModelChild_mask
       SET ObjectId_new = gpInsertUpdate_Object_Goods (ioId                     := 0
                                                     , inCode                   := 0
                                                     , inName                   := _tmpReceiptProdModelChild_mask.ObjectName_new
                                                     , inArticle                := REPLACE (REPLACE (ObjectString_Article.ValueData, vbModelName_mask, vbModelName), LEFT (vbModelName_mask,3), LEFT (vbModelName,3) ) ::TVarChar
                                                     , inArticleVergl           := ''
                                                     , inEAN                    := ''
                                                     , inASIN                   := ''
                                                     , inMatchCode              := ''
                                                     , inFeeNumber              := ObjectString_FeeNumber.ValueData
                                                     , inComment                := ObjectString_Comment.ValueData
                                                     , inIsArc                  := FALSE
                                                     , inFeet                   := ObjectFloat_Feet.ValueData
                                                     , inMetres                 := ObjectFloat_Metres.ValueData
                                                     , inAmountMin              := ObjectFloat_Min.ValueData
                                                     , inAmountRefer            := ObjectFloat_Refer.ValueData
                                                     , inEKPrice                := ObjectFloat_EKPrice.ValueData
                                                     , inEmpfPrice              := ObjectFloat_EmpfPrice.ValueData
                                                     , inGoodsGroupId           := ObjectLink_Goods_GoodsGroup.ChildObjectId
                                                     , inMeasureId              := ObjectLink_Goods_Measure.ChildObjectId
                                                     , inGoodsTagId             := ObjectLink_Goods_GoodsTag.ChildObjectId
                                                     , inGoodsTypeId            := ObjectLink_Goods_GoodsType.ChildObjectId
                                                     , inGoodsSizeId            := ObjectLink_Goods_GoodsSize.ChildObjectId
                                                     , inProdColorId            := ObjectLink_Goods_ProdColor.ChildObjectId
                                                     , inPartnerId              := ObjectLink_Goods_Partner.ChildObjectId
                                                     , inUnitId                 := ObjectLink_Goods_Unit.ChildObjectId
                                                     , inDiscountPartnerId      := ObjectLink_Goods_DiscountPartner.ChildObjectId
                                                     , inTaxKindId              := ObjectLink_Goods_TaxKind.ChildObjectId
                                                     , inEngineId               := NULL
                                                     , inPriceListId            := NULL
                                                     , inStartDate_price        := NULL
                                                     , inOperPriceList          := NULL  
                                                     , inSession                := inSession :: TVarChar
                                                      )
       FROM Object AS Object_Goods
                   LEFT JOIN ObjectString AS ObjectString_Article
                                          ON ObjectString_Article.ObjectId = Object_Goods.Id
                                         AND ObjectString_Article.DescId = zc_ObjectString_Article()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                        ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                        ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                        ON ObjectLink_Goods_GoodsTag.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsType
                                        ON ObjectLink_Goods_GoodsType.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_GoodsType.DescId   = zc_ObjectLink_Goods_GoodsType()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsSize
                                        ON ObjectLink_Goods_GoodsSize.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_GoodsSize.DescId = zc_ObjectLink_Goods_GoodsSize()

                   LEFT JOIN ObjectString AS ObjectString_Comment
                                          ON ObjectString_Comment.ObjectId = Object_Goods.Id
                                         AND ObjectString_Comment.DescId   = zc_ObjectString_Goods_Comment()
                   LEFT JOIN ObjectString AS ObjectString_FeeNumber
                                          ON ObjectString_FeeNumber.ObjectId = Object_Goods.Id
                                         AND ObjectString_FeeNumber.DescId   = zc_ObjectString_Goods_FeeNumber()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Partner
                                        ON ObjectLink_Goods_Partner.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_Partner.DescId = zc_ObjectLink_Goods_Partner()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Unit
                                        ON ObjectLink_Goods_Unit.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_Unit.DescId = zc_ObjectLink_Goods_Unit()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_DiscountPartner
                                        ON ObjectLink_Goods_DiscountPartner.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_DiscountPartner.DescId = zc_ObjectLink_Goods_DiscountPartner()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                                        ON ObjectLink_Goods_TaxKind.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_TaxKind.DescId = zc_ObjectLink_Goods_TaxKind()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                        ON ObjectLink_Goods_ProdColor.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()

                   LEFT JOIN ObjectFloat AS ObjectFloat_Min
                                         ON ObjectFloat_Min.ObjectId = Object_Goods.Id
                                        AND ObjectFloat_Min.DescId   = zc_ObjectFloat_Goods_Min()
                   LEFT JOIN ObjectFloat AS ObjectFloat_Refer
                                         ON ObjectFloat_Refer.ObjectId = Object_Goods.Id
                                        AND ObjectFloat_Refer.DescId   = zc_ObjectFloat_Goods_Refer()
                   LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                         ON ObjectFloat_EKPrice.ObjectId = Object_Goods.Id
                                        AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()
                   LEFT JOIN ObjectFloat AS ObjectFloat_EmpfPrice
                                         ON ObjectFloat_EmpfPrice.ObjectId = Object_Goods.Id
                                        AND ObjectFloat_EmpfPrice.DescId   = zc_ObjectFloat_Goods_EmpfPrice()

                   LEFT JOIN ObjectFloat AS ObjectFloat_Feet
                                         ON ObjectFloat_Feet.ObjectId = Object_Goods.Id
                                        AND ObjectFloat_Feet.DescId   = zc_ObjectFloat_Goods_Feet()
                   LEFT JOIN ObjectFloat AS ObjectFloat_Metres
                                         ON ObjectFloat_Metres.ObjectId = Object_Goods.Id
                                        AND ObjectFloat_Metres.DescId   = zc_ObjectFloat_Goods_Metres()

       WHERE COALESCE (_tmpReceiptProdModelChild_mask.ObjectId_new,0) = 0
         AND Object_Goods.DescId = zc_Object_Goods()
         AND Object_Goods.Id = _tmpReceiptProdModelChild_mask.ObjectId
       ;
       
       
      -- обновление добавление  ReceiptProdModelChild   связываем новые товары с уже сохраненными и обновляем или добавляем  данные
      
      
      
       /*
       UPDATE Object
        SET isErased = TRUE
       WHERE Object.Id IN (SELECT _tmpReceiptProdModelChild.Id 
                           FROM _tmpReceiptProdModelChild
                                LEFT JOIN _tmpReceiptGoodsChild ON _tmpReceiptGoodsChild.ObjectId = _tmpReceiptProdModelChild.ObjectId
                           WHERE _tmpReceiptGoodsChild.ObjectId IS NULL
                           )
         AND Object.DescId   = zc_Object_ReceiptProdModelChild()
       ;*/
      

      PERFORM gpInsertUpdate_Object_ReceiptProdModelChild (ioId                 := COALESCE (_tmpReceiptProdModelChild.Id, 0)     ::Integer
                                                         , inComment            := _tmpReceiptProdModelChild_mask.ObjectName_new  ::TVarChar
                                                         , inReceiptProdModelId := inReceiptProdModelId                           ::Integer
                                                         , inObjectId           := _tmpReceiptProdModelChild_mask.ObjectId_new    ::Integer
                                                         , inReceiptLevelId_top := 0                                              ::Integer
                                                         , inReceiptLevelId     := COALESCE (_tmpReceiptProdModelChild_mask.ReceiptLevelId, _tmpReceiptProdModelChild.ReceiptLevelId) ::Integer
                                                         , ioValue              := COALESCE (_tmpReceiptProdModelChild_mask.Value, _tmpReceiptProdModelChild.Value)                   ::TVarChar
                                                         , ioValue_service      := COALESCE (_tmpReceiptProdModelChild_mask.Value_servise, _tmpReceiptProdModelChild.Value_servise)   ::TVarChar
                                                         , ioForCount           := COALESCE (_tmpReceiptProdModelChild_mask.ForCount, _tmpReceiptProdModelChild.ForCount)             ::TFloat
                                                         , ioIsCheck            := COALESCE (_tmpReceiptProdModelChild.isCheck, _tmpReceiptProdModelChild.isCheck, FALSE)             ::Boolean
                                                         , inSession            := inSession             ::TVarChar
                                                          )
      FROM  _tmpReceiptProdModelChild_mask
          LEFT JOIN _tmpReceiptProdModelChild ON _tmpReceiptProdModelChild.ObjectId = _tmpReceiptProdModelChild_mask.ObjectId_new
      ; 

    /*  RAISE EXCEPTION 'Test. <%> ', (SELECT COUNT(*)
                                     FROM  _tmpReceiptProdModelChild_mask
                                         LEFT JOIN _tmpReceiptProdModelChild ON _tmpReceiptProdModelChild.ObjectId = _tmpReceiptProdModelChild_mask.ObjectId_new
                                     WHERE _tmpReceiptProdModelChild.Id IS NULL
                                     );   
    */    

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
06.01.26          *               
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ReceiptProdModelChild_byModel()
