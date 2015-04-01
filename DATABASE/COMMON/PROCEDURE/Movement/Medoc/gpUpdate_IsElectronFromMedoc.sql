-- Function: gpInsert_EDIFiles()

DROP FUNCTION IF EXISTS gpUpdate_IsElectronFromMedoc(TVarChar, TVarChar, TVarChar, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_IsElectronFromMedoc(
    IN inOurOKPO             TVarChar   , -- ��� ����
    IN inFirmOKPO            TVarChar   , -- �� ����
    IN inInvNumber           TVarChar   , -- �����
    IN inOperDate            TDateTime  , -- ����
    IN inDocKind             TVarChar   , -- ��� ���������
    IN inSession             TVarChar     -- ������������
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
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
              WHERE MovementString_InvNumberPartner.ValueData = inInvNumber AND JuridicalFrom.OKPO = inOurOKPO  
                AND JuridicalTo.OKPO = inFirmOKPO AND Movement.OperDate = inOperDate AND Movement.DescId = zc_Movement_Tax();
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
              WHERE MovementString_InvNumberPartner.ValueData = inInvNumber AND JuridicalFrom.OKPO = inFirmOKPO  
                AND JuridicalTo.OKPO = inOurOKPO 
                AND Movement.OperDate = inOperDate AND Movement.DescId = zc_Movement_TaxCorrective();
   END CASE;
   IF COALESCE(vbMovementId, 0) <> 0 THEN
      PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_Electron(), vbMovementId, true);
   END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 31.03.15                         * 

*/

-- ����
-- select * from gpUpdate_IsElectronFromMedoc('24447183', '25288083', '3813', '05.01.2015'::TDateTime, 'TaxCorrective', '2');
