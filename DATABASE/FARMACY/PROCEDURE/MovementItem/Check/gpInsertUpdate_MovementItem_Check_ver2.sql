 -- Function: gpInsertUpdate_MovementItem_Income()

-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Check_ver2 (Integer, Integer, Integer, TFloat, TFloat, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Check_ver2 (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Check_ver2 (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Check_ver2(
 INOUT ioId                  Integer   , -- ���� ������� <������ ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inPrice               TFloat    , -- ����
    IN inPriceSale           TFloat    , -- ���� ��� ������
    IN inChangePercent       TFloat    , -- % ������
    IN inSummChangePercent   TFloat    , -- ����� ������
    IN inList_UID            TVarChar  , -- UID ������
    -- IN inDiscountExternalId  Integer  DEFAULT 0,  -- ������ ���������� ����
    -- IN inDiscountCardNumber  TVarChar DEFAULT '', -- � ���������� �����
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
    if coalesce(inUserSession, '') <> '' then 
     inSession := inUserSession;
    end if;
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
    vbUserId := lpGetUserBySession (inSession);


    -- ������� ������� �� ��������� � ������
    IF COALESCE (ioId, 0) = 0
       OR NOT EXISTS (SELECT 1 FROM MovementItem WHERE Id = ioId)
    THEN
        ioId:= (SELECT MovementItem.Id
                FROM MovementItem
                     INNER JOIN MovementItemFloat AS MIFloat_Price
                                                  ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                 AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                 AND MIFloat_Price.ValueData = inPrice
                WHERE MovementItem.MovementId = inMovementId 
                  AND MovementItem.ObjectId   = inGoodsId 
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND MovementItem.isErased   = FALSE
               );
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

    -- ��������� �������� <����� ������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent(), ioId, inSummChangePercent);

    -- ��������� �������� <UID ������ �������>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_UID(), ioId, inList_UID);

    -- ��������� ����� � <���������� �����> + ����� �� � ������������ <���������� �����>
    -- PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_DiscountCard(), ioId, lpInsertFind_Object_DiscountCard (inObjectId:= inDiscountExternalId, inValue:= inDiscountCardNumber, inUserId:= vbUserId));

    -- ����������� �������� �����
    PERFORM lpInsertUpdate_MovementFloat_TotalSummCheck (inMovementId);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_Check_ver2 (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 10.08.16                                                                        *��������� �������� <UID ������ �������>
 08.08.16                                        *
 03.11.2015                                                                      *
 07.08.2015                                                                      *
 26.05.15                        *
*/

/*
select lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceSale(), MovementItem.Id, MIFloat_Price.ValueData)
, *
from Movement
     inner join MovementItem on MovementId = Movement.Id and MovementItem.DescId = zc_MI_Master()
            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                        ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
where Movement.descId = zc_Movement_Check()
and Movement.OperDate >= '01.08.2016'
and MIFloat_PriceSale.MovementItemId is null
*/