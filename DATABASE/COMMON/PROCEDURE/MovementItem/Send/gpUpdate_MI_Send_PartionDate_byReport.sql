-- Function: gpUpdate_MI_Send_PartionDate_byReport()

DROP FUNCTION IF EXISTS gpUpdate_MI_Send_PartionDate_byReport (Integer, Integer,Integer,Integer,TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Send_PartionDate_byReport(
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inMovementItemId        Integer   , -- ���� ������� <������� ���������> 
    IN inGoodsId               Integer  ,
    IN inGoodsKindId           Integer  ,
    IN inPartionGoodsDate      TDateTime , -- ���� ������
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId   Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send_PartionDate_byReport());

     IF COALESCE (inMovementItemId,0) = 0
     THEN
         RAISE EXCEPTION '������.%��������� ������ �������� � ������ <�� ����������>.', CHR (13);
     END IF;
     
     -- ������ ��������
     IF inPartionGoodsDate <= '01.01.2010' THEN inPartionGoodsDate:= NULL; END IF;
     
     -- ��������� �������� <���� ������>
     IF COALESCE (inPartionGoodsDate, zc_DateStart()) <> zc_DateStart() OR EXISTS (SELECT 1 FROM MovementItemDate AS MID WHERE MID.MovementItemId = inMovementItemId AND MID.DescId = zc_MIDate_PartionGoods())
     THEN
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), inMovementItemId, inPartionGoodsDate); 
     END IF;

     -- ��������� ��������
     --PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.01.24         *
*/

-- ����
--