 -- Function: gpInsertUpdate_Object_StickerFile()

DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_StickerFile (Integer, Integer, TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_StickerFile (Integer, Integer, Integer, Integer, TVarChar, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_StickerFile (Integer, Integer, Integer, Integer, TVarChar, TVarChar
                                                          , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);
/*DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_StickerFile (Integer, Integer, Integer, Integer, TVarChar, TVarChar
                                                          , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                          , TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);*/

/*DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_StickerFile (Integer, Integer, Integer, Integer, TVarChar, TVarChar
                                                          , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                          , TFloat, TFloat, TFloat, TFloat
                                                          , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                          , TFloat, TFloat, TFloat, TFloat
                                                          , Boolean, TVarChar);*/

DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_StickerFile (Integer, Integer, Integer, Integer, TVarChar, TVarChar
                                                          , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                          , TFloat, TFloat, TFloat, TFloat
                                                          , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                          , TFloat, TFloat, TFloat, TFloat
                                                          , Boolean, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_StickerFile(
   INOUT ioId                       Integer,     -- ид
      IN incode                     Integer,     -- код
      IN inJuridicalId              Integer,     --
      IN inTradeMarkId              Integer,     --
      IN inLanguageName             TVarChar,    --
      IN inComment                  TVarChar,    -- Примечание
      IN inWidth1                   TFloat, 
      IN inWidth2                   TFloat,
      IN inWidth3                   TFloat,
      IN inWidth4                   TFloat,
      IN inWidth5                   TFloat,
      IN inWidth6                   TFloat,
      IN inWidth7                   TFloat,
      IN inWidth8                   TFloat,
      IN inWidth9                   TFloat,
      IN inWidth10                  TFloat,
      IN inLevel1                   TFloat, 
      IN inLevel2                   TFloat,
      IN inLeft1                    TFloat, 
      IN inLeft2                    TFloat,
      IN inWidth1_70_70             TFloat, 
      IN inWidth2_70_70             TFloat,
      IN inWidth3_70_70             TFloat,
      IN inWidth4_70_70             TFloat,
      IN inWidth5_70_70             TFloat,
      IN inWidth6_70_70             TFloat,
      IN inWidth7_70_70             TFloat,
      IN inWidth8_70_70             TFloat,
      IN inWidth9_70_70             TFloat,
      IN inWidth10_70_70            TFloat,
      IN inLevel1_70_70             TFloat, 
      IN inLevel2_70_70             TFloat,
      IN inLeft1_70_70              TFloat, 
      IN inLeft2_70_70              TFloat,

      IN inisDefault                Boolean ,    -- 
      IN inisSize70                 Boolean ,    --
      IN inSession                  TVarChar     -- Пользователь
      )
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbCode_calc  Integer;
   DECLARE vbLanguageId Integer;
   DECLARE vbName       TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_StickerFile());
   vbUserId:= lpGetUserBySession (inSession);

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_StickerFile());

   vbName := TRIM (TRIM (inComment)
                || COALESCE ((SELECT ' ' || TRIM (Object.ValueData) FROM Object where Object.Id = inJuridicalId), '')
                || COALESCE ((SELECT ' ' || TRIM (Object.ValueData) FROM Object where Object.Id = inTradeMarkId), '')
                ||' - ' || TRIM (inLanguageName)
                  );

   -- проверка прав уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_StickerFile(), vbName);
   -- проверка прав уникальности для свойства <Код >
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_StickerFile(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_StickerFile(), vbCode_calc, vbName);

   -- сохранили св-во <Примечание>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_StickerFile_Comment(), ioId, inComment);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_StickerFile_Default(), ioId, inisDefault);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_StickerFile_70(), ioId, inisSize70);

    -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StickerFile_Juridical(), ioId, inJuridicalId);
    -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StickerFile_TradeMark(), ioId, inTradeMarkId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Width1(), ioId, inWidth1);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Width2(), ioId, inWidth2);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Width3(), ioId, inWidth3);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Width4(), ioId, inWidth4);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Width5(), ioId, inWidth5);
      -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Width6(), ioId, inWidth6);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Width7(), ioId, inWidth7);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Width8(), ioId, inWidth8);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Width9(), ioId, inWidth9);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Width10(), ioId, inWidth10);


   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Level1(), ioId, inLevel1);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Level2(), ioId, inLevel2);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Left1(), ioId, inLeft1);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Left2(), ioId, inLeft2);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Width1_70_70(), ioId, inWidth1_70_70);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Width2_70_70(), ioId, inWidth2_70_70);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Width3_70_70(), ioId, inWidth3_70_70);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Width4_70_70(), ioId, inWidth4_70_70);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Width5_70_70(), ioId, inWidth5_70_70);
      -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Width6_70_70(), ioId, inWidth6_70_70);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Width7_70_70(), ioId, inWidth7_70_70);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Width8_70_70(), ioId, inWidth8_70_70);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Width9_70_70(), ioId, inWidth9_70_70);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Width10_70_70(), ioId, inWidth10_70_70);


   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Level1_70_70(), ioId, inLevel1_70_70);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Level2_70_70(), ioId, inLevel2_70_70);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Left1_70_70(), ioId, inLeft1_70_70);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_StickerFile_Left2_70_70(), ioId, inLeft2_70_70);   

   -- пытаемся найти "Способ изготовления продукта"
   -- если не находим записывае новый элемент в справочник
   vbLanguageId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Language() AND UPPER (TRIM(Object.ValueData)) LIKE UPPER (TRIM(inLanguageName)));
   IF COALESCE (vbLanguageId, 0) = 0 AND COALESCE (inLanguageName, '')<> ''
   THEN
       -- записываем новый элемент
       vbLanguageId := gpInsertUpdate_Object_Language (ioId     := 0
                                                     , inCode   := lfGet_ObjectCode(0, zc_Object_Language())
                                                     , inName   := TRIM(inLanguageName)
                                                     , inComment:= '' ::TVarChar
                                                     , inSession:= inSession
                                                      );
   END IF;

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_StickerFile_Language(), ioId, vbLanguageId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.09.23         *
 11.04.23         *
 08.05.18         *
 19.12.17         *
 23.10.17         *
*/

-- тест
--
