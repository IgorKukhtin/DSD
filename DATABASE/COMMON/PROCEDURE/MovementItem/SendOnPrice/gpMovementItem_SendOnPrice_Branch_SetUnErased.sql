-- Function: gpMovementItem_SendOnPrice_Branch_SetUnErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_SendOnPrice_Branch_SetUnErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_SendOnPrice_Branch_SetUnErased(
    IN inMovementItemId      Integer              , -- ключ объекта <Элемент документа>
   OUT outIsErased           Boolean              , -- новое значение
    IN inSession             TVarChar               -- текущий пользователь
)
  RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsProcess_BranchIn Boolean;
   DECLARE vbMovementId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetUnErased_MI_SendOnPrice());


  -- параметр
  vbMovementId:= (SELECT MovementId FROM MovementItem WHERE Id = inMovementItemId);

  -- Важный параметр - Приход на филиала или расход с филиала (в первом случае вводится только "Кол-во (приход)")
  vbIsProcess_BranchIn:= EXISTS (SELECT Id FROM Object_Unit_View WHERE Id = (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = vbMovementId AND DescId = zc_MovementLinkObject_To()) AND BranchId = (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId));

  -- Проверка, т.к. в этом случае удалять нельзя
  IF (vbIsProcess_BranchIn = TRUE  AND EXISTS (SELECT 1 FROM MovementItem WHERE Id = inMovementItemId AND Amount <> 0))
  OR (vbIsProcess_BranchIn = FALSE AND EXISTS (SELECT 1 FROM MovementItemFloat WHERE MovementItemId = inMovementItemId AND DescId = zc_MIFloat_AmountPartner() AND ValueData <> 0))
  THEN
      RAISE EXCEPTION 'Ошибка.Нет прав восстанавливать <Элемент>.';
  END IF;

  -- устанавливаем новое значение
  outIsErased:= lpSetUnErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.A.
 05.05.14                                                       *
*/

-- тест
-- SELECT * FROM gpMovementItem_SendOnPrice_Branch_SetUnErased (inMovementId:= 55, inJuridicalId = 1, inSession:= '2')
