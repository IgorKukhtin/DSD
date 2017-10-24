-- Function: gpInsertUpdate_Object_StickerProperty()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_StickerProperty(Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TBlob, TFloat, TFloat,TFloat,TFloat,TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_StickerProperty(
 INOUT ioId                  Integer   , -- ключ объекта <Товар>
    IN inCode                Integer   , -- Код объекта <Товар>
    IN inComment             TVarChar  , -- Примечание
    IN inJuridicalId         Integer   , -- ссылка юр.лицо, ТОрг.сеть, Контрагент
    IN inGoodsId             Integer   , -- Товар
    IN inStickerPropertyFileId       Integer   , -- 
    IN inStickerPropertyGroupName    TVarChar  , -- 
    IN inStickerPropertyTypeName     TVarChar  , -- 
    IN inStickerPropertyTagName      TVarChar  , -- 
    IN inStickerPropertySortName     TVarChar  , -- 
    IN inStickerPropertyNormName     TVarChar  , -- 
    IN inInfo                TBlob     , -- 
    IN inValue1              TFloat    , -- значение цены
    IN inValue2              TFloat    , -- значение цены
    IN inValue3              TFloat    , --
    IN inValue4              TFloat    , --
    IN inValue5              TFloat    , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbCode              Integer;   
   DECLARE vbStickerPropertyGroupId    Integer;
   DECLARE vbStickerPropertyTypeId     Integer;
   DECLARE vbStickerPropertyTagId      Integer;
   DECLARE vbStickerPropertySortId     Integer;
   DECLARE vbStickerPropertyNormId     Integer;
   DECLARE vbIsUpdate          Boolean;
   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_StickerProperty());
   
   -- !!! Если код не установлен, определяем его как последний+1 (!!! ПОТОМ НАДО БУДЕТ ЭТО ВКЛЮЧИТЬ !!!)
   vbCode:=lfGet_ObjectCode (inCode, zc_Object_StickerProperty());
   
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_StickerProperty(), vbCode);

