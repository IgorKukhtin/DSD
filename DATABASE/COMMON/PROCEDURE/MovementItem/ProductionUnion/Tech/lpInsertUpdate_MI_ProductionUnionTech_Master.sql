-- Function: lpInsertUpdate_MI_ProductionUnionTech_Master()

--DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnionTech_Master (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnionTech_Master (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnionTech_Master (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnionTech_Master (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnionTech_Master (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnionTech_Master (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_ProductionUnionTech_Master(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inCount	             TFloat    , -- ���������� ������� ��� �������� 
    IN inCountReal           TFloat    , -- ���������� ��. ���� ������ ��� ����� "�������"
    IN inRealWeight          TFloat    , -- ����������� ���(������������)
    IN inRealWeightMsg       TFloat    , -- ����������� ���(����� ���������)
    IN inRealWeightShp       TFloat    , -- ����������� ���(����� �����������)
    IN inCuterCount          TFloat    , -- ���������� �������
    IN inCuterWeight         TFloat    , -- ��� �/� ����(������) 
    IN inAmountForm          TFloat    , -- ���-�� ��������+1����,��
    IN inAmountForm_two      TFloat    , -- ���-�� ��������+2����,��
    IN inComment             TVarChar  , -- ����������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inGoodsKindCompleteId Integer   , -- ���� �������  ��
    IN inReceiptId           Integer   , -- ���������
    IN inUserId              Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
  DECLARE vbIsInsert Boolean;
BEGIN
   -- ������������ ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- ��������� <������� ���������>
   ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

   -- ��������� ����� � <���������>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Receipt(), ioId, inReceiptId);
   -- ��������� ����� � <���� �������>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
   -- ��������� ����� � <���� ������� ��>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKindComplete(), ioId, inGoodsKindCompleteId);

   -- ��������� �������� <������ ������� (��/���)>
   -- PERFORM lpInsertUpdate_MovementItemBoolean(zc_MIBoolean_PartionClose(), ioId, inPartionClose);

   -- ��������� �������� <����������>
   PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

   -- ��������� �������� <���������� �������>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Count(), ioId, inCount);

   -- ��������� �������� <���������� ��. ���� ������ ��� ����� "�������">
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountReal(), ioId, inCountReal);

   -- ��������� �������� <����������� ���(������������)>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RealWeight(), ioId, inRealWeight);
   -- ��������� �������� <���������� �������>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CuterCount(), ioId, inCuterCount);
   -- ��������� �������� <��� �/� ����(������)>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CuterWeight(), ioId, inCuterWeight);

   -- ��������� �������� <���-�� ��������+1����,��>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountForm(), ioId, inAmountForm);
   -- ��������� �������� <���-�� ��������+2����,��>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountForm_two(), ioId, inAmountForm_two);


   -- ������ ������ ������������� ����������� ����� ��������� �  ����� ����������� ������������ �����: �������� �. + ������� �.
   IF inUserId IN (9031170, 954882)
      -- ����������� 7 ���� ��-�� (��������)
      OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  AS UserRole_View WHERE UserRole_View.UserId = inUserId AND UserRole_View.RoleId = 11841068)
   THEN
       IF inRealWeightMsg <> COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_RealWeightMsg()), 0)
       THEN
           RAISE EXCEPTION '������.��� ���� �������� �������� <%> %� <%> �� <%>'
                         , (SELECT MovementItemFloatDesc.ItemName FROM MovementItemFloatDesc WHERE MovementItemFloatDesc.Id = zc_MIFloat_RealWeightMsg())
                         , CHR (13)
                         , zfConvert_FloatToString (COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_RealWeightMsg()), 0))
                         , zfConvert_FloatToString (inRealWeightMsg)
                            ;
       END IF;

       IF inRealWeightShp <> COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_RealWeightShp()), 0)
       THEN
           RAISE EXCEPTION '������.��� ���� �������� �������� <%> %� <%> �� <%>'
                         , (SELECT MovementItemFloatDesc.ItemName FROM MovementItemFloatDesc WHERE MovementItemFloatDesc.Id = zc_MIFloat_RealWeightShp())
                         , CHR (13)
                         , zfConvert_FloatToString (COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_RealWeightShp()), 0))
                         , zfConvert_FloatToString (inRealWeightShp)
                            ;
       END IF;

   ELSE
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RealWeightMsg(), ioId, inRealWeightMsg);
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_RealWeightShp(), ioId, inRealWeightShp);
   END IF;


   IF vbIsInsert = TRUE
   THEN
       -- ��������� ����� � <>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, inUserId);
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
   ELSE
       -- ��������� ����� � <>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), ioId, inUserId);
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), ioId, CURRENT_TIMESTAMP);
   END IF;

   -- ����������� �������� ����� �� ���������
   PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

   -- ��������� ��������
   PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.03.25         * inAmountForm_two
 30.07.24         * inAmountForm
 25.10.23         *
 13.09.22         * inCountReal
 02.12.20         *
 21.03.15                                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MI_ProductionUnionTech_Master (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')
