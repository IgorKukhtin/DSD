-- Function: gpInsertUpdate_MovementItem_Income()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ReturnOut(Integer, Integer, Integer, TFloat, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ReturnOut(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inPrice               TFloat    , -- ����
    IN inParentId            Integer   , -- ������ �� ��������
   OUT outSumm               TFloat    , -- �����
   OUT outAmountInIncome     TFloat    , -- ���-�� � �������
   OUT outRemains            TFloat    , -- ������� �� �������
   OUT outWarningColor       Integer   , -- ��������� ��������, ���� ���-�� > ������� 
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     --vbUserId := inSession;
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ReturnOut());
     
     
     outSumm := (inAmount*inPrice)::TFloat;
     
     ioId := lpInsertUpdate_MovementItem_ReturnOut(ioId, inMovementId, inGoodsId, inAmount, inPrice, inParentId, vbUserId);

    SELECT
        MovementItem.Amount
       ,Container.Amount
       ,CASE 
          WHEN inAmount > COALESCE(MovementItem.Amount,0) or
               inAmount > COALESCE(Container.Amount,0)
            THEN zc_Color_Warning_Red()
        END       
    INTO
        outAmountInIncome
       ,outRemains
       ,outWarningColor
    FROM 
        MovementItem
        LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.MovementItemId = MovementItem.Id
                                             AND MovementItemContainer.DescId = zc_MIContainer_Count()
        LEFT OUTER JOIN Container ON Container.Id = MovementItemContainer.ContainerId
                                 AND Container.DescId = zc_Container_Count() 
    WHERE 
        MovementItem.Id = inParentId;
     -- ����������� �������� �����
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 10.02.15                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Income (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
