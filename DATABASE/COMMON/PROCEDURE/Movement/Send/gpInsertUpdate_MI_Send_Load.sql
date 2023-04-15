-- Function: gpInsertUpdate_MI_Send_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Send_Load (Integer, Integer, TVarChar, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Send_Load(
    IN inMovementId            Integer   , --
    IN inGoodsCode             Integer   , 
    IN inGoodsName             TVarChar  , -- 
    IN inGoodsKindName         TVarChar  , 
    IN inAmount                TFloat    , -- ����������
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbGoodsId           Integer;
   DECLARE vbGoodsKindId       Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());

     -- ��������
     IF COALESCE (inAmount,0) = 0
     THEN
         RETURN;
     END IF;

     --������� ������
     vbGoodsId        := (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inGoodsCode AND Object.DescId = zc_Object_Goods());
     -- ������� ��� ������
     vbGoodsKindId    := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inGoodsKindName) AND Object.DescId = zc_Object_GoodsKind());

     IF COALESCE (vbGoodsId,0) = 0
     THEN
         RAISE EXCEPTION '������.����� (<%>) <%> �� ������.',inGoodsCode, inGoodsName;
     END IF;

     IF COALESCE (vbGoodsKindId,0) = 0
     THEN
         RAISE EXCEPTION '������.��� ������ <%> �� ������.', inGoodsKindName;
     END IF;
     
     -- ��������� <������� ���������>
     PERFORM lpInsertUpdate_MovementItem_Send (ioId                  := 0              ::Integer
                                             , inMovementId          := inMovementId   ::Integer
                                             , inGoodsId             := vbGoodsId      ::Integer
                                             , inAmount              := inAmount       :: TFloat
                                             , inPartionGoodsDate    := NULL           :: TDateTime
                                             , inCount               := 0              :: TFloat
                                             , inHeadCount           := 0              :: TFloat
                                             , ioPartionGoods        := ''             :: TVarChar
                                             , inGoodsKindId         := vbGoodsKindId  ::Integer
                                             , inGoodsKindCompleteId := 0              ::Integer
                                             , inAssetId             := 0              ::Integer
                                             , inAssetId_two         := 0              ::Integer
                                             , inUnitId              := 0              ::Integer
                                             , inStorageId           := 0              ::Integer
                                             , inPartionGoodsId      := 0              ::Integer
                                             , inUserId              := vbUserId
                                              ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
14.04.23          *
*/

-- ����
--