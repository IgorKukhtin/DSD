-- Function: gpInsertUpdate_MovementItem_PromoCodeCheck_Site()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_CheckPromoCode_Site (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_CheckPromoCode_Site (Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_CheckPromoCode_Site(
 INOUT ioId                  Integer   , -- ���� ������� <������ ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inPrice               TFloat    , -- ����
    IN inPriceSale           TFloat    , -- ���� ��� ������
    IN inPartionDateKindID   Integer   , -- ��� ����/�� ����
    IN inChangePercent       TFloat    , -- % ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbObjectId   Integer;
   DECLARE vbIsInsert   Boolean;
   DECLARE vbAmount_old TFloat;
   DECLARE vbPriceSale TFloat;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
    vbUserId := lpGetUserBySession (inSession);

    inPrice := Round(inPrice, 2);
    inPriceSale := Round(inPriceSale, 2);

    -- !!!������ ��� - ������������ <�������� ����>!!!
    vbObjectId:= (SELECT ObjectLink_Juridical_Retail.ChildObjectId
                  FROM ObjectLink AS ObjectLink_Unit_Juridical
                       INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                             ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                  WHERE ObjectLink_Unit_Juridical.ObjectId = (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Unit())
                    AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                 );

    -- !!!������, ����� � ��� ������ ����!!!
    inGoodsId:= (SELECT ObjectLink_Child.ChildObjectId
                 FROM ObjectLink AS ObjectLink_Child_NB
                      INNER JOIN ObjectLink AS ObjectLink_Main_NB ON ObjectLink_Main_NB.ObjectId = ObjectLink_Child_NB.ObjectId
                                                                 AND ObjectLink_Main_NB.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                      INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ChildObjectId = ObjectLink_Main_NB.ChildObjectId
                                                               AND ObjectLink_Main.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                      INNER JOIN ObjectLink AS ObjectLink_Child
                                            ON ObjectLink_Child.ObjectId = ObjectLink_Main.ObjectId
                                           AND ObjectLink_Child.DescId   = zc_ObjectLink_LinkGoods_Goods()
                      INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                            ON ObjectLink_Goods_Object.ObjectId      = ObjectLink_Child.ChildObjectId
                                           AND ObjectLink_Goods_Object.DescId        = zc_ObjectLink_Goods_Object()
                                           AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId -- !!!������ ����!!!
                 WHERE ObjectLink_Child_NB.ChildObjectId = inGoodsId -- ����� ������ ����� ���� ��
                   AND ObjectLink_Child_NB.DescId        = zc_ObjectLink_LinkGoods_Goods()
                );

    -- ��������
    IF COALESCE (inGoodsId, 0) = 0
    THEN
         RAISE EXCEPTION '������.����� ����� <%> �� ������ � �������� ���� <%>.', lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData (vbObjectId);
    END IF;


    -- ������� ������� �� ��������� � ������ � ����
    IF COALESCE(ioId,0) = 0
       OR NOT EXISTS(SELECT 1 FROM MovementItem WHERE Id = ioId)
    THEN
        SELECT MovementItem.Id, MovementItem.Amount
               INTO ioId, vbAmount_old
        FROM MovementItem
             INNER JOIN MovementItemFloat AS MIFloat_Price
                                          ON MIFloat_Price.MovementItemId = MovementItem.Id
                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                         AND MIFloat_Price.ValueData = inPrice
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.ObjectId   = inGoodsId
          AND MovementItem.DescId     = zc_MI_Master()
          AND MovementItem.isErased   = FALSE
         ;
    END IF;

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount + COALESCE (vbAmount_old, 0), NULL);

    -- ��������� �������� <���-�� ������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountOrder(), ioId, inAmount);
    -- ��������� �������� <����>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);

    -- ��������� �������� <���� ��� ������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceSale(), ioId, inPriceSale);

    -- ��������� �������� <% ������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), ioId, inChangePercent);

    -- ��������� �������� <����� ������>
    IF inPrice <> inPriceSale AND ROUND(ROUND(inAmount, 3) * inPriceSale, 2) - ROUND(ROUND(inAmount, 3) * inPrice, 2) > 0
    THEN
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent(), ioId, ROUND(ROUND(inAmount, 3) * inPriceSale, 2) - ROUND(ROUND(inAmount, 3) * inPrice, 2));
    END IF;

    -- ��������� �������� <��� ����/�� ����>
    IF COALESCE (inPartionDateKindID, 0) <> 0
    THEN
      PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionDateKind(), ioId, inPartionDateKindID);
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PricePartionDate(), ioId, inPrice);
      BEGIN
        PERFORM lpInsertUpdate_MovementItemLinkContainer(inMovementItemId := ioId, inUserId := vbUserId);
      EXCEPTION
         WHEN others THEN vbUserId := vbUserId;
      END;        
    ELSE
      IF EXISTS(SELECT * FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescID = zc_MI_Child() AND MovementItem.ParentId = ioId)
      THEN
        UPDATE MovementItem SET isErased = True, Amount = 0
        WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescID = zc_MI_Child() AND MovementItem.ParentId = ioId;
      END IF;
    END IF;

    -- ����������� �������� �����
    PERFORM lpInsertUpdate_MovementFloat_TotalSummCheck (inMovementId);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

    -- !!!�������� ��� �����!!!
    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION '���� ������ ������� ��� <%> <%>', inSession, inPartionDateKindID;
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_CheckPromoCode_Site(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������ �.�.
 30.01.19        *
 17.07.18        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_CheckPromoCode_Site (ioId:= 0, inMovementId:= 29342092, inGoodsId:= 51922, inAmount:= 1, inPrice:= 241.30, inPriceSale := 248.80, inPartionDateKindID := 14542625, inChangePercent := 3, inSession := '3')