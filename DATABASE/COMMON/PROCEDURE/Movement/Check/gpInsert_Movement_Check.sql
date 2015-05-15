-- Function: gpInsertUpdate_Movement_Check()

DROP FUNCTION IF EXISTS gpInsert_Movement_Check (TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Check(
   OUT Id                  Integer   , -- Ключ объекта <Документ ЧЕК>
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbInvNumber Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderInternal());
     vbUserId := inSession;

     vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
     IF vbUnitKey = '' THEN
        vbUnitKey := '0';
     END IF;   
     vbUnitId := vbUnitKey::Integer;

     IF COALESCE(vbUnitId, 0) = 0 THEN
        RAISE EXCEPTION 'Для пользователя не установлено значение параметра Подразделение';
     END IF;

     -- 0.
     SELECT COALESCE(MAX(zfConvert_StringToNumber(InvNumber)), 0) + 1 INTO vbInvNumber
       FROM Movement_Check_View 
      WHERE Movement_Check_View.UnitId = vbUnitId AND Movement_Check_View.OperDate > CURRENT_DATE;

     -- сохранили <Документ>
     Id := lpInsertUpdate_Movement (Id, zc_Movement_Check(), vbInvNumber::TVarChar, CURRENT_TIMESTAMP, NULL);

     -- сохранили связь с <Подразделением>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), Id, vbUnitId);

     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 08.05.15                         * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_OrderInternal (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
