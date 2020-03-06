-- Function: gpInsert_Movement_TechnicalRediscount_RedCheck()

DROP FUNCTION IF EXISTS gpInsert_Movement_TechnicalRediscount_RedCheck (Integer, TVarChar);

CREATE OR REPLACE FUNCTION public.gpInsert_Movement_TechnicalRediscount_RedCheck (
   IN inUnitId integer,
  OUT outMovementId integer,
    IN inSession public.tvarchar
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TechnicalRediscount());
     
     IF EXISTS(SELECT Movement.Id
               FROM Movement 
                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                    LEFT JOIN MovementBoolean AS MovementBoolean_RedCheck
                                              ON MovementBoolean_RedCheck.MovementId = Movement.Id
                                             AND MovementBoolean_RedCheck.DescId = zc_MovementBoolean_RedCheck()
               WHERE Movement.DescId = zc_Movement_TechnicalRediscount()   
                 AND Movement.OperDate = CURRENT_DATE
                 AND Movement.StatusId = zc_Enum_Status_UnComplete()
                 AND MovementLinkObject_Unit.ObjectId = inUnitId
                 AND COALESCE (MovementBoolean_RedCheck.ValueData, False) = True)
     THEN
        RAISE EXCEPTION 'Ошибка. Уже создан документ технического переучета по подразделению с признаком "Красный чек".';
     END IF;
     
     -- сохранили <Документ>
     outMovementId := lpInsertUpdate_Movement_TechnicalRediscount (ioId               := 0
                                                                 , inInvNumber        := CAST (NEXTVAL ('Movement_TechnicalRediscount_seq') AS TVarChar)
                                                                 , inOperDate         := CURRENT_DATE
                                                                 , inUnitId           := inUnitId
                                                                 , inComment          := ''
                                                                 , inisRedCheck       := True
                                                                 , inUserId           := vbUserId
                                                                  );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
ALTER FUNCTION gpInsert_Movement_TechnicalRediscount_RedCheck (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 15.02.20                                                       *
*/