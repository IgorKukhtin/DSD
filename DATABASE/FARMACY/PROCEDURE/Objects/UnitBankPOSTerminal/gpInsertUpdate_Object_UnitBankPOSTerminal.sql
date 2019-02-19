-- Function: gpInsertUpdate_Object_UnitBankPOSTerminal()

-- DROP FUNCTION gpInsertUpdate_Object_UnitBankPOSTerminal();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_UnitBankPOSTerminal(
 INOUT ioId	                Integer   ,     -- ���� ������� ����� 
    IN inUnitId             Integer   ,     -- �������������
    IN inBankPOSTerminalID  Integer   ,     -- ����
    IN inSession            TVarChar        -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);

   -- ��������
   IF COALESCE (inUnitId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�� ����������� �������� <Unit>.';
   END IF;
   -- ��������
   IF COALESCE (inBankPOSTerminalID, 0) = 0
   THEN
       RAISE EXCEPTION '������.�� ����������� �������� <BankPOSTerminal>.';
   END IF;

   -- �������� �����
   IF COALESCE (ioId, 0) = 0
   THEN
       ioId:= (SELECT ObjectLink_UnitBankPOSTerminal_Unit.ObjectId
               FROM ObjectLink AS ObjectLink_UnitBankPOSTerminal_Unit
   
                    JOIN ObjectLink AS ObjectLink_UnitBankPOSTerminal_BankPOSTerminal 
                                    ON ObjectLink_UnitBankPOSTerminal_BankPOSTerminal.ObjectId = ObjectLink_UnitBankPOSTerminal_Unit.ObjectId
                                   AND ObjectLink_UnitBankPOSTerminal_BankPOSTerminal.ChildObjectId = inBankPOSTerminalID 
                                   AND ObjectLink_UnitBankPOSTerminal_BankPOSTerminal.DescId = zc_ObjectLink_UnitBankPOSTerminal_BankPOSTerminal()
                       
               WHERE ObjectLink_UnitBankPOSTerminal_Unit.ChildObjectId = inUnitId
                 AND ObjectLink_UnitBankPOSTerminal_Unit.DescId = zc_ObjectLink_UnitBankPOSTerminal_Unit()
               LIMIT 1);
   END IF;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_UnitBankPOSTerminal(), 0, '');

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_UnitBankPOSTerminal_Unit(), ioId, inUnitId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_UnitBankPOSTerminal_BankPOSTerminal(), ioId, inBankPOSTerminalID);

   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 18.02.19                                                       *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_UnitBankPOSTerminal()
