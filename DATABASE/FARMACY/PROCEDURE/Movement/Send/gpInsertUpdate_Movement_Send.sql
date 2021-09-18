-- Function: gpInsertUpdate_Movement_Send()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Send (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Send (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Send (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Send (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Send (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Send (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, Boolean, Boolean, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Send (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, Boolean, Boolean, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Send(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inComment             TVarChar  , -- Примечание
    IN inChecked             Boolean   , -- Проверен
    IN inisComplete          Boolean   , -- Собрано фармацевтом
    IN inNumberSeats         Integer   , -- Количество мест
    IN inDriverSunId         Integer   , -- Водитель получивший товар
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbUserUnitId Integer;
   DECLARE vbParentId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Send());
     vbUserId := inSession;
    
/*     IF COALESCE (ioId, 0) <> 0 AND (COALESCE (inFromId, 0) = 0 OR COALESCE (inToId, 0) = 0)
     THEN 
       RAISE EXCEPTION 'Ошибка. Не заполнено подразделение..';             
     END IF;     
*/
     IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
               WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = 308121) -- Для роли "Кассир аптеки"
     THEN
     
        vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
        IF vbUnitKey = '' THEN
          vbUnitKey := '0';
        END IF;
        vbUserUnitId := vbUnitKey::Integer;
        vbParentId := 0;
        
        IF COALESCE (vbUserUnitId, 0) = 0
        THEN 
          RAISE EXCEPTION 'Ошибка. Не найдено подразделение сотрудника.';     
        END IF;     
        
        IF vbUserId in (12325076, 6406669, 3999086, 16175938, 4000094, 6002014, 6025400, 16411862)
        THEN
          SELECT ObjectLink_Unit_Parent.ChildObjectId
          INTO vbParentId
          FROM ObjectLink AS ObjectLink_Unit_Parent
          WHERE  ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
            AND ObjectLink_Unit_Parent.ObjectId = vbUserUnitId;
        END IF;

        IF COALESCE (ioId, 0) <> 0
        THEN
          IF EXISTS(SELECT 
                            1 
                    FROM Movement
                         INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                         INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                    WHERE Movement.Id = ioId 
                      AND COALESCE (MovementLinkObject_From.ObjectId, 0) <> COALESCE (vbUserUnitId, 0) 
                      AND COALESCE (MovementLinkObject_To.ObjectId, 0) <> COALESCE (vbUserUnitId, 0) 
                      AND COALESCE (MovementLinkObject_From.ObjectId, 0) <> COALESCE (vbParentId, 0) 
                      AND COALESCE (MovementLinkObject_To.ObjectId, 0) <> COALESCE (vbParentId, 0))
          THEN
            RAISE EXCEPTION 'Ошибка. Изменение подразделения запрещено..';                       
          END IF;
        END IF;
        
        IF COALESCE (inFromId, 0) <> COALESCE (vbUserUnitId, 0) AND COALESCE (inToId, 0) <> COALESCE (vbUserUnitId, 0) AND
           COALESCE (inFromId, 0) <> COALESCE (vbParentId, 0) AND COALESCE (inToId, 0) <> COALESCE (vbParentId, 0) 
        THEN 
          RAISE EXCEPTION 'Ошибка. Вам разрешено работать только с подразделением <%>.', (SELECT ValueData FROM Object WHERE ID = vbUserUnitId);     
        END IF;     
        
        IF (COALESCE (ioId, 0) = 0 OR inToId <> (SELECT MovementLinkObject_To.ObjectId FROM MovementLinkObject AS MovementLinkObject_To
                                                 WHERE MovementLinkObject_To.MovementId = ioId
                                                   AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()))
          AND inToId = (SELECT ObjectLink_Unit_UnitOverdue.ChildObjectId FROM ObjectLink AS ObjectLink_Unit_UnitOverdue
                        WHERE ObjectLink_Unit_UnitOverdue.ObjectId = vbUserUnitId
                          AND ObjectLink_Unit_UnitOverdue.DescId = zc_ObjectLink_Unit_UnitOverdue()) 
        THEN 
          RAISE EXCEPTION 'Ошибка. Вам запрещено создавать перемещения на виртуальный склад Сроки.';     
        END IF;     
        
     END IF;     

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_Send (ioId               := ioId
                                         , inInvNumber        := inInvNumber
                                         , inOperDate         := inOperDate
                                         , inFromId           := inFromId
                                         , inToId             := inToId
                                         , inComment          := inComment
                                         , inChecked          := inChecked
                                         , inisComplete       := inisComplete
                                         , inNumberSeats      := inNumberSeats
                                         , inDriverSunId      := inDriverSunId
                                         , inUserId           := vbUserId
                                          );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 18.12.18                                                       *  
 15.11.16         * inisComplete
 28.06.16         * 
 29.05.15                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Send (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')