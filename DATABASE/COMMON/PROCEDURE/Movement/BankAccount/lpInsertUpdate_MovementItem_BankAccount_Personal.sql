-- Function: lpInsertUpdate_MovementItem_BankAccount_Personal()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_BankAccount_Personal (Integer, Integer, Integer, TFloat, TDateTime, TVarChar, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_BankAccount_Personal (Integer, Integer, Integer, TFloat, TDateTime, TVarChar, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_BankAccount_Personal(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inPersonalId            Integer   , -- ����������
    IN inAmount                TFloat    , -- ����� � �������
    IN inServiceDate           TDateTime , -- ����� ����������
    IN inComment               TVarChar  , -- ����������
    IN inInfoMoneyId           Integer   , -- ������ ����������
    IN inUnitId                Integer   , -- �������������
    IN inPositionId            Integer   , -- ���������
    IN inPersonalServiceListId Integer   , -- ��������� ����������
    IN inUserId                Integer     -- ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ��������
     IF COALESCE (inPersonalId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ��������� �������� <��� (���������)>.';
     END IF;
     -- ��������
     IF COALESCE (inInfoMoneyId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ��������� �������� <�� ������>.';
     END IF;
     -- ��������
     IF COALESCE (inUnitId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ��������� �������� <�������������>.';
     END IF;
     -- ��������
     IF COALESCE (inPositionId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ��������� �������� <���������>.';
     END IF;
     -- ��������
     IF COALESCE (inPersonalServiceListId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ��������� �������� <��������� ����������>.';
     END IF;


     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId:= lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inPersonalId, inMovementId, inAmount, NULL);

     -- ����������� �������� <����� ����������>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ServiceDate(), ioId, inServiceDate);

     -- ��������� �������� <����������>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioId, inInfoMoneyId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Position(), ioId, inPositionId);
     -- ��������� ����� � <��������� ����������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PersonalServiceList(), ioId, inPersonalServiceListId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 06.04.15                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItem_BankAccount_Personal (ioId:= 0, inMovementId:= 10, inPersonalId:= 1, inAmount:=1, inUserId:= zfCalc_UserAdmin() :: Integer)
