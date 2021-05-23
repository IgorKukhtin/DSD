-- Function: gpInsertUpdate_Object_BarCodeBox (Integer, Integer, TVarChar, TFloat, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BarCodeBox (Integer, Integer, TVarChar, TFloat, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_BarCodeBox (Integer, Integer, TVarChar, TFloat, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_BarCodeBox(
 INOUT ioId           Integer   , -- Ключ объекта <Талоны на топливо>
    IN inCode         Integer   , -- свойство <Код >
    IN inBarCode      TVarChar  , -- свойство <Ш/К>
    IN inWeight       TFloat    , -- точный вес ящ
    IN inAmountPrint  TFloat    , -- кол для печати
    IN inBoxId        Integer   , -- ссылка на Ящик
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_BarCodeBox());
   vbUserId:= lpGetUserBySession (inSession);


    -- проверка <inName>
   IF TRIM (COALESCE (inBarCode, '')) = ''
   THEN
       RAISE EXCEPTION 'Ошибка.Значение <Ш/К> должно быть установлено.';
   END IF;


   -- Если код не установлен, определяем его как последний + 1
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_BarCodeBox());

   -- проверка уникальности для свойства <Ш/К>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_BarCodeBox(), inBarCode);
   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_BarCodeBox(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_BarCodeBox(), vbCode_calc, inBarCode);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_BarCodeBox_Box(), ioId, inBoxId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_BarCodeBox_Weight(), ioId, inWeight);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_BarCodeBox_Print(), ioId, inAmountPrint);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.05.20         *
 14.05.19         *
*/
/*
SELECT *
    , gpInsertUpdate_Object_BarCodeBox(
     ioId          := 0
    , inCode       := tmp.a
    , inBarCode    := tmp.xxx
    , inWeight     := 0
    , inBoxId      := zc_Box_E3()
    , inSession    := '5'
)
from (
SELECT *, '1' || repeat ('0', 12 - LENGTH (tmp.a :: TVarChar) ) ||  tmp.a :: TVarChar as xxx
from (SELECT GENERATE_SERIES (300, 499) as a) as tmp
) as tmp
*/
-- тест
-- SELECT * FROM gpInsertUpdate_Object_BarCodeBox()
