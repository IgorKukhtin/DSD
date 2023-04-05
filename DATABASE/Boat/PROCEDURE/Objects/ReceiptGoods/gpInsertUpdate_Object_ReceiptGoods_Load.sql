--

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoods_Load (INTEGER, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReceiptGoods_Load(
    IN inRecNum                INTEGER ,  -- Строка загрузки
    IN inArticle               TVarChar,  -- Артикул-результат
    IN inReceiptLevelName      TVarChar,  -- Название сборки
    IN inGoodsName             TVarChar,  -- Название-результат
    IN inGroupName             TVarChar,  -- Группа-результат
    IN inReplacement           TVarChar,  -- Замена
    IN inArticle_child         TVarChar,  -- Артикул-комплект/узел
    IN inGoodsName_child       TVarChar,  -- Название-комплект/узел
    IN inGroupName_child       TVarChar,  -- Группа-комплект/узел
    IN inAmount                TVarChar,  -- Количество
    IN inSession               TVarChar   -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsGroupId Integer;
   DECLARE vbGoodsGroupId_child Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbGoodsId_child Integer;
   DECLARE vbReceiptGoodsId Integer;
   DECLARE vbReceiptGoodsChildId Integer;
   DECLARE vbAmount NUMERIC (16, 8);
   DECLARE vbForCount TFloat;
   
   DECLARE vbStage boolean; -- Сборка второго уровня
   DECLARE vbNotRename boolean; -- Не переименовывать
   DECLARE vbReceiptProdModel boolean; -- Сборка лодки
   
   DECLARE vbColorPatternId Integer;
   DECLARE vbModelId Integer;
   
   DECLARE vbReceiptLevelId Integer;
   DECLARE vbProdColorPatternId Integer;
   DECLARE vbMaterialOptionsId Integer;
   
   DECLARE vbReceiptProdModelId Integer;
   DECLARE vbReceiptProdModelChildId Integer;

   DECLARE vbArticle_GoodsChild     TVarChar;  -- Артикул-результат
   DECLARE vbGoods_GoodsChildName   TVarChar;  -- Название-результат
   DECLARE vbGroup_GoodsChildName   TVarChar;  -- Группа-результат
   DECLARE vbGoods_GoodsChildId Integer;
   DECLARE vbGroup_GoodsChildId Integer;
   
   DECLARE vbProdColorName TVarChar;
   DECLARE vbProdColor_ChildId Integer; 
   DECLARE vbProdColorId Integer; 
      
   DECLARE text_var1 Text;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);
   
   --
   IF inReceiptLevelName ILIKE 'Streeting console'
   THEN
       inReceiptLevelName:= 'Steering console';
   END IF;

   --
   IF COALESCE (TRIM (inGoodsName_child), '') = '' OR
      upper(TRIM(SPLIT_PART (inArticle, '-', 3))) NOT IN ('01', '02', '03', '*ICE WHITE', 'BEL', 'BASIS') THEN RETURN; END IF;
      
   IF upper(TRIM(SPLIT_PART (inArticle_child, '-', 3))) = '02' AND upper(TRIM(SPLIT_PART (inArticle_child, '-', 4))) = 'ПФ' THEN RETURN; END IF;
      
   -- Преобразуем количество
   IF inAmount = '' OR inAmount = '0'
   THEN
     vbAmount := 0;
   ELSE
     vbAmount := zfConvert_CheckStringToFloat (inAmount);
     -- если надо добавить разряд
     IF vbAmount <> vbAmount :: TFloat
     THEN
         vbForCount:= 1000;
         vbAmount:= vbAmount * 1000;
     ELSE
         vbForCount:= 1;
     END IF;
     --
     IF vbAmount <= 0
     THEN
       RAISE EXCEPTION 'Ошибка преобразования в число <%>.', inAmount;        
     END IF;
   END IF;
     
   -- Заменяем А 
   inGoodsName := REPLACE(inGoodsName, chr(1040)||'GL-', 'AGL-');
   inGoodsName_child := REPLACE(inGoodsName_child, chr(1040)||'GL-', 'AGL-');
   IF POSITION('AGL ' IN inArticle_child) = 1 THEN inArticle_child := REPLACE(inArticle_child, 'AGL ', 'AGL'); END IF;
   vbStage := False;
   vbNotRename := False;
   vbReceiptProdModel := False;
   
   -- Ищем Шаблон Boat Structure
   SELECT Object_ColorPattern.Id, ObjectLink_Model.ChildObjectId
   INTO vbColorPatternId, vbModelId
   FROM Object AS Object_ColorPattern                                 
        LEFT JOIN ObjectLink AS ObjectLink_Model
                             ON ObjectLink_Model.ObjectId = Object_ColorPattern.Id
                            AND ObjectLink_Model.DescId = zc_ObjectLink_ColorPattern_Model()
   WHERE Object_ColorPattern.DescId = zc_Object_ColorPattern()
     AND Object_ColorPattern.isErased = FALSE    
     AND Object_ColorPattern.ValueData ILIKE 'Agilis-'||TRIM(SPLIT_PART (inArticle, '-', 2))||'%';
     
   IF COALESCE (vbColorPatternId, 0) = 0
   THEN
     RAISE EXCEPTION 'Ошибка Шаблон Boat Structure <%> не найден.', 'Agilis-'||TRIM(SPLIT_PART (inArticle, '-', 2));        
   END IF;

   -- Если первая строка загрузки удаляем все содержимое сборки модели
   IF inRecNum = 1
   THEN
      -- поиск Шаблон сборка Модели
     vbReceiptProdModelId := (SELECT Object.Id FROM Object 
                              WHERE Object.DescId = zc_Object_ReceiptProdModel() 
                                AND Object.ValueData ILIKE '%'||SPLIT_PART (inArticle, '-', 2)||'-base%'
                                AND Object.isErased = False);
                                
     IF COALESCE (vbReceiptProdModelId, 0) = 0
     THEN
       RAISE EXCEPTION 'Ошибка Шаблон сборка Модели <%> не найден.', 'Agilis-'||TRIM(SPLIT_PART (inArticle, '-', 2));        
     END IF;
     
     PERFORM gpUpdate_Object_isErased_ReceiptProdModelChild(inObjectId := Object_ReceiptProdModelChild.Id
                                                          , inIsErased := TRUE
                                                          , inSession  := inSession)
     FROM Object AS Object_ReceiptProdModelChild
          -- шаблон ProdModel
          INNER JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                ON ObjectLink_ReceiptProdModel.ObjectId = Object_ReceiptProdModelChild.Id
                               AND ObjectLink_ReceiptProdModel.DescId   = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()
                               AND ObjectLink_ReceiptProdModel.ChildObjectId = vbReceiptProdModelId
     WHERE Object_ReceiptProdModelChild.DescId   = zc_Object_ReceiptProdModelChild()
       AND Object_ReceiptProdModelChild.isErased = FALSE;
   
   END IF;        
   
   -- Дефаултный цвет   
   vbProdColorName := 'RAL 9010';

   -- ********* Обработка артикула *********
   
   IF SPLIT_PART (inArticle, '-', 3) = '01' -- Сборка крпуса
   THEN
              
     -- Узел 2 уровня   
     IF LOWER(SPLIT_PART (inArticle, '-', 4)) = 'пф'
     THEN

       vbArticle_GoodsChild := inArticle;
       vbGoods_GoodsChildName := 'ПФ Корпус стеклопластиковый '||SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2)||'-'||vbProdColorName;
       vbGroup_GoodsChildName := 'Boote'; --inGroupName;
       vbStage := True;
     END IF;
     
     -- Комплектующее узла
     inGroupName_child := 'Boote';
     
     -- Если есть замена комплектующей то определяем параметры
     IF inReplacement ILIKE 'ДА'
     THEN
       vbProdColorId := (SELECT MAX(Object_ProdColor.Id) FROM Object AS Object_ProdColor 
                         WHERE Object_ProdColor.DescId = zc_Object_ProdColor() AND Object_ProdColor.ValueData ILIKE vbProdColorName);

       SELECT ProdColorPattern.Id
            , ObjectLink_MaterialOptions.ChildObjectId 
       INTO vbProdColorPatternId, vbMaterialOptionsId
       FROM gpSelect_Object_ProdColorPattern(inColorPatternId:= vbColorPatternId, inIsErased:= FALSE, inIsShowAll := FALSE, inSession := inSession) AS ProdColorPattern
             LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                  ON ObjectLink_MaterialOptions.ObjectId = ProdColorPattern.prodoptionsid
                                 AND ObjectLink_MaterialOptions.DescId = zc_ObjectLink_ProdOptions_MaterialOptions()
      WHERE ProdColorPattern.ModelId = vbModelId
         AND ProdColorPattern.ProdColorGroupName ILIKE CASE WHEN inReceiptLevelName ILIKE 'Steering console' 
                                                            THEN 'Fiberglass '   || TRIM(SPLIT_PART (COALESCE(NULLIF(SPLIT_PART (inReceiptLevelName, '-', 2), ''), inReceiptLevelName), '/', 1))
                                                            ELSE 'Fiberglass - ' || TRIM(SPLIT_PART (COALESCE(NULLIF(SPLIT_PART (inReceiptLevelName, '-', 2), ''), inReceiptLevelName), '/', 1))
                                                       END;

     END IF;

     -- Узел основной
     inGoodsName := 'Корпус '||SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2)||'-'||vbProdColorName;
     inGroupName := 'Boote'; --'Сборка корпуса';    
     inArticle := SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2)||'-'||SPLIT_PART (inArticle, '-', 3);

   ELSEIF SPLIT_PART (inArticle, '-', 3) = '02' -- Сборка сиденья
   THEN

     -- Узел 2 уровня   
     IF LOWER(SPLIT_PART (inArticle, '-', 4)) = 'пф'
     THEN
       vbArticle_GoodsChild := inArticle;
       vbGoods_GoodsChildName := 'ПФ Сиденье водителя '||SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2)||'-'||vbProdColorName;
       vbGroup_GoodsChildName := 'Boote'; --inGroupName;
       vbStage := True;
     END IF;
     
     -- Комплектующее узла
     inGroupName_child := 'Boote';
     
     -- Если есть замена комплектующей то определяем параметры
     IF inReplacement ILIKE 'ДА' AND LOWER(SPLIT_PART (inArticle, '-', 4)) = 'пф'
     THEN
       vbProdColorId := (SELECT MAX(Object_ProdColor.Id) FROM Object AS Object_ProdColor 
                         WHERE Object_ProdColor.DescId = zc_Object_ProdColor() AND Object_ProdColor.ValueData ILIKE vbProdColorName);

       SELECT ProdColorPattern.Id
            , ObjectLink_MaterialOptions.ChildObjectId 
       INTO vbProdColorPatternId, vbMaterialOptionsId
       FROM gpSelect_Object_ProdColorPattern(inColorPatternId:= vbColorPatternId, inIsErased:= FALSE, inIsShowAll := FALSE, inSession := inSession) AS ProdColorPattern
             LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                  ON ObjectLink_MaterialOptions.ObjectId = ProdColorPattern.prodoptionsid
                                 AND ObjectLink_MaterialOptions.DescId = zc_ObjectLink_ProdOptions_MaterialOptions()
       WHERE ProdColorPattern.ModelId = vbModelId AND ProdColorPattern.ProdColorGroupName ILIKE 'Fiberglass - DECK';
       
     ELSEIF inReplacement ILIKE 'ДА'
     THEN
       vbProdColor_ChildId := (SELECT MAX(Object_ProdColor.Id) FROM Object AS Object_ProdColor 
                               WHERE Object_ProdColor.DescId = zc_Object_ProdColor() AND Object_ProdColor.ValueData ILIKE SPLIT_PART (inGoodsName_child, '-', 3));

       SELECT ProdColorPattern.Id
            , ObjectLink_MaterialOptions.ChildObjectId 
       INTO vbProdColorPatternId, vbMaterialOptionsId
       FROM gpSelect_Object_ProdColorPattern(inColorPatternId:= vbColorPatternId, inIsErased:= FALSE, inIsShowAll := FALSE, inSession := inSession) AS ProdColorPattern
             LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                  ON ObjectLink_MaterialOptions.ObjectId = ProdColorPattern.prodoptionsid
                                 AND ObjectLink_MaterialOptions.DescId = zc_ObjectLink_ProdOptions_MaterialOptions()
       WHERE ProdColorPattern.ModelId = vbModelId AND ProdColorPattern.ProdColorGroupName ILIKE 'Fiberglass - DECK color';

     END IF;

     -- Узел основной
     inGoodsName := 'Сиденье водителя '||SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2)||'-'||vbProdColorName;
     inGroupName := 'Boote'; --'Сборка сиденья';    
     inArticle := SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2)||'-'||SPLIT_PART (inArticle, '-', 3);

   ELSEIF SPLIT_PART (inArticle, '-', 3) = '03' -- Сборка капота
   THEN

     -- Узел 2 уровня   
     IF LOWER(SPLIT_PART (inArticle, '-', 4)) = 'пф'
     THEN
       vbArticle_GoodsChild := inArticle;
       vbGoods_GoodsChildName := 'ПФ Капот '||SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2)||'-'||vbProdColorName;
       vbGroup_GoodsChildName := 'Boote'; --inGroupName;
       vbStage := True;
     END IF;
     
     -- Комплектующее узла
     inGroupName_child := 'Boote';
     
     -- Если есть замена комплектующей то определяем параметры
     IF inReplacement ILIKE 'ДА'
     THEN
       vbProdColor_ChildId := (SELECT MAX(Object_ProdColor.Id) FROM Object AS Object_ProdColor 
                               WHERE Object_ProdColor.DescId = zc_Object_ProdColor() AND Object_ProdColor.ValueData ILIKE vbProdColorName);

       SELECT ProdColorPattern.Id
            , ObjectLink_MaterialOptions.ChildObjectId 
       INTO vbProdColorPatternId, vbMaterialOptionsId
       FROM gpSelect_Object_ProdColorPattern(inColorPatternId:= vbColorPatternId, inIsErased:= FALSE, inIsShowAll := FALSE, inSession := inSession) AS ProdColorPattern
             LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                  ON ObjectLink_MaterialOptions.ObjectId = ProdColorPattern.prodoptionsid
                                 AND ObjectLink_MaterialOptions.DescId = zc_ObjectLink_ProdOptions_MaterialOptions()
       WHERE ProdColorPattern.ModelId = vbModelId AND ProdColorPattern.ProdColorGroupName ILIKE 'Fiberglass Steering Console';

     END IF;

     -- Узел основной
     inGoodsName := 'Капот '||SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2)||'-'||vbProdColorName;
     inGroupName := 'Boote'; --'Сборка Капота';    
     inArticle := SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2)||'-'||SPLIT_PART (inArticle, '-', 3);

   ELSEIF TRIM(SPLIT_PART (inArticle, '-', 3)) ILIKE '*ICE WHITE' -- Балоны
   THEN
     vbNotRename := True;  
     inGoodsName := inArticle;
     inGroupName := 'Boote'; -- 'Сборка баллона';

     -- Комплектующее узла
     inGroupName_child := 'Boote';
     
     -- Если есть замена комплектующей то определяем параметры
     IF inReplacement ILIKE 'ДА'
     THEN

       inGroupName_child := TRIM(inReceiptLevelName);
       
       IF TRIM(inReceiptLevelName) ILIKE 'primary'
       THEN
         vbProdColor_ChildId := (SELECT MAX(Object_ProdColor.Id) FROM Object AS Object_ProdColor 
                                 WHERE Object_ProdColor.DescId = zc_Object_ProdColor() AND Object_ProdColor.ValueData ILIKE 'ICE WHITE');
         inGroupName_child := 'Hypalon';
       ELSEIF TRIM(inReceiptLevelName) ILIKE 'secondary'
       THEN
         vbProdColor_ChildId := (SELECT MAX(Object_ProdColor.Id) FROM Object AS Object_ProdColor 
                                 WHERE Object_ProdColor.DescId = zc_Object_ProdColor() AND Object_ProdColor.ValueData ILIKE 'NEPTUNE GREY');
         inGroupName_child := 'Hypalon';
       ELSEIF TRIM(inReceiptLevelName) ILIKE 'fender'
       THEN
         vbProdColor_ChildId := (SELECT MAX(Object_ProdColor.Id) FROM Object AS Object_ProdColor 
                                 WHERE Object_ProdColor.DescId = zc_Object_ProdColor() AND Object_ProdColor.ValueData ILIKE 'NEPTUNE GREY');
       END IF;

       SELECT ProdColorPattern.Id
            , ObjectLink_MaterialOptions.ChildObjectId 
       INTO vbProdColorPatternId, vbMaterialOptionsId
       FROM gpSelect_Object_ProdColorPattern(inColorPatternId:= vbColorPatternId, inIsErased:= FALSE, inIsShowAll := FALSE, inSession := inSession) AS ProdColorPattern
             LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                  ON ObjectLink_MaterialOptions.ObjectId = ProdColorPattern.prodoptionsid
                                 AND ObjectLink_MaterialOptions.DescId = zc_ObjectLink_ProdOptions_MaterialOptions()
       WHERE ProdColorPattern.ModelId = vbModelId 
         AND ProdColorPattern.ProdColorGroupName ILIKE 'Hypalon' 
         AND ProdColorPattern.Name ILIKE TRIM(inReceiptLevelName);

     END IF;

   ELSEIF TRIM(SPLIT_PART (inArticle, '-', 3)) ILIKE 'BEL' -- Обивка
   THEN
     vbNotRename := True;  

     -- Комплектующее узла
     inGroupName_child := 'Boote';
     
     -- Если есть замена комплектующей то определяем параметры
     IF inReplacement ILIKE 'ДА'
     THEN
       vbProdColor_ChildId := (SELECT MAX(Object_ProdColor.Id) FROM Object AS Object_ProdColor 
                               WHERE Object_ProdColor.DescId = zc_Object_ProdColor() AND Object_ProdColor.ValueData ILIKE 'pure white');
       vbProdColorId := vbProdColor_ChildId;

       SELECT ProdColorPattern.Id
            , ObjectLink_MaterialOptions.ChildObjectId 
       INTO vbProdColorPatternId, vbMaterialOptionsId
       FROM gpSelect_Object_ProdColorPattern(inColorPatternId:= vbColorPatternId, inIsErased:= FALSE, inIsShowAll := FALSE, inSession := inSession) AS ProdColorPattern
             LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                  ON ObjectLink_MaterialOptions.ObjectId = ProdColorPattern.prodoptionsid
                                 AND ObjectLink_MaterialOptions.DescId = zc_ObjectLink_ProdOptions_MaterialOptions()
       WHERE ProdColorPattern.ModelId = vbModelId 
         AND ProdColorPattern.ProdColorGroupName ILIKE 'Upholstery' 
         AND ProdColorPattern.Name ILIKE 'primary+secondary';

     END IF;

     -- Узел основной
     inGroupName := 'Boote';
     
   ELSEIF TRIM(SPLIT_PART (inArticle, '-', 3)) ILIKE 'basis' -- Сборка лодки
   THEN
     vbNotRename := True;  
     vbReceiptProdModel := True;
     
     inGroupName_child := 'Boote';
     
     -- Если есть замена комплектующей то определяем параметры
     IF inReplacement ILIKE 'ДА'
     THEN

       SELECT ProdColorPattern.Id
            , ObjectLink_MaterialOptions.ChildObjectId 
       INTO vbProdColorPatternId, vbMaterialOptionsId
       FROM gpSelect_Object_ProdColorPattern(inColorPatternId:= vbColorPatternId, inIsErased:= FALSE, inIsShowAll := FALSE, inSession := inSession) AS ProdColorPattern
             LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                  ON ObjectLink_MaterialOptions.ObjectId = ProdColorPattern.prodoptionsid
                                 AND ObjectLink_MaterialOptions.DescId = zc_ObjectLink_ProdOptions_MaterialOptions()
       WHERE ProdColorPattern.ModelId = vbModelId 
         AND ProdColorPattern.ProdColorGroupName ILIKE 'Teak';

     END IF;   
   ELSE
     RAISE EXCEPTION 'Ошибка Для <%> <%> не найдена обработка.', inArticle, inArticle_child;        
   END IF;

   IF inReplacement ILIKE 'ДА' AND COALESCE (vbProdColorPatternId, 0) = 0
   THEN
     RAISE EXCEPTION 'Ошибка В Boat Structure не найдена замена для <%> <%> <%> <%>'
      , CASE WHEN inReceiptLevelName ILIKE 'Steering console' 
                  THEN 'Fiberglass '   || TRIM(SPLIT_PART (inReceiptLevelName, '/', 1))
             WHEN inReceiptLevelName ILIKE 'Hull' OR inReceiptLevelName ILIKE 'Deck' OR inReceiptLevelName ILIKE 'Deck color' 
                  THEN 'Fiberglass - '   || TRIM(SPLIT_PART (inReceiptLevelName, '/', 1))
             ELSE TRIM(SPLIT_PART (inReceiptLevelName, '/', 1))                                                         
        END
      , inArticle, inGoodsName_child
      , CASE WHEN inReceiptLevelName ILIKE 'Steering console' 
             THEN 'Fiberglass '   || TRIM(SPLIT_PART (COALESCE(NULLIF(SPLIT_PART (inReceiptLevelName, '-', 2), ''), inReceiptLevelName), '/', 1))
             ELSE 'Fiberglass - ' || TRIM(SPLIT_PART (COALESCE(NULLIF(SPLIT_PART (inReceiptLevelName, '-', 2), ''), inReceiptLevelName), '/', 1))
        END
       ;  

   END IF;

   BEGIN

     -- ********* Комплектующее 2 уровня *********

     -- пробуем найти Товар - Child - второго уровня
     IF COALESCE (vbGoods_GoodsChildName, '') <> '' AND vbStage = True
     THEN

         IF TRIM (vbArticle_GoodsChild) <> ''
         THEN
            -- по артикулу
            vbGoods_GoodsChildId := (SELECT ObjectString_Article.ObjectId
                               FROM ObjectString AS ObjectString_Article
                                    INNER JOIN Object ON Object.Id       = ObjectString_Article.ObjectId
                                                     AND Object.DescId   = zc_Object_Goods()
                                                     AND Object.isErased = FALSE
                               WHERE ObjectString_Article.ValueData ILIKE TRIM (vbArticle_GoodsChild)
                                 AND ObjectString_Article.DescId    = zc_ObjectString_Article()
                               LIMIT 1
                              );
         ELSE

            -- по названию
            vbGoods_GoodsChildId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ValueData ILIKE TRIM (vbGoods_GoodsChildName));
         END IF;


            -- ВСЕГДА - создание/корректировка товара Child
            IF COALESCE (vbGoods_GoodsChildId, 0) = 0
            THEN
              
               raise notice 'Value 01: Не нашли Child 2'; 

               -- группа товара пробуем найти
               vbGroup_GoodsChildId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsGroup() AND Object.ValueData = TRIM (vbGroup_GoodsChildName));

               -- если нет такой группы создаем
               IF COALESCE (vbGroup_GoodsChildId, 0) = 0
               THEN
                    vbGroup_GoodsChildId := (SELECT tmp.ioId
                                             FROM gpInsertUpdate_Object_GoodsGroup (ioId              := 0         :: Integer
                                                                                  , ioCode            := 0         :: Integer
                                                                                  , inName            := TRIM (vbGroup_GoodsChildName) ::TVarChar
                                                                                  , inParentId        := 0         :: Integer
                                                                                  , inInfoMoneyId     := 0         :: Integer
                                                                                  , inModelEtiketenId := 0         :: Integer
                                                                                  , inSession         := inSession :: TVarChar
                                                                                   ) AS tmp);
               END IF;

               -- создаем Child
               vbGoods_GoodsChildId := gpInsertUpdate_Object_Goods (ioId                := COALESCE (vbGoods_GoodsChildId, 0) :: Integer
                                                                  , inCode              := CASE WHEN COALESCE (vbGoods_GoodsChildId, 0) = 0 THEN -1 ELSE 0 END
                                                                  , inName              := TRIM (vbGoods_GoodsChildName) :: TVarChar
                                                                  , inArticle           := TRIM (vbArticle_GoodsChild)
                                                                  , inArticleVergl      := NULL     :: TVarChar
                                                                  , inEAN               := NULL     :: TVarChar
                                                                  , inASIN              := NULL     :: TVarChar
                                                                  , inMatchCode         := NULL     :: TVarChar
                                                                  , inFeeNumber         := NULL     :: TVarChar
                                                                  , inComment           := COALESCE ((SELECT OC.ValueData FROM Object AS OC
                                                                                                      WHERE OC.Id = COALESCE (vbGoods_GoodsChildId, 0) 
                                                                                                        AND OC.DescId = zc_ObjectString_Goods_Comment()), '') ::TVarChar
                                                                  , inIsArc             := FALSE    :: Boolean
                                                                  , inFeet              := 0        :: TFloat
                                                                  , inMetres            := 0        :: TFloat
                                                                  , inAmountMin         := 0        :: TFloat
                                                                  , inAmountRefer       := 0        :: TFloat
                                                                  , inEKPrice           := 0        :: TFloat
                                                                  , inEmpfPrice         := 0        :: TFloat
                                                                  , inGoodsGroupId      := vbGroup_GoodsChildId  :: Integer
                                                                  , inMeasureId         := 0        :: Integer
                                                                  , inGoodsTagId        := 0        :: Integer
                                                                  , inGoodsTypeId       := 0        :: Integer
                                                                  , inGoodsSizeId       := 0        :: Integer
                                                                  , inProdColorId       := 0        :: Integer
                                                                  , inPartnerId         := 0        :: Integer
                                                                  , inUnitId            := 0        :: Integer
                                                                  , inDiscountPartnerId := 0        :: Integer
                                                                  , inTaxKindId         := 0        :: Integer
                                                                  , inEngineId          := NULL
                                                                  , inSession           := inSession:: TVarChar
                                                                   );

            ELSEIF vbNotRename = False 
               AND NOT EXISTS (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.Id = COALESCE (vbGoods_GoodsChildId, 0) AND Object.ValueData ILIKE TRIM (vbGoods_GoodsChildName))
            THEN
               PERFORM lpUpdate_Object_ValueData (COALESCE (vbGoods_GoodsChildId, 0), TRIM (vbGoods_GoodsChildName) :: TVarChar, vbUserId) ;
            END IF;
     ELSEIF SPLIT_PART (vbArticle_GoodsChild, '-', 4) ILIKE 'пф' AND vbStage = True
     THEN
         -- по артиклу
         vbGoods_GoodsChildId := (SELECT Object.Id 
                                  FROM Object 
                                       INNER JOIN ObjectString AS ObjectString_Article
                                                               ON ObjectString_Article.ObjectId = Object.Id
                                                              AND ObjectString_Article.DescId = zc_ObjectString_Article()
                                                              AND ObjectString_Article.ValueData = TRIM (vbArticle_GoodsChild)
                                  WHERE Object.DescId = zc_Object_Goods()
                                  LIMIT 1);
     END IF;


     -- ********* Главное комплектующее *********

     -- пробуем найти Товар - Master
     IF COALESCE (inGoodsName, '') <> '' and vbReceiptProdModel = False
     THEN

         IF TRIM (inArticle) <> ''
         THEN
            -- по артикулу
            vbGoodsId := (SELECT ObjectString_Article.ObjectId
                          FROM ObjectString AS ObjectString_Article
                               INNER JOIN Object ON Object.Id       = ObjectString_Article.ObjectId
                                                AND Object.DescId   = zc_Object_Goods()
                                                AND Object.isErased = FALSE
                          WHERE ObjectString_Article.ValueData ILIKE TRIM (inArticle)
                            AND ObjectString_Article.DescId    = zc_ObjectString_Article()
                          LIMIT 1
                         );
         ELSE
            -- по названию
            vbGoodsId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ValueData ILIKE TRIM (inGoodsName));
         END IF;
         
         IF COALESCE (vbGoodsId, 0)  = 0 AND vbNotRename = True
         THEN
            -- по названию
            vbGoodsId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ValueData ILIKE TRIM (inGoodsName));
         END IF;

            -- ВСЕГДА - создание/корректировка товара Master
            IF COALESCE (vbGoodsId, 0) = 0
            THEN

               raise notice 'Value 02: Не нашли Master'; 

               -- группа товара пробуем найти
               vbGoodsGroupId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsGroup() AND Object.ValueData = TRIM (inGroupName));

               -- если нет такой группы создаем
               IF COALESCE (vbGoodsGroupId, 0) = 0
               THEN
                    vbGoodsGroupId := (SELECT tmp.ioId
                                       FROM gpInsertUpdate_Object_GoodsGroup (ioId              := 0         :: Integer
                                                                            , ioCode            := 0         :: Integer
                                                                            , inName            := TRIM (inGroupName) ::TVarChar
                                                                            , inParentId        := 0         :: Integer
                                                                            , inInfoMoneyId     := 0         :: Integer
                                                                            , inModelEtiketenId := 0         :: Integer
                                                                            , inSession         := inSession :: TVarChar
                                                                             ) AS tmp);
               END IF;

               -- создаем Master
               vbGoodsId := gpInsertUpdate_Object_Goods (ioId                := COALESCE (vbGoodsId, 0) :: Integer
                                                       , inCode              := CASE WHEN COALESCE (vbGoodsId, 0) = 0 THEN -1 ELSE 0 END
                                                       , inName              := TRIM (inGoodsName) :: TVarChar
                                                       , inArticle           := TRIM (inArticle)
                                                       , inArticleVergl      := NULL     :: TVarChar
                                                       , inEAN               := NULL     :: TVarChar
                                                       , inASIN              := NULL     :: TVarChar
                                                       , inMatchCode         := NULL     :: TVarChar
                                                       , inFeeNumber         := NULL     :: TVarChar
                                                       , inComment           := COALESCE ((SELECT OC.ValueData FROM Object AS OC
                                                                                           WHERE OC.Id = COALESCE (vbGoodsId, 0) 
                                                                                             AND OC.DescId = zc_ObjectString_Goods_Comment()), '') ::TVarChar
                                                       , inIsArc             := FALSE    :: Boolean
                                                       , inFeet              := 0        :: TFloat
                                                       , inMetres            := 0        :: TFloat
                                                       , inAmountMin         := 0        :: TFloat
                                                       , inAmountRefer       := 0        :: TFloat
                                                       , inEKPrice           := 0        :: TFloat
                                                       , inEmpfPrice         := 0        :: TFloat
                                                       , inGoodsGroupId      := vbGoodsGroupId  :: Integer
                                                       , inMeasureId         := 0        :: Integer
                                                       , inGoodsTagId        := 0        :: Integer
                                                       , inGoodsTypeId       := 0        :: Integer
                                                       , inGoodsSizeId       := 0        :: Integer
                                                       , inProdColorId       := vbProdColorId :: Integer
                                                       , inPartnerId         := 0        :: Integer
                                                       , inUnitId            := 0        :: Integer
                                                       , inDiscountPartnerId := 0       :: Integer
                                                       , inTaxKindId         := 0        :: Integer
                                                       , inEngineId          := NULL
                                                       , inSession           := inSession:: TVarChar
                                                        );
                                                        
            ELSEIF vbNotRename = False 
               AND NOT EXISTS (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.Id = COALESCE (vbGoodsId, 0) AND Object.ValueData ILIKE TRIM (inGoodsName))
            THEN
               PERFORM lpUpdate_Object_ValueData (COALESCE (vbGoodsId, 0), TRIM (inGoodsName) :: TVarChar, vbUserId) ;
            END IF;
     END IF;

     -- ********* Комплектующее *********

     -- пробуем найти Товар - Child
     IF COALESCE (inGoodsName_child, '') <> ''
     THEN

         IF TRIM (inArticle_child) <> ''
         THEN
            -- по артикулу
            vbGoodsId_child := (SELECT ObjectString_Article.ObjectId
                                FROM ObjectString AS ObjectString_Article
                                     INNER JOIN Object ON Object.Id       = ObjectString_Article.ObjectId
                                                      AND Object.DescId   = zc_Object_Goods()
                                                      AND Object.isErased = FALSE
                                WHERE ObjectString_Article.ValueData = inArticle_child
                                  AND ObjectString_Article.DescId    = zc_ObjectString_Article()
                                LIMIT 1
                               );
         ELSE

            -- по названию
            vbGoodsId_child := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ValueData ILIKE TRIM (inGoodsName_child));
         END IF;
         
         IF vbReceiptProdModel = TRUE AND COALESCE (vbGoodsId_child, 0) = 0 
         THEN
            -- по названию
            vbGoodsId_child := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ValueData ILIKE TRIM (inGoodsName_child));
         END IF;


            -- ВСЕГДА - создание/корректировка товара Child
            IF COALESCE (vbGoodsId_child, 0) = 0 
            THEN

               raise notice 'Value 03: Не нашли Child'; 

               -- группа товара пробуем найти
               vbGoodsGroupId_child := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsGroup() AND Object.ValueData = TRIM (inGroupName_child));
               -- если нет такой группы создаем
               IF COALESCE (vbGoodsGroupId_child, 0) = 0
               THEN
                    vbGoodsGroupId_child := (SELECT tmp.ioId
                                             FROM gpInsertUpdate_Object_GoodsGroup (ioId              := 0         :: Integer
                                                                                  , ioCode            := 0         :: Integer
                                                                                  , inName            := TRIM (inGroupName_child) ::TVarChar
                                                                                  , inParentId        := 0         :: Integer
                                                                                  , inInfoMoneyId     := 0         :: Integer
                                                                                  , inModelEtiketenId := 0         :: Integer
                                                                                  , inSession         := inSession :: TVarChar
                                                                                   ) AS tmp);
               END IF;

               -- создаем Child
               vbGoodsId_child := gpInsertUpdate_Object_Goods (ioId               := COALESCE (vbGoodsId_child,0)::  Integer
                                                             , inCode             := 0
                                                             , inName             := TRIM (inGoodsName_child) :: TVarChar
                                                             , inArticle          := TRIM (inArticle_child)
                                                             , inArticleVergl     := NULL     :: TVarChar
                                                             , inEAN              := NULL     :: TVarChar
                                                             , inASIN             := NULL     :: TVarChar
                                                             , inMatchCode        := NULL     :: TVarChar
                                                             , inFeeNumber        := NULL     :: TVarChar
                                                             , inComment          := COALESCE ((SELECT OC.ValueData FROM Object AS OC
                                                                                                WHERE OC.Id = COALESCE (vbGoodsId_child, 0) 
                                                                                                  AND OC.DescId = zc_ObjectString_Goods_Comment()), '') ::TVarChar
                                                             , inIsArc            := FALSE    :: Boolean
                                                             , inFeet             := 0        :: TFloat
                                                             , inMetres           := 0        :: TFloat
                                                             , inAmountMin        := 0        :: TFloat
                                                             , inAmountRefer      := 0        :: TFloat
                                                             , inEKPrice          := 0        :: TFloat
                                                             , inEmpfPrice        := 0        :: TFloat
                                                             , inGoodsGroupId     := vbGoodsGroupId_child  :: Integer
                                                             , inMeasureId        := 0        :: Integer
                                                             , inGoodsTagId       := 0        :: Integer
                                                             , inGoodsTypeId      := 0        :: Integer
                                                             , inGoodsSizeId      := 0        :: Integer
                                                             , inProdColorId      := COALESCE(vbProdColor_ChildId, 0) :: Integer
                                                             , inPartnerId        := 0        :: Integer
                                                             , inUnitId           := 0        :: Integer
                                                             , inDiscountPartnerId:= 0       :: Integer
                                                             , inTaxKindId        := 0        :: Integer
                                                             , inEngineId         := NULL
                                                             , inSession          := inSession:: TVarChar
                                                              );

            ELSEIF vbNotRename = False 
               AND NOT EXISTS (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.Id = COALESCE (vbGoodsId_child, 0) AND Object.ValueData ILIKE TRIM (inGoodsName_child))
            THEN
               PERFORM lpUpdate_Object_ValueData (COALESCE (vbGoodsId_child, 0), TRIM (inGoodsName_child) :: TVarChar, vbUserId) ;
            END IF;
     END IF;
          
     -- ********* Шаблоны сборки *********     

     -- Шаблон сборки узла
     IF vbReceiptProdModel = False
     THEN
     
       -- ищем ReceiptGoods
       vbReceiptGoodsId := (SELECT ObjectLink.ObjectId
                            FROM ObjectLink
                            WHERE ObjectLink.DescId        = zc_ObjectLink_ReceiptGoods_Object()
                              AND ObjectLink.ChildObjectId = vbGoodsId
                           );

       -- ВСЕГДА создание/корректировка
       IF COALESCE (vbReceiptGoodsId, 0) = 0 OR 1=1
       THEN
           -- если не нашли создаем
           vbReceiptGoodsId :=  gpInsertUpdate_Object_ReceiptGoods (ioId               := vbReceiptGoodsId
                                                                  , inCode             := 0   :: Integer
                                                                  , inName             := TRIM (inGoodsName) :: TVarChar
                                                                  , inColorPatternId   := vbColorPatternId
                                                                  , inGoodsId          := vbGoodsId
                                                                  , inUnitId           := 0
                                                                  , inIsMain           := TRUE     :: Boolean
                                                                  , inUserCode         := ''       :: TVarChar
                                                                  , inComment          := COALESCE ((SELECT OC.ValueData FROM Object AS OC
                                                                                                     WHERE OC.Id = COALESCE (vbReceiptGoodsId, 0) 
                                                                                                       AND OC.DescId = zc_ObjectString_ReceiptGoods_Comment()), '') ::TVarChar
                                                                  , inSession          := inSession:: TVarChar
                                                                   );
       END IF;


       IF COALESCE (inReceiptLevelName, '') <> '' AND COALESCE (vbGoods_GoodsChildId, 0) <> 0
       THEN

           -- Этап сборки пробуем найти
           vbReceiptLevelId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ReceiptLevel() AND Object.ValueData = TRIM (inReceiptLevelName));

           -- если нет такого Этап сборки
           IF COALESCE (vbReceiptLevelId, 0) = 0
           THEN
                vbReceiptLevelId := (SELECT tmp.ioId
                                     FROM gpInsertUpdate_Object_ReceiptLevel (ioId              := 0         :: Integer
                                                                            , ioCode            := 0         :: Integer
                                                                            , inName            := TRIM (inReceiptLevelName) ::TVarChar
                                                                            , inShortName       := TRIM (inReceiptLevelName) ::TVarChar
                                                                            , inObjectDesc      := 'zc_Object_ReceiptGoods'  ::TVarChar
                                                                            , inSession         := inSession :: TVarChar
                                                                             ) AS tmp);
           END IF;
           
       END IF;

       -- ищем ReceiptGoodsChild
       vbReceiptGoodsChildId := (SELECT Object_ReceiptGoodsChild.Id
                                 FROM Object AS Object_ReceiptGoodsChild
                                      INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                                            ON ObjectLink_ReceiptGoods.ObjectId = Object_ReceiptGoodsChild.Id
                                                           AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                                           AND ObjectLink_ReceiptGoods.ChildObjectId = vbReceiptGoodsId
                                      INNER JOIN ObjectLink AS ObjectLink_Object
                                                            ON ObjectLink_Object.ObjectId = Object_ReceiptGoodsChild.Id
                                                           AND ObjectLink_Object.DescId = zc_ObjectLink_ReceiptGoodsChild_Object()
                                                           AND ObjectLink_Object.ChildObjectId = vbGoodsId_child
                                      LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                                           ON ObjectLink_ProdColorPattern.ObjectId = Object_ReceiptGoodsChild.Id
                                                          AND ObjectLink_ProdColorPattern.DescId = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()
                                      LEFT JOIN ObjectLink AS ObjectLink_GoodsChild
                                                           ON ObjectLink_GoodsChild.ObjectId = Object_ReceiptGoodsChild.Id
                                                          AND ObjectLink_GoodsChild.DescId = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()
                                      LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel
                                                           ON ObjectLink_ReceiptLevel.ObjectId = Object_ReceiptGoodsChild.Id
                                                          AND ObjectLink_ReceiptLevel.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptLevel()
                                 WHERE Object_ReceiptGoodsChild.DescId = zc_Object_ReceiptGoodsChild()
                                   AND Object_ReceiptGoodsChild.isErased = FALSE
                                   AND COALESCE (ObjectLink_ProdColorPattern.ChildObjectId, 0) = COALESCE (vbProdColorPatternId, 0)
                                   AND (COALESCE (ObjectLink_GoodsChild.ChildObjectId, 0) = 0 OR
                                        COALESCE (ObjectLink_GoodsChild.ChildObjectId, 0) = COALESCE (vbGoods_GoodsChildId, 0))
                                   AND COALESCE (ObjectLink_ReceiptLevel.ChildObjectId, 0) = COALESCE (vbReceiptLevelId, 0)
                                 );

       IF COALESCE (vbReceiptGoodsChildId, 0) = 0 OR
          NOT EXISTS (SELECT Object_ReceiptGoodsChild.Id
                      FROM Object AS Object_ReceiptGoodsChild
                           LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                                ON ObjectLink_ProdColorPattern.ObjectId = Object_ReceiptGoodsChild.Id
                                               AND ObjectLink_ProdColorPattern.DescId = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()
                           LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                                ON ObjectLink_MaterialOptions.ObjectId = Object_ReceiptGoodsChild.Id
                                               AND ObjectLink_MaterialOptions.DescId = zc_ObjectLink_ReceiptGoodsChild_MaterialOptions()
                           LEFT JOIN ObjectLink AS ObjectLink_GoodsChild
                                                ON ObjectLink_GoodsChild.ObjectId = Object_ReceiptGoodsChild.Id
                                               AND ObjectLink_GoodsChild.DescId = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()
                           LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel
                                                ON ObjectLink_ReceiptLevel.ObjectId = Object_ReceiptGoodsChild.Id
                                               AND ObjectLink_ReceiptLevel.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptLevel()
                      WHERE Object_ReceiptGoodsChild.DescId = zc_Object_ReceiptGoodsChild()
                        AND Object_ReceiptGoodsChild.ID = vbReceiptGoodsChildId
                        AND COALESCE (ObjectLink_ProdColorPattern.ChildObjectId, 0) = COALESCE (vbProdColorPatternId, 0)
                        AND COALESCE (ObjectLink_MaterialOptions.ChildObjectId, 0) = COALESCE (vbMaterialOptionsId, 0)
                        AND COALESCE (ObjectLink_GoodsChild.ChildObjectId, 0) = COALESCE (vbGoods_GoodsChildId, 0)
                        AND COALESCE (ObjectLink_ReceiptLevel.ChildObjectId, 0) = COALESCE (vbReceiptLevelId, 0))
       THEN

           -- если не нашли создаем или правим если надо
           vbReceiptGoodsChildId := (SELECT tmp.ioId
                                     FROM gpInsertUpdate_Object_ReceiptGoodsChild (ioId                 := COALESCE (vbReceiptGoodsChildId,0) ::Integer
                                                                                 , inComment            := COALESCE ((SELECT OC.ValueData FROM Object AS OC
                                                                                                                      WHERE OC.Id = COALESCE (vbReceiptGoodsChildId, 0) 
                                                                                                                        AND OC.DescId = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()), '') ::TVarChar
                                                                                 , inReceiptGoodsId     := vbReceiptGoodsId     ::Integer
                                                                                 , inObjectId           := vbGoodsId_child      ::Integer
                                                                                 , inProdColorPatternId := vbProdColorPatternId ::Integer
                                                                                 , inMaterialOptionsId  := COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbReceiptGoodsChildId AND OL.DescId = zc_ObjectLink_ReceiptGoodsChild_MaterialOptions()), vbMaterialOptionsId)  ::Integer
                                                                                 , inReceiptLevelId_top := 0                    ::Integer
                                                                                 , inReceiptLevelId     := vbReceiptLevelId     ::Integer
                                                                                 , inGoodsChildId       := vbGoods_GoodsChildId ::Integer
                                                                                 , ioValue              := vbAmount             ::TVarChar
                                                                                 , ioValue_service      :='0'                   ::TVarChar
                                                                                 , ioForCount           := vbForCount
                                                                                 , inIsEnabled          := TRUE                 ::Boolean
                                                                                 , inSession            := inSession            ::TVarChar
                                                                                  ) AS tmp);

       END IF;
     END IF;
     
     -- Шаблон сборки лодки
     IF vbReceiptProdModel = True
     THEN
     
        -- поиск Шаблон сборка Модели
       vbReceiptProdModelId := (SELECT Object.Id FROM Object 
                                WHERE Object.DescId = zc_Object_ReceiptProdModel() 
                                  AND Object.ValueData ILIKE '%'||SPLIT_PART (inArticle, '-', 2)||'-base%'
                                  AND Object.isErased = False);

         -- Этап сборки пробуем найти
       IF COALESCE (inReceiptLevelName, '') <> ''
       THEN

           -- Этап сборки пробуем найти
           vbReceiptLevelId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ReceiptLevel() AND Object.ValueData = TRIM (inReceiptLevelName));

           -- если нет такого Этап сборки
           IF COALESCE (vbReceiptLevelId, 0) = 0
           THEN
                vbReceiptLevelId := (SELECT tmp.ioId
                                     FROM gpInsertUpdate_Object_ReceiptLevel (ioId              := 0         :: Integer
                                                                            , ioCode            := 0         :: Integer
                                                                            , inName            := TRIM (inReceiptLevelName) ::TVarChar
                                                                            , inShortName       := TRIM (inReceiptLevelName) ::TVarChar
                                                                            , inObjectDesc      := 'zc_Object_ReceiptProdModel'  ::TVarChar
                                                                            , inSession         := inSession :: TVarChar
                                                                             ) AS tmp);
             END IF;
       END IF;
     
       -- поиск ReceiptProdModelChild
       vbReceiptProdModelChildId:= (SELECT Object_ReceiptProdModelChild.Id
                                    FROM Object AS Object_ReceiptProdModelChild

                                         INNER JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                                               ON ObjectLink_ReceiptProdModel.ObjectId      = Object_ReceiptProdModelChild.Id
                                                              AND ObjectLink_ReceiptProdModel.ChildObjectId = vbReceiptProdModelId
                                                              AND ObjectLink_ReceiptProdModel.DescId        = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()

                                         INNER JOIN ObjectLink AS ObjectLink_Object
                                                               ON ObjectLink_Object.ObjectId      = Object_ReceiptProdModelChild.Id
                                                              AND ObjectLink_Object.ChildObjectId = vbGoodsId_child
                                                              AND ObjectLink_Object.DescId        = zc_ObjectLink_ReceiptProdModelChild_Object()

                                    WHERE Object_ReceiptProdModelChild.DescId   = zc_Object_ReceiptProdModelChild()
                                      AND Object_ReceiptProdModelChild.isErased = FALSE
                                   );
       
       -- Если удалено то востанавливаем                            
       IF COALESCE (vbReceiptProdModelChildId, 0) <> 0
          AND EXISTS (SELECT 1 FROM Object WHERE Object.ID = vbReceiptProdModelChildId AND Object.isErased = TRUE)
       THEN

         PERFORM gpUpdate_Object_isErased_ReceiptProdModelChild(inObjectId := vbReceiptProdModelChildId
                                                              , inIsErased := FALSE
                                                              , inSession  := inSession);
       
       END IF;                                    
                                   
       --
       IF COALESCE (vbReceiptProdModelChildID, 0) = 0 OR
          COALESCE (vbReceiptLevelId, 0) <> 0 AND
          NOT EXISTS(SELECT OC.ValueData 
                     FROM Object AS OC
                          LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel
                                               ON ObjectLink_ReceiptLevel.ObjectId      = OC.Id
                                              AND ObjectLink_ReceiptLevel.DescId        = zc_ObjectLink_ReceiptProdModelChild_ReceiptLevel()
                     WHERE OC.Id = COALESCE (vbReceiptProdModelChildId, 0) 
                       AND OC.DescId = zc_Object_ReceiptProdModelChild()
                       AND COALESCE(ObjectLink_ReceiptLevel.ChildObjectId, 0) <> COALESCE(vbReceiptLevelId, 0))  
       THEN

         raise notice 'Value 05: Не нашли ReceiptProdModelChild'; 

         vbReceiptProdModelChildID:= (SELECT tmp.ioId
                                      FROM gpInsertUpdate_Object_ReceiptProdModelChild (ioId                 := COALESCE (vbReceiptProdModelChildId, 0)
                                                                                      , inComment            := COALESCE ((SELECT OC.ValueData FROM Object AS OC
                                                                                                                           WHERE OC.Id = COALESCE (vbReceiptProdModelChildId, 0) 
                                                                                                                             AND OC.DescId = zc_Object_ReceiptProdModelChild()), '')    ::TVarChar
                                                                                      , inReceiptProdModelId := vbReceiptProdModelId  ::Integer
                                                                                      , inObjectId           := vbGoodsId_child       ::Integer
                                                                                      , inReceiptLevelId_top := vbReceiptLevelId      ::Integer
                                                                                      , inReceiptLevelId     := vbReceiptLevelId      ::Integer
                                                                                      , ioValue              := vbAmount              ::TVarChar
                                                                                      , ioValue_service      := 0                     ::TVarChar
                                                                                      , ioForCount           := vbForCount
                                                                                      , ioIsCheck            := FALSE
                                                                                      , inSession            := inSession             ::TVarChar
                                                                                       ) AS tmp);
       END IF;
    
     END IF;
     
     
   EXCEPTION
      WHEN OTHERS THEN GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;	
      RAISE EXCEPTION 'Ошибка <%> %Строка загрузки <%> %Артикул-результат <%> %Название сборки <%> %Название-результат <%> %Группа-результат  <%> %Замена <%> %Артикул-комплект/узел <%> %Название-комплект/узел <%> %Группа-комплект/узел <%> %Количество <%>', 
             text_var1, Chr(13),
             inRecNum, Chr(13),                  -- Строка загрузки
             inArticle, Chr(13),                 -- Артикул-результат
             inReceiptLevelName, Chr(13),        -- Название сборки
             inGoodsName, Chr(13),               -- Название-результат
             inGroupName, Chr(13),               -- Группа-результат
             inReplacement, Chr(13),             -- Замена
             inArticle_child, Chr(13),           -- Артикул-комплект/узел
             inGoodsName_child, Chr(13),         -- Название-комплект/узел
             inGroupName_child, Chr(13),         -- Группа-комплект/узел
             vbAmount                            -- Количество
             ;
   END;
   

  /* RAISE EXCEPTION 'Goods Main <%> <%> <%> <%> <%> %Goods child 2 <%> <%> <%> <%> <%> <%>  %Goods child <%> <%> <%> <%> <%> <%> <%> %ReceiptGoods <%> <%> <%> %ReceiptGoodsChild <%> <%> <%> <%> %ReceiptProdModel <%> <%>', 
     --Goods Main        
     inArticle, inGoodsName, inGroupName, vbGoodsId, vbGoodsGroupId, Chr(13), 
     --Goods child 2     
     inReceiptLevelName, vbArticle_GoodsChild, vbGoods_GoodsChildName, vbGroup_GoodsChildName, vbGoods_GoodsChildId, vbGroup_GoodsChildId, Chr(13),
     --Goods child       
     inArticle_child, inGoodsName_child, vbGoodsId_child, inGroupName_child, vbGoodsGroupId_child, inAmount, vbAmount, Chr(13),
     --ReceiptGoods      
     vbReceiptGoodsId, vbColorPatternId, vbModelId, Chr(13),
     --ReceiptGoodsChild 
     vbReceiptGoodsChildId, vbReceiptLevelId, vbProdColorPatternId, vbMaterialOptionsId, Chr(13),
     --ReceiptProdModel  
     vbReceiptProdModelId, vbReceiptProdModelChildId; */

   -- RAISE EXCEPTION 'В работе'; 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 12.10.22                                                       *
 04.04.22         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ReceiptGoods_Load(3, 'AGL-280-01-пф', '1-HULL/(Корпус)', '', '', '', '77083888883', 'SYNOLITE 8388-P-1', 'Стеклопластик ПФ', '16,7124', zfCalc_UserAdmin())
