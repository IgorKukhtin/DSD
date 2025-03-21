-- Function: gpInsertUpdate_Object_Box()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Box(Integer,Integer,TVarChar,TFloat,TFloat,TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Box(Integer,Integer,TVarChar,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Box(Integer,Integer,TVarChar,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Box(Integer,Integer,TVarChar, Integer, TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Box(
 INOUT ioId	      Integer,   	-- ключ объекта <Единица измерения>
    IN inCode         Integer,      -- свойство <Код Единицы измерения>
    IN inName         TVarChar,     -- главное Название Единицы измерения 
    IN inGoodsId      Integer,
    IN inBoxVolume    TFloat,       --
    IN inBoxWeight    TFloat,       --
    IN inBoxHeight    TFloat  ,     -- 
    IN inBoxLength    TFloat  ,     --
    IN inBoxWidth     TFloat  ,     --
    IN inNPP          TFloat  ,     --
    IN inSession      TVarChar      -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Code_max Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Box());
   vbUserId:= lpGetUserBySession (inSession);

   -- Если код не установлен, определяем его как последний+1
   IF COALESCE (inCode, 0) = 0
   THEN
       SELECT COALESCE( MAX (ObjectCode), 0) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_Box();
   ELSE
       Code_max := inCode;
   END IF;

   -- проверка уникальности для свойства <Наименование Единицы измерения>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Box(), inName);
   -- проверка уникальности для свойства <Код Единицы измерения>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Box(), Code_max);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Box(), Code_max, inName);

   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Box_Volume(), ioId, inBoxVolume);
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Box_Weight(), ioId, inBoxWeight);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Box_Height(), ioId, inBoxHeight);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Box_Length(), ioId, inBoxLength);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Box_Width(), ioId, inBoxWidth);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Box_NPP(), ioId, inNPP);

   -- сохранили связь с <Товар>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Box_Goods(), ioId, inGoodsId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 21.03.25         *
 18.02.25         *
 24.06.18         *
 09.10.14                                                       *

*/

-- тест
-- 