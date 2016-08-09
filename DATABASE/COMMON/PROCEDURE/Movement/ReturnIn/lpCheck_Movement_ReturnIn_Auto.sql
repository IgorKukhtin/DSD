-- Function: lpCheck_Movement_ReturnIn_Auto()

DROP FUNCTION IF EXISTS lpCheck_Movement_ReturnIn_Auto (Integer, Integer);

CREATE OR REPLACE FUNCTION lpCheck_Movement_ReturnIn_Auto(
    IN inMovementId          Integer   , -- ���� ���������
   OUT outMessageText        Text      ,
    IN inUserId              Integer     -- ������������
)
RETURNS Text
AS
$BODY$
   DECLARE vbMovementDescId Integer;
BEGIN

     -- !!!��� ���� ����������� - �����!!! + zc_Enum_Process_Auto_PrimeCost
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View
                WHERE UserId = inUserId
                  AND RoleId IN (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Role() AND Object.ObjectCode IN (3004, 4004, 5004, 6004, 7004, 8004, 8014, 9042))
               )
        OR inUserId IN (zc_Enum_Process_Auto_PrimeCost())
     THEN
         outMessageText:= '-1';
         RETURN;
     END IF;

     -- !!!��� ��� - ��������� � �����!!!
     IF zc_Enum_PaidKind_SecondForm() = (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId IN (zc_MovementLinkObject_PaidKind(), zc_MovementLinkObject_PaidKindFrom()))
     THEN
         -- !!!��������� � �����!!!
         PERFORM lpInsertUpdate_MovementItem_ReturnIn_Child (ioId                  := MovementItem.Id
                                                           , inMovementId          := inMovementId
                                                           , inParentId            := MovementItem.ParentId
                                                           , inGoodsId             := MovementItem.ObjectId
                                                           , inAmount              := 0
                                                           , inMovementId_sale     := 0
                                                           , inMovementItemId_sale := 0
                                                           , inUserId              := inUserId
                                                           , inIsRightsAll         := FALSE
                                                            )
         FROM MovementItem
         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId     = zc_MI_Child()
        ;
         -- �����
         RETURN;
     END IF;


     -- ��������
     vbMovementDescId:= (SELECT Movement.DescId FROM Movement WHERE Movement.Id = inMovementId);

     -- !!!��������, ������ ��� �����!!!
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpItem'))
     THEN
         -- �������
         CREATE TEMP TABLE _tmpItem (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, OperCount TFloat, OperCount_Partner TFloat, Price_original TFloat)  ON COMMIT DROP;
         -- ������
         INSERT INTO _tmpItem (MovementItemId, GoodsId, GoodsKindId, OperCount, OperCount_Partner, Price_original)
                 SELECT MI.Id AS MovementItemId, MI.ObjectId AS GoodsId, COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                      , CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN 0 ELSE MI.Amount END AS OperCount
                      , CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN MIF_AmountPartner.ValueData ELSE 0 END AS OperCount_Partner
                      , COALESCE (MIF_Price.ValueData, 0)         AS Price_original
                 FROM MovementItem AS MI
                      LEFT JOIN Movement ON Movement.Id = MI.MovementId
                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind ON MILinkObject_GoodsKind.MovementItemId = MI.Id AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                      LEFT JOIN MovementItemFloat AS MIF_AmountPartner ON MIF_AmountPartner.MovementItemId = MI.Id AND MIF_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                      LEFT JOIN MovementItemFloat AS MIF_Price ON MIF_Price.MovementItemId = MI.Id AND MIF_Price.DescId = zc_MIFloat_Price()
                 WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE
                   AND (CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN 0 ELSE MI.Amount END <> 0
                     OR CASE WHEN Movement.DescId = zc_Movement_ReturnIn() THEN MIF_AmountPartner.ValueData ELSE 0 END <> 0
                       );
     /*ELSE 
         DELETE FROM _tmpItem;
         INSERT INTO _tmpItem (MovementItemId, GoodsId, GoodsKindId, OperCount_Partner, Price_original) SELECT MI.Id AS MovementItemId, MI.ObjectId AS GoodsId, COALESCE (MILO.ObjectId, 0) AS GoodsKindId, MIF1.ValueData AS OperCount_Partner, MIF.ValueData AS Price_original FROM MovementItem AS MI LEFT JOIN MovementItemLinkObject AS MILO ON MILO.MovementItemId = MI.Id AND MILO.DescId = zc_MILinkObject_GoodsKind() LEFT JOIN MovementItemFloat AS MIF1 ON MIF1.MovementItemId = MI.Id AND MIF1.DescId = zc_MIFloat_AmountPartner() LEFT JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = MI.Id AND MIF.DescId = zc_MIFloat_Price() WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE;
     */
     END IF;
     -- !!!��������, ������ ��� �����!!!


     -- !!!������� ������, ���� ����!!!
     outMessageText:= (WITH tmpChild_all AS (SELECT MovementItem.ParentId, MovementItem.ObjectId AS GoodsId, SUM (MovementItem.Amount) AS Amount
                                             FROM MovementItem
                                             WHERE MovementItem.MovementId = inMovementId
                                               AND MovementItem.DescId     = zc_MI_Child()
                                               AND MovementItem.isErased   = FALSE
                                             GROUP BY MovementItem.ParentId, MovementItem.ObjectId
                                         )
                          , tmpChild AS (SELECT COALESCE (_tmpItem.MovementItemId, 0)             AS ParentId
                                              , COALESCE (_tmpItem.GoodsId, tmpChild_all.GoodsId) AS GoodsId
                                              , _tmpItem.GoodsKindId
                                              , _tmpItem.Price_original
                                              , tmpChild_all.Amount
                                         FROM tmpChild_all
                                              LEFT JOIN _tmpItem ON _tmpItem.MovementItemId = tmpChild_all.ParentId
                                         )
                          , tmpResult AS (SELECT tmp.GoodsId, tmp.GoodsKindId, tmp.Price_original, SUM (tmp.Amount) AS Amount
                                          FROM tmpChild AS tmp
                                          GROUP BY tmp.GoodsId, tmp.GoodsKindId, tmp.Price_original
                                         )
                          , tmpMaster AS (SELECT tmp.GoodsId, tmp.GoodsKindId, tmp.Price_original
                                               , SUM (CASE WHEN vbMovementDescId = zc_Movement_ReturnIn() THEN tmp.OperCount_Partner ELSE tmp.OperCount END) AS Amount
                                          FROM _tmpItem AS tmp
                                          GROUP BY tmp.GoodsId, tmp.GoodsKindId, tmp.Price_original
                                         UNION ALL
                                          SELECT -1 * tmp.GoodsId, 0 AS GoodsKindId, 0 AS Price_original, -1 * tmp.Amount AS Amount
                                          FROM tmpChild AS tmp
                                          WHERE tmp.Amount <> 0 AND tmp.ParentId = 0
                                         )
                       -- ���������
                       SELECT '������. ��� �������� ���-�� = <' || tmpMaster.Amount :: TVarChar || '>'
               || CHR (13) || '�� ������������� �������� � ������� � ���-�� = <' || COALESCE (tmpResult.Amount, 0) :: TVarChar || '>.'
               || CHR (13) || '����� <' || lfGet_Object_ValueData (ABS (tmpMaster.GoodsId)) || '>'
                           || CASE WHEN tmpMaster.GoodsKindId > 0 THEN CHR (13) || '��� <' || lfGet_Object_ValueData (tmpMaster.GoodsKindId) || '>' ELSE '' END
                       FROM tmpMaster
                            LEFT JOIN tmpResult ON tmpResult.GoodsId         = tmpMaster.GoodsId
                                               AND tmpResult.GoodsKindId     = tmpMaster.GoodsKindId
                                               AND tmpResult.Price_original  = tmpMaster.Price_original
                       WHERE tmpMaster.Amount <> COALESCE (tmpResult.Amount, 0)
                         AND tmpMaster.Price_original <> 0
                       LIMIT 1
                      );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.05.16                                        *
*/

-- ����
-- SELECT * FROM MovementItem WHERE MovementId = 3662505 AND DescId = zc_MI_Child() -- SELECT * FROM MovementItemFloat WHERE MovementItemId IN (SELECT Id FROM MovementItem WHERE MovementId = 3662505 AND DescId = zc_MI_Child())
-- SELECT lpCheck_Movement_ReturnIn_Auto (inMovementId:= Movement.Id, inUserId:= zfCalc_UserAdmin() :: Integer) || CHR (13), Movement.* FROM Movement WHERE Movement.Id = 3662505
-- SELECT lpCheck_Movement_ReturnIn_Auto (inMovementId:= Movement.Id, inUserId:= zfCalc_UserAdmin() :: Integer) || CHR (13), Movement.* FROM Movement WHERE Movement.Id = 3185773 
