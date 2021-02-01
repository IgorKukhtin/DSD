-- Function: lpInsertUpdate_MovementItem_Send()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Send (Integer, Integer, Integer, TFloat, TDateTime, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Send(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inPartionGoodsDate    TDateTime , -- ���� ������
    IN inCount               TFloat    , -- ���������� ������� ��� ��������
    IN inHeadCount           TFloat    , -- ���������� �����
 INOUT ioPartionGoods        TVarChar  , -- ������ ������/����������� �����
    IN inGoodsKindId         Integer   , -- ���� �������
    IN inGoodsKindCompleteId Integer   , -- ���� �������  ��
    IN inAssetId             Integer   , -- �������� �������� (��� ������� ���������� ���)
    IN inUnitId              Integer   , -- ������������� (��� ��)
    IN inStorageId           Integer   , -- ����� ��������
    IN inPartionGoodsId      Integer   , -- ������ ������� (��� ������ ������� ���� � ��)
    IN inUserId              Integer     -- ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ������ ��������
     IF inPartionGoodsDate <= '01.01.1900' THEN inPartionGoodsDate:= NULL; END IF;

     -- ���� �� ����������� ������ ������
     IF COALESCE (inGoodsId,0) = 0
     THEN
        RETURN;
     END IF;
     
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ������ ����������� �����: ���� ����������� ����� �� ���������� � ��� ����������� �� ��
     IF (vbIsInsert = TRUE OR COALESCE (ioPartionGoods, '') = '' OR COALESCE (ioPartionGoods, '0') = '0')
        AND EXISTS (SELECT MovementLinkObject_From.ObjectId
                    FROM MovementLinkObject AS MovementLinkObject_From
                         INNER JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                                                         AND Object_From.DescId = zc_Object_Unit()
                         INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                       ON MovementLinkObject_To.MovementId = MovementLinkObject_From.MovementId
                                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                         INNER JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
                                                       AND Object_To.DescId = zc_Object_Member()
                    WHERE MovementLinkObject_From.MovementId = inMovementId
                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From())
     THEN
         ioPartionGoods:= lfGet_Object_PartionGoods_InvNumber (inGoodsId);
     ELSE 
         -- ������� ����������� �����: ���� ��� ����������� � �� �� ��
         IF EXISTS (SELECT MovementLinkObject_From.ObjectId
                    FROM MovementLinkObject AS MovementLinkObject_From
                         INNER JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                                                         AND Object_From.DescId = zc_Object_Member()
                         INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                       ON MovementLinkObject_To.MovementId = MovementLinkObject_From.MovementId
                                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                         INNER JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
                                                           AND Object_To.DescId = zc_Object_Member()
                    WHERE MovementLinkObject_From.MovementId = inMovementId
                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From())
         THEN
             ioPartionGoods:= (SELECT ValueData FROM Object WHERE Id = inPartionGoodsId);
         END IF;
     END IF;


     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- ��������� �������� <���� ������>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inPartionGoodsDate);

     -- ��������� �������� <���������� ��������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountPack(), ioId, inCount);

     -- ��������� �������� <���������� �����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_HeadCount(), ioId, inHeadCount);

     -- ��������� �������� <������ ������>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), ioId, ioPartionGoods);

     -- ��������� ����� � <���� �������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);
     -- ��������� ����� � <���� ������� ��>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKindComplete(), ioId, inGoodsKindCompleteId);

     -- ��������� ����� � <�������� �������� (��� ������� ���������� ���)> - ����� �� ������������, �.�. � ������� �� ����. ���� ������ ���
     -- PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Asset(), ioId, inAssetId);

     -- ��������� ����� � <������������� (��� ��)> - ������ �� ����
     -- PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);
     -- ��������� ����� � <����� ��������> - ��� ������ ������� �� ��
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Storage(), ioId, inStorageId);
     
     -- ��������� ����� � <������ ������� (��� ������ ������� ���� � ��)> - ���� �� ����
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionGoods(), ioId, inPartionGoodsId);


     IF inGoodsId <> 0 AND inGoodsKindId <> 0
     THEN
         -- ������� ������ <����� ������ � ���� �������>
         PERFORM lpInsert_Object_GoodsByGoodsKind (inGoodsId, inGoodsKindId, inUserId);
     END IF;

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     -- !!! ������� ����.!!!
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.08.17         * add inGoodsKindCompleteId
 29.05.15                                        * set lp
 26.07.14                                        * add inPartionGoodsDate and inUnitId and inStorageId and inPartionGoodsId and ioPartionGoods
 23.05.14                                                       *
 18.07.13         * add inAssetId
 16.07.13                                        * del params by SendOnPrice
 12.07.13         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItem_Send (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
