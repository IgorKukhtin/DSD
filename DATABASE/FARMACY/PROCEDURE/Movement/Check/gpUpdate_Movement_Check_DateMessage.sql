-- Function: gpUpdate_Movement_Check_DateMessage()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_DateMessage(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_DateMessage(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inCheckSourceKindId   Integer   , -- ��������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS INTEGER AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;

  IF COALESCE(inCheckSourceKindId, 0) <> zc_Enum_CheckSourceKind_Tabletki()
  THEN
    RETURN 0;
  END IF;

  raise notice 'Value 05: % % %', inMovementId, inCheckSourceKindId, inSession;
  
  IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin()) OR
    NOT EXISTS(SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_CashierPharmacy()) 
  THEN
    RETURN 0;
  END IF;

  IF EXISTS(SELECT * FROM MovementBoolean 
            WHERE MovementBoolean.DescId = zc_MovementBoolean_AccruedFine()
              AND MovementBoolean.MovementId = inMovementId)
  THEN
    RETURN 0;
  END IF;

   
  IF NOT EXISTS(SELECT * FROM MovementDate 
                WHERE MovementDate.DescId = zc_MovementDate_Message()
                  AND MovementDate.MovementId = inMovementId)
  THEN
    --������ ������� ���� ����� ���������
    PERFORM lpInsertUpdate_MovementDate(zc_MovementDate_Message(), inMovementId, CURRENT_TIMESTAMP);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);
    
  ELSEIF (SELECT MovementDate.ValueData FROM MovementDate 
          WHERE MovementDate.DescId = zc_MovementDate_Message()
            AND MovementDate.MovementId = inMovementId) < CURRENT_TIMESTAMP - INTERVAL '31 MINUTE'
  THEN 
    --������ ������� ��������� �����
    PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_AccruedFine(), inMovementId, TRUE);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);  
  END IF;

  -- !!!�������� ��� �����!!!
  IF inSession = zfCalc_UserAdmin()
  THEN
      RAISE EXCEPTION '���� ������ ������� ��� % % %', inMovementId, inCheckSourceKindId, inSession;
  END IF;
              
  RETURN 1;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ������ �.�.
 15.04.21                                                                    *
*/

-- ����