-- Function: gpUpdate_Movement_WeighingPartner()

DROP FUNCTION IF EXISTS gpUpdate_Movement_WeighingPartner (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_WeighingPartner(
    IN inId                   Integer   , -- ���� ������� <��������>
    IN inWeighingNumber       Integer   , -- ����� �����������
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
  
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_WeighingPartner());
     vbUserId:= lpGetUserBySession (inSession);

     -- ��������� �������� <����� �����������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_WeighingNumber(), inId, inWeighingNumber);

    
     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 05.10.15         *
*/

-- select lpInsertUpdate_MovementFloat (zc_MovementFloat_WeighingNumber(), 2005096 , 8);

-- SELECT * FROM gpUpdate_Movement_WeighingPartner (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', , inSession:= '2')
