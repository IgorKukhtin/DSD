--

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoods_Load (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReceiptGoods_Load(
    IN inArticle               TVarChar,  -- Артикул-результат
    IN inReceiptLevelName      TVarChar,  -- Название сборки
    IN inGoodsName             TVarChar,  -- Название-результат
    IN inGroupName             TVarChar,  -- Группа-результат
    IN inReplacement           TVarChar,  -- Замена
    IN inArticle_child         TVarChar,  -- Артикул-комплект/узел
    IN inGoodsName_child       TVarChar,  -- Название-комплект/узел
    IN inGroupName_child       TVarChar,  -- Группа-комплект/узел
    IN inAmount                TFloat,    -- Количество
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

   DECLARE vbReceiptLevelId Integer;

   DECLARE vbArticleChild     TVarChar;  -- Артикул-результат
   DECLARE vbGoodsChildName   TVarChar;  -- Название-результат
   DECLARE vbGroupChildName   TVarChar;  -- Группа-результат
   DECLARE vbGoodsChildId Integer;
   DECLARE vbGroupChildId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);
   
   --
   IF COALESCE (TRIM (inGoodsName_child), '') = '' THEN RETURN; END IF;
   
   -- Заменяем А 
   inGoodsName := REPLACE(inGoodsName, chr(1040)||'GL-', 'AGL-');
   inGoodsName_child := REPLACE(inGoodsName_child, chr(1040)||'GL-', 'AGL-');

   -- Если этапы сборки крпуса
   IF (COALESCE (inReceiptLevelName, '') <> '') AND SPLIT_PART (inArticle, '-', 3) = '01' AND SPLIT_PART (inArticle, '-', 4) = '001'
   THEN
     vbArticleChild := inArticle;
     vbGoodsChildName := inGoodsName;
     vbGroupChildName := inGroupName;

     inGoodsName := 'Корпус '||SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2);
     inGroupName := 'Сборка корпуса';
     inArticle := SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2)||'-'||SPLIT_PART (inArticle, '-', 3);

   ELSEIF (COALESCE (inReceiptLevelName, '') = '') AND SPLIT_PART (inArticle, '-', 3) = '01' AND SPLIT_PART (inArticle, '-', 4) = ''
   THEN
     inGoodsName := 'Корпус '||SPLIT_PART (inArticle, '-', 1)||'-'||SPLIT_PART (inArticle, '-', 2);
     inGroupName := 'Сборка корпуса';    
   END IF;

   -- пробуем найти Товар - Child - второго уровня
   IF COALESCE (vbGoodsChildName, '') <> ''
   THEN
       -- по названию
       vbGoodsChildId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ValueData = TRIM (vbGoodsChildName));

          -- ВСЕГДА - создание/корректировка товара Master
          IF COALESCE (vbGoodsId, 0) = 0 OR 1=1
          THEN

             -- группа товара пробуем найти
             vbGroupChildId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsGroup() AND Object.ValueData = TRIM (vbGroupChildName));

             -- если нет такой группы создаем
             IF COALESCE (vbGroupChildId, 0) = 0
             THEN
                  vbGroupChildId := (SELECT tmp.ioId
                                     FROM gpInsertUpdate_Object_GoodsGroup (ioId              := 0         :: Integer
                                                                          , ioCode            := 0         :: Integer
                                                                          , inName            := TRIM (vbGroupChildName) ::TVarChar
                                                                          , inParentId        := 0         :: Integer
                                                                          , inInfoMoneyId     := 0         :: Integer
                                                                          , inModelEtiketenId := 0         :: Integer
                                                                          , inSession         := inSession :: TVarChar
                                                                           ) AS tmp);
             END IF;

             -- создаем Child
             vbGoodsChildId := gpInsertUpdate_Object_Goods (ioId                := COALESCE (vbGoodsChildId, 0) :: Integer
                                                          , inCode              := CASE WHEN COALESCE (vbGoodsChildId, 0) = 0 THEN -1 ELSE 0 END
                                                          , inName              := TRIM (vbGoodsChildName) :: TVarChar
                                                          , inArticle           := TRIM (vbArticleChild)
                                                          , inArticleVergl      := NULL     :: TVarChar
                                                          , inEAN               := NULL     :: TVarChar
                                                          , inASIN              := NULL     :: TVarChar
                                                          , inMatchCode         := NULL     :: TVarChar
                                                          , inFeeNumber         := NULL     :: TVarChar
                                                          , inComment           := NULL     :: TVarChar
                                                          , inIsArc             := FALSE    :: Boolean
                                                          , inAmountMin         := 0        :: TFloat
                                                          , inAmountRefer       := 0        :: TFloat
                                                          , inEKPrice           := 0        :: TFloat
                                                          , inEmpfPrice         := 0        :: TFloat
                                                          , inGoodsGroupId      := vbGroupChildId  :: Integer
                                                          , inMeasureId         := 0        :: Integer
                                                          , inGoodsTagId        := 0        :: Integer
                                                          , inGoodsTypeId       := 0        :: Integer
                                                          , inGoodsSizeId       := 0        :: Integer
                                                          , inProdColorId       := 0        :: Integer
                                                          , inPartnerId         := 0        :: Integer
                                                          , inUnitId            := 0        :: Integer
                                                          , inDiscountPartnerId := 0       :: Integer
                                                          , inTaxKindId         := 0        :: Integer
                                                          , inEngineId          := NULL
                                                          , inSession           := inSession:: TVarChar
                                                           );

          END IF;
   ELSEIF SPLIT_PART (vbArticleChild, '-', 4) = '001'
   THEN
       -- по артиклу
       vbGoodsChildId := (SELECT Object.Id 
                          FROM Object 
                               INNER JOIN ObjectString AS ObjectString_Article
                                                       ON ObjectString_Article.ObjectId = Object.Id
                                                      AND ObjectString_Article.DescId = zc_ObjectString_Article()
                                                      AND ObjectString_Article.ValueData = TRIM (vbArticleChild)
                          WHERE Object.DescId = zc_Object_Goods()
                          LIMIT 1);
   END IF;

   -- пробуем найти Товар - Master
   IF COALESCE (inGoodsName, '') <> ''
   THEN
       -- по названию
       vbGoodsId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ValueData = TRIM (inGoodsName));

