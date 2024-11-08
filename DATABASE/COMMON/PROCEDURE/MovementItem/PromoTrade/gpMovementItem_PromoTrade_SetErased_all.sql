-- Function: gpMovementItem_PromoTrade_SetErased_all (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_PromoTrade_SetErased_all (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_PromoTrade_SetErased_all(
    IN inMovementId      Integer              , -- ���� ������� <������� ���������>
    IN inSession         TVarChar               -- ������� ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId          Integer;
BEGIN
  vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_MI_PromoTrade());


  -- ��������
  PERFORM lpSetErased_MovementItem (MovementItem.Id, vbUserId)
  FROM MovementItem
  WHERE MovementItem.MovementId = inMovementId
    AND MovementItem.DescId     = zc_MI_Master()
    AND MovementItem.isErased   = FALSE
   ;
  
  -- ����������� �������� ����� �� ���������
  PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);



END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.09.24         *
*/
