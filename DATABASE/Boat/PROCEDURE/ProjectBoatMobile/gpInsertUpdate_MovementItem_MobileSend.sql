-- Function: gpInsertUpdate_MovementItem_MobileSend()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_MobileSend (Integer, Integer, TFloat, TVarChar, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_MobileSend (Integer, Integer, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_MobileSend(
 INOUT ioId                                 Integer   , -- Ключ объекта <Элемент документа>
    IN inGoodsId                            Integer   , -- Товары
    IN inAmount                             TFloat    , -- Количество
    IN inPartNumber                         TVarChar  , --
    IN inPartionCellName                    TVarChar  , -- код или название
    IN inFromId                             Integer   , -- От кого
    IN inToId                               Integer   , -- Кому
    IN inMovementId_OrderClient             Integer   , -- Заказ Клиента
    IN inSession                            TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbIsInsert   Boolean;
   DECLARE vbPartionCellId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbMovementOldId Integer;
   DECLARE vbStatusId   Integer;
   DECLARE vbInvNumber  TVarChar;
   DECLARE vbFromId     Integer;
   DECLARE vbToId       Integer;
   DECLARE vbParentId   Integer;
   DECLARE vbInsertId   Integer;
   DECLARE vbOperDate   TDateTime;
   DECLARE vbGoodsId    Integer;
   DECLARE vbisErased   Boolean;
   DECLARE vbPartNumber TVarChar;
   DECLARE vbAmount     TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());
     vbUserId:= lpGetUserBySession (inSession);
     
     -- Проверим подразделения
     IF COALESCE (inFromId, 0) = 0 OR COALESCE (inToId, 0) = 0
     THEN
       RAISE EXCEPTION 'Ошибка. Не заполнено подразделение.';
     END IF;
     
     vbMovementOldId := 0;
     
     -- Если чтото изменили проверяем
     IF COALESCE(ioId, 0) <> 0
     THEN

       -- Данные по документу
       SELECT Movement.Id,  Movement.StatusId,  Movement.ParentId, Movement.OperDate, Movement.InvNumber, MLO_From.ObjectId, MLO_To.ObjectId, MLO_Insert.ObjectId
            , MovementItem.ObjectId, MovementItem.Amount, MovementItem.isErased, COALESCE (MIString_PartNumber.ValueData,'')
       INTO vbMovementId, vbStatusId, vbParentId, vbOperDate, vbInvNumber, vbFromId, vbToId, vbInsertId
          , vbGoodsId, vbAmount, vbisErased, vbPartNumber
       FROM MovementItem 
            LEFT JOIN MovementItemString AS MIString_PartNumber
                                         ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                        AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
            INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
            LEFT JOIN MovementLinkObject AS MLO_From
                                         ON MLO_From.MovementId = Movement.Id
                                        AND MLO_From.DescId     = zc_MovementLinkObject_From()
            LEFT JOIN MovementLinkObject AS MLO_To
                                         ON MLO_To.MovementId = Movement.Id
                                        AND MLO_To.DescId     = zc_MovementLinkObject_To()
            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId     = zc_MovementLinkObject_Insert()
       WHERE MovementItem.ID = ioId;
       
       IF COALESCE (vbMovementId, 0) = 0
       THEN
         RAISE EXCEPTION 'Ошибка. Не найден документ перемещения по строке.';
       END IF;

       IF COALESCE(vbStatusId, zc_Enum_Status_Erased()) = zc_Enum_Status_Erased()
       THEN
         RAISE EXCEPTION 'Ошибка.Изменение документа № <%> в статусе <%> не возможно.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
       END IF; 
       
       IF vbUserId <> COALESCE(vbInsertId, 0)
       THEN
         RAISE EXCEPTION 'Ошибка.Изменение документа № <%> созданного сотрудником <%> вам запрещено.', vbInvNumber, lfGet_Object_ValueData (vbInsertId);
       END IF; 

       -- Если строка удалена то ругаемся
       IF COALESCE(vbisErased, TRUE) = TRUE
       THEN
         RAISE EXCEPTION 'Ошибка. Изменение удаленных записей запрещено.';
       END IF;
       
       -- Если строка удалена то ругаемся
       IF COALESCE(vbParentId, 0) <> COALESCE(inMovementId_OrderClient, 0)
       THEN
         RAISE EXCEPTION 'Ошибка. Изменение заказа покупателя запрещено.';
       END IF;

       -- Если ничего не изменилось то просто выходим
       IF COALESCE (vbFromId, 0) = inFromId AND COALESCE (vbToId, 0) = inToId AND 
          COALESCE (vbGoodsId, 0) = inGoodsId AND COALESCE (vbAmount, 0) = inAmount AND COALESCE (vbPartNumber, '') = COALESCE (inPartNumber, '')
       THEN
         Return;
       END IF;
              
       -- Отменяес проведение найденого документа если проведен
       IF COALESCE(vbStatusId, zc_Enum_Status_Erased()) = zc_Enum_Status_Complete()
       THEN
         PERFORM gpUnComplete_Movement_Send (vbMovementId, inSession);
       END IF;
       
       -- Если изменилось подраздегения или сотрудник то сбрасываем номер документа перемещения
       IF COALESCE (vbFromId, 0) <> inFromId OR COALESCE (vbToId, 0) <> inToId OR COALESCE (vbInsertId, 0) <> vbUserId
       THEN
         vbMovementOldId := vbMovementId;
         vbMovementId := 0;
       END IF;
     
     END IF;
     
     -- Ищем документ перемещения по сотруднику и заказу покупателя
     IF COALESCE(vbMovementId, 0) = 0
     THEN
     
       if COALESCE((SELECT COUNT(DISTINCT Movement.Id) CountDoc
                    FROM Movement
                         INNER JOIN MovementLinkObject AS MLO_From
                                                       ON MLO_From.MovementId = Movement.Id
                                                      AND MLO_From.DescId     = zc_MovementLinkObject_From()
                                                      AND MLO_From.ObjectId   = inFromId
                         INNER JOIN MovementLinkObject AS MLO_To
                                                       ON MLO_To.MovementId = Movement.Id
                                                      AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                                      AND MLO_To.ObjectId   = inToId
                         INNER JOIN MovementLinkObject AS MLO_Insert
                                                       ON MLO_Insert.MovementId = Movement.Id
                                                      AND MLO_Insert.DescId     = zc_MovementLinkObject_Insert()
                                                      AND MLO_Insert.ObjectId   = vbUserId  
                         INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                AND MovementItem.DescId     = zc_MI_Scan()
                    WHERE Movement.DescId   = zc_Movement_Send()
                      AND Movement.StatusId <> zc_Enum_Status_Erased()
                      AND COALESCE(Movement.ParentId, 0) = COALESCE(inMovementId_OrderClient, 0)
                      AND Movement.OperDate = CURRENT_DATE), 0) > 1
       THEN 
         RAISE EXCEPTION 'Ошибка. Активно более одного документа для сканирования. Удалите лишний.';
       END IF;
       
       SELECT Movement.Id, Movement.StatusId, Movement.InvNumber
       INTO vbMovementId, vbStatusId, vbInvNumber
       FROM Movement
            INNER JOIN MovementLinkObject AS MLO_From
                                          ON MLO_From.MovementId = Movement.Id
                                         AND MLO_From.DescId     = zc_MovementLinkObject_From()
                                         AND MLO_From.ObjectId   = inFromId
            INNER JOIN MovementLinkObject AS MLO_To
                                          ON MLO_To.MovementId = Movement.Id
                                         AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                         AND MLO_To.ObjectId   = inToId
            INNER JOIN MovementLinkObject AS MLO_Insert
                                          ON MLO_Insert.MovementId = Movement.Id
                                         AND MLO_Insert.DescId     = zc_MovementLinkObject_Insert()
                                         AND MLO_Insert.ObjectId   = vbUserId  
            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                   AND MovementItem.DescId     = zc_MI_Scan()
       WHERE Movement.DescId   = zc_Movement_Send()
         AND Movement.StatusId <> zc_Enum_Status_Erased()
         AND COALESCE(Movement.ParentId, 0) = COALESCE(inMovementId_OrderClient, 0)
         AND Movement.OperDate = CURRENT_DATE
       LIMIT 1;

       -- Отменяем проведение найденого документа если проведен
       IF COALESCE(vbStatusId, zc_Enum_Status_Erased()) = zc_Enum_Status_Complete()
       THEN
         PERFORM gpUnComplete_Movement_Send (vbMovementId, inSession);
       END IF;
     END IF;
     
     -- Создаем документ перемещения
     IF COALESCE(vbMovementId, 0) = 0
     THEN
        vbMovementId := lpInsertUpdate_Movement_Send(0
                                                   , CAST (NEXTVAL ('movement_Send_seq') AS TVarChar)
                                                   , CURRENT_DATE
                                                   , inFromId
                                                   , inToId
                                                   , ''
                                                   , ''
                                                   , vbUserId);  
                                                   
        IF COALESCE(inMovementId_OrderClient, 0) <> 0
        THEN
          UPDATE Movement SET ParentId = inMovementId_OrderClient WHERE Movement.Id = vbMovementId AND COALESCE (Movement.ParentId, 0) <> inMovementId_OrderClient;
        END IF;
     END IF;
     
     -- Данные по документу
     SELECT Movement.OperDate, Movement.InvNumber
     INTO vbOperDate, vbInvNumber
     FROM Movement 
     WHERE Movement.ID = vbMovementId;
               
     -- Если заполнен S/N то можно только 1 ша и раз.
     IF COALESCE (inPartNumber, '') <> ''
     THEN

       IF COALESCE (inAmount, 0) <> 1
       THEN
         RAISE EXCEPTION 'Ошибка. Количество комплектующего <%> с S/N <%> должно быть 1.', lfGet_Object_ValueData (inGoodsId), inPartNumber;
       END IF;

       IF EXISTS(SELECT MI.Id 
                 FROM MovementItem AS MI
                      INNER JOIN MovementItemString AS MIString_PartNumber
                                                    ON MIString_PartNumber.MovementItemId = MI.Id
                                                   AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                 WHERE MI.MovementId = vbMovementId
                   AND MI.DescId     = zc_MI_Scan()
                   AND MI.ObjectId   = inGoodsId
                   AND MI.isErased   = FALSE
                   AND MI.Id <> COALESCE (ioId, 0) 
                   AND COALESCE (MIString_PartNumber.ValueData,'') = COALESCE (inPartNumber,''))
       THEN
         RAISE EXCEPTION 'Ошибка. Комплектующее <%> с S/N <%> уже добавлено в инвентаризацию.', lfGet_Object_ValueData (inGoodsId), inPartNumber;
       END IF;
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
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Scan(), inGoodsId, NULL, vbMovementId, inAmount, NULL, vbUserId);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartNumber(), ioId, inPartNumber);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell(), ioId, vbPartionCellId);      

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);
     
     -- сохранили свойство <Заказ Клиента>
     IF COALESCE(inMovementId_OrderClient, 0) <> 0
     THEN
       PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), ioId, inMovementId_OrderClient ::TFloat);       
     END IF; 

     -- Проводим документ из которого изяли товар если есть количество
     IF COALESCE(vbMovementOldId, 0) <> 0 AND
        EXISTS (SELECT MovementItem.ObjectId AS GoodsId
                     , SUM(MovementItem.Amount)::TFloat             AS Amount
                     , COALESCE (MIString_PartNumber.ValueData, '') AS PartNumber
                FROM MovementItem 

                     LEFT JOIN MovementItemString AS MIString_PartNumber
                                                  ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                 AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                                                                     
                WHERE MovementItem.MovementId = vbMovementOldId
                  AND MovementItem.DescId     = zc_MI_Scan()
                  AND MovementItem.isErased   = False
                GROUP BY MovementItem.ObjectId
                       , COALESCE (MIString_PartNumber.ValueData, '')
                HAVING SUM(MovementItem.Amount) <> 0)
     THEN
       PERFORM gpComplete_Movement_Send (vbMovementOldId, inSession);
     END IF;

     -- Проводим документ 
     IF EXISTS (SELECT MovementItem.ObjectId AS GoodsId
                     , SUM(MovementItem.Amount)::TFloat             AS Amount
                     , COALESCE (MIString_PartNumber.ValueData, '') AS PartNumber
                FROM MovementItem 

                     LEFT JOIN MovementItemString AS MIString_PartNumber
                                                  ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                 AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                                                                     
                WHERE MovementItem.MovementId = vbMovementId
                  AND MovementItem.DescId     = zc_MI_Scan()
                  AND MovementItem.isErased   = False
                GROUP BY MovementItem.ObjectId
                       , COALESCE (MIString_PartNumber.ValueData, '')
                HAVING SUM(MovementItem.Amount) <> 0)
     THEN
       PERFORM gpComplete_Movement_Send (vbMovementId, inSession);
     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 13.04.24                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_MobileSend(ioId := 0 , inGoodsId := 261920 , inAmount := 1 , inPartNumber := '' , inPartionCellName := '' , inFromId := 35139 , inToId := 33347 , inMovementId_OrderClient := 908 , inSession := zfCalc_UserAdmin())