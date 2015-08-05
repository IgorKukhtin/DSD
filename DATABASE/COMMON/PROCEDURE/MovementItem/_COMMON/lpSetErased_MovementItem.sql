-- Function: lpSetErased_MovementItem (Integer, Integer)

DROP FUNCTION IF EXISTS lpSetErased_MovementItem (Integer, Integer);

CREATE OR REPLACE FUNCTION lpSetErased_MovementItem(
    IN inMovementItemId      Integer              , -- ���� ������� <������� ���������>
   OUT outIsErased           Boolean              , -- ����� ��������
    IN inUserId              Integer
)                              
  RETURNS Boolean
AS
$BODY$
   DECLARE vbMovementId Integer;
   DECLARE vbStatusId Integer;
BEGIN
  -- ������������� ����� ��������
  outIsErased := TRUE;

  -- ����������� ������ 
  UPDATE MovementItem SET isErased = TRUE WHERE Id = inMovementItemId
         RETURNING MovementId INTO vbMovementId;

  -- �������� - ��������� ��������� �������� ������
  -- PERFORM lfCheck_Movement_Parent (inMovementId:= vbMovementId, inComment:= '���������');

  -- ���������� <������>
  vbStatusId := (SELECT StatusId FROM Movement WHERE Id = vbMovementId);
  -- �������� - �����������/��������� ��������� �������� ������
  IF vbStatusId <> zc_Enum_Status_UnComplete()
     -- AND inUserId <> 5 -- !!!�������� ��� �������� �� Sybase!!!
  THEN
      /*IF AND vbStatusId = zc_Enum_Status_Erased() 
      THEN
         IF NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
         THEN RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
         END IF;
      ELSE RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
      END IF;*/

      RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
  END IF;

  -- ����������� �������� ����� �� ���������
  PERFORM lpInsertUpdate_MovementFloat_TotalSumm (vbMovementId);

  -- ��������� ��������
  PERFORM lpInsert_MovementItemProtocol (inMovementItemId:= inMovementItemId, inUserId:= inUserId, inIsInsert:= FALSE, inIsErased:= TRUE);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpSetErased_MovementItem (Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.10.14                                        * set lp
 02.04.14                                        * add zc_Enum_Role_Admin
 06.10.13                                        * add vbStatusId
 06.10.13                                        * add lfCheck_Movement_Parent
 06.10.13                                        * add lpInsertUpdate_MovementFloat_TotalSumm
 06.10.13                                        * add outIsErased
 01.10.13                                        *
*/

-- ����
-- SELECT * FROM lpSetErased_MovementItem (inMovementItemId:= 0, inUserId:= '5')
