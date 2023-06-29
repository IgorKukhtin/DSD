-- Function: lpInsertUpdate_MovementItem_SendAsset()

--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_SendAsset (Integer, Integer, Integer, TFloat, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_SendAsset (Integer, Integer, Integer, TFloat, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_SendAsset(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inContainerId         Integer   , -- Партия ОС 
    IN inStorageId           Integer   , -- Место хранения
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;


     -- Проверка
     IF COALESCE (inContainerId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Для ОС <%> не установлена партия.', lfGet_Object_ValueData_sh (inGoodsId);
     END IF;

     -- Проверка
     IF NOT EXISTS (SELECT 1 FROM Object WHERE Object.Id = inGoodsId AND Object.DescId = zc_Object_Asset())
    AND NOT EXISTS (SELECT 1
                    FROM Container
                         INNER JOIN ContainerLinkObject AS CLO_Unit
                                                        ON CLO_Unit.ContainerId = Container.Id
                                                       AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                       AND CLO_Unit.ObjectId > 0
                         LEFT JOIN Object ON Object.Id = Container.ObjectId
                         LEFT JOIN ContainerLinkObject AS CLO_AssetTo ON CLO_AssetTo.ContainerId = Container.Id
                                                                     AND CLO_AssetTo.DescId = zc_ContainerLinkObject_AssetTo()
                         LEFT JOIN ContainerLinkObject AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = Container.Id
                                                                          AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                         LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId
                    WHERE Container.Id = inContainerId
                      AND Container.DescId   IN (zc_Container_Count(), zc_Container_CountAsset())
                      AND COALESCE (Container.Amount, 0) <> 0
                      AND (Object_PartionGoods.ObjectCode > 0 OR CLO_AssetTo.ObjectId > 0 OR Object.DescId = zc_Object_Asset())
                   )
     THEN
         RAISE EXCEPTION 'Ошибка.Значение ОС не может быть пустым (<%>).', lfGet_Object_ValueData_sh (inGoodsId);
     END IF;


      -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, null);

     -- сохранили свойство <Партия ОС>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContainerId(), ioId, inContainerId);

     -- сохранили связь с <Место хранения> - для партии прихода на МО 
     IF COALESCE (inStorageId,0) <> 0 OR EXISTS (SELECT 1 FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = ioId AND MILO.DescId = zc_MILinkObject_Storage())
     THEN
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Storage(), ioId, inStorageId);
     END IF;

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.06.23         *
 16.03.20         *
*/

-- тест
-- select * from gpInsertUpdate_MovementItem_SendAsset(ioId := 0 , inMovementId := 16151863 , inGoodsId := 4071624 , inAmount := 0 , inContainerId := 2682725 ,  inSession := '5');
