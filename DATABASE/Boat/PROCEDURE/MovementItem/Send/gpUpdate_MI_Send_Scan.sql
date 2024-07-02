-- Function: gpUpdate_MI_Send_Scan()

DROP FUNCTION IF EXISTS gpUpdate_MI_Send_Scan (Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Send_Scan(
    IN inId                      Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId              Integer   , -- Ключ объекта <Документ>
    IN inMovementId_OrderClient  Integer   , -- Заказ Клиента
    IN inMovementId_OrderTop     Integer   , -- Заказ Клиента из шапки 
    IN inGoodsId                 Integer   , -- Товары
    IN inAmount                  TFloat    , -- Количество
    IN inPartNumber              TVarChar  , -- № по тех паспорту
 INOUT ioPartionCellName         TVarChar  , -- код или название
   OUT outMovementId_OrderClient Integer   , --
   OUT outInvNumber_OrderClient  TVarChar  ,
   OUT outProductName            TVarChar  ,
   OUT outFromName               TVarChar  ,
   OUT outCIN                    TVarChar  ,
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPartionCellId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Send());
     vbUserId := lpGetUserBySession (inSession);

    IF COALESCE (inMovementId_OrderClient,0) = 0
    THEN
        inMovementId_OrderClient := inMovementId_OrderTop;
    END IF;

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

     -- сохранили свойство <Заказ Клиента>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), inId, inMovementId_OrderClient ::TFloat);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartNumber(), inId, inPartNumber);
    
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell(), inId, vbPartionCellId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

     SELECT Movement_OrderClient.Id                                   AS MovementId_OrderClient
          , zfCalc_InvNumber_isErased ('', Movement_OrderClient.InvNumber, Movement_OrderClient.OperDate, Movement_OrderClient.StatusId) AS InvNumber_OrderClient
          , Object_From.ValueData                                     AS FromName
          , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased) AS ProductName
          , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData,       Object_Product.isErased) AS CIN
   INTO outMovementId_OrderClient
      , outInvNumber_OrderClient
      , outFromName
      , outProductName
      , outCIN
     FROM Movement AS Movement_OrderClient
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement_OrderClient.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

          LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                       ON MovementLinkObject_Product.MovementId = Movement_OrderClient.Id
                                      AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
          LEFT JOIN Object AS Object_Product ON Object_Product.Id = MovementLinkObject_Product.ObjectId

          LEFT JOIN ObjectString AS ObjectString_CIN
                                 ON ObjectString_CIN.ObjectId = Object_Product.Id
                                AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()
     WHERE Movement_OrderClient.Id = inMovementId_OrderClient
     ;

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