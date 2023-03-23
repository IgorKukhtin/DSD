-- Function: gpSetErased_MovementItem (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_MovementItem (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_MovementItem(
    IN inMovementItemId      Integer              , -- ключ объекта <Элемент документа>
   OUT outIsErased           Boolean              , -- новое значение
    IN inSession             TVarChar               -- текущий пользователь
)                              
  RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbBoxNumber Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_???());
  vbUserId:= lpGetUserBySession (inSession);

  -- устанавливаем новое значение
  outIsErased:= lpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);
  
  IF EXISTS (SELECT 1 FROM MovementItem JOIN Movement ON Movement.Id = MovementItem.MovementId AND Movement.DescId = zc_Movement_WeighingPartner() WHERE MovementItem.Id= inMovementItemId)
  THEN
      --
      vbMovementId:= (SELECT MovementItem.MovementId FROM MovementItem WHERE MovementItem.Id= inMovementItemId);
      --
      vbBoxNumber:= (SELECT MIF.ValueData :: Integer FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = inMovementItemId AND MIF.DescId = zc_MIFloat_BoxNumber());
      --
       
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_BoxNumber(), tmp.MovementItemId, BoxNumber - 1)
      FROM (SELECT MovementItem.Id             AS MovementItemId
                 , MIFloat_BoxNumber.ValueData AS BoxNumber
            FROM MovementItem
                 INNER JOIN MovementItemFloat AS MIFloat_BoxNumber
                                              ON MIFloat_BoxNumber.MovementItemId = MovementItem.Id
                                             AND MIFloat_BoxNumber.DescId         = zc_MIFloat_BoxNumber()
                                             AND MIFloat_BoxNumber.ValueData      > vbBoxNumber
            WHERE MovementItem.MovementId = vbMovementId
              AND MovementItem.isErased   = FALSE
              AND MovementItem.DescId     = zc_MI_Master()
              AND vbBoxNumber             > 0
           ) AS tmp;

  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSetErased_MovementItem (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.10.14                                        *
*/

-- тест
-- SELECT * FROM gpSetErased_MovementItem (inMovementItemId:= 0, inSession:= '2')
