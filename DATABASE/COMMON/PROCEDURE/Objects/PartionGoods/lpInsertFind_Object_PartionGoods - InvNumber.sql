-- Function: lpInsertFind_Object_PartionGoods - InvNumber - Прочие ТМЦ + МНМА

DROP FUNCTION IF EXISTS lpInsertFind_Object_PartionGoods (Integer, Integer, Integer, TVarChar, TDateTime, TFloat);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionGoods(
    IN inUnitId_Partion Integer   , -- *Подразделение(для цены)
    IN inGoodsId        Integer   , -- *Товар
    IN inStorageId      Integer   , -- *Место хранения
    IN inInvNumber      TVarChar  , -- *Инвентарный номер
    IN inOperDate       TDateTime , -- *Дата перемещения
    IN inPrice          TFloat      -- Цена
)
  RETURNS Integer AS
$BODY$
   DECLARE vbPartionGoodsId Integer;
BEGIN
     -- в этом случае партия не нужна
     IF inOperDate < '01.05.2017' OR (COALESCE (inUnitId_Partion, 0) = 0 AND COALESCE (inGoodsId, 0) = 0)
     THEN
         -- RETURN (80132); -- !!!Пустая партия!!!
         RETURN (0);
     END IF;


     -- RAISE EXCEPTION 'Ошибка.Учет не организован.';

     -- проверка
     IF COALESCE (inUnitId_Partion, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.В партии Не определено <Подразделеление>.';
     END IF;
     -- проверка
     IF COALESCE (inGoodsId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.В партии Не определен <Товар>.';
     END IF;
     -- проверка
     IF inOperDate IS NULL OR inOperDate IN (zc_DateStart(), zc_DateEnd())
     THEN
         RAISE EXCEPTION 'Ошибка.В партии для <%> Не определена <Дата перемещения>.', lfGet_Object_ValueData (inGoodsId);
     END IF;

     -- меняем параметр
     IF COALESCE (inInvNumber, '') = ''
     THEN
         inInvNumber:= '0';
     END IF;


     -- меняем параметр - !!!ВРЕМЕННО будет 1 партия в Месяц - последним днем!!!
     inOperDate:= DATE_TRUNC ('MONTH', inOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY';


     IF COALESCE (inStorageId, 0) = 0
     THEN
         -- Находим по св-вам: Товар + Дата перемещения + Инвентарный номер + Место учета + Место хранения=NULL
         vbPartionGoodsId:= (SELECT ObjectLink_Goods.ObjectId
                             FROM ObjectLink AS ObjectLink_Goods
                                  INNER JOIN ObjectDate ON ObjectDate.ObjectId  = ObjectLink_Goods.ObjectId
                                                       AND ObjectDate.DescId    = zc_ObjectDate_PartionGoods_Value()
                                                       AND ObjectDate.ValueData = inOperDate
                                  -- по Инвентарный номер
                                  INNER JOIN Object ON Object.Id        = ObjectLink_Goods.ObjectId
                                                   AND Object.ValueData = inInvNumber
                                  INNER JOIN ObjectLink AS ObjectLink_Unit
                                                        ON ObjectLink_Unit.ObjectId      = ObjectLink_Goods.ObjectId
                                                       AND ObjectLink_Unit.DescId        = zc_ObjectLink_PartionGoods_Unit()
                                                       AND ObjectLink_Unit.ChildObjectId = inUnitId_Partion
                                  INNER JOIN ObjectLink AS ObjectLink_Storage
                                                        ON ObjectLink_Storage.ObjectId      = ObjectLink_Goods.ObjectId
                                                       AND ObjectLink_Storage.DescId        = zc_ObjectLink_PartionGoods_Storage()
                                                       AND ObjectLink_Storage.ChildObjectId IS NULL
                             WHERE ObjectLink_Goods.ChildObjectId = inGoodsId
                               AND ObjectLink_Goods.DescId        = zc_ObjectLink_PartionGoods_Goods()
                            );
     ELSE
         -- Находим по св-вам: Товар + Дата перемещения + Инвентарный номер + Место учета + Место хранения
         vbPartionGoodsId:= (SELECT ObjectLink_Goods.ObjectId
                             FROM ObjectLink AS ObjectLink_Goods
                                  INNER JOIN ObjectDate ON ObjectDate.ObjectId  = ObjectLink_Goods.ObjectId
                                                       AND ObjectDate.DescId    = zc_ObjectDate_PartionGoods_Value()
                                                       AND ObjectDate.ValueData = inOperDate
                                  -- по Инвентарный номер
                                  INNER JOIN Object ON Object.Id        = ObjectLink_Goods.ObjectId
                                                   AND Object.ValueData = inInvNumber
                                  INNER JOIN ObjectLink AS ObjectLink_Unit
                                                        ON ObjectLink_Unit.ObjectId      = ObjectLink_Goods.ObjectId
                                                       AND ObjectLink_Unit.DescId        = zc_ObjectLink_PartionGoods_Unit()
                                                       AND ObjectLink_Unit.ChildObjectId = inUnitId_Partion
                                  INNER JOIN ObjectLink AS ObjectLink_Storage
                                                        ON ObjectLink_Storage.ObjectId      = ObjectLink_Goods.ObjectId
                                                       AND ObjectLink_Storage.DescId        = zc_ObjectLink_PartionGoods_Storage()
                                                       AND ObjectLink_Storage.ChildObjectId = inStorageId
                             WHERE ObjectLink_Goods.ChildObjectId = inGoodsId
                               AND ObjectLink_Goods.DescId = zc_ObjectLink_PartionGoods_Goods()
                            );
     END IF;

     -- Если не нашли
     IF COALESCE (vbPartionGoodsId, 0) = 0
     THEN
         -- сохранили <Инвентарный номер>
         vbPartionGoodsId := lpInsertUpdate_Object (vbPartionGoodsId, zc_Object_PartionGoods(), 0, inInvNumber);

         -- сохранили <Подразделения(для цены)>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_Unit(), vbPartionGoodsId, inUnitId_Partion);
         -- сохранили <Товар>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_Goods(), vbPartionGoodsId, inGoodsId);
         -- сохранили <Место хранения>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_Storage(), vbPartionGoodsId, CASE WHEN inStorageId = 0 THEN NULL ELSE inStorageId END);

         -- сохранили <Дата перемещения>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_PartionGoods_Value(), vbPartionGoodsId, inOperDate);
         -- сохранили <Цена>
         PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionGoods_Price(), vbPartionGoodsId, COALESCE (inPrice, 0));
     END IF;

     -- Возвращаем значение
     RETURN (vbPartionGoodsId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertFind_Object_PartionGoods (Integer, Integer, Integer, TVarChar, TDateTime, TFloat) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.07.14                                        *
*/

-- тест
-- SELECT * FROM lpInsertFind_Object_PartionGoods ();
