-- Function: gpInsertUpdate_MovementItem_Wages_IlliquidAssets()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Wages_IlliquidAssets(INTEGER, INTEGER, INTEGER, INTEGER, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Wages_IlliquidAssets(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inUserId              Integer   , -- Сотрудник
    IN inUnitId              Integer   , -- подразделение
    IN inIlliquidAssets      TFloat    , -- Маркетинг
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

    IF COALESCE (inMovementId, 0) = 0
    THEN
      RAISE EXCEPTION 'Ошибка. Документ не сохранен.';
    END IF;
    
    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    IF vbIsInsert = TRUE
    THEN

      -- сохранили <Элемент документа>
      ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inUserId, inMovementId, 0, NULL);

      -- сохранили свойство <Подразделение>
      PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);   
      
    ELSE
    
      IF EXISTS(SELECT 1
                FROM MovementItemBoolean AS MIB_isIssuedBy
                WHERE MIB_isIssuedBy.MovementItemId = ioId
                  AND MIB_isIssuedBy.DescId = zc_MIBoolean_isIssuedBy()
                  AND MIB_isIssuedBy.ValueData = True)
      THEN
        RAISE EXCEPTION 'Ошибка. Зарплата выдана. Изменение сумм запрещено.';            
      END IF;
      
    END IF; 

     -- сохранили свойство <Маркетинг>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaIlliquidAssets(), ioId, inIlliquidAssets);

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

    --RAISE EXCEPTION 'Ошибка. Прошло % %', (select valuedata from Object where id = inUserId), inIlliquidAssets;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.04.21                                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Wages_IlliquidAssets (, inSession:= '3')