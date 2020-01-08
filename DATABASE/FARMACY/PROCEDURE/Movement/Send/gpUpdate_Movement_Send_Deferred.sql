-- Function: gpUpdate_Movement_Send_Deferred()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Send_Deferred(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Send_Deferred(
    IN inMovementId          Integer   ,    -- ключ документа
    IN inisDeferred          Boolean   ,    -- Отложен
   OUT outisDeferred         Boolean   ,
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbisDeferred Boolean;
   DECLARE vbisSUN Boolean;
   DECLARE vbisDefSUN Boolean;
   DECLARE vbSumma TFloat;
   DECLARE vbLimitSUN TFloat;
BEGIN

   IF COALESCE(inMovementId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

    -- параметры документа
    SELECT
        Movement.StatusId,
        COALESCE (MovementBoolean_Deferred.ValueData, FALSE),
        COALESCE (MovementBoolean_SUN.ValueData, FALSE),
        COALESCE (MovementBoolean_DefSUN.ValueData, FALSE),
        COALESCE (MovementFloat_TotalSummFrom.ValueData, 0),
        COALESCE (ObjectFloat_LimitSUN.ValueData, 0)
    INTO
        vbStatusId,
        vbisDeferred,
        vbisSUN,
        vbisDefSUN,
        vbSumma,
        vbLimitSUN
    FROM Movement
        LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                  ON MovementBoolean_Deferred.MovementId = Movement.Id
                                 AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
        LEFT JOIN MovementBoolean AS MovementBoolean_SUN
                                  ON MovementBoolean_SUN.MovementId = Movement.Id
                                 AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
        LEFT JOIN MovementBoolean AS MovementBoolean_DefSUN
                                  ON MovementBoolean_DefSUN.MovementId = Movement.Id
                                 AND MovementBoolean_DefSUN.DescId = zc_MovementBoolean_DefSUN()
        LEFT JOIN MovementFloat AS MovementFloat_TotalSummFrom
                                ON MovementFloat_TotalSummFrom.MovementId =  Movement.Id
                               AND MovementFloat_TotalSummFrom.DescId = zc_MovementFloat_TotalSummFrom()
        LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                     ON MovementLinkObject_From.MovementId = Movement.ID
                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

        LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                             ON ObjectLink_Unit_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                            AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
        
        LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                             ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

        LEFT JOIN ObjectFloat AS ObjectFloat_LimitSUN
                              ON ObjectFloat_LimitSUN.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                             AND ObjectFloat_LimitSUN.DescId = zc_ObjectFloat_Retail_LimitSUN()
    WHERE Movement.Id = inMovementId;
   
    IF vbisDefSUN = TRUE AND inisDeferred = TRUE
    THEN
      RAISE EXCEPTION 'Ошибка. Коллеги, отложенные перемещение по СУН проводить нельзя.';
    END IF;
    
    IF vbisSUN = TRUE AND COALESCE(vbLimitSUN, 0) > 0 AND vbSumma < COALESCE(vbLimitSUN, 0) AND inisDeferred = TRUE 
       AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
    THEN
      RAISE EXCEPTION 'Ошибка. Коллеги, перемещения по СУН с суммой менее % грн. отлаживать нельзя.', COALESCE(vbLimitSUN, 0);
    END IF;

   -- свойство не меняем у проведенных документов
   IF COALESCE (vbStatusId, 0) = zc_Enum_Status_UnComplete()
   THEN
       -- определили признак
       outisDeferred:=  inisDeferred;
       -- сохранили признак
       PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Deferred(), inMovementId, outisDeferred);
    
       IF inisDeferred = TRUE
       THEN
       
           IF vbisDeferred = TRUE
           THEN
             RAISE EXCEPTION 'Ошибка.Документ уже отложен!';
           END IF;

           -- собст	венно проводки
           PERFORM lpComplete_Movement_Send(inMovementId  -- ключ Документа
                                          , vbUserId);    -- Пользователь  
       ELSE
           -- убираем проводки
           PERFORM lpUnComplete_Movement (inMovementId
                                        , vbUserId);
       END IF;
   ELSE
       RAISE EXCEPTION 'Ошибка. Отлаживать документ в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);   
   END IF;
   
   outisDeferred := COALESCE (outisDeferred, COALESCE (vbisDeferred, FALSE));
   
   -- возвращаем статус документа
   -- UPDATE Movement SET StatusId = vbStatusId WHERE Id = inMovementId;
   
   -- сохранили протокол
   PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 08.11.17         *
*/
