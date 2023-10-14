-- Function: gpInsert_Object_GoodsPropertyValue_byGoodsProperty()

DROP FUNCTION IF EXISTS gpInsert_Object_GoodsPropertyValue_byGoodsProperty (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Object_GoodsPropertyValue_byGoodsProperty(
    IN inGoodsPropertyId       Integer   ,    -- Классификатор свойств товаров
    IN inGoodsPropertyId_mask  Integer   ,    -- Классификатор свойств товаров - откуда копировать свойства
    IN inSession               TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
 BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_GoodsPropertyValue());

   -- проверка
   IF COALESCE (inGoodsPropertyId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не установлено значение <Классификатор свойств товаров>.';
   END IF;
   -- проверка
   IF COALESCE (inGoodsPropertyId_mask, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не установлено значение <Классификатор свойств товаров> для копирования.';
   END IF;
  
   --сохраняем элементы из выбранного классификатора
   PERFORM gpInsertUpdate_Object_GoodsPropertyValue (ioId             := 0                  :: Integer       -- ключ объекта <Значения свойств товаров для классификатора>
                                                   , inName           := tmp.Name           :: TVarChar      -- Название товара(покупателя)
                                                   , inAmount         := tmp.Amount         :: TFloat        -- Кол-во штук при сканировании
                                                   , inBoxCount       := tmp.BoxCount       :: TFloat        -- Кол-во единиц в ящике
                                                   , inBarCode        := tmp.BarCode        :: TVarChar      -- Штрих-код
                                                   , inArticle        := tmp.Article        :: TVarChar      -- Артикул
                                                   , inBarCodeGLN     := tmp.BarCodeGLN     :: TVarChar      -- Штрих-код GLN
                                                   , inArticleGLN     := tmp.ArticleGLN     :: TVarChar      -- Артикул GLN
                                                   , inGroupName      := tmp.GroupName      :: TVarChar      -- Название группы
                                                   , inGoodsPropertyId:= inGoodsPropertyId  :: Integer       -- Классификатор свойств товаров
                                                   , inGoodsId        := tmp.GoodsId        :: Integer       -- Товары
                                                   , inGoodsKindId    := tmp.GoodsKindId    :: Integer       -- Виды товара
                                                   , inGoodsBoxId     := tmp.GoodsBoxId     :: Integer       -- Товары (гофроящик) 
                                                   , inGoodsKindSubId := tmp.GoodsKindSubId :: Integer       -- Вид товара (факт расход в накладной)
                                                   , inisGoodsKind    := tmp.isGoodsKind    :: Boolean       -- Разрешена отгрузка с таким видом тов.
                                                   , inSession        := inSession          :: TVarChar
                                                   )
   FROM gpSelect_Object_GoodsPropertyValue (inGoodsPropertyId := inGoodsPropertyId_mask, inShowAll:= False, inSession := inSession) AS tmp

        LEFT JOIN (SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                   AS GoodsId
                        , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                   FROM ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                        INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                              ON ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId = ObjectLink_GoodsPropertyValue_Goods.ObjectId
                                             AND ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = inGoodsPropertyId
                                             AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                        LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                             ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_Goods.ObjectId
                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                   WHERE ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                   ) AS tmpGoodsProperty ON tmpGoodsProperty.GoodsId     = tmp.GoodsId
                                        AND tmpGoodsProperty.GoodsKindId = tmp.GoodsKindId
   WHERE tmpGoodsProperty.GoodsId IS NULL; 
    

   if vbUserId = 5 OR vbUserId = 9457
   then
       RAISE EXCEPTION 'Test. Ok';
   end if;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.10.23         *
*/

-- тест
-- SELECT * FROM gpInsert_Object_GoodsPropertyValue_byGoodsProperty()

---SELECT * FROM gpSelect_Object_GoodsPropertyValue (inGoodsPropertyId := 8342227   , inShowAll:= False, inSession := '9457') AS tmp; 