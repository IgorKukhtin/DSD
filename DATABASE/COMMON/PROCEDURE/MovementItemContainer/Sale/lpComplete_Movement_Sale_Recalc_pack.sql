-- Function: lpComplete_Movement_Sale_Recalc_pack (Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_Sale_Recalc_pack (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Sale_Recalc_pack(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbStatusId Integer;
BEGIN

     vbStatusId:= (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inMovementId);


if inUserId = 5 
then
     IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE '_tmp_test')
     THEN
         -- ������� - �������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
         CREATE TEMP TABLE _tmp_test (MovementItemId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
     ELSE
         DELETE FROM  _tmp_test;
     END IF;

     --     
     INSERT INTO _tmp_test (MovementItemId, GoodsId, Amount)
        SELECT MovementItem.Id, MovementItem.ObjectId, MovementItem.Amount
        FROM MovementItem
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId     = zc_MI_Master()
          AND MovementItem.isErased   = FALSE
       ;
end if;

     --
     UPDATE Movement SET StatusId = zc_Enum_Status_UnComplete() WHERE Movement.Id = inMovementId AND Movement.StatusId = zc_Enum_Status_Complete();

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (tmpMI.MovementItemId, inUserId, FALSE)

     FROM (-- ���������
           SELECT lpInsertUpdate_MovementItem (tmpMI.MovementItemId, tmpMI.DescId, tmpMI.GoodsId, tmpMI.MovementId, tmpMI.Amount_cacl, tmpMI.ParentId)
                , lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountPack(), tmpMI.MovementItemId, tmpMI.CountPack)
                , tmpMI.MovementItemId
           FROM
                -- ��������
               (WITH tmpMI AS (SELECT MovementItem.*
                                    , MILinkObject_GoodsKind.ObjectId      AS GoodsKindId
                                    , ObjectFloat_WeightPackage.ValueData  AS WeightPackage
                                    , ObjectFloat_WeightTotal.ValueData    AS WeightTotal
                               FROM MovementItem
                                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                     ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                    AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                    INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                                          ON ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = MovementItem.ObjectId
                                                         AND ObjectLink_GoodsByGoodsKind_Goods.DescId        = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                    INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                          ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId      = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                         AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                                         AND ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId = MILinkObject_GoodsKind.ObjectId
                                    -- ��� 1-��� ������ - ��� ������ ��� ��������
                                    LEFT JOIN ObjectFloat AS ObjectFloat_WeightPackage
                                                          ON ObjectFloat_WeightPackage.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                         AND ObjectFloat_WeightPackage.DescId   = zc_ObjectFloat_GoodsByGoodsKind_WeightPackage()
                                    -- ��� � �������� - "������" ��� + ��� 1-��� ������
                                    LEFT JOIN ObjectFloat AS ObjectFloat_WeightTotal
                                                          ON ObjectFloat_WeightTotal.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                         AND ObjectFloat_WeightTotal.DescId   = zc_ObjectFloat_GoodsByGoodsKind_WeightTotal()
                               WHERE MovementItem.MovementId = inMovementId
                                 AND MovementItem.DescId     = zc_MI_Master()
                                 AND MovementItem.isErased   = FALSE
                              )
                   , tmp AS (SELECT MovementItem.Id                           AS MovementItemId
                                  , MovementItem.DescId                       AS DescId
                                  , MovementItem.ObjectId                     AS GoodsId
                                  , MovementItem.GoodsKindId                  AS GoodsKindId
                                  , MovementItem.MovementId                   AS MovementId
                                  , MovementItem.ParentId                     AS ParentId
                                  , MIB_BarCode.ValueData                     AS isBarCode
                                  , OL_Measure.ChildObjectId                  AS MeasureId
                                  , MovementItem.Amount
                                    -- ������ ���-�� ��. �������� (���� ���������� �� 4-� ������)
                                  , CASE WHEN MovementItem.WeightTotal <> 0 AND MovementItem.WeightPackage <> 0 AND MovementItem.WeightTotal > MovementItem.WeightPackage
                                              THEN CAST (CAST (MIFloat_AmountPartner.ValueData / (1 - MovementItem.WeightPackage / MovementItem.WeightTotal) AS NUMERIC (16, 4)) / MovementItem.WeightTotal AS NUMERIC (16, 4))
                                         ELSE 0
                                    END :: TFloat AS CountPack
                                    -- ������ ���-�� �����
                                  , CAST ((COALESCE (MIFloat_AmountPartner.ValueData, 0)
                                           -- ������ ���-�� ��. �������� (���� ���������� �� 4-� ������)
                                         + CASE WHEN MovementItem.WeightTotal <> 0 AND MovementItem.WeightPackage <> 0 AND MovementItem.WeightTotal > MovementItem.WeightPackage
                                                     THEN CAST (CAST (MIFloat_AmountPartner.ValueData / (1 - MovementItem.WeightPackage / MovementItem.WeightTotal) AS NUMERIC (16, 4)) / MovementItem.WeightTotal AS NUMERIC (16, 4))
                                                ELSE 0
                                           END :: TFloat
                                           -- ��� 1-��� ������, ����� ����� �������� ��� ���� �������
                                         * COALESCE (MovementItem.WeightPackage, 0)
                                          )
                                         -- % ������ ���
                                        / (1 - CASE WHEN MIFloat_ChangePercentAmount.ValueData < 100 THEN MIFloat_ChangePercentAmount.ValueData/100 ELSE 0 END)
                                         AS NUMERIC (16, 4)) AS Amount_cacl
                     
                             FROM tmpMI AS MovementItem
                                  LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                              ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                             AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                                  -- % ������ ���
                                  LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentAmount
                                                              ON MIFloat_ChangePercentAmount.MovementItemId = MovementItem.Id
                                                             AND MIFloat_ChangePercentAmount.DescId         = zc_MIFloat_ChangePercentAmount()
                                /*LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()*/
                                  LEFT JOIN MovementItemBoolean AS MIB_BarCode
                                                                ON MIB_BarCode.MovementItemId = MovementItem.Id
                                                               AND MIB_BarCode.DescId         = zc_MIBoolean_BarCode()
                                  LEFT JOIN ObjectLink AS OL_Measure
                                                       ON OL_Measure.ObjectId = MovementItem.ObjectId
                                                      AND OL_Measure.DescId   = zc_ObjectLink_Goods_Measure()
                                  /*LEFT JOIN Object_GoodsByGoodsKind_View
                                         ON Object_GoodsByGoodsKind_View.GoodsId     = MovementItem.ObjectId
                                        AND Object_GoodsByGoodsKind_View.GoodsKindId = MILinkObject_GoodsKind.ObjectId
                                   -- ��� 1-��� ������ - ��� ������ ��� ��������
                                   LEFT JOIN ObjectFloat AS ObjectFloat_WeightPackage
                                                         ON ObjectFloat_WeightPackage.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                        AND ObjectFloat_WeightPackage.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightPackage()
                                   -- ��� � �������� - "������" ��� + ��� 1-��� ������
                                   LEFT JOIN ObjectFloat AS MovementItem.WeightTotal
                                                         ON MovementItem.WeightTotal.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                        AND MovementItem.WeightTotal.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightTotal()*/
                           /*WHERE MovementItem.MovementId = inMovementId
                               AND MovementItem.DescId     = zc_MI_Master()
                               AND MovementItem.isErased   = FALSE*/
                            )
             -- ��������
             SELECT *
             FROM tmp
             WHERE tmp.Amount_cacl <> tmp.Amount
               AND tmp.isBarCode   = TRUE
               AND tmp.MeasureId   = zc_Measure_Kg()
               AND tmp.GoodsId     > 0
               AND tmp.GoodsKindId IN (6899005, 8349) -- ���. 200 + ����-���
            ) AS tmpMI

           ) AS tmpMI
      ;

     -- ������ ������ �������
     if inUserId = 5 AND 1=0
     then
         RAISE EXCEPTION '��� ���� � ��� �������� - ��� � ������ �� ������.����� = <%>.���������� = <%>. one = <%> <%> min= <%> max=<%> '
                        , (SELECT SUM (MovementItem.Amount)
                           FROM MovementItem
                                LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                            ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                           AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = FALSE)
                        , (SELECT SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0))
                           FROM MovementItem
                                LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                            ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                           AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = FALSE)
                        , (SELECT MovementItem.Amount :: TVarChar || ' ' || lfGet_Object_ValueData (MovementItem.ObjectId) FROM MovementItem WHERE MovementItem.Id = 233583423)
                      --, (SELECT MovementItem.Amount :: TVarChar || ' ' || lfGet_Object_ValueData (MovementItem.ObjectId) FROM MovementItem WHERE MovementItem.Id = 233663447)
                        , (SELECT COUNT(*)
                           FROM MovementItem
                                JOIN _tmp_test ON _tmp_test.MovementItemId = MovementItem.Id
                                              AND _tmp_test.Amount        <> MovementItem.Amount
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = FALSE
                          )
                        , (SELECT MIN (MovementItem.Id)
                           FROM MovementItem
                                JOIN _tmp_test ON _tmp_test.MovementItemId = MovementItem.Id
                                              AND _tmp_test.Amount        <> MovementItem.Amount
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = FALSE
                          )
                        , (SELECT MAX (MovementItem.Id)
                           FROM MovementItem
                                JOIN _tmp_test ON _tmp_test.MovementItemId = MovementItem.Id
                                              AND _tmp_test.Amount        <> MovementItem.Amount
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = FALSE
                          )
                        ;
     end if;

     --
     IF vbStatusId = zc_Enum_Status_Complete()
     THEN
         UPDATE Movement SET StatusId = zc_Enum_Status_Complete() WHERE Movement.Id = inMovementId;
     END IF;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.07.22                                        *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_Sale_Recalc_pack (inMovementId:= 22903221, inUserId:= zfCalc_UserAdmin() :: Integer)
