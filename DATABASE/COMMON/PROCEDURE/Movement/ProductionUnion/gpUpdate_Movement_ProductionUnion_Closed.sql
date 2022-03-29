-- Function: gpUpdate_Movement_ProductionUnion_Closed()

DROP FUNCTION IF EXISTS gpUpdate_Movement_ProductionUnion_Closed (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_ProductionUnion_Closed(
    IN inId                  Integer   , -- ���� ������� <��������>
    IN inisClosed            Boolean   , --
   OUT outClosed             Boolean   , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProductionUnion());
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������� �������
     outClosed := not inisClosed;

     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Closed(), inId, outClosed);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.03.22          *
*/

-- ����
--  