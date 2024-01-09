-- Function: gpInsertUpdate_MovementItem_Inventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer,Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer,Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Inventory(
 INOUT ioId                                 Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId                         Integer   , -- Ключ объекта <Документ>
    IN inMovementId_OrderClient             Integer   , -- Заказ Клиента
    IN inGoodsId                            Integer   , -- Товары
    IN inPartionId                          Integer   , -- Партия  
    IN inPartnerId                          Integer   , -- поставщик
 INOUT ioAmount                             TFloat    , -- Количество 
    IN inTotalCount                         TFloat    , -- Количество Итого
    IN inTotalCount_old                     TFloat    , -- Количество Итого
 INOUT ioPrice                              TFloat    , -- Цена
   OUT outAmountSumm                        TFloat    , -- Сумма расчетная
    IN inPartNumber                         TVarChar  , --       
 INOUT ioPartionCellName                    TVarChar  , -- код или название
    IN inComment                            TVarChar  , -- примечание
    IN inSession                            TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbPartionCellId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());
     vbUserId:= lpGetUserBySession (inSession);


     -- замена
     -- IF ioAmount = 0 THEN ioAmount:= 1; END IF;

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
                                                                     , inName    := TRIM (ioPartionCellName)                          ::TVarChar
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


     -- определяются параметры из документа
     SELECT tmp.ioId, tmp.ioAmount, tmp.ioPrice, tmp.outAmountSumm
            INTO ioId, ioAmount, ioPrice, outAmountSumm
     FROM lpInsertUpdate_MovementItem_Inventory (ioId              := ioId
                                               , inMovementId      := inMovementId
                                               , inMovementId_OrderClient := inMovementId_OrderClient
                                               , inGoodsId         := inGoodsId
                                               , inPartnerId       := inPartnerId
                                               , inPartionCellId   := vbPartionCellId
                                               , ioAmount          := ioAmount
                                               , inTotalCount      := inTotalCount
                                               , inTotalCount_old  := inTotalCount_old
                                               , ioPrice           := ioPrice
                                               , inPartNumber      := inPartNumber
                                               , inComment         := inComment
                                               , inUserId          := vbUserId
                                                ) AS tmp;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.01.24         *
 17.02.22         *
*/

-- тест
-- 