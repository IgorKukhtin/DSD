-- Function: gpInsertUpdateMobile_Movement_Visit()

DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Movement_Visit (TVarChar, TVarChar, TDateTime, Integer, TVarChar, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Movement_Visit (TVarChar, TVarChar, TDateTime, Integer, Integer, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdateMobile_Movement_Visit (
    IN inGUID       TVarChar  , -- Глобальный уникальный идентификатор для синхронизации с мобильными устройствами
    IN inInvNumber  TVarChar  , -- Номер документа
    IN inOperDate   TDateTime , -- Дата документа
    IN inStatusId   Integer   , -- Виды статусов
    IN inPartnerId  Integer   , -- Контрагент
    IN inComment    TVarChar  , -- Примечание
    IN inInsertDate TDateTime , -- Дата/время создания
    IN inSession    TVarChar    -- сессия пользователя
)
RETURNS Integer 
AS
$BODY$
   DECLARE vbId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbisInsert Boolean;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      -- получаем Id документа по GUID
      SELECT MovementString_GUID.MovementId 
           , Movement_Visit.StatusId
      INTO vbId 
         , vbStatusId
      FROM MovementString AS MovementString_GUID
           JOIN Movement AS Movement_Visit
                         ON Movement_Visit.Id = MovementString_GUID.MovementId
                        AND Movement_Visit.DescId = zc_Movement_Visit()
      WHERE MovementString_GUID.DescId = zc_MovementString_GUID() 
        AND MovementString_GUID.ValueData = inGUID;

      vbisInsert:= (COALESCE (vbId, 0) = 0);

      IF (vbisInsert = false) AND (vbStatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_Erased()))
      THEN -- если визит проведен или удален, то распроводим
           PERFORM gpUnComplete_Movement_Visit (inMovementId:= vbId, inSession:= inSession);
      END IF;

      vbId:= lpInsertUpdate_Movement_Visit (ioId        := vbId
                                          , inInvNumber := (zfConvert_StringToNumber (inInvNumber) + lfGet_User_BillNumberMobile (vbUserId)) :: TVarChar
                                          , inOperDate  := inOperDate
                                          , inPartnerId := inPartnerId
                                          , inComment   := inComment 
                                          , inUserId    := vbUserId
                                           );

      -- сохранили свойство <Дата/время создания на мобильном устройстве>
      PERFORM lpInsertUpdate_MovementDate(zc_MovementDate_InsertMobile(), vbId, inInsertDate);

      -- сохранили свойство <Глобальный уникальный идентификатор>
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_GUID(), vbId, inGUID);

      IF COALESCE (inStatusId, 0) NOT IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
      THEN
           inStatusId:= zc_Enum_Status_Complete();
      END IF;

      IF inStatusId = zc_Enum_Status_Complete()
      THEN -- проводим визит
           PERFORM gpComplete_Movement_Visit (inMovementId:= vbId, inSession:= inSession);
      ELSIF inStatusId = zc_Enum_Status_Erased()
      THEN -- удаляем визит
           PERFORM gpSetErased_Movement_Visit (inMovementId:= vbId, inSession:= inSession);
      END IF;

      RETURN vbId;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 03.04.17                                                        *                                          
*/

-- тест
-- SELECT * FROM gpInsertUpdateMobile_Movement_Visit (inGUID:= '{2F3BD890-0022-45F7-A1E2-9324BC312C76}', inInvNumber:= '-7', inOperDate:= CURRENT_DATE, inStatusId:= zc_Enum_Status_UnComplete(), inPartnerId:= 17819, inComment:= 'Це з мобілки прийшло :)', inInsertDate:= CURRENT_TIMESTAMP, inSession:= zfCalc_UserAdmin());
