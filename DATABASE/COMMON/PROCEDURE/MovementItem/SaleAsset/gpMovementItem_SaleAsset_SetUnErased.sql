-- Function: gpMovementItem_Loss_SetUnErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_SaleAsset_SetUnErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_SaleAsset_SetUnErased(
    IN inMovementItemId      Integer              , -- ���� ������� <������� ���������>
   OUT outIsErased           Boolean              , -- ����� ��������
    IN inSession             TVarChar               -- ������� ������������
)
  RETURNS Boolean
AS
$BODY$
   DECLARE vbMovementId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbUserId Integer;
BEGIN
  vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetUnErased_MI_SaleAsset());

  -- ������������� ����� ��������
  outIsErased := FALSE;

  -- ����������� ������
  UPDATE MovementItem SET isErased = FALSE WHERE Id = inMovementItemId
         RETURNING MovementId INTO vbMovementId;

  -- ���������� <������>
  vbStatusId := (SELECT CASE WHEN StatusId_next = zc_Enum_Status_UnComplete() THEN StatusId_next ELSE StatusId END FROM Movement WHERE Id = vbMovementId);
  -- �������� - �����������/��������� ��������� �������� ������
  IF vbStatusId <> zc_Enum_Status_UnComplete()
  THEN
      RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
  END IF;

  -- ����������� �������� ����� �� ���������
  PERFORM lpInsertUpdate_MovementFloat_TotalSumm (vbMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.06.20         *
*/

-- ����
--