-- Function: gpInsertUpdate_Movement_RouteMember()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_RouteMember (Integer, TVarChar, TDateTime, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_RouteMember(
 INOUT ioId           Integer   , -- Ключ объекта <Документ>
    IN inInvNumber    TVarChar  , -- Номер документа
    IN inOperDate     TDateTime , -- Дата документа
    IN inGPSN         TFloat    , -- GPS координаты маршрута (широта)
    IN inGPSE         TFloat    , -- GPS координаты маршрута (долгота)
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS Integer 
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_RouteMember());
      vbUserId:= lpGetUserBySession (inSession);

      -- Сохранение
      ioId:= lpInsertUpdate_Movement_RouteMember (ioId        := ioId
                                                , inInvNumber := inInvNumber
                                                , inOperDate  := inOperDate
                                                , inGPSN      := inGPSN
                                                , inGPSE      := inGPSE
                                                , inUserId    := vbUserId
                                               );
      
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 27.03.17         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_RouteMember (ioId:= 0, inInvNumber:= '-1', inOperDate:= CURRENT_DATE, inPartnerId:= 0, inComment:= 'тестовый факт', inSession:= '5')
