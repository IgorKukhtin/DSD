-- Function: gpInsertUpdate_Movement_ChoiceCell()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ChoiceCell (Integer, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ChoiceCell(
 INOUT ioId                  Integer   , -- ���� ������� <�������� ������� ����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ����(�����)
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ChoiceCell());

     --vbUserId:=:= (CASE WHEN vbUserId = 5 THEN 140094 ELSE vbUserId);

     -- ��������� <��������>
     ioId:= lpInsertUpdate_Movement_ChoiceCell
                                       (ioId               := ioId
                                      , inInvNumber        := inInvNumber
                                      , inOperDate         := inOperDate
                                      , inPersonalTradeId  := inPersonalTradeId
                                      , inUserId           := vbUserId
                                       )AS tmp;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 24.08.24         *
*/

-- ����
--