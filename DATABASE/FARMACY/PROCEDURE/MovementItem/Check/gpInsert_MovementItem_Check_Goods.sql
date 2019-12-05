 -- Function: gpInsert_MovementItem_Check_Goods()

DROP FUNCTION IF EXISTS gpInsert_MovementItem_Check_Goods (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MovementItem_Check_Goods(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbPrice TFloat;
   DECLARE vbUnitId Integer;
   DECLARE vbId Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
    vbUserId := lpGetUserBySession (inSession);

    IF 3 <> inSession::Integer AND 375661 <> inSession::Integer AND 4183126 <> inSession::Integer AND 
      8001630 <> inSession::Integer AND 9560329 <> inSession::Integer
    THEN
      RAISE EXCEPTION '��������� <����������> ��� ���������.';
    END IF;

    SELECT 
      StatusId,
      MovementLinkObject_Unit.ObjectId 
    INTO
      vbStatusId,
      vbUnitId
    FROM Movement 
         LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()    
    WHERE Id = inMovementId;
            
    IF COALESCE(inMovementId,0) = 0
    THEN
        RAISE EXCEPTION '�������� �� �������.';
    END IF;

    IF vbStatusId <> zc_Enum_Status_UnComplete() 
    THEN
        RAISE EXCEPTION '������.��������� ������������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
    END IF;

      -- �������� ����      
    SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                 AND ObjectFloat_Goods_Price.ValueData > 0
                THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                ELSE ROUND (Price_Value.ValueData, 2)
           END :: TFloat                           AS Price
    INTO vbPrice
    FROM ObjectLink AS ObjectLink_Price_Unit
       LEFT JOIN ObjectLink AS Price_Goods
                            ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                           AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
       LEFT JOIN ObjectFloat AS Price_Value
                             ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                            AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
       -- ���� ���� ��� ���� ����
       LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                              ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                             AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
       LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                               ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                              AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
    WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
      AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
      AND Price_Goods.ChildObjectId = inGoodsId;  

    IF COALESCE (vbPrice, 0) = 0
    THEN
        RAISE EXCEPTION '������.�� ������� ��������� ���� ������.';
    END IF;

-- ��������� <������� ���������>
    vbId := lpInsertUpdate_MovementItem (0, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

    -- ��������� �������� <����>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), vbId, vbPrice);

    -- ��������� �������� <���� ��� ������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceSale(), vbId, vbPrice);


    -- ����������� �������� �����
    PERFORM lpInsertUpdate_MovementFloat_TotalSummCheck (inMovementId);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (vbId, vbUserId, True);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsert_MovementItem_Check_Goods (Integer, Integer, TFloat, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 10.10.19                                                       *
*/
