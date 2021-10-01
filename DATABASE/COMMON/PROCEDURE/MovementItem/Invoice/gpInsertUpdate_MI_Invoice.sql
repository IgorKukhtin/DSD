-- Function: gpInsertUpdate_MI_Invoice()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Invoice (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Invoice(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
 INOUT ioMeasureId           Integer   , -- 
   OUT outMeasureName        TVarChar  , -- 
    IN inAmount              TFloat    , -- ����������
 INOUT ioCountForPrice       TFloat    , -- 
    IN inPrice               TFloat    , -- 
    IN inMIId_OrderIncome    TFloat    , -- ������� ��������� ������ ����������
  OUT outAmountSumm          TFloat    , -- ����� ���������
 INOUT ioGoodsId             Integer   , -- �����
   OUT outGoodsName          TVarChar  , -- 
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
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Invoice());


     -- ������
     inNameBeforeName:= COALESCE (TRIM (inNameBeforeName), '');
     -- ��������
     IF COALESCE (ioGoodsId, 0) = 0 AND inNameBeforeName = ''
     THEN
         RAISE EXCEPTION '������.�� ���������� �������� <�������� (�����/��/������)> ��� <�����>.';
     END IF;

     -- ��������
     IF TRIM ((SELECT Object.ValueData FROM Object WHERE Object.Id = ioGoodsId)) <> (SELECT Object.ValueData FROM Object WHERE Object.Id = ioGoodsId)
     THEN
         RAISE EXCEPTION '������.���������� <�������� (�����/��/������)> = <%> � <�����> = <%>.', inNameBeforeName, (SELECT Object.ValueData FROM Object WHERE Object.Id = ioGoodsId);
     END IF;

     -- ������
     IF ioGoodsId > 0 AND inNameBeforeName <> COALESCE ((SELECT ValueData FROM Object WHERE Id = ioGoodsId), '')
        AND zc_Object_Goods() = (SELECT DescId FROM Object WHERE Id = ioGoodsId)
     THEN
         ioGoodsId:= 0;
     END IF;
     outGoodsName:= (SELECT ValueData FROM Object WHERE Id = ioGoodsId);
     -- ������
     IF COALESCE (ioMeasureId, 0) = 0
     THEN
         ioMeasureId:= zc_Measure_Sht();
     END IF;
     outMeasureName:= (SELECT ValueData FROM Object WHERE Id = ioMeasureId);
     -- ������
     IF COALESCE (ioCountForPrice, 0) = 0
     THEN
         ioCountForPrice:= 1;
     END IF;

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), ioMeasureId, inMovementId, inAmount, NULL);


     -- ���� ���� ...
     IF (COALESCE (ioGoodsId, 0) = 0 OR zc_Object_Asset() = (SELECT DescId FROM Object WHERE Id = ioGoodsId))
        AND inNameBeforeName <> ''
        AND inNameBeforeName <> COALESCE ((SELECT ValueData FROM Object WHERE Id = ioGoodsId AND DescId = zc_Object_Asset()), '')
     THEN 
         -- ���� �����/��/������
         vbNameBeforeId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_NameBefore() AND Object.ValueData = inNameBeforeName);
     END IF;
     -- ���� ���� ...
     IF (COALESCE (ioGoodsId, 0) = 0 OR zc_Object_Asset() = (SELECT DescId FROM Object WHERE Id = ioGoodsId))
        AND COALESCE (vbNameBeforeId, 0) = 0 AND inNameBeforeName <> ''
        AND inNameBeforeName <> COALESCE ((SELECT ValueData FROM Object WHERE Id = ioGoodsId AND DescId = zc_Object_Asset()), '')
     THEN
         -- ����������
         vbNameBeforeId:= gpInsertUpdate_Object_NameBefore   (ioId              := 0
                                                            , inCode            := lfGet_ObjectCode (0, zc_Object_NameBefore()) 
                                                            , inName            := inNameBeforeName
                                                            , inSession         := inSession
                                                             );
     END IF;


     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, ioCountForPrice);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementItemId(), ioId, inMIId_OrderIncome);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(), ioId, ioGoodsId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_NameBefore(), ioId, vbNameBeforeId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Asset(), ioId, inAssetId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);

     -- ��������� ����� �� ��������, ��� �����
     outAmountSumm := CASE WHEN ioCountForPrice > 0
                                THEN CAST (inAmount * inPrice / ioCountForPrice AS NUMERIC (16, 2))
                           ELSE CAST (inAmount * inPrice AS NUMERIC (16, 2))
                      END;

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� �������� !!!����� ���������!!!
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

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