-- Function: gpUpdate_TechnicalRediscount_RedCheck()

DROP FUNCTION IF EXISTS gpUpdate_TechnicalRediscount_RedCheck(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_TechnicalRediscount_RedCheck(
    IN inMovementId          Integer   , -- ���� ������� <��������>
 INOUT ioisRedCheck          Boolean   ,   
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TechnicalRediscount());

    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION '������.������� ��������� �� ��������.';
    END IF;

     -- ��������� ������ ����������� � ������� ������
    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
       AND vbUserId <> 11263040
    THEN
      RAISE EXCEPTION '��������� ������ ���������� ��������������';
    END IF;

    SELECT 
      StatusId
    INTO
      vbStatusId
    FROM Movement 
    WHERE Id = inMovementId;
            
    IF vbStatusId <> zc_Enum_Status_UnComplete() 
    THEN
        RAISE EXCEPTION '������. ��������� ������������ ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    ioisRedCheck := NOT ioisRedCheck;
    
      -- ��������� <������� ���>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_RedCheck(), inMovementId, ioisRedCheck);

    
    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (inMovementId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 14.01.21                                                        *
*/

-- ����
-- select * from gpUpdate_TechnicalRediscount_RedCheck(inMovementId := 21444137 , ioisRedCheck := 'True' ,  inSession := '3');