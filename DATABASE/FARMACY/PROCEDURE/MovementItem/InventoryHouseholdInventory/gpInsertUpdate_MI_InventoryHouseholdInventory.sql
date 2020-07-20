-- Function: gpInsertUpdate_MI_InventoryHouseholdInventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_InventoryHouseholdInventory (Integer, Integer, Integer, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_InventoryHouseholdInventory(
 INOUT ioId                           Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId                   Integer   , -- Ключ объекта <Документ>
    IN inPartionHouseholdInventoryId  Integer   , -- Партия хозяйственного инвентаря
    IN inAmount                       TFloat    , -- Количество
    IN inComment                      TVarChar  , -- Комментарий
    IN inSession                      TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbUnitId     Integer;
   DECLARE vbInvNumber  TVarChar;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_InventoryHouseholdInventory());
    
    IF COALESCE (inAmount, 0) <> 1 AND COALESCE (inAmount, 0) <> 0
    THEN
        RAISE EXCEPTION 'Ошибка.Количество должно быть 1 или 0.';    
    END IF;

    --определяем данные документа
    SELECT MovementLinkObject_Unit.ObjectId                             AS UnitId, Movement.InvNumber
    INTO vbUnitId, vbInvNumber 
    FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE Movement.Id = inMovementId;


     -- сохранили
    ioId := lpInsertUpdate_MI_InventoryHouseholdInventory (ioId                           := ioId
                                                        , inMovementId                   := inMovementId
                                                        , inPartionHouseholdInventoryId  := inPartionHouseholdInventoryId
                                                        , inAmount                       := inAmount
                                                        , inComment                      := inComment
                                                        , inUserId                       := vbUserId
                                                         );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_MI_InventoryHouseholdInventory (Integer, Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 17.07.20                                                                      *
*/

-- тест
-- select * from gpInsertUpdate_MI_InventoryHouseholdInventory(ioId := 0 , inMovementId := 19386934 , inGoodsId := 427 , inAmount := 10 , inNewExpirationDate := ('22.07.2020')::TDateTime , inContainerId := 20253754 ,  inSession := '3');
