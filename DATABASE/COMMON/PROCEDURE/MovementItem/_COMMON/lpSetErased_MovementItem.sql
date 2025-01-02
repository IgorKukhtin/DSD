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
   -- !!!������ �������� �������!!!
   PERFORM lpCheckPeriodClose_auditor (NULL, NULL, NULL, inMovementItemId, NULL, inUserId);


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
   IF vbStatusId           <> zc_Enum_Status_UnComplete()
      AND vbDescId         <> zc_MI_Sign()
      AND vbMovementDescId <> zc_Movement_PromoPartner()
      AND (vbMovementDescId <> zc_Movement_PromoTrade()
        OR vbDescId         <> zc_MI_Message())   
      AND (COALESCE (vbMovementDescId, 0) <> zc_Movement_BankAccount() OR vbDescId <> zc_MI_Detail())
      AND (COALESCE (vbMovementDescId, 0) <> zc_Movement_Promo() OR vbDescId <> zc_MI_Detail())
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
 
   -- !!!�� ������!!!
   IF vbDescId <> zc_MI_Sign()
   THEN
       -- !!!�� ������!!!
       IF vbDescId <> zc_MI_Child() OR vbMovementDescId NOT IN (zc_Movement_PersonalService(), zc_Movement_OrderGoodsDetail(), zc_Movement_PromoTrade())
       THEN
           -- ����������� �������� ����� �� ���������
           PERFORM lpInsertUpdate_MovementFloat_TotalSumm (vbMovementId);
       END IF;
 
       -- ��������� ��������
       PERFORM lpInsert_MovementItemProtocol (inMovementItemId:= inMovementItemId, inUserId:= inUserId, inIsInsert:= FALSE, inIsErased:= TRUE);

   END IF;
 

 
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
