-- Function: gpInsertUpdate_Movement_InventoryHouseholdInventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_InventoryHouseholdInventory (Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_InventoryHouseholdInventory(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inUnitId              Integer   , --
    IN inComment             TVarChar  , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbUserUnitId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_IU_Movement_InventoryHouseholdInventory());
    
     IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
               WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = 308121) -- ��� ���� "������ ������"
     THEN
     
        vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
        IF vbUnitKey = '' THEN
          vbUnitKey := '0';
        END IF;
        vbUserUnitId := vbUnitKey::Integer;
        
        IF COALESCE (vbUserUnitId, 0) = 0
        THEN 
          RAISE EXCEPTION '������. �� ������� ������������� ����������.';     
        END IF;     
        
        IF COALESCE (inUnitId, 0) <> COALESCE (vbUserUnitId, 0)
        THEN 
          RAISE EXCEPTION '������. ��� ��������� �������� ������ � �������������� <%>.', (SELECT ValueData FROM Object WHERE ID = vbUserUnitId);     
        END IF;     
     END IF;     
     
     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_InventoryHouseholdInventory (ioId               := ioId
                                                             , inInvNumber        := inInvNumber
                                                             , inOperDate         := inOperDate
                                                             , inUnitId           := inUnitId
                                                             , inComment          := inComment
                                                             , inUserId           := vbUserId
                                                              );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.07.20                                                       *
*/

-- ����
-- 
