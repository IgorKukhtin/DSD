-- Function: gpInsertUpdateMobile_Movement_RouteMember()

-- DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Movement_RouteMember (TVarChar, TVarChar, TDateTime, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Movement_RouteMember (TVarChar, TVarChar, TDateTime, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdateMobile_Movement_RouteMember (
    IN inGUID         TVarChar  , -- Глобальный уникальный идентификатор для синхронизации с мобильными устройствами
    IN inInvNumber    TVarChar  , -- Номер документа
    IN inInsertDate   TDateTime , -- Дата/время создания
    IN inGPSN         TFloat    , -- GPS координаты маршрута (широта)
    IN inGPSE         TFloat    , -- GPS координаты маршрута (долгота)
    IN inAddressByGPS TVarChar  , -- Адрес, определенный по GPS
    IN inSession      TVarChar    -- сессия пользователя
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


      -- testm
      IF vbUserId = 1123966 -- testm
      THEN
          RAISE EXCEPTION 'Ошибка.Нет Прав.';
      END IF;
      
      -- Замена
      IF COALESCE (inInsertDate, zc_DateStart()) <= zc_DateStart()
      THEN
          inInsertDate:= CURRENT_DATE;
      END IF;

-- Хаджиева В.С.
-- IF inGUID = '?13' AND vbUserId = 1156045 THEN RETURN 0; END IF;
--  IF vbUserId = 1156045 THEN RETURN 0; END IF;
-- testm
--  IF vbUserId = 1123966 THEN RETURN 0; END IF;
 


      -- поиск Id документа по GUID
      SELECT MovementString_GUID.MovementId 
           , Movement_RouteMember.StatusId
      INTO vbId 
         , vbStatusId
      FROM MovementString AS MovementString_GUID
           JOIN Movement AS Movement_RouteMember
                         ON Movement_RouteMember.Id = MovementString_GUID.MovementId
                        AND Movement_RouteMember.DescId = zc_Movement_RouteMember()
      WHERE MovementString_GUID.DescId = zc_MovementString_GUID() 
        AND MovementString_GUID.ValueData = inGUID;


      -- определяем признак Создание/Корректировка
      vbisInsert:= (COALESCE (vbId, 0) = 0);

      IF (vbisInsert = FALSE) AND (vbStatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_Erased()))
      THEN 
           -- если маршрут торгового агента проведен, то распроводим
           PERFORM gpUnComplete_Movement_RouteMember (inMovementId:= vbId, inSession:= inSession);
      END IF;


      -- сохраняем
      vbId:= lpInsertUpdate_Movement_RouteMember (ioId        := vbId
                                                , inInvNumber := (zfConvert_StringToNumber (inInvNumber) + lfGet_User_BillNumberMobile (vbUserId)) :: TVarChar
                                                , inOperDate  := DATE_TRUNC ('day', inInsertDate)
                                                , inGPSN      := inGPSN
                                                , inGPSE      := inGPSE
                                                , inUserId    := vbUserId
                                                 );

      -- сохранили свойство <Дата/время создания на мобильном устройстве>
      PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_InsertMobile(), vbId, inInsertDate);

      -- сохранили свойство <Глобальный уникальный идентификатор>
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_GUID(), vbId, inGUID);

      -- сохранили свойство <Адрес, определенный по GPS>
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_AddressByGPS(), vbId, inAddressByGPS);

      -- проводим маршрут торгового агента
      PERFORM gpComplete_Movement_RouteMember (inMovementId:= vbId, inSession:= inSession);

      IF vbisInsert = FALSE
      THEN
          -- сохранили свойство < Дата/время когда выполнилась загрузка с моб устр >
          PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_UpdateMobile(), vbId, CURRENT_TIMESTAMP);
      END IF;

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
-- SELECT * FROM gpInsertUpdateMobile_Movement_RouteMember (inGUID:= '{94774140-0FF6-4DC3-910C-5805989B6FC4}', inInvNumber:= '-9', inInsertDate:= CURRENT_TIMESTAMP, inGPSN:= 56, inGPSE:= 56, inAddressByGPS:= 'г. Кузнецк, ул. Сталелитейная, 7', inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpInsertUpdateMobile_Movement_RouteMember (inGUID:= '?13', inInvNumber:= '57710', inInsertDate:= '04.03.1518 14:43:59', inGPSN:= 47.8988, inGPSE:= 33.3982, inAddressByGPS:= '', inSession:= '1156045');

