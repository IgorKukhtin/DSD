-- Function: lpComplete_Movement_RelatedProduct (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_RelatedProduct (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_RelatedProduct(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)                              
RETURNS VOID
AS
$BODY$

BEGIN

    -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_RelatedProduct()
                               , inUserId     := inUserId
                                );
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 13.10.20                                                       *
*/