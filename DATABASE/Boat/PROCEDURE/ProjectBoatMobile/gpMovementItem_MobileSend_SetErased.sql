-- Function: gpMovementItem_MobileSend_SetErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_MobileSend_SetErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_MobileSend_SetErased(
    IN inMovementItemId      Integer              , -- ключ объекта <Элемент документа>
   OUT outIsErased           Boolean              , -- новое значение
    IN inSession             TVarChar               -- текущий пользователь
)
  RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbGoodsId    Integer;
   DECLARE vbPartNumber TVarChar;
BEGIN
  --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_MI_OrderClient());
  vbUserId:= inSession;

  -- Получаем данные строки
  SELECT MI.ObjectId
       , COALESCE (MIString_PartNumber.ValueData,'')
       , MI.MovementId
  INTO vbGoodsId, vbPartNumber, vbMovementId
  FROM MovementItem AS MI
       LEFT JOIN MovementItemString AS MIString_PartNumber
                                    ON MIString_PartNumber.MovementItemId = MI.Id
                                   AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
  WHERE MI.Id = inMovementItemId;

  -- Ищем может уже есть такой товар ругаемся
  IF EXISTS(SELECT MI.Id 
            FROM MovementItem AS MI
                 LEFT JOIN MovementItemString AS MIString_PartNumber
                                              ON MIString_PartNumber.MovementItemId = MI.Id
                                             AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
            WHERE MI.MovementId = vbMovementId
              AND MI.DescId     = zc_MI_Master()
              AND MI.ObjectId   = vbGoodsId
              AND MI.isErased   = FALSE
              AND COALESCE (MIString_PartNumber.ValueData,'') = COALESCE (vbPartNumber,''))
  THEN
    RAISE EXCEPTION 'Ошибка. Комплектующее <%> с S/N <%> уже сохранено в переещении. Удалить строку нельзя.', lfGet_Object_ValueData (inGoodsId), inPartNumber;
  END IF;

  -- устанавливаем новое значение
  outIsErased:= lpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 15.04.24                                                       *
*/

-- тест
--