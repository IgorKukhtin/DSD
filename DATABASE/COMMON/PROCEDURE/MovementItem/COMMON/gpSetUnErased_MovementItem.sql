-- Function: gpSetUnErased_MovementItem (Integer, TVarChar)

-- DROP FUNCTION gpSetUnErased_MovementItem (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetUnErased_MovementItem(
    IN inMovementItemId      Integer              , -- ключ объекта <Элемент документа>
    IN inSession             TVarChar               -- текущий пользователь
)                              
  RETURNS void AS
$BODY$
BEGIN

  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_SetErased_MovementItem());

  -- Обязательно меняем 
  UPDATE MovementItem SET isErased = FALSE WHERE Id = inMovementItemId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSetUnErased_MovementItem (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.10.13                                        *
*/

-- тест
-- SELECT * FROM gpSetUnErased_MovementItem (inMovementItemId:= 55, inSession:= '2')
