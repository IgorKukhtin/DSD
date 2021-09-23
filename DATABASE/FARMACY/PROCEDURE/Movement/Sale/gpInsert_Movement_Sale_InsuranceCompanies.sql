-- Function: gpInsert_Movement_Sale_InsuranceCompanies()

DROP FUNCTION IF EXISTS gpInsert_Movement_Sale_InsuranceCompanies (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Sale_InsuranceCompanies(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInsuranceCompaniesId  Integer    , -- ��������� ��������
    IN inMemberICId            Integer    , -- ��� ���������� (��������� ��������)
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());
    vbUserId := inSession;
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;
    
    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement_Sale (ioId          := ioId
                                        , inInvNumber   := CAST (NEXTVAL ('movement_sale_seq') AS TVarChar)
                                        , inOperDate    := CURRENT_DATE
                                        , inUnitId      := vbUnitId
                                        , inJuridicalId := 0
                                        , inPaidKindId  := zc_Enum_PaidKind_FirstForm()
                                        , inPartnerMedicalId:= 0
                                        , inGroupMemberSPId := 0
                                        , inOperDateSP      := Null
                                        , inInvNumberSP     := Null
                                        , inMedicSP         := Null
                                        , inMemberSP        := Null
                                        , inComment         := Null
                                        , inisNP            := False
                                        , inInsuranceCompaniesId := inInsuranceCompaniesId
                                        , inMemberICId           := inMemberICId
                                        , inUserId          := vbUserId
                                        );

    -- ��������� ����� � <��� ���.�������>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SPKind(), ioId, zc_Enum_SPKind_InsuranceCompanies());

   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 23.03.21                                                       *
*/