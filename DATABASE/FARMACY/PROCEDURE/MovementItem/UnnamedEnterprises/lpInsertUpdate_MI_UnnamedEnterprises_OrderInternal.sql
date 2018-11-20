-- Function: lpInsertUpdate_MI_UnnamedEnterprises_OrderInternal()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_UnnamedEnterprises_OrderInternal(Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_UnnamedEnterprises_OrderInternal(
    IN vbOrderInternalId     Integer   ,    -- ���� ������� <>
    IN inGoodsId             Integer   ,    -- ��� ������
    IN inAmountOrder         TFloat    ,    -- ����������
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOIIId Integer;
   DECLARE vbComment TVarChar;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
  vbUserId:= inSession;

  IF EXISTS(SELECT 1 FROM MovementItem WHERE MovementItem.DescId = zc_MI_Master() AND MovementItem.ObjectId = inGoodsId AND MovementItem.MovementID = vbOrderInternalId)
  THEN
    SELECT
      MovementItem.Id,
      inAmountOrder + MovementItem.Amount
    INTO
      vbOIIId,
      inAmountOrder
    FROM MovementItem
    WHERE MovementItem.DescId = zc_MI_Master()
      AND MovementItem.ObjectId = inGoodsId
      AND MovementItem.MovementID = vbOrderInternalId;
  ELSE
    vbOIIId := 0;
  END IF;

  vbOIIId := lpInsertUpdate_MovementItem_OrderInternal(vbOIIId, vbOrderInternalId, inGoodsId, inAmountOrder, Null, NULL, vbUserId);

  vbComment := COALESCE ((SELECT MovementItemString.ValueData FROM MovementItemString
                          WHERE MovementItemString.DescId = zc_MIString_Comment() and MovementItemString.MovementItemID = vbOIIId), '');

  IF vbComment = ''
  THEN
    vbComment := '��';
  ELSE
    vbComment := vbComment || ' ��';
  END IF;

    -- ��������� �������� <����������>
  PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), vbOIIId, vbComment);

END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������ �.�.
 15.11.18        *

*/

-- ����
-- SELECT * FROM lpInsertUpdate_MI_UnnamedEnterprises_OrderInternal
