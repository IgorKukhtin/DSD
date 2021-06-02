-- Function: gpInsert_Movement_Sale_SMS()


DROP FUNCTION IF EXISTS gpInsert_Movement_Sale_SMS (Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Sale_SMS(
 INOUT ioId                   Integer   , -- Ключ объекта <Документ>
   OUT outSmsSettingsName     TVarChar   , -- 
   OUT outLogin               TVarChar   , -- 
   OUT outPassword            TVarChar   , -- 
   OUT outMessage             TVarChar   , -- 
   OUT outPhoneSMS            TVarChar   , -- 
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());
     vbUserId := lpGetUserBySession (inSession);

     SELECT ObjectString_PhoneMobile.ValueData AS PhoneMobile
   INTO outPhoneSMS
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN ObjectString AS ObjectString_PhoneMobile
                                 ON ObjectString_PhoneMobile.ObjectId = MovementLinkObject_To.ObjectId
                                AND ObjectString_PhoneMobile.DescId = zc_ObjectString_Client_PhoneMobile()
     WHERE Movement.Id = ioId;
       

     SELECT tmp.Name     :: TVarChar
          , tmp.Login    :: TVarChar
          , tmp.Password :: TVarChar
          , tmp.Message  :: TVarChar
    INTO outSmsSettingsName, outLogin, outPassword, outMessage
     FROM gpSelect_Object_SmsSettings(inIsShowAll := FALSE, inSession := inSession) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.06.21         *
 */

-- тест