-- Function: gpInsertUpdate_MovementItem_Inventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Inventory(
 INOUT ioId                                 Integer   , -- ���� ������� <������� ���������>
    IN inMovementId                         Integer   , -- ���� ������� <��������>
    IN inGoodsId                            Integer   , -- ������
    IN inPartionId                          Integer   , -- ������
 INOUT ioAmount                             TFloat    , -- ���������� 
    IN inPrice                              TFloat    , -- ����
   OUT outAmountSumm                        TFloat    , -- ����� ���������
    IN inPartNumber                         TVarChar  , -- 
    IN inComment                            TVarChar  , -- ����������
    IN inSession                            TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());
     vbUserId:= lpGetUserBySession (inSession);


     -- ������������ ��������� �� ���������
     SELECT MovementLinkObject_Unit.ObjectId
            INTO  vbUnitId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
     WHERE Movement.Id = inMovementId;


    /* -- ������ �� ������ : OperPrice + CountForPrice + OperPriceList
     SELECT Object_PartionGoods.CountForPrice
          , Object_PartionGoods.OperPrice
          , Object_PartionGoods.OperPriceList
            INTO outCountForPrice, outOperPrice, outOperPriceList
     FROM Object_PartionGoods
     WHERE Object_PartionGoods.MovementItemId = inPartionId;
*/
     IF ioAmount = 0 THEN ioAmount:= 1; END IF;

     -- ����� �����
     IF ioId < 0
     THEN
         IF inPartionId > 0
         THEN
             -- ��������
             IF 1 < (SELECT COUNT(*) FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.PartionId = inPartionId AND MI.isErased = FALSE)
             THEN
                 RAISE EXCEPTION '������.������� ��������� ����� � ����� �������.%<%>.', CHR (13), inPartionId;
             END IF;
             -- �����
             ioId:= (SELECT MI.Id FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.PartionId = inPartionId AND MI.isErased = FALSE);
         ELSE
             -- ��������
             IF 1 < (SELECT COUNT(*) FROM MovementItem AS MI 
                                 LEFT JOIN MovementItemString AS MIString_PartNumber
                                                              ON MIString_PartNumber.MovementItemId = MI.Id
                                                             AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                     WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE
                       AND MI.ObjectId = inGoodsId
                       AND MI.PartionId = inPartionId
                       AND COALESCE (MIString_PartNumber.ValueData,'') = COALESCE (inPartNumber,'')
                     )
             THEN
                 RAISE EXCEPTION '������.������� ��������� ����� � ����� �������������.%<%>.', CHR (13), lfGet_Object_ValueData (inGoodsId);
             END IF;
             -- �����
             ioId:= (SELECT MI.Id FROM MovementItem AS MI
                                 LEFT JOIN MovementItemString AS MIString_PartNumber
                                                              ON MIString_PartNumber.MovementItemId = MI.Id
                                                             AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                     WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.isErased = FALSE
                       AND MI.ObjectId = inGoodsId
                       AND COALESCE (MIString_PartNumber.ValueData,'') = COALESCE (inPartNumber,'')
                     );
         END IF;
         -- 
         ioAmount:= ioAmount + COALESCE ((SELECT MI.Amount FROM MovementItem AS MI WHERE MI.Id = ioId), 0);

     END IF;


     --
          
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������> -
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inPartionId, inMovementId, ioAmount, NULL, vbUserId);

     -- ��������� �������� <����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartNumber(), ioId, inPartNumber);
     -- ��������� �������� <����������>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);


     -- ��������� ����� �� ��������, ��� �����
     outAmountSumm := CAST(ioAmount * inPrice AS NUMERIC (16, 2));

    -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.02.22         *
*/

-- ����
-- 