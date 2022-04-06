--
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoods_Load (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TVarChar);
                                                              

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReceiptGoods_Load(
    IN inArticle               TVarChar,
    IN inGoodsName             TVarChar,
    IN inGroupName             TVarChar,
    IN inArticle_child         TVarChar,
    IN inGoodsName_child       TVarChar,
    IN inGroupName_child       TVarChar,
    IN inAmount                TFloat  ,
    IN inSession               TVarChar       -- сессия пользователя
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

BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);

   --
   IF COALESCE (TRIM (inGoodsName), '') = '' THEN RETURN; END IF;


   -- пробуем найти Товар 1
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

          -- Eсли не нашли создаем товар
          IF COALESCE (vbGoodsId,0) = 0
          THEN

             --группа товара пробуем найти
             vbGoodsGroupId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsGroup() AND Object.ValueData = TRIM (inGroupName));
             --если нет такой группы создаем
             IF COALESCE (vbGoodsGroupId,0) = 0
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

             -- создаем
             vbGoodsId := gpInsertUpdate_Object_Goods(ioId               := COALESCE (vbGoodsId,0)::  Integer
                                                    , inCode             := lfGet_ObjectCode(0, zc_Object_Goods())    :: Integer
                                                    , inName             := TRIM (inGoodsName) :: TVarChar
                                                    , inArticle          := TRIM (inArticle)
                                                    , inArticleVergl     := Null     :: TVarChar
                                                    , inEAN              := Null     :: TVarChar
                                                    , inASIN             := Null     :: TVarChar
                                                    , inMatchCode        := Null     :: TVarChar 
                                                    , inFeeNumber        := Null     :: TVarChar
                                                    , inComment          := Null     :: TVarChar
                                                    , inIsArc            := FALSE    :: Boolean
                                                    , inAmountMin        := 0        :: TFloat
                                                    , inAmountRefer      := 0        :: TFloat
                                                    , inEKPrice          := 0        :: TFloat
                                                    , inEmpfPrice        := 0        :: TFloat
                                                    , inGoodsGroupId     := vbGoodsGroupId  :: Integer  
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

   -- пробуем найти Товар 2
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

          -- Eсли не нашли создаем товар
          IF COALESCE (vbGoodsId_child,0) = 0
          THEN

             --группа товара пробуем найти
             vbGoodsGroupId_child := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsGroup() AND Object.ValueData = TRIM (inGroupName_child));
             --если нет такой группы создаем
             IF COALESCE (vbGoodsGroupId_child,0) = 0
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

             -- создаем
             vbGoodsId_child := gpInsertUpdate_Object_Goods(ioId               := COALESCE (vbGoodsId_child,0)::  Integer
                                                          , inCode             := lfGet_ObjectCode(0, zc_Object_Goods())    :: Integer
                                                          , inName             := TRIM (inGoodsName_child) :: TVarChar
                                                          , inArticle          := TRIM (inArticle_child)
                                                          , inArticleVergl     := Null     :: TVarChar
                                                          , inEAN              := Null     :: TVarChar
                                                          , inASIN             := Null     :: TVarChar
                                                          , inMatchCode        := Null     :: TVarChar 
                                                          , inFeeNumber        := Null     :: TVarChar
                                                          , inComment          := Null     :: TVarChar
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
                        WHERE ObjectLink.DescId = zc_ObjectLink_ReceiptGoods_Object()
                          AND ObjectLink.ChildObjectId = vbGoodsId
                        );

   IF COALESCE (vbReceiptGoodsId,0) = 0
   THEN
       --если не нашли создаем
       vbReceiptGoodsId :=  gpInsertUpdate_Object_ReceiptGoods(ioId               := 0   :: Integer
                                                             , inCode             := 0   :: Integer
                                                             , inName             := TRIM (inGoodsName) :: TVarChar
                                                             , inColorPatternId   := 0
                                                             , inGoodsId          := vbGoodsId
                                                             , inisMain           := FALSE    :: Boolean
                                                             , inUserCode         := ''       :: TVarChar
                                                             , inComment          := Null     :: TVarChar
                                                             , inSession          := inSession:: TVarChar
                                                             );
   END IF;

   --ищем ReceiptGoodsChild
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

   IF COALESCE (vbReceiptGoodsChildId,0) = 0
   THEN
       --если не нашли создаем
       PERFORM gpInsertUpdate_Object_ReceiptGoodsChild(ioId                 := COALESCE (vbReceiptGoodsChildId,0) ::Integer
                                                     , inComment            := ''               ::TVarChar
                                                     , inReceiptGoodsId     := vbReceiptGoodsId ::Integer   
                                                     , inObjectId           := vbGoodsId_child  ::Integer   
                                                     , inProdColorPatternId := 0                ::Integer   
                                                     , ioValue              := inAmount         ::TFloat    
                                                     , ioValue_service      := 0                ::TFloat    
                                                     , inIsEnabled          := TRUE             ::Boolean   
                                                     , inSession            := inSession        ::TVarChar
                                                     );
   END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.04.22         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ReceiptGoods_Load()