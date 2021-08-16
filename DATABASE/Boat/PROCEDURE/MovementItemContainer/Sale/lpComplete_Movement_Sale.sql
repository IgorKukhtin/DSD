DROP FUNCTION IF EXISTS lpComplete_Movement_Sale (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Sale(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)
RETURNS VOID
AS
$BODY$
BEGIN

 

    -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_Sale()
                               , inUserId     := inUserId
                                );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.08.21         *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_Sale (inMovementId:= 224, inUserId := zfCalc_UserAdmin() :: Integer)  order by ObjectId_parent;
