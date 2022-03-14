-- Function: gpUpdate_MI_Send_ClearAmountManual()

DROP FUNCTION IF EXISTS gpUpdate_MI_Send_ClearAmountManual (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Send_ClearAmountManual(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar    -- пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount     Integer;
   DECLARE vbStatusId    Integer;
   DECLARE vbisDeferred  Boolean;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     vbUserId := inSession;
     
     IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
        RAISE EXCEPTION 'Ошибка. Изменение <Факт кол-во точки-получателя> разрешено только администратору.';
     END IF;

     SELECT Movement.StatusId
          , COALESCE (MovementBoolean_Deferred.ValueData, FALSE)   ::Boolean AS isDeferred
     INTO vbStatusId, vbisDeferred
     FROM Movement

          LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                    ON MovementBoolean_Deferred.MovementId = Movement.Id
                                   AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

     WHERE Movement.Id = inMovementId;     
     
     IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_UnComplete()
     THEN
        RAISE EXCEPTION 'Ошибка. Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
     END IF;


     IF vbisDeferred = TRUE
     THEN
        RAISE EXCEPTION 'Ошибка. Изменение отложеного документа не возможно.';
     END IF;
             
     -- сохранили
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountManual(), MovementItem.id, 0)
     FROM MovementItem 
          INNER JOIN MovementItemFloat AS MIFloat_AmountManual
                                       ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                      AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()   
                                      AND MIFloat_AmountManual.ValueData <> 0  
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId = zc_MI_Master();

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
  08.03.22                                                      *
*/

-- тест
-- SELECT * FROM gpUpdate_MI_Send_ClearAmountManual (inMovementId:= 0, inUserId:= 2)