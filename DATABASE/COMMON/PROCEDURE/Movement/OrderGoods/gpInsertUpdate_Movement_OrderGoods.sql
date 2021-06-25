-- Function: gpInsertUpdate_Movement_OrderGoods()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderGoods (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderGoods (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderGoods(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
 INOUT ioInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inOrderPeriodKindId   Integer   , --
    IN inPriceListId         Integer   , --
    IN inUnitId              Integer   , --
    IN inComment             TVarChar   , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderGoods());
     
     -- ��������� <��������>
      SELECT tmp.ioId, tmp.ioInvNumber
    INTO ioId, ioInvNumber
      FROM lpInsertUpdate_Movement_OrderGoods (ioId          := ioId
                                            , ioInvNumber    := ioInvNumber
                                            , inOperDate     := inOperDate
                                            , inOrderPeriodKindId := inOrderPeriodKindId
                                            , inPriceListId  := inPriceListId
                                            , inUnitId       := inUnitId
                                            , inComment      := inComment
                                            , inUserId       := vbUserId
                                             ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.06.21         *
 08.06.21         *
*/

-- ����
-- select * from gpInsertUpdate_Movement_OrderGoods(ioId := 18775751 , ioInvNumber := '2' , ioOperDate := ('13.01.2021')::TDateTime , inOperDate_top := ('31.01.2021')::TDateTime , inPartnerId := 4126219 , inTotalCountKg := 222 , inTotalSumm := 22222 , inComment := '' ,  inSession := '5');
