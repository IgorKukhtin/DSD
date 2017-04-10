-- Function: lpUpdate_MI_OrderInternal_Property()

DROP FUNCTION IF EXISTS lpUpdate_MI_OrderInternal_Property (Integer, Integer, Integer, Integer, TFloat, Integer, TFloat, Integer, TFloat, Integer, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_MI_OrderInternal_Property(
    IN ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inAmount_Param        TFloat    , --
    IN inDescId_Param        Integer   ,
    IN inAmount_ParamOrder   TFloat    , --
    IN inDescId_ParamOrder   Integer   ,
    IN inAmount_ParamSecond  TFloat    , --
    IN inDescId_ParamSecond  Integer   ,
    IN inIsPack              Boolean   , --
    IN inUserId              Integer     -- ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbMonth Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbFromId Integer;
   DECLARE vbAmount_calc TFloat;
BEGIN
     -- ������������
     SELECT EXTRACT (MONTH FROM (Movement.OperDate + INTERVAL '1 DAY'))
          , Movement.OperDate
          , MovementLinkObject_From.ObjectId
            INTO vbMonth, vbOperDate, vbFromId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
     WHERE Movement.Id = inMovementId;


     -- ������ ������ ��� �����
     IF inDescId_ParamSecond = zc_MIFloat_AmountPartnerSecond()
     /*AND EXISTS (SELECT 1
                FROM ObjectLink AS ObjectLink_Goods_InfoMoney
                     LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                    AND Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10200() -- �������� ����� + ������ �����
                                                    -- AND Object_InfoMoney_View.InfoMoneyId <> zc_Enum_InfoMoney_10204() -- �������� ����� + ������ ����� + ������ �����
                WHERE ObjectLink_Goods_InfoMoney.ObjectId = inGoodsId
                  AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
               )*/
     THEN vbAmount_calc:= COALESCE (inAmount_Param, 0) + COALESCE (inAmount_ParamOrder, 0) + COALESCE (inAmount_ParamSecond, 0)
                        - (-- �������
                           COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_AmountRemains()), 0)
                            -- ������������ �����������
                         + COALESCE ((SELECT SUM (tmpMI.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) AS Amount
                                      FROM (SELECT CASE -- !!!�������� �����������!!!
                                                        WHEN MIContainer.ObjectExtId_Analyzer = 8445 -- ����� ���������
                                                         -- AND COALESCE (MIContainer.ObjectIntId_Analyzer, 0) = 0
                                                             THEN 8338 -- �����.
                                                        ELSE 0 -- COALESCE (MIContainer.ObjectIntId_Analyzer, 0)
                                                   END AS GoodsKindId
                                                 , SUM (MIContainer.Amount)                       AS Amount
                                            FROM MovementItemContainer AS MIContainer
                                            WHERE MIContainer.OperDate               = vbOperDate
                                              AND MIContainer.DescId                 = zc_MIContainer_Count()
                                              AND MIContainer.MovementDescId         = zc_Movement_Send()
                                              AND MIContainer.ObjectId_Analyzer      = inGoodsId
                                              AND MIContainer.WhereObjectId_Analyzer = vbFromId
                                              -- AND MIContainer.isActive = TRUE
                                            GROUP BY CASE -- !!!�������� �����������!!!
                                                          WHEN MIContainer.ObjectExtId_Analyzer = 8445 -- ����� ���������
                                                           -- AND COALESCE (MIContainer.ObjectIntId_Analyzer, 0) = 0
                                                               THEN 8338 -- �����.
                                                          ELSE 0 -- COALESCE (MIContainer.ObjectIntId_Analyzer, 0)
                                                     END
                                           ) AS tmpMI
                                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                                ON ObjectLink_Goods_Measure.ObjectId = inGoodsId
                                                               AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                           LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                                 ON ObjectFloat_Weight.ObjectId = inGoodsId
                                                                AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                                      WHERE tmpMI.GoodsKindId = COALESCE (inGoodsKindId, 0)
                                     ), 0)
                          );
     END IF;

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     IF COALESCE (ioId, 0) = 0
     THEN
         -- �������� ������������
         IF EXISTS (SELECT 1
                    FROM MovementItem
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                          ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.ObjectId   = inGoodsId
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND MovementItem.isErased   = FALSE
                      AND COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = COALESCE (inGoodsKindId, 0)
                    )
         THEN
             RAISE EXCEPTION '������.� ��������� ��� ���������� <%> <%>.������������ ���������.', lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData (inGoodsKindId);
         END IF;


         -- ��������� <������� ���������>
         ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, COALESCE (CASE WHEN vbAmount_calc > 0 THEN vbAmount_calc ELSE 0 END, 0), NULL);

         -- ��������� ����� � <���� �������>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);

     -- ������ ��� �����
     ELSEIF inDescId_ParamSecond = zc_MIFloat_AmountPartnerSecond()
     THEN
         -- ��������� <������� ���������>
         ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, COALESCE (CASE WHEN vbAmount_calc > 0 THEN vbAmount_calc ELSE 0 END, 0), NULL);

     -- !!!��������
     -- ELSE
         -- ��������� <������� ���������>
         -- ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, 0, NULL);

     END IF;


     -- !!!������ ��� ������ �� ������������!!!
     IF inIsPack = FALSE AND (vbIsInsert = TRUE OR 1=1)
     THEN
         -- ��������� ����� � <���������>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReceiptBasis(), ioId, tmp.ReceiptId_basis)
               , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Receipt(),      ioId, tmp.ReceiptId)
               , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsBasis(),   ioId, ObjectLink_Receipt_Goods_basis.ChildObjectId)
               , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(),        ioId, ObjectLink_Receipt_Goods.ChildObjectId)
               , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKindComplete(), ioId, ObjectLink_Receipt_GoodsKind.ChildObjectId)
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_TermProduction(),         ioId, COALESCE (ObjectFloat_TermProduction.ValueData, 1))
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_NormInDays(),             ioId, COALESCE (ObjectFloat_NormInDays.ValueData, 2))
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_Koeff(),                  ioId, COALESCE (ObjectFloat_Koeff.ValueData, 1))
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_StartProductionInDays(),  ioId, COALESCE (ObjectFloat_StartProductionInDays.ValueData, 1))
         FROM (SELECT inGoodsId AS GoodsId) AS tmpGoods
              LEFT JOIN (SELECT inGoodsId AS GoodsId
                              , CASE WHEN ObjectLink_Receipt_GoodsKind_Parent_0.ChildObjectId = zc_GoodsKind_WorkProgress()
                                          THEN ObjectLink_Receipt_Parent_0.ChildObjectId
                                     WHEN ObjectLink_Receipt_GoodsKind_Parent_1.ChildObjectId = zc_GoodsKind_WorkProgress()
                                          THEN ObjectLink_Receipt_Parent_1.ChildObjectId
                                     WHEN ObjectLink_Receipt_GoodsKind_Parent_2.ChildObjectId = zc_GoodsKind_WorkProgress()
                                          THEN ObjectLink_Receipt_Parent_2.ChildObjectId
                                     WHEN ObjectLink_Receipt_GoodsKind_Parent_3.ChildObjectId = zc_GoodsKind_WorkProgress()
                                          THEN ObjectLink_Receipt_Parent_3.ChildObjectId
                                END AS ReceiptId_basis
                              , CASE WHEN ObjectLink_Receipt_GoodsKind_Parent_0.ChildObjectId = zc_GoodsKind_WorkProgress()
                                          THEN ObjectLink_Receipt_Parent_0.ObjectId
                                     WHEN ObjectLink_Receipt_GoodsKind_Parent_1.ChildObjectId = zc_GoodsKind_WorkProgress()
                                          THEN ObjectLink_Receipt_Parent_1.ObjectId
                                     WHEN ObjectLink_Receipt_GoodsKind_Parent_2.ChildObjectId = zc_GoodsKind_WorkProgress()
                                          THEN ObjectLink_Receipt_Parent_2.ObjectId
                                     WHEN ObjectLink_Receipt_GoodsKind_Parent_3.ChildObjectId = zc_GoodsKind_WorkProgress()
                                          THEN ObjectLink_Receipt_Parent_3.ObjectId
                                END AS ReceiptId
                         FROM ObjectLink AS ObjectLink_Receipt_Goods
                              INNER JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                    ON ObjectLink_Receipt_GoodsKind.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                                   AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
                                                   AND ObjectLink_Receipt_GoodsKind.ChildObjectId = inGoodsKindId
                              INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_Receipt_Goods.ObjectId
                                                                 AND Object_Receipt.isErased = FALSE
                              INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                       ON ObjectBoolean_Main.ObjectId = Object_Receipt.Id
                                                      AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                                      AND ObjectBoolean_Main.ValueData = TRUE
                              LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_0
                                                   ON ObjectLink_Receipt_Parent_0.ObjectId = Object_Receipt.Id
                                                  AND ObjectLink_Receipt_Parent_0.DescId = zc_ObjectLink_Receipt_Parent()
                              LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_0
                                                   ON ObjectLink_Receipt_GoodsKind_Parent_0.ObjectId = ObjectLink_Receipt_Parent_0.ChildObjectId
                                                  AND ObjectLink_Receipt_GoodsKind_Parent_0.DescId = zc_ObjectLink_Receipt_GoodsKind()

                              LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_1
                                                   ON ObjectLink_Receipt_Parent_1.ObjectId = ObjectLink_Receipt_Parent_0.ChildObjectId
                                                  AND ObjectLink_Receipt_Parent_1.DescId = zc_ObjectLink_Receipt_Parent()
                              LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_1
                                                   ON ObjectLink_Receipt_GoodsKind_Parent_1.ObjectId = ObjectLink_Receipt_Parent_1.ChildObjectId
                                                  AND ObjectLink_Receipt_GoodsKind_Parent_1.DescId = zc_ObjectLink_Receipt_GoodsKind()

                              LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_2
                                                   ON ObjectLink_Receipt_Parent_2.ObjectId = ObjectLink_Receipt_Parent_1.ChildObjectId
                                                  AND ObjectLink_Receipt_Parent_2.DescId = zc_ObjectLink_Receipt_Parent()
                              LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_2
                                                   ON ObjectLink_Receipt_GoodsKind_Parent_2.ObjectId = ObjectLink_Receipt_Parent_2.ChildObjectId
                                                  AND ObjectLink_Receipt_GoodsKind_Parent_2.DescId = zc_ObjectLink_Receipt_GoodsKind()

                              LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_3
                                                   ON ObjectLink_Receipt_Parent_3.ObjectId = ObjectLink_Receipt_Parent_2.ChildObjectId
                                                  AND ObjectLink_Receipt_Parent_3.DescId = zc_ObjectLink_Receipt_Parent()
                              LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_3
                                                   ON ObjectLink_Receipt_GoodsKind_Parent_3.ObjectId = ObjectLink_Receipt_Parent_3.ChildObjectId
                                                  AND ObjectLink_Receipt_GoodsKind_Parent_3.DescId = zc_ObjectLink_Receipt_GoodsKind()

                         WHERE ObjectLink_Receipt_Goods.ChildObjectId = inGoodsId
                           AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                        ) AS tmp ON tmp.GoodsId = inGoodsId


                        LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods_basis
                                             ON ObjectLink_Receipt_Goods_basis.ObjectId = tmp.ReceiptId_basis
                                            AND ObjectLink_Receipt_Goods_basis.DescId = zc_ObjectLink_Receipt_Goods()

                        LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                             ON ObjectLink_Receipt_Goods.ObjectId = tmp.ReceiptId
                                            AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                        LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                             ON ObjectLink_Receipt_GoodsKind.ObjectId = tmp.ReceiptId
                                            AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()

                        LEFT JOIN ObjectLink AS ObjectLink_OrderType_Goods
                                             ON ObjectLink_OrderType_Goods.ChildObjectId = ObjectLink_Receipt_Goods.ChildObjectId
                                            AND ObjectLink_OrderType_Goods.DescId = zc_ObjectLink_OrderType_Goods()
                        LEFT JOIN ObjectFloat AS ObjectFloat_Koeff
                                              ON ObjectFloat_Koeff.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                             AND ObjectFloat_Koeff.DescId = CASE vbMonth WHEN 1 THEN zc_ObjectFloat_OrderType_Koeff1()
                                                                                         WHEN 2 THEN zc_ObjectFloat_OrderType_Koeff2()
                                                                                         WHEN 3 THEN zc_ObjectFloat_OrderType_Koeff3()
                                                                                         WHEN 4 THEN zc_ObjectFloat_OrderType_Koeff4()
                                                                                         WHEN 5 THEN zc_ObjectFloat_OrderType_Koeff5()
                                                                                         WHEN 6 THEN zc_ObjectFloat_OrderType_Koeff6()
                                                                                         WHEN 7 THEN zc_ObjectFloat_OrderType_Koeff7()
                                                                                         WHEN 8 THEN zc_ObjectFloat_OrderType_Koeff8()
                                                                                         WHEN 9 THEN zc_ObjectFloat_OrderType_Koeff9()
                                                                                         WHEN 10 THEN zc_ObjectFloat_OrderType_Koeff10()
                                                                                         WHEN 11 THEN zc_ObjectFloat_OrderType_Koeff11()
                                                                                         WHEN 12 THEN zc_ObjectFloat_OrderType_Koeff12()
                                                                            END
                                             AND ObjectFloat_Koeff.ValueData <> 0
                        LEFT JOIN ObjectFloat AS ObjectFloat_TermProduction
                                              ON ObjectFloat_TermProduction.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                             AND ObjectFloat_TermProduction.DescId = zc_ObjectFloat_OrderType_TermProduction()
                                             AND ObjectFloat_TermProduction.ValueData <> 0
                        LEFT JOIN ObjectFloat AS ObjectFloat_NormInDays
                                              ON ObjectFloat_NormInDays.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                             AND ObjectFloat_NormInDays.DescId = zc_ObjectFloat_OrderType_NormInDays()
                                             AND ObjectFloat_NormInDays.ValueData <> 0
                        LEFT JOIN ObjectFloat AS ObjectFloat_StartProductionInDays
                                              ON ObjectFloat_StartProductionInDays.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                             AND ObjectFloat_StartProductionInDays.DescId = zc_ObjectFloat_OrderType_StartProductionInDays()
                       ;
     END IF;

     -- !!!������ ��� ������ �� ��������!!!
     IF inIsPack = TRUE AND (vbIsInsert = TRUE OR 1=1)
     THEN
         -- ��������� ����� � <���������>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReceiptBasis(), ioId, tmp.ReceiptId_basis)
               , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Receipt(),      ioId, tmp.ReceiptId)
               , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(),        ioId, ObjectLink_Receipt_Goods.ChildObjectId)
               , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKindComplete(), ioId, ObjectLink_Receipt_GoodsKind.ChildObjectId)
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_TermProduction(),         ioId, COALESCE (ObjectFloat_TermProduction.ValueData, 1))
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_NormInDays(),             ioId, COALESCE (ObjectFloat_NormInDays.ValueData, 2))
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_Koeff(),                  ioId, COALESCE (ObjectFloat_Koeff.ValueData, 1))
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_StartProductionInDays(),  ioId, COALESCE (ObjectFloat_StartProductionInDays.ValueData, 1))
         FROM (SELECT inGoodsId AS GoodsId) AS tmpGoods
              LEFT JOIN (SELECT inGoodsId AS GoodsId
                              , Object_Receipt.Id AS ReceiptId
                              , ObjectLink_Receipt_Parent_0.ChildObjectId AS ReceiptId_basis
                         FROM ObjectLink AS ObjectLink_Receipt_Goods
                              INNER JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                                    ON ObjectLink_Receipt_GoodsKind.ObjectId = ObjectLink_Receipt_Goods.ObjectId
                                                   AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()
                                                   AND ObjectLink_Receipt_GoodsKind.ChildObjectId = inGoodsKindId
                              INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_Receipt_Goods.ObjectId
                                                                 AND Object_Receipt.isErased = FALSE
                              INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                       ON ObjectBoolean_Main.ObjectId = Object_Receipt.Id
                                                      AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                                      AND ObjectBoolean_Main.ValueData = TRUE
                              LEFT JOIN ObjectLink AS ObjectLink_Receipt_Parent_0
                                                   ON ObjectLink_Receipt_Parent_0.ObjectId = Object_Receipt.Id
                                                  AND ObjectLink_Receipt_Parent_0.DescId = zc_ObjectLink_Receipt_Parent()
                              /*LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind_Parent_0
                                                   ON ObjectLink_Receipt_GoodsKind_Parent_0.ObjectId = ObjectLink_Receipt_Parent_0.ChildObjectId
                                                  AND ObjectLink_Receipt_GoodsKind_Parent_0.DescId = zc_ObjectLink_Receipt_GoodsKind()*/
                         WHERE ObjectLink_Receipt_Goods.ChildObjectId = inGoodsId
                           AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                        ) AS tmp ON tmp.GoodsId = inGoodsId


                        LEFT JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                             ON ObjectLink_Receipt_Goods.ObjectId = tmp.ReceiptId_basis
                                            AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                        LEFT JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                             ON ObjectLink_Receipt_GoodsKind.ObjectId = tmp.ReceiptId_basis
                                            AND ObjectLink_Receipt_GoodsKind.DescId = zc_ObjectLink_Receipt_GoodsKind()

                        LEFT JOIN ObjectLink AS ObjectLink_OrderType_Goods
                                             ON ObjectLink_OrderType_Goods.ChildObjectId = ObjectLink_Receipt_Goods.ChildObjectId
                                            AND ObjectLink_OrderType_Goods.DescId = zc_ObjectLink_OrderType_Goods()
                        LEFT JOIN ObjectFloat AS ObjectFloat_Koeff
                                              ON ObjectFloat_Koeff.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                             AND ObjectFloat_Koeff.DescId = CASE vbMonth WHEN 1 THEN zc_ObjectFloat_OrderType_Koeff1()
                                                                                         WHEN 2 THEN zc_ObjectFloat_OrderType_Koeff2()
                                                                                         WHEN 3 THEN zc_ObjectFloat_OrderType_Koeff3()
                                                                                         WHEN 4 THEN zc_ObjectFloat_OrderType_Koeff4()
                                                                                         WHEN 5 THEN zc_ObjectFloat_OrderType_Koeff5()
                                                                                         WHEN 6 THEN zc_ObjectFloat_OrderType_Koeff6()
                                                                                         WHEN 7 THEN zc_ObjectFloat_OrderType_Koeff7()
                                                                                         WHEN 8 THEN zc_ObjectFloat_OrderType_Koeff8()
                                                                                         WHEN 9 THEN zc_ObjectFloat_OrderType_Koeff9()
                                                                                         WHEN 10 THEN zc_ObjectFloat_OrderType_Koeff10()
                                                                                         WHEN 11 THEN zc_ObjectFloat_OrderType_Koeff11()
                                                                                         WHEN 12 THEN zc_ObjectFloat_OrderType_Koeff12()
                                                                            END
                                             AND ObjectFloat_Koeff.ValueData <> 0
                        LEFT JOIN ObjectFloat AS ObjectFloat_TermProduction
                                              ON ObjectFloat_TermProduction.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                             AND ObjectFloat_TermProduction.DescId = zc_ObjectFloat_OrderType_TermProduction()
                                             AND ObjectFloat_TermProduction.ValueData <> 0
                        LEFT JOIN ObjectFloat AS ObjectFloat_NormInDays
                                              ON ObjectFloat_NormInDays.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                             AND ObjectFloat_NormInDays.DescId = zc_ObjectFloat_OrderType_NormInDays()
                                             AND ObjectFloat_NormInDays.ValueData <> 0
                        LEFT JOIN ObjectFloat AS ObjectFloat_StartProductionInDays
                                              ON ObjectFloat_StartProductionInDays.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                             AND ObjectFloat_StartProductionInDays.DescId = zc_ObjectFloat_OrderType_StartProductionInDays()
                       ;
     END IF;


     -- !!!������ ��� ������ �����!!!
     IF inIsPack IS NULL AND (vbIsInsert = TRUE OR 1=1)
     THEN
         -- ��������� ����� � <���������>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Receipt(), ioId, tmp.ReceiptId)
         FROM (SELECT inGoodsId AS GoodsId) AS tmpGoods
              LEFT JOIN (SELECT inGoodsId AS GoodsId
                              , Object_Receipt.Id AS ReceiptId
                         FROM ObjectLink AS ObjectLink_Receipt_Goods
                              INNER JOIN Object AS Object_Receipt ON Object_Receipt.Id = ObjectLink_Receipt_Goods.ObjectId
                                                                 AND Object_Receipt.isErased = FALSE
                              INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                       ON ObjectBoolean_Main.ObjectId = Object_Receipt.Id
                                                      AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Receipt_Main()
                                                      AND ObjectBoolean_Main.ValueData = TRUE
                         WHERE ObjectLink_Receipt_Goods.ChildObjectId = inGoodsId
                           AND ObjectLink_Receipt_Goods.DescId = zc_ObjectLink_Receipt_Goods()
                        ) AS tmp ON tmp.GoodsId = inGoodsId
                       ;
     END IF;


     -- ��������� ��������
     PERFORM lpInsertUpdate_MovementItemFloat (inDescId_Param, ioId, inAmount_Param);
     -- ��������� ��������
     IF inDescId_ParamOrder <> 0
     THEN
         PERFORM lpInsertUpdate_MovementItemFloat (inDescId_ParamOrder, ioId, inAmount_ParamOrder);
     END IF;
     -- ��������� ��������
     IF inDescId_ParamSecond <> 0
     THEN
         PERFORM lpInsertUpdate_MovementItemFloat (inDescId_ParamSecond, ioId, inAmount_ParamSecond);
     END IF;

     -- ��������� ��������
     -- !!!��� � �� ����� ����!!! PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.03.16                                        *
 19.06.15                                        * all
 02.03.15         *
*/
/*
                              SELECT lpUpdate_MI_OrderInternal_Property (
                                                   ioId                 := MovementItem.Id
                                                 , inMovementId         := MovementItem.MovementId
                                                 , inGoodsId            := MovementItem.ObjectId
                                                 , inGoodsKindId        := MILinkObject_GoodsKind.ObjectId
                                                 , inAmount_Param       := COALESCE (MIFloat_AmountPartner.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_Param       := zc_MIFloat_AmountPartner()
                                                 , inAmount_ParamOrder  := COALESCE (MIFloat_AmountPartnerPrior.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_ParamOrder  := zc_MIFloat_AmountPartnerPrior()
                                                 , inAmount_ParamSecond := COALESCE (MIFloat_AmountPartnerSecond.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_ParamSecond := zc_MIFloat_AmountPartnerSecond()
                                                 , inIsPack             := NULL
                                                 , inUserId             := 5
                                                  )
                                   , MovementItem.*

                              FROM MovementItem
                                   INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                             AND Movement.DescId = zc_Movement_OrderInternal()
                                             AND Movement.OperDate between '01.03.2017'  and '31.03.2017' 
                                             AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                   inner JOIN MovementLinkObject AS MovementLinkObject_From
                                                                ON MovementLinkObject_From.MovementId = Movement.Id
                                                               AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                               and MovementLinkObject_from.ObjectId in (8447 )
                                   inner JOIN MovementLinkObject AS MovementLinkObject_to
                                                                ON MovementLinkObject_to.MovementId = Movement.Id
                                                               AND MovementLinkObject_to.DescId = zc_MovementLinkObject_To()
                                                               AND MovementLinkObject_to.ObjectId = MovementLinkObject_from.ObjectId

                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountRemains
                                                               ON MIFloat_AmountRemains.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountRemains.DescId = zc_MIFloat_AmountRemains()
                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                               ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerPrior
                                                               ON MIFloat_AmountPartnerPrior.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountPartnerPrior.DescId = zc_MIFloat_AmountPartnerPrior()
                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerSecond
                                                               ON MIFloat_AmountPartnerSecond.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountPartnerSecond.DescId = zc_MIFloat_AmountPartnerSecond()
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                        ON ObjectLink_Goods_Measure.ObjectId = MovementItem.Id
                                                       AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                   LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                         ON ObjectFloat_Weight.ObjectId = MovementItem.Id
                                                        AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                              WHERE MovementItem.MovementId = 5609806
                                AND MovementItem.DescId     = zc_MI_Master()
                                AND MovementItem.isErased   = FALSE
*/
-- ����
-- SELECT * FROM lpUpdate_MI_OrderInternal_Property (ioId:= 10696633, inMovementId:= 869524, inGoodsId:= 7402,  inGoodsKindId := 8328 , inAmount:= 45::TFloat, inAmountParam:= 777::TFloat, inDescCode:= 'zc_MIFloat_AmountRemains'::TVarChar, inSession:= lpCheckRight ('5', zc_Enum_Process_InsertUpdate_MI_OrderExternal()))
