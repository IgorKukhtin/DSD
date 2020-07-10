-- Function: lpInsertUpdate_Object_PartionHouseholdInventory()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_PartionHouseholdInventory (Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_PartionHouseholdInventory(
 INOUT ioId                     Integer   ,     -- ���� ������� <>
    IN inInvNumber              Integer   ,     -- ����������� �����
    IN inUnitId                 Integer   ,     -- �������������
    IN inMovementItemId         Integer   ,     -- ���� �������� ������� �������������� ���������
    IN inUserId                 Integer     -- ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
--   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_HouseholdInventory());

   IF COALESCE (inInvNumber, 0) = 0
   THEN
      RAISE EXCEPTION '������. �� ��������� <����������� �����>...';
   END IF;

   -- �������� ����� ID
   IF EXISTS(SELECT Object.ID FROM Object 
             WHERE Object.DescId = zc_Object_PartionHouseholdInventory()
               AND Object.ObjectCode = inInvNumber) 
   THEN 
     SELECT Object.ID FROM Object 
     INTO ioId
     WHERE Object.DescId = zc_Object_PartionHouseholdInventory()
       AND Object.ObjectCode = inInvNumber;
   ELSE
     ioId := 0;
   END IF;
   
   IF COALESCE (ioId, 0) = 0 AND COALESCE (inMovementItemId, 0) = 0
   THEN 
      RETURN;
   END IF;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_PartionHouseholdInventory(), inInvNumber, inInvNumber::TVarChar);
   
   -- ��������� 
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionHouseholdInventory_MovementItemId(), ioId, inMovementItemId);

   -- ��������� 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PartionHouseholdInventory_Unit(), ioId, inUnitId);
   
   -- ��������� ��������
--   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_Object_PartionHouseholdInventory (Integer, Integer, Integer, Integer, Integer) OWNER TO postgres;


-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.07.20                                                       *
*/

-- ����
-- 