-- Function: gpUpdateMI_OrderInternal_AmountPartner_dif()

DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_AmountPartner_dif (Integer, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMI_OrderInternal_AmountPartner_dif(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inOperDate            TDateTime , -- ���� ���������
    IN inFromId              Integer   , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbIsPack     Boolean;
   DECLARE vbIsTushenka Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderInternal());


    -- ������, �������� ����������� - To = ��� ��������
    vbIsPack:= EXISTS (SELECT MovementId FROM MovementLinkObject WHERE DescId = zc_MovementLinkObject_To() AND MovementId = inMovementId AND ObjectId = 8451); -- ��� ��������
    -- ������, �������� ����������� - To = ��� �������
    vbIsTushenka:= EXISTS (SELECT MovementId FROM MovementLinkObject WHERE DescId = zc_MovementLinkObject_To() AND MovementId = inMovementId AND ObjectId = 2790412); -- ��� �������


    -- ������� -
   CREATE TEMP TABLE tmpAll (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, AmountPartner TFloat, AmountPartnerPrior TFloat) ON COMMIT DROP;
   --
   INSERT INTO tmpAll (MovementItemId, GoodsId, GoodsKindId, AmountPartner, AmountPartnerPrior)
                                 WITH tmpUnit AS (SELECT UnitId FROM lfSelect_Object_Unit_byGroup (inFromId) AS lfSelect_Object_Unit_byGroup WHERE UnitId <> inFromId)
                                    , tmpGoods AS (SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
                                                        , CASE WHEN Object_InfoMoney_View.InfoMoneyId IN (zc_Enum_InfoMoney_20901() -- ����
                                                                                                        , zc_Enum_InfoMoney_30101() -- ������� ���������
                                                                                                        , zc_Enum_InfoMoney_30201() -- ������ �����

                                                                                                        , zc_Enum_InfoMoney_30102() -- ������ + ��������� + �������
                                                                                                         )
                                                                    THEN TRUE
                                                               ELSE FALSE
                                                          END AS isGoodsKind
                                                   FROM Object_InfoMoney_View
                                                        LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                                             ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                                                            AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                                   WHERE ((Object_InfoMoney_View.InfoMoneyId            = zc_Enum_InfoMoney_30101()            -- ������ + ��������� + ������� ���������
                                                        OR Object_InfoMoney_View.InfoMoneyId            = zc_Enum_InfoMoney_30102()            -- ������ + ��������� + �������
                                                        OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- ������ + ������ ����� + ��������...
                                                        OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- ������������� + ����
                                                          )
                                                         AND vbIsPack = FALSE AND vbIsTushenka = FALSE)

                                                      OR ((Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_30102() -- ������ + ��������� + �������
                                                          )
                                                         AND vbIsPack = FALSE AND vbIsTushenka = TRUE)

                                                      OR ((Object_InfoMoney_View.InfoMoneyId            = zc_Enum_InfoMoney_30101()            -- ������ + ��������� + ������� ���������
                                                        OR Object_InfoMoney_View.InfoMoneyId            = zc_Enum_InfoMoney_30201()            -- ������ + ������ ����� + ������ �����
                                                        OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- ������������� + ����
                                                          )
                                                         AND vbIsPack = TRUE AND vbIsTushenka = FALSE)
                                                  )
                    , tmpOrder_all AS (SELECT Movement.Id                                                              AS MovementId
                                            , MovementItem.ObjectId                                                    AS GoodsId
                                            , CASE WHEN tmpGoods.isGoodsKind = TRUE AND COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = 0 THEN zc_GoodsKind_Basis() ELSE COALESCE (MILinkObject_GoodsKind.ObjectId, 0) END AS GoodsKindId
                                            , SUM (CASE WHEN Movement.OperDate = inOperDate THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountPartner
                                            , SUM (CASE WHEN Movement.OperDate < inOperDate
                                                         AND MovementDate_OperDatePartner.ValueData >= inOperDate
                                                             THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                                                        ELSE 0
                                                   END) AS AmountPartnerPrior
                                       FROM Movement
                                            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                                   ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                            INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                            INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_To.ObjectId
                                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                                   AND MovementItem.isErased   = FALSE

                                            LEFT JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId

                                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                                        ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                                       AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                                       WHERE Movement.OperDate BETWEEN (inOperDate - INTERVAL '7 DAY') AND inOperDate + INTERVAL '0 DAY'
                                         AND MovementDate_OperDatePartner.ValueData >= inOperDate
                                         AND Movement.DescId   = zc_Movement_OrderExternal()
                                         AND Movement.StatusId = zc_Enum_Status_Complete()
                                       GROUP BY MovementItem.ObjectId
                                              , CASE WHEN tmpGoods.isGoodsKind = TRUE AND COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = 0 THEN zc_GoodsKind_Basis() ELSE COALESCE (MILinkObject_GoodsKind.ObjectId, 0) END
                                              , Movement.Id
                                       HAVING SUM (CASE WHEN Movement.OperDate = inOperDate THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) <> 0
                                           OR SUM (CASE WHEN Movement.OperDate < inOperDate
                                                         AND MovementDate_OperDatePartner.ValueData >= inOperDate
                                                             THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                                                        ELSE 0
                                                   END)  <> 0
                                       )

                          -- �������� ������� �� �������
                        , tmpMISale AS (SELECT tmp.MovementId             AS MovementId_order -- ������
                                             , MovementItem.Id
                                             , MovementItem.ObjectId      AS GoodsId
                                             , MovementItem.Amount        AS Amount
                                      FROM (SELECT DISTINCT tmpOrder_all.MovementId FROM tmpOrder_all) AS tmp
                                           LEFT JOIN MovementLinkMovement AS MLM_Order
                                                                          ON MLM_Order.MovementChildId = tmp.MovementId
                                                                         AND MLM_Order.DescId          = zc_MovementLinkMovement_Order()
                                           INNER JOIN Movement AS MovementSale
                                                               ON MovementSale.Id     = MLM_Order.MovementId  -- �������
                                                              AND MovementSale.DescId IN (zc_Movement_Sale(), zc_Movement_SendOnPrice())
                                                            --AND MovementSale.StatusId <> zc_Enum_Status_Erased()
                                                              AND MovementSale.StatusId = zc_Enum_Status_Complete()
                                                              -- ������������� ������� �������, �.�. ������� ����� �� 8:00
                                                              AND MovementSale.OperDate < inOperDate
                                           LEFT JOIN MovementItem ON MovementItem.MovementId = MovementSale.Id
                                                                 AND MovementItem.DescId     = zc_MI_Master()
                                                                 AND MovementItem.isErased   = FALSE
                                       )
                        , tmpMILO_GoodsKind AS (SELECT MovementItemLinkObject.*
                                                FROM MovementItemLinkObject
                                                WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMISale.Id FROM tmpMISale)
                                                   AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                                                )
                        , tmpSale AS (SELECT tmpMISale.MovementId_order -- ������
                                           , tmpMISale.GoodsId
                                           , CASE WHEN tmpGoods.isGoodsKind = TRUE AND COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = 0 THEN zc_GoodsKind_Basis() ELSE COALESCE (MILinkObject_GoodsKind.ObjectId, 0) END AS GoodsKindId
                                           , SUM (tmpMISale.Amount)  AS Amount
                                      FROM tmpMISale
                                           LEFT JOIN tmpMILO_GoodsKind AS MILinkObject_GoodsKind
                                                                       ON MILinkObject_GoodsKind.MovementItemId = tmpMISale.Id
                                                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                           LEFT JOIN tmpGoods ON tmpGoods.GoodsId = tmpMISale.GoodsId
                                      WHERE tmpMISale.Amount > 0
                                      GROUP BY tmpMISale.MovementId_order -- ������
                                             , tmpMISale.GoodsId
                                             , CASE WHEN tmpGoods.isGoodsKind = TRUE AND COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = 0 THEN zc_GoodsKind_Basis() ELSE COALESCE (MILinkObject_GoodsKind.ObjectId, 0) END
                                      )

                          --  �������� ���� �������� �� �������
                        , tmpOrder_diff AS (SELECT tmpOrder_all.GoodsId
                                                 , tmpOrder_all.GoodsKindId
                                                 , SUM (CASE WHEN COALESCE (tmpOrder_all.AmountPartner,0) - COALESCE (tmpSale.Amount, 0) > 0 THEN COALESCE (tmpOrder_all.AmountPartner,0) - COALESCE (tmpSale.Amount, 0) ELSE 0 END)           AS AmountPartner
                                                 , SUM (CASE WHEN COALESCE (tmpOrder_all.AmountPartnerPrior,0) - COALESCE (tmpSale.Amount, 0) > 0 THEN COALESCE (tmpOrder_all.AmountPartnerPrior,0) - COALESCE (tmpSale.Amount, 0) ELSE 0 END) AS AmountPartnerPrior
                                            FROM tmpOrder_all
                                                 LEFT JOIN tmpSale ON tmpSale.MovementId_order = tmpOrder_all.MovementId
                                                                  AND tmpSale.GoodsId          = tmpOrder_all.GoodsId
                                                                  AND tmpSale.GoodsKindId      = tmpOrder_all.GoodsKindId
                                            GROUP BY tmpOrder_all.GoodsId
                                                   , tmpOrder_all.GoodsKindId
                                            HAVING SUM (CASE WHEN COALESCE (tmpOrder_all.AmountPartner,0) - COALESCE (tmpSale.Amount, 0) > 0 THEN COALESCE (tmpOrder_all.AmountPartner,0) - COALESCE (tmpSale.Amount, 0) ELSE 0 END) > 0
                                                OR SUM (CASE WHEN COALESCE (tmpOrder_all.AmountPartnerPrior,0) - COALESCE (tmpSale.Amount, 0) > 0 THEN COALESCE (tmpOrder_all.AmountPartnerPrior,0) - COALESCE (tmpSale.Amount, 0) ELSE 0 END)> 0
                                            )
                        -- ���������� ������
                        , tmpOrder AS (SELECT tmpOrder_diff.GoodsId
                                            , CASE WHEN tmpGoods.isGoodsKind = TRUE AND tmpOrder_diff.GoodsKindId = 0 THEN zc_GoodsKind_Basis() WHEN tmpGoods.isGoodsKind = TRUE THEN tmpOrder_diff.GoodsKindId ELSE 0 END AS GoodsKindId
                                            , SUM (COALESCE (tmpOrder_diff.AmountPartner,0))      AS AmountPartner
                                            , SUM (COALESCE (tmpOrder_diff.AmountPartnerPrior,0)) AS AmountPartnerPrior
                                       FROM tmpOrder_diff
                                            INNER JOIN tmpGoods ON tmpGoods.GoodsId = tmpOrder_diff.GoodsId
                                       GROUP BY tmpOrder_diff.GoodsId
                                              , CASE WHEN tmpGoods.isGoodsKind = TRUE AND tmpOrder_diff.GoodsKindId = 0 THEN zc_GoodsKind_Basis() WHEN tmpGoods.isGoodsKind = TRUE THEN tmpOrder_diff.GoodsKindId ELSE 0 END
                                       )
                        -- ������ ���.���������
                    , tmpMI_all AS (SELECT MovementItem.Id                               AS MovementItemId
                                         , MovementItem.ObjectId                         AS GoodsId
                                         , CASE WHEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = 0 THEN zc_GoodsKind_Basis()
                                                ELSE COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                           END AS GoodsKindId
                                         , MovementItem.Amount
                                           -- � �/�
                                         , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId
                                                                         , CASE WHEN tmpGoods.isGoodsKind = TRUE AND COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = 0 THEN zc_GoodsKind_Basis()
                                                                                WHEN tmpGoods.isGoodsKind = TRUE THEN COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                                                                ELSE COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                                                           END
                                                              ORDER BY MovementItem.Id DESC
                                                             ) AS Ord
                                    FROM MovementItem
                                         LEFT JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
                                         LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                          ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                         AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                    WHERE MovementItem.MovementId = inMovementId
                                      AND MovementItem.DescId     = zc_MI_Master()
                                      AND MovementItem.isErased   = FALSE
                                  )
                     , tmpMI AS (SELECT tmpMI_all.MovementItemId
                                      , tmpMI_all.GoodsId
                                      , tmpMI_all.GoodsKindId
                                      , tmpMI_all.Amount
                                 FROM tmpMI_all 
                                 WHERE tmpMI_all.Ord = 1
                                )
       -- ���������
       SELECT tmp.MovementItemId
             , COALESCE (tmp.GoodsId,tmpOrder.GoodsId)          AS GoodsId
             , COALESCE (tmp.GoodsKindId, tmpOrder.GoodsKindId) AS GoodsKindId
             , COALESCE (tmpOrder.AmountPartner, 0)             AS AmountPartner
             , COALESCE (tmpOrder.AmountPartnerPrior, 0)        AS AmountPartnerPrior
       FROM tmpOrder
            FULL JOIN tmpMI AS tmp  ON tmp.GoodsId     = tmpOrder.GoodsId
                                   AND tmp.GoodsKindId = tmpOrder.GoodsKindId
      ;


       -- ���������
       PERFORM lpUpdate_MI_OrderInternal_Property (ioId                    := tmpAll.MovementItemId
                                                 , inMovementId            := inMovementId
                                                 , inGoodsId               := tmpAll.GoodsId
                                                 , inGoodsKindId           := tmpAll.GoodsKindId
                                                 , inAmount_Param          := COALESCE (tmpAll.AmountPartner * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END, 0)
                                                 , inDescId_Param          := zc_MIFloat_AmountPartner()
                                                 , inAmount_ParamOrder     := COALESCE (tmpAll.AmountPartnerPrior * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END, 0)
                                                 , inDescId_ParamOrder     := zc_MIFloat_AmountPartnerPrior()
                                                 , inAmount_ParamSecond    := NULL
                                                 , inDescId_ParamSecond    := NULL
                                                 , inAmount_ParamAdd       := 0
                                                 , inDescId_ParamAdd       := 0
                                                 , inAmount_ParamNext      := 0
                                                 , inDescId_ParamNext      := 0
                                                 , inAmount_ParamNextPromo := 0
                                                 , inDescId_ParamNextPromo := 0
                                                 , inIsPack                := vbIsPack
                                                 , inIsParentMulti         := TRUE
                                                 , inUserId                := vbUserId
                                                  ) 
       FROM tmpAll
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpAll.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = tmpAll.GoodsId
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
      ;

IF vbUserId = 5 AND 1=1
THEN
    RAISE EXCEPTION 'OK';
    -- '��������� �������� ����� 3 ���.'
END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.06.20         *
*/

-- ����
-- SELECT * FROM gpUpdateMI_OrderInternal_AmountPartner_dif (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= zfCalc_UserAdmin())
