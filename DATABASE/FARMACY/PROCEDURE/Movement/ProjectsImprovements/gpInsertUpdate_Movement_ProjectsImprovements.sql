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
                                                          
     outisApprovedBy := COALESCE ((SELECT MovementBoolean.ValueData 
                                   FROM MovementBoolean WHERE MovementBoolean.MovementId = ioId
                                    AND MovementBoolean.DescId = zc_MovementBoolean_ApprovedBy()), False);
     outStatusCode := (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = ioId);
     outStatusName := (SELECT Object.ValueData FROM Object WHERE Object.Id = outStatusCode);
                                    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
ALTER FUNCTION gpInsertUpdate_Movement_ProjectsImprovements (Integer, TVarChar, TDateTime, TVarChar, Text, TVarChar, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 12.05.20                                                       *
*/