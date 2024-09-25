--
--gpInsertUpdate_Object_GoodsPropertyValue_GoodsBox_Load
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsPropertyValue_GoodsBox_Load (TVarChar, Integer, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsPropertyValue_GoodsBox_Load (TVarChar, Integer, TVarChar, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsPropertyValue_GoodsBox_Load(
    IN inGoodsPropertyName  TVarChar,      -- Классификатор свойств товаров
    IN inGoodsCode          Integer,       -- Код отгружаемого товара
    IN inGoodsName          TVarChar,      -- Название отгружаемого товара
    IN inGoodsKindName      TVarChar,      -- Вид отгружаемого товара
    IN inGoodsBoxCode       Integer,      -- Название товара гофроящик
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbGoodsId Integer; 
  DECLARE vbGoodsKindId Integer;
  DECLARE vbGoodsPropertyId Integer;
  DECLARE vbGoodsBoxId Integer;
  DECLARE vbGoodsPropertyValueId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpGetUserBySession (inSession);
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsPropertyValue());
   
   IF COALESCE (inGoodsPropertyName,'') = ''
   THEN
        RAISE EXCEPTION 'Ошибка.Классификатор свойств товаров не задан.';
   END IF;
   
   IF COALESCE (inGoodsCode,0) = 0 OR COALESCE (inGoodsBoxCode,0) = 0
   THEN
       RETURN;
   END IF;
   
   --Находим товары
   vbGoodsId    := (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inGoodsCode AND Object.DescId = zc_Object_Goods());
   -- находим вид товара
   vbGoodsKindId    := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inGoodsKindName) AND Object.DescId = zc_Object_GoodsKind()); 
   -- находим Товар Гофроящик
   vbGoodsBoxId := (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inGoodsBoxCode AND Object.DescId = zc_Object_Goods());

   -- находим vbGoodsPropertyId
   vbGoodsPropertyId := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inGoodsPropertyName) AND Object.DescId = zc_Object_GoodsProperty()); 
   
    IF COALESCE (vbGoodsPropertyId, 0) = 0
   THEN
        RAISE EXCEPTION 'Ошибка.Классификатор свойств товаров <%> не найден.', inGoodsPropertyName;
   END IF;  
    IF COALESCE (vbGoodsId, 0) = 0
   THEN
        RAISE EXCEPTION 'Ошибка.Товар (%)<%> не найден.', inGoodsCode, inGoodsName;
   END IF; 
    IF COALESCE (vbGoodsKindId, 0) = 0
   THEN
        RAISE EXCEPTION 'Ошибка.Вид товара <%> не найден.', inGoodsKindName;
   END IF;  
    IF COALESCE (vbGoodsBoxId, 0) = 0
   THEN
        RAISE EXCEPTION 'Ошибка.Товар(гофроящик) с кодом <%> не найден.', inGoodsBoxCode;
   END IF;
               
   --находим  
   vbGoodsPropertyValueId := (SELECT ObjectLink_GoodsPropertyValue_Goods.ObjectId
                              FROM ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                   INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                         ON ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId = ObjectLink_GoodsPropertyValue_Goods.ObjectId
                                                        AND ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = vbGoodsPropertyId
                                                        AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                   LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                        ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_Goods.ObjectId
                                                       AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                              WHERE ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                AND ObjectLink_GoodsPropertyValue_Goods.ChildObjectId = vbGoodsId
                                AND COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) = COALESCE (vbGoodsKindId, 0)
                                );

   IF COALESCE (vbGoodsPropertyValueId,0) = 0
   THEN
       -- сохранили <Объект>
       vbGoodsPropertyValueId := lpInsertUpdate_Object(0, zc_Object_GoodsPropertyValue(), 0, '');

       -- сохранили связь
       PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsPropertyValue_Goods(), vbGoodsPropertyValueId, vbGoodsId);
       -- сохранили связь
       PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsPropertyValue_GoodsKind(), vbGoodsPropertyValueId, vbGoodsKindId);
       -- сохранили связь
       PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsPropertyValue_GoodsProperty(), vbGoodsPropertyValueId, vbGoodsPropertyId);              
   END IF;

   -- сохранили связь  Товар Гофроящик
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsPropertyValue_GoodsBox(), vbGoodsPropertyValueId, vbGoodsBoxId);


   IF vbUserId = 9457 
   THEN
        RAISE EXCEPTION 'Test.OK';
   END IF;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.09.24         *
*/

-- тест
--select * from gpInsertUpdate_Object_GoodsPropertyValue_GoodsBox_Load(inGoodsPropertyName := 'Фоззи' , inGoodsCode := 2 , inGoodsName := 'Ковбаса ТЕЛЯЧА З ЯЗИКОМ вар в/ґ ТМ Спец Цех' , inGoodsKindName := 'Б/В' , inGoodsBoxCode := 2016 ,  inSession := '9457');
