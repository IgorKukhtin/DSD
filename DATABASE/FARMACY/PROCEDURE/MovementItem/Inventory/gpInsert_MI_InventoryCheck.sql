-- Function: gpInsert_MI_InventoryCheck()

DROP FUNCTION IF EXISTS gpInsert_MI_InventoryCheck (Integer, Integer, TFloat, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_InventoryCheck(
    IN inMovementId  Integer   , -- ���� ������� <�������� ��������������>
    IN inGoodsId     Integer   , -- �����
    IN inAmount      TFloat    , -- ���������� ���.������������
    IN inDateInput   TDateTime , -- ���� �����
    IN inUserInputId Integer   , -- ��� ����
    IN inCheckId     Integer   , -- ID ����
    IN inSession     TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;

   DECLARE vbId         Integer;
   DECLARE vbChildId    Integer;
   DECLARE vbUnitId     Integer;
   DECLARE vbAmount     TFloat;
   DECLARE vbAmountUser TFloat;
   DECLARE vbPrice      TFloat;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());

    --���������� ������������� � ���� ���������
    SELECT MLO_Unit.ObjectId
    INTO vbUnitId
    FROM Movement
         INNER JOIN MovementLinkObject AS MLO_Unit
                                       ON MLO_Unit.MovementId = Movement.Id
                                      AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE Movement.Id = inMovementId;   
    
    --���������� �� ������
    vbId := (SELECT MovementItem.Id
             FROM MovementItem
             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.DescId = zc_MI_Master()
               AND MovementItem.ObjectId = inGoodsId);
               
    IF EXISTS (SELECT MovementItem.Id
               FROM MovementItem
                    INNER JOIN MovementItemFloat AS MIDate_Insert
                                                 ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                AND MIDate_Insert.DescId = zc_MIFloat_MovementId()
                                                AND MIDate_Insert.ValueData = inCheckId
               WHERE MovementItem.ParentId = vbId
                 AND MovementItem.DescId   = zc_MI_Child()
                 AND MovementItem.isErased = FALSE
               )
    THEN
      RETURN;
    END IF;


    -- ����� ���������� ����� ���-�� (��������� ���-�� �� ���� ������������� + �������)
    -- � ���-�� �������������, �������������� �������
    SELECT SUM (tmp.Amount) AS  Amount
         , SUM (tmp.AmountUser) AS  AmountUser
    INTO vbAmount, vbAmountUser
    FROM (SELECT MovementItem.Amount                                                                  AS Amount
               , CASE WHEN MovementItem.ObjectId = inUserInputId then MovementItem.Amount ELSE 0 END  AS AmountUser 
               , CAST (ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY MovementItem.ObjectId, MIDate_Insert.ValueData DESC) AS Integer) AS Num
          FROM MovementItem
               LEFT JOIN MovementItemDate AS MIDate_Insert
                                          ON MIDate_Insert.MovementItemId = MovementItem.Id
                                         AND MIDate_Insert.DescId = zc_MIDate_Insert()
          WHERE MovementItem.ParentId  = vbId
            AND MovementItem.DescId    = zc_MI_Child()
            AND MovementItem.isErased  = FALSE
           ) AS tmp
    WHERE tmp.Num = 1;

    vbAmount := COALESCE (inAmount, 1) + COALESCE (vbAmount, 0);
    vbAmountUser := COALESCE (inAmount, 1) + COALESCE (vbAmountUser, 0);
    
    -- ���������� ����
    vbPrice := (SELECT ROUND(Price_Value.ValueData,2)::TFloat
                FROM ObjectLink AS Price_Unit
                       INNER JOIN ObjectLink AS Price_Goods
                                             ON Price_Goods.ObjectId = Price_Unit.ObjectId
                                            AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                            AND Price_Goods.ChildObjectId = inGoodsId
                       LEFT JOIN ObjectFloat AS Price_Value
                                             ON Price_Value.ObjectId = Price_Unit.ObjectId
                                            AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                WHERE Price_Unit.ChildObjectId = vbUnitId
                  AND Price_Unit.DescId = zc_ObjectLink_Price_Unit());


    -- ���������
    vbId:= lpInsertUpdate_MovementItem_Inventory (ioId                 := COALESCE(vbId,0)
                                                , inMovementId         := inMovementId
                                                , inGoodsId            := inGoodsId
                                                , inAmount             := vbAmount
                                                , inPrice              := COALESCE(vbPrice, 0)
                                                , inSumm               := (vbAmount * COALESCE(vbPrice, 0))::TFloat --outSumm
                                                , inComment            := '' ::TVarChar
                                                , inUserId             := vbUserId) AS tmp;

    -- ���������� ����������� �������
    IF COALESCE(vbId,0) <> 0
    THEN
                                                      
       -- ��������� <������� ���������>
       vbChildId := lpInsertUpdate_MovementItem (0, zc_MI_Child(), inUserInputId, inMovementId, vbAmountUser, vbId);
       
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), vbChildId, inDateInput);

       -- ��������� �������� <>
       PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), vbChildId, inCheckId);

       -- ��������� ��������
       PERFORM lpInsert_MovementItemProtocol (vbChildId, vbUserId, True);
                                                  
    END IF;
    
    -- !!!�������� ��� �����!!!
    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION '���� ������ ������� ��� <%> <%> <%>', vbId, inUserInputId, inSession;
    END IF;
    

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 12.06.23                                                       *
*/

-- ����

-- select * from gpInsert_MI_InventoryCheck(inUnitId := 377610 , inOperDate := ('28.04.2023')::TDateTime , inGoodsId := 8674 , inAmount := 1 , inDateInput := '2023-04-28 00:36:33.858' , inUserInputId := 3 ,  inSession := '3');
