-- Function: gpUpdate_MovementItem_Attach_SendPartionDateChange()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Attach_SendPartionDateChange (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Attach_SendPartionDateChange(
    IN inGoodsId        Integer   , -- Товар
    IN inMISendId       TVarChar  , -- Перечень перемещений
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMISendId Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbIndex Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN

  vbUserId:= lpGetUserBySession (inSession);

  vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
  IF vbUnitKey = '' THEN
     vbUnitKey := '0';
  END IF;
  vbUnitId := vbUnitKey::Integer;

  SELECT MAX(MovementItem.Id)
  INTO vbMovementItemId
  FROM Movement

       INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                    AND MovementLinkObject_Unit.ObjectId = vbUnitId

       INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                              AND MovementItem.DescId = zc_MI_Master()
                              AND MovementItem.ObjectId = inGoodsId
                              AND MovementItem.Amount > 0
                              AND MovementItem.isErased = FALSE


   WHERE Movement.OperDate >= CURRENT_DATE - INTERVAL '5 DAY'
     AND Movement.DescId = zc_Movement_SendPartionDateChange();

  IF COALESCE (vbMovementItemId, 0) = 0
  THEN
    RAISE EXCEPTION 'Ошибка. По товару <%> не найдена заявка на изменение срока.', 
          (SELECT Object.ValueData FROM Object WHERE Object.Id = inGoodsId);
  END IF;


 -- парсим перемещения
  vbIndex := 1;
  WHILE SPLIT_PART (inMISendId, ';', vbIndex) <> '' LOOP
      -- добавляем то что нашли
      vbMISendId := SPLIT_PART (inMISendId, ';', vbIndex) :: Integer;
      -- сохранили свойство <Количество мест>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MISendPDChangeId(), vbMISendId, vbMovementItemId);
      -- теперь следуюющий
      vbIndex := vbIndex + 1;
  END LOOP;

  --RAISE EXCEPTION 'Прошло. %', vbMovementItemId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.09.20                                                       *
 02.09.20                                                       *
*/

-- тест
-- select * from gpUpdate_MovementItem_Attach_SendPartionDateChange(inGoodsId := 13242 , inMISendId := '371008924' ,  inSession := '3');