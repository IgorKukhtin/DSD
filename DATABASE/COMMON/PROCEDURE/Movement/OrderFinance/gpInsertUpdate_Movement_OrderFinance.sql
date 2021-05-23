-- Function: gpInsertUpdate_Movement_OrderFinance()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderFinance (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderFinance (Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderFinance(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inOrderFinanceId      Integer   , --
    IN inBankAccountId       Integer   , --
    IN inComment             TVarChar   , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderFinance());


     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_OrderFinance (ioId               := ioId
                                                 , inInvNumber        := inInvNumber
                                                 , inOperDate         := inOperDate
                                                 , inOrderFinanceId   := inOrderFinanceId
                                                 , inBankAccountId    := inBankAccountId
                                                 , inComment          := inComment
                                                 , inUserId           := vbUserId
                                                  );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.07.19         *
*/

-- ����
--