 -- Function: lpInsertUpdate_MI_ProductionUnion_Child()

-- DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnion_Child (Integer, Integer, Integer, TFloat, Integer, TDateTime, TVarChar, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnion_Child (Integer, Integer, Integer, TFloat, Integer, TDateTime, TVarChar, Integer, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_ProductionUnion_Child(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <�������� ������������ - ����������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inParentId            Integer   , -- ������� ������� ���������
    IN inPartionGoodsDate    TDateTime , -- ������ ������	
    IN inPartionGoods        TVarChar  , -- ������ ������        
    IN inGoodsKindId         Integer   , -- ���� �������            
    IN inCount_onCount       TFloat    , -- ���������� �������
    IN inUserId              Integer     -- ������������
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
   -- ��������
   IF COALESCE (inParentId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�� �������� ������� �������.';
   END IF;

   -- ������ ��������
   IF inPartionGoodsDate <= '01.01.1900' THEN inPartionGoodsDate:= NULL; END IF;

   -- ������������ ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;
 
   -- ��������� <������� ���������>
   ioId := lpInsertUpdate_MovementItem (ioId           := ioId
                                      , inDescId       := zc_MI_Child()
                                      , inObjectId     := inGoodsId
                                      , inMovementId   := inMovementId
                                      , inAmount       := inAmount
                                      , inParentId     := inParentId
                                      , inUserId       := inUserId
                                       );
  
   -- ��������� �������� <������ ������>
   PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), ioId, inPartionGoodsDate);
   -- ��������� �������� <������ ������>
   PERFORM lpInsertUpdate_MovementItemString (zc_MIString_PartionGoods(), ioId, inPartionGoods);
   
   -- ��������� ����� � <���� �������>
   PERFORM lpInsertUpdate_MovementItemLinkObject(zc_MILinkObject_GoodsKind(), ioId, inGoodsKindId);

   -- ��������� �������� <���������� �������>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_Count(), ioId, inCount_onCount);

   -- !!!������ ��� ��������!!!
   IF vbIsInsert = TRUE AND inUserId IN (zc_Enum_Process_Auto_PartionDate(), zc_Enum_Process_Auto_PartionClose())
   THEN
       PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_isAuto(), ioId, TRUE);
   END IF;


   -- ����������� �������� ����� �� ���������
   PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

   -- ��������� ��������
   PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.07.15                                        * add inUserId:=
 05.07.15                                        * add inCount_onCount
 21.03.15                                        * all
 11.12.14         * �� gp
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MI_ProductionUnion_Child (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inParentId:= NULL, inAmountReceipt:= 1, inComment:= '', inSession:= '2')
