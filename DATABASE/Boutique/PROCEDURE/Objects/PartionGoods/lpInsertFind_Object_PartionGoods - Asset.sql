-- Function: lpInsertFind_Object_PartionGoods - Asset

DROP FUNCTION IF EXISTS lpInsertFind_Object_PartionGoods (Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionGoods(
    IN inMovementId     Integer   , -- *Партия - документ
    IN inGoodsId        Integer   , -- *Основные средства или Товар
    IN inUnitId         Integer   , -- *Подразделение использования
    IN inStorageId      Integer   , -- *Место хранения
    IN inInvNumber      TVarChar    -- *Инвентарный номер
)
  RETURNS Integer AS
$BODY$
   DECLARE vbPartionGoodsId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN

     -- проверка
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не определено значение <Партия - документ>.';
     END IF;
     -- проверка
     IF COALESCE (inGoodsId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не определено значение <Основные средства или Товар>.';
     END IF;

     -- меняем параметр
     IF COALESCE (inInvNumber, '') = ''
     THEN
         inInvNumber:= '0';
     END IF;

     -- находим <Дата ввода в эксплуатацию>
     vbOperDate:= (SELECT OperDate FROM Movement WHERE Id = inMovementId AND DescId = zc_Movement_EntryAsset());


     IF inMovementId > 0
     THEN 
             -- Находим по св-вам:
             vbPartionGoodsId:= (SELECT ObjectLink_Goods.ObjectId
                                 FROM Object
                                      INNER JOIN ObjectLink AS ObjectLink_Goods
                                                            ON ObjectLink_Goods.ObjectId      = Object.Id
                                                           AND ObjectLink_Goods.DescId        = zc_ObjectLink_PartionGoods_Goods()
                                                           AND ObjectLink_Goods.ChildObjectId = inGoodsId
                                      INNER JOIN ObjectLink AS ObjectLink_Unit
                                                            ON ObjectLink_Unit.ObjectId = Object.Id
                                                           AND ObjectLink_Unit.DescId   = zc_ObjectLink_PartionGoods_Unit()
                                                           AND COALESCE (ObjectLink_Unit.ChildObjectId, 0) = COALESCE (inUnitId, 0)
                                      INNER JOIN ObjectLink AS ObjectLink_Storage
                                                            ON ObjectLink_Storage.ObjectId = Object.Id
                                                           AND ObjectLink_Storage.DescId   = zc_ObjectLink_PartionGoods_Storage()
                                                           AND COALESCE (ObjectLink_Storage.ChildObjectId, 0) = COALESCE (inStorageId, 0)
                                 WHERE Object.ObjectCode = inMovementId
                                   AND Object.ValueData  = inInvNumber
                                   AND Object.DescId     = zc_Object_PartionGoods()
                                );

     END IF;

     -- Если не нашли
     IF COALESCE (vbPartionGoodsId, 0) = 0
     THEN
         -- сохранили <Партия - документ> + <Инвентарный номер>
         vbPartionGoodsId := lpInsertUpdate_Object (vbPartionGoodsId, zc_Object_PartionGoods(), inMovementId, inInvNumber);
         -- сохранили <Основные средства> или <Товар>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_Goods(), vbPartionGoodsId, inGoodsId);

         -- сохранили <Подразделение использования>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_Unit(), vbPartionGoodsId, CASE WHEN inUnitId = 0 THEN NULL ELSE inUnitId END);
         -- сохранили <Место хранения>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_Storage(), vbPartionGoodsId, CASE WHEN inStorageId = 0 THEN NULL ELSE inStorageId END);

         -- сохранили <Дата ввода в эксплуатацию>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_PartionGoods_Value(), vbPartionGoodsId, vbOperDate);

     END IF;

     -- Возвращаем значение
     RETURN (vbPartionGoodsId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertFind_Object_PartionGoods (Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.08.16                                        *
*/

-- тест
-- SELECT * FROM lpInsertFind_Object_PartionGoods ();
