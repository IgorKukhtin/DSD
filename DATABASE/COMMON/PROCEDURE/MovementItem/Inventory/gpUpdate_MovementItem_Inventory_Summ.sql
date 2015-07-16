-- Function: gpUpdate_MovementItem_Inventory_Summ (Integer, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Inventory_Summ (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Inventory_Summ(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inSumm                TFloat    , -- �����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_Inventory_Summ());

     IF inId <> 0
     THEN
          -- ��������� �������� <�����>
          PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), inId, inSumm);

          -- ����������� �������� ����� �� ���������
          PERFORM lpInsertUpdate_MovementFloat_TotalSumm ((SELECT MovementItem.MovementId FROM MovementItem WHERE MovementItem.Id = inId));

          -- ��������� ��������
          PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.07.15                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_MovementItem_Inventory_Summ
