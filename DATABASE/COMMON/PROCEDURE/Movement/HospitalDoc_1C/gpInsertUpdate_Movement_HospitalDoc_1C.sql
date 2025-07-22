-- Function: gpInsertUpdate_Movement_HospitalDoc_1C_Load ()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_HospitalDoc_1C_Load (TDateTime, TDateTime, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_HospitalDoc_1C_Load(
    IN inOperDate            TDateTime , -- Дата документа
    IN inStartStop           TDateTime  , -- 
    IN inEndStop             TDateTime   , --             
    IN inServiceDate         TVarChar   , -- 
    IN inCode1C              TVarChar  , -- 
    IN inINN                 TVarChar  , -- 
    IN inFIO                 TVarChar  , -- 
    IN inComment             TVarChar  , -- 
   -- IN inError               TVarChar  , -- 
    IN inInvNumberPartner    TVarChar  , -- 
    IN inInvNumberHospital   TVarChar  , -- 
    IN inNumHospital         TVarChar  , -- 
    IN inSummStart           TFloat  , -- 
    IN inSummPF              TFloat  , -- 
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_HospitalDoc_1C());
     vbUserId:= lpGetUserBySession (inSession);



     --проверка 
     IF COALESCE (,0) = 0
     THEN
          RAISE EXCEPTION 'Ошибка.<> должен быть заполнен.';
     END IF;

     -- сохранили <Документ>
     ioId:= lpInsertUpdate_Movement_HospitalDoc_1C ( ioId              := ioId
                                                   , inInvNumber       := inInvNumber
                                                   , inOperDate        := inOperDate             ::TDateTime
                                                   , inServiceDate     := inServiceDate          ::TDateTime  
                                                   , inStartStop       := inStartStop            ::TDateTime  --
                                                   , inEndStop         := inEndStop              ::TDateTime  --
                                                   , inPersonalId      := inPersonalId           ::Integer
                                                   , inCode1C          := inCode1C               ::TVarChar   --
                                                   , inINN             := inINN                  ::TVarChar   --
                                                   , inFIO             := inFIO                  ::TVarChar   --
                                                   , inComment         := inComment              ::TVarChar   --
                                                   , inError           := inError                ::TVarChar   -
                                                   , inInvNumberPartner  := inInvNumberPartner   ::TVarChar   --
                                                   , inInvNumberHospital := inInvNumberHospital  ::TVarChar   --
                                                   , inNumHospital       := inNumHospital        ::TVarChar   --
                                                   , inSummStart       := inSummStart            ::TFloat     --
                                                   , inSummPF          := inSummPF               ::TFloat     --
                                                   , inUserId          := vbUserId               ::Integer
                                                    );  
                                                   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.07.25         *
*/

-- тест
--