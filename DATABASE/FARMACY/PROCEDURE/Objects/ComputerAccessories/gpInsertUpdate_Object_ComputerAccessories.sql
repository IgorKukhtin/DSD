-- Function: gpInsertUpdate_Object_ComputerAccessories()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ComputerAccessories (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ComputerAccessories(
 INOUT ioId                     Integer   ,     -- ���� ������� <�����>
    IN inCode                   Integer   ,     -- ��� �������
    IN inName                   TVarChar  ,     -- �������� �������
    IN inSession                TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   vbUserId := inSession;

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
     RAISE EXCEPTION '��������� ������ ���������� ��������������';
   END IF;

   IF COALESCE (inName, '') = ''
   THEN
      RAISE EXCEPTION '������. �� ��������� <������������>...';
   END IF;

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ComputerAccessories());

   -- �������� ������������ ��� �������� <������������> 
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ComputerAccessories(), inName);
   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ComputerAccessories(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ComputerAccessories(), vbCode_calc, inName);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ComputerAccessories (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 14.07.20                                                       *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ComputerAccessories(ioId:=null, inCode:=null, inName:='�����', inSession:='3')