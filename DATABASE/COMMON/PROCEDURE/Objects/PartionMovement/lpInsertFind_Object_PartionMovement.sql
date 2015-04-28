-- Function: lpInsertFind_Object_PartionMovement (Integer)

-- DROP FUNCTION lpInsertFind_Object_PartionMovement (Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionMovement(
    IN inMovementId  Integer -- ссылка на документ
)
RETURNS Integer
AS
$BODY$
   DECLARE vbPartionMovementId Integer;
BEGIN
   
   -- 
   IF COALESCE (inMovementId, 0) = 0
   THEN vbPartionMovementId:= 0; -- !!!будет без партий, и элемент с пустой партией не создается!!!
   ELSE
       -- Находим 
       vbPartionMovementId:= (SELECT ObjectId FROM ObjectFloat WHERE ValueData = inMovementId AND DescId = zc_ObjectFloat_PartionMovement_MovementId());

       IF COALESCE (vbPartionMovementId, 0) = 0
       THEN
           -- сохранили <Объект>
           vbPartionMovementId := lpInsertUpdate_Object (vbPartionMovementId, zc_Object_PartionMovement(), 0, inMovementId :: TVarChar);
           -- сохранили
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionMovement_MovementId(), vbPartionMovementId, inMovementId :: TFloat);

       END IF;
   END IF;

   -- Возвращаем значение
   RETURN (vbPartionMovementId);

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpInsertFind_Object_PartionMovement (Integer) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.05.15                                        * all
 13.02.14                                        * !!!будем без партий!!! но по другому
 27.09.13                                        * !!!будем без партий!!!
 02.07.13                                        * сначала Find, потом если надо Insert
 02.07.13          *
*/

-- тест
-- SELECT * FROM lpInsertFind_Object_PartionMovement (inMovementId:= 123)