-- Function: gpInsertUpdate_MI_Inventory_PartionCell()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Inventory_PartionCell (Integer, Integer, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Inventory_PartionCell (Integer, Integer, TVarChar, Boolean, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Inventory_PartionCell(
    IN inId                      Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId              Integer   , -- Ключ объекта <Документ>
 INOUT ioPartionCellName_1       TVarChar   , --
    IN inisPartionCell_Close_1   Boolean    ,
    IN inPartionGoodsDate        TDateTime , -- Дата партии
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbPartionCellId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());

     IF COALESCE (inId,0) = 0
     THEN
         RETURN;
     END IF;


     --  1
     IF COALESCE (ioPartionCellName_1, '') <> '' AND TRIM (ioPartionCellName_1) <> '0'
     THEN
         -- !!!поиск ИД !!!
         --если ввели код ищем по коду, иначе по названию
         IF zfConvert_StringToNumber (ioPartionCellName_1) <> 0
         THEN
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName_1)
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
         ELSE
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ValueData ILIKE TRIM (ioPartionCellName_1)
                                  AND Object.DescId    = zc_Object_PartionCell()
                               );
         END IF;

         -- если не нашли
         IF COALESCE (vbPartionCellId, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найдена ячейка с % = <%>.'
                           , CASE WHEN zfConvert_StringToNumber (ioPartionCellName_1) > 0 THEN 'Кодом =' ELSE 'Названием =' END
                           , ioPartionCellName_1
                            ;
         END IF;

         -- сохранили связь с <Ячейка хранения>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_1(), inId, vbPartionCellId);

         --
         ioPartionCellName_1 := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPartionCellId);

     ELSE
         -- обнулили связь с <Ячейка хранения>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_1(), inId, NULL);
         --
         ioPartionCellName_1:= '';
     END IF;


     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_1(), inId, inisPartionCell_Close_1);

     -- меняем параметр
     IF inPartionGoodsDate <= '01.01.1900' THEN inPartionGoodsDate:= NULL; END IF;

     -- сохранили свойство <Дата партии>
     IF COALESCE (inPartionGoodsDate, zc_DateStart()) <> zc_DateStart() OR EXISTS (SELECT 1 FROM MovementItemDate AS MID WHERE MID.MovementItemId = inId AND MID.DescId = zc_MIDate_PartionGoods())
     THEN
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), inId, inPartionGoodsDate);
     END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.01.24         *
*/

-- тест
--