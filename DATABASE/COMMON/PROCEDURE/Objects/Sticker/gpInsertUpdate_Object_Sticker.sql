-- Function: gpInsertUpdate_Object_Sticker()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Sticker(Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TBlob, TFloat, TFloat,TFloat,TFloat,TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Sticker(Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TBlob, TFloat, TFloat,TFloat,TFloat,TFloat, TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Sticker(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TBlob, TFloat, TFloat,TFloat,TFloat,TFloat, TFloat,TFloat,TFloat,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Sticker(
 INOUT ioId                  Integer   , -- ключ объекта <Товар>
    IN inCode                Integer   , -- Код объекта <Товар>
    IN inComment             TVarChar  , -- Примечание
    IN inJuridicalId         Integer   , -- ссылка юр.лицо, ТОрг.сеть, Контрагент
    IN inGoodsId             Integer   , -- Товар
    IN inStickerFileId       Integer   , --
    IN inStickerFileId_70_70 Integer   , --
    IN inStickerGroupName    TVarChar  , --
    IN inStickerTypeName     TVarChar  , --
    IN inStickerTagName      TVarChar  , --
    IN inStickerSortName     TVarChar  , --
    IN inStickerNormName     TVarChar  , --
    IN inInfo                TBlob     , --
    IN inValue1              TFloat    , -- значение цены
    IN inValue2              TFloat    , -- значение цены
    IN inValue3              TFloat    , --
    IN inValue4              TFloat    , --
    IN inValue5              TFloat    , --
    IN inValue6              TFloat    , --
    IN inValue7              TFloat    , --
    IN inValue8              TFloat    , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbCode              Integer;
   DECLARE vbStickerGroupId    Integer;
   DECLARE vbStickerTypeId     Integer;
   DECLARE vbStickerTagId      Integer;
   DECLARE vbStickerSortId     Integer;
   DECLARE vbStickerNormId     Integer;
   DECLARE vbIsUpdate          Boolean;

BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Sticker());

   -- !!! Если код не установлен, определяем его как последний+1 (!!! ПОТОМ НАДО БУДЕТ ЭТО ВКЛЮЧИТЬ !!!)
   vbCode:=lfGet_ObjectCode (inCode, zc_Object_Sticker());

   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Sticker(), vbCode);

--       RAISE EXCEPTION 'Ошибка.Значение <Группа товаров> должно быть установлено.';

   -- определили <Признак>
   vbIsUpdate:= COALESCE (ioId, 0) > 0;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Sticker(), vbCode, COALESCE (inComment, ''));

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Sticker_Juridical(), ioId, inJuridicalId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Sticker_Goods(), ioId, inGoodsId);
   -- сохранили вязь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Sticker_StickerFile(), ioId, inStickerFileId);
   -- сохранили вязь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Sticker_StickerFile_70_70(), ioId, inStickerFileId_70_70);
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBlob (zc_ObjectBlob_Sticker_Info(), ioId, inInfo);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Sticker_Value1(), ioId, inValue1);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Sticker_Value2(), ioId, inValue2);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Sticker_Value3(), ioId, inValue3);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Sticker_Value4(), ioId, inValue4);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Sticker_Value5(), ioId, inValue5);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Sticker_Value6(), ioId, inValue6);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Sticker_Value7(), ioId, inValue7);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Sticker_Value8(), ioId, inValue8);
   
   -- проверка "Вид продукта (Группа)"
   IF 1 < (SELECT COUNT(*) FROM Object WHERE Object.DescId = zc_Object_StickerGroup() AND UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inStickerGroupName)) AND TRIM (inStickerGroupName) <> '')
   THEN
         RAISE EXCEPTION 'Ошибка.Не УНИКАЛЬНО значение Вид продукта (Группа) <%>', inStickerGroupName;
   END IF;
   -- поиск
   vbStickerGroupId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_StickerGroup() AND UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inStickerGroupName)) AND TRIM (inStickerGroupName) <> '');
   IF COALESCE (vbStickerGroupId, 0) = 0 AND COALESCE (inStickerGroupName, '')<> ''
   THEN
       -- если не нашли - сохранили новый элемент в справочник
       vbStickerGroupId := gpInsertUpdate_Object_StickerGroup (ioId     := 0
                                                             , inCode   := lfGet_ObjectCode (0, zc_Object_StickerGroup())
                                                             , inName   := TRIM (inStickerGroupName)
                                                             , inComment:= ''
                                                             , inSession:= inSession
                                                              );
   END IF;

   -- проверка "Способ изготовления продукта"
   IF 1 < (SELECT COUNT(*) FROM Object WHERE Object.DescId = zc_Object_StickerType() AND UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inStickerTypeName)) AND TRIM (inStickerTypeName) <> '')
   THEN
         RAISE EXCEPTION 'Ошибка.Не УНИКАЛЬНО значение Способ изготовления продукта <%>', inStickerTypeName;
   END IF;
   -- поиск
   vbStickerTypeId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_StickerType() AND UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inStickerTypeName)) AND TRIM (inStickerTypeName) <> '');
   IF COALESCE (vbStickerTypeId, 0) = 0 AND COALESCE (inStickerTypeName, '') <> ''
   THEN
       -- если не нашли - сохранили новый элемент в справочник
       vbStickerTypeId := gpInsertUpdate_Object_StickerType (ioId     := 0
                                                           , inCode   := lfGet_ObjectCode (0, zc_Object_StickerType())
                                                           , inName   := TRIM (inStickerTypeName)
                                                           , inComment:= ''
                                                           , inSession:= inSession
                                                            );
   END IF;

   -- проверка "Название продукта"
   IF 1 < (SELECT COUNT(*) FROM Object WHERE Object.DescId = zc_Object_StickerTag() AND UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inStickerTagName)) AND TRIM (inStickerTagName) <> '')
   THEN
         RAISE EXCEPTION 'Ошибка.Не УНИКАЛЬНО значение Название продукта <%>', inStickerTagName;
   END IF;
   -- поиск
   vbStickerTagId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_StickerTag() AND UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inStickerTagName)) AND TRIM (inStickerTagName) <> '');
   IF COALESCE (vbStickerTagId, 0) = 0 AND COALESCE (inStickerTagName, '') <> ''
   THEN
       -- если не нашли - сохранили новый элемент в справочник
       vbStickerTagId := gpInsertUpdate_Object_StickerTag (ioId     := 0
                                                         , inCode   := lfGet_ObjectCode (0, zc_Object_StickerTag())
                                                         , inName   := TRIM (inStickerTagName)
                                                         , inComment:= ''
                                                         , inSession:= inSession
                                                          );
   END IF;

   -- проверка "Сортность продукта"
   IF 1 < (SELECT COUNT(*) FROM Object WHERE Object.DescId = zc_Object_StickerSort() AND UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inStickerSortName)) AND TRIM (inStickerSortName) <> '')
   THEN
         RAISE EXCEPTION 'Ошибка.Не УНИКАЛЬНО значение Сортность продукта <%>', inStickerSortName;
   END IF;
   -- поиск
   vbStickerSortId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_StickerSort() AND UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inStickerSortName)) AND TRIM (inStickerSortName) <> '');
   IF COALESCE (vbStickerSortId, 0) = 0 AND COALESCE (inStickerSortName, '') <> ''
   THEN
       -- если не нашли - сохранили новый элемент в справочник
       vbStickerSortId := gpInsertUpdate_Object_StickerSort (ioId     := 0
                                                           , inCode   := lfGet_ObjectCode (0, zc_Object_StickerSort())
                                                           , inName   := TRIM (inStickerSortName)
                                                           , inComment:= ''
                                                           , inSession:= inSession
                                                            );
   END IF;

   -- проверка "ТУ или ДСТУ"
   IF 1 < (SELECT COUNT(*) FROM Object WHERE Object.DescId = zc_Object_StickerNorm() AND UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inStickerNormName)) AND TRIM (inStickerNormName) <> '')
   THEN
         RAISE EXCEPTION 'Ошибка.Не УНИКАЛЬНО значение ТУ или ДСТУ <%>', inStickerNormName;
   END IF;
   vbStickerNormId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_StickerNorm() AND UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inStickerNormName)) AND TRIM (inStickerNormName) <> '');
   IF COALESCE (vbStickerNormId, 0) = 0 AND COALESCE (inStickerNormName, '') <> ''
   THEN
       -- записываем новый элемент
       vbStickerNormId := gpInsertUpdate_Object_StickerNorm (ioId     := 0
                                                           , inCode   := lfGet_ObjectCode (0, zc_Object_StickerNorm())
                                                           , inName   := TRIM (inStickerNormName)
                                                           , inComment:= ''
                                                           , inSession:= inSession
                                                            );
   END IF;


   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Sticker_StickerGroup(), ioId, vbStickerGroupId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Sticker_StickerType(), ioId, vbStickerTypeId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Sticker_StickerTag(), ioId, vbStickerTagId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Sticker_StickerSort(), ioId, vbStickerSortId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Sticker_StickerNorm(), ioId, vbStickerNormId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.09.23         *
 14.02.20         *
 23.10.17         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Sticker (ioId:=0, inCode:=-1, inName:= 'TEST-Sticker', ... , inSession:= '2')
