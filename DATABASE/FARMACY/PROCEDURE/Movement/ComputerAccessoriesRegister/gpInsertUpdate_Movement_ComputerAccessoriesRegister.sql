-- Function: gpInsertUpdate_Movement_ComputerAccessoriesRegister()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ComputerAccessoriesRegister (Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ComputerAccessoriesRegister(
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
     vbUserId := inSession;
      
     IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
     THEN
       RAISE EXCEPTION '��������� ������ ���������� ��������������';
     END IF;
     
     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_ComputerAccessoriesRegister (ioId               := ioId
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
 14.07.20                                                       *
*/

-- ����
-- 
