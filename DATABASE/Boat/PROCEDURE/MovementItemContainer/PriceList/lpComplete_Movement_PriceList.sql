DROP FUNCTION IF EXISTS lpComplete_Movement_PriceList (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_PriceList(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)
RETURNS VOID
AS
$BODY$
BEGIN

    -- �������� - E��� �� �����
    IF COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Partner()), 0) = 0
    THEN
         RAISE EXCEPTION '������.�� ������ ���������.';
    END IF;

    -- 1. �������� Link_Partner + EKPrice
    PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Partner(), MovementItem.ObjectId, (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Partner()))
          , lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_EKPrice(), MovementItem.ObjectId, MovementItem.Amount)
    FROM MovementItem
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId     = zc_MI_Master()
      AND MovementItem.isErased   = FALSE;

    -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_PriceList()
                               , inUserId     := inUserId
                                );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.03.22         *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_PriceList (inMovementId:= 224, inUserId := zfCalc_UserAdmin() :: Integer)  order by ObjectId_parent;
