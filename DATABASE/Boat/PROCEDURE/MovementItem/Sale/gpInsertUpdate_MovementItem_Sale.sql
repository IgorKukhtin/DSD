-- Function: gpInsertUpdate_MovementItem_Sale()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale(Integer, Integer, Integer, TFloat, TFloat, TFloat,TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Sale(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
 INOUT ioOperPrice           TFloat    , -- ���� �� �������
    IN inOperPriceList       TFloat    , -- ���� ��� ������
    IN inBasisPrice          TFloat    , -- ���� �������
    IN inCountForPrice       TFloat    , -- ���� �� ���.
    IN inComment             TVarChar  , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Sale());
     vbUserId := lpGetUserBySession (inSession);


     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     SELECT tmp.ioId, tmp.ioOperPrice
            INTO ioId , ioOperPrice
     FROM lpInsertUpdate_MovementItem_Sale (ioId
                                                 , inMovementId
                                                 , inGoodsId
                                                 , inAmount
                                                 , ioOperPrice
                                                 , inOperPriceList
                                                 , inBasisPrice
                                                 , inCountForPrice
                                                 , inComment
                                                 , vbUserId
                                                 ) AS tmp;


     -- ����������� �������� �����
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm_order (inMovementId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.08.21         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Sale (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')