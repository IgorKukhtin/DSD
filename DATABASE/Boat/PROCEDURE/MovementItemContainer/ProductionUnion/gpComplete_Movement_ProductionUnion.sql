-- Function: gpComplete_Movement_ProductionUnion()

DROP FUNCTION IF EXISTS gpComplete_Movement_ProductionUnion  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ProductionUnion(
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
     PERFORM lpComplete_Movement_ProductionUnion_CreateTemp();

     -- ��������
     PERFORM lpComplete_Movement_ProductionUnion (inMovementId -- ��������
                                                , vbUserId     -- ������������  
                                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.02.21         *
 */