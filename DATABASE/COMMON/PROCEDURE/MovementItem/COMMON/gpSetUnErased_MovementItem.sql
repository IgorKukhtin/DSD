-- Function: gpSetUnErased_MovementItem (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetUnErased_MovementItem (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetUnErased_MovementItem(
    IN inMovementItemId      Integer              , -- ключ объекта <Элемент документа>
   OUT outIsErased           Boolean              , -- новое значение
    IN inSession             TVarChar               -- текущий пользователь
)                              
  RETURNS Boolean
AS
$BODY$
BEGIN

  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_SetErased_MovementItem());

  -- устанавливаем новое значение
  outIsErased := FALSE;

  -- Обязательно меняем 
  UPDATE MovementItem SET isErased = outIsErased WHERE Id = inMovementItemId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSetUnErased_MovementItem (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.10.13                                        * add outIsErased
 01.10.13                                        *
*/

-- тест
-- SELECT * FROM gpSetUnErased_MovementItem (inMovementItemId:= 55, inSession:= '2')
