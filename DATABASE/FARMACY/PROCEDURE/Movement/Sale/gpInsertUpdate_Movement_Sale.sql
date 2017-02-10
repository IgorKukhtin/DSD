-- Function: gpInsertUpdate_Movement_Sale()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Sale (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Sale (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TDateTime,  TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Sale (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Integer, TDateTime,  TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Sale(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inUnitId                Integer    , -- �� ���� (�������������)
    IN inJuridicalId           Integer    , -- ���� (����������)
    IN inPaidKindId            Integer    , -- ���� ���� ������
    IN inPartnerMedicalId      Integer    , -- ����������� ����������(���. ������)
    IN inGroupMemberSPId       Integer    , -- ��������� ��������(���. ������)
    IN inOperDateSP            TDateTime  , -- ���� ������� (���. ������)
    IN inInvNumberSP           TVarChar   , -- ����� ������� (���. ������)
    IN inMedicSP               TVarChar   , -- ��� ����� (���. ������)
    IN inMemberSP              TVarChar   , -- ��� �������� (���. ������)
    IN inComment               TVarChar   , -- ����������
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());
    vbUserId := inSession;
    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement_Sale (ioId          := ioId
                                        , inInvNumber   := inInvNumber
                                        , inOperDate    := inOperDate
                                        , inUnitId      := inUnitId
                                        , inJuridicalId := inJuridicalId
                                        , inPaidKindId  := inPaidKindId
                                        , inPartnerMedicalId:= inPartnerMedicalId
                                        , inGroupMemberSPId := inGroupMemberSPId
                                        , inOperDateSP      := inOperDateSP
                                        , inInvNumberSP     := inInvNumberSP
                                        , inMedicSP         := inMedicSP
                                        , inMemberSP        := inMemberSP
                                        , inComment         := inComment
                                        , inUserId          := vbUserId
                                        );

   IF COALESCE (inPartnerMedicalId,0) <> 0 OR
      --COALESCE (inOperDateSP,Null) <> Null OR
      COALESCE (inInvNumberSP,'') <> '' OR
      COALESCE (inMedicSP,'') <> '' OR
      COALESCE (inMemberSP,'') <> '' THEN

     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_SP(), MovementItem.Id, True)
     FROM MovementItem
     WHERE MovementItem.MovementId = ioId
       AND MovementItem.DescId = zc_MI_Master();
   END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.  ��������� �.�.
 08.02.17         *
 13.10.15                                                                    *
*/