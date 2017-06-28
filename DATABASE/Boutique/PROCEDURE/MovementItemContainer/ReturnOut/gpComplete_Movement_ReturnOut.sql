-- Function: gpComplete_Movement_ReturnOut()

DROP FUNCTION IF EXISTS gpComplete_Movement_ReturnOut  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ReturnOut(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);
  
     -- ��������� ��������� ������� - ��� ������������ ������ �� ���������
     PERFORM lpComplete_Movement_ReturnOut_CreateTemp();

     -- ��������
     PERFORM lpComplete_Movement_ReturnOut (inMovementId -- ��������
                                          , vbUserId     -- ������������  
                                           );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 25.04.17         *
 */
 
-- ����
-- SELECT * FROM gpComplete_Movement_Income (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
