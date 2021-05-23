-- Function: gpInsertUpdateMobile_MovementItem_Visit()

DROP FUNCTION IF EXISTS gpInsertUpdateMobile_MovementItem_Visit (TVarChar, TVarChar, TBlob, TVarChar, TVarChar, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdateMobile_MovementItem_Visit (TVarChar, TVarChar, TBlob, TVarChar, TVarChar, TDateTime, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdateMobile_MovementItem_Visit (TVarChar, TVarChar, TBlob, TVarChar, TVarChar, TFloat, TFloat, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdateMobile_MovementItem_Visit (TVarChar, TVarChar, TBlob, TVarChar, TVarChar, TFloat, TFloat, TVarChar, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdateMobile_MovementItem_Visit(
    IN inGUID         TVarChar  , -- Глобальный уникальный идентификатор для синхронизации с мобильными устройствами
    IN inMovementGUID TVarChar  , -- Глобальный уникальный идентификатор документа
    IN inPhoto        TBlob     , -- Фото, содержание файла
    IN inPhotoName    TVarChar  , -- Фото, имя файла
    IN inComment      TVarChar  , -- Примечание к фото
    IN inGPSN         TFloat    , -- GPS координаты фото (широта)
    IN inGPSE         TFloat    , -- GPS координаты фото (долгота)
    IN inAddressByGPS TVarChar  , -- Адрес, определенный по GPS
    IN inInsertDate   TDateTime , -- Дата/время создания элемента
    IN inIsErased     Boolean   , -- Удаленный ли элемент
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbPhotoMobileId Integer;
   DECLARE vbStatusId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      -- testm
      IF vbUserId = 1123966 -- testm
      THEN
          RAISE EXCEPTION 'Ошибка.Нет Прав.';
      END IF;


      -- получаем Id документа по GUID
      SELECT MovementString_GUID.MovementId
           , Movement_Visit.StatusId
      INTO vbMovementId
         , vbStatusId
      FROM MovementString AS MovementString_GUID
           JOIN Movement AS Movement_Visit
                         ON Movement_Visit.Id = MovementString_GUID.MovementId
                        AND Movement_Visit.DescId = zc_Movement_Visit()
      WHERE MovementString_GUID.DescId = zc_MovementString_GUID()
        AND MovementString_GUID.ValueData = inMovementGUID;

      IF COALESCE (vbMovementId, 0) = 0
      THEN
           RAISE EXCEPTION 'Ошибка. Не заведена шапка документа.';
      END IF;

      -- получаем Id строки документа по GUID
      SELECT MIString_GUID.MovementItemId
      INTO vbId
      FROM MovementItemString AS MIString_GUID
           JOIN MovementItem AS MovementItem_Visit
                             ON MovementItem_Visit.Id = MIString_GUID.MovementItemId
                            AND MovementItem_Visit.DescId = zc_MI_Master()
                            AND MovementItem_Visit.MovementId = vbMovementId
      WHERE MIString_GUID.DescId = zc_MIString_GUID()
        AND MIString_GUID.ValueData = inGUID;

      IF COALESCE (vbId, 0) <> 0
      THEN
           -- Находим существующий элемент PhotoMobile по ObjectCode
           SELECT Object_PhotoMobile.Id
           INTO vbPhotoMobileId
           FROM Object AS Object_PhotoMobile
           WHERE Object_PhotoMobile.DescId = zc_Object_PhotoMobile()
             AND Object_PhotoMobile.ObjectCode = vbId;
      END IF;

      IF COALESCE (vbPhotoMobileId, 0) = 0
      THEN
           -- сохраняем новый элемент PhotoMobile
           vbPhotoMobileId:= lpInsertUpdate_Object (0, zc_Object_PhotoMobile(), 0, TRIM (inPhotoName));
      END IF;

      IF vbStatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_Erased())
      THEN -- если визит проведен или удален, то распроводим
           PERFORM gpUnComplete_Movement_Visit (inMovementId:= vbMovementId, inSession:= inSession);
      END IF;

      vbId:= lpInsertUpdate_MovementItem_Visit (ioId:= vbId
                                              , inMovementId:= vbMovementId
                                              , inPhotoMobileId:= vbPhotoMobileId
                                              , inComment:= inComment
                                              , inUserId:= vbUserId
                                               );

      -- сохранили свойство <Глобальный уникальный идентификатор>
      PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GUID(), vbId, inGUID);

      -- обновляем элемент фото
      PERFORM lpInsertUpdate_Object_PhotoMobile (vbPhotoMobileId, vbId, TRIM (inPhotoName), inPhoto, vbUserId);

      -- сохранили свойство <GPS координаты фото (широта)>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_GPSN(), vbId, inGPSN);

      -- сохранили свойство <GPS координаты фото (долгота)>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_GPSE(), vbId, inGPSE);

      -- сохранили свойство <Адрес, определенный по GPS>
      PERFORM lpInsertUpdate_MovementItemString (zc_MIString_AddressByGPS(), vbId, inAddressByGPS);

      -- сохранили свойство <Дата/время создания>
      PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_InsertMobile(), vbId, inInsertDate);

      IF inIsErased
      THEN
           PERFORM gpMovementItem_Visit_SetErased (vbId, inSession);
      ELSE
           PERFORM gpMovementItem_Visit_SetUnErased (vbId, inSession);
      END IF;

      -- проводим визит
      PERFORM gpComplete_Movement_Visit (inMovementId:= vbMovementId, inSession:= inSession);

      -- сохранили свойство <Дата/время сохранения с мобильного устройства>
      PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_UpdateMobile(), vbMovementId, CURRENT_TIMESTAMP);

      RETURN vbId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 26.06.17                                                        * AddressByGPS
 04.04.17                                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdateMobile_MovementItem_Visit (inGUID:= '{29F0D6D3-006A-4D30-8B30-CECCD7D883C6}', inMovementGUID:= '{2F3BD890-0022-45F7-A1E2-9324BC312C76}', inPhoto:= NULL, inPhotoName:= 'NoPhoto', inComment:= 'simple test', inGPSN:= 56, inGPSE:= 57, inAddressByGPS:= 'г. Лесной, ул. Дубовая, 15', inInsertDate:= CURRENT_TIMESTAMP, inIsErased:= false, inSession:= zfCalc_UserAdmin())
