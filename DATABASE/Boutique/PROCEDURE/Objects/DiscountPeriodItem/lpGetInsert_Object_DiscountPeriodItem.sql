-- Элемент Сезонных скидок - для Истории

DROP FUNCTION IF EXISTS lpGetInsert_Object_DiscountPeriodItem (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpGetInsert_Object_DiscountPeriodItem(
    IN inUnitId         Integer,      -- Подразделение
    IN inGoodsId        Integer,      -- Товар
    IN inUserId         Integer
)
RETURNS Integer
AS
$BODY$
DECLARE vbId Integer;
BEGIN

   -- Проверка
   IF COALESCE (inUnitId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Магазин не установлен.';
   END IF;
   -- Проверка
   IF COALESCE (inUnitId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Товар не установлен.';
   END IF;


   -- поиск
   vbId:= (SELECT ObjectLink_DiscountPeriodItem_Goods.ObjectId
           FROM ObjectLink AS ObjectLink_DiscountPeriodItem_Goods
                JOIN ObjectLink AS ObjectLink_DiscountPeriodItem_Unit
                                ON ObjectLink_DiscountPeriodItem_Unit.ObjectId      = ObjectLink_DiscountPeriodItem_Goods.ObjectId
                               AND ObjectLink_DiscountPeriodItem_Unit.DescId        = zc_ObjectLink_DiscountPeriodItem_Unit()
                               AND ObjectLink_DiscountPeriodItem_Unit.ChildObjectId = inUnitId
           WHERE ObjectLink_DiscountPeriodItem_Goods.DescId        =  zc_ObjectLink_DiscountPeriodItem_Goods()
             AND ObjectLink_DiscountPeriodItem_Goods.ChildObjectId = inGoodsId
          );


  IF COALESCE (vbId, 0) = 0 THEN
     -- сохранили <Объект>
     vbId := lpInsertUpdate_Object (0, zc_Object_DiscountPeriodItem(), 0, '');

     --
     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_DiscountPeriodItem_Unit(), vbId, inUnitId);

     PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_DiscountPeriodItem_Goods(), vbId, inGoodsId);
     -- сохранили свойство <Дата создания> - убрал т.к. сохраняется в протоколе истории
     -- PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), vbId, CURRENT_TIMESTAMP);
     -- сохранили свойство <Пользователь (создание)> - убрал т.к. сохраняется в протоколе истории
     -- PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), vbId, inUserId);

  END IF;

  -- вернули значение
  RETURN vbId;

END;$BODY$
 LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.04.17         *
*/

-- тест
-- SELECT * FROM lpGetInsert_Object_DiscountPeriodItem()
