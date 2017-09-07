-- Function: gpInsertUpdate_MovementItem_Send()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Send(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inPrice               TFloat    , -- ���� �����. �����.
    IN inPriceUnitFrom       TFloat    , -- ���� �����������
 INOUT ioPriceUnitTo         TFloat    , -- ���� ����������
   OUT outSumma              TFloat    , -- �����
   OUT outSummaUnitTo        TFloat    , -- ����� � ����� ����������
    IN inAmountManual        TFloat    , -- ���-�� ������
   OUT outAmountDiff         TFloat    , -- ������� �����������
    IN inReasonDifferencesId Integer   , -- ������� �����������
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbUnitId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
    vbUserId := inSession;
    
    --���������� ������������� ����������
    SELECT MovementLinkObject_To.ObjectId AS UnitId
           INTO vbUnitId
    FROM MovementLinkObject AS MovementLinkObject_To
    WHERE MovementLinkObject_To.MovementId = inMovementId
      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To();
           
    --���� ���� ���������� = 0 �������� �� �� ���� ����������� � ���������� � �����
    IF COALESCE (ioPriceUnitTo, 0) = 0 AND COALESCE (inPriceUnitFrom, 0) <> 0 
    THEN
        ioPriceUnitTo := inPriceUnitFrom;
        
        --����������� �����
        PERFORM lpInsertUpdate_Object_Price(inGoodsId := inGoodsId,
                                            inUnitId  := vbUnitId,
                                            inPrice   := ioPriceUnitTo,
                                            inDate    := CURRENT_DATE::TDateTime,
                                            inUserId  := vbUserId);
    END IF;
    
    --��������� �����
    outSumma := ROUND(inAmount * inPrice, 2); 
    outAmountDiff := COALESCE(inAmountManual,0) - coalesce(inAmount,0);
    
    outSummaUnitTo := ROUND(inAmount * ioPriceUnitTo, 2); 


    IF outAmountDiff = 0
    THEN
        inReasonDifferencesId := 0;
    END IF;

     -- ���������
    ioId := lpInsertUpdate_MovementItem_Send (ioId                 := ioId
                                            , inMovementId         := inMovementId
                                            , inGoodsId            := inGoodsId
                                            , inAmount             := inAmount
                                            , inAmountManual       := inAmountManual
                                            , inReasonDifferencesId:= inReasonDifferencesId
                                            , inUserId             := vbUserId
                                             );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.09.17         *
 28.06.16         *
 29.05.15                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Send (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
