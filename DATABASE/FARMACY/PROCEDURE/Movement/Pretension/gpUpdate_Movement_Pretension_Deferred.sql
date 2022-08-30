-- Function: gpUpdate_Movement_Pretension_Deferred()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Pretension_Deferred(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Pretension_Deferred(
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
BEGIN

   vbUserId := lpGetUserBySession (inSession);

   IF COALESCE(inMovementId, 0) = 0 THEN
      RETURN;
   END IF;

    -- параметры документа
    SELECT
        Movement.StatusId,
        COALESCE (MovementBoolean_Deferred.ValueData, FALSE)
    INTO
        vbStatusId,
        vbisDeferred
    FROM Movement
        LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                  ON MovementBoolean_Deferred.MovementId = Movement.Id
                                 AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
    WHERE Movement.Id = inMovementId;
   
   -- свойство меняем у не проведенных документов
   IF COALESCE (vbStatusId, 0) = zc_Enum_Status_UnComplete()
   THEN
       -- определили признак
       outisDeferred:=  inisDeferred;
       -- сохранили признак
       PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Deferred(), inMovementId, outisDeferred);
    
       IF inisDeferred = TRUE
       THEN
           IF EXISTS(SELECT 1
                     FROM MovementLinkMovement 
                          INNER JOIN Movement ON Movement.Id =  MovementLinkMovement.MovementId
                                             AND Movement.StatusId <> zc_Enum_Status_Erased() 
                     WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Pretension()
                       AND MovementLinkMovement.MovementChildId = inMovementId)
           THEN
             RAISE EXCEPTION 'Отложка запрещена. Создан возврат поставщику.';       
           END IF;
           
                      -- собственно проводки
           PERFORM lpComplete_Movement_Pretension(inMovementId  -- ключ Документа
                                               , vbUserId);    -- Пользователь  
       ELSE
           -- убираем проводки
           PERFORM lpUnComplete_Movement (inMovementId
                                        , vbUserId);
       END IF;
   ELSE 
       RAISE EXCEPTION 'Ошибка.Изменение признака отложен в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);   
   END IF;
   
   outisDeferred := COALESCE (outisDeferred, COALESCE (vbisDeferred, FALSE));
   
   -- сохранили протокол
   PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.12.21                                                       *
*/

-- select * from gpUpdate_Movement_Pretension_Deferred(inMovementId := 26087688 , inisDeferred := 'True' ,  inSession := '3');