-- Function: gpInsertUpdate_MI_Invoice()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Invoice (Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Invoice (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Invoice(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inMeasureId           Integer   , -- 
    IN inAmount              TFloat    , -- ����������
    IN inCountForPrice       TFloat    , -- 
    IN inPrice               TFloat    , -- 
    IN inMIId_OrderIncome    TFloat    , -- ������� ��������� ������ ����������
  OUT outAmountSumm          TFloat    , -- ����� ���������
    IN inGoodsId             Integer   , -- ������
    IN inAssetId             Integer   ,
    IN inUnitId              Integer   ,
    IN inNameBeforeName      TVarChar  ,
    IN inComment             TVarChar ,   -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbMovementItemId Integer;
   DECLARE vbNameBeforeId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Invoice());

     -- ��������
     IF COALESCE (inGoodsId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ���������� �������� <�����>.';
     END IF;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inMeasureId, inMovementId, inAmount, NULL);


     -- ���� �����/��/������
     vbNameBeforeId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_NameBefore() and Object.ValueData = inNameBeforeName);

     IF COALESCE (vbNameBeforeId, 0) = 0
     THEN
         -- ��������
         vbNameBeforeId:= gpInsertUpdate_Object_NameBefore   (ioId              := 0
                                                            , inCode            := lfGet_ObjectCode(0, zc_Object_NameBefore()) 
                                                            , inName            := inNameBeforeName
                                                            , inSession         := inSession
                                                              );
     END IF;



     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, inCountForPrice);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementItemId(), ioId, inMIId_OrderIncome);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(), ioId, inGoodsId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_NameBefore(), ioId, vbNameBeforeId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Asset(), ioId, inAssetId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);

     -- ��������� ����� �� ��������, ��� �����
     outAmountSumm := CASE WHEN inCountForPrice > 0
                                THEN CAST (inAmount * inPrice / inCountForPrice AS NUMERIC (16, 2))
                           ELSE CAST (inAmount * inPrice AS NUMERIC (16, 2))
                      END;

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� �������� !!!����� ���������!!!
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, FALSE);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.07.15         *
*/

-- ����
-- 