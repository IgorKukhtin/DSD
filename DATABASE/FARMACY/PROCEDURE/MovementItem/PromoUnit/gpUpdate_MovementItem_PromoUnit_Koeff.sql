-- Function: gpUpdate_MovementItem_PromoUnit_Koeff()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_PromoUnit_Koeff (Integer, TFloat, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_PromoUnit_Koeff(
    IN inId                Integer   , -- Ключ объекта <Документ ЧЕК>
    IN inKoeff             TFloat    , -- Подразделени
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpGetUserBySession (inSession);

    IF COALESCE(inId,0) = 0
    THEN
        RAISE EXCEPTION 'Документ не записан.';
    END IF;
    
    IF COALESCE (inKoeff, 0) < 0
    THEN
        RAISE EXCEPTION 'Ошибка.Коэффициента должен быть больше или равен 0.';
    END IF;

    SELECT 
      Movement.StatusId
    INTO
      vbStatusId
    FROM MovementItem
         INNER JOIN Movement ON Movement.ID = MovementItem.MovementId
    WHERE MovementItem.Id = inId;
            

    IF vbStatusId <> zc_Enum_Status_UnComplete() 
    THEN
        RAISE EXCEPTION 'Ошибка.Изменение Коэффициента в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    -- сохранили связь с <Подразделением>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Koeff(), inId, inKoeff);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.01.22                                                       *
*/
-- тест
-- select * from gpUpdate_MovementItem_PromoUnit_Koeff(inId := 7784533 , inUnitId := 183294 ,  inSession := '3');