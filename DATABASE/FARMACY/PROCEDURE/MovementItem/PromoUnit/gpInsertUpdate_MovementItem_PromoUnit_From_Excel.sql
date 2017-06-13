-- Function: gpInsertUpdate_MovementItem_PromoUnit_From_Excel()
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoUnit_From_Excel (Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PromoUnit_From_Excel(
    IN inMovementId          Integer   , -- ���� ������� <�������� ��������������>
    IN inUnitId              Integer   , -- ���� �������������
    IN inGoodsCode           Integer   , -- ��� ������
    IN inAmount              TFloat    , -- ����������
    IN inAmountPlanMax       TFloat    , -- ���-�� ��� ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbId Integer;
   DECLARE vbPrice TFloat;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;
	 
    vbGoodsId := 0;
     --�������� ����� �� ����
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
    Select Id INTO vbGoodsId from Object_Goods_View Where ObjectId = vbObjectId AND GoodsCodeInt = inGoodsCode;
    --���������, � ���� �� ����� ����� � ����
    IF (COALESCE(vbGoodsId,0) = 0)
    THEN
        RAISE EXCEPTION '������. � ���� ������ �� ������ ����� � ����� <%>', inGoodsCode;
    END IF;

    -- ����� ���� ������
    vbPrice := (SELECT ROUND(Price_Value.ValueData,2)::TFloat  AS Price 
                FROM ObjectLink AS ObjectLink_Price_Unit
                     LEFT JOIN ObjectLink AS Price_Goods
                            ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                           AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                     LEFT JOIN ObjectFloat AS Price_Value
                            ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                  AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
                  AND Price_Goods.ChildObjectId = vbGoodsId);
    
    IF inAmount is not null AND (inAmount < 0)
    THEN
        RAISE EXCEPTION '������. ���������� <%> �� ����� ���� ������ ����.', inAmount;
    END IF;
    

    SELECT Id INTO vbId from MovementItem Where MovementId = COALESCE(inMovementId,0) AND ObjectId = vbGoodsId;

    -- ��������� <������� ���������>
    PERFORM lpInsertUpdate_MovementItem_PromoUnit (ioId                 := COALESCE(vbId,0)
                                                 , inMovementId         := inMovementId
                                                 , inGoodsId            := vbGoodsId
                                                 , inAmount             := inAmount
                                                 , inAmountPlanMax      := inAmountPlanMax
                                                 , inPrice              := COALESCE(vbPrice,0) ::TFloat
                                                 , inComment            := '' ::TVarChar
                                                 , inUserId             := vbUserId
                                                );

    -- ����������� �������� ����� �� ���������
    PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
  12.06.17        * ���� �� Object_Price_View
  04.02.17        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_PromoUnit (ioId:= 0, inMovementId:= 0, inGoodsId:= 1, inAmount:= 0, inSession:= '2')
