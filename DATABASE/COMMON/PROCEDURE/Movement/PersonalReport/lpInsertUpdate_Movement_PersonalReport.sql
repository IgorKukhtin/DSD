-- Function: gpInsertUpdate_Movement_PersonalReport()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_PersonalReport (integer, tvarchar, TDateTime, tfloat, tvarchar, integer, integer, integer, integer, integer, integer, integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_PersonalReport(
 INOUT ioId                       Integer   , -- ���� ������� <��������>
    IN inInvNumber                TVarChar  , -- ����� ���������
    IN inOperDate                 TDateTime , -- ���� ���������
    IN inAmount                   TFloat    , -- ����� ��������
    IN inComment                  TVarChar  , -- ����������
    IN inMemberId                 Integer   ,
    IN inInfoMoneyId              Integer   , -- ������ ����������
    IN inContractId               Integer   , -- ��������
    IN inUnitId                   Integer   ,
    IN inMoneyPlaceId             Integer   ,
    IN inCarId                    Integer   ,
    IN inUserId                   Integer    -- ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_PersonalReport(), inInvNumber, inOperDate, NULL);

     -- ���������� <������� ���������>
     SELECT MovementItem.Id INTO vbMovementItemId FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master();

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;

     -- ��������� <������� ���������>
     vbMovementItemId := lpInsertUpdate_MovementItem (vbMovementItemId, zc_MI_Master(), inMemberId, ioId, inAmount, NULL);

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
     PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, inUserId, vbIsInsert);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.05.21         *
*/

-- ����
--