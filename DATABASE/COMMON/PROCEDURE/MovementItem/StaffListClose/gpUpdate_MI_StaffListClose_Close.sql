-- Function: gpUpdate_MI_StaffListClose_Close()

DROP FUNCTION IF EXISTS gpUpdate_MI_StaffListClose_Close (Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_StaffListClose_Close (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_StaffListClose_Close(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inUnitId              Integer   , -- �������������(����������)
    IN inAmount              TFloat    , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_StaffListClose());


     -- 1. ����  update
     IF inMovementId > 0 AND EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.StatusId <> zc_Enum_Status_UnComplete())
     THEN
         -- ����������� ��������
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId
                                       );
     END IF;

     -- ��������� <������� ���������>
     PERFORM lpInsertUpdate_MovementItem_StaffListClose (ioId         := 0
                                                       , inMovementId := inMovementId
                                                       , inUnitId     := inUnitId
                                                       , inAmount     := inAmount
                                                       , inUserId     := vbUserId
                                                        ) AS tmp;
     -- ����
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Closed(), inMovementId, CASE WHEN inAmount > 0 THEN TRUE ELSE FALSE END);
   
     -- �������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_StaffListClose()
                                , inUserId     := vbUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.09.25         *
*/

-- ����
--