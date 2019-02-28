-- Function: gpInsert_EDIFiles()

DROP FUNCTION IF EXISTS gpUpdate_IsMedoc (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_IsMedoc(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inSession             TVarChar     -- ������������
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_...());
   vbUserId:= lpGetUserBySession (inSession);


   -- ��������
   IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_TaxCorrective())
      AND NOT EXISTS (SELECT 1 FROM MovementBoolean    AS MB  WHERE MB.MovementId  = inMovementId AND MB.DescId  = zc_MovementBoolean_NPP_calc()           AND MB.ValueData = TRUE)
      AND NOT EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_DocumentTaxKind() AND MLO.ObjectId = zc_Enum_DocumentTaxKind_Prepay())
   THEN
       RAISE EXCEPTION '������.��� ��������� <%> � <%> �� <%>  �� ��������� �������� <������������ � �/� ��� ������� 1/2������>.'
                     , (SELECT MovementDesc.ItemName FROM MovementDesc         WHERE MovementDesc.Id = zc_Movement_TaxCorrective())
                     , (SELECT MS.ValueData          FROM MovementString AS MS WHERE MS.MovementId = inMovementId AND MS.DescId = zc_MovementString_InvNumberPartner())
                     , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = inMovementId)
                      ;
   END IF;

   -- ��������� - �������� � ����� ������
   PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Medoc(), inMovementId, TRUE);

   -- ��������� "������� ����", ������ "�����������" - ���� � ��� ��� ������ ������� ����������� (�.�. ����������� �����)
   PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_DateRegistered(), tmp.MovementId, CURRENT_DATE)
   FROM (SELECT inMovementId AS MovementId) AS tmp
        LEFT JOIN MovementBoolean ON MovementBoolean.MovementId = tmp.MovementId
                                 AND MovementBoolean.DescId = zc_MovementBoolean_Electron()
   WHERE COALESCE (MovementBoolean.ValueData, FALSE) = FALSE
   ;

   -- ��������� ��������
   PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.03.16                                        * 
 15.12.14                         * 
*/

-- ����
-- SELECT * FROM gpUpdate_IsMedoc (ioId:= 0, inSession:= '2')
