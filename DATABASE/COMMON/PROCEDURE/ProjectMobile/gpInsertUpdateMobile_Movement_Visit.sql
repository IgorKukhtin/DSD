-- Function: gpInsertUpdateMobile_Movement_Visit()

DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Movement_Visit (TVarChar, TVarChar, TDateTime, Integer, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdateMobile_Movement_Visit (
    IN inGUID       TVarChar  , -- Глобальный уникальный идентификатор для синхронизации с мобильными устройствами
    IN inInvNumber  TVarChar  , -- Номер документа
    IN inOperDate   TDateTime , -- Дата документа
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
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      -- получаем Id документа по GUID
      SELECT MovementString_GUID.MovementId 
      INTO vbId 
      FROM MovementString AS MovementString_GUID
           JOIN Movement AS Movement_Visit
                         ON Movement_Visit.Id = MovementString_GUID.MovementId
                        AND Movement_Visit.DescId = zc_Movement_Visit()
      WHERE MovementString_GUID.DescId = zc_MovementString_GUID() 
        AND MovementString_GUID.ValueData = inGUID;

      vbId:= lpInsertUpdate_Movement_Visit (ioId:= vbId
                                          , inInvNumber:= inInvNumber
                                          , inOperDate:= inOperDate
                                          , inPartnerId:= inPartnerId
                                          , inComment:= inComment 
                                          , inUserId:= vbUserId
                                           );

      -- сохранили свойство <Дата/время создания на мобильном устройстве>
      PERFORM lpInsertUpdate_MovementDate(zc_MovementDate_InsertMobile(), vbId, inInsertDate);

      -- сохранили свойство <Глобальный уникальный идентификатор>
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_GUID(), vbId, inGUID);

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
-- SELECT * FROM gpInsertUpdateMobile_Movement_Visit (inGUID:= '{2F3BD890-0022-45F7-A1E2-9324BC312C76}', inInvNumber:= '-7', inOperDate:= CURRENT_DATE, inPartnerId:= 17819, inComment:= 'Це з мобілки прийшло :)', inInsertDate:= CURRENT_TIMESTAMP, inSession:= zfCalc_UserAdmin());
