-- Function: gpInsertUpdate_Movement_Send()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SendVIP (Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_SendVIP(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inisUrgently          Boolean   , -- ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbUserUnitId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Send());
     vbUserId := inSession;


     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_Send (ioId               := ioId
                                         , inInvNumber        := CAST (NEXTVAL ('Movement_Send_seq') AS TVarChar)
                                         , inOperDate         := CURRENT_DATE
                                         , inFromId           := inFromId
                                         , inToId             := inToId
                                         , inComment          := ''
                                         , inChecked          := False
                                         , inisComplete       := False
                                         , inNumberSeats      := 0
                                         , inDriverSunId      := 0
                                         , inUserId           := vbUserId
                                          );

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_VIP(), ioId, True);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Urgently(), ioId, inisUrgently);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.05.20                                                       *  
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_SendVIP (ioId:= 0, inFromId:= 1, inToId:= 2, inisUrgently := False; inSession:= '2')
