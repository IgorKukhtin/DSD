-- Function: gpInsertUpdate_Movement_SendPartionDate()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendPartionDate (Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendPartionDate (Integer, TVarChar, TDateTime, Integer, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_SendPartionDate(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inUnitId              Integer   , --
    IN inChangePercent       TFloat    , -- % скидки (срок от 1 мес до 6 мес)
    IN inChangePercentMin    TFloat    , -- % скидки (срок меньше месяца)
    IN inComment             TVarChar  , -- Примечание
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbUserUnitId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_SendPartionDate());
     vbUserId := inSession;
    
     IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
               WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = 308121) -- Для роли "Кассир аптеки"
     THEN
     
        vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
        IF vbUnitKey = '' THEN
          vbUnitKey := '0';
        END IF;
        vbUserUnitId := vbUnitKey::Integer;
        
        IF COALESCE (vbUserUnitId, 0) = 0
        THEN 
          RAISE EXCEPTION 'Ошибка. Не найдено подразделение сотрудника.';     
        END IF;     
        
        IF COALESCE (inUnitId, 0) <> COALESCE (vbUserUnitId, 0)
        THEN 
          RAISE EXCEPTION 'Ошибка. Вам разрешено работать только с подразделением <%>.', (SELECT ValueData FROM Object WHERE ID = vbUserUnitId);     
        END IF;     
     END IF;     

     vbUnitId := (SELECT MovementLinkObject_Unit.ObjectId
                  FROM MovementLinkObject AS MovementLinkObject_Unit
                  WHERE MovementLinkObject_Unit.MovementId = ioId
                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit());

     -- Eсли выбирают др. подразделение все строки метим на удаление
     IF vbUnitId <> 0 AND vbUnitId <> inUnitId
     THEN
         --
         UPDATE MovementItem
         SET isErased = TRUE
         WHERE MovementItem.MovementId = ioId;
     END IF;
     
     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_SendPartionDate (ioId               := ioId
                                                   , inInvNumber        := inInvNumber
                                                   , inOperDate         := inOperDate
                                                   , inUnitId           := inUnitId
                                                   , inChangePercent    := inChangePercent
                                                   , inChangePercentMin := inChangePercentMin
                                                   , inComment          := inComment
                                                   , inUserId           := vbUserId
                                                    );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.05.19         *
 02.04.19         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_SendPartionDate (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
