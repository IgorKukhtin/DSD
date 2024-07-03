-- Function: gpUpdate_MI_Inventory_Scan()

DROP FUNCTION IF EXISTS gpUpdate_MI_Inventory_Scan (Integer, Integer, Integer, TFloat, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Inventory_Scan(
    IN inId                      Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId              Integer   , -- Ключ объекта <Документ>
    IN inGoodsId                 Integer   , -- Товары
    IN inAmount                  TFloat    , -- Количество
    IN inPartNumber              TVarChar  , -- № по тех паспорту
 INOUT ioPartionCellName         TVarChar  , -- код или название
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPartionCellId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Inventory());
     vbUserId := lpGetUserBySession (inSession);

     --находим ячейку хранения, если нет такой создаем
     IF COALESCE (ioPartionCellName, '') <> '' THEN
         -- !!!поиск ИД !!!
         --если ввели код ищем по коду, иначе по названию
         IF zfConvert_StringToNumber (ioPartionCellName) <> 0
         THEN
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = zfConvert_StringToNumber (ioPartionCellName)
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
             --если не нашли ошибка
             IF COALESCE (vbPartionCellId,0) = 0
             THEN
                 RAISE EXCEPTION 'Ошибка.Не найдена ячейка с кодом <%>.', ioPartionCellName;
             END IF;
         ELSE
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioPartionCellName))
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
             --если не нашли Создаем
             IF COALESCE (vbPartionCellId,0) = 0
             THEN
                 --
                 vbPartionCellId := gpInsertUpdate_Object_PartionCell (ioId      := 0                                            ::Integer
                                                                     , inCode    := lfGet_ObjectCode(0, zc_Object_PartionCell()) ::Integer
                                                                     , inName    := TRIM (ioPartionCellName)                     ::TVarChar
                                                                     , inLevel   := 0           ::TFloat
                                                                     , inComment := ''          ::TVarChar
                                                                     , inSession := inSession   ::TVarChar
                                                                      );

             END IF;
         END IF;
         --
         ioPartionCellName := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbPartionCellId);
     ELSE
         vbPartionCellId := NULL ::Integer;
     END IF;


     -- сохранили <Элемент документа>
     PERFORM lpInsertUpdate_MovementItem (inId, zc_MI_Scan(), inGoodsId, NULL, inMovementId, inAmount, NULL, vbUserId);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartNumber(), inId, inPartNumber);
    
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell(), inId, vbPartionCellId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);


     -- пересчитали Итоговые суммы
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.07.24         *
*/

-- тест
--