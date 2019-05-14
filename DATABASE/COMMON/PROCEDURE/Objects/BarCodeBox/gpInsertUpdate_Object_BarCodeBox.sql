-- Function: gpInsertUpdate_Object_BarCodeBox (Integer, Integer, TVarChar, TFloat, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BarCodeBox (Integer, Integer, TVarChar, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_BarCodeBox(
 INOUT ioId         Integer   , -- Ключ объекта <Талоны на топливо>
    IN inCode       Integer   , -- свойство <Код >
    IN inBarCode    TVarChar  , -- свойство <Ш/К>
    IN inWeight     TFloat    , -- точный вес ящ
    IN inBoxId      Integer   , -- ссылка на Ящик
    IN inSession    TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   

BEGIN
 
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_BarCodeBox());
   vbUserId := inSession;

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_BarCodeBox());

   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_BarCodeBox(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_BarCodeBox(), vbCode_calc, '');

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_BarCodeBox_Box(), ioId, inBoxId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_BarCodeBox_Weight(), ioId, inWeight);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_BarCodeBox_BarCode(), ioId, inBarCode);
      
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.05.19         * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_BarCodeBox()
