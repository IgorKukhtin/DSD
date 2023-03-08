-- Function: gpUpdate_MI_PromoBonus_BonusInetOrder()

DROP FUNCTION IF EXISTS gpUpdate_MI_PromoBonus_BonusInetOrder (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_PromoBonus_BonusInetOrder(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inBonusInetOrder      TFloat    , -- Маркетинговый бонус
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
    IF COALESCE (inBonusInetOrder, 0) <> COALESCE((SELECT MovementItemFloat.ValueData
                                  FROM MovementItemFloat 
                                  WHERE MovementItemFloat.MovementItemID = inId
                                    AND MovementItemFloat.DescId = zc_MIFloat_BonusInetOrder()), 0)
    THEN
      -- Сохранили <Маркет бонусы для инет заказов, %>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_BonusInetOrder(), inId, inBonusInetOrder);
              
      -- Сохранили <Дату изменения>
      PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), inId, CURRENT_TIMESTAMP);

      -- сохранили протокол
      PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);
      
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpUpdate_MI_PromoBonus_BonusInetOrder (Integer, TFloat, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 08.03.23                                                                      *
*/

-- тест
-- 

select * from gpUpdate_MI_PromoBonus_BonusInetOrder(inId := 410460411 , inBonusInetOrder := 0 ,  inSession := '3');