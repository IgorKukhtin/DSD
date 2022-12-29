-- Function: gpUpdate_Movement_IncomeFuel_ChangePriceUser()

DROP FUNCTION IF EXISTS gpUpdate_Movement_IncomeFuel_ChangePriceUser (Integer, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_IncomeFuel_ChangePriceUser(
    IN inId                  Integer   , -- ���� ������� <��������>
    IN inChangePrice         TFloat    , -- ������ � ����
    IN inIsChangePriceUser   Boolean   , -- ������ ������ � ���� (��/���)
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     IF EXISTS (SELECT 1  FROM  MovementLinkObject AS MLO WHERE MLO.MovementId = inId AND MLO.DescId = zc_MovementLinkObject_PaidKind() AND MLO.ObjectId = zc_Enum_PaidKind_SecondForm())
     THEN vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_IncomeFuel_ChangePriceUserSF());
     ELSE vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_IncomeFuel_ChangePriceUser());
     END IF;

     -- ������� ������ ���������
     vbStatusId := (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inId);
     
     IF vbStatusId = zc_Enum_Status_Complete()
     THEN
         --����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId := inId
                                      , inUserId     := vbUserId);
     END IF;

     -- ��������� �������� <������ ������ � ���� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_ChangePriceUser(), inId, inIsChangePriceUser);
     
     -- ��������� �������� <������ � ����>
     PERFORM lpInsertUpdate_MovemenTFloat (zc_MovemenTFloat_ChangePrice(), inId, inChangePrice);


     -- 5.3. �������� ��������
     IF vbStatusId = zc_Enum_Status_Complete()
     THEN
          -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
          PERFORM lpComplete_Movement_Income_CreateTemp();
          -- �������� ��������
          PERFORM lpComplete_Movement_Income (inMovementId     := inId
                                            , inUserId         := vbUserId
                                            , inIsLastComplete := TRUE
                                             );
     ELSE
          PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);
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