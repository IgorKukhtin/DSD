-- Function: lpUpdate_MovementItem_Cash_Personal_TotalSumm()

DROP FUNCTION IF EXISTS lpUpdate_MovementItem_Cash_Personal_TotalSumm (Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_MovementItem_Cash_Personal_TotalSumm(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inUserId              Integer     -- ������������
)
RETURNS VOID
AS
$BODY$
BEGIN

     -- � ������� ������ �������� �����
     PERFORM lpInsertUpdate_MovementItem (MovementItem.Id, MovementItem.DescId, MovementItem.ObjectId, MovementItem.MovementId
                                        , -1 * COALESCE ((SELECT SUM (COALESCE (MovementItem.Amount, 0)) AS Amount
                                                          FROM MovementItem
                                                          WHERE MovementItem.MovementId = inMovementId
                                                            AND MovementItem.DescId = zc_MI_Child()
                                                            AND MovementItem.isErased = FALSE
                                                         ), 0)
                                        , MovementItem.ParentId
                                         )
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId = zc_MI_Master();

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.04.15                                        *
*/

-- ����
-- SELECT * FROM lpUpdate_MovementItem_Cash_Personal_TotalSumm (inMovementId:= 10, inUserId:= zfCalc_UserAdmin() :: Integer)
