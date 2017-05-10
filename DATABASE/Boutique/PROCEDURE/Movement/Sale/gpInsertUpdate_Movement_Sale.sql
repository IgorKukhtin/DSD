-- Function: gpInsertUpdate_Movement_Sale()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Sale (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Sale(
 INOUT ioId                   Integer   , -- Ключ объекта <Документ>
 INOUT ioInvNumber            TVarChar  , -- Номер документа
    IN inOperDate             TDateTime , -- Дата документа
    IN inFromId               Integer   , -- От кого (в документе)
    IN inToId                 Integer   , -- Кому (в документе)
    IN inComment              TVarChar  , -- Примечание
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());

     IF COALESCE (ioId, 0) = 0 THEN
         ioInvNumber:= CAST (NEXTVAL ('movement_Sale_seq') AS TVarChar);  
     END IF;
     
     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_Sale (ioId                := ioId
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
 09.05.17         *
 */

-- тест
-- select * from gpInsertUpdate_Movement_Sale(ioId := 7 , ioInvNumber := '4' , inOperDate := ('01.01.2017')::TDateTime , inFromId := 230 , inToId := 229, inComment := 'df' ,  inSession := '2');