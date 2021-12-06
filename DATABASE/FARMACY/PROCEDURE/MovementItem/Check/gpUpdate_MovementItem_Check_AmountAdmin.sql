 -- Function: gpUpdate_MovementItem_Check_AmountAdmin()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Check_AmountAdmin (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Check_AmountAdmin(
    IN inId                  Integer   , -- Ключ объекта <строка документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inAmount              TFloat    , -- Количество
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbSPKindId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
    vbUserId := lpGetUserBySession (inSession);

    SELECT 
      StatusId,
      COALESCE(MovementLinkObject_SPKind.ObjectId, 0) 
    INTO
      vbStatusId,
      vbSPKindId
    FROM Movement 
         LEFT JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                      ON MovementLinkObject_SPKind.MovementId = Movement.Id
                                     AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
    WHERE Id = inMovementId;

    IF vbUserId NOT IN (3, 375661, 4183126, 8001630, 9560329) AND 
      (vbSPKindId <> zc_Enum_SPKind_1303() OR NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = 11041603))
    THEN
      RAISE EXCEPTION 'Изменение <Количества> вам запрещено.';
    END IF;
            
    IF COALESCE(inMovementId,0) = 0
    THEN
        RAISE EXCEPTION 'Документ не записан.';
    END IF;

    IF vbStatusId <> zc_Enum_Status_UnComplete() 
    THEN
        RAISE EXCEPTION 'Ошибка.Изменение подразделения в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
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

    IF inAmount < 0
    THEN
        RAISE EXCEPTION 'Количество должно быть положительным или равно нолю.';
    END IF;      

    -- сохранили <Элемент документа>
    UPDATE MovementItem SET Amount = inAmount 
    WHERE DescId = zc_MI_Master() AND ID = inId;

    -- пересчитали Итоговые суммы
    PERFORM lpInsertUpdate_MovementFloat_TotalSummCheck (inMovementId);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpUpdate_MovementItem_Check_AmountAdmin (Integer, Integer, TFloat, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 10.10.19                                                       *
*/