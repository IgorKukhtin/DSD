-- Function: gpUpdate_MI_Send_AmountManual()

DROP FUNCTION IF EXISTS gpUpdate_MI_Send_AmountManual (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Send_AmountManual(
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
     
     IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId IN (zc_Enum_Role_Admin(), zc_Enum_Role_PharmacyManager(), zc_Enum_Role_SeniorManager()))
     THEN
        RAISE EXCEPTION 'Ошибка. Изменение <Факт кол-во точки-получатедя> разрешено только администратору и менеджерам.';
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
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountManual(), MovementItem.id, COALESCE(MIFloat_AmountStorage.ValueData,0))
     FROM MovementItem 

          LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                                      ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                     AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
          LEFT JOIN MovementItemFloat AS MIFloat_AmountStorage
                                      ON MIFloat_AmountStorage.MovementItemId = MovementItem.Id
                                     AND MIFloat_AmountStorage.DescId = zc_MIFloat_AmountStorage()

     WHERE MovementItem.MovementId = inMovementId
       AND COALESCE(MIFloat_AmountStorage.ValueData,0) <> COALESCE(MIFloat_AmountManual.ValueData,0)
       AND MovementItem.DescId = zc_MI_Master()
       AND MovementItem.isErased = False;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
  08.03.22                                                      *
*/

-- тест
-- SELECT * FROM gpUpdate_MI_Send_AmountManual (inMovementId:= 0, inUserId:= 2)