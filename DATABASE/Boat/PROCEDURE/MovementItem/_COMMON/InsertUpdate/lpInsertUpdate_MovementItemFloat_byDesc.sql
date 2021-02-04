-- Function: lpInsertUpdate_MovementItemFloat_byDesc

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItemFloat_byDesc (Integer, Integer, TFloat);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemFloat_byDesc(
    IN inDescId                Integer           , -- ключ класса свойства
    IN inMovementItemId        Integer           , -- ключ 
    IN inValueData             TFloat              -- свойство
)
RETURNS Boolean
AS
$BODY$
BEGIN
     -- только для Установленного inDescId
     IF inDescId > 0
     THEN
         RETURN lpInsertUpdate_MovementItemFloat (inDescId        := inDescId
                                                , inMovementItemId:= inMovementItemId
                                                , inValueData     := inValueData
                                                 );
     ELSE
         RETURN FALSE;
     END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementItemFloat_byDesc (Integer, Integer, TFloat) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.10.17                                        *
*/
