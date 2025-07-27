-- Function: gpInsertUpdate_Movement_HospitalDoc_1C_Load ()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_HospitalDoc_1C_Load (TDateTime, TDateTime, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_HospitalDoc_1C_Load(
    IN inServiceDate         TDateTime   , --
    IN inStartStop           TDateTime  , -- 
    IN inEndStop             TDateTime  , -- 
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
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
           vbMovementId Integer;
           vbInvNumber TVarChar;
           vbMemberId Integer;
           vbPersonalId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_HospitalDoc_1C());
     vbUserId:= lpGetUserBySession (inSession);

     --проверка 
     IF COALESCE (inINN,'') = ''
     THEN
          RAISE EXCEPTION 'Ошибка.<ИНН> должен быть заполнен. (%) <%>', inCode1C, inFIO;
     END IF;

     -- мес начислений + Номер документа 1с + Дата с + Дата по + инн
     --пробуем найти документ
     SELECT Movement.Id
           , Movement.InvNumber 
    INTO vbMovementId, vbInvNumber 
      FROM Movement
           INNER JOIN MovementDate AS MovementDate_StartStop
                                   ON MovementDate_StartStop.MovementId = Movement.Id
                                  AND MovementDate_StartStop.DescId = zc_MovementDate_StartStop()
                                  AND MovementDate_StartStop.ValueData = inStartStop

           INNER JOIN MovementDate AS MovementDate_EndStop
                                   ON MovementDate_EndStop.MovementId = Movement.Id
                                  AND MovementDate_EndStop.DescId = zc_MovementDate_EndStop()
                                  AND MovementDate_EndStop.ValueData = inEndStop

           INNER JOIN MovementString AS MovementString_INN
                                     ON MovementString_INN.MovementId = Movement.Id
                                    AND MovementString_INN.DescId = zc_MovementString_INN()
                                    AND MovementString_INN.ValueData = inINN

           INNER JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
                                    AND MovementString_InvNumberPartner.ValueData = inInvNumberPartner
      WHERE Movement.OperDate = inServiceDate
        AND Movement.DescId = zc_Movement_HospitalDoc_1C()
        AND Movement.StatusId <> zc_Enum_Status_Erased() 
      ;
     --физ. лицо по ИНН 
     vbMemberId := (SELECT ObjectString_INN.ObjectId
                    FROM ObjectString AS ObjectString_INN
                    WHERE ObjectString_INN.DescId = zc_ObjectString_Member_INN()
                      AND ObjectString_INN.ValueData = inINN
                    );

     vbPersonalId := (SELECT lfSelect.PersonalId
                      FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                      WHERE lfSelect.Ord = 1
                        AND lfSelect.MemberId = vbMemberId
                      ); 

     IF COALESCE (vbInvNumber,'') = ''
     THEN
         vbInvNumber := CAST (NEXTVAL ('movement_hospitaldoc_1c_seq') AS TVarChar);
     END IF;
     
     -- сохранили <Документ>
     PERFORM lpInsertUpdate_Movement_HospitalDoc_1C (ioId                := COALESCE (vbMovementId,0) ::Integer
                                                   , inInvNumber         := vbInvNumber            ::TVarChar
                                                   , inOperDate          := inServiceDate          ::TDateTime
                                                   , inServiceDate       := inServiceDate          ::TDateTime  
                                                   , inStartStop         := inStartStop            ::TDateTime  --
                                                   , inEndStop           := inEndStop              ::TDateTime  --
                                                   , inPersonalId        := vbPersonalId           ::Integer
                                                   , inCode1C            := inCode1C               ::TVarChar   --
                                                   , inINN               := inINN                  ::TVarChar   --
                                                   , inFIO               := inFIO                  ::TVarChar   --
                                                   , inComment           := inComment              ::TVarChar   --
                                                   --, inError           := inError                ::TVarChar   -
                                                   , inInvNumberPartner  := inInvNumberPartner     ::TVarChar   --
                                                   , inInvNumberHospital := inInvNumberHospital    ::TVarChar   --
                                                   , inNumHospital       := inNumHospital          ::TVarChar   --
                                                   , inSummStart         := inSummStart            ::TFloat     --
                                                   , inSummPF            := inSummPF               ::TFloat     --
                                                   , inUserId            := vbUserId               ::Integer
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