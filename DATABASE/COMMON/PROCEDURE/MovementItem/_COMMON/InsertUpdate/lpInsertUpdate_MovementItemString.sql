-- Function: lpInsertUpdate_MovementItemString

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItemString (Integer, Integer, TFloat);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemString(
    IN inDescId                Integer           , -- ключ класса свойства
    IN inMovementItemId        Integer           , -- ключ 
    IN inObjectId              Integer             -- ключ объекта
)
RETURNS Boolean
AS
$BODY$
BEGIN

     -- изменить <свойство>
     UPDATE MovementItemString SET ValueData = inValueData WHERE MovementItemId = inMovementItemId AND DescId = inDescId;

     -- если не нашли
     IF NOT FOUND AND inValueData <> ''
     THEN
         -- добавить <свойство>
         INSERT INTO MovementItemString (DescId, MovementItemId, ValueData)
                                 VALUES (inDescId, inMovementItemId, inValueData);
     END IF;

     RETURN TRUE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.03.15                                        * IF ... AND inValueData <> 0
 17.05.14                                        * add проверка - inValueData
*/
