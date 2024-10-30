-- Function: gpInsertUpdate_MI_BankAccount_Detail()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_BankAccount_Detail (Integer, Integer, Integer, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_BankAccount_Detail(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inInfoMoneyId         Integer   , -- 
    IN inAmount              TFloat    , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_BankAccount());


     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Detail(), inInfoMoneyId, inMovementId, inAmount, NULL);


     -- ����������� �������� ����� �� ���������
     --PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� �������� !!!����� ���������!!!
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.10.24         *
*/

-- ����
-- 