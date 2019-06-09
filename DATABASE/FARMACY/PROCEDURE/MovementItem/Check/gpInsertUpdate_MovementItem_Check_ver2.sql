 -- Function: gpinsertupdate_movementitem_check_ver2()

-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Check_ver2 (Integer, Integer, Integer, TFloat, TFloat, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Check_ver2 (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Check_ver2 (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Check_ver2 (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar, TVarChar, TVarChar);

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
    -- !!!��������!!!
    IF COALESCE (inUserSession, '') <> '' AND inUserSession <> '5'
    THEN
        inSession := inUserSession;
    END IF;

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
    vbUserId := lpGetUserBySession (inSession);


    -- ������� ������� �� ��������� � ������
    IF COALESCE (ioId, 0) = 0
       OR NOT EXISTS (SELECT 1 FROM MovementItem WHERE Id = ioId)
    THEN
        IF COALESCE (inPrice, 0) = 0
        THEN
            -- ����������, ������, ������� �� ���� ������ - ���
            ioId:= (SELECT MovementItem.Id
                    FROM MovementItem
                         LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                     ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                    AND MIFloat_Price.DescId         = zc_MIFloat_Price()
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.ObjectId   = inGoodsId
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND MovementItem.isErased   = FALSE
                      AND COALESCE (MIFloat_Price.ValueData, 0) = inPrice
                   );
        ELSE
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
        -- ���� �� ����� ������� � ������ �����, ���� ����� ������ �������
        IF COALESCE(ioID, 0) = 0
        THEN
            ioId:= (SELECT MovementItem.Id
                    FROM MovementItem
                         INNER JOIN MovementItemFloat AS MIFloat_Price
                                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                     -- ���������� ���� � ���������� ����� �����������
                                                     -- AND MIFloat_Price.ValueData = inPrice
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.ObjectId   = inGoodsId
                      AND MovementItem.DescId     = zc_MI_Master()
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
      PERFORM lpInsertUpdate_MovementItemLinkContainer(inMovementItemId := ioId, inUserId := vbUserId);
    ELSE
      IF EXISTS(SELECT * FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescID = zc_MI_Child() AND MovementItem.ParentId = ioId)
      THEN
        UPDATE MovementItem SET isErased = True, Amount = 0
        WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescID = zc_MI_Child() AND MovementItem.ParentId = ioId;
      END IF;
    END IF;


    -- ��������� �������� <UID ������ �������>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_UID(), ioId, inList_UID);

    -- ��������� ����� � <���������� �����> + ����� �� � ������������ <���������� �����>
    -- PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_DiscountCard(), ioId, lpInsertFind_Object_DiscountCard (inObjectId:= inDiscountExternalId, inValue:= inDiscountCardNumber, inUserId:= vbUserId));

    -- ����������� �������� �����
    PERFORM lpInsertUpdate_MovementFloat_TotalSummCheck (inMovementId);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);


    -- !!!�������� ��� �����!!!
    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION '���� ������ ������� ��� <%> <%> <%>', inUserSession, inSession, inList_UID;
    END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_Check_ver2 (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar) OWNER TO postgres;

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

/*
-- ������ � ������ - ������
-- update MovementItemFloat set ValueData = tmp.new2  from (
-- select lpInsertUpdate_MovementFloat_TotalSummCheck (tmp.Id) from (select distinct Movement.Id

select MIFloat_SummChangePercent.*,  MovementItem.Amount * (COALESCE (MIFloat_PriceSale.ValueData, 0) - COALESCE (MIFloat_Price.ValueData, 0)) as new
                                  , ROUND (MovementItem.Amount * (COALESCE (MIFloat_PriceSale.ValueData, 0) - COALESCE (MIFloat_Price.ValueData, 0)), 4) as new2
-- , Movement.*, Object_Unit.*
from Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

     inner join MovementItem on MovementItem.MovementId = Movement.Id
                               and MovementItem.isErased = false
           inner JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                        ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummChangePercent.DescId = zc_MIFloat_SummChangePercent()
                                       AND MIFloat_SummChangePercent.ValueData <> 0

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                        ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()

where Movement.OperDate between '01.04.2017'  and '01.06.2017'
  and Movement.DescId = zc_Movement_Check()
-- and MIFloat_SummChangePercent.ValueData <>  MovementItem.Amount * (COALESCE (MIFloat_PriceSale.ValueData, 0) - COALESCE (MIFloat_Price.ValueData, 0))
and MIFloat_SummChangePercent.ValueData <>  ROUND (MovementItem.Amount * (COALESCE (MIFloat_PriceSale.ValueData, 0) - COALESCE (MIFloat_Price.ValueData, 0)) , 4)
-- and MovementItem .Amount = 0

 -- ) as tmp
 -- where MovementItemFloat .MovementItemId = tmp.MovementItemId  and MovementItemFloat .DescId = tmp.DescId


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