-- Function: gpInsertUpdate_Object_GoodsReportSale()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsReportSale (TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsReportSale(
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsPack  Boolean;
   DECLARE vbIsBasis Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderInternal());
     
     
     -- ��������� zc_Object_GoodsReportSaleInf
     PERFORM lpInsertUpdate_Object_GoodsReportSaleInf (inId := COALESCE ((SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsReportSaleInf()) , 0) ::Integer
                                                     , inStartDate := (CURRENT_DATE - INTERVAL '57 DAY') ::TDateTime
                                                     , inEndDate   := (CURRENT_DATE - INTERVAL '2 DAY')  ::TDateTime
                                                     , inWeek      := 8                                  ::TFloat
                                                     , inUserId    := vbUserId
                                                       );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.11.17         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_GoodsReportSale (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
