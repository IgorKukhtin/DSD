-- Function: gpInsertUpdate_Movement_OrderInternalPromo()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderInternalPromo (Integer, TVarChar, TDateTime, TDateTime, TFloat, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderInternalPromo (Integer, TVarChar, TDateTime, TDateTime, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderInternalPromo (Integer, TVarChar, TDateTime, TDateTime, TFloat, TFloat, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderInternalPromo (Integer, TVarChar, TDateTime, TDateTime, TFloat, TFloat, TFloat, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderInternalPromo (Integer, TVarChar, TDateTime, TDateTime, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderInternalPromo(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа
    IN inStartSale             TDateTime  , -- Дата начала продаж
    IN inTotalSummPrice        TFloat     , -- итого сумма по ценам прайса
    IN inTotalSummSIP          TFloat     , -- итого сумма по ценам сип
    IN inTotalAmount           TFloat     , -- Крличество для распр.
    IN inRetailId              Integer    , -- Торговая сеть
    IN inComment               TVarChar   , -- Примечание
    IN inDaysGrace             Integer    , -- Дней отсрочки
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbRetailId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderInternalPromo());
    vbUserId := inSession;
    
    -- находим сохраненное значене
      vbRetailId := (SELECT MovementLinkObject_Retail.ObjectId
                     FROM MovementLinkObject AS MovementLinkObject_Retail
                     WHERE MovementLinkObject_Retail.MovementId = ioId
                       AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail());

     -- Eсли выбирают др. сеть все строки метим на удаление
     IF vbRetailId <> 0 AND vbRetailId <> inRetailId
     THEN
         RAISE EXCEPTION 'Ошибка. Данные заполнены. Изменение Сети запрещено'; 
         --
         /* UPDATE MovementItem
            SET isErased = TRUE
            WHERE MovementItem.MovementId = ioId;
         */
     END IF;
     
     
    -- считаем итого кол-во
    vbAmount := COALESCE ( (SELECT SUM(MovementItem.Amount) FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE) , 0) :: TFloat;
    
    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement_OrderInternalPromo (ioId            := ioId
                                                      , inInvNumber     := inInvNumber
                                                      , inOperDate      := inOperDate
                                                      , inStartSale     := inStartSale
                                                      , inAmount        := vbAmount
                                                      , inRetailId      := inRetailId
                                                      , inTotalSummPrice:= inTotalSummPrice
                                                      , inTotalSummSIP  := inTotalSummSIP
                                                      , inTotalAmount   := inTotalAmount
                                                      , inComment       := inComment
                                                      , inDaysGrace     := inDaysGrace
                                                      , inUserId        := vbUserId
                                                      );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.04.19         *
*/