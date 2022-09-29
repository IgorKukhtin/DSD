-- Торговая марка

DROP FUNCTION IF EXISTS gpUpdate_Object_ProdColor_Value (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_ProdColor_Value(
    IN inId              Integer,       -- ключ объекта <Бренд>
    IN inValue           TVarChar,      -- Значение цвета
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS VOID
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
   
   IF COALESCE (inId, 0) = 0
   THEN
     RETURN;
   END IF;

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ProdColor_Value(), inId, inValue);
   
   IF inValue <> ''
   THEN
      BEGIN
         EXECUTE('SELECT CAST(x'''||SUBSTRING(inValue, 6, 2)||SUBSTRING(inValue, 4, 2)||SUBSTRING(inValue, 2, 2)||''' AS INT8)') INTO vbColor_calc;
      EXCEPTION
         WHEN others THEN vbColor_calc := zc_Color_White();
      END;     
   ELSE
     vbColor_calc := zc_Color_White();
   END IF;

   -- сохранили свойство <>
   IF vbColor_calc <> zc_Color_White() OR
      EXISTS(SELECT 1 FROM ObjectFloat
             WHERE ObjectId = inId AND DescId = zc_ObjectFloat_ProdColor_Value())
   THEN
     PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ProdColor_Value(), inId, vbColor_calc);
   END IF;
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 29.09.22                                                       *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_ProdColor_Value()