-- Function: gpInsertUpdate_MovementItem_Check_Site()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Check_Site (Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Check_Site(
 INOUT ioId                  Integer   , -- ���� ������� <������ ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inPrice               TFloat    , -- ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbObjectId   Integer;
   DECLARE vbIsInsert   Boolean;
   DECLARE vbAmount_old TFloat;
   DECLARE vbSiteDiscount TFloat;
   DECLARE vbPriceSale TFloat;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
    vbUserId := lpGetUserBySession (inSession);
    vbSiteDiscount := COALESCE (gpGet_GlobalConst_SiteDiscount(inSession), 0);
    
    inPrice := Round(inPrice, 2);

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
    -- ��������� �������� <���� �����������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceLoad(), ioId, inPrice);
     
    IF COALESCE(vbSiteDiscount, 0) = 0 THEN
      -- ��������� �������� <���� ��� ������>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceSale(), ioId, inPrice);
    ELSE
      SELECT ObjectFloat_Price_Value.ValueData AS Price
      INTO vbPriceSale
      FROM Movement
           INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()    
           INNER JOIN ObjectLink AS ObjectLink_Price_Goods
                                 ON ObjectLink_Price_Goods.ChildObjectId = inGoodsId
                                AND ObjectLink_Price_Goods.DescId        = zc_ObjectLink_Price_Goods()
           INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                 ON ObjectLink_Price_Unit.ObjectId      = ObjectLink_Price_Goods.ObjectId
                                AND ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                                AND ObjectLink_Price_Unit.ChildObjectId = MovementLinkObject_Unit.ObjectId
           LEFT JOIN ObjectFloat AS ObjectFloat_Price_Value
                                 ON ObjectFloat_Price_Value.ObjectId = ObjectLink_Price_Goods.ObjectId
                                AND ObjectFloat_Price_Value.DescId = zc_ObjectFloat_Price_Value()  
      WHERE  Movement.ID = inMovementId; 
    
      -- ��������� �������� <���� ��� ������>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceSale(), ioId, COALESCE(vbPriceSale, Round(inPrice * 100 / (100 - vbSiteDiscount), 2)));

      -- ��������� �������� <% ������>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), ioId, vbSiteDiscount);

      -- ��������� �������� <����� ������>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent(), ioId, CASE WHEN inAmount = 0 OR 
          inPrice = COALESCE(vbPriceSale, Round(inPrice * 100 / (100 - vbSiteDiscount), 2)) THEN 0 
          ELSE ROUND(ROUND(inAmount, 3) * COALESCE(vbPriceSale, Round(inPrice * 100 / (100 - vbSiteDiscount), 2)), 2) - ROUND(ROUND(inAmount, 3) * inPrice, 2) END);
    END IF;

    -- ����������� �������� �����
    PERFORM lpInsertUpdate_MovementFloat_TotalSummCheck (inMovementId);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_Check_Site(Integer, Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.  ������ �.�.
 29.01.19                                                                                      *
 17.12.2015                                                                      *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Check_Site (ioId:= 219344347, inMovementId:= 12604039, inGoodsId:= 51922, inAmount:= 2, inPrice:= 248.80, inSession := '3')