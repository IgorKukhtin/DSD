-- Function: gpInsert_EDIFiles()

DROP FUNCTION IF EXISTS gpUpdate_IsElectronFromMedoc(TVarChar, TVarChar, TVarChar, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_IsElectronFromMedoc(
    IN inFromINN             TVarChar   , -- ИНН от кого
    IN inToINN               TVarChar   , -- ИНН кому
    IN inInvNumber           TVarChar   , -- Номер
    IN inOperDate            TDateTime  , -- Дата
    IN inDocKind             TVarChar   , -- Тип документа
    IN inSession             TVarChar     -- Пользователь
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EDI());
   vbUserId := lpGetUserBySession(inSession);

   CASE inDocKind 
        WHEN 'Tax' THEN
             SELECT Movement.Id INTO vbMovementId 
                    FROM Movement 
                         LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                         LEFT JOIN ObjectHistory_JuridicalDetails_View AS JuridicalFrom ON JuridicalFrom.JuridicalId = MovementLinkObject_From.ObjectId

                         LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                      ON MovementLinkObject_To.MovementId = Movement.Id
                                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                         LEFT JOIN ObjectHistory_JuridicalDetails_View AS JuridicalTo ON JuridicalTo.JuridicalId = MovementLinkObject_To.ObjectId

                         LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                                  ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                                 AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
              WHERE MovementString_InvNumberPartner.ValueData = inInvNumber AND JuridicalFrom.INN = inFromINN  
                AND JuridicalTo.INN = inToINN AND Movement.OperDate = inOperDate AND Movement.DescId = zc_Movement_Tax();
        WHEN 'TaxCorrective' THEN
             SELECT Movement.Id INTO vbMovementId 
                    FROM Movement 
                         LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                         LEFT JOIN ObjectHistory_JuridicalDetails_View AS JuridicalFrom ON JuridicalFrom.JuridicalId = MovementLinkObject_From.ObjectId

                         LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                      ON MovementLinkObject_To.MovementId = Movement.Id
                                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                         LEFT JOIN ObjectHistory_JuridicalDetails_View AS JuridicalTo ON JuridicalTo.JuridicalId = MovementLinkObject_To.ObjectId
                         LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                                  ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                                 AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
              WHERE MovementString_InvNumberPartner.ValueData = inInvNumber AND JuridicalFrom.INN = inToINN  
                AND JuridicalTo.INN = inFromINN 
                AND Movement.OperDate = inOperDate AND Movement.DescId = zc_Movement_TaxCorrective();
   END CASE;
   IF COALESCE(vbMovementId, 0) <> 0 THEN
      PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_Electron(), vbMovementId, true);
      -- сохранили протокол
      PERFORM lpInsert_MovementProtocol (vbMovementId, vbUserId, FALSE);      
   END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.04.15                         * 
 31.03.15                         * 

*/

-- тест
-- select * from gpUpdate_IsElectronFromMedoc('244471804626', '387340110310', '860', '16.03.2015'::TDateTime, 'Tax', '2');
--<inFromINN  DataType="ftString"   Value="244471804626" />
--<inToINN  DataType="ftString"   Value="387340110310" />
--<inInvNumber  DataType="ftString"   Value="860" />
--<inOperDate  DataType="ftDateTime"   Value="16.03.2015" />
--<inDocKind  DataType="ftString"   Value="Tax" />
