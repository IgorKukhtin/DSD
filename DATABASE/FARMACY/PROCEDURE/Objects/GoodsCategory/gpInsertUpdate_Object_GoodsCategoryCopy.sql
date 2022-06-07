-- Function: gpInsertUpdate_Object_GoodsCategoryCopy()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsCategoryCopy (Integer, Integer, Integer, Integer, TFloat, Boolean, TVarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsCategoryCopy(
    IN inId                      Integer   ,   	-- ключ объекта <Договор>
    IN inGoodsId                 Integer   ,    -- ссылка на главное юр.лицо
    IN inUnitCategoryId          Integer   ,    -- ссылка на категория подразд.
    IN inUnitId                  Integer   ,    -- ссылка на подразделение
    IN inValue                   TFloat    ,    -- Количество
    IN inisErased                Boolean   ,    -- Удален
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

   inId := (SELECT ObjectLink_GoodsCategory_Goods.ObjectId AS Id
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
            Limit 1 -- на всякий случай
            );   
            
    IF inisErased 
    THEN
      IF EXISTS(SELECT * FROM OBJECT WHERE ID = inId AND isErased = False)
      THEN
        PERFORM gpUpdateObjectIsErased (inId, inSession);      
      END IF;
    ELSE
    
      IF EXISTS(SELECT * FROM OBJECT WHERE ID = inId AND isErased = True)
      THEN
        PERFORM gpUpdateObjectIsErased (inId, inSession);      
      END IF;
      
      inId := lpInsertUpdate_Object_GoodsCategory (ioId             := inId
                                                 , inGoodsId        := inGoodsId
                                                 , inUnitCategoryId := inUnitCategoryId
                                                 , inUnitId         := inUnitId
                                                 , inValue          := inValue
                                                 , inUserId         := vbUserId
                                                 );
    END IF;

    -- !!!ВРЕМЕННО для ТЕСТА!!!
/*    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION 'Тест прошел успешно для <%> <%>', inSession, inId;
    END IF;*/   
    
END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 06.06.22                                                       *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsCategory ()                            