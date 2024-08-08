-- Function: gpInsertUpdate_Object_ChoiceCell  

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ChoiceCell (Integer, Integer, TVarChar, Integer, Integer, TFloat,TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ChoiceCell(
 INOUT ioId                Integer   ,    -- ключ объекта <Товары в реализации покупателям> 
    IN inCode              Integer   ,
    IN inName              TVarChar  ,    
    IN inGoodsId           Integer   ,    -- товар
    IN inGoodsKindId       Integer   ,    -- 
    IN inBoxCount          TFloat   ,    -- 
    IN inNPP               TFloat   ,    -- 
    IN inComment           TVarChar  ,    -- 
    IN inSession           TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;   
   DECLARE vbIsLoad Boolean;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   IF zfConvert_StringToNumber (inSession) < 0
   THEN
       vbIsLoad:= TRUE;
       vbUserId := lpCheckRight ((-1 * zfConvert_StringToNumber (inSession)) :: TVarChar, zc_Enum_Process_InsertUpdate_Object_ChoiceCell());
   ELSE
       vbIsLoad:= FAlSE;
       vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ChoiceCell());
   END IF;
   
   IF COALESCE (inNPP,0) = 0
   THEN
      RAISE EXCEPTION 'Ошибка. № п/п не установлено.';
   END IF;

   IF COALESCE (inCode,0) = 0
   THEN
      RAISE EXCEPTION 'Ошибка. Код не установлен.';
   END IF;

   IF TRIM (COALESCE (inName,'')) = ''
   THEN
      RAISE EXCEPTION 'Ошибка. Название не установлено.';
   END IF;


   IF COALESCE (inGoodsId,0) = 0 AND vbIsLoad = FALSE AND 1=0
   THEN
      RAISE EXCEPTION 'Ошибка. Товар не установлен.';
   END IF;


   IF COALESCE (inGoodsKindId,0) = 0 AND vbIsLoad = FALSE AND 1=0
   THEN
      RAISE EXCEPTION 'Ошибка. Вид Товара не установлен.';
   END IF;


   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   inCode:= lfGet_ObjectCode (inCode, zc_Object_ChoiceCell());
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ChoiceCell(), inCode, inName);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ChoiceCell_Goods(), ioId, inGoodsId);                          
   -- сохранили связь с < >
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ChoiceCell_GoodsKind(), ioId, inGoodsKindId);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ChoiceCell_NPP(), ioId, inNPP);
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ChoiceCell_BoxCount(), ioId, inBoxCount);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ChoiceCell_Comment(), ioId, inComment);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.07.24         * 
*/

-- тест
--