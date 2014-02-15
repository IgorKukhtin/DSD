-- Function: gpInsertUpdate_Object_Receipt()

-- DROP FUNCTION gpInsertUpdate_Object_Receipt();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Receipt(
 INOUT ioId                  Integer   , -- ключ объекта <Составляющие рецептур>
    IN inName                TVarChar  , -- Наименование
    IN inCode                TVarChar  , -- Код рецептуры 
    IN inComment             TVarChar  , -- Комментарий
    IN inValue               TFloat    , -- Значение (Количество)
    IN inValueCost           TFloat    , -- Значение затрат(Количество)
    IN inTaxExit             TFloat    , -- % выхода
    IN inPartionValue        TFloat    , -- Количество в партии (количество в кутере)
    IN inPartionCount        TFloat    , -- Минимальное количество партий (количество кутеров, значение или 0.5 или 1)
    IN inWeightPackage       TFloat    , -- Вес упаковки
    IN inStartDate           TDateTime , -- Начальная дата
    IN inEndDate             TDateTime , -- Конечная дата
    IN inMain                Boolean   , -- Признак главный
    IN inGoodsId             Integer   , -- ссылка на Товары
    IN inGoodsKindId         Integer   , -- ссылка на Виды товаров
    IN inGoodsKindCompleteId Integer   , -- Виды товаров (готовая продукция)
    IN inReceiptCostId       Integer   , -- Затраты в рецептурах
    IN inReceiptKindId       Integer   , -- Виды рецептур
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Receipt()());
   vbUserId := inSession;
   
   -- проверка уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Receipt(), inName);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Receipt(), 0, inName);
   
   -- сохранили связь с <Товаром>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Receipt_Goods(), ioId, inGoodsId);   
   -- сохранили связь с <Видом товаров>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Receipt_GoodsKind(), ioId, inGoodsKindId);
   -- сохранили связь с <Виды товаров (готовая продукция)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Receipt_GoodsKindComplete(), ioId, inGoodsKindCompleteId);
   -- сохранили связь с <Затраты в рецептурах>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Receipt_ReceiptCost(), ioId, inReceiptCostId);
   -- сохранили связь с <Виды рецептур>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Receipt_ReceiptKind(), ioId, inReceiptKindId);


   -- сохранили свойство <Код рецептуры>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Receipt_Code(), ioId, inCode);
   -- сохранили свойство <Комментарий>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Receipt_Comment(), ioId, inComment);

   -- сохранили свойство <Значение (Количество)>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Receipt_Value(), ioId, inValue);
   -- сохранили свойство <Значение затрат(Количество)>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Receipt_ValueCost(), ioId, inValueCost);
   -- сохранили свойство <% выхода>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Receipt_TaxExit(), ioId, inTaxExit);
   -- сохранили свойство <Количество в партии (количество в кутере)>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Receipt_PartionValue(), ioId, inPartionValue);
   -- сохранили свойство <Минимальное количество партий (количество кутеров, значение или 0.5 или 1)>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Receipt_PartionCount(), ioId, inPartionCount);
   -- сохранили свойство <Вес упаковки>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Receipt_WeightPackage(), ioId, inWeightPackage);

   -- сохранили свойство <Начальная дата>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Receipt_Start(), ioId, inStartDate);
   -- сохранили свойство <Конечная дата>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Receipt_End(), ioId, inEndDate);
 
    -- сохранили свойство <Признак главный>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Receipt_Main(), ioId, inMain);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Receipt (Integer, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TDateTime, Boolean, Integer, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

  
/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.07.13         * rename zc_ObjectDate_               
 10.07.13         * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Receipt ()
    