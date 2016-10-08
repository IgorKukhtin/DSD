-- Function: gpUpdate_Movement_WeighingPartner()

DROP FUNCTION IF EXISTS gpUpdate_Movement_WeighingPartner (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_WeighingPartner(
    IN inId                   Integer   , -- Ключ объекта <Документ>
    IN inWeighingNumber       Integer   , -- Номер взвешивания
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
  
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_WeighingPartner());
     vbUserId:= lpGetUserBySession (inSession);

     -- сохранили свойство <Номер взвешивания>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_WeighingNumber(), inId, inWeighingNumber);

    
     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 05.10.15         *
*/

-- select lpInsertUpdate_MovementFloat (zc_MovementFloat_WeighingNumber(), 2005096 , 8);

-- SELECT * FROM gpUpdate_Movement_WeighingPartner (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', , inSession:= '2')
