-- Function: gpUpdate_Scale_Movement_Status()

DROP FUNCTION IF EXISTS gpUpdate_Scale_Movement_Status (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Scale_Movement_Status(
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inSession               TVarChar    -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Scale_MI_Erased());
     vbUserId:= lpGetUserBySession (inSession);



     -- ��������
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�������� �������������� ��� �� �����������.%���������� ������� ������� �����������.', CHR (13);
     END IF;

     -- ��������
     IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
         RAISE EXCEPTION '������.�������� � <%> �� <%> ��� � ������� <%>.'
                       , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                       , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = inMovementId)
                       , (SELECT lfGet_Object_ValueData_sh (Movement.StatusId) FROM Movement WHERE Movement.Id = inMovementId)
                        ;
     END IF;

     -- ��������
     IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.StatusId <> zc_Enum_Status_UnComplete())
     THEN
         RAISE EXCEPTION '������.�������� � <%> �� <%> � ������� <%>.'
                       , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                       , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = inMovementId)
                       , (SELECT lfGet_Object_ValueData_sh (Movement.StatusId) FROM Movement WHERE Movement.Id = inMovementId)
                        ;
     END IF;

     -- ��������
     IF NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_Inventory())
     THEN
         RAISE EXCEPTION '������.��� ���� ��������� �������� <%>%� <%> �� <%> .'
                       , (SELECT MovementDesc.ItemName FROM Movement JOIN MovementDesc ON MovementDesc.Id = Movement.DescId WHERE Movement.Id = inMovementId)
                       , CHR (13)
                       , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                       , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = inMovementId)
                        ;
     END IF;
     

     IF vbUserId NOT IN (2414368 -- ;2405;"��������� �.�."
                       , 2118489 -- ;2382;"������� �.�."
                       , 2687823 -- ;2434;"������ �.�."
                       , 6527404 -- ;2785;"����� �.�."
                       , 300539 -- ;1040;"������� �.�."
                       , 8098596 -- ;2897;"��������� �.�."
                       , 4103954 -- ;2558;"������������ �.�."
                        )
     THEN
         RAISE EXCEPTION '������.��� ���� ��������� �������� <%>%� <%> �� <%> .'
                       , (SELECT MovementDesc.ItemName FROM Movement JOIN MovementDesc ON MovementDesc.Id = Movement.DescId WHERE Movement.Id = inMovementId)
                       , CHR (13)
                       , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                       , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = inMovementId)
                        ;
     END IF;

     -- �������� ��������
     PERFORM gpComplete_Movement_Inventory (inMovementId     := inMovementId
                                          , inIsLastComplete := NULL
                                          , inSession        := inSession);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.10.23                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Scale_Movement_Status (inMovementId:= 0, inSession:= '5')
