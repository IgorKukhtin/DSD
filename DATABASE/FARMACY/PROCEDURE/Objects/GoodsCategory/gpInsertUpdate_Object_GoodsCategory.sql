-- Function: gpInsertUpdate_Object_GoodsCategory()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsCategory (Integer, Integer, Integer, TFloat, tvarchar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsCategory (Integer, Integer, Integer, Integer, TFloat, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsCategory (Integer, Integer, Integer, Integer, TFloat, Boolean, TVarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsCategory(
    IN inId                      Integer   ,   	-- ключ объекта <Договор>
    IN inGoodsId                 Integer   ,    -- ссылка на главное юр.лицо
    IN inUnitCategoryId          Integer   ,    -- ссылка на категория подразд.
    IN inUnitId                  Integer   ,    -- ссылка на подразделение
    IN inValue                   TFloat    ,    --  
    In inisUnitList              Boolean   ,    -- по списку
    IN inSession                 TVarChar       -- сессия пользователя
)
  RETURNS VOID
  AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsCategory());
   vbUserId:= inSession;

   -- проверка
   IF COALESCE (inUnitId, 0) = 0 OR COALESCE (inGoodsId, 0) = 0
   THEN 
       RAISE EXCEPTION 'Ошибка.Параметры <Товар> и <Подразделение> обязательны к заполнению';
   END IF;

   PERFORM lpInsertUpdate_Object_GoodsCategory (ioId             := 0
                                              , inGoodsId        := inGoodsId
                                              , inUnitCategoryId := inUnitCategoryId
                                              , inUnitId         := tmpUnit.UnitId
                                              , inValue          := inValue
                                              , inUserId         := vbUserId
                                              )
   FROM (SELECT inUnitId AS UnitId
         WHERE COALESCE (inUnitId, 0) <> 0 
           AND inisUnitList = FALSE
        UNION
         SELECT ObjectBoolean_GoodsCategory.ObjectId AS UnitId
         FROM ObjectBoolean AS ObjectBoolean_GoodsCategory
         WHERE ObjectBoolean_GoodsCategory.DescId = zc_ObjectBoolean_Unit_GoodsCategory()
           AND ObjectBoolean_GoodsCategory.ValueData = TRUE
           AND inisUnitList = TRUE
      ) AS tmpUnit;
   
END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.02.19         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsCategory ()                            

--select * from gpInsertUpdate_Object_GoodsCategory(ioId := 10091548 , inGoodsId := 342 , inGoodsCategoryId := 7779481 , inValue := 2 ,  inSession := '3');