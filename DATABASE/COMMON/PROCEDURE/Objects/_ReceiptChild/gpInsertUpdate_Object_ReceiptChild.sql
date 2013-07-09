-- Function: gpInsertUpdate_Object_ReceiptChild()

-- DROP FUNCTION gpInsertUpdate_Object_ReceiptChild();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReceiptChild(
 INOUT ioId              Integer   , -- ключ объекта <Составляющие рецептур>
    IN inValue           TFloat    , -- Значение объекта 
    IN inWeight          Boolean   , -- Входит в общий вес выхода 
    IN inTaxExit         Boolean   , -- Зависит от % выхода
    IN inStartDate       TDateTime , -- Начальная дата
    IN inEndDate         TDateTime , -- Конечная дата
    IN inComment         TVarChar  , -- Комментарий
    IN inReceiptId       Integer   , -- ссылка на Рецептуры
    IN inGoodsId         Integer   , -- ссылка на Товары
    IN inGoodsKindId     Integer   , -- ссылка на Виды товаров
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ReceiptChild()());
   vbUserId := inSession;
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ReceiptChild(), 0, '');
   
   -- сохранили связь с <Рецептурой>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptChild_Receipt(), ioId, inReceiptId);
   -- сохранили связь с <Товаром>
   PERFORM lpInsertUpdate_ObjectLink (c_ObjectLink_ReceiptChild_Goods(), ioId, inGoodsId);
   -- сохранили связь с <Видом товаров>
   PERFORM lpInsertUpdate_ObjectLink (c_ObjectLink_ReceiptChild_GoodsKind(), ioId, inGoodsKindId);
   
   -- сохранили свойство <Значение>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ReceiptChild_Value(), ioId, inValue);
   -- сохранили свойство <Входит в общий вес выхода>
   PERFORM lpInsertUpdate_ObjectBoolean (c_ObjectBoolean_ReceiptChild_Weight(), ioId, inWeight);
   -- сохранили свойство <Зависит от % выхода>
   PERFORM lpInsertUpdate_ObjectBoolean (c_ObjectBoolean_ReceiptChild_TaxExit(), ioId, inTaxExit);
   -- сохранили свойство <Начальная дата>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ReceiptChild_StartDate(), ioId, inStartDate);
   -- сохранили свойство <Конечная дата>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ReceiptChild_EndDate(), ioId, inEndDate);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ReceiptChild (Integer, TFloat, Boolean, Boolean, TDateTime, TDateTime, TVarChar, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

  
/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
               
 09.07.13          * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ReceiptChild ()
    