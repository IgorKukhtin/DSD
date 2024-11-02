-- Function: lpSetUnErased_MovementItem (Integer, Integer)

DROP FUNCTION IF EXISTS lpSetUnErased_MovementItem (Integer, Integer);

CREATE OR REPLACE FUNCTION lpSetUnErased_MovementItem(
    IN inMovementItemId      Integer              , -- ���� ������� <������� ���������>
   OUT outIsErased           Boolean              , -- ����� ��������
    IN inUserId              Integer
)                              
  RETURNS Boolean
AS
$BODY$
   DECLARE vbMovementId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbDescId     Integer;
   DECLARE vbMovementDescId Integer;
BEGIN
  -- !!!������ �������� �������!!!
  PERFORM lpCheckPeriodClose_auditor (NULL, NULL, NULL, inMovementItemId, NULL, inUserId);


  -- ������������� ����� ��������
  outIsErased := FALSE;

  -- ����������� ������ 
  UPDATE MovementItem SET isErased = FALSE WHERE Id = inMovementItemId
         RETURNING MovementId, DescId INTO vbMovementId, vbDescId;

  -- �������� - ��������� ��������� �������� ������
  -- PERFORM lfCheck_Movement_Parent (inMovementId:= vbMovementId, inComment:= '���������');


  -- ���������� <������> � ��� ���������
   SELECT StatusId ,DescId
 INTO vbStatusId, vbMovementDescId
   FROM Movement WHERE Id = vbMovementId;

  -- �������� - �����������/��������� ��������� �������� ������
  IF vbStatusId <> zc_Enum_Status_UnComplete()
  AND (COALESCE (vbMovementDescId, 0) <> zc_Movement_BankAccount() OR vbDescId <> zc_MI_Detail())
  THEN
      RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
  END IF;

  -- ����������� �������� ����� �� ���������
  PERFORM lpInsertUpdate_MovementFloat_TotalSumm (vbMovementId);

  -- ��������� ��������
  PERFORM lpInsert_MovementItemProtocol (inMovementItemId:= inMovementItemId, inUserId:= inUserId, inIsInsert:= FALSE, inIsErased:= FALSE);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpSetUnErased_MovementItem (Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.10.14                                        * set lp
 06.10.13                                        * add vbStatusId
 06.10.13                                        * add lfCheck_Movement_Parent
 06.10.13                                        * add lpInsertUpdate_MovementFloat_TotalSumm
 06.10.13                                        * add outIsErased
 01.10.13                                        *
*/

-- ����
-- SELECT * FROM lpSetUnErased_MovementItem (inMovementItemId:= 0, inUserId:= '5')
