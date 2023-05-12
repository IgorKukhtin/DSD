-- Function: gpInsertUpdate_MovementItem_Inventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory (Integer,Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Inventory(
 INOUT ioId                                 Integer   , -- ���� ������� <������� ���������>
    IN inMovementId                         Integer   , -- ���� ������� <��������>
    IN inMovementId_OrderClient             Integer   , -- ����� �������
    IN inGoodsId                            Integer   , -- ������
    IN inPartionId                          Integer   , -- ������  
    IN inPartnerId                          Integer   , -- ���������
 INOUT ioAmount                             TFloat    , -- ���������� 
    IN inTotalCount                         TFloat    , -- ���������� �����
    IN inTotalCount_old                     TFloat    , -- ���������� �����
 INOUT ioPrice                              TFloat    , -- ����
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


     -- ������
     -- IF ioAmount = 0 THEN ioAmount:= 1; END IF;

     -- ������������ ��������� �� ���������
     SELECT tmp.ioId, tmp.ioAmount, tmp.ioPrice, tmp.outAmountSumm
            INTO ioId, ioAmount, ioPrice, outAmountSumm
     FROM lpInsertUpdate_MovementItem_Inventory (ioId              := ioId
                                               , inMovementId      := inMovementId
                                               , inMovementId_OrderClient := inMovementId_OrderClient
                                               , inGoodsId         := inGoodsId
                                               , inPartnerId       := inPartnerId
                                               , ioAmount          := ioAmount
                                               , inTotalCount      := inTotalCount
                                               , inTotalCount_old  := inTotalCount_old
                                               , ioPrice           := ioPrice
                                               , inPartNumber      := inPartNumber
                                               , inComment         := inComment
                                               , inUserId          := vbUserId
                                                ) AS tmp;

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