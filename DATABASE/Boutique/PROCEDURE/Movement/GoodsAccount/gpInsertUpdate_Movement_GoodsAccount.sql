-- Function: gpInsertUpdate_Movement_GoodsAccount()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_GoodsAccount (Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_GoodsAccount (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_GoodsAccount(
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
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_GoodsAccount());
     vbUserId := lpGetUserBySession (inSession);


     -- проверка может ли смотреть любой магазин, или только свой
     PERFORM lpCheckUnit_byUser (inUnitId_by:= inToId, inUserId:= vbUserId);

     
     -- определяется уникальный № док.
     IF COALESCE (ioId, 0) = 0 THEN
         ioInvNumber:= CAST (NEXTVAL ('Movement_GoodsAccount_seq') AS TVarChar);  
     ELSEIF vbUserId = zc_User_Sybase() THEN
        ioInvNumber:= (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = ioId);
     END IF;
     
     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_GoodsAccount (ioId                := ioId
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
 14.07.17         *
 18.05.17         *
 */

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_GoodsAccount(ioId := 7 , ioInvNumber := '4' , inOperDate := ('01.01.2017')::TDateTime , inFromId := 230 , inComment := 'df' ,  inSession := '2');
