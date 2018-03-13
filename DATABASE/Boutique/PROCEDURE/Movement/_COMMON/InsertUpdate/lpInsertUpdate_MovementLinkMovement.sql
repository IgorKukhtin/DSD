-- Function: lpInsertUpdate_MovementLinkMovement()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementLinkMovement (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementLinkMovement(
    IN inDescId                Integer           ,  -- код класса свойства
    IN inMovementId            Integer           ,  -- ключ главного документа
    IN inMovementChildId       Integer              -- ключ подчиненного документа
)
  RETURNS Boolean AS
$BODY$
BEGIN
    -- заменили
    IF inMovementChildId = 0 THEN
       inMovementChildId := NULL;
    END IF;

    -- проверка - если сам с собой
    IF inMovementId = inMovementChildId
    THEN
        RAISE EXCEPTION 'Ошибка.Документ № <%> от <%> не может быть связан сам с собой.', (SELECT InvNumber FROM Movement WHERE Id = inMovementId), DATE ((SELECT OperDate FROM Movement WHERE Id = inMovementId));
    END IF;

    -- изменить данные по значению <ключ объекта>
    UPDATE MovementLinkMovement SET MovementChildId = inMovementChildId WHERE MovementId = inMovementId AND DescId = inDescId;

    -- если не нашли
    IF NOT FOUND THEN
       -- вставить <свойство>
       INSERT INTO MovementLinkMovement (DescId, MovementId, MovementChildId)
                                 VALUES (inDescId, inMovementId, inMovementChildId);
    END IF;             

    RETURN TRUE;
    
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementLinkMovement (Integer, Integer, Integer) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 16.03.14                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementLinkMovement (inDescId:= NULL, inMovementId:= 1, inMovementChildId:= 2)
