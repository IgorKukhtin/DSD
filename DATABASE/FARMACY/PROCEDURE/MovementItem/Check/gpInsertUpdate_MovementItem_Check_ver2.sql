 -- Function: gpinsertupdate_movementitem_check_ver2()

-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Check_ver2 (Integer, Integer, Integer, TFloat, TFloat, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Check_ver2 (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Check_ver2 (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Check_ver2 (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Check_ver2 (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TFloat, TVarChar, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Check_ver2 (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TFloat, Integer, TVarChar, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Check_ver2 (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TFloat, Integer, Integer, TVarChar, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Check_ver2 (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TFloat, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Check_ver2 (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TFloat, Integer, Integer, Integer, Boolean, TVarChar, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Check_ver2 (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TFloat, Integer, Integer, Integer, Boolean, Integer, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Check_ver2 (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TFloat, Integer, Integer, Integer, Boolean, Integer, Integer, Boolean, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Check_ver2 (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TFloat, Integer, Integer, Integer, Boolean, Integer, Integer, Boolean, TVarChar, TVarChar, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Check_ver2(
 INOUT ioId                  Integer   , -- ���� ������� <������ ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inPrice               TFloat    , -- ����
    IN inPriceSale           TFloat    , -- ���� ��� ������
    IN inChangePercent       TFloat    , -- % ������
    IN inSummChangePercent   TFloat    , -- ����� ������
    IN inPartionDateKindID   Integer   , -- ��� ����/�� ����
    IN inPricePartionDate    TFloat    , -- ���� ��������� �������� �����
    IN inNDSKindId           Integer   , -- ������ ���
    IN inDiscountExternalId  Integer   , -- ������ ���������� ����
    IN inDivisionPartiesID   Integer   , -- ���������� ������ � ����� ��� �������
    IN inPresent             Boolean   , -- �������
    IN inJuridicalId         Integer   , -- ��������� ����� ����������
    IN inGoodsPresentId      Integer   , -- ��������� �����
    IN inisGoodsPresent      Boolean   , -- ��������� �������
    IN inIdSP                TVarChar  , -- ID ����. ������ ��� ��
    IN inList_UID            TVarChar  , -- UID ������
    in inUserSession	     TVarChar  , -- ������ ������������ (��������� ��������)
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbUnitId Integer;
   DECLARE vbReserve TFloat;
   DECLARE vbRemains TFloat;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- !!!��������!!!
    IF COALESCE (inUserSession, '') <> '' AND inUserSession <> '5'
    THEN
        inSession := inUserSession;
    END IF;

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
    vbUserId := lpGetUserBySession (inSession);

    IF COALESCE (inNDSKindId, 0) = 0
    THEN
      inNDSKindId := COALESCE((SELECT Object_Goods_Main.NDSKindId FROM  Object_Goods_Retail
                                      LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                               WHERE Object_Goods_Retail.Id = inGoodsId), zc_Enum_NDSKind_Medical());

    END IF;

    -- ������� ������� �� ��������� � ������
    IF COALESCE (ioId, 0) = 0
       OR NOT EXISTS (SELECT 1 FROM MovementItem WHERE Id = ioId)
    THEN
        IF COALESCE (inPrice, 0) = 0
        THEN
            -- ����������, ������, ������� �� ���� ������ - ���
            ioId:= (SELECT MAX(MovementItem.Id)
                    FROM MovementItem
                         LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                     ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                    AND MIFloat_Price.DescId         = zc_MIFloat_Price()
                         LEFT JOIN MovementItemBoolean AS MIBoolean_Present
                                                       ON MIBoolean_Present.MovementItemId = MovementItem.Id
                                                      AND MIBoolean_Present.DescId         = zc_MIBoolean_Present()
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionDateKind
                                                          ON MILinkObject_PartionDateKind.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_PartionDateKind.DescId         = zc_MILinkObject_PartionDateKind()
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_DivisionParties
                                                          ON MILinkObject_DivisionParties.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_DivisionParties.DescId = zc_MILinkObject_DivisionParties()
                         LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = MovementItem.ObjectId
                         LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = Object_Goods_Retail.GoodsMainId
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_NDSKind
                                                          ON MILinkObject_NDSKind.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_NDSKind.DescId = zc_MILinkObject_NDSKind()

                         LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsPresent
                                                          ON MILinkObject_GoodsPresent.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_GoodsPresent.DescId = zc_MILinkObject_GoodsPresent()
                         LEFT JOIN MovementItemBoolean AS MIBoolean_GoodsPresent
                                                       ON MIBoolean_GoodsPresent.MovementItemId = MovementItem.Id
                                                      AND MIBoolean_GoodsPresent.DescId         = zc_MIBoolean_GoodsPresent()

                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.ObjectId   = inGoodsId
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND MovementItem.isErased   = FALSE
                      AND COALESCE (MILinkObject_PartionDateKind.ObjectId, 0) = COALESCE (inPartionDateKindID, 0)
                      AND COALESCE (MILinkObject_NDSKind.ObjectId, Object_Goods.NDSKindId) = COALESCE (inNDSKindId, 0)
                      AND COALESCE (MILinkObject_DivisionParties.ObjectId, 0) = COALESCE (inDivisionPartiesID, 0)
                      AND COALESCE (MIFloat_Price.ValueData, 0) = inPrice
                      AND COALESCE (MIBoolean_Present.ValueData, False) = COALESCE(inPresent, False)
                      /*AND COALESCE (MILinkObject_GoodsPresent.ObjectId, 0) = COALESCE (inGoodsPresentID, 0)*/
                      AND COALESCE (MIBoolean_GoodsPresent.ValueData, False) = COALESCE(inisGoodsPresent, False)
                   );
        ELSE
            ioId:= (SELECT MAX(MovementItem.Id)
                    FROM MovementItem
                         INNER JOIN MovementItemFloat AS MIFloat_Price
                                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                     AND MIFloat_Price.ValueData = inPrice
                         LEFT JOIN MovementItemBoolean AS MIBoolean_Present
                                                       ON MIBoolean_Present.MovementItemId = MovementItem.Id
                                                      AND MIBoolean_Present.DescId         = zc_MIBoolean_Present()
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionDateKind
                                                          ON MILinkObject_PartionDateKind.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_PartionDateKind.DescId         = zc_MILinkObject_PartionDateKind()
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_DivisionParties
                                                          ON MILinkObject_DivisionParties.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_DivisionParties.DescId = zc_MILinkObject_DivisionParties()

                         LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = MovementItem.ObjectId
                         LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = Object_Goods_Retail.GoodsMainId
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_NDSKind
                                                          ON MILinkObject_NDSKind.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_NDSKind.DescId = zc_MILinkObject_NDSKind()                                                         

                         LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsPresent
                                                          ON MILinkObject_GoodsPresent.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_GoodsPresent.DescId = zc_MILinkObject_GoodsPresent()
                         LEFT JOIN MovementItemBoolean AS MIBoolean_GoodsPresent
                                                       ON MIBoolean_GoodsPresent.MovementItemId = MovementItem.Id
                                                      AND MIBoolean_GoodsPresent.DescId         = zc_MIBoolean_GoodsPresent()
                                                         
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.ObjectId   = inGoodsId
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND COALESCE (MILinkObject_PartionDateKind.ObjectId, 0) = COALESCE (inPartionDateKindID, 0)
                      AND COALESCE (MILinkObject_NDSKind.ObjectId, Object_Goods.NDSKindId) = COALESCE (inNDSKindId, 0)
                      AND COALESCE (MILinkObject_DivisionParties.ObjectId, 0) = COALESCE (inDivisionPartiesID, 0)
                      AND COALESCE (MIBoolean_Present.ValueData, False) = COALESCE(inPresent, False)
                      /*AND COALESCE (MILinkObject_GoodsPresent.ObjectId, 0) = COALESCE (inGoodsPresentID, 0)*/
                      AND COALESCE (MIBoolean_GoodsPresent.ValueData, False) = COALESCE(inisGoodsPresent, False)
                      AND MovementItem.isErased   = FALSE
                   );
        END IF;
        -- ���� �� ����� ������� � ������ �����, ���� ����� ������ �������
        IF COALESCE(ioID, 0) = 0
        THEN
            ioId:= (SELECT Max(MovementItem.Id)
                    FROM MovementItem
                         INNER JOIN MovementItemFloat AS MIFloat_Price
                                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                     -- ���������� ���� � ���������� ����� �����������
                                                     -- AND MIFloat_Price.ValueData = inPrice
                         LEFT JOIN MovementItemBoolean AS MIBoolean_Present
                                                       ON MIBoolean_Present.MovementItemId = MovementItem.Id
                                                      AND MIBoolean_Present.DescId         = zc_MIBoolean_Present()
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionDateKind
                                                          ON MILinkObject_PartionDateKind.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_PartionDateKind.DescId         = zc_MILinkObject_PartionDateKind()
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_DivisionParties
                                                          ON MILinkObject_DivisionParties.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_DivisionParties.DescId = zc_MILinkObject_DivisionParties()
                         LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = MovementItem.ObjectId
                         LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = Object_Goods_Retail.GoodsMainId
                         LEFT JOIN MovementItemLinkObject AS MILinkObject_NDSKind
                                                          ON MILinkObject_NDSKind.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_NDSKind.DescId = zc_MILinkObject_NDSKind()

                         LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsPresent
                                                          ON MILinkObject_GoodsPresent.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_GoodsPresent.DescId = zc_MILinkObject_GoodsPresent()
                         LEFT JOIN MovementItemBoolean AS MIBoolean_GoodsPresent
                                                       ON MIBoolean_GoodsPresent.MovementItemId = MovementItem.Id
                                                      AND MIBoolean_GoodsPresent.DescId         = zc_MIBoolean_GoodsPresent()

                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.ObjectId   = inGoodsId
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND COALESCE (MILinkObject_PartionDateKind.ObjectId, 0) = COALESCE (inPartionDateKindID, 0)
                      AND COALESCE (MILinkObject_NDSKind.ObjectId, Object_Goods.NDSKindId) = COALESCE (inNDSKindId, 0)
                      AND COALESCE (MILinkObject_DivisionParties.ObjectId, 0) = COALESCE (inDivisionPartiesID, 0)
                      AND COALESCE (MIBoolean_Present.ValueData, False) = COALESCE(inPresent, False)
                      /*AND COALESCE (MILinkObject_GoodsPresent.ObjectId, 0) = COALESCE (inGoodsPresentID, 0)*/
                      AND COALESCE (MIBoolean_GoodsPresent.ValueData, False) = COALESCE(inisGoodsPresent, False)
                      AND MovementItem.isErased   = FALSE
                    LIMIT 1
                   );
        END IF;

    END IF;

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

    -- ��������� �������� <����>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);

    -- !!!������!!!
    IF COALESCE (inPriceSale, 0) = 0 AND COALESCE (inChangePercent, 0) = 0 AND COALESCE (inSummChangePercent, 0) = 0 THEN inPriceSale:= inPrice; END IF;
    -- ��������� �������� <���� ��� ������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceSale(), ioId, inPriceSale);

    -- ��������� �������� <% ������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), ioId, inChangePercent);

    -- ��������� �������� <>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent(), ioId, CASE WHEN inAmount = 0 THEN 0 ELSE inSummChangePercent END);

    -- ��������� �������� <��� ����/�� ����>
    IF COALESCE (inPartionDateKindID, 0) <> 0
    THEN
      PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionDateKind(), ioId, inPartionDateKindID);
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PricePartionDate(), ioId, inPricePartionDate);
      PERFORM lpInsertUpdate_MovementItemLinkContainer(inMovementItemId := ioId, inUserId := vbUserId);
    ELSE
      IF EXISTS(SELECT * FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescID = zc_MI_Child() AND MovementItem.ParentId = ioId)
      THEN
        UPDATE MovementItem SET isErased = True, Amount = 0
        WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescID = zc_MI_Child() AND MovementItem.ParentId = ioId;
      END IF;
    END IF;

    -- ��������� �������� <���>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_NDSKind(), ioId, inNDSKindId);

    -- ��������� �������� <UID ������ �������>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_UID(), ioId, inList_UID);

    -- ��������� ����� � <���������� �����>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_DiscountExternal(), ioId, COALESCE (inDiscountExternalId, 0));

    -- ��������� ����� � <���������� ������ � ����� ��� �������>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_DivisionParties(), ioId, COALESCE (inDivisionPartiesID, 0));
    
    -- ��������� �������� <�������>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Present(), ioId, inPresent);
    
    -- ��������� ����� � <��������� ����� ����������>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Juridical(), ioId, COALESCE (inJuridicalId, 0));

    -- ��������� ����� � <��������� �����>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsPresent(), ioId, COALESCE (inGoodsPresentId, 0));

    -- ��������� �������� <��������� �������>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_GoodsPresent(), ioId, inisGoodsPresent);


    -- ����������� �������� �����
    PERFORM lpInsertUpdate_MovementFloat_TotalSummCheck (inMovementId);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

    -- ��������� �������� <ID ����. ������ ��� ��>
    IF Trim(inIdSP) <> ''
    THEN
      PERFORM lpInsertUpdate_MovementItemString (zc_MIString_IdSP(), ioId, Trim(inIdSP));
    END IF;


    -- !!!�������� ��� �����!!!
    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION '���� ������ ������� ��� <%> <%> <%>', inUserSession, inSession, inIdSP;
    END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_Check_ver2 (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TFloat, Integer, Integer, Integer, Boolean, Integer, Integer, Boolean, TVarChar, TVarChar, TVarChar, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.   ������������ �.�.
 05.05.18                                                                                           *  � ����� ����� ���� ���� ����� � ���� ��������
 03.05.18                                                                                           *  �������� ������������ � ���������� ����� ��-�� ������ ����
 10.08.16                                                                        *��������� �������� <UID ������ �������>
 08.08.16                                        *
 03.11.2015                                                                      *
 07.08.2015                                                                      *
 26.05.15                        *
*/