/*     -- по артикулу
       vbGoodsId := (SELECT ObjectString_Article.ObjectId
                     FROM ObjectString AS ObjectString_Article
                          INNER JOIN Object ON Object.Id       = ObjectString_Article.ObjectId
                                           AND Object.DescId   = zc_Object_Goods()
                                           AND Object.isErased = FALSE
                     WHERE ObjectString_Article.ValueData = inArticle
                       AND ObjectString_Article.DescId    = zc_ObjectString_Article()
                     LIMIT 1
                    );
*/

          -- ВСЕГДА - создание/корректировка товара Master
          IF COALESCE (vbGoodsId, 0) = 0 OR 1=1
          THEN

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
                                                     , inComment           := NULL     :: TVarChar
                                                     , inIsArc             := FALSE    :: Boolean
                                                     , inAmountMin         := 0        :: TFloat
                                                     , inAmountRefer       := 0        :: TFloat
                                                     , inEKPrice           := 0        :: TFloat
                                                     , inEmpfPrice         := 0        :: TFloat
                                                     , inGoodsGroupId      := vbGoodsGroupId  :: Integer
                                                     , inMeasureId         := 0        :: Integer
                                                     , inGoodsTagId        := 0        :: Integer
                                                     , inGoodsTypeId       := 0        :: Integer
                                                     , inGoodsSizeId       := 0        :: Integer
                                                     , inProdColorId       := 0        :: Integer
                                                     , inPartnerId         := 0        :: Integer
                                                     , inUnitId            := 0        :: Integer
                                                     , inDiscountPartnerId := 0       :: Integer
                                                     , inTaxKindId         := 0        :: Integer
                                                     , inEngineId          := NULL
                                                     , inSession           := inSession:: TVarChar
                                                      );

          END IF;
   END IF;


   -- пробуем найти Товар - Child
   IF COALESCE (inGoodsName_child, '') <> ''
   THEN
       -- по названию
       vbGoodsId_child := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ValueData = TRIM (inGoodsName_child));

/*     -- по артикулу
       vbGoodsId_child := (SELECT ObjectString_Article.ObjectId
                           FROM ObjectString AS ObjectString_Article
                                INNER JOIN Object ON Object.Id       = ObjectString_Article.ObjectId
                                                 AND Object.DescId   = zc_Object_Goods()
                                                 AND Object.isErased = FALSE
                           WHERE ObjectString_Article.ValueData = inArticle_child
                             AND ObjectString_Article.DescId    = zc_ObjectString_Article()
                           LIMIT 1
                          );
*/

          -- ВСЕГДА - создание/корректировка товара Child
          IF COALESCE (vbGoodsId_child, 0) = 0 OR 1=1
          THEN
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
                                                           , inComment          := NULL     :: TVarChar
                                                           , inIsArc            := FALSE    :: Boolean
                                                           , inAmountMin        := 0        :: TFloat
                                                           , inAmountRefer      := 0        :: TFloat
                                                           , inEKPrice          := 0        :: TFloat
                                                           , inEmpfPrice        := 0        :: TFloat
                                                           , inGoodsGroupId     := vbGoodsGroupId_child  :: Integer
                                                           , inMeasureId        := 0        :: Integer
                                                           , inGoodsTagId       := 0        :: Integer
                                                           , inGoodsTypeId      := 0        :: Integer
                                                           , inGoodsSizeId      := 0        :: Integer
                                                           , inProdColorId      := 0        :: Integer
                                                           , inPartnerId        := 0        :: Integer
                                                           , inUnitId           := 0        :: Integer
                                                           , inDiscountPartnerId := 0       :: Integer
                                                           , inTaxKindId        := 0        :: Integer
                                                           , inEngineId         := NULL
                                                           , inSession          := inSession:: TVarChar
                                                            );

          END IF;
   END IF;


   --- ищем ReceiptGoods
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
                                                              , inColorPatternId   := 0
                                                              , inGoodsId          := vbGoodsId
                                                              , inisMain           := TRUE     :: Boolean
                                                              , inUserCode         := ''       :: TVarChar
                                                              , inComment          := NULL     :: TVarChar
                                                              , inSession          := inSession:: TVarChar
                                                               );
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
                             WHERE Object_ReceiptGoodsChild.DescId = zc_Object_ReceiptGoodsChild()
                               AND Object_ReceiptGoodsChild.isErased = FALSE
                             );

   IF COALESCE (inReceiptLevelName, '') <> '' AND COALESCE (vbGoodsChildId, 0) <> 0
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

   IF COALESCE (vbReceiptGoodsChildId, 0) = 0
   THEN
       -- если не нашли создаем
       vbReceiptGoodsChildId := (SELECT tmp.ioId
                                 FROM gpInsertUpdate_Object_ReceiptGoodsChild (ioId                 := COALESCE (vbReceiptGoodsChildId,0) ::Integer
                                                                             , inComment            := ''               ::TVarChar
                                                                             , inReceiptGoodsId     := vbReceiptGoodsId ::Integer
                                                                             , inObjectId           := vbGoodsId_child  ::Integer
                                                                             , inProdColorPatternId := 0                ::Integer
                                                                             , inMaterialOptionsId  := 0                ::Integer
                                                                             , inReceiptLevelId_top := 0                ::Integer
                                                                             , inReceiptLevelId     := vbReceiptLevelId ::Integer
                                                                             , inGoodsChildId       := vbGoodsChildId   ::Integer
                                                                             , ioValue              := inAmount         ::TFloat
                                                                             , ioValue_service      := 0                ::TFloat
                                                                             , inIsEnabled          := TRUE             ::Boolean
                                                                             , inSession            := inSession        ::TVarChar
                                                                              ) AS tmp);
   END IF;

   RAISE EXCEPTION 'Goods Main <%> <%> <%> <%> <%> %Goods child 2 <%> <%> <%> <%> <%> <%>  %Goods child <%> <%> <%> <%> <%> %ReceiptGoods <%> %ReceiptGoodsChild <%> <%>', 
               inArticle, inGoodsName, inGroupName, vbGoodsId, vbGoodsGroupId, Chr(13), 
               inReceiptLevelName, vbArticleChild, vbGoodsChildName, vbGroupChildName, vbGoodsChildId, vbGroupChildId, Chr(13),
               inArticle_child, inGoodsName_child, vbGoodsId_child, inGroupName_child, vbGoodsGroupId_child, Chr(13),
               vbReceiptGoodsId, Chr(13),
               vbReceiptGoodsChildId, vbReceiptLevelId; 

   RAISE EXCEPTION 'В работе'; 

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
-- 


SELECT * FROM gpInsertUpdate_Object_ReceiptGoods_Load('AGL-280-01-001', 'HULL/(Корпус)', '', '', '', '2100535557', 'CUROX M-303', 'Стеклопластик ПФ', 0.145, zfCalc_UserAdmin())