-- Function: gpUpdate_Movement_OrderExternal_SupplierFailures()

DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderExternal_SupplierFailures(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_OrderExternal_SupplierFailures(
    IN inMovementId          Integer   ,    -- ���� ���������
    IN inisSupplierFailures  Boolean   ,    -- �������
   OUT outisSupplierFailures Boolean   ,
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inMovementId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   -- ���������� �������
   outisSupplierFailures:=  inisSupplierFailures;

   PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_SupplierFailures(), inMovementId, inisSupplierFailures);

   -- ��������� ��������
   PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, false);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 08.03.22                                                      *
*/