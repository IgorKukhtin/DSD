-- Function: gpComplete_Movement_PriceList()

DROP FUNCTION IF EXISTS gpComplete_Movement_PriceList  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_PriceList(
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

    -- ���������� ��������
    PERFORM lpComplete_Movement_PriceList (inMovementId   -- ���� ���������
                                         , vbUserId       -- ������������  
                                          );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.03.22         *
 */