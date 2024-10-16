-- Function: gpInsertUpdate_Movement_Check()

-- DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_SpParam (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, TVarChar);
-- DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_SpParam (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_SpParam (Integer, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_SpParam (Integer, Integer, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_SpParam (Integer, Integer, Integer, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_SpParam(
    IN inId                  Integer   , -- ���� ������� <�������� ���>
    IN inSPKindId            Integer   , -- ��� ���.�������
    IN inPartnerMedicalId    Integer   , -- ����������� ����������(���. ������)
    IN inOperDateSP          TDateTime , -- ���� ������� (���. ������)
    IN inAmbulance           TVarChar  , --
    IN inMedicSP             TVarChar  , -- ��� ����� (���. ������)
    IN inInvNumberSP         TVarChar  , -- ����� ������� (���. ������)
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMedicSPId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    vbUserId := lpGetUserBySession (inSession);

    -- �������� ������������ ��� ����� � ���������
    IF NOT EXISTS (SELECT Object_MedicSP.Id                 AS Id
                   FROM Object AS Object_MedicSP
                       INNER JOIN ObjectLink AS ObjectLink_MedicSP_PartnerMedical
                                            ON ObjectLink_MedicSP_PartnerMedical.ObjectId = Object_MedicSP.Id
                                           AND ObjectLink_MedicSP_PartnerMedical.DescId = zc_ObjectLink_MedicSP_PartnerMedical()
                                           AND ObjectLink_MedicSP_PartnerMedical.ChildObjectId = inPartnerMedicalId
                   WHERE Object_MedicSP.DescId = zc_Object_MedicSP()
                     AND UPPER(Object_MedicSP.ValueData) LIKE UPPER ('%' || inMedicSP || '%')     --('%���������%')   --
                   )
       ANd (inPartnerMedicalId > 0
         OR inMedicSP <> '')
    THEN
        RAISE EXCEPTION '������.��� ����� <%> �� ������������� ���������� ���.����������.', inMedicSP;
    END IF;
    
    
    
    vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inId);

    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SPKind(), inId, inSPKindId);
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PartnerMedical(), inId, inPartnerMedicalId);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Ambulance(), inId, inAmbulance);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_MedicSP(), inId, inMedicSP);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberSP(), inId, inInvNumberSP);
    -- ��������� <>
    IF inInvNumberSP <> ''
    THEN
          IF inOperDateSP > vbOperDate
             THEN
                 RAISE EXCEPTION '��������� ���� �������.';
          END IF;
       -- ��������� <>
       PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateSP(), inId, inOperDateSP);
    ELSE   
       -- ��������� <>
       PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateSP(), inId, NULL);
    END IF;

    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);
   
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 13.09.17         *
 23.05.17         * add inSPKindId
 26.04.17         * add inPartnerMedicalId
 21.04.17         *
*/

-- ����
-- SELECT * FROM gpUpdate_Movement_Check_SpParam (ioId := 0, inUnitId := 183293, inDate := NULL::TDateTime, inBayer := 'Test Bayer'::TVarChar, inSession:= zfCalc_UserAdmin());
