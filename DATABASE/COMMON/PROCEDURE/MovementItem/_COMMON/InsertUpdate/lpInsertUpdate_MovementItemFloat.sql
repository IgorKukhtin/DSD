-- Function: lpInsertUpdate_MovementItem

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItemFloat (Integer, Integer, TFloat);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemFloat(
    IN inDescId          Integer ,
    IN inMovementItemId  Integer ,
    IN inValueData       TFloat  
)
  RETURNS BOOLEAN AS
$BODY$
BEGIN
     -- проверка - inValueData
     IF inValueData IS NULL
     THEN
         RAISE EXCEPTION 'Ошибка-1.Не определено числовое значение Id=<%> ParentId=<%> MovementId=<%> InvNumber=<%>.', inMovementItemId, (SELECT ParentId FROM MovementItem WHERE Id = inMovementItemId), (SELECT MovementId FROM MovementItem WHERE Id = inMovementItemId), (SELECT InvNumber FROM Movement WHERE Id = (SELECT MovementId FROM MovementItem WHERE Id = inMovementItemId);
     END IF;

     --
     UPDATE MovementItemFloat SET ValueData = inValueData WHERE MovementItemId = inMovementItemId AND DescId = inDescId;

     --
     IF NOT FOUND
     THEN
         -- вставить <ключ свойства> , <ключ строки> и <значение>
         INSERT INTO MovementItemFloat (DescId, MovementItemId, ValueData)
                                VALUES (inDescId, inMovementItemId, inValueData);
     END IF;

     RETURN (TRUE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementItemFloat(Integer, Integer, TFloat) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.05.14                                        * add проверка - inValueData
*/
