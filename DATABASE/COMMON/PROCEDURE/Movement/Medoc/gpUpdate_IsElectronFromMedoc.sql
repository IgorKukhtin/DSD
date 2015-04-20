-- Function: gpInsert_EDIFiles()

DROP FUNCTION IF EXISTS gpUpdate_IsElectronFromMedoc(TVarChar, TVarChar, TVarChar, TDateTime, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_IsElectronFromMedoc(TVarChar, TVarChar, TVarChar, TDateTime, TVarChar, TVarChar, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_IsElectronFromMedoc(
   OUT outId                 Integer    ,
    IN inMedocCode           Integer    ,
    IN inFromINN             TVarChar   , -- ИНН от кого
    IN inToINN               TVarChar   , -- ИНН кому
    IN inInvNumber           TVarChar   , -- Номер
    IN inOperDate            TDateTime  , -- Дата
    IN inInvNumberBranch     TVarChar   , -- Филиал
    IN inInvNumberRegistered TVarChar   , -- Номер
    IN inDateRegistered      TDateTime  , -- Дата
    IN inDocKind             TVarChar   , -- Тип документа
    IN inSession             TVarChar     -- Пользователь
)                              
RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbFromId Integer;
   DECLARE vbToId Integer;
   DECLARE vbIsBranch_Medoc boolean;
   DECLARE vbAccessKey Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EDI());
   vbUserId := lpGetUserBySession(inSession);

   CASE inInvNumberBranch 
        WHEN '1' THEN vbAccessKey := zc_Enum_Process_AccessKey_DocumentKharkov();
        WHEN '2' THEN vbAccessKey := zc_Enum_Process_AccessKey_DocumentKiev();
        WHEN '5' THEN vbAccessKey := zc_Enum_Process_AccessKey_DocumentNikolaev();
        WHEN '8' THEN vbAccessKey := zc_Enum_Process_AccessKey_DocumentKrRog();
        WHEN '9' THEN vbAccessKey := zc_Enum_Process_AccessKey_DocumentCherkassi();
        ELSE  vbAccessKey := 0;
   END CASE;


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
                AND JuridicalTo.INN = inToINN AND Movement.OperDate = inOperDate AND Movement.DescId = zc_Movement_Tax()
                AND Movement.StatusId <> zc_Enum_Status_Erased() ;
              IF COALESCE(vbMovementId, 0) = 0 AND COALESCE(vbAccessKey, 0) <> 0 THEN 
                 SELECT JuridicalId INTO vbFromId FROM ObjectHistory_JuridicalDetails_View WHERE ObjectHistory_JuridicalDetails_View.INN = inFromINN;
                 SELECT JuridicalId INTO vbToId FROM ObjectHistory_JuridicalDetails_View WHERE ObjectHistory_JuridicalDetails_View.INN = inToINN;
                 vbMovementId := lpInsert_Movement_TaxMedoc(inInvNumber, inInvNumberBranch, 
                                       inOperDate, 20::TFloat, vbFromId, vbToId, vbUserId);                       
                 update Movement set AccessKeyId = vbAccessKey where Id = vbMovementId;
                 outId := vbMovementId;
              END IF; 
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
                AND JuridicalTo.INN = inFromINN AND Movement.StatusId <> zc_Enum_Status_Erased()
                AND Movement.OperDate = inOperDate AND Movement.DescId = zc_Movement_TaxCorrective();
              IF COALESCE(vbMovementId, 0) = 0 AND COALESCE(vbAccessKey, 0) <> 0 THEN 
                 SELECT JuridicalId INTO vbFromId FROM ObjectHistory_JuridicalDetails_View WHERE ObjectHistory_JuridicalDetails_View.INN = inFromINN;
                 SELECT JuridicalId INTO vbToId FROM ObjectHistory_JuridicalDetails_View WHERE ObjectHistory_JuridicalDetails_View.INN = inToINN;
                 vbMovementId := lpInsert_Movement_TaxCorrectiveMedoc(inInvNumber, inInvNumberBranch, 
                                       inOperDate, 20::TFloat, vbFromId, vbToId, vbUserId);
                 update Movement set AccessKeyId = vbAccessKey where Id = vbMovementId;
                 outId := vbMovementId;
              END IF; 
   END CASE;
   IF (COALESCE(vbMovementId, 0)) <> 0 THEN
       PERFORM lpInsertUpdate_MovementFloat(zc_MovementFloat_MedocCode(), vbMovementId, inMedocCode);
   END IF;
   IF (COALESCE(vbMovementId, 0)) <> 0 AND (COALESCE(inInvNumberRegistered, '') <> '') THEN
      PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_Electron(), vbMovementId, true);
      PERFORM lpInsertUpdate_MovementString(zc_MovementString_InvNumberRegistered(), vbMovementId, inInvNumberRegistered);
      PERFORM lpInsertUpdate_MovementDate(zc_MovementDate_DateRegistered(), vbMovementId, inDateRegistered);

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