--       RAISE EXCEPTION 'Ошибка.Значение <Группа товаров> должно быть установлено.';
  
   -- определили <Признак>
   vbIsUpdate:= COALESCE (ioId, 0) > 0;
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_StickerProperty(), vbCode, COALESCE (inComment, ''));

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StickerProperty_Juridical(), ioId, inJuridicalId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StickerProperty_Goods(), ioId, inGoodsId);
   -- сохранили вязь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StickerProperty_StickerPropertyFile(), ioId, inStickerPropertyFileId);
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBlob (zc_ObjectBlob_StickerProperty_Info(), ioId, inInfo);
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerProperty_Value1(), ioId, inValue1);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerProperty_Value2(), ioId, inValue2);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerProperty_Value3(), ioId, inValue3);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerProperty_Value4(), ioId, inValue4);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerProperty_Value5(), ioId, inValue5);
   
   -- пытаемся найти "Вид продукта (Группа)"
   -- если не находим записывае новый элемент в справочник
   vbStickerPropertyGroupId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_StickerPropertyGroup() AND UPPER (TRIM(Object.ValueData)) LIKE UPPER (TRIM(inStickerPropertyGroupName)));
   IF COALESCE (vbStickerPropertyGroupId, 0) = 0 AND COALESCE (inStickerPropertyGroupName, '')<> ''
   THEN
       -- записываем новый элемент
       vbStickerPropertyGroupId := gpInsertUpdate_Object_StickerPropertyGroup (ioId     := 0
                                                             , inCode   := lfGet_ObjectCode(0, zc_Object_StickerPropertyGroup()) 
                                                             , inName   := TRIM(inStickerPropertyGroupName)
                                                             , inComment:= '' ::TVarChar
                                                             , inSession:= inSession
                                                              );
   END IF; 

   -- пытаемся найти "Способ изготовления продукта"
   -- если не находим записывае новый элемент в справочник
   vbStickerPropertyTypeId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_StickerPropertyType() AND UPPER (TRIM(Object.ValueData)) LIKE UPPER (TRIM(inStickerPropertyTypeName)));
   IF COALESCE (vbStickerPropertyTypeId, 0) = 0 AND COALESCE (inStickerPropertyTypeName, '')<> ''
   THEN
       -- записываем новый элемент
       vbStickerPropertyTypeId := gpInsertUpdate_Object_StickerPropertyType (ioId     := 0
                                                           , inCode   := lfGet_ObjectCode(0, zc_Object_StickerPropertyType()) 
                                                           , inName   := TRIM(inStickerPropertyTypeName)
                                                           , inComment:= '' ::TVarChar
                                                           , inSession:= inSession
                                                            );
   END IF;

   -- пытаемся найти "Название продукта"
   -- если не находим записывае новый элемент в справочник
   vbStickerPropertyTagId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_StickerPropertyTag() AND UPPER (TRIM(Object.ValueData)) LIKE UPPER (TRIM(inStickerPropertyTagName)));
   IF COALESCE (vbStickerPropertyTagId, 0) = 0 AND COALESCE (inStickerPropertyTagName, '')<> ''
   THEN
       -- записываем новый элемент
       vbStickerPropertyTagId := gpInsertUpdate_Object_StickerPropertyTag (ioId     := 0
                                                         , inCode   := lfGet_ObjectCode(0, zc_Object_StickerPropertyTag()) 
                                                         , inName   := TRIM(inStickerPropertyTagName)
                                                         , inComment:= '' ::TVarChar
                                                         , inSession:= inSession
                                                          );
   END IF;

   -- пытаемся найти " 	Сортность продукта"
   -- если не находим записывае новый элемент в справочник
   vbStickerPropertySortId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_StickerPropertySort() AND UPPER (TRIM(Object.ValueData)) LIKE UPPER (TRIM(inStickerPropertySortName)));
   IF COALESCE (vbStickerPropertySortId, 0) = 0 AND COALESCE (inStickerPropertySortName, '')<> ''
   THEN
       -- записываем новый элемент
       vbStickerPropertySortId := gpInsertUpdate_Object_StickerPropertySort (ioId     := 0
                                                           , inCode   := lfGet_ObjectCode(0, zc_Object_StickerPropertySort()) 
                                                           , inName   := TRIM(inStickerPropertySortName)
                                                           , inComment:= '' ::TVarChar
                                                           , inSession:= inSession
                                                            );
   END IF;

   -- пытаемся найти "ТУ или ДСТУ"
   -- если не находим записывае новый элемент в справочник
   vbStickerPropertyNormId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_StickerPropertyNorm() AND UPPER (TRIM(Object.ValueData)) LIKE UPPER (TRIM(inStickerPropertyNormName)));
   IF COALESCE (vbStickerPropertyNormId, 0) = 0 AND COALESCE (inStickerPropertyNormName, '')<> ''
   THEN
       -- записываем новый элемент
       vbStickerPropertyNormId := gpInsertUpdate_Object_StickerPropertyNorm (ioId     := 0
                                                           , inCode   := lfGet_ObjectCode(0, zc_Object_StickerPropertyNorm()) 
                                                           , inName   := TRIM(inStickerPropertyNormName)
                                                           , inComment:= '' ::TVarChar
                                                           , inSession:= inSession
                                                            );
   END IF;
  

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StickerProperty_StickerPropertyGroup(), ioId, vbStickerPropertyGroupId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StickerProperty_StickerPropertyType(), ioId, vbStickerPropertyTypeId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StickerProperty_StickerPropertyTag(), ioId, vbStickerPropertyTagId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StickerProperty_StickerPropertySort(), ioId, vbStickerPropertySortId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StickerProperty_StickerPropertyNorm(), ioId, vbStickerPropertyNormId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
 
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.10.17         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_StickerProperty (ioId:=0, inCode:=-1, inName:= 'TEST-StickerProperty', ... , inSession:= '2')
