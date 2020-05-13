-- Function: gpInsertUpdate_Movement_ProjectsImprovements()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProjectsImprovements (Integer, TVarChar, TDateTime, TVarChar, Text, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ProjectsImprovements(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Возврат поставщику>
 INOUT ioInvNumber           TVarChar  , -- Номер документа
 INOUT ioOperDate            TDateTime , -- Дата документа
    IN inTitle               TVarChar  , -- Название
    IN inDescription         Text      , -- Краткое описание 
    IN inComment             TVarChar  , -- Примечание 
   OUT outisApprovedBy       Boolean   , -- Утверждено
   OUT outStatusCode         Integer   ,
   OUT outStatusName         TVarChar  ,
   OUT outUserName           TVarChar  ,
    IN inSession             TVarChar    -- сессия пользователя
)                               
RETURNS Record AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProjectsImprovements());
     
     IF COALESCE(ioInvNumber, '') = ''
     THEN
       ioInvNumber := CAST (NEXTVAL ('Movement_ProjectsImprovements_seq') AS TVarChar);
     END IF;
     
     IF ioOperDate IS NULL
     THEN
       ioOperDate := CURRENT_DATE;
     END IF;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_ProjectsImprovements (ioId               := ioId
                                                         , inInvNumber        := ioInvNumber
                                                         , inOperDate         := ioOperDate
                                                         , inTitle            := inTitle
                                                         , inDescription      := inDescription
                                                         , inComment          := inComment
                                                         , inUserId           := vbUserId
                                                          );
                                                          
     SELECT T1.StatusCode, T1.StatusName, T1.isApprovedBy, T1.UserName
     INTO outStatusCode, outStatusName, outisApprovedBy, outUserName
     FROM gpGet_Movement_ProjectsImprovements (ioId, inSession) AS T1;
                                    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
ALTER FUNCTION gpInsertUpdate_Movement_ProjectsImprovements (Integer, TVarChar, TDateTime, TVarChar, Text, TVarChar, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 12.05.20                                                       *
*/

-- select * from gpInsertUpdate_Movement_ProjectsImprovements(ioId := 18831165 , ioInvNumber := '103' , ioOperDate := ('13.05.2020')::TDateTime , inTitle := 'Проба 1' , inDescription := 'Чтото сделать' , inComment := '' ,  inSession := '3');