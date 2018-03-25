-- Function: gpComplete_Movement_Sale()

DROP FUNCTION IF EXISTS gpComplete_Movement_Sale_User (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Sale_User(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Sale());
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!������ ������ ��� �������������!!! - ���� ���. ������ ��������������� ���� ����������
     UPDATE Movement SET OperDate = CURRENT_DATE WHERE Movement.Id = inMovementId;
     -- ��������� �������� <���� ��������> - �� ���� ����������
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), inMovementId, CURRENT_TIMESTAMP);
     -- ��������� �������� <������������ (��������)> - �� ������������ ����������
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), inMovementId, vbUserId);


     -- ��������� ��������� ������� - ��� ������������ ������ �� ���������
     PERFORM lpComplete_Movement_Sale_CreateTemp();

     -- ���������� ��������
     PERFORM lpComplete_Movement_Sale (inMovementId  -- ��������
                                     , vbUserId);    -- ������������

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 26.02.18         *
 */

-- ����
-- SELECT * FROM gpComplete_Movement_Sale (inMovementId:= 1100, inSession:= zfCalc_UserAdmin())
