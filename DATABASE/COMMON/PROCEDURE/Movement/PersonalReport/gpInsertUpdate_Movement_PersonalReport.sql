-- Function: gpInsertUpdate_Movement_PersonalReport()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PersonalReport (integer, tvarchar, TDateTime, tfloat, tfloat, tvarchar, integer, integer, integer, integer, integer, tvarchar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PersonalReport (integer, tvarchar, TDateTime, tfloat, tfloat, tvarchar, integer, integer, integer, integer, integer, integer, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PersonalReport (integer, tvarchar, TDateTime, tfloat, tfloat, tvarchar, integer, integer, integer, integer, integer, integer, integer, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PersonalReport(
 INOUT ioId                       Integer   , -- ���� ������� <��������>
    IN inInvNumber                TVarChar  , -- ����� ���������
    IN inOperDate                 TDateTime , -- ���� ���������
    IN inAmountIn                 TFloat    , -- ����� ��������
    IN inAmountOut                TFloat    , -- ����� ��������
    IN inComment                  TVarChar  , -- ����������
    IN inMemberId                 Integer   ,
    IN inInfoMoneyId              Integer   , -- ������ ����������
    IN inContractId               Integer   , -- ��������
    IN inUnitId                   Integer   ,
    IN inMoneyPlaceId             Integer   ,
    IN inCarId                    Integer   ,
    IN inMovementId_Invoice       Integer   , -- �������� ����
    IN inSession                  TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PersonalReport());
     -- ���������� ���� �������
--     vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_PersonalReport());


     -- ��������
     PERFORM lpCheck_Movement_PersonalReport (inMovementId:= -1 * (SELECT Object.DescId FROM Object WHERE Object.Id = inMoneyPlaceId), inComment:= CASE WHEN ioId > 0 THEN '�������' ELSE '��������' END, inUserId:= vbUserId);

     -- ��������
     IF ioId > 0 THEN PERFORM lpCheck_Movement_PersonalReport (inMovementId:= ioId, inComment:= '�������', inUserId:= vbUserId); END IF;


     -- ��������
     IF (COALESCE(inAmountIn, 0) = 0) AND (COALESCE(inAmountOut, 0) = 0) THEN
        RAISE EXCEPTION '������� �����.';
     END IF;

     -- ��������
     IF (COALESCE(inAmountIn, 0) <> 0) AND (COALESCE(inAmountOut, 0) <> 0) THEN
        RAISE EXCEPTION '������ ���� ������� ������ ���� �����: <�����> ��� <������>.';
     END IF;

     -- ������
     IF inAmountIn <> 0 THEN
        vbAmount := inAmountIn;
     ELSE
        vbAmount := -1 * inAmountOut;
     END IF;

     -- 1. ����������� ��������
     IF ioId > 0 AND vbUserId = lpCheckRight (inSession, zc_Enum_Process_UnComplete_PersonalReport())
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := vbUserId);
     END IF;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_PersonalReport(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

     -- ��������� ����� � ���������� <����>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Invoice(), ioId, inMovementId_Invoice);
     
     -- ���������� <������� ���������>
     SELECT MovementItem.Id INTO vbMovementItemId FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master();

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;

     -- ��������� <������� ���������>
     vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), inMemberId, ioId, vbAmount, NULL);

     -- ��������� �������� <����������>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), vbMovementItemId, inComment);
     -- ��������� ����� � <�������������� ������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), vbMovementItemId, inInfoMoneyId);
     -- ��������� ����� � <���������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), vbMovementItemId, inContractId);
     -- ��������� ����� � <��������������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), vbMovementItemId, inUnitId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_MoneyPlace(), vbMovementItemId, inMoneyPlaceId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Car(), vbMovementItemId, inCarId);


     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, vbUserId, vbIsInsert);

     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- 5.3. �������� ��������
     IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_Complete_PersonalReport())
     THEN
          PERFORM lpComplete_Movement_PersonalReport (inMovementId := ioId
                                                    , inUserId     := vbUserId);
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.03.22         * inMovementId_Invoice
 07,05,15         * add contract
 12.11.14                                        * add lpComplete_Movement_Finance_CreateTemp
 15.09.14                                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_PersonalReport (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inAmount:= 20, inJuridicalId:= 1, inJuridicalBasisId:= 1, inBusinessId:= 2, inPaidKindId:= 1,  inInfoMoneyId:= 0, inUnitId:= 0, inSession:= '2')
