-- Function: lpInsertUpdate_MovementString

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementString (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementString(
    IN inDescId                Integer           , -- ключ класса свойства
    IN inMovementId            Integer           , -- ключ 
    IN inValueData             TVarChar            -- Значение
)
RETURNS Boolean
AS
$BODY$
BEGIN

     -- изменить <свойство>
     UPDATE MovementString SET ValueData = inValueData WHERE MovementId = inMovementId AND DescId = inDescId;
 
     -- если не нашли + попробуем ПУСТО НЕ вставлять
     IF NOT FOUND AND inValueData <> ''
     THEN
        -- вставить <свойство>
        INSERT INTO MovementString (DescId, MovementId, ValueData)
                            VALUES (inDescId, inMovementId, inValueData);
     END IF;

     RETURN (TRUE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementString (Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.05.17                                        * IF ... AND inValueData <> ''
*/
