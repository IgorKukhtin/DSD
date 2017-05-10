-- Function: lpInsertUpdate_MovementItemString

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItemString (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemString(
    IN inDescId                Integer           , -- ключ класса свойства
    IN inMovementItemId        Integer           , -- ключ 
    IN inValueData             TVarChar            -- Значение
)
RETURNS Boolean
AS
$BODY$
BEGIN

     -- изменить <свойство>
    UPDATE MovementItemString SET ValueData = inValueData WHERE MovementItemId = inMovementItemId AND DescId = inDescId;

     -- если не нашли + попробуем ПУСТО НЕ вставлять
     IF NOT FOUND AND inValueData <> ''
     THEN
        -- вставить <свойство>
        INSERT INTO MovementItemString (DescId, MovementItemId, ValueData)
                                VALUES (inDescId, inMovementItemId, inValueData);
     END IF;

     RETURN (TRUE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementItemString (Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.05.17                                        * IF ... AND inValueData <> ''
*/
