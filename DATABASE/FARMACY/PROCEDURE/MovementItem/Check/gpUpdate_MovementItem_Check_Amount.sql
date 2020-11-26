 -- Function: gpUpdate_MovementItem_Check_Amount()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Check_Amount (Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Check_Amount(
    IN inId                  Integer   , -- ���� ������� <������ ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
   OUT outTotalSumm          TFloat    , -- ����� ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS TFloat AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbAmountOrder TFloat;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
    vbUserId := lpGetUserBySession (inSession);


    -- ��������� ������� �� ���������
    IF COALESCE (inId, 0) = 0
       OR NOT EXISTS (SELECT 1 FROM MovementItem WHERE Id = inId)
    THEN
        RAISE EXCEPTION '�� ������ ������� �� ���������';
    END IF;

    -- ������� ������� �� ��������� � ������
    IF COALESCE (inMovementId, 0) = 0
       OR NOT EXISTS (SELECT 1 FROM MovementItem WHERE Id = inId)
    THEN
        RAISE EXCEPTION '�� ����� �������� ��� ������������ �����';
    END IF;
    
    
    IF EXISTS(SELECT 1 FROM MovementLinkObject AS MovementLinkObject_CheckSourceKind
              WHERE MovementLinkObject_CheckSourceKind.MovementId = inMovementId
                AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind()
                AND MovementLinkObject_CheckSourceKind.ObjectId = zc_Enum_CheckSourceKind_Tabletki())
    THEN
      SELECT MovementItem.Amount, COALESCE (MIFloat_AmountOrder.ValueData, 0)
      INTO vbAmount, vbAmountOrder
      FROM MovementItem
           LEFT JOIN MovementItemFloat AS MIFloat_AmountOrder
                                       ON MIFloat_AmountOrder.MovementItemId = MovementItem.Id
                                      AND MIFloat_AmountOrder.DescId = zc_MIFloat_AmountOrder()      
      WHERE MovementItem.ID = inId;
      
      IF inAmount > ceil(vbAmountOrder)
      THEN
          RAISE EXCEPTION '����������� ���������� �� ����� �������� ���������, ����� �� ���������� ������. ��������� ������� ���������� �����.';
      END IF;      
    END IF;

    -- ��������� <������� ���������>
    UPDATE MovementItem SET Amount = inAmount 
    WHERE DescId = zc_MI_Master() AND ID = inId;

    -- ����������� �������� �����
    PERFORM lpInsertUpdate_MovementFloat_TotalSummCheck (inMovementId);
    
    -- �������� ����� ���������
    SELECT MovementFloat_TotalSumm.ValueData
    INTO outTotalSumm
    FROM MovementFloat AS MovementFloat_TotalSumm
    WHERE MovementFloat_TotalSumm.MovementId =  inMovementId
      AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm();


    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpUpdate_MovementItem_Check_Amount (Integer, Integer, Integer, TFloat, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
              ������ �.�.
 06.10.18       *
*/

