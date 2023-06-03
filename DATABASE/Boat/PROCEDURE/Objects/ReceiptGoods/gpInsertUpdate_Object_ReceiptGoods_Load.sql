--

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoods_Load (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoods_Load (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReceiptGoods_Load(
    IN inRecNum                Integer ,  -- Строка загрузки
    IN inNPP                   TVarChar,  -- № п/п
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

   DECLARE vbStage            Boolean; -- Сборка второго уровня
   DECLARE vbNotRename        Boolean; -- Не переименовывать
   DECLARE vbReceiptProdModel Boolean; -- Сборка лодки

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

   DECLARE vbMeasureName TVarChar;
   DECLARE vbMeasureId Integer;

   DECLARE text_var1 Text;

   DECLARE vbReceiptLevelName_find TVarChar;
   DECLARE vbcomment_master TVarChar;

BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);


/* IF inRecNum = 218
   THEN
      RAISE EXCEPTION 'Ошибка %  <%>  %  <%>  %.'
    , inNPP
    , inArticle
    , inArticle_child
    , inGroupName_child
    , inAmount
    ;

   END IF;*/

   -- !!!тест!!!
 /*IF TRIM (inArticle_child) ILIKE  '38.200.00'
   OR TRIM (inGoodsName_child) ILIKE 'Anti-vibration rubber peak latch 96x29 mm'
   THEN
      RAISE EXCEPTION 'Ошибка %<%>  %<%>  %<%>  %<%>.', CHR (13), inArticle_child, CHR (13), inGoodsName_child, CHR (13), zfConvert_CheckStringToFloat (inAmount), CHR (13), inAmount;
   END IF;*/


   -- !!!замена!!!
   inArticle               := TRIM (inArticle);
   inReceiptLevelName      := TRIM (inReceiptLevelName);
   inGoodsName             := TRIM (inGoodsName);
   inGroupName             := TRIM (inGroupName);
   inReplacement           := TRIM (inReplacement);
   inArticle_child         := TRIM (inArticle_child);
   inGoodsName_child       := TRIM (inGoodsName_child);
   inGroupName_child       := TRIM (inGroupName_child);
   inAmount                := TRIM (inAmount);

   --
   IF inReceiptLevelName ILIKE 'Streeting console'
   THEN
       inReceiptLevelName:= 'Steering console';
   END IF;

   --
   vbReceiptLevelName_find:= CASE inReceiptLevelName
                                  WHEN 'HULL/(Корпус)' THEN '1-HULL/(Корпус)'
                                  WHEN 'DECK/(Палуба)' THEN '2-DECK/(Палуба)'
                                  WHEN 'СЭ' THEN '3-СЭ'
                                  WHEN 'БС' THEN '4-БС'
                                  ELSE inReceiptLevelName
                             END;

   -- пустые строки
   IF COALESCE (TRIM (inGoodsName_child), '') = '' OR COALESCE (TRIM (inGoodsName_child), '') = '-'
    --OR SPLIT_PART (TRIM (inArticle), '-', 1))) NOT ILIKE 'AGL'
    --OR upper(TRIM(SPLIT_PART (inArticle, '-', 3))) NOT IN ('01', '02', '03', '*ICE WHITE', 'BEL', 'BASIS')
   THEN
       RETURN;
   END IF;

   -- ПФ в Артикул-комплект/узел НЕ загружаем
   -- IF upper(TRIM(SPLIT_PART (inArticle_child, '-', 3))) = '02' AND upper(TRIM(SPLIT_PART (inArticle_child, '-', 4))) = 'ПФ' THEN RETURN; END IF;
   IF TRIM (inArticle_child) ILIKE '%-ПФ' THEN RETURN; END IF;


   -- Проверка
   IF zfConvert_StringToNumber (inNPP) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не установлен NPP = <%> RecNum = <%> Article_ch = <%>.', inNPP, inRecNum, inArticle_child;
   END IF;


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


   -- Measure
   vbMeasureName:= CASE WHEN inAmount ILIKE '%м.п.%'  THEN 'м.п.'
                        WHEN inAmount ILIKE '%м.кв.%' THEN 'м.кв.'

                        WHEN inAmount ILIKE '%шт.%'   THEN 'шт.'
                        WHEN inAmount ILIKE '%шт%'    THEN 'шт.'

                        WHEN inAmount ILIKE '%уп.%'   THEN 'уп.'
                        WHEN inAmount ILIKE '%уп%'    THEN 'уп.'

                        WHEN inAmount ILIKE '%к-т.%'  THEN 'к-т.'
                        WHEN inAmount ILIKE '%к-т%'   THEN 'к-т.'

                        WHEN inAmount ILIKE '%ml.%'   THEN 'ml.'
                        WHEN inAmount ILIKE '%ml%'    THEN 'ml.'

                        WHEN inAmount ILIKE '%st.%'   THEN 'st.'
                        WHEN inAmount ILIKE '%st%'    THEN 'st.'

                        WHEN inAmount ILIKE '%м.%'    THEN 'м.'
                        WHEN inAmount ILIKE '%м%'     THEN 'м.'
                   END;

   -- Заменяем А
   inGoodsName := REPLACE(inGoodsName, chr(1040)||'GL-', 'AGL-');
   inGoodsName_child := REPLACE(inGoodsName_child, chr(1040)||'GL-', 'AGL-');

   -- Заменяем пробел после AGL
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
                            AND ObjectLink_Model.DescId   = zc_ObjectLink_ColorPattern_Model()
        -- поиск по модели
        INNER JOIN Object AS Object_Model ON Object_Model.Id = ObjectLink_Model.ChildObjectId
                                         -- здесь Модель
                                         AND Object_Model.ValueData ILIKE TRIM (SPLIT_PART (inArticle, '-', 2))
   WHERE Object_ColorPattern.DescId    = zc_Object_ColorPattern()
     AND Object_ColorPattern.isErased  = FALSE
  ;

   -- Проверка
   IF COALESCE (vbColorPatternId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Шаблон Boat Structure для модели = <%> не найден.', TRIM (SPLIT_PART (inArticle, '-', 2));
   END IF;


   -- Если первая строка загрузки удаляем все содержимое сборки модели
   IF inRecNum = 1
   THEN
       -- поиск Шаблон сборка Модели
       vbReceiptProdModelId := (SELECT Object.Id
                                FROM Object
                                     LEFT JOIN ObjectLink AS ObjectLink_Model
                                                          ON ObjectLink_Model.ObjectId = Object.Id
                                                         AND ObjectLink_Model.DescId = zc_ObjectLink_ReceiptProdModel_Model()
                                     -- поиск по Модели
                                     INNER JOIN Object AS Object_Model ON Object_Model.Id = ObjectLink_Model.ChildObjectId
                                                                      -- здесь Модель
                                                                      AND Object_Model.ValueData ILIKE TRIM (SPLIT_PART (inArticle, '-', 2))
                                WHERE Object.DescId   = zc_Object_ReceiptProdModel()
                                  AND Object.isErased = FALSE
                               );

       -- Проверка
       IF COALESCE (vbReceiptProdModelId, 0) = 0
       THEN
         RAISE EXCEPTION 'Ошибка.Шаблон сборка Модели для модели = <%> не найден.', TRIM (SPLIT_PART (inArticle, '-', 2));
       END IF;

       -- удаление
       PERFORM gpUpdate_Object_isErased_ReceiptProdModelChild(inObjectId := Object_ReceiptProdModelChild.Id
                                                            , inIsErased := TRUE
                                                            , inSession  := inSession)
       FROM Object AS Object_ReceiptProdModelChild
            -- Шаблон сборка Модели
            INNER JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                  ON ObjectLink_ReceiptProdModel.ObjectId      = Object_ReceiptProdModelChild.Id
                                 AND ObjectLink_ReceiptProdModel.DescId        = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()
                                 AND ObjectLink_ReceiptProdModel.ChildObjectId = vbReceiptProdModelId
       WHERE Object_ReceiptProdModelChild.DescId   = zc_Object_ReceiptProdModelChild()
         AND Object_ReceiptProdModelChild.isErased = FALSE
      ;

   END IF;

   -- Дефаултный цвет
   vbProdColorName:= 'RAL 9010';


   IF TRIM (inGoodsName) = '' AND UPPER (TRIM (SPLIT_PART (inArticle, '-', 3))) <> 'BASIS'
   THEN
       -- поиск
       inGoodsName:= (SELECT Object.ValueData
                      FROM ObjectString AS ObjectString_Article
                           INNER JOIN Object ON Object.Id       = ObjectString_Article.ObjectId
                                            AND Object.DescId   = zc_Object_Goods()
                                            AND Object.isErased = FALSE
                      WHERE ObjectString_Article.ValueData ILIKE TRIM (inArticle)
                        AND ObjectString_Article.DescId    = zc_ObjectString_Article()
                      --LIMIT 1
                     );
       -- Проверка
       IF COALESCE (inGoodsName, '') = ''
       THEN
           RAISE EXCEPTION 'Ошибка.Узел = <%> не найден.', inArticle;
       END IF;

   END IF;

if inRecNum = 2 AND 1=0
then
           RAISE EXCEPTION 'Ошибка. <%> <%>  <%> <%>.', inArticle, inGoodsName, inArticle_child, inGoodsName_child;
end if;

   -- ********* Обработка артикула *********

   -- 1. Сборка Корпус + Капот + Консоль + Бортовые площадки + Сиденье + т.п.
   IF UPPER (TRIM (SPLIT_PART (inArticle, '-', 3))) NOT IN ('*ICE WHITE', 'BEL', 'BASIS')
   THEN
       -- если есть Узел 2 уровня
       IF TRIM (SPLIT_PART (inArticle, '-', 4)) ILIKE 'ПФ'
       THEN
           -- переносится Article
           vbArticle_GoodsChild:= inArticle;
           --
           IF TRIM (inGoodsName) <> ''
           THEN
               vbGoods_GoodsChildName:= TRIM (inGoodsName);
           ELSE
               -- пробуем найти по Article
               vbGoods_GoodsChildName:= (SELECT Object.ValueData
                                         FROM ObjectString AS ObjectString_Article
                                              INNER JOIN Object ON Object.Id       = ObjectString_Article.ObjectId
                                                               AND Object.DescId   = zc_Object_Goods()
                                                               AND Object.isErased = FALSE
                                         WHERE ObjectString_Article.ValueData ILIKE TRIM (inArticle)
                                           AND ObjectString_Article.DescId    = zc_ObjectString_Article()
                                         --LIMIT 1
                                        );
           END IF;

           -- Проверка
           IF TRIM (COALESCE (vbGoods_GoodsChildName, '')) = ''
           THEN
               RAISE EXCEPTION 'Ошибка.Не найден vbGoods_GoodsChildName с таким inArticle = <%>.', inArticle;
           END IF;

           -- переносится группа
           vbGroup_GoodsChildName := TRIM (inGroupName);

           -- Сборка второго уровня
           vbStage := TRUE;

       END IF;

       -- Комплектующие для узла
       inGroupName_child:= TRIM (inGroupName_child);


       -- Если это заменяемый, тогда надо найти BoatStructure
       IF inReplacement ILIKE 'ДА'
       THEN

           vbProdColorId := (SELECT MAX (Object_ProdColor.Id) FROM Object AS Object_ProdColor
                             WHERE Object_ProdColor.DescId = zc_Object_ProdColor() AND Object_ProdColor.ValueData ILIKE vbProdColorName
                            );
           -- поиск Конфигуратора
           SELECT gpSelect.Id                     AS ProdColorPatternId
                , gpSelect.MaterialOptionsId_find AS MaterialOptionsId
                  INTO vbProdColorPatternId, vbMaterialOptionsId
           FROM gpSelect_Object_ProdColorPattern (inColorPatternId:= vbColorPatternId, inIsErased:= FALSE, inIsShowAll := FALSE, inSession := inSession) AS gpSelect
           WHERE gpSelect.ModelId = vbModelId
             AND gpSelect.ProdColorGroupName ILIKE '%' || TRIM (SPLIT_PART (inReceiptLevelName, '/', 1))
          ;

           -- Проверка
           IF COALESCE (vbProdColorPatternId, 0) = 0
           THEN
             RAISE EXCEPTION 'Ошибка.Конфигуратор для модели = <%> + Level = <%>  + Шаблон = <%> не найден.(%)(%)(%)'
                           , lfGet_Object_ValueData_sh (vbModelId)
                           , inReceiptLevelName
                           , lfGet_Object_ValueData_sh (vbColorPatternId)
                           , inRecNum
                           , inNPP
                           , inArticle
                            ;
           END IF;

       END IF;

       -- Узел основной - заменяем, если было ПФ
       inArticle := REPLACE (REPLACE (inArticle, '-ПФ', ''), '-пф', '');
       inGoodsName:= REPLACE (REPLACE (inGoodsName, 'ПФ ', ''), 'пф ', '');
       inGroupName := CASE WHEN inGroupName ILIKE 'ПФ %' THEN 'Сборка ' || REPLACE (REPLACE (inGroupName, 'ПФ ', ''), 'пф ', '') ELSE inGroupName END;



   -- 2. Балоны
   ELSEIF TRIM (SPLIT_PART (inArticle, '-', 3)) ILIKE '*ICE WHITE'
   THEN
     vbNotRename := TRUE;
     --inGoodsName := inArticle;
     inGroupName := 'Сборка баллона';

     -- Комплектующее узла
     inGroupName_child := 'Сборка баллона'; -- 'Boote';

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

       SELECT gpSelect.Id                     AS ProdColorPatternId
            , gpSelect.MaterialOptionsId_find AS MaterialOptionsId
              INTO vbProdColorPatternId, vbMaterialOptionsId
       FROM gpSelect_Object_ProdColorPattern (inColorPatternId:= vbColorPatternId, inIsErased:= FALSE, inIsShowAll := FALSE, inSession := inSession) AS gpSelect
       WHERE gpSelect.ModelId = vbModelId
         AND gpSelect.ProdColorGroupName ILIKE 'Hypalon'
         AND gpSelect.Name ILIKE TRIM(inReceiptLevelName);

     END IF;


   -- 3. Обивка
   ELSEIF TRIM (SPLIT_PART (inArticle, '-', 3)) ILIKE 'BEL'
   THEN
       --
       vbNotRename := TRUE;

       -- Комплектующее узла
       inGroupName_child := 'Fabric';

       -- Если есть замена комплектующей то определяем параметры
       IF inReplacement ILIKE 'ДА'
       THEN
         vbProdColor_ChildId := (SELECT MAX(Object_ProdColor.Id) FROM Object AS Object_ProdColor
                                 WHERE Object_ProdColor.DescId = zc_Object_ProdColor() AND Object_ProdColor.ValueData ILIKE 'pure white'
                                );
         vbProdColorId := vbProdColor_ChildId;

         SELECT gpSelect.Id                     AS ProdColorPatternId
              , gpSelect.MaterialOptionsId_find AS MaterialOptionsId
                INTO vbProdColorPatternId, vbMaterialOptionsId
         FROM gpSelect_Object_ProdColorPattern (inColorPatternId:= vbColorPatternId, inIsErased:= FALSE, inIsShowAll := FALSE, inSession := inSession) AS gpSelect
               LEFT JOIN ObjectLink AS ObjectLink_MaterialOptions
                                    ON ObjectLink_MaterialOptions.ObjectId = gpSelect.prodoptionsid
                                   AND ObjectLink_MaterialOptions.DescId = zc_ObjectLink_ProdOptions_MaterialOptions()
         WHERE gpSelect.ModelId = vbModelId
           AND gpSelect.ProdColorGroupName ILIKE 'Upholstery'
           AND gpSelect.Name               ILIKE 'primary+secondary';

       END IF;

       -- Узел основной
       inGroupName := 'Кресло';


   -- 4. Сборка лодки
   ELSEIF TRIM(SPLIT_PART (inArticle, '-', 3)) ILIKE 'BASIS'
   THEN
       vbNotRename := TRUE;
       vbReceiptProdModel := TRUE;

       inGroupName_child := 'Boote';

       -- !!!надо создать узел с НУЖНЫМИ vbProdColorPatternId!!!!
       inReplacement:='';

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

if inRecNum = 325 AND 1=0
then
    RAISE EXCEPTION 'Ошибка.  <%> <%> <%> <%>  <%> <%>.', inArticle, inGoodsName, inArticle_child, inGoodsName_child
    , vbGoods_GoodsChildName, vbStage
    ;
end if;


   BEGIN

     -- если это Сборка второго уровня
     vbComment_master:= CASE WHEN inGoodsName ILIKE '%Корпус%'
                                  THEN 'HULL/DECK'

                             WHEN (SELECT gpSelect.ProdColorGroupName FROM gpSelect_Object_ProdColorPattern (0, FALSE, FALSE, inSession) AS gpSelect WHERE gpSelect.Id = vbProdColorPatternId)
                                   ILIKE '%DECK%'
                                  THEN 'DECK'

                             WHEN (SELECT gpSelect.ProdColorGroupName FROM gpSelect_Object_ProdColorPattern (0, FALSE, FALSE, inSession) AS gpSelect WHERE gpSelect.Id = vbProdColorPatternId)
                                   ILIKE '%CONSOLE%'
                                  THEN 'STEERING CONSOLE'

                             WHEN 'Hypalon' ILIKE (SELECT gpSelect.ProdColorGroupName FROM gpSelect_Object_ProdColorPattern (0, FALSE, FALSE, inSession) AS gpSelect WHERE gpSelect.Id = vbProdColorPatternId)
                                  THEN 'Hypalon'
                        END;

     -- ********* Комплектующее 2 уровня *********

     -- если это Сборка второго уровня
     IF vbStage = TRUE
     THEN
         -- найти Товар - Child - второго уровня
         IF TRIM (vbArticle_GoodsChild) <> ''
         THEN
            -- поиск по артикулу
            vbGoods_GoodsChildId := (SELECT ObjectString_Article.ObjectId
                                     FROM ObjectString AS ObjectString_Article
                                          INNER JOIN Object ON Object.Id       = ObjectString_Article.ObjectId
                                                           AND Object.DescId   = zc_Object_Goods()
                                                           AND Object.isErased = FALSE
                                     WHERE ObjectString_Article.ValueData ILIKE TRIM (vbArticle_GoodsChild)
                                       AND ObjectString_Article.DescId    = zc_ObjectString_Article()
                                     --LIMIT 1
                                    );
         ELSE
            -- поиск по названию
            -- vbGoods_GoodsChildId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ValueData ILIKE TRIM (vbGoods_GoodsChildName) AND Object.isErased = FALSE);
            RAISE EXCEPTION 'Ошибка.Не установлено значение vbArticle_GoodsChild для <%> (%)(%).', vbGoods_GoodsChildName, inArticle, inGoodsName;
         END IF;


         -- найти группу товара
         vbGroup_GoodsChildId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsGroup() AND Object.ValueData = TRIM (vbGroup_GoodsChildName));

         -- если нет такой группы - создаем
         IF COALESCE (vbGroup_GoodsChildId, 0) = 0 AND TRIM (vbGroup_GoodsChildName) <> ''
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

         -- НЕ ВСЕГДА - создание/корректировка товара Child
         IF COALESCE (vbGoods_GoodsChildId, 0) = 0
         THEN

            raise notice 'Value 01: Не нашли Child 2';

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
                                                               , inComment           := CASE WHEN vbComment_master <> '' THEN vbComment_master
                                                                                             ELSE COALESCE ((SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.ObjectId = vbGoods_GoodsChildId AND OS.DescId = zc_ObjectString_Goods_Comment()), '')
                                                                                        END
                                                               , inIsArc             := FALSE    :: Boolean
                                                               , inFeet              := 0        :: TFloat
                                                               , inMetres            := 0        :: TFloat
                                                               , inAmountMin         := 0        :: TFloat
                                                               , inAmountRefer       := 0        :: TFloat
                                                               , inEKPrice           := 0        :: TFloat
                                                               , inEmpfPrice         := 0        :: TFloat
                                                               , inGoodsGroupId      := CASE WHEN vbGroup_GoodsChildId > 0
                                                                                             THEN vbGroup_GoodsChildId
                                                                                             ELSE (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbGoods_GoodsChildId AND OL.DescId = zc_ObjectLink_Goods_GoodsGroup())
                                                                                        END
                                                               , inMeasureId         := 0        :: Integer
                                                               , inGoodsTagId        := 0        :: Integer
                                                               , inGoodsTypeId       := 0        :: Integer
                                                               , inGoodsSizeId       := 0        :: Integer
                                                               , inProdColorId       := CASE WHEN vbProdColorId > 0
                                                                                             THEN vbProdColorId
                                                                                             ELSE (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbGoodsId AND OL.DescId = zc_ObjectLink_Goods_ProdColor())
                                                                                        END
                                                               , inPartnerId         := 0        :: Integer
                                                               , inUnitId            := 0        :: Integer
                                                               , inDiscountPartnerId := 0        :: Integer
                                                               , inTaxKindId         := 0        :: Integer
                                                               , inEngineId          := NULL
                                                               , inSession           := inSession:: TVarChar
                                                                );

         ELSEIF vbNotRename = FALSE
            -- если название другое
            AND NOT EXISTS (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.Id = vbGoods_GoodsChildId AND Object.ValueData ILIKE TRIM (vbGoods_GoodsChildName))
         THEN
            -- меняем только название
            PERFORM lpUpdate_Object_ValueData (vbGoods_GoodsChildId, TRIM (vbGoods_GoodsChildName) :: TVarChar, vbUserId);

            -- еще сохранили связь с <Группой товара>
            IF vbGroup_GoodsChildId > 0 THEN PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroup(), vbGoods_GoodsChildId, vbGroup_GoodsChildId); END IF;

            -- еще сохранили связь с <ProdColor>
            IF vbProdColorId > 0 THEN PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_ProdColor(), vbGoods_GoodsChildId, vbProdColorId); END IF;

            -- еще сохранили <Comment>
            IF vbComment_master <> '' THEN PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_Comment(), vbGoods_GoodsChildId, vbComment_master); END IF;

         ELSE
            -- сохранили связь с <Группой товара>
            IF vbGroup_GoodsChildId > 0 THEN PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroup(), vbGoods_GoodsChildId, vbGroup_GoodsChildId); END IF;

            -- еще сохранили связь с <ProdColor>
            IF vbProdColorId > 0 THEN PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_ProdColor(), vbGoods_GoodsChildId, vbProdColorId); END IF;

            -- еще сохранили <Comment>
            IF vbComment_master <> '' THEN PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_Comment(), vbGoods_GoodsChildId, vbComment_master); END IF;

         END IF;

     END IF;


     -- ********* Узлы *********

     -- если НЕ лодка
     IF vbReceiptProdModel = FALSE
     THEN
         -- если есть Артикул
         IF inArticle <> ''
         THEN
            -- поиск по артикулу
            vbGoodsId := (SELECT ObjectString_Article.ObjectId
                          FROM ObjectString AS ObjectString_Article
                               INNER JOIN Object ON Object.Id       = ObjectString_Article.ObjectId
                                                AND Object.DescId   = zc_Object_Goods()
                                                AND Object.isErased = FALSE
                          WHERE ObjectString_Article.ValueData ILIKE TRIM (inArticle)
                            AND ObjectString_Article.DescId    = zc_ObjectString_Article()
                          --LIMIT 1
                         );

            -- если не нашли
            IF COALESCE (vbGoodsId, 0)  = 0 --AND vbNotRename = TRUE
            THEN
               -- поиск по названию
               vbGoodsId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ValueData ILIKE TRIM (inGoodsName) AND Object.isErased = FALSE);
            END IF;

         ELSE
             -- поиск по названию
             -- vbGoodsId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ValueData ILIKE TRIM (inGoodsName) AND Object.isErased = FALSE);
             RAISE EXCEPTION 'Ошибка.Не установлено значение inArticle для <%>.', inGoodsName;
         END IF;


         -- группа товара пробуем найти
         vbGoodsGroupId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsGroup() AND Object.ValueData = TRIM (inGroupName));

         -- если нет такой группы создаем
         IF COALESCE (vbGoodsGroupId, 0) = 0 AND TRIM (inGroupName) <> ''
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

         -- не ВСЕГДА - создание/корректировка товара Master
         IF COALESCE (vbGoodsId, 0) = 0
         THEN

            raise notice 'Value 02: Не нашли Master';

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
                                                    , inComment           := CASE WHEN vbComment_master <> '' THEN vbComment_master
                                                                                  ELSE COALESCE ((SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.ObjectId = vbGoodsId AND OS.DescId = zc_ObjectString_Goods_Comment()), '')
                                                                             END
                                                    , inIsArc             := FALSE    :: Boolean
                                                    , inFeet              := 0        :: TFloat
                                                    , inMetres            := 0        :: TFloat
                                                    , inAmountMin         := 0        :: TFloat
                                                    , inAmountRefer       := 0        :: TFloat
                                                    , inEKPrice           := 0        :: TFloat
                                                    , inEmpfPrice         := 0        :: TFloat
                                                    , inGoodsGroupId      := CASE WHEN vbGoodsGroupId > 0
                                                                                  THEN vbGoodsGroupId
                                                                                  ELSE (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbGoodsId AND OL.DescId = zc_ObjectLink_Goods_GoodsGroup())
                                                                             END
                                                    , inMeasureId         := 0        :: Integer
                                                    , inGoodsTagId        := 0        :: Integer
                                                    , inGoodsTypeId       := 0        :: Integer
                                                    , inGoodsSizeId       := 0        :: Integer
                                                    , inProdColorId       := CASE WHEN vbProdColorId > 0
                                                                                  THEN vbProdColorId
                                                                                  ELSE (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbGoodsId AND OL.DescId = zc_ObjectLink_Goods_ProdColor())
                                                                             END
                                                    , inPartnerId         := 0        :: Integer
                                                    , inUnitId            := 0        :: Integer
                                                    , inDiscountPartnerId := 0       :: Integer
                                                    , inTaxKindId         := 0        :: Integer
                                                    , inEngineId          := NULL
                                                    , inSession           := inSession:: TVarChar
                                                     );


         -- если название другое
         ELSEIF vbNotRename = FALSE
            AND NOT EXISTS (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.Id = vbGoodsId AND Object.ValueData ILIKE TRIM (inGoodsName))
         THEN
            -- меняем только название
            PERFORM lpUpdate_Object_ValueData (vbGoodsId, TRIM (inGoodsName) :: TVarChar, vbUserId) ;

            -- еще сохранили связь с <Группой товара>
            IF vbGoodsGroupId > 0 THEN PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroup(), vbGoodsId, vbGoodsGroupId); END IF;
            
            -- еще сохранили связь с <ProdColor>
            IF vbProdColorId > 0 THEN PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_ProdColor(), vbGoodsId, vbProdColorId); END IF;

            -- еще сохранили <Comment>
            IF vbComment_master <> '' THEN PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_Comment(), vbGoodsId, vbComment_master); END IF;

            -- пересохранили свойство
            PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Article(), vbGoodsId, inArticle);

         ELSE
            -- сохранили связь с <Группой товара>
            IF vbGoodsGroupId > 0 THEN PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroup(), vbGoodsId, vbGoodsGroupId); END IF;

            -- еще сохранили связь с <ProdColor>
            IF vbProdColorId > 0 THEN PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_ProdColor(), vbGoodsId, vbProdColorId); END IF;

            -- еще сохранили <Comment>
            IF vbComment_master <> '' THEN PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_Comment(), vbGoodsId, vbComment_master); END IF;

            -- пересохранили свойство
            PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Article(), vbGoodsId, inArticle);

         END IF;

     END IF;


     -- ********* Комплектующие *********

     -- Товар - Child
     IF COALESCE (inGoodsName_child, '') <> ''
     THEN
         -- если есть Артикул
         IF TRIM (inArticle_child) <> ''
         THEN
             -- поиск по артикулу
             vbGoodsId_child := (SELECT ObjectString_Article.ObjectId
                                 FROM ObjectString AS ObjectString_Article
                                      INNER JOIN Object ON Object.Id       = ObjectString_Article.ObjectId
                                                       AND Object.DescId   = zc_Object_Goods()
                                                       AND Object.isErased = FALSE
                                 WHERE ObjectString_Article.ValueData ILIKE TRIM (inArticle_child)
                                   AND ObjectString_Article.DescId    = zc_ObjectString_Article()
                                 --LIMIT 1
                                );

             -- если не нашли
             IF COALESCE (vbGoodsId_child, 0) = 0
             THEN
                 -- поиск по названию
                vbGoodsId_child := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ValueData ILIKE TRIM (inGoodsName_child) AND Object.isErased = FALSE);
             END IF;

             -- если нашли
             IF vbGoodsId_child <> 0
                -- если названию другое
                AND NOT EXISTS (SELECT 1 FROM Object WHERE Object.Id = vbGoodsId_child AND Object.DescId = zc_Object_Goods() AND Object.ValueData ILIKE TRIM (inGoodsName_child))
                --
                AND inGoodsName_child NOT ILIKE 'ПФ%'
             THEN
                 -- заменяем название товара "последним" значением, т.к. у одного артикула могут быть разные названия
                 UPDATE Object SET ValueData = TRIM (inGoodsName_child) WHERE Object.Id = vbGoodsId_child AND Object.DescId = zc_Object_Goods();

                 /*RAISE EXCEPTION 'Ошибка.Для Артикул = <%>%разные названия комплектующих %<%> %<%> %<%> %<%> %'
                                  , inArticle_child
                                  , CHR (13)
                                  , CHR (13)
                                  , TRIM (inGoodsName_child)
                                  , CHR (13)
                                  , (SELECT Object.ValueData FROM Object WHERE Object.Id = vbGoodsId_child)
                                  , CHR (13)
                                  , vbGoodsId_child
                                  , CHR (13)
                                  , inNPP
                                  , CHR (13)
                                   ;*/
             END IF;

         ELSE
             -- поиск по названию
             vbGoodsId_child := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ValueData ILIKE TRIM (inGoodsName_child) AND Object.isErased = FALSE);

         END IF;


         -- группа товара пробуем найти
         vbGoodsGroupId_child := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsGroup() AND Object.ValueData = TRIM (inGroupName_child));
         -- если нет такой группы создаем
         IF COALESCE (vbGoodsGroupId_child, 0) = 0 AND TRIM (inGroupName_child) <> ''
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

         -- не ВСЕГДА - создание/корректировка товара Child
         IF COALESCE (vbGoodsId_child, 0) = 0
         THEN

            raise notice 'Value 03: Не нашли Child';

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
                                                          , inComment          := COALESCE ((SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.ObjectId = vbGoodsId_child AND OS.DescId = zc_ObjectString_Goods_Comment()), '')
                                                          , inIsArc            := FALSE    :: Boolean
                                                          , inFeet             := 0        :: TFloat
                                                          , inMetres           := 0        :: TFloat
                                                          , inAmountMin        := 0        :: TFloat
                                                          , inAmountRefer      := 0        :: TFloat
                                                          , inEKPrice          := 0        :: TFloat
                                                          , inEmpfPrice        := 0        :: TFloat
                                                          , inGoodsGroupId     := CASE WHEN vbGoodsGroupId_child > 0
                                                                                       THEN vbGoodsGroupId_child
                                                                                       ELSE (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbGoodsId_child AND OL.DescId = zc_ObjectLink_Goods_GoodsGroup())
                                                                                  END
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
            -- если название другое
            AND NOT EXISTS (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.Id = vbGoodsId_child AND Object.ValueData ILIKE TRIM (inGoodsName_child))
         THEN
             -- меняем только название
             PERFORM lpUpdate_Object_ValueData (vbGoodsId_child, TRIM (inGoodsName_child) :: TVarChar, vbUserId) ;
         END IF;

     END IF;


     -- ********* Шаблоны сборки *********

     -- Шаблон сборки узла
     IF vbReceiptProdModel = FALSE
     THEN

       -- поиск сборка ReceiptGoods
       vbReceiptGoodsId := (SELECT ObjectLink.ObjectId
                            FROM ObjectLink
                                  INNER JOIN Object AS Object_ReceiptGoods ON Object_ReceiptGoods.Id       = ObjectLink.ObjectId
                                                                          AND Object_ReceiptGoods.isErased = FALSE
                            WHERE ObjectLink.DescId        = zc_ObjectLink_ReceiptGoods_Object()
                              AND ObjectLink.ChildObjectId = vbGoodsId
                           );

       -- Если первый №п/п загрузки, удаляем все содержимое сборки узла
       IF inNPP :: Integer = 1 AND vbReceiptGoodsId > 0
       THEN
           -- удаление
           PERFORM gpUpdate_Object_isErased_ReceiptGoodsChild (inObjectId := Object_ReceiptGoodsChild.Id
                                                             , inIsErased := TRUE
                                                             , inSession  := inSession
                                                              )
           FROM Object AS Object_ReceiptGoodsChild
                -- Шаблон сборка Модели
                INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                      ON ObjectLink_ReceiptGoods.ObjectId      = Object_ReceiptGoodsChild.Id
                                     AND ObjectLink_ReceiptGoods.DescId        = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                     AND ObjectLink_ReceiptGoods.ChildObjectId = vbReceiptGoodsId
           WHERE Object_ReceiptGoodsChild.DescId   = zc_Object_ReceiptGoodsChild()
             AND Object_ReceiptGoodsChild.isErased = FALSE
          ;

       END IF;

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
           vbReceiptLevelId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ReceiptLevel() AND Object.ValueData = TRIM (vbReceiptLevelName_find));

           -- если нет такого Этап сборки
           IF COALESCE (vbReceiptLevelId, 0) = 0
           THEN
                vbReceiptLevelId := (SELECT tmp.ioId
                                     FROM gpInsertUpdate_Object_ReceiptLevel (ioId              := 0         :: Integer
                                                                            , ioCode            := 0         :: Integer
                                                                            , inName            := TRIM (vbReceiptLevelName_find) ::TVarChar
                                                                            , inShortName       := TRIM (vbReceiptLevelName_find) ::TVarChar
                                                                            , inObjectDesc      := 'zc_Object_ReceiptGoods'  ::TVarChar
                                                                            , inSession         := inSession :: TVarChar
                                                                             ) AS tmp);
           END IF;

       END IF;

       -- ищем ReceiptGoodsChild
       vbReceiptGoodsChildId := (SELECT Object_ReceiptGoodsChild.Id
                                 FROM Object AS Object_ReceiptGoodsChild
                                      INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                                            ON ObjectLink_ReceiptGoods.ObjectId      = Object_ReceiptGoodsChild.Id
                                                           AND ObjectLink_ReceiptGoods.DescId        = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                                           AND ObjectLink_ReceiptGoods.ChildObjectId = vbReceiptGoodsId
                                      -- NPP
                                      INNER JOIN ObjectFloat AS ObjectFloat_NPP
                                                             ON ObjectFloat_NPP.ObjectId  = Object_ReceiptGoodsChild.Id
                                                            AND ObjectFloat_NPP.DescId    = zc_ObjectFloat_ReceiptGoodsChild_NPP()
                                                            AND ObjectFloat_NPP.ValueData = inNPP :: Integer
                                 WHERE Object_ReceiptGoodsChild.DescId = zc_Object_ReceiptGoodsChild()
                                   AND Object_ReceiptGoodsChild.isErased = FALSE
                                );

       /*IF inReceiptLevelName ILIKE 'fender'
         THEN
             RAISE EXCEPTION 'Ошибка.<%>  <%>'
             , inReceiptLevelName
             , vbReceiptGoodsChildId
         END IF;*/


         -- тест
         --IF inReceiptLevelName ILIKE 'Steering console'
         IF 1=0 -- inArticle_child = '54890600251'
         THEN
           RAISE EXCEPTION 'Ошибка.<%>  <%>  <%>  <%>   <%>   <%>   <%>   <%>   <%>'
                       , (inArticle)
                       , vbReceiptGoodsChildId
                       , lfGet_Object_ValueData (vbGoods_GoodsChildId)
                       , inArticle_child

                       , vbReceiptGoodsId
                       , vbGoodsId_child

                       , vbProdColorPatternId
                       , vbGoods_GoodsChildId
                       , vbReceiptLevelId
                          ;
         END IF;

       -- всегда замена
       IF 1=1
       THEN
           -- если не нашли создаем или правим если надо
           vbReceiptGoodsChildId := (SELECT tmp.ioId
                                     FROM gpInsertUpdate_Object_ReceiptGoodsChild (ioId                 := COALESCE (vbReceiptGoodsChildId,0) ::Integer
                                                                                 , inComment            := COALESCE ((SELECT OC.ValueData FROM Object AS OC
                                                                                                                      WHERE OC.Id = COALESCE (vbReceiptGoodsChildId, 0)
                                                                                                                        AND OC.DescId = zc_Object_ReceiptGoodsChild()), '') ::TVarChar
                                                                                 , inNPP                := inNPP                ::Integer
                                                                                 , inReceiptGoodsId     := vbReceiptGoodsId     ::Integer
                                                                                 , inObjectId           := vbGoodsId_child      ::Integer
                                                                                 , inProdColorPatternId := vbProdColorPatternId ::Integer
                                                                                 , inMaterialOptionsId  := vbMaterialOptionsId -- (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = vbReceiptGoodsChildId AND OL.DescId = zc_ObjectLink_ReceiptGoodsChild_MaterialOptions()))  ::Integer
                                                                                 , inReceiptLevelId_top := 0                    ::Integer
                                                                                 , inReceiptLevelId     := vbReceiptLevelId     ::Integer
                                                                                 , inGoodsChildId       := vbGoods_GoodsChildId ::Integer
                                                                                 , ioValue              := vbAmount             ::TVarChar
                                                                                 , ioValue_service      :='0'                   ::TVarChar
                                                                                 , ioForCount           := vbForCount
                                                                                 , inIsEnabled          := TRUE                 ::Boolean
                                                                                 , inSession            := inSession            ::TVarChar
                                                                                  ) AS tmp);

           -- еще это св-во
           -- PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ReceiptGoodsChild_NPP(), vbReceiptGoodsChildId, inNPP :: Integer);

       END IF;
     END IF;

     -- Шаблон сборки лодки
     IF vbReceiptProdModel = TRUE
     THEN
       -- поиск Шаблон сборка Модели
       vbReceiptProdModelId := (SELECT Object.Id
                                FROM Object
                                     LEFT JOIN ObjectLink AS ObjectLink_Model
                                                          ON ObjectLink_Model.ObjectId = Object.Id
                                                         AND ObjectLink_Model.DescId = zc_ObjectLink_ReceiptProdModel_Model()
                                     -- поиск по Модели
                                     INNER JOIN Object AS Object_Model ON Object_Model.Id = ObjectLink_Model.ChildObjectId
                                                                      -- здесь Модель
                                                                      AND Object_Model.ValueData ILIKE TRIM (SPLIT_PART (inArticle, '-', 2))
                                WHERE Object.DescId   = zc_Object_ReceiptProdModel()
                                  AND Object.isErased = FALSE
                               );

         -- Этап сборки пробуем найти
       IF COALESCE (vbReceiptLevelName_find, '') <> ''
       THEN

           -- Этап сборки пробуем найти
           vbReceiptLevelId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ReceiptLevel() AND Object.ValueData = TRIM (vbReceiptLevelName_find));

           -- если нет такого Этап сборки
           IF COALESCE (vbReceiptLevelId, 0) = 0
           THEN
                vbReceiptLevelId := (SELECT tmp.ioId
                                     FROM gpInsertUpdate_Object_ReceiptLevel (ioId              := 0         :: Integer
                                                                            , ioCode            := 0         :: Integer
                                                                            , inName            := TRIM (vbReceiptLevelName_find) ::TVarChar
                                                                            , inShortName       := TRIM (vbReceiptLevelName_find) ::TVarChar
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


   -- сохранили
   IF vbMeasureName  <> ''
   THEN
       vbMeasureId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE vbMeasureName LIMIT 1);
       IF COALESCE (vbMeasureId, 0) = 0
       THEN
           -- сохранили
           vbMeasureId := lpInsertUpdate_Object (vbMeasureId, zc_Object_Measure(), 0, vbMeasureName);
       END IF;

        -- сохранили
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Measure(), vbGoodsId_child, vbMeasureId);

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
