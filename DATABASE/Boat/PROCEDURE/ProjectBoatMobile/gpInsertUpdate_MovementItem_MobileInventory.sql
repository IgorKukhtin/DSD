-- Function: gpInsertUpdate_MovementItem_MobileInventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_MobileInventory (Integer, Integer, Integer, TFloat, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_MobileInventory(
 INOUT ioId                                 Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId                         Integer   , -- Ключ объекта <Документ>
    IN inGoodsId                            Integer   , -- Товары
    IN inAmount                             TFloat    , -- Количество
    IN inPartNumber                         TVarChar  , --
    IN inPartionCellName                    TVarChar  , -- код или название
    IN inSession                            TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbPartionCellId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbInvNumber TVarChar;
   
   DECLARE vbMovementId_OrderClient Integer;
   DECLARE vbPartionId Integer;
   DECLARE vbPartnerId Integer;
   DECLARE vbPrice     TFloat;
   DECLARE vbComment   TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());
     vbUserId:= lpGetUserBySession (inSession);

     -- определяются параметры документа
     SELECT Movement.StatusId
          , Movement.InvNumber
     INTO vbStatusId, vbInvNumber
     FROM Movement
     WHERE Movement.Id = inMovementId;

     IF COALESCE(vbStatusId, zc_Enum_Status_Erased()) <> zc_Enum_Status_UnComplete()
     THEN
       RAISE EXCEPTION 'Ошибка.Изменение документа № <%> в статусе <%> не возможно.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF; 
     
     -- Ищем может уже есть такой товар ругаемся
     IF EXISTS(SELECT MI.Id 
               FROM MovementItem AS MI
                    LEFT JOIN MovementItemString AS MIString_PartNumber
                                                 ON MIString_PartNumber.MovementItemId = MI.Id
                                                AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
               WHERE MI.MovementId = inMovementId
                 AND MI.DescId     = zc_MI_Master()
                 AND MI.ObjectId   = inGoodsId
                 AND MI.isErased   = FALSE
                 AND COALESCE (MIString_PartNumber.ValueData,'') = COALESCE (inPartNumber,''))
     THEN
       RAISE EXCEPTION 'Ошибка. Комплектующее <%> с S/N <%> уже сохранено в инвентаризации.', lfGet_Object_ValueData (inGoodsId), vbInvNumber;
     END IF;

     

     --находим ячейку хранения, если нет такой создаем
     IF COALESCE (inPartionCellName, '') <> '' THEN
         -- !!!поиск ИД !!!
         --если ввели код ищем по коду, иначе по названию
         IF zfConvert_StringToNumber (inPartionCellName) <> 0
         THEN
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE Object.ObjectCode = zfConvert_StringToNumber (inPartionCellName)
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
             --если не нашли ошибка
             IF COALESCE (vbPartionCellId,0) = 0
             THEN
                 RAISE EXCEPTION 'Ошибка.Не найдена ячейка с кодом <%>.', inPartionCellName;
             END IF;
         ELSE
             vbPartionCellId:= (SELECT Object.Id
                                FROM Object
                                WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inPartionCellName))
                                  AND Object.DescId     = zc_Object_PartionCell()
                               );
             --если не нашли Создаем
             IF COALESCE (vbPartionCellId,0) = 0
             THEN
                 --
                 vbPartionCellId := gpInsertUpdate_Object_PartionCell (ioId	     := 0                                            ::Integer
                                                                     , inCode    := lfGet_ObjectCode(0, zc_Object_PartionCell()) ::Integer
                                                                     , inName    := TRIM (inPartionCellName)                          ::TVarChar
                                                                     , inLevel   := 0           ::TFloat
                                                                     , inComment := ''          ::TVarChar
                                                                     , inSession := inSession   ::TVarChar
                                                                      );

             END IF;
         END IF;
         --
     END IF;
     
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Detail(), inGoodsId, NULL, inMovementId, inAmount, NULL, vbUserId);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartNumber(), ioId, inPartNumber);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell(), ioId, vbPartionCellId);      

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 01.03.24                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_MobileInventory(ioId := 0, inMovementId := 3179 , inGoodsId := 261920, inAmount := 1, inPartNumber := '', inPartionCellName := '', inSession := zfCalc_UserAdmin())