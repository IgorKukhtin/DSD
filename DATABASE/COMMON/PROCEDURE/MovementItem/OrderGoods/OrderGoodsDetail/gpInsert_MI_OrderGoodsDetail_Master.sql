-- Function: gpInsert_MI_OrderGoodsDetail_Master()

DROP FUNCTION IF EXISTS gpInsert_MI_OrderGoodsDetail_Master (Integer, Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_OrderGoodsDetail_Master(
    IN inParentId             Integer  , -- ���� ��������� OrderGoods
    IN inOperDateStart        TDateTime, --
    IN inOperDateEnd          TDateTime, --
    IN inSession              TVarChar   -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbOperDate  TDateTime;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate   TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsReportSale());

     --������� ����� ����������� ���.
     vbMovementId := (SELECT Movement.Id FROM Movement WHERE Movement.ParentId = inParentId AND Movement.DescId = zc_Movement_OrderGoodsDetail());
     -- �������������� ���� ��� ���������� ����� ��� , ���� �� ����
     vbMovementId := lpInsertUpdate_Movement_OrderGoodsDetail (ioId            := vbMovementId
                                                             , inParentId      := inParentId   -- ���� ��������� OrderGoods
                                                             , inOperDate      := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inParentId)
                                                             , inOperDateStart := inOperDateStart
                                                             , inOperDateEnd   := inOperDateEnd
                                                             , inUserId        := vbUserId
                                                              );

     -- �������� - ���� ��� ���� ��������
     CREATE TEMP TABLE tmpGoodsMaster (GoodsId Integer, Amount TFloat) ON COMMIT DROP;
     INSERT INTO tmpGoodsMaster (GoodsId, Amount)
       SELECT MovementItem.ObjectId AS GoodsId
              -- ��������� � ������ ��.���.
            , SUM (CAST (CASE -- ���� ��� ������� �����
                              WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                              THEN CASE WHEN ObjectFloat_Weight.ValueData > 0 AND MovementItem.Amount > 0
                                        -- ����� ���, ��������� � ��
                                        THEN MovementItem.Amount / ObjectFloat_Weight.ValueData
                                        -- ����� ��
                                        ELSE MIFloat_AmountSecond.ValueData
                                   END
                              -- ��� ������� �����
                              ELSE CASE WHEN COALESCE (MovementItem.Amount,0) <> 0
                                        -- �����  ���
                                        THEN MovementItem.Amount
                                        -- ����� ��, ��������� � ��� - �� ������ ���� �� �����, ���� ������� �������� ��� �����
                                        ELSE MIFloat_AmountSecond.ValueData * COALESCE (ObjectFloat_Weight.ValueData, 1)
                                   END
                         END AS NUMERIC (16,0))
                   )AS Amount
       FROM MovementItem
            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                        ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountSecond.DescId         = zc_MIFloat_AmountSecond()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                 AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
       WHERE MovementItem.MovementId = inParentId
         AND MovementItem.DescId     = zc_MI_Master()
         AND MovementItem.isErased   = FALSE
       GROUP BY MovementItem.ObjectId
      ;


      -- ���������� ������ + �������
      CREATE TEMP TABLE tmpAll (GoodsId Integer, GoodsKindId Integer, AmountOrder TFloat, AmountOrderPromo TFloat, AmountSale TFloat, AmountSalePromo TFloat, Amount_calc TFloat) ON COMMIT DROP;

      WITH -- ������ ��
           tmpGoods AS (SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
                             , CASE WHEN Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_30101() -- ������� ���������
                                         THEN TRUE
                                    ELSE FALSE
                               END AS isGoodsKind
                        FROM Object_InfoMoney_View
                             LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                  ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                                 AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                        WHERE (Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- ������ + ��������� + ������� ��������� and ������� and ����
                            OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- ������������� + ����
                          --OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- ������ + ������ ����� : ��������...
                              )
                       )
           -- ������ - ������������
         , tmpOrder AS (SELECT MovementItem.Id
                             , MovementItem.ObjectId AS GoodsId
                             , CASE WHEN tmpGoods.isGoodsKind = TRUE THEN COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) ELSE 0 END AS GoodsKindId
                               -- ����������(������)  - ��� �����
                             , (CASE WHEN COALESCE (MIFloat_PromoMovementId.ValueData, 0) = 0 THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS Amount
                               -- ����������(������)  - ������ �����
                             , (CASE WHEN COALESCE (MIFloat_PromoMovementId.ValueData, 0) > 0 THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountPromo
                        FROM (SELECT Movement.Id
                              FROM MovementDate AS MD_OperDatePartner
                                   INNER JOIN Movement ON Movement.Id       = MD_OperDatePartner.MovementId
                                                      AND Movement.DescId   = zc_Movement_OrderExternal()
                                                      AND Movement.StatusId = zc_Enum_Status_Complete()
                                   INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                 ON MovementLinkObject_From.MovementId = Movement.Id
                                                                AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                   -- ���� ��� ������ � �������
                                   LEFT JOIN Object AS Object_From ON Object_From.Id     = MovementLinkObject_From.ObjectId
                                                                  AND Object_From.DescId = zc_Object_Unit()
      
                              WHERE MD_OperDatePartner.ValueData BETWEEN inOperDateStart AND inOperDateEnd
                                AND MD_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                -- ��� ������ � �������
                                AND Object_From.Id IS NULL
                             ) AS Movement

                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = FALSE
                             INNER JOIN tmpGoodsMaster ON tmpGoodsMaster.GoodsId = MovementItem.ObjectId

                             LEFT JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
                             
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                                             AND tmpGoods.isGoodsKind                  = TRUE
                             LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                         ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountSecond.DescId         = zc_MIFloat_AmountSecond()

                             LEFT JOIN MovementItemFloat AS MIFloat_PromoMovementId
                                                         ON MIFloat_PromoMovementId.MovementItemId = MovementItem.Id
                                                        AND MIFloat_PromoMovementId.DescId         = zc_MIFloat_PromoMovementId()
                      --GROUP BY MovementItem.ObjectId
                      --       , CASE WHEN tmpGoods.isGoodsKind = TRUE THEN COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) ELSE 0 END
                       )
            -- ������� - �� ��� � ������������
          , tmpSale AS (SELECT MovementItem.Id
                             , MovementItem.ObjectId AS GoodsId
                             , CASE WHEN tmpGoods.isGoodsKind = TRUE THEN COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) ELSE 0 END AS GoodsKindId
                               -- ����������(������)  - ��� �����
                             , (CASE WHEN COALESCE (MIFloat_PromoMovementId.ValueData, 0) = 0 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) AS Amount
                               -- ����������(������)  - ������ �����
                             , (CASE WHEN COALESCE (MIFloat_PromoMovementId.ValueData, 0) > 0 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) AS AmountPromo
                        FROM (SELECT Movement.Id
                              FROM MovementDate AS MD_OperDatePartner
                                   INNER JOIN Movement ON Movement.Id       = MD_OperDatePartner.MovementId
                                                      AND Movement.DescId   = zc_Movement_Sale()
                                                      AND Movement.StatusId = zc_Enum_Status_Complete()
                              WHERE MD_OperDatePartner.ValueData BETWEEN inOperDateStart AND inOperDateEnd
                                AND MD_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                             ) AS Movement

                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = FALSE
                             INNER JOIN tmpGoodsMaster ON tmpGoodsMaster.GoodsId = MovementItem.ObjectId

                             LEFT JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId

                             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                                             AND tmpGoods.isGoodsKind                  = TRUE
                             LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                         ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()

                             LEFT JOIN MovementItemFloat AS MIFloat_PromoMovementId
                                                         ON MIFloat_PromoMovementId.MovementItemId = MovementItem.Id
                                                        AND MIFloat_PromoMovementId.DescId         = zc_MIFloat_PromoMovementId()
                      --GROUP BY MovementItem.ObjectId
                      --       , CASE WHEN tmpGoods.isGoodsKind = TRUE THEN COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) ELSE 0 END
                       )
         , tmpMIAll AS (-- 1.1 ������
                        SELECT tmpOrder.GoodsId
                             , tmpOrder.GoodsKindId
                             , SUM (tmpOrder.Amount)      AS AmountOrder
                             , SUM (tmpOrder.AmountPromo) AS AmountOrderPromo
                             , 0                          AS AmountSale
                             , 0                          AS AmountSalePromo
                        FROM tmpOrder
                        WHERE tmpOrder.Amount > 0 OR tmpOrder.AmountPromo > 0
                        GROUP BY tmpOrder.GoodsId
                               , tmpOrder.GoodsKindId

                       UNION ALL
                        -- 1.2 �������
                        SELECT tmpSale.GoodsId
                             , tmpSale.GoodsKindId
                             , 0                         AS AmountOrder
                             , 0                         AS AmountOrderPromo
                             , SUM (tmpSale.Amount)      AS AmountSale
                             , SUM (tmpSale.AmountPromo) AS AmountSalePromo
                        FROM tmpSale
                        WHERE tmpSale.Amount > 0 OR tmpSale.AmountPromo > 0
                        GROUP BY tmpSale.GoodsId
                               , tmpSale.GoodsKindId
                       )
      -- ��������� - ���������� ������ + �������
      INSERT INTO tmpAll (GoodsId, GoodsKindId, AmountOrder, AmountOrderPromo, AmountSale, AmountSalePromo, Amount_calc)
         SELECT tmpMIAll.GoodsId
              , tmpMIAll.GoodsKindId
              , SUM (tmpMIAll.AmountOrder)        AS AmountOrder
              , SUM (tmpMIAll.AmountOrderPromo)   AS AmountOrderPromo
              , SUM (tmpMIAll.AmountSale)         AS AmountSale
              , SUM (tmpMIAll.AmountSalePromo)    AS AmountSalePromo
                -- �� ����� �������� - ������������
              , SUM (tmpMIAll.AmountSale + tmpMIAll.AmountSalePromo) AS Amount_calc
         FROM tmpMIAll
         GROUP BY tmpMIAll.GoodsId
                , tmpMIAll.GoodsKindId
         HAVING SUM (tmpMIAll.AmountOrder)      <> 0
             OR SUM (tmpMIAll.AmountOrderPromo) <> 0
             OR SUM (tmpMIAll.AmountSale)       <> 0
             OR SUM (tmpMIAll.AmountSalePromo)  <> 0
     ;

   -- �������� - ���� �� ����� �������� (�����������)
   CREATE TEMP TABLE tmpMI_Master (Id Integer, GoodsId Integer, GoodsKindId Integer) ON COMMIT DROP;
    INSERT INTO tmpMI_Master (Id, GoodsId, GoodsKindId)
       SELECT MovementItem.Id
            , MovementItem.ObjectId                 AS GoodsId
            , COALESCE (MILO_GoodsKind.ObjectId, 0) AS GoodsKindId
       FROM MovementItem
            LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                             ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
       WHERE MovementItem.MovementId = vbMovementId
         AND MovementItem.DescId     = zc_MI_Master()
         AND MovementItem.isErased   = FALSE
      ;

   -- ������� ������ ������� ��� � �������, ��������� �������
   PERFORM gpMovementItem_OrderGoodsDetail_SetErased_Master (inMovementItemId := tmpMI_Master.Id
                                                           , inSession := inSession)
   FROM tmpMI_Master
       LEFT JOIN tmpAll ON tmpAll.GoodsId = tmpMI_Master.GoodsId
                       AND tmpAll.GoodsKindId = tmpMI_Master.GoodsKindId
   WHERE tmpAll.GoodsId IS NULL;

   -- MI_Master - ������������ - ���� �� ����� �������� (�����������)
   PERFORM lpInsert_MI_OrderGoodsDetail_Master(inId                       := tmpMI_Master.Id
                                             , inMovementId               := vbMovementId
                                             , inObjectId                 := tmpGoodsMaster.GoodsId
                                             , inGoodsKindId              := CASE WHEN tmpAll.GoodsKindId > 0 THEN tmpAll.GoodsKindId ELSE zc_GoodsKind_Basis() END
                                             , inAmount                   := CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                                                                  THEN
                                                                                     CAST (CASE -- ���� ������� - ������������ tmpGoodsMaster
                                                                                                WHEN tmpAll_total.Amount_calc <> 0
                                                                                                     THEN tmpGoodsMaster.Amount * tmpAll.Amount_calc / tmpAll_total.Amount_calc
                                                                                                -- ������� � ������
                                                                                                WHEN tmpAll.Ord = 1
                                                                                                     THEN tmpGoodsMaster.Amount
                                                                                                ELSE 0
                                                                                           END AS NUMERIC (16,0))
                                                                                  ELSE
                                                                                     CAST (CASE -- ���� ������� - ������������
                                                                                                WHEN tmpAll_total.Amount_calc <> 0
                                                                                                     THEN tmpGoodsMaster.Amount * tmpAll.Amount_calc / tmpAll_total.Amount_calc
                                                                                                -- ������� � ������
                                                                                                WHEN tmpAll.Ord = 1
                                                                                                     THEN tmpGoodsMaster.Amount
                                                                                                ELSE 0
                                                                                           END AS NUMERIC (16,2))
                                                                                  END
                                             , inAmountForecast           := COALESCE (tmpAll.AmountSale,0)       ::TFloat
                                             , inAmountForecastOrder      := COALESCE (tmpAll.AmountOrder,0)      ::TFloat
                                             , inAmountForecastPromo      := COALESCE (tmpAll.AmountSalePromo,0)  ::TFloat
                                             , inAmountForecastOrderPromo := COALESCE (tmpAll.AmountOrderPromo,0) ::TFloat
                                             , inUserId                   := vbUserId
                                              )
   FROM tmpGoodsMaster
        -- ���������� ������ + ������� �� ����� ��������
        LEFT JOIN (SELECT tmpAll.*
                          -- � �/�, �.�. ���� ������ ��� - ������� � ������
                        , ROW_NUMBER() OVER (PARTITION BY tmpAll.GoodsId ORDER BY tmpAll.AmountOrder DESC, tmpAll.AmountOrderPromo DESC) AS Ord
                   FROM tmpAll
                  ) AS tmpAll ON tmpAll.GoodsId = tmpGoodsMaster.GoodsId
        -- ���������� ������ + ������� �����
        LEFT JOIN (SELECT tmpAll.GoodsId, SUM (tmpAll.Amount_calc) AS Amount_calc FROM tmpAll GROUP BY tmpAll.GoodsId
                  ) AS tmpAll_total ON tmpAll_total.GoodsId = tmpGoodsMaster.GoodsId
        -- ��� ����������� - ����� Id
        LEFT JOIN tmpMI_Master ON tmpMI_Master.GoodsId     = tmpAll.GoodsId
                              AND tmpMI_Master.GoodsKindId = tmpAll.GoodsKindId
        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                             ON ObjectLink_Goods_Measure.ObjectId = tmpGoodsMaster.GoodsId
                            AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
       ;

 --RAISE EXCEPTION 'end ';

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.09.21         *
*/

-- ����
-- select * from gpInsert_MI_OrderGoodsDetail_Master(inParentId := 20242962 , inOperDateStart := ('28.07.2021')::TDateTime , inOperDateEnd := ('31.08.2021')::TDateTime ,  inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e');
