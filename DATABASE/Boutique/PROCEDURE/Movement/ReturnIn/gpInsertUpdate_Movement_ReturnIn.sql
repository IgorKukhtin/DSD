-- Function: gpInsertUpdate_Movement_ReturnIn()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReturnIn (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ReturnIn(
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
   DECLARE vbUnitId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReturnIn());
     vbUserId := lpGetUserBySession (inSession);


     -- определяем магазин по принадлежности пользователя к сотруднику
     vbUnitId:= lpGetUnitBySession (inSession);

     -- если у пользователя = 0, тогда может смотреть любой магазин, иначе только свой
     IF COALESCE (vbUnitId, 0 ) <> 0 AND COALESCE (vbUnitId) <> inToId
     THEN
         RAISE EXCEPTION 'Ошибка.У Пользователя <%> нет прав на подразделение <%> .', lfGet_Object_ValueData (vbUserId), lfGet_Object_ValueData (inToId);
     END IF;
     

     -- определяется уникальный № док.
     IF COALESCE (ioId, 0) = 0 THEN
         ioInvNumber:= CAST (NEXTVAL ('Movement_ReturnIn_seq') AS TVarChar);  
     ELSEIF vbUserId = zc_User_Sybase() THEN
        ioInvNumber:= (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = ioId);
     END IF;
     
     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_ReturnIn (ioId                := ioId
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
 15.05.17         *
 */

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_ReturnIn (ioId := 7 , ioInvNumber := '4' , inOperDate := ('01.01.2017')::TDateTime , inFromId := 230 , inToId := 229, inComment := 'df' ,  inSession := '2');
