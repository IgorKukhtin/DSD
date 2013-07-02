-- Function: lpInsertFind_Object_PartionMovement()

-- DROP FUNCTION lpInsertFind_Object_PartionMovement();

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionMovement(
 INOUT ioId                  Integer   , -- ключ объекта <Партии накладных>
    IN inCode                Integer   , -- Код объекта 
    IN inName                TVarChar  , -- Полное значение партии
    IN inMovementId          Integer     -- ссылка на документ Приход от постащика
)
  RETURNS Integer AS
$BODY$
BEGIN
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_PartionMovement(), 0, inName);

   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_PartionMovement_MovementId(), ioId, inMovementId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertFind_Object_PartionMovement (Integer, Integer, TVarChar, Integer) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.07.13          *
*/

-- тест
-- SELECT * FROM lpInsertFind_Object_PartionMovement (ioId:= -4, inCode:=6 , inName:= 'Test_PartionMovement', inMovementId:= 4)