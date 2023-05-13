-- Function: lpInsertUpdate_MovementItem_Inventory()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_Inventory (Integer,Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_Inventory(
 INOUT ioId                                 Integer   , -- ���� ������� <������� ���������>
    IN inMovementId                         Integer   , -- ���� ������� <��������>
    IN inMovementId_OrderClient             Integer   , -- ����� �������
    IN inGoodsId                            Integer   , -- ������ 
    IN inPartnerId                          Integer   , --
 INOUT ioAmount                             TFloat    , -- ����������
    IN inTotalCount                         TFloat    , -- ���������� �����
    IN inTotalCount_old                     TFloat    , -- ���������� �����
 INOUT ioPrice                              TFloat    , -- ����
   OUT outAmountSumm                        TFloat    , -- ����� ���������
    IN inPartNumber                         TVarChar  , --
    IN inComment                            TVarChar  , -- ����������
    IN inUserId                             Integer     -- ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbUnitId   Integer;
BEGIN
     -- ������
     ioPrice:= (SELECT lpGet.ValuePrice FROM lpGet_MovementItem_PriceList ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId), inGoodsId, inUserId) AS lpGet);

     -- ������������ ��������� �� ���������
     -- vbUnitId:= (SELECT MLO_Unit.ObjectId FROM MovementLinkObject AS MLO_Unit WHERE MLO_Unit.MovementId = inMovementId AND MLO_Unit.DescId = zc_MovementLinkObject_Unit());

     -- ����� �����
     IF ioId < 0
     THEN
         -- ��������
         IF 1 < (SELECT COUNT(*)
                 FROM MovementItem AS MI
                      LEFT JOIN MovementItemString AS MIString_PartNumber
                                                   ON MIString_PartNumber.MovementItemId = MI.Id
                                                  AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
                 WHERE MI.MovementId = inMovementId
                   AND MI.DescId     = zc_MI_Master()
                   AND MI.ObjectId   = inGoodsId
                   AND MI.isErased   = FALSE
                   AND COALESCE (MIString_PartNumber.ValueData,'') = COALESCE (inPartNumber,'')
                )
         THEN
             RAISE EXCEPTION '������.������� ������������ <������>%<%><%>.', CHR (13), lfGet_Object_ValueData (inGoodsId), inPartNumber;
         END IF;

         -- �����
         ioId:= (SELECT MI.Id FROM MovementItem AS MI
                             LEFT JOIN MovementItemString AS MIString_PartNumber
                                                          ON MIString_PartNumber.MovementItemId = MI.Id
                                                         AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                 WHERE MI.MovementId = inMovementId
                   AND MI.DescId     = zc_MI_Master()
                   AND MI.ObjectId   = inGoodsId
                   AND MI.isErased   = FALSE
                   AND COALESCE (MIString_PartNumber.ValueData,'') = COALESCE (inPartNumber,'')
                );
         -- 

         -- ����� ������ ����� ����������, ����� ��� ���������, ����� + � ������������ ����������
         IF COALESCE (inTotalCount, 0) <> COALESCE (inTotalCount_old, 0)
         THEN
             ioAmount := inTotalCount;
         ELSE 
             ioAmount:= ioAmount + COALESCE ((SELECT MI.Amount FROM MovementItem AS MI WHERE MI.Id = ioId), 0);
         END IF;

     END IF;


     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, NULL, inMovementId, ioAmount, NULL, inUserId);

     -- ��������� �������� <����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, COALESCE (ioPrice, 0));

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartNumber(), ioId, inPartNumber);
     -- ��������� �������� <����������>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);
     --
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Partner(), ioId, inPartnerId);

    -- ��������� �������� <����� �������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), ioId, inMovementId_OrderClient ::TFloat);
     
     -- ��������� ����� �� ��������, ��� �����
     outAmountSumm := CAST (ioAmount * ioPrice AS NUMERIC (16, 2));


     -- ��������
     IF 1 < (SELECT COUNT(*)
             FROM MovementItem AS MI
                  LEFT JOIN MovementItemString AS MIString_PartNumber
                                               ON MIString_PartNumber.MovementItemId = MI.Id
                                              AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
             WHERE MI.MovementId = inMovementId
               AND MI.DescId     = zc_MI_Master()
               AND MI.ObjectId   = inGoodsId
               AND MI.isErased   = FALSE
               AND COALESCE (MIString_PartNumber.ValueData,'') = COALESCE (inPartNumber,'')
            )
     THEN
         RAISE EXCEPTION '������.������� ������������ <������>%<%><%>.', CHR (13), lfGet_Object_ValueData (inGoodsId), inPartNumber;
     END IF;

    -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.05.23         *
 17.02.22         *
*/

-- ����
--