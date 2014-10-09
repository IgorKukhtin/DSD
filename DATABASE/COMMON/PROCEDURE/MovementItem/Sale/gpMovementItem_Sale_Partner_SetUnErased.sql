-- Function: gpMovementItem_Sale_Partner_SetUnErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_Sale_Partner_SetUnErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_Sale_Partner_SetUnErased(
    IN inMovementItemId      Integer              , -- ключ объекта <Элемент документа>
   OUT outIsErased           Boolean              , -- новое значение
    IN inSession             TVarChar               -- текущий пользователь
)
  RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetUnErased_MI_Sale_Partner());


  -- Проверка, т.к. в этом случае восстанавливать нельзя
  IF EXISTS (SELECT Id FROM MovementItem WHERE Id = inMovementItemId AND Amount <> 0)
  THEN
      RAISE EXCEPTION 'Ошибка.Нет прав восстановить <Элемент>.';
  END IF;

  -- устанавливаем новое значение
  outIsErased:= lpSetUnErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpMovementItem_Sale_Partner_SetUnErased (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 09.10.14                                        * add lpSetUnErased_MovementItem
 05.05.14                                        *
*/

-- тест
-- SELECT * FROM gpMovementItem_Sale_Partner_SetUnErased (inMovementId:= 55, inJuridicalId = 1, inSession:= '2')
