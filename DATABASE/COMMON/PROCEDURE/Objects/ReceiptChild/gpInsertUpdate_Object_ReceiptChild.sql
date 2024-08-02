-- Function: gpInsertUpdate_Object_ReceiptChild()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptChild (Integer, TFloat, Boolean, Boolean, TDateTime, TDateTime, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptChild (Integer, TFloat, Boolean, Boolean, TDateTime, TDateTime, TVarChar, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptChild (Integer, TFloat, Boolean, Boolean, Boolean, TDateTime, TDateTime, TVarChar, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptChild (Integer, TFloat, Boolean, Boolean, Boolean, Boolean, TDateTime, TDateTime, TVarChar, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReceiptChild(
 INOUT ioId              Integer   , -- ключ объекта <Составляющие рецептур>
    IN inValue           TFloat    , -- Значение объекта 
   OUT outValueWeight    TFloat    , -- Значение объекта 
    IN inIsWeightMain    Boolean   , -- Входит в осн. сырье (100 кг.)
    IN inIsTaxExit       Boolean   , -- Зависит от % выхода
 --   IN inIsReal          Boolean   , -- Зависит от факта
    IN inisSave          Boolean   , --
    IN inisDel           Boolean   , --
 INOUT ioStartDate       TDateTime , -- Начальная дата
 INOUT ioEndDate         TDateTime , -- Конечная дата
    IN inComment         TVarChar  , -- Комментарий
    IN inReceiptId       Integer   , -- ссылка на Рецептуры
    IN inReceiptLevelId  Integer   , -- этапы производства
    IN inGoodsId         Integer   , -- ссылка на Товары
    IN inGoodsKindId     Integer   , -- ссылка на Виды товаров
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsUpdate Boolean; 
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ReceiptChild());

   --проверка
   IF COALESCE (inisSave,FALSE) = TRUE AND COALESCE (inisDel,FALSE) = TRUE
   THEN
       RAISE EXCEPTION 'Ошибка.Может быть выбрано только одно значание Cохранить или Удалить историю для расхода.';
   END IF;

   -- определили <Признак>
   vbIsUpdate:= COALESCE (ioId, 0) > 0;

   -- расчет
   outValueWeight:= (SELECT inValue * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                     FROM ObjectLink AS ObjectLink_Goods_Measure
                          LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                               ON ObjectFloat_Weight.ObjectId = ObjectLink_Goods_Measure.ObjectId
                                              AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                     WHERE ObjectLink_Goods_Measure.ObjectId = inGoodsId
                       AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                    );

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ReceiptChild(), 0, '');

   
   -- сохранили связь с <Рецептурой>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptChild_Receipt(), ioId, inReceiptId);
   -- сохранили связь с <Товаром>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptChild_Goods(), ioId, inGoodsId);
   -- сохранили связь с <Видом товаров>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptChild_GoodsKind(), ioId, inGoodsKindId);

   -- сохранили связь с <Этапы производства>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptChild_ReceiptLevel(), ioId, inReceiptLevelId);

   -- сохранили свойство <Значение>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ReceiptChild_Value(), ioId, inValue);
   -- сохранили свойство <Входит в осн. сырье (100 кг.)>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_ReceiptChild_WeightMain(), ioId, inIsWeightMain);
   -- сохранили свойство <Зависит от % выхода>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_ReceiptChild_TaxExit(), ioId, inIsTaxExit);

   -- сохранили свойство <Зависит от факта>
   --PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_ReceiptChild_Real(), ioId, inIsReal);

   
   IF COALESCE (inisSave,FALSE) = TRUE
      THEN   
          -- сохранили свойство <Начальная дата>
          PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ReceiptChild_Start(), ioId, ioStartDate);
          -- сохранили свойство <Конечная дата>
          PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ReceiptChild_End(), ioId, ioEndDate);
   END IF;
   IF COALESCE (inisDel,FALSE) = TRUE
      THEN   
          -- сохранили свойство <Начальная дата>
          PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ReceiptChild_Start(), ioId, NULL);
          -- сохранили свойство <Конечная дата>
          PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ReceiptChild_End(), ioId, NULL);
   END IF;
   -- возвращаем сохраненные значения 
   ioStartDate := (SELECT ObjectDate.ValueData FROM ObjectDate WHERE ObjectDate.DescId = zc_ObjectDate_ReceiptChild_Start() AND ObjectDate.ObjectId = ioId);
   ioEndDate   := (SELECT ObjectDate.ValueData FROM ObjectDate WHERE ObjectDate.DescId = zc_ObjectDate_ReceiptChild_End() AND ObjectDate.ObjectId = ioId);
   
   -- сохранили свойство <Комментарий>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ReceiptChild_Comment(), ioId, inComment);

   -- !!!пересчитали итоговые кол-ва по рецепту!!!
   PERFORM lpUpdate_Object_Receipt_Total (inReceiptId, vbUserId);

   -- !!!пересчитали связь с рецепт "поиск"!!!
   -- PERFORM lpUpdate_Object_Receipt_Parent (inReceiptId, 0, vbUserId);

   -- сохранили протокол
   --PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   PERFORM lpInsert_ObjectProtocol (inObjectId:= ioId, inUserId:= vbUserId, inIsUpdate:= vbIsUpdate, inIsErased:= NULL);  

   
   if vbUserId = 9457
   then   
        RAISE EXCEPTION 'Test.OK. <%> , <%>', ioStartDate, ioEndDate;
   end if;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_ReceiptChild (Integer, TFloat, Boolean, Boolean, TDateTime, TDateTime, TVarChar, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 27.09.22         *inIsReal
 14.06.21         * inReceiptLevelId
 12.11.15         * 
 14.02.15                                        *all
 19.07.13         * rename zc_ObjectDate_              
 09.07.13         * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ReceiptChild ()
