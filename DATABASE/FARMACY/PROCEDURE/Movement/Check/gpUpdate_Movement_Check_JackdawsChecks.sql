-- Function: gpUpdate_Movement_Check_JackdawsChecks()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_JackdawsChecks (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_JackdawsChecks(
    IN inId                Integer   , -- Ключ объекта <Документ ЧЕК>
    IN inJackdawsChecksId  Integer   , -- 
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbPaidTypeId Integer;
   DECLARE vbJackdawsChecks Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpGetUserBySession (inSession);
--    vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Check_OperDate());

    IF 3 <> inSession::Integer AND 375661 <> inSession::Integer AND 4183126 <> inSession::Integer AND
      8001630 <> inSession::Integer AND 9560329 <> inSession::Integer
    THEN
      RAISE EXCEPTION 'Изменение <типа галки вам запрещено> вам запрещено.';
    END IF;

    SELECT
      StatusId,
      MovementLinkObject_PaidType.ObjectId,
      COALESCE(MovementLinkObject_JackdawsChecks.ObjectId, 0)
    INTO
      vbStatusId,
      vbPaidTypeId,
      vbJackdawsChecks
    FROM Movement

         LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidType
                                      ON MovementLinkObject_PaidType.MovementId = Movement.Id
                                     AND MovementLinkObject_PaidType.DescId = zc_MovementLinkObject_PaidType()
         LEFT JOIN MovementLinkObject AS MovementLinkObject_JackdawsChecks
                                      ON MovementLinkObject_JackdawsChecks.MovementId = Movement.Id
                                     AND MovementLinkObject_JackdawsChecks.DescId = zc_MovementLinkObject_JackdawsChecks()
    WHERE Id = inId;

    IF COALESCE(inId,0) = 0
    THEN
        RAISE EXCEPTION 'Документ не записан.';
    END IF;

    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION 'Ошибка.Изменение типа галки в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;
    
    IF vbJackdawsChecks = inJackdawsChecksId
    THEN
      inJackdawsChecksId := 0;
    END IF;
    

    -- сохранили связь с <Подразделением>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_JackdawsChecks(), inId, inJackdawsChecksId);

    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.  Шаблий О.В.
 17.11.18                                                                                    *
*/
-- тест
-- select * from gpUpdate_Movement_Check_JackdawsChecks(inId := 7784533 , inUnitId := 183294 ,  inSession := '3');
