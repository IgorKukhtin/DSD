-- Function: gpUpdate_MI_PriceList_SupplierFailures()

DROP FUNCTION IF EXISTS gpUpdate_MI_PriceList_SupplierFailures(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_PriceList_SupplierFailures(
    IN inId                   Integer ,     -- Товар
    IN inisSupplierFailures   Boolean ,
    IN inSession              TVarChar      -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPriceListId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);


   IF COALESCE (inId, 0) = 0
   THEN
     RAISE EXCEPTION 'Ошибка. Не определена запись.';   
   END IF;
   
   -- сохранили свойство <Отказ поставщика>
   PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_SupplierFailures(), inId, NOT inisSupplierFailures);
   
   -- сохранили свойство <Сотрудник>
   PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), inId, CURRENT_TIMESTAMP);

   -- сохранили связь с <Дата/время корректировки>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), inId, vbUserId);
   
   -- сохранили протокол
   -- PERFORM lpInsert_MovementItemProtocol (inId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 22.02.22                                                       *
*/

-- select * from gpUpdate_MI_PriceList_SupplierFailures(inId := 495365270 , inisSupplierFailures := 'True' ,  inSession := '3');

-- select * from gpUpdate_MI_PriceList_SupplierFailures(inId := 495608342 , inisSupplierFailures := 'True' ,  inSession := '3');