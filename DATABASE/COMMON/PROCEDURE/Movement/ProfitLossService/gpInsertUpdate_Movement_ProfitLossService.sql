-- Function: gpInsertUpdate_Movement_ProfitLossService()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossService (Integer, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ProfitLossService(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProfitLossService());

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_ProfitLossService (ioId               := ioId
                                                      , inInvNumber        := inInvNumber
                                                      , inOperDate         := inOperDate
                                                      , inUserId           := vbUserId
                                                       );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.02.14                                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_ProfitLossService (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inSession:= '2');