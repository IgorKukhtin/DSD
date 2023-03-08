-- Function: gpUpdate_MI_PromoBonus_Amount()

DROP FUNCTION IF EXISTS gpUpdate_MI_PromoBonus_Amount (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_PromoBonus_Amount(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inAmount              TFloat    , -- Маркетинговый бонус
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbStatusId   Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
    vbUserId := inSession;
    
    -- определяем <Статус>
    vbStatusId := (SELECT StatusId FROM Movement WHERE Id = (SELECT MovementItem.MovementId FROM MovementItem WHERE  MovementItem.ID = inId));

    -- проверка - проведенные/удаленные документы Изменять нельзя
    IF COALESCE(vbStatusId, 0) <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION 'Ошибка.Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;
    
    IF COALESCE(inId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. Строка не определена.';         
    END IF;


     -- сохранили
    IF COALESCE (inAmount, 0) <> (SELECT MovementItem.Amount
                                  FROM MovementItem WHERE  MovementItem.ID = inId)
    THEN
      UPDATE MovementItem SET Amount = COALESCE (inAmount, 0)
      WHERE MovementItem.ID = inId;
      
      -- Сохранили <Дату изменения>
      PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), inId, CURRENT_TIMESTAMP);

      -- сохранили протокол
      PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);
      
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpUpdate_MI_PromoBonus_Amount (Integer, TFloat, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 08.03.23                                                                      *
*/

-- тест
-- select * from gpUpdate_MI_PromoBonus_Amount(inId := 410460411 , inAmount := 10 ,  inSession := '3');