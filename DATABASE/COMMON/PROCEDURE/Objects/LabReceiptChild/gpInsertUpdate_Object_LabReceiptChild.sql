-- Function: gpInsertUpdate_Object_LabReceiptChild()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_LabReceiptChild (Integer, TFloat, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_LabReceiptChild (Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_LabReceiptChild(
 INOUT ioId              Integer   , -- ключ объекта <>
    IN inLabMarkId       Integer   , -- ссылка на Название показателя (вид исследования)
    IN inGoodsId         Integer   , -- ссылка на Товары
    IN inValue           TFloat    , -- Значение объекта 
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsUpdate Boolean; 
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_LabReceiptChild());

   -- определили <Признак>
   vbIsUpdate:= COALESCE (ioId, 0) > 0;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_LabReceiptChild(), 0, '');

   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_LabReceiptChild_LabMark(), ioId, inLabMarkId);
   -- сохранили связь с <Товаром>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_LabReceiptChild_Goods(), ioId, inGoodsId);

   -- сохранили свойство <Значение>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_LabReceiptChild_Value(), ioId, inValue);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inObjectId:= ioId, inUserId:= vbUserId, inIsUpdate:= vbIsUpdate, inIsErased:= NULL);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.10.19         * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_LabReceiptChild ()
