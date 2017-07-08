-- Function: gpInsertUpdate_Movement_Inventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Inventory (Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Inventory (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Inventory(
 INOUT ioId                   Integer   , -- Ключ объекта <Документ>
 INOUT ioInvNumber            TVarChar  , -- Номер документа
    IN inOperDate             TDateTime , -- Дата документа
    IN inFromId               Integer   , -- Подразделения
    IN inToId                 Integer   , -- Склад
    IN inComment              TVarChar  , -- Примечание
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Inventory());
     
     IF COALESCE (ioId, 0) = 0 THEN
         ioInvNumber:= CAST (NEXTVAL ('movement_inventory_seq') AS TVarChar);  
     ELSEIF vbUserId = zc_User_Sybase() THEN
        ioInvNumber:= (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = ioId);
     END IF;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_Inventory (ioId                := ioId
                                              , inInvNumber         := ioInvNumber
                                              , inOperDate          := inOperDate
                                              , inFromId            := inFromId
                                              , inToId              := inToId
                                              , inComment           := inComment
                                              , inUserId            := vbUserId
                                              );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 02.05.17         *
 */

-- тест
-- select * from gpInsertUpdate_Movement_Inventory(ioId := 25 , ioInvNumber := '3' , inOperDate := ('01.01.2017')::TDateTime , inFromId := 311 , inToId := 0 , inComment := 'sdfgh' ,  inSession := '2');