-- Function: gpUpdate_MI_Sale_PartionGoodsDate()

DROP FUNCTION IF EXISTS gpUpdate_MI_Sale_PartionGoodsDate (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Sale_PartionGoodsDate(
    IN inId                      Integer   , -- ���� ������� <>
    IN inPartionGoodsDate        TDateTime , --
    IN inSession                 TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale());

     -- ������ ��������
     IF inPartionGoodsDate <= '01.01.1900' THEN inPartionGoodsDate:= NULL; END IF;

     -- ��������� �������� <���� ������>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), inId, inPartionGoodsDate);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.03.20         *
*/
