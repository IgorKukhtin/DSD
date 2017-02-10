-- Function: gpInsertUpdate_Object_ReceiptChild_Sybase()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptChild_Sybase (Integer, TFloat, Boolean, Boolean, TDateTime, TDateTime, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReceiptChild_Sybase(
 INOUT ioId              Integer   , -- ключ объекта <Составляющие рецептур>
    IN inValue           TFloat    , -- Значение объекта 
    IN inIsWeightMain    Boolean   , -- Входит в общий вес сырья
    IN inIsTaxExit       Boolean   , -- Зависит от % выхода
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
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ReceiptChild());


   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ReceiptChild(), 0, '');
   
   -- сохранили связь с <Рецептурой>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptChild_Receipt(), ioId, inReceiptId);
   -- сохранили связь с <Товаром>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptChild_Goods(), ioId, inGoodsId);
   -- сохранили связь с <Видом товаров>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptChild_GoodsKind(), ioId, inGoodsKindId);
   
   -- сохранили свойство <Значение>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ReceiptChild_Value(), ioId, inValue);
   IF EXISTS (SELECT * FROM ObjectLink WHERE ObjectId = inReceiptId AND DescId = zc_ObjectLink_Receipt_GoodsKind() AND ChildObjectId = zc_GoodsKind_WorkProgress())
      OR EXISTS (SELECT * FROM ObjectLink WHERE ObjectId = (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = inReceiptId AND DescId = zc_ObjectLink_Receipt_Goods())
                                            AND DescId = zc_ObjectLink_Goods_InfoMoney()
                                            AND ChildObjectId = zc_Enum_InfoMoney_10105()) -- Основное сырье + Мясное сырье + Прочее мясное сырье
   THEN
       -- сохранили свойство <Входит в осн. сырье (100 кг.)>
       PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_ReceiptChild_WeightMain(), ioId, inIsWeightMain);
   ELSE
       -- сохранили свойство <Входит в осн. сырье (100 кг.)>
       PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_ReceiptChild_WeightMain(), ioId, FALSE);
   END IF;

   -- сохранили свойство <Зависит от % выхода>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_ReceiptChild_TaxExit(), ioId, inIsTaxExit);
   -- сохранили свойство <Начальная дата>
   -- PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ReceiptChild_Start(), ioId, inStartDate);
   -- сохранили свойство <Конечная дата>
   -- PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ReceiptChild_End(), ioId, inEndDate);
   -- сохранили свойство <Комментарий>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ReceiptChild_Comment(), ioId, inComment);

   -- !!!пересчитали итоговые кол-ва по рецепту!!!
   PERFORM lpUpdate_Object_Receipt_Total (inReceiptId, vbUserId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ReceiptChild_Sybase (Integer, TFloat, Boolean, Boolean, TDateTime, TDateTime, TVarChar, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 14.02.15                                        *all
 19.07.13         * rename zc_ObjectDate_              
 09.07.13         * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ReceiptChild_Sybase ()
