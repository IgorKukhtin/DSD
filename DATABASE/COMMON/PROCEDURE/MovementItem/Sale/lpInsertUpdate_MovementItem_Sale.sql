-- Function: gpInsertUpdate_MovementItem_Sale()

-- DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale_BBB(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TFloat, TFloat, TFloat, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Sale(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TFloat, TFloat, TFloat, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Sale(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inAmountPartner       TFloat    , -- ���������� � �����������
    IN inAmountChangePercent TFloat    , -- ���������� c ������ % ������
    IN inChangePercentAmount TFloat    , -- % ������ ��� ���-��
 INOUT ioPrice               TFloat    , -- ����
 INOUT ioCountForPrice       TFloat    , -- ���� �� ����������
   OUT outAmountSumm         TFloat    , -- ����� ���������
    IN inHeadCount           TFloat    , -- ���������� �����
    IN inBoxCount            TFloat    , -- ���������� ������
    IN inPartionGoods        TVarChar  , -- ������ ������
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inAssetId             Integer   , -- �������� �������� (��� ������� ���������� ���)
    IN inBoxId               Integer   , -- �����
    IN inCountPack           TFloat    , -- ���������� �������� (������)
    IN inWeightTotal         TFloat    , -- ��� 1 ��. ��������� + ��������
    IN inWeightPack          TFloat    , -- ��� �������� ��� 1-�� ��. ���������
    IN inIsBarCode           Boolean   , -- �� �������,  �.�. ��� ������� ������ ��� (�� ��������), ��� ���� Amount - ������ ���������
   OUT outMovementId_Promo   Integer   ,
   OUT outPricePromo         TFloat    ,
   IN inUserId              Integer     -- ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbPriceWithVAT Boolean;
   DECLARE vbChangePercent TFloat;
   DECLARE vbIsChangePercent_Promo Boolean;
   DECLARE vbTaxPromo TFloat;
   DECLARE vbCountForPricePromo TFloat;
   DECLARE vbPartnerId Integer;
   DECLARE vbMovementId_Order Integer;
BEGIN
     -- ������
     vbMovementId_Order:= (SELECT MLM.MovementChildId FROM MovementLinkMovement AS MLM WHERE MLM.MovementId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Order());
     -- ����������
     vbPartnerId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To());
     -- ���� � ���
     vbPriceWithVAT:= (SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_PriceWithVAT());
     -- ��������� �����
     SELECT tmp.MovementId, CASE WHEN tmp.TaxPromo <> 0 AND vbPriceWithVAT = TRUE THEN tmp.PriceWithVAT_orig
                                 WHEN tmp.TaxPromo <> 0 THEN tmp.PriceWithOutVAT_orig
                                 ELSE 0
                            END
          , tmp.CountForPrice
          , tmp.TaxPromo
          , tmp.isChangePercent
            INTO outMovementId_Promo, outPricePromo, vbCountForPricePromo, vbTaxPromo, vbIsChangePercent_Promo
     FROM lpGet_Movement_Promo_Data (inOperDate   := CASE WHEN vbMovementId_Order <> 0
                                                           AND TRUE = (SELECT ObjectBoolean_OperDateOrder.ValueData
                                                                       FROM ObjectLink AS ObjectLink_Juridical
                                                                            INNER JOIN ObjectLink AS ObjectLink_Retail
                                                                                                  ON ObjectLink_Retail.ObjectId = ObjectLink_Juridical.ChildObjectId
                                                                                                 AND ObjectLink_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                                            INNER JOIN ObjectBoolean AS ObjectBoolean_OperDateOrder
                                                                                                     ON ObjectBoolean_OperDateOrder.ObjectId = ObjectLink_Retail.ChildObjectId
                                                                                                    AND ObjectBoolean_OperDateOrder.DescId = zc_ObjectBoolean_Retail_OperDateOrder()
                                                                       WHERE ObjectLink_Juridical.ObjectId = vbPartnerId
                                                                         AND ObjectLink_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                                                      )
                                                                THEN (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_Order)
                                                          ELSE (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_OperDatePartner())
                                                     END
                                   , inPartnerId  := vbPartnerId
                                   , inContractId := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                   , inUnitId     := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From())
                                   , inGoodsId    := inGoodsId
                                   , inGoodsKindId:= inGoodsKindId) AS tmp;

     -- (-)% ������ (+)% �������
     vbChangePercent:= CASE WHEN COALESCE (vbIsChangePercent_Promo, TRUE) = TRUE THEN COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_ChangePercent()), 0) ELSE 0 END;
     

     -- !!!������ ��� �����!!
     IF outMovementId_Promo > 0
     THEN
        IF NOT EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = outMovementId_Promo AND MB.DescId = zc_MovementBoolean_Promo() AND MB.ValueData = TRUE)
        THEN
              -- �������� �������� - ��� �������
             ioPrice:= outPricePromo;

        ELSEIF COALESCE (ioId, 0) = 0 AND vbTaxPromo <> 0
        THEN
              -- �������� ��������
             ioPrice:= outPricePromo;
             ioCountForPrice:= vbCountForPricePromo;

        ELSE -- ������ ��������
             IF ioId <> 0 AND (ioPrice + 0.06) < outPricePromo AND vbTaxPromo <> 0
             THEN
                 RAISE EXCEPTION '������.��� ������ = <%> <%> ���������� ������ ��������� ���� = <%>.', lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData_sh (inGoodsKindId), zfConvert_FloatToString (outPricePromo);
             END IF;
        END IF;

     -- ELSE !!!������� �� ������ ���� �� ����������!!!!
     END IF;

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- ��������� �������� <MovementId-�����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PromoMovementId(), ioId, COALESCE (outMovementId_Promo, 0));

     -- ��������� �������� <���������� � �����������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), ioId, inAmountPartner);
     -- ��������� �������� <���������� c ������ % ������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountChangePercent(), ioId, inAmountChangePercent);
     -- ��������� �������� <% ������ ��� ���-��>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercentAmount(), ioId, inChangePercentAmount);
     -- ��������� �������� <(-)% ������ (+)% �������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), ioId, vbChangePercent);

     -- ��������� �������� <����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, ioPrice);

     -- ��������� �������� <���� �� ����������>
     IF COALESCE (ioCountForPrice, 0) = 0 THEN ioCountForPrice := 1; END IF;
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, ioCountForPrice);

     -- ��������� �������� <���������� �����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_HeadCount(), ioId, inHeadCount);

     -- ��������� �������� <���������� ������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_BoxCount(), ioId, inBoxCount);

     -- ��������� �������� <������ ������>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), ioId, inPartionGoods);

     -- ��������� �������� <���������� �������� (������)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountPack(), ioId, inCountPack);
     -- ��������� �������� <��� 1 ��. ��������� + ��������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightTotal(), ioId, inWeightTotal);
     -- ��������� �������� <��� �������� ��� 1-�� ��. ���������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WeightPack(), ioId, inWeightPack);

     -- ��������� �������� <�� �������>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_BarCode(), ioId, inIsBarCode);


     -- ��������� ����� � <���� �������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);

     -- ��������� ����� � <�������� �������� (��� ������� ���������� ���)>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Asset(), ioId, inAssetId);

     -- ��������� ����� � <�����>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box(), ioId, inBoxId);

     IF inGoodsId <> 0
     THEN
         -- ������� ������ <����� ������ � ���� �������>
         PERFORM lpInsert_Object_GoodsByGoodsKind (inGoodsId, inGoodsKindId, inUserId);
     END IF;

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovemenTFloat_TotalSumm (inMovementId);

     -- ��������� ����� �� ��������, ��� �����
     outAmountSumm := CASE WHEN ioCountForPrice > 0
                                THEN CAST (inAmountPartner * ioPrice / ioCountForPrice AS NUMERIC (16, 2))
                           ELSE CAST (inAmountPartner * ioPrice AS NUMERIC (16, 2))
                      END;

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 13.11.15                                        *
 10.10.14                                                       * add box
 07.05.14                                        * add lpInsert_MovementItemProtocol
 08.02.14                                        *
 04.02.14                         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItem_Sale (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, ioPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
