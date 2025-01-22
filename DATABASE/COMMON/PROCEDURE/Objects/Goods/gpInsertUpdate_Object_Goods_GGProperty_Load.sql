 -- Function: gpInsertUpdate_Object_Goods_GGProperty_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods_GGProperty_Load (Integer, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods_GGProperty_Load (Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods_GGProperty_Load(
    IN inGoodsCode                        Integer   , -- Код объекта <Товар>
    IN inGoodsName                        TVarChar  ,
    IN inGoodsGroupPropertyName           TVarChar    , -- вес
    IN inGoodsGroupPropertyName_parent    TVarChar    , -- вес втулки
    IN inSession                          TVarChar    -- сессия пользователя
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbGoodsGroupPropertyId Integer;
   DECLARE vbGoodsGroupPropertyId_parent Integer;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     IF inGoodsCode > 0
     THEN
         -- !!!поиск ИД товара!!!
         vbGoodsId:= (SELECT Object_Goods.Id
                      FROM Object AS Object_Goods
                      WHERE Object_Goods.ObjectCode = inGoodsCode
                        AND Object_Goods.DescId     = zc_Object_Goods()
                        AND inGoodsCode > 0
                     );
     ELSE
         --пробуем найти по названию
         -- !!!поиск ИД товара!!!
         vbGoodsId:= (SELECT Object_Goods.Id
                      FROM Object AS Object_Goods
                      WHERE TRIM (Object_Goods.ValueData) ILIKE TRIM (inGoodsName)
                        AND Object_Goods.DescId     = zc_Object_Goods()
                        AND inGoodsCode = 0
                     );
     END IF;

     -- Проверка
     IF COALESCE (vbGoodsId, 0) = 0
     THEN
        -- !!!Пустой код - Пропустили!!!
        RETURN;
        --
        -- RAISE EXCEPTION 'Ошибка.Не найден Товар с Код = <%> .', inGoodsCode;
     END IF;

     -- Проверка
     IF TRIM (inGoodsGroupPropertyName) = ''
     THEN
        RAISE EXCEPTION 'Ошибка.Не найден Классификатор для Код = <%> .', inGoodsCode;
     END IF;



   -- Группа классификатора
   vbGoodsGroupPropertyId_parent := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsGroupProperty() AND TRIM (inGoodsGroupPropertyName_parent) <> '' AND TRIM (Object.ValueData) ILIKE TRIM (inGoodsGroupPropertyName_parent));
   -- если не находим создаем
   IF COALESCE (vbGoodsGroupPropertyId_parent,0) = 0 AND TRIM (inGoodsGroupPropertyName_parent) <> ''
   THEN
        vbGoodsGroupPropertyId_parent := (SELECT tmp.ioId
                                          FROM gpInsertUpdate_Object_GoodsGroupProperty (ioId           := 0         :: Integer
                                                                                       , inCode         := 0         :: Integer
                                                                                       , inName         := TRIM (inGoodsGroupPropertyName_parent) :: TVarChar
                                                                                       , inParentId     := Null      :: Integer
                                                                                       , inSession      := inSession :: TVarChar
                                                                                        ) AS tmp);
   END IF;

   -- классификатор
   vbGoodsGroupPropertyId := (SELECT Object.Id
                              FROM Object
                                   LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupProperty_Parent
                                                        ON ObjectLink_GoodsGroupProperty_Parent.ObjectId = Object.Id
                                                       AND ObjectLink_GoodsGroupProperty_Parent.DescId = zc_ObjectLink_GoodsGroupProperty_Parent()
                              WHERE Object.DescId = zc_Object_GoodsGroupProperty()
                                AND TRIM (Object.ValueData) ILIKE TRIM (inGoodsGroupPropertyName)
                                AND COALESCE (ObjectLink_GoodsGroupProperty_Parent.ChildObjectId, 0) = COALESCE (vbGoodsGroupPropertyId_parent, 0)
                             );
   -- если не находим создаем
   IF COALESCE (vbGoodsGroupPropertyId,0) = 0
   THEN
         vbGoodsGroupPropertyId := (SELECT tmp.ioId
                                   FROM gpInsertUpdate_Object_GoodsGroupProperty (ioId           := COALESCE (vbGoodsGroupPropertyId,0)         :: Integer
                                                                                , inCode         := 0         :: Integer
                                                                                , inName         := TRIM (inGoodsGroupPropertyName) :: TVarChar
                                                                                , inParentId     := vbGoodsGroupPropertyId_parent   :: Integer
                                                                                , inQualityINN   := ''
                                                                                , inSession      := inSession :: TVarChar
                                                                                 ) AS tmp);
   END IF;



   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroupProperty(), vbGoodsId, vbGoodsGroupPropertyId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.12.23         *
*/

-- тест
--
