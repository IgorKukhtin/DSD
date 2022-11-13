-- Function: gpInsertUpdate_Movement_SendDebtMember()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendDebtMember (Integer, TVarChar, TDateTime, Integer, Integer, Tfloat
                                                              , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                              , TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_SendDebtMember(
 INOUT ioId                   Integer   , -- ���� ������� <��������>
    IN inInvNumber            TVarChar  , -- ����� ���������
    IN inOperDate             TDateTime , -- ���� ���������

 INOUT ioMasterId             Integer   , -- ���� ������� <������� ���������>
 INOUT ioChildId              Integer   , -- ���� ������� <������� ���������>

    IN inAmount               TFloat    , -- �����  
        
    IN inMemberFromId         Integer   , -- ���. ����
    IN inJuridicalBasisFromId Integer   , -- ��. ��.����
    IN inCarFromId            Integer   , -- ����
    IN inInfoMoneyFromId      Integer   , -- ������ ����������
    IN inBranchFromId         Integer   , -- 
    
    IN inMemberToId           Integer   , -- ���.����
    IN inJuridicalBasisToId   Integer   , -- ��. ��.����
    IN inCarToId              Integer   , -- ����
    IN inInfoMoneyToId        Integer   , -- ������ ����������
    IN inBranchToId           Integer   , -- 

    IN inComment              TVarChar  , -- ����������
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS Record AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;   
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_SendDebtMember());

     -- ��������
     IF (COALESCE (inMemberFromId, 0) = 0)
     THEN
         RAISE EXCEPTION '������. �� ����������� <���.���� ���� (������)>.';
     END IF;
     -- ��������
     IF (COALESCE (inInfoMoneyFromId, 0) = 0)
     THEN
         RAISE EXCEPTION '������. �� ����������� <�� ������ ���������� (������)>.';
     END IF;
     -- ��������
   /*IF (COALESCE (inCarFromId, 0) = 0)
     THEN
         RAISE EXCEPTION '������. �� ����������� <���� (������)>.';
     END IF;
     -- ��������
     IF (COALESCE (inJuridicalBasisFromId, 0) = 0)
     THEN
         RAISE EXCEPTION '������. �� ����������� <��.��.���� (������)>.';
     END IF;

     -- ��������
     IF (COALESCE (inMemberToId, 0) = 0)
     THEN
         RAISE EXCEPTION '������. �� ����������� <���.���� (�����)>.';
     END IF;
     -- ��������
     IF (COALESCE (inInfoMoneyToId, 0) = 0)
     THEN
         RAISE EXCEPTION '������. �� ����������� <�� ������ ���������� (�����)>.';
     END IF;
     -- ��������
     IF (COALESCE (inCarToId, 0) = 0)
     THEN
         RAISE EXCEPTION '������. �� ����������� <���� (�����)>.';
     END IF;
     -- ��������
     IF (COALESCE (inJuridicalBasisToId, 0) = 0)
     THEN
         RAISE EXCEPTION '������. �� ����������� <��.��.���� (�����)>.';
     END IF;*/


     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- 1. ����������� ��������
     IF ioId > 0 AND vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_SendDebtMember())
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := vbUserId);
     END IF;


     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_SendDebtMember(), inInvNumber, inOperDate, NULL);

     -- ��������� �������� <�����������>
     PERFORM lpInsertUpdate_MovementString(zc_MovementString_Comment(), ioId, inComment);
   
     -- ��������� <�������> - ������
     ioMasterId := lpInsertUpdate_MovementItem (ioMasterId, zc_MI_Master(), inMemberFromId, ioId, inAmount, NULL);

     -- ��������� ����� � <���� �� >
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Car(), ioMasterId, inCarFromId);

     -- ��������� ����� � <�� ��.���� ��>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_JuridicalBasis(), ioMasterId, inJuridicalBasisFromId);

     -- ��������� ����� � <������ ���������� ��>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioMasterId, inInfoMoneyFromId);

     -- ��������� ����� � <������ ��>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(), ioMasterId, inBranchFromId);


  


     -- ��������� <�������> - �����
     ioChildId := lpInsertUpdate_MovementItem (ioChildId, zc_MI_Child(), CASE WHEN inMemberToId > 0 THEN inMemberToId ELSE inMemberFromId END, ioId, inAmount, NULL);

     -- ��������� ����� � <���� ����>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Car(), ioChildId, inCarToId);

     -- ��������� ����� � <�� ��.���� ��>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_JuridicalBasis(), ioChildId, inJuridicalBasisToId);

     -- ��������� ����� � <������ ���������� ����>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioChildId, CASE WHEN inInfoMoneyToId > 0 THEN inInfoMoneyToId ELSE inInfoMoneyFromId END);

     -- ��������� ����� � <������ ����>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(), ioChildId, inBranchToId);

     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- 5.3. �������� ��������
     IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_Complete_SendDebtMember())
     THEN
          PERFORM lpComplete_Movement_SendDebtMember (inMovementId := ioId
                                                    , inUserId     := vbUserId);
     END IF;

     -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.10.22         *
 */

-- ����
-- 