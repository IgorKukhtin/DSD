-- Function: gpUpdate_Object_GoodsProperty_TaxDoc()

DROP FUNCTION IF EXISTS gpUpdate_Object_GoodsProperty_TaxDoc(Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_GoodsProperty_TaxDoc(
    IN inId                  Integer   ,    -- ключ объекта <Значения свойств товаров для классификатора>
    IN inTaxDoc              TFloat    ,    -- 
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
 BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Update_Object_GoodsProperty_TaxDoc());

   -- проверка
   IF COALESCE (inId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Элемент не сохранен.';
   END IF;
  
   -- сохранили 
   PERFORM lpInsertUpdate_ObjectFloat(zc_objectFloat_GoodsProperty_TaxDoc(), inId, inTaxDoc);
 
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 27.06.17         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_GoodsProperty_TaxDoc()

