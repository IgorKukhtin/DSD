-- Function: gpInsertUpdate_Object_GoodsCategory()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsCategory (Integer, Integer, Integer, TFloat, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsCategory (Integer, Integer, Integer, Integer, TFloat, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsCategory(
 INOUT ioId                      Integer   ,   	-- ключ объекта <Договор>
    IN inGoodsId                 Integer   ,    -- ссылка на главное юр.лицо
    IN inUnitCategoryId          Integer   ,    -- ссылка на категория подразд.
    IN inUnitId                  Integer   ,    -- ссылка на подразделение
    IN inValue                   TFloat    ,    --  
    IN inSession                 TVarChar       -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsCategory());
   vbUserId:= inSession;

     -- проверка
   IF EXISTS (SELECT 1
              FROM ObjectLink AS ObjectLink_GoodsCategory_Unit
                   INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Goods
                                        ON ObjectLink_GoodsCategory_Goods.ObjectId = ObjectLink_GoodsCategory_Unit.ObjectId
                                       AND ObjectLink_GoodsCategory_Goods.DescId = zc_ObjectLink_GoodsCategory_Goods()
                                       AND ObjectLink_GoodsCategory_Goods.ChildObjectId = inGoodsId

                   INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_UnitCategory
                                         ON ObjectLink_GoodsCategory_UnitCategory.ObjectId = ObjectLink_GoodsCategory_Unit.ObjectId
                                        AND ObjectLink_GoodsCategory_UnitCategory.DescId = zc_ObjectLink_GoodsCategory_Category()
                                        AND COALESCE (ObjectLink_GoodsCategory_UnitCategory.ChildObjectId, 0) = inUnitCategoryId

              WHERE ObjectLink_GoodsCategory_Unit.DescId = zc_ObjectLink_GoodsCategory_Unit()
                AND ObjectLink_GoodsCategory_Unit.ChildObjectId = inUnitId
                AND ObjectLink_GoodsCategory_Unit.ObjectId <> ioId
              )
   THEN
      RAISE EXCEPTION 'Ошибка.Связь <%> - <%> - <%>  уже существует', lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData (inUnitId), lfGet_Object_ValueData (inUnitCategoryId);
   END IF; 

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsCategory(), 0, '');

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsCategory_Goods(), ioId, inGoodsId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsCategory_Category(), ioId, inUnitCategoryId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsCategory_Unit(), ioId, inUnitId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsCategory_Value(), ioId, inValue);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.02.19         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsCategory ()                            

--select * from gpInsertUpdate_Object_GoodsCategory(ioId := 10091548 , inGoodsId := 342 , inGoodsCategoryId := 7779481 , inValue := 2 ,  inSession := '3');