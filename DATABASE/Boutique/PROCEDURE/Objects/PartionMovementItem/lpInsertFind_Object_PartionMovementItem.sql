-- Function: lpInsertFind_Object_PartionMovement (Integer)

DROP FUNCTION IF EXISTS lpInsertFind_Object_PartionMovementItem (Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionMovementItem(
    IN inMovementItemId  Integer -- ссылка на элемент документа
)
RETURNS Integer
AS
$BODY$
   DECLARE vbPartionMovementItemId Integer;
BEGIN
   
   -- 
   IF COALESCE (inMovementItemId, 0) = 0
      THEN vbPartionMovementItemId:= 0; -- !!!будет без партий, и элемент с пустой партией не создается!!!
   ELSE
       -- Находим 
       vbPartionMovementItemId:= (SELECT Id FROM Object WHERE ObjectCode = inMovementItemId AND DescId = zc_Object_PartionMovementItem());

       IF COALESCE (vbPartionMovementItemId, 0) = 0
       THEN
           -- сохранили <Объект>
           vbPartionMovementItemId := lpInsertUpdate_Object (vbPartionMovementItemId, zc_Object_PartionMovementItem(), inMovementItemId, '');

       END IF;
   END IF;

   -- Возвращаем значение
   RETURN (vbPartionMovementItemId);

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpInsertFind_Object_PartionMovementItem (Integer) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.05.15                          *
 04.05.15                          *
*/

-- тест
-- SELECT * FROM lpInsertFind_Object_PartionMovementItem (inMovementItemId:= 123)