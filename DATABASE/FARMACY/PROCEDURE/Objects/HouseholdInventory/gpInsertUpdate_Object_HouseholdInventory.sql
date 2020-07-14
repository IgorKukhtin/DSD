-- Function: gpInsertUpdate_Object_HouseholdInventory()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_HouseholdInventory (Integer, Integer, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_HouseholdInventory(
 INOUT ioId                     Integer   ,     -- ���� ������� <�����>
    IN inCode                   Integer   ,     -- ��� �������
    IN inName                   TVarChar  ,     -- �������� �������
    IN inCountForPrice          TFloat    ,     -- �������������
    IN inSession                TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_HouseholdInventory());

   IF COALESCE (inName, '') = ''
   THEN
      RAISE EXCEPTION '������. �� ��������� <������������>...';
   END IF;

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_HouseholdInventory());

   -- �������� ������������ ��� �������� <������������> 
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_HouseholdInventory(), inName);
   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_HouseholdInventory(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_HouseholdInventory(), vbCode_calc, inName);

   -- ��������� �������� <�������������>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_HouseholdInventory_CountForPrice(), ioId, inCountForPrice);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_HouseholdInventory (Integer, Integer, TVarChar, TFloat, TVarChar) OWNER TO postgres;


-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 08.07.20                                                       *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_HouseholdInventory(ioId:=null, inCode:=null, inName:='�����', inSession:='3')