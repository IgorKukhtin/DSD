-- Function: gpComplete_Movement_Send()

DROP FUNCTION IF EXISTS gpComplete_Movement_Send  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Send(
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
     PERFORM lpComplete_Movement_Send_CreateTemp();

     -- ��������
     PERFORM lpComplete_Movement_Send (inMovementId -- ��������
                                     , vbUserId     -- ������������  
                                      );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 28.06.17                                        *
 25.04.17         *
 */
  
-- ����
-- SELECT * FROM gpComplete_Movement_Send (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
