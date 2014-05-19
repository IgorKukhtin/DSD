-- Function: gpInsertUpdate_Movement_EDI()

-- DROP FUNCTION gpInsertUpdate_Movement_EDI (Integer, TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_EDI(
   OUT outId                 Integer   , -- Ключ объекта <Документ Перемещение>
    IN inOrderInvNumber      TVarChar  , -- Номер документа
    IN inOrderOperDate       TDateTime , -- Дата документа
    IN inSaleInvNumber       TVarChar  , -- Номер документа
    IN inSaleOperDate        TDateTime , -- Дата документа


    IN inGLN                 TVarChar   , -- От кого (в документе)
    IN inOKPO                TVarChar   , -- От кого (в документе)
 
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPartnerId Integer;
   DECLARE vbJuridicalId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EDI());
     vbUserId := inSession;

     outId := null;

     SELECT Id INTO outId 
       FROM Movement WHERE DescId = zc_Movement_EDI() AND OperDate = inOrderOperDate AND InvNumber = inOrderInvNumber;

     -- сохранили <Документ>
     IF COALESCE(outId, 0) = 0 THEN
        outId := lpInsertUpdate_Movement (outId, zc_Movement_EDI(), inOrderInvNumber, inOrderOperDate, NULL);
     END IF;

     PERFORM lpInsertUpdate_MovementString (zc_MovementString_SaleInvNumber(), outId, inSaleInvNumber);

     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_SaleOperDate(), outId, inSaleOperDate);
     
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_GLNCode(), outId, inGLN);

     PERFORM lpInsertUpdate_MovementString (zc_MovementString_OKPO(), outId, inOKPO);

     -- Находим контрагента по GLN
     vbPartnerId := COALESCE((SELECT ObjectId FROM ObjectString 
                       WHERE ObjectString.DescId = zc_ObjectString_Partner_GLNCode() AND ObjectString.ValueData = inGLN), 0);     

     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), outId, vbPartnerId);

     -- Находим Юр лицо по OKPO

     vbJuridicalId := COALESCE((SELECT JuridicalId FROM ObjectHistory_JuridicalDetails_ViewByDate
                         WHERE CURRENT_DATE BETWEEN StartDate AND EndDate
                           AND OKPO = inOKPO), 0);

     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), outId, vbJuridicalId);
    
     -- сохранили протокол
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.05.14                         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_EDI (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFromId:= 1, inToId:= 2, inSession:= '2')
