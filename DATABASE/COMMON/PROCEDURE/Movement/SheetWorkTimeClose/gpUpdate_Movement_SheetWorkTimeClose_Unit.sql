-- Function: gpUpdate_Movement_SheetWorkTimeClose_Unit()

DROP FUNCTION IF EXISTS gpUpdate_Movement_SheetWorkTimeClose_Unit (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_SheetWorkTimeClose_Unit(
    IN inId                  Integer   , -- ���� ������� <��������>
    IN inUnitId              Integer   , -- �������������(����������)
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_SheetWorkTimeClose());

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), inId, inUnitId);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.02.24         *
*/

-- ����
--