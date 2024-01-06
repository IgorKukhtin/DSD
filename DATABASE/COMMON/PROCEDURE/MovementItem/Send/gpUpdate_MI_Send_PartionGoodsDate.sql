-- Function: gpUpdate_MI_Send_PartionGoodsDate()

DROP FUNCTION IF EXISTS gpUpdate_MI_Send_PartionGoodsDate (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Send_PartionGoodsDate(
    IN inId                       Integer   , -- ���� ������� <������� ���������>
    IN inPartionGoodsDate         TDateTime , -- ���� ������
    IN inSession                  TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId   Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());

     IF COALESCE (inId,0) = 0
     THEN
         RETURN;
     END IF;
     
     -- ������ ��������
     IF inPartionGoodsDate <= '01.01.1900' THEN inPartionGoodsDate:= NULL; END IF;
     
     -- ��������� �������� <���� ������>
     IF COALESCE (inPartionGoodsDate, zc_DateStart()) <> zc_DateStart() OR EXISTS (SELECT 1 FROM MovementItemDate AS MID WHERE MID.MovementItemId = inId AND MID.DescId = zc_MIDate_PartionGoods())
     THEN
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), inId, inPartionGoodsDate); 
     END IF;

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.12.23         *
*/

-- ����
--