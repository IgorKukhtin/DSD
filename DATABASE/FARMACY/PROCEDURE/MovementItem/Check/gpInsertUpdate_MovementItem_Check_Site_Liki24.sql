-- Function: gpInsertUpdate_MovementItem_Check_Site_Liki24()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Check_Site_Liki24 (Integer, Integer, TVarChar, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Check_Site_Liki24(
 INOUT ioId                  Integer   , -- ���� ������� <������ ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inItemId              TVarChar  , -- ID ������ ������ � ������
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
   DECLARE vbSiteDiscount TFloat;
   DECLARE vbPriceSale TFloat;
   DECLARE vbStatusId Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
    IF inSession = zfCalc_UserAdmin()
    THEN
      inSession = zfCalc_UserSite();
    END IF;
    
    vbUserId := lpGetUserBySession (inSession);

    IF COALESCE(inItemId, '') = ''
    THEN
        RAISE EXCEPTION '������. �� ��������� ID ������ ������ � ������';
    END IF;


    IF COALESCE(ioId,0) = 0 AND
       EXISTS(SELECT MovementItemString.MovementItemId FROM MovementItemString
              WHERE MovementItemString.DescId = zc_MIString_ItemId()
                AND MovementItemString.ValueData = inItemId)
    THEN
      SELECT MovementItemString.MovementItemId
      INTO ioId
      FROM MovementItemString
      WHERE MovementItemString.DescId = zc_MIString_ItemId()
        AND MovementItemString.ValueData = inItemId;
    END IF;

    SELECT StatusId
    INTO vbStatusId
    FROM Movement
    WHERE Id = inMovementId;

    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
      RETURN;
    END IF;

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
        SELECT MovementItem.Id
               INTO ioId
        FROM MovementItem
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.ObjectId   = inGoodsId
          AND MovementItem.DescId     = zc_MI_Master()
          AND MovementItem.isErased   = FALSE
         ;
    END IF;

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;
     
     inAmount := round(inAmount, 3);

    -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

    -- ��������� �������� <���-�� ������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountOrder(), ioId, inAmount);
    -- ��������� �������� <����>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
    -- ��������� �������� <���� ��� ������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceSale(), ioId, inPrice);
    -- ��������� �������� <Id ������ ������ � ������>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_ItemId(), ioId, inItemId);

    -- ����������� �������� �����
    PERFORM lpInsertUpdate_MovementFloat_TotalSummCheck (inMovementId);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

/*    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION '���� ������ ������� ��� <%> <%>', inItemId, inSession;
    END IF;
*/
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_Check_Site_Liki24(Integer, Integer, TVarChar, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 18.06.20                                                       *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Check_Site_Liki24 (ioId:= 0, inMovementId:= 19235565 , inItemId := '1111111',  inGoodsId:= 36085, inAmount:= 2, inPrice:= 248.80, inSession := '3')