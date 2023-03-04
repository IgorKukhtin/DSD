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
    DECLARE vbStatusId   Integer;
    DECLARE vbDescId     Integer;
    DECLARE vbMovementDescId Integer;
 BEGIN
   -- ������������� ����� ��������
   outIsErased := TRUE;
 
   -- ����������� ������ 
   UPDATE MovementItem SET isErased = TRUE WHERE Id = inMovementItemId
          RETURNING MovementId, DescId INTO vbMovementId, vbDescId;
 
   -- �������� - ��������� ��������� �������� ������
   -- PERFORM lfCheck_Movement_Parent (inMovementId:= vbMovementId, inComment:= '���������');
 
   -- ���������� <������>
   SELECT StatusId, DescId INTO vbStatusId, vbMovementDescId FROM Movement WHERE Id = vbMovementId;

   -- �������� - �����������/��������� ��������� �������� ������
   IF vbStatusId <> zc_Enum_Status_UnComplete() AND vbDescId <> zc_MI_Sign()
      AND (vbMovementDescId <> zc_Movement_Cash() OR vbDescId <> zc_MI_Child())
   THEN

       RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
   END IF;
 
   IF vbMovementDescId = zc_Movement_Cash() AND vbDescId = zc_MI_Child()
   THEN
       -- ���� ������������� ������������
       IF EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = vbMovementId AND MB.DescId = zc_MovementBoolean_Sign() AND MB.ValueData = TRUE)
       THEN
           RAISE EXCEPTION '������.������ �������, ������������� ��� ������������.';
       ELSE
           -- ������� ��� �������
           PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id, inUserId:= inUserId)
           FROM MovementItem
           WHERE MovementItem.MovementId = vbMovementId
             AND MovementItem.DescId     = zc_MI_Sign()
             AND MovementItem.isErased   = FALSE
            ;
       END IF;

   END IF;

   -- 
   /*IF vbDescId <> zc_MI_Sign()
   THEN
       -- ����������� �������� ����� �� ���������
       PERFORM lpInsertUpdate_MovementFloat_TotalSumm (vbMovementId);
   END IF;*/
 
   -- ��������� ��������
   PERFORM lpInsert_MovementItemProtocol (inMovementItemId:= inMovementItemId, inUserId:= inUserId, inIsInsert:= FALSE, inIsErased:= TRUE);
 
 
 END;
 $BODY$
   LANGUAGE plpgsql VOLATILE;
 
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
