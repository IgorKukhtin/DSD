-- Function: lpInsertUpdate_MovementItem_PersonalTransport()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalTransport (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PersonalTransport(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inPersonalId            Integer   , -- ����������   
    IN inInfoMoneyId           Integer   , -- ������ ����������
    IN inUnitId                Integer   , -- �������������
    IN inPositionId            Integer   , -- ���������
    IN inAmount                TFloat    , -- 
    IN inComment               TVarChar  , -- 
    IN inUserId                Integer     -- ������������
)                               
RETURNS Integer AS               
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ��������
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�������� �� ��������.';
     END IF;
     -- ��������
     IF COALESCE (inPersonalId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ��������� �������� <��� (���������)> ��� ����� ��������� = <%>.', zfConvert_FloatToString (inAmount);
     END IF;
     -- ��������
     IF COALESCE (inInfoMoneyId, 0) = 0
     THEN
         IF inAmount = 0 THEN RETURN; END IF;
         RAISE EXCEPTION '������.�� ��������� �������� <�� ������> ��� ����� ��������� = <%>.', zfConvert_FloatToString (inAmount);
     END IF;
     -- ��������
     IF COALESCE (inUnitId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ��������� �������� <�������������> ��� ����� ��������� = <%>.', zfConvert_FloatToString (inAmount);
     END IF;
     -- ��������
     IF COALESCE (inPositionId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ��������� �������� <���������> ��� ����� ��������� = <%>.', zfConvert_FloatToString (inAmount);
     END IF;


     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inPersonalId, inMovementId, inAmount, NULL);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioId, inInfoMoneyId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Position(), ioId, inPositionId);
     
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);


     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

      -- ��������� ��������
      PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.08.22         *
*/

-- ����
-- 