-- Function: gpInsertUpdate_Object_StickerProperty()

-- DROP FUNCTION IF EXISTS gpInsertUpdate_Object_StickerProperty(Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, Boolean, TFloat, TFloat,TFloat,TFloat,TFloat,TFloat,TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_StickerProperty(Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_StickerProperty(Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_StickerProperty(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_StickerProperty(
 INOUT ioId                  Integer   , -- ключ объекта <>
    IN inCode                Integer   , -- Код объекта <>
    IN inComment             TVarChar  , -- Примечание
    IN inStickerId           Integer   , -- ссылка юр.лицо, ТОрг.сеть, Контрагент
    IN inGoodsKindId         Integer   , -- Товар
    IN inStickerFileId       Integer   , --
    IN inStickerFileId_70_70 Integer   , --
    IN inStickerSkinName     TVarChar  , --
    IN inStickerPackName     TVarChar  , --
    IN inBarCode             TVarChar  , --
    IN inFix                 Boolean   , --
    IN inValue1              TFloat    , --
    IN inValue2              TFloat    , --
    IN inValue3              TFloat    , --
    IN inValue4              TFloat    , --
    IN inValue5              TFloat    , --
    IN inValue6              TFloat    , --
    IN inValue7              TFloat    , --
    IN inValue8              TFloat    , --
    IN inValue9              TFloat    , --
    IN inValue10             TFloat    , --
    IN inValue11             TFloat    , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbCode              Integer;
   DECLARE vbStickerSkinId     Integer;
   DECLARE vbStickerPackId     Integer;
   DECLARE vbIsUpdate          Boolean;

BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_StickerProperty());

   -- !!! Если код не установлен, определяем его как последний+1 (!!! ПОТОМ НАДО БУДЕТ ЭТО ВКЛЮЧИТЬ !!!)
   vbCode:= lfGet_ObjectCode (inCode, zc_Object_StickerProperty());

   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_StickerProperty(), vbCode);

--       RAISE EXCEPTION 'Ошибка.Значение <Группа товаров> должно быть установлено.';

   -- определили <Признак>
   vbIsUpdate:= COALESCE (ioId, 0) > 0;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_StickerProperty(), vbCode, COALESCE (inComment, ''));

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StickerProperty_Sticker(), ioId, inStickerId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StickerProperty_GoodsKind(), ioId, inGoodsKindId);
   -- сохранили вязь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StickerProperty_StickerFile(), ioId, inStickerFileId);
   -- сохранили вязь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StickerProperty_StickerFile_70_70(), ioId, inStickerFileId_70_70);

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_StickerProperty_BarCode(), ioId, inBarCode);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_StickerProperty_Fix(), ioId, inFix);

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
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerProperty_Value6(), ioId, inValue6);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerProperty_Value7(), ioId, inValue7);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerProperty_Value8(), ioId, inValue8);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerProperty_Value9(), ioId, inValue9);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerProperty_Value10(), ioId, inValue10);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerProperty_Value11(), ioId, inValue11);


   -- проверка "Оболочка"
   IF 1 < (SELECT COUNT(*) FROM Object WHERE Object.DescId = zc_Object_StickerSkin() AND UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inStickerSkinName)) AND TRIM (inStickerSkinName) <> '')
   THEN
         RAISE EXCEPTION 'Ошибка.Не УНИКАЛЬНО значение Оболочка <%>', inStickerSkinName;
   END IF;
   -- поиск
   vbStickerSkinId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_StickerSkin() AND UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inStickerSkinName)) AND TRIM (inStickerSkinName) <> '');
   IF COALESCE (vbStickerSkinId, 0) = 0 AND COALESCE (inStickerSkinName, '') <> ''
   THEN
       -- если не нашли - сохранили новый элемент в справочник
       vbStickerSkinId := gpInsertUpdate_Object_StickerSkin (ioId     := 0
                                                           , inCode   := lfGet_ObjectCode (0, zc_Object_StickerSkin())
                                                           , inName   := TRIM (inStickerSkinName)
                                                           , inComment:= ''
                                                           , inSession:= inSession
                                                            );
   END IF;

   -- проверка "вид пакування"
   IF 1 < (SELECT COUNT(*) FROM Object WHERE Object.DescId = zc_Object_StickerPack() AND UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inStickerPackName)) AND TRIM (inStickerPackName) <> '')
   THEN
         RAISE EXCEPTION 'Ошибка.Не УНИКАЛЬНО значение вид пакування <%>', inStickerPackName;
   END IF;
   -- поиск
   vbStickerPackId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_StickerPack() AND UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inStickerPackName)) AND TRIM (inStickerPackName) <> '');
   IF COALESCE (vbStickerPackId, 0) = 0 AND COALESCE (inStickerPackName, '') <> ''
   THEN
       -- если не нашли - сохранили новый элемент в справочник
       vbStickerPackId := gpInsertUpdate_Object_StickerPack (ioId     := 0
                                                           , inCode   := lfGet_ObjectCode (0, zc_Object_StickerPack())
                                                           , inName   := TRIM (inStickerPackName)
                                                           , inComment:= ''
                                                           , inSession:= inSession
                                                            );
   END IF;

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StickerProperty_StickerSkin(), ioId, vbStickerSkinId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StickerProperty_StickerPack(), ioId, vbStickerPackId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.09.23         *
 24.10.17         *
*/

-- тест
--