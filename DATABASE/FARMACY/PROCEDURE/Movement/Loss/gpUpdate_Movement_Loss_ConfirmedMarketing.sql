-- Function: gpUpdate_Movement_Loss_ConfirmedMarketing()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Loss_ConfirmedMarketing(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Loss_ConfirmedMarketing(
    IN inMovementId            Integer   ,    -- ���� ���������
 INOUT ioisConfirmedMarketing  Boolean   ,    -- ������������ �����������
    IN inSession               TVarChar       -- ������� ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId          Integer;
   DECLARE vbStatusId        Integer;
BEGIN

   IF COALESCE(inMovementId, 0) = 0 THEN
      RETURN;
   END IF;
   vbUserId := lpGetUserBySession (inSession);

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin(), 12084491))
   THEN
     RAISE EXCEPTION '��������� "������������ �����������" ��� ���������.';
   END IF;

   SELECT Movement.StatusId
   INTO vbStatusId
   FROM Movement
   WHERE Movement.Id = inMovementId;

   IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_UnComplete()
   THEN
      RAISE EXCEPTION '������. ��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
   END IF;
   
   ioisConfirmedMarketing := NOT ioisConfirmedMarketing;

   -- ��������� �������
   PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_ConfirmedMarketing(), inMovementId, ioisConfirmedMarketing);

   -- ��������� ��������
   PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.  ������ �.�.
 22.12.19                                                                      *
*/

-- select * from gpUpdate_Movement_Loss_ConfirmedMarketing(inMovementId := 21976992 , ioisConfirmedMarketing := 'False' ,  inSession := '3');