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
         RAISE EXCEPTION '������.%��������� ���� ������ �������� � ������ <�� ����������>.', CHR (13);
     END IF;
     
     IF EXISTS (SELECT 1
                FROM MovementItemLinkObject AS MILO_PartionCell
                WHERE MILO_PartionCell.MovementItemId = inMovementItemId
                  AND MILO_PartionCell.ObjectId       > 0
                  AND MILO_PartionCell.ObjectId       NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  AND MILO_PartionCell.DescId         IN (zc_MILinkObject_PartionCell_1()
                                                        , zc_MILinkObject_PartionCell_2()
                                                        , zc_MILinkObject_PartionCell_3()
                                                        , zc_MILinkObject_PartionCell_4()
                                                        , zc_MILinkObject_PartionCell_5()
                                                        , zc_MILinkObject_PartionCell_6()
                                                        , zc_MILinkObject_PartionCell_7()
                                                        , zc_MILinkObject_PartionCell_8()
                                                        , zc_MILinkObject_PartionCell_9()
                                                        , zc_MILinkObject_PartionCell_10()
                                                        , zc_MILinkObject_PartionCell_11()
                                                        , zc_MILinkObject_PartionCell_12()
                                                        , zc_MILinkObject_PartionCell_13()
                                                        , zc_MILinkObject_PartionCell_14()
                                                        , zc_MILinkObject_PartionCell_15()
                                                        , zc_MILinkObject_PartionCell_16()
                                                        , zc_MILinkObject_PartionCell_17()
                                                        , zc_MILinkObject_PartionCell_18()
                                                        , zc_MILinkObject_PartionCell_19()
                                                        , zc_MILinkObject_PartionCell_20()
                                                        , zc_MILinkObject_PartionCell_21()
                                                        , zc_MILinkObject_PartionCell_22()
                                                         )
               )
     THEN
         RAISE EXCEPTION '������.%��������� ������ �������� ���� �� ��������� ����� ��������.', CHR (13);
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