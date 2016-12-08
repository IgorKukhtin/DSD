-- Function: gpUpdate_MI_Price()

DROP FUNCTION IF EXISTS gpUpdate_MI_Price(Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Price(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsMainId         Integer   , -- ������
    IN inAmount              TFloat    , -- ����
    IN inPercent             TFloat    , -- % ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_PriceList());
     vbUserId := inSession;


     -- �������� ���� � <������� ���������>
     PERFORM lpInsertUpdate_MovementItem (inId, zc_MI_Master(), inGoodsMainId, inMovementId, inAmount, NULL);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 08.12.16         *
*/

-- ����
-- SELECT * FROM gpUpdate_MI_Price (inId:= 0, inMovementId:= 10, inGoodsMainId:= 1, inAmount:= 0, inSession:= '2')
