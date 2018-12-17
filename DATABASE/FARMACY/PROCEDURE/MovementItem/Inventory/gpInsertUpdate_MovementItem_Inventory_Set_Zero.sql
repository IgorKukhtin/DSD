-- Function: gpInsertUpdate_MovementItem_Inventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory_Set_Zero (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Inventory_Set_Zero(
    IN inMovementId          Integer   , -- Ключ объекта <Документ Инвентаризации>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbUserUnitId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());
	 
     IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
               WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = 308121) -- Для роли "Кассир аптеки"
     THEN
     
        vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
        IF vbUnitKey = '' THEN
           vbUnitKey := '0';
        END IF;
        vbUserUnitId := vbUnitKey::Integer;

        SELECT MLO_Unit.ObjectId
        INTO vbUnitId
        FROM  Movement
              INNER JOIN MovementLinkObject AS MLO_Unit
                                            ON MLO_Unit.MovementId = Movement.Id
                                           AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
        WHERE Movement.Id = inMovementId;

        IF COALESCE (vbUnitId, 0) <> COALESCE (vbUserUnitId, 0)
        THEN
           RAISE EXCEPTION 'Ошибка. Вам разрешено работать только с подразделением <%>.', (SELECT ValueData FROM Object WHERE ID = vbUserUnitId);     
        END IF;     
     END IF;     

    -- записываем чайлд
    PERFORM lpInsertUpdate_MI_Inventory_Child(inId                 := 0
                                            , inMovementId         := inMovementId
                                            , inParentId           := MovementItem.Id
                                            , inAmountUser         := 0::TFloat
                                            , inUserId             := vbUserId
                                              )
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId = zc_MI_Master()
       AND MovementItem.Amount <> 0
       AND MovementItem.isErased = FALSE;

    -- Обнулили все позиции
    PERFORM lpInsertUpdate_MovementItem_Inventory (ioId                 := MovementItem.Id
                                                 , inMovementId         := MovementItem.MovementId
                                                 , inGoodsId            := MovementItem.ObjectId
                                                 , inAmount             := 0::TFloat
                                                 , inPrice              := COALESCE(MovementItemFloat_Price.ValueData,0)
                                                 , inSumm               := 0::TFloat
                                                 , inComment            := NULL::TVarChar
                                                 , inUserId             := vbUserId)
    FROM MovementItem
        LEFT OUTER JOIN MovementItemFloat AS MovementItemFloat_Price
                                          ON MovementItemFloat_Price.MovementItemId = MovementItem.Id
                                         AND MovementItemFloat_Price.DescId = zc_MIFloat_Price() 
    WHERE
        MovementItem.MovementId = inMovementId
        AND
        MovementItem.DescId = zc_MI_Master()
        AND
        MovementItem.Amount <> 0;

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSummInventory (inMovementId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_Inventory_Set_Zero (Integer, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.   Шаблий О.В.
  17.12.18                                                                                  *
  05.01.17        *
  03.08.15                                                                    *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Inventory_Set_Zero inMovementId:= 0, inSession:= '2')
