-- Function: gpInsertUpdate_Movement_GoodsAccount()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_GoodsAccount (Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_GoodsAccount(
 INOUT ioId                   Integer   , -- Ключ объекта <Документ>
 INOUT ioInvNumber            TVarChar  , -- Номер документа
    IN inOperDate             TDateTime , -- Дата документа
    IN inFromId               Integer   , -- От кого (в документе)
    IN inComment              TVarChar  , -- Примечание
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_GoodsAccount());

     IF COALESCE (ioId, 0) = 0 THEN
         ioInvNumber:= CAST (NEXTVAL ('movement_GoodsAccount_seq') AS TVarChar);  
     END IF;
     
     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_GoodsAccount (ioId                := ioId
                                                 , inInvNumber         := ioInvNumber
                                                 , inOperDate          := inOperDate
                                                 , inFromId            := inFromId
                                                 , inComment           := inComment
                                                 , inUserId            := vbUserId
                                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 18.05.17         *
 */

-- тест
-- select * from gpInsertUpdate_Movement_GoodsAccount(ioId := 7 , ioInvNumber := '4' , inOperDate := ('01.01.2017')::TDateTime , inFromId := 230 , inComment := 'df' ,  inSession := '2');