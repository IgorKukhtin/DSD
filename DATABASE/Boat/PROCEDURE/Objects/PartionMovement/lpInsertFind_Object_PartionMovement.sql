-- Function: lpInsertFind_Object_PartionMovement (Integer)

DROP FUNCTION IF EXISTS lpInsertFind_Object_PartionMovement (Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionMovement(
    IN inMovementId   Integer -- документ
)
RETURNS Integer
AS
$BODY$
   DECLARE vbPartionId Integer;
BEGIN

   --
   IF COALESCE (inMovementId, 0) = 0
   THEN
       vbPartionId:= 0; -- !!!будет без партий, и элемент с пустой партией не создается!!!

   ELSE
       -- Находим
       vbPartionId:= (SELECT Id FROM Object WHERE ObjectCode = inMovementId AND DescId = zc_Object_PartionMovement());

       IF COALESCE (vbPartionId, 0) = 0
       THEN
           -- сохранили <Объект>
           vbPartionId:= lpInsertUpdate_Object (vbPartionId, zc_Object_PartionMovement(), inMovementId, '');

       END IF;

   END IF;

   -- Возвращаем значение
   RETURN (COALESCE (vbPartionId, 0));

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.08.23                                        *
*/

-- тест
-- SELECT * FROM lpInsertFind_Object_PartionMovement (inMovementId:= 802)
