-- Function: gpSetErased_Movement_Tabletki_CheckBooking()

DROP FUNCTION IF EXISTS gpSetErased_Movement_Tabletki_CheckBooking (TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_Tabletki_CheckBooking(
    IN inBookingId         TVarChar  , -- ID заказа на сайте
    IN inComment           TVarChar  , -- ID заказа на сайте    
   OUT outisOk             Boolean   , -- Удалили 
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    IF inSession = zfCalc_UserAdmin()
    THEN
      inSession = zfCalc_UserSite();
    END IF;

    vbUserId := lpGetUserBySession (inSession);
    
    outisOk := False;

    IF COALESCE(inBookingId, '') = ''
    THEN
        RAISE EXCEPTION 'Оштбка. Не заполнено ID звказа';
    END IF;

    vbId := COALESCE((SELECT MovementString.MovementId
                      FROM MovementString
                           INNER JOIN Movement ON Movement.ID = MovementString.MovementId
                                              AND Movement.StatusId = zc_Enum_Status_UnComplete() 
                      WHERE MovementString.DescId = zc_MovementString_BookingId()
                        AND MovementString.ValueData = inBookingId), 0);

    IF COALESCE(vbId, 0) = 0
    THEN
      RETURN;
    END IF;

    -- сохранили Статус заказа
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_BookingStatus(), vbId, '7.0');

    IF COALESCE (TRIM(inComment), '') <> '' THEN
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_CommentCustomer(), vbId, TRIM(inComment));
	END IF;
    
    -- Удалили документ
    PERFORM gpSetErased_Movement_Check (inMovementId:= vbId, inSession:= inSession);

    outisOk := True;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 26.04.23                                                       *
*/

-- тест
-- 
SELECT * FROM gpSetErased_Movement_Tabletki_CheckBooking ('3f7c5314-6160-472e-acd8-dde7c0f7c65b', 'Не встигаю забрати', '3');