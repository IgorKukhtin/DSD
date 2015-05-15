-- Function: gpInsertUpdate_Movement_Check()

DROP FUNCTION IF EXISTS gpInsert_Movement_Check (TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Check(
   OUT Id                  Integer   , -- ���� ������� <�������� ���>
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbInvNumber Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderInternal());
     vbUserId := inSession;

     vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
     IF vbUnitKey = '' THEN
        vbUnitKey := '0';
     END IF;   
     vbUnitId := vbUnitKey::Integer;

     IF COALESCE(vbUnitId, 0) = 0 THEN
        RAISE EXCEPTION '��� ������������ �� ����������� �������� ��������� �������������';
     END IF;

     -- 0.
     SELECT COALESCE(MAX(zfConvert_StringToNumber(InvNumber)), 0) + 1 INTO vbInvNumber
       FROM Movement_Check_View 
      WHERE Movement_Check_View.UnitId = vbUnitId AND Movement_Check_View.OperDate > CURRENT_DATE;

     -- ��������� <��������>
     Id := lpInsertUpdate_Movement (Id, zc_Movement_Check(), vbInvNumber::TVarChar, CURRENT_TIMESTAMP, NULL);

     -- ��������� ����� � <��������������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), Id, vbUnitId);

     -- ��������� ��������
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 08.05.15                         * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_OrderInternal (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
