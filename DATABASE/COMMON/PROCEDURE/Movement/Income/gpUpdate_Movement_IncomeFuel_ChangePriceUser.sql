-- Function: gpUpdate_Movement_IncomeFuel_ChangePriceUser()

DROP FUNCTION IF EXISTS gpUpdate_Movement_IncomeFuel_ChangePriceUser(Integer, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_IncomeFuel_ChangePriceUser(
    IN inId                  Integer   , -- ���� ������� <��������>
    IN inChangePrice         TFloat    , -- ������ � ����
    IN inisChangePriceUser   Boolean   , -- ������ ������ � ���� (��/���)
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbStatusId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_IncomeFuel_ChangePriceUser());
     -- ���������� ���� �������
     vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_Update_Movement_IncomeFuel_ChangePriceUser());

     --������� ������ ���������
     vbStatusId := (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inId);
     
     IF vbStatusId = zc_Enum_Status_Complete()
     THEN
         --����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := vbUserId);
     END IF;

     -- ��������� �������� <������ ������ � ���� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_ChangePriceUser(), inId, inisChangePriceUser);
     
     -- ��������� �������� <������ � ����>
     PERFORM lpInsertUpdate_MovemenTFloat (zc_MovemenTFloat_ChangePrice(), inId, inChangePrice);


     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);


     -- 5.3. �������� ��������
     IF vbStatusId = zc_Enum_Status_Complete()
     THEN
          --
          PERFORM gpComplete_Movement_Income (inMovementId, FALSE, inSession);
     END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.11.22         *
*/

-- ����
--