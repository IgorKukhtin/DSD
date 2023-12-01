-- Function: gpInsertUpdate_Object_ReceiptGoods()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoods_UnitChild(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReceiptGoods_UnitChild(
    IN inId               Integer   ,    -- ключ объекта <Лодки>
    IN inUnitChildId      Integer   ,    ---
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ReceiptGoods());
   vbUserId:= lpGetUserBySession (inSession);

    --
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN;
   END IF;

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptGoods_UnitChild(), inId, inUnitChildId);
   
   
   -- сохранили свойство <Дата корр>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), inId, CURRENT_TIMESTAMP);
   -- сохранили свойство <Пользователь (корр)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Update(), inId, vbUserId);



   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.12.23         * inUnitChildId
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ReceiptGoods_UnitChild()