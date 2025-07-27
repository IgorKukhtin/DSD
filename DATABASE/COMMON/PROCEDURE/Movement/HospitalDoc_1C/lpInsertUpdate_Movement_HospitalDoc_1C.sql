-- Function: lpInsertUpdate_Movement_HospitalDoc_1C ()

--DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_HospitalDoc_1C (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_HospitalDoc_1C (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_HospitalDoc_1C(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inServiceDate         TDateTime   , -- 
    IN inStartStop           TDateTime  , -- 
    IN inEndStop             TDateTime   , --
    IN inPersonalId          Integer   , -- 
    IN inCode1C              TVarChar  , -- 
    IN inINN                 TVarChar  , -- 
    IN inFIO                 TVarChar  , -- 
    IN inComment             TVarChar  , -- 
    --IN inError               TVarChar  , -- 
    IN inInvNumberPartner    TVarChar  , -- 
    IN inInvNumberHospital   TVarChar  , -- 
    IN inNumHospital         TVarChar  , -- 
    IN inSummStart           TFloat  , -- 
    IN inSummPF              TFloat  , -- 
    IN inUserId              Integer     -- Пользователь
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- определяем ключ доступа
     --vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_HospitalDoc_1C());
     --vbUserId:= lpGetUserBySession (inSession);

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_HospitalDoc_1C(), inInvNumber, inOperDate, NULL);

     -- расчет - 1-ое число месяца
     inServiceDate:= DATE_TRUNC ('MONTH', inServiceDate);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_ServiceDate(), ioId, inServiceDate);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartStop(), ioId, inStartStop);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndStop(), ioId, inEndStop);
 
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Code1C(), ioId, inCode1C); 
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_INN(), ioId, inINN); 
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_FIO(), ioId, inFIO); 
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment); 
     -- сохранили свойство <>
     --PERFORM lpInsertUpdate_MovementString (zc_MovementString_Error(), ioId, inError); 
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner); 
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberHospital(), ioId, inInvNumberHospital); 
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_NumHospital(), ioId, inNumHospital); 


     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummStart(), ioId, inSummStart);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummPF(), ioId, inSummPF);
               
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Personal(), ioId, inPersonalId);
     
     IF vbIsInsert = TRUE
     THEN
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
     ELSE
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
     END IF;
     
     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);


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