-- Function: gpInsertUpdate_MovementItem_OrderClient()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send(Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Send(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inMovementId_OrderClient Integer, -- Заказ Клиента
    IN inMovementId_OrderTop Integer, -- Заказ Клиента из шапки
    IN inGoodsId             Integer   , -- Товары
    IN ioAmount              TFloat    , -- Количество
    IN inOperPrice           TFloat    , -- Цена со скидкой
    IN inCountForPrice       TFloat    , -- Цена за кол.
    IN inPartNumber          TVarChar  , --№ по тех паспорту
 INOUT ioPartionCellName     TVarChar  , -- код или название
    IN inComment             TVarChar  , --
 INOUT ioIsOn                Boolean   , -- вкл
   OUT outIsErased           Boolean   , -- удален
   OUT outMovementId_OrderClient Integer   , --
   OUT outInvNumber_OrderClient  TVarChar  ,
   OUT outProductName        TVarChar  ,
   OUT outFromName           TVarChar  ,
   OUT outCIN                TVarChar  ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbPartionCellId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Send());
     vbUserId := lpGetUserBySession (inSession);

     -- Если были сканирования
     IF EXISTS (SELECT MovementItem.Id
                FROM MovementItem 
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Scan())
     THEN
       RAISE EXCEPTION 'Ошибка.Изменять документ созданный из мобильного приложения запрешщено.';
     END IF;

     -- нужен ПОИСК
     IF ioId < 0
     THEN
             -- Проверка
             IF 1 < (SELECT COUNT(*) FROM MovementItem AS MI
                                 LEFT JOIN MovementItemString AS MIString_PartNumber
                                                              ON MIString_PartNumber.MovementItemId = MI.Id
                                                             AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                     WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE
                       AND MI.ObjectId = inGoodsId
                       AND COALESCE (MIString_PartNumber.ValueData,'') = COALESCE (inPartNumber,'')
                     )
             THEN
                 RAISE EXCEPTION 'Ошибка.Найдено несколько строк с таким комплектующим.%<%>.', CHR (13), lfGet_Object_ValueData (inGoodsId);
             END IF;
             -- нашли
             ioId:= (SELECT MI.Id FROM MovementItem AS MI
                                 LEFT JOIN MovementItemString AS MIString_PartNumber
                                                              ON MIString_PartNumber.MovementItemId = MI.Id
                                                             AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                     WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE
                       AND MI.ObjectId = inGoodsId
                       AND COALESCE (MIString_PartNumber.ValueData,'') = COALESCE (inPartNumber,'')
                     );
         --
         ioAmount:= ioAmount + COALESCE ((SELECT MI.Amount FROM MovementItem AS MI WHERE MI.Id = ioId), 0);

     END IF;

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) <= 0;

     -- замена
     IF vbIsInsert = TRUE THEN ioIsOn:= TRUE; END IF;

     IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.Id = ioId AND MovementItem.isErased = TRUE)
     THEN
         -- надо восстановить
         outIsErased := gpMovementItem_Send_SetUnErased (ioId, inSession);
     ENd IF;

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
                 vbPartionCellId := gpInsertUpdate_Object_PartionCell (ioId	     := 0                                            ::Integer
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
     SELECT tmp.ioId
            INTO ioId
     FROM lpInsertUpdate_MovementItem_Send (ioId
                                          , inMovementId
                                          , inMovementId_OrderClient
                                          , inGoodsId
                                          , vbPartionCellId  --inPartionCellId
                                          , ioAmount
                                          , inOperPrice
                                          , inCountForPrice
                                          , inPartNumber
                                          , inComment
                                          , vbUserId
                                           ) AS tmp;

     -- (разделила т.к. если внесут еще какие-то изменения в строку то ощибка что элемент удален)
     IF COALESCE (ioIsOn, FALSE) = FALSE
     THEN
         -- ставим отметку об удалении
         outIsErased := gpMovementItem_Send_SetErased (ioId, inSession);
     ENd IF;



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
 09.01.24         *
 15.12.22         *
 16.09.21         *
 23.06.21         *
*/

-- тест
--