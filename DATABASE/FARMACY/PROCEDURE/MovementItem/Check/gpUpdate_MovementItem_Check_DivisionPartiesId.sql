 -- Function: gpUpdate_MovementItem_Check_DivisionPartiesId()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Check_DivisionPartiesId (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Check_DivisionPartiesId(
    IN inId                  Integer   , -- Ключ объекта <строка документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inDivisionPartiesId   Integer   , -- Типы разделений партий
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
    vbUserId := lpGetUserBySession (inSession);

    IF inSession::Integer NOT IN (3, 375661, 4183126, 8001630, 9560329, 8051421, 14080152 )
    THEN
      RAISE EXCEPTION 'Изменение <Типы разделений партий> вам запрещено.';
    END IF;

    SELECT
      StatusId
    INTO
      vbStatusId
    FROM Movement
    WHERE Id = inMovementId;

    IF COALESCE(inMovementId,0) = 0
    THEN
        RAISE EXCEPTION 'Документ не записан.';
    END IF;

    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION 'Ошибка.Изменение Типы разделений партий в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    -- Провкряем элемент по документу
    IF COALESCE (inId, 0) = 0
       OR NOT EXISTS (SELECT 1 FROM MovementItem WHERE Id = inId)
    THEN
        RAISE EXCEPTION 'Не найден элемент по документe';
    END IF;

    -- Находим элемент по документу и товару
    IF COALESCE (inMovementId, 0) = 0
       OR NOT EXISTS (SELECT 1 FROM MovementItem WHERE Id = inId)
    THEN
        RAISE EXCEPTION 'Не задан документ или неправельная связь';
    END IF;

    -- сохранили <Элемент документа>
    IF COALESCE (inDivisionPartiesId, 0) <> COALESCE ((SELECT ObjectId FROM MovementItemLinkObject WHERE MovementItemId = inId
                                                                                                     AND DescId = zc_MILinkObject_DivisionParties()), 0)
    THEN
      PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_DivisionParties(), inId, inDivisionPartiesId);
    ELSE
      PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_DivisionParties(), inId, 0);    
    END IF;

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpUpdate_MovementItem_Check_DivisionPartiesId (Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.04.20                                                       *
*/


--select * from gpUpdate_MovementItem_Check_DivisionPartiesId(inId := 397322599 , inMovementId := 21453664 , inDivisionPartiesId := 14839320 ,  inSession := '3');