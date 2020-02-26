-- Function: gpSetErased_Movement_TechnicalRediscount (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_TechnicalRediscount (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_TechnicalRediscount(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbStatusID Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_TechnicalRediscount());
   
    -- параметры документа
    SELECT Movement.StatusId
    INTO vbStatusID
    FROM Movement
    WHERE Movement.Id = inMovementId;  
    
    IF vbStatusId = zc_Enum_Status_Complete()
    THEN
      RAISE EXCEPTION 'Ошибка. Удаление документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;
      
    -- Удаляем Документ
    PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.12.19                                                       *
*/
