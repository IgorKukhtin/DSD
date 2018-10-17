-- Function: lpComplete_Movement_Promo (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_Promo (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Promo(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)
RETURNS VOID
AS
$BODY$

BEGIN

  /*
     16.10.18 ����� � ��������� �������: gpUpdate_MovementItemContainer_Promo

    -- 1. �����������
    PERFORM lpReComplete_Movement_Promo_All (inMovementId := inMovementId
                                           , inUserId     := inUserId
                                            );
  */

    -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_Promo()
                               , inUserId     := inUserId
                                );

    -- ��������� <������ ���� ��������� ObjectIntId_analyzer>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Promo_Prescribe(), inMovementId, TRUE);

    -- ����������� ����� �� ��������� (��� ����� �������, ������� ��������� ����� ���������� ���������)
    PERFORM lpInsertUpdate_MovementFloat_TotalSumm(inMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.  ������ �.�.
 16.10.18                                                                       *
 25.04.16         *
*/