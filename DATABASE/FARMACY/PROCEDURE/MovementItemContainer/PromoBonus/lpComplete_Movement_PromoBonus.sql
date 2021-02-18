 -- Function: lpComplete_Movement_PromoBonus (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_PromoBonus (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_PromoBonus(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)
RETURNS VOID
AS
$BODY$
BEGIN

    -- �������� - ������� ������
    IF NOT EXISTS (SELECT 1
                   FROM MovementItem
                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.isErased = FALSE
                     AND MovementItem.Amount > 0
                     AND MovementItem.DescId = zc_MI_Master())
    THEN
        RAISE EXCEPTION 'Error. ��� ������ ��� ����������.';
    END IF;


    -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_PromoBonus()
                               , inUserId     := inUserId
                                );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.02.21                                                       *
*/

-- ����
-- select * from gpUpdate_Status_PromoBonus(inMovementId := 19386934 , inStatusCode := 2 ,  inSession := '3');

