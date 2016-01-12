-- Function: gpUpdate_MI_SendOnPrice_AmountPartner (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_MI_SendOnPrice_AmountPartner (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_SendOnPrice_AmountPartner(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SendOnPrice_Branch());

     -- ���������
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), MovementItem.Id, COALESCE (MovementItem.Amount, 0))
     FROM MovementItem
     WHERE MovementId = inMovementId;


     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (MovementItem.Id, vbUserId, FALSE)
     FROM MovementItem
     WHERE MovementId = inMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 12.01.16         *
*/

-- ����
-- SELECT * FROM gpUpdate_MI_SendOnPrice_AmountPartner
