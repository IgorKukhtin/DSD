-- Function: gpUpdate_MovementItem_TestingTuning_Storekeeper()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_TestingTuning_Storekeeper (Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_TestingTuning_Storekeeper(
    IN inId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inParentId              Integer   , -- ���� ������� <��������> 
    IN inisStorekeeper         Boolean   , -- ������ � ����������
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_lTestingTuning);
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession::Integer;

     -- ��������� ������ ����������� � ������� ������    
    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId IN (zc_Enum_Role_Admin(), zc_Enum_Role_TestingTuning()))
    THEN
      RAISE EXCEPTION '��� ��������� �������� ��������� ������������';
    END IF;

    --��������� �� ������������ ���-��
    IF COALESCE(inMovementId, 0) = 0 or COALESCE(inParentId, 0) = 0 or COALESCE(inId, 0) = 0
    THEN
      RAISE EXCEPTION '������. �� �������� ��������.';
    END IF;     
 
    -- ��������� �������� <������ � ����������>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Storekeeper(), inId, not inisStorekeeper);
        
    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_MovementItem_TestingTuning_Storekeeper (Integer, Integer, Integer, Boolean, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 06.07.21                                                                     *  
*/

-- ����
-- select * from gpUpdate_MovementItem_TestingTuning_Storekeeper(inId := 440869114 , inMovementId := 23977600 , inParentId := 440823953 , inisStorekeeper := 'False' ,  inSession := '3');
