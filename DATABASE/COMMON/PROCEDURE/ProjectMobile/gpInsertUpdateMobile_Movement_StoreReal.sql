-- Function: gpInsertUpdateMobile_Movement_StoreReal()

DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Movement_StoreReal (TVarChar, TVarChar, TDateTime, Integer, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdateMobile_Movement_StoreReal (
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


      -- получаем Id документа по GUID
      SELECT MovementString_GUID.MovementId 
           , Movement_StoreReal.StatusId
      INTO vbId 
         , vbStatusId
      FROM MovementString AS MovementString_GUID
           JOIN Movement AS Movement_StoreReal
                         ON Movement_StoreReal.Id = MovementString_GUID.MovementId
                        AND Movement_StoreReal.DescId = zc_Movement_StoreReal()
      WHERE MovementString_GUID.DescId = zc_MovementString_GUID() 
        AND MovementString_GUID.ValueData = inGUID;

      vbisInsert:= (COALESCE (vbId, 0) = 0);

      IF vbisInsert = TRUE
      THEN
           PERFORM lpInsert_LockUnique (inKeyData:= inGUID, inUserId:= vbUserId);
      END IF;
                                                                                       
      IF (vbisInsert = false) AND (vbStatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_Erased()))
      THEN -- если фактический остаток проведен, то распроводим    
           PERFORM gpUnComplete_Movement_StoreReal (inMovementId:= vbId, inSession:= inSession);
      END IF;

      vbId:= lpInsertUpdate_Movement_StoreReal (ioId        := vbId
                                              , inInvNumber := (zfConvert_StringToNumber (inInvNumber) + lfGet_User_BillNumberMobile (vbUserId)) :: TVarChar
                                              , inOperDate  := inOperDate
                                              , inPartnerId := CASE WHEN COALESCE (inPartnerId, 0) <= 0 THEN 273855 ELSE inPartnerId END -- ТОВ "АЛАН"(покупат)
                                              , inComment   := inComment 
                                              , inUserId    := vbUserId
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
 16.02.17                                                        *                                          
*/

-- тест
/* 
  SELECT * FROM gpInsertUpdateMobile_Movement_StoreReal (inGUID:= '{678E6742-8182-4FF4-8882-D1DFF49D6C62}'
                                                       , inInvNumber:= '-3'
                                                       , inOperDate:= CURRENT_DATE
                                                       , inPartnerId:= 17819
                                                       , inComment:= 'Це з мобілки прийшло :)'
                                                       , inInsertDate:= CURRENT_TIMESTAMP
                                                       , inSession:= zfCalc_UserAdmin()
                                                        );
*/

/* 
  SELECT * FROM gpInsertUpdateMobile_Movement_StoreReal (inGUID:= '{F7D25B81-B904-4473-9A51-B0104B344069}'
                                                       , inInvNumber:= '-4'
                                                       , inOperDate:= CURRENT_DATE
                                                       , inPartnerId:= 17819
                                                       , inComment:= 'І знову це з мобілки прийшло :)'
                                                       , inInsertDate:= CURRENT_TIMESTAMP
                                                       , inSession:= zfCalc_UserAdmin()
                                                        );
*/
