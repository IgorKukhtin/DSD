-- Function: gpInsert_MI_FarmacyInventory()

DROP FUNCTION IF EXISTS gpInsert_MI_FarmacyInventory (Integer, TDateTime, Integer, TFloat, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_FarmacyInventory(
    IN inUnitId      Integer   , -- Подразделение
    IN inOperDate    TDateTime , -- Дата инвентаризации
    IN inGoodsId     Integer   , -- Товар
    IN inAmount      TFloat    , -- Количество тек.пользователя
    IN inDateInput   TVarChar  , -- Дата ввода
    IN inUserInputId Integer   , -- Кто ввел
    IN inCheckId     Integer   , -- Чек
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbMovementId Integer;

   DECLARE vbId         Integer;
   DECLARE vbChildId    Integer;
   DECLARE vbAmount     TFloat;
   DECLARE vbAmountUser TFloat;
   DECLARE vbPrice      TFloat;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());

    --определяем подразделение и дату документа
    
    vbMovementId := ( SELECT Movement.Id
                      FROM Movement
                           INNER JOIN MovementLinkObject AS MLO_Unit
                                                         ON MLO_Unit.MovementId = Movement.Id
                                                        AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
                                                        AND MLO_Unit.ObjectId = inUnitId
                           INNER JOIN MovementBoolean AS MovementBoolean_FullInvent
                                                      ON MovementBoolean_FullInvent.MovementId = Movement.Id
                                                     AND MovementBoolean_FullInvent.DescId = zc_MovementBoolean_FullInvent()
                                                     AND MovementBoolean_FullInvent.ValueData = True
                      WHERE Movement.OperDate >= inOperDate
                        AND Movement.OperDate <= inOperDate + INTERVAL '4 DAY'
                        AND Movement.DescId = zc_Movement_Inventory()
                        AND Movement.StatusId = zc_Enum_Status_UnComplete());
      
    IF COALESCE(vbMovementId, 0) = 0
    THEN
      RAISE EXCEPTION 'Полная инвентаризация по подразделению <%> не найдена.%Необходимо создать документ полной инв в Farmacy', lfGet_Object_ValueData (inUnitId), Chr(13);
    END IF;
      

    --определяем ИД строки
    vbId := (SELECT MovementItem.Id
             FROM MovementItem
             WHERE MovementItem.MovementId = vbMovementId
               AND MovementItem.DescId = zc_MI_Master()
               AND MovementItem.ObjectId = inGoodsId);
               
    IF EXISTS (SELECT MovementItem.Id
               FROM MovementItem
                    INNER JOIN MovementItemDate AS MIDate_Insert
                                                ON MIDate_Insert.MovementItemId = MovementItem.Id
                                               AND MIDate_Insert.DescId = zc_MIDate_Insert()
                                               AND MIDate_Insert.ValueData = inDateInput::TDateTime
                    LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                               AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
               WHERE MovementItem.ParentId = vbId
                 AND MovementItem.DescId   = zc_MI_Child()
                 AND COALESCE(MIFloat_MovementId.ValueData, 0)::Integer = COALESCE(inCheckId, 0) 
                 AND MovementItem.isErased = FALSE
               )
    THEN
      RETURN;
    END IF;


    -- Нужно определить итого кол-во (последнее кол-во по всем пользователям + текущее)
    -- и кол-во пользователей, сформировавших остаток
    SELECT SUM (tmp.Amount) AS  Amount
         , SUM (tmp.AmountUser) AS  AmountUser
    INTO vbAmount, vbAmountUser
    FROM (SELECT MovementItem.Amount                                                                  AS Amount
               , CASE WHEN MovementItem.ObjectId = inUserInputId then MovementItem.Amount ELSE 0 END  AS AmountUser 
               , CAST (ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY MovementItem.ObjectId, MIDate_Insert.ValueData DESC) AS Integer) AS Num
          FROM MovementItem
               LEFT JOIN MovementItemDate AS MIDate_Insert
                                          ON MIDate_Insert.MovementItemId = MovementItem.Id
                                         AND MIDate_Insert.DescId = zc_MIDate_Insert()
          WHERE MovementItem.ParentId  = vbId
            AND MovementItem.DescId    = zc_MI_Child()
            AND MovementItem.isErased  = FALSE
           ) AS tmp
    WHERE tmp.Num = 1;

    vbAmount := COALESCE (inAmount, 1) + COALESCE (vbAmount, 0);
    vbAmountUser := COALESCE (inAmount, 1) + COALESCE (vbAmountUser, 0);
    
    -- определяем цену
    vbPrice := (SELECT ROUND(Price_Value.ValueData,2)::TFloat
                FROM ObjectLink AS Price_Unit
                       INNER JOIN ObjectLink AS Price_Goods
                                             ON Price_Goods.ObjectId = Price_Unit.ObjectId
                                            AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                            AND Price_Goods.ChildObjectId = inGoodsId
                       LEFT JOIN ObjectFloat AS Price_Value
                                             ON Price_Value.ObjectId = Price_Unit.ObjectId
                                            AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                WHERE Price_Unit.ChildObjectId = inUnitId
                  AND Price_Unit.DescId = zc_ObjectLink_Price_Unit());


    -- сохранили
    vbId:= lpInsertUpdate_MovementItem_Inventory (ioId                 := COALESCE(vbId,0)
                                                , inMovementId         := vbMovementId
                                                , inGoodsId            := inGoodsId
                                                , inAmount             := vbAmount
                                                , inPrice              := COALESCE(vbPrice, 0)
                                                , inSumm               := (vbAmount * COALESCE(vbPrice, 0))::TFloat --outSumm
                                                , inComment            := '' ::TVarChar
                                                , inUserId             := vbUserId) AS tmp;

    -- Записываем подчиненный элемент
    IF COALESCE(vbId,0) <> 0
    THEN
                                                      
       -- сохранили <Элемент документа>
       vbChildId := lpInsertUpdate_MovementItem (0, zc_MI_Child(), inUserInputId, vbMovementId, vbAmountUser, vbId);
       
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), vbChildId, inDateInput::TDateTime);


       -- сохранили свойство <>
       PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), vbChildId, inCheckId);

       -- сохранили протокол
       PERFORM lpInsert_MovementItemProtocol (vbChildId, vbUserId, True);
                                                  
    END IF;
    
    -- !!!ВРЕМЕННО для ТЕСТА!!!
    /*IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION 'Тест прошел успешно для <%> <%> <%> <%>', inUnitId, vbId, inUserInputId, inSession;
    END IF;*/
    

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 29.04.23                                                       *
*/

-- тест

-- select * from gpInsert_MI_FarmacyInventory(inUnitId := 377610 , inOperDate := ('15.06.2023')::TDateTime , inGoodsId := 6307 , inAmount := -2 , inDateInput := '2023-06-15 08:12:03.000' , inUserInputId := 4085760 , inCheckId := 32399450 ,  inSession := '3');


