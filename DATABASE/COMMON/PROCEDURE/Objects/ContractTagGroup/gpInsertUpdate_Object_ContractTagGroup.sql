-- Function: gpInsertUpdate_Object_ContractTagGroup()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContractTagGroup(Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ContractTagGroup(
 INOUT ioId                  Integer   ,     -- ���� ������� <������� ������> 
    IN inCode                Integer   ,     -- ��� �������  
    IN inName                TVarChar  ,     -- �������� ������� 
    IN inSession             TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ContractTagGroup());
   vbUserId:= lpGetUserBySession (inSession);


   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ContractTagGroup());
   
   -- �������� ���� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_ContractTagGroup(), inName);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ContractTagGroup(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ContractTagGroup(), vbCode_calc, inName);
   

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.01.15         * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ContractTagGroup(ioId:=null, inCode:=null, inName:='�������� ���� 1', inSession:='2')
