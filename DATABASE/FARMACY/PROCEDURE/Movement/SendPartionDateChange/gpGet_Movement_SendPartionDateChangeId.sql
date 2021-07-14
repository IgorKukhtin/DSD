-- Function: gpGet_Movement_SendPartionDateChangeId()

DROP FUNCTION IF EXISTS gpGet_Movement_SendPartionDateChangeId (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_SendPartionDateChangeId(
    IN inUnitId            Integer  , -- Подразделение
   OUT outMovementId       Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);
   
   IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
             WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = 308121) -- Для роли "Кассир аптеки"
   THEN
   
     vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
     IF vbUnitKey = '' THEN
        vbUnitKey := '0';
     END IF;
     vbUnitId := vbUnitKey::Integer;
     outMovementId := 0;
     
     IF vbUnitId <> inUnitId
     THEN
        RAISE EXCEPTION 'Ошибка. Вам разрешено работать только с подразделением <%>.', (SELECT ValueData FROM Object WHERE ID = vbUnitId);     
     END IF;
   END IF;

   IF EXISTS(SELECT Movement.Id
             FROM Movement 
                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                               ON MovementLinkObject_Unit.MovementId = Movement.Id
                                              AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
             WHERE Movement.DescId = zc_Movement_SendPartionDateChange()   
               AND Movement.StatusId = zc_Enum_Status_UnComplete()
               AND MovementLinkObject_Unit.ObjectId = inUnitId)
   THEN
      SELECT Max(Movement.Id) AS Id
      INTO outMovementId
      FROM Movement 
           LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
      WHERE Movement.DescId = zc_Movement_SendPartionDateChange()   
        AND Movement.StatusId = zc_Enum_Status_UnComplete()
        AND MovementLinkObject_Unit.ObjectId = inUnitId;  
   ELSE
      outMovementId := gpInsertUpdate_Movement_SendPartionDateChange(ioId              := 0
                                                                   , inInvNumber       := CAST (NEXTVAL ('Movement_SendPartionDateChange_seq') AS TVarChar)
                                                                   , inOperDate        := CURRENT_DATE
                                                                   , inUnitId          := inUnitId
                                                                   , inComment         := ''
                                                                   , inSession         := inSession);
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_SendPartionDateChangeId (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 12.07.21                                                       *
 */

-- тест
-- SELECT * FROM gpGet_Movement_SendPartionDateChangeId (inUnitId := 183292, inSession:= '3')