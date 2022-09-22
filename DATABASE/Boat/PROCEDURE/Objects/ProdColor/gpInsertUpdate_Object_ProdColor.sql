-- Торговая марка

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdColor (Integer, Integer, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdColor (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProdColor(
 INOUT ioId              Integer,       -- ключ объекта <Бренд>
 INOUT ioCode            Integer,       -- свойство <Код Бренда>
    IN inName            TVarChar,      -- главное Название Бренда
    IN inComment         TVarChar,      -- 
    IN inValue           TVarChar,      --
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
   DECLARE vbIsInsert Boolean;  
   DECLARE vbColor_calc Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ProdColor());
   vbUserId:= lpGetUserBySession (inSession);

   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- Если код не установлен, определяем его как последний+1
   vbCode_calc:= lfGet_ObjectCode (ioCode, zc_Object_ProdColor()); 

   -- проверка прав уникальности для свойства <Наименование >
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ProdColor(), inName, vbUserId);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ProdColor(), vbCode_calc, inName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ProdColor_Comment(), ioId, inComment);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ProdColor_Value(), ioId, inValue);
   
   IF inValue <> ''
   THEN
      BEGIN
         EXECUTE('SELECT CAST(x'''||SUBSTRING(inValue, 2, 7)||''' AS INT8)') INTO vbColor_calc;
      EXCEPTION
         WHEN others THEN vbColor_calc := zc_Color_White();
      END;     
   ELSE
     vbColor_calc := zc_Color_White();
   END IF;

   -- сохранили свойство <>
   IF vbColor_calc <> zc_Color_White() OR
      EXISTS(SELECT 1 FROM ObjectFloat
             WHERE ObjectId = ioId AND DescId = zc_ObjectFloat_ProdColor_Value())
   THEN
     PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ProdColor_Value(), ioId, vbColor_calc);
   END IF;
   

   IF vbIsInsert = TRUE THEN
      -- сохранили свойство <Дата создания>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- сохранили свойство <Пользователь (создание)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   END IF;
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.10.20         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ProdColor()