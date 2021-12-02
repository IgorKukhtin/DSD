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
   DECLARE vbChangePercent TFloat;
   DECLARE vbUnitId Integer;
   DECLARE vbId Integer;
   DECLARE vbSPKindId Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
    vbUserId := lpGetUserBySession (inSession);

    SELECT 
      StatusId,
      MovementLinkObject_Unit.ObjectId,
      COALESCE(MovementLinkObject_SPKind.ObjectId, 0) 
    INTO
      vbStatusId,
      vbUnitId,
      vbSPKindId
    FROM Movement 
         LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()    
         LEFT JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                      ON MovementLinkObject_SPKind.MovementId = Movement.Id
                                     AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
    WHERE Id = inMovementId;

    IF vbUserId NOT IN (375661, 4183126, 8001630, 9560329) AND 
      (vbSPKindId <> zc_Enum_SPKind_1303() OR NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = 11041603))
    THEN
      RAISE EXCEPTION '��������� ����� ��� ���������.';
    END IF;
            
    IF COALESCE(inMovementId,0) = 0
    THEN
        RAISE EXCEPTION '�������� �� �������.';
    END IF;

    IF vbStatusId <> zc_Enum_Status_UnComplete() 
    THEN
        RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
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
    
    -- ��������� ������ ��� 1303
    vbChangePercent := 0;
    IF vbSPKindId = zc_Enum_SPKind_1303()
    THEN
      if EXISTS (SELECT *
                 FROM MovementItem
                 
                      INNER JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                   ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                  AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                                                 
                 WHERE MovementItem.DescId     = zc_MI_Master()
                   AND MovementItem.MovementId = inMovementId
                 )
      THEN
          
        SELECT COALESCE (MIN(MIFloat_ChangePercent.ValueData), 0)
        INTO vbChangePercent
        FROM MovementItem
                 
             INNER JOIN MovementItemFloat AS MIFloat_ChangePercent
                                          ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                         AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                                                 
        WHERE MovementItem.DescId     = zc_MI_Master()
          AND MovementItem.MovementId = inMovementId;      
          
      END IF;       
    END IF;

    -- ��������� <������� ���������>
    vbId := lpInsertUpdate_MovementItem (0, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

    IF vbChangePercent <> 0
    THEN

      -- ��������� �������� <% ������>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), vbId, vbChangePercent);
    
      -- ��������� �������� <����>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), vbId, ROUND(vbPrice * (100 - vbChangePercent) / 100, 2));

    ELSE
      -- ��������� �������� <����>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), vbId, vbPrice);
    END IF;

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