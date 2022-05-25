-- Function: gpUpdate_Movement_Cash_Child()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Cash_Child (Integer, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Cash_Child(
    IN inMI_Id                Integer   , -- ������������� ������
    IN inServiceDate          TDateTime , -- ���� ����������
    IN inUnitId               Integer   , -- �����
    IN inInfoMoneyId          Integer   , -- ������
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbMovementItemId Integer;
BEGIN

     -- ��������
     IF COALESCE (inInfoMoneyId, 0) = 0
     THEN
        RAISE EXCEPTION '������.<������> �� �������.';
     END IF;

     -- ������ - 1-�� ����� ������
     inServiceDate:= DATE_TRUNC ('MONTH', inServiceDate);
     /*
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), inMI_Id, inUnitId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), inMI_Id, inInfoMoneyId);

     -- ��������� �������� <���� ����������>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ServiceDate(), inMI_Id, inServiceDate);

 
     -- ��������� �������� <���� �������������>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), inMI_Id, CURRENT_TIMESTAMP);
     -- ��������� �������� <������������ (�������������)>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), inMI_Id, inUserId);
    
     
     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (inMI_Id, inUserId, vbIsInsert);
    */
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.05.22         *
 */

-- ����
--