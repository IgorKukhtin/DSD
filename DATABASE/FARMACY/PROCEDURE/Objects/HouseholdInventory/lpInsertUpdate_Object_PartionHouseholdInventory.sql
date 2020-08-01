-- Function: lpInsertUpdate_Object_PartionHouseholdInventory()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_PartionHouseholdInventory (Integer, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_PartionHouseholdInventory(
 INOUT ioId                     Integer   ,     -- ���� ������� <>
    IN inOrderID                Integer   ,     -- ���������� �����
    IN inUnitId                 Integer   ,     -- �������������
    IN inMovementItemId         Integer   ,     -- ���� �������� ������� �������������� ���������
    IN inUserId                 Integer     -- ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbInvNumber Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
--   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_HouseholdInventory());

   IF COALESCE (inOrderID, 0) = 0 OR COALESCE (inMovementItemId, 0) = 0 OR COALESCE (inUnitId, 0) = 0
   THEN
      RAISE EXCEPTION '������. �� ��������� <���������� �����>...';
   END IF;

   -- �������� ����� ID
   IF EXISTS(SELECT Object.ID 
             FROM ObjectFloat 
                  INNER JOIN Object ON Object.ID = ObjectFloat.ObjectID
                                   AND Object.ValueData = inOrderID::TVarChar
             WHERE ObjectFloat.DescId = zc_ObjectFloat_PartionHouseholdInventory_MovementItemId()
               AND ObjectFloat.ValueData = inMovementItemId) 
   THEN 
     SELECT Object.ID, Object.ObjectCode 
     INTO ioId, vbInvNumber
     FROM ObjectFloat 
          INNER JOIN Object ON Object.ID = ObjectFloat.ObjectID
                           AND Object.ValueData = inOrderID::TVarChar
     WHERE ObjectFloat.DescId = zc_ObjectFloat_PartionHouseholdInventory_MovementItemId()
       AND ObjectFloat.ValueData = inMovementItemId;
   ELSE
     ioId := 0;
     vbInvNumber := lfGet_ObjectCode(0, zc_Object_PartionHouseholdInventory()) ;
   END IF;
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, c(), vbInvNumber, inOrderID::TVarChar);
   
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