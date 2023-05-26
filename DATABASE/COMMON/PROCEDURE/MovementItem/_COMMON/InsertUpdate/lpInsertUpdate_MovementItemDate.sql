-- Function: lpInsertUpdate_MovementItemDate

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItemDate (Integer, Integer, TDateTime);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemDate(
    IN inDescId                Integer           , -- ключ класса свойства
    IN inMovementItemId        Integer           , -- ключ 
    IN inValueData             TDateTime           -- свойство
))
RETURNS Boolean
AS
$BODY$
BEGIN

     -- изменить <свойство>
     UPDATE MovementItemDate SET ValueData = inValueData WHERE MovementItemId = inMovementItemId AND DescId = inDescId;

     -- если не нашли
     IF NOT FOUND
     THEN
         -- добавить <свойство>
        INSERT INTO MovementItemDate (DescId, MovementItemId, ValueData)
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
