-- Function: gpInsertUpdate_Object_ContractKind()

-- DROP FUNCTION gpInsertUpdate_Object_ContractKind();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ContractKind(
INOUT ioId	                Integer,       -- ���� ������� <���� ���������>
   IN inCode                Integer   ,    -- ��� ������� <���� ���������>
   IN inName                TVarChar  ,    -- �������� ������� <���� ���������>
   IN inSession             TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ContractKind());
   vbUserId := inSession;
   
   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ContractKind()); 
   
   -- �������� ���� ������������ ��� �������� <���� ��������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_ContractKind(), inName);
   -- �������� ���� ������������ ��� �������� <��� ���� ��������>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ContractKind(), vbCode_calc);


   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ContractKind(), vbCode_calc, inName);
   -- ��������� ����� � <���� ������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContractKind_AccountKind(), ioId, CASE WHEN vbCode_calc < 100 THEN zc_Enum_AccountKind_Active() WHEN vbCode_calc < 200 THEN zc_Enum_AccountKind_Passive() END);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ContractKind (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.12.13                                        * add zc_ObjectLink_ContractKind_AccountKind
 22.12.13                                        * Cyr1251
 21.10.13                                        * add vbCode_calc
 11.06.13          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Route()
