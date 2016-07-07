-- Function: gpInsertUpdate_MI_Child_Over_Auto()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Child_Over_Auto (Integer, Integer, TDateTime, Integer, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Child_Over_Auto(
    IN inUnitFromId          Integer   , -- от кого
    IN inUnitToId            Integer   , -- кому
    IN inOperDate            TDateTime , -- дата
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inRemains	     TFloat    , -- 
    IN inPrice               TFloat    , -- Цена от кого
    IN inMCS                 TFloat    , -- период для расчета НТЗ
    IN inMinExpirationDate   TDateTime , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Void
AS  
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbMovementItemChildId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Over());
    vbUserId := inSession;

    IF COALESCE(inAmount, 0) <> 0 THEN
      -- ищем ИД документа (ключ - дата, Подразделение) 
      SELECT Movement.Id  
      INTO vbMovementId
      FROM Movement
        Inner Join MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.ID
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                     AND MovementLinkObject_Unit.ObjectId = inUnitFromId
        
      WHERE Movement.DescId = zc_Movement_Over() AND Movement.OperDate = inOperDate
          AND Movement.StatusId <> zc_Enum_Status_Erased();
    
      IF COALESCE (vbMovementId,0) = 0 THEN
          RAISE EXCEPTION 'Ошибка.Документ не определен.';
      END IF;
      
      -- Ищеи ИД строки (ключ - ид документа, товар)
      SELECT MovementItem.Id
       INTO vbMovementItemId
      FROM MovementItem
      WHERE MovementItem.MovementId = vbMovementId 
        AND MovementItem.DescId = zc_MI_Master()
        AND MovementItem.ObjectId = inGoodsId;



   --   IF COALESCE (vbMovementItemId,0) = 0 THEN
   --       RAISE EXCEPTION 'Ошибка.Строка мастера не определена.';
   --   END IF;

     IF COALESCE (vbMovementItemId,0) <> 0 THEN
       -- Ищем строку Чайлд
    /*   SELECT MovementItem.Id
        INTO vbMovementItemChildId
       FROM MovementItem
       WHERE MovementItem.MovementId = vbMovementId 
         AND MovementItem.DescId = zc_MI_Child()
         AND MovementItem.ParentId = vbMovementItemId
         AND MovementItem.ObjectId = inUnitToId;
    */
        -- сохранили строку документа
        vbMovementItemId := lpInsertUpdate_MI_Over_Child(ioId               := 0 --COALESCE(vbMovementItemChildId,0) ::Integer
                                                       , inMovementId       := vbMovementId
                                                       , inParentId         := vbMovementItemId                                
                                                       , inUnitId           := inUnitToId
                                                       , inAmount           := inAmount
                                                       , inRemains          := inRemains
                                                       , inPrice            := inPrice
                                                       , inMCS              := inMCS
                                                       , inMinExpirationDate:= inMinExpirationDate
                                                       , inComment          := Null :: TVarChar
                                                       , inUserId           := vbUserId
                                                       );
      
      END IF;
  
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 07.07.16         *
*/

-- тест
--select * from gpInsertUpdate_MI_Child_Over_Auto(inUnitId := 183292 , inToId := 183290 , inOperDate := ('01.06.2016')::TDateTime , inGoodsId := 3022 , inRemainsMCS_result := 0.8 , inPrice_from := 155.1 , inPrice_to := 155.1 ,  inSession := '3');
