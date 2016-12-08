-- Function: gpUpdate_MI_Price()

DROP FUNCTION IF EXISTS gpUpdate_MI_Price(Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Price(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
 INOUT ioAmount              TFloat    , -- ����
    IN inPercent             TFloat    , -- % ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS TFloat AS
$BODY$
   DECLARE vbUserId Integer;
   --DECLARE vbAmount TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_PriceList());
     vbUserId := inSession;

     ioAmount :=  CAST ((ioAmount + (ioAmount * inPercent / 100)) ::NUMERIC (16, 2) AS TFloat);

     -- �������� ���� � <������� ���������>
     PERFORM lpInsertUpdate_MovementItem (inId, zc_MI_Master(), inGoodsId, inMovementId, ioAmount, NULL);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 19.09.14                         *
*/

-- ����
-- SELECT * FROM gpUpdate_MI_Price (inId:= 0, inMovementId:= 10, inGoodsId:= 1, ioAmount:= 0, inPercent := inSession:= '2')