-- Function: gpComplete_Movement_Sale()

DROP FUNCTION IF EXISTS gpComplete_Movement_Sale  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Sale(
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
     PERFORM lpComplete_Movement_Sale_CreateTemp();

     -- ���������� ��������
     PERFORM lpComplete_Movement_Sale (inMovementId, -- ���� ���������
                                       vbUserId      -- ������������  
                                      );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.08.21         *
 */