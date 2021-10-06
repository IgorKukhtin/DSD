-- Function: gpMovementItem_Income_SetErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_Income_SetErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_Income_SetErased(
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
  vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_MI_Income());

  -- устанавливаем новое значение
  outIsErased := lpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);
  
  -- устанавливаем новое значение
  UPDATE Object_PartionGoods SET isErased = TRUE WHERE MovementItemId = inMovementItemId;

  -- устанавливаем новое значение
  UPDATE Object SET isErased = TRUE WHERE Object.Id = (SELECT Object_PartionGoods.GoodsId
                                                       FROM Object_PartionGoods
                                                            LEFT JOIN MovementItem ON MovementItem.ObjectId = Object_PartionGoods.GoodsId
                                                                                  AND MovementItem.isErased = FALSE
                                                       WHERE Object_PartionGoods.MovementItemId = inMovementItemId
                                                         AND MovementItem.Id IS NULL
                                                      )
                                       AND Object.DescId = zc_Object_Goods();
  -- select * FROM Object_PartionGoods where goodsId = 50745
  -- RAISE EXCEPTION 'Ошибка.<%>', (select iserased from Object where Id = 50745);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.A.
 10.04.17         *
*/

-- тест
-- SELECT * FROM gpMovementItem_Income_SetErased (inMovementId:= 55, inJuridicalId = 1, inSession:= '2')
