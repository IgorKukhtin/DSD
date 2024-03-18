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
   DECLARE vbUnitId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbPartionCellId Integer;
   
   DECLARE vbMovementId_OrderClient Integer;
   DECLARE vbPartionId Integer;
   DECLARE vbPartnerId Integer;
   DECLARE vbPrice     TFloat;
   DECLARE vbComment   TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());
     vbUserId:= lpGetUserBySession (inSession);

     -- определяются параметры из документа
     IF COALESCE((SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inMovementId), zc_Enum_Status_Erased()) <> zc_Enum_Status_UnComplete()
     THEN
       RETURN;
     END IF; 

     -- Ищем может уже есть твкой товар
     IF COALESCE(ioId, 0) = 0
     THEN

       -- нашли
       ioId:= COALESCE((SELECT MI.Id FROM MovementItem AS MI
                                     LEFT JOIN MovementItemString AS MIString_PartNumber
                                                                  ON MIString_PartNumber.MovementItemId = MI.Id
                                                                 AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                        WHERE MI.MovementId = inMovementId
                          AND MI.DescId     = zc_MI_Master()
                          AND MI.ObjectId   = inGoodsId
                          AND MI.isErased   = FALSE
                          AND COALESCE (MIString_PartNumber.ValueData,'') = COALESCE (inPartNumber,'')
                       ), 0);
     END IF;


     IF COALESCE(ioId, 0) <> 0
     THEN
     
       SELECT MI.Amount + inAmount
            , COALESCE (MIFloat_MovementId.ValueData, 0) :: Integer AS MovementId_OrderClient
            , COALESCE (MILinkObject_Partner.ObjectId, 0) 
            , COALESCE (MILO_PartionCell.ObjectId, 0)
            , COALESCE (MIFloat_Price.ValueData, 0)        AS Price
            , COALESCE (MIString_Comment.ValueData,'')     AS Comment
       INTO inAmount, vbMovementId_OrderClient, vbPartnerId, vbPartionCellId, vbPrice, vbComment
       FROM MovementItem AS MI 
            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MI.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
            LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                        ON MIFloat_MovementId.MovementItemId = MI.Id
                                       AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MI.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Partner
                                             ON MILinkObject_Partner.MovementItemId = MI.Id
                                            AND MILinkObject_Partner.DescId         = zc_MILinkObject_Partner()
            LEFT JOIN MovementItemLinkObject AS MILO_PartionCell
                                             ON MILO_PartionCell.MovementItemId = MI.Id
                                            AND MILO_PartionCell.DescId = zc_MILinkObject_PartionCell()

       WHERE MI.Id = ioId;
     
     ELSE
       vbMovementId_OrderClient := 0;
       vbPartnerId := 0;
       vbPartionCellId := 0;
       vbPrice := 0;
       vbComment := '';  
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
     
     -- определяются параметры из документа
     SELECT tmp.ioId
     INTO ioId
     FROM lpInsertUpdate_MovementItem_Inventory (ioId             := ioId
                                               , inMovementId      := inMovementId
                                               , inMovementId_OrderClient := vbMovementId_OrderClient
                                               , inGoodsId         := inGoodsId
                                               , inPartnerId       := vbPartnerId
                                               , inPartionCellId   := vbPartionCellId
                                               , ioAmount          := inAmount
                                               , inTotalCount      := inAmount
                                               , inTotalCount_old  := inAmount
                                               , ioPrice           := vbPrice
                                               , inPartNumber      := inPartNumber
                                               , inComment         := vbComment
                                               , inUserId          := vbUserId
                                                ) AS tmp;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 01.03.24                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_MobileInventory(ioId := 0, inMovementId := 3172, inGoodsId := 9718, inAmount := 1, inPartNumber := '', inPartionCellName := '', inSession := zfCalc_UserAdmin())