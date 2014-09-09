-- Function: gpInsertUpdate_Object_Branch (Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Branch (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Branch(
 INOUT ioId                  Integer,       -- ���� ������� <������>
    IN inCode                Integer,       -- ��� ������� <������> 
    IN inName                TVarChar,      -- �������� ������� <������>
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Branch());

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ��������� + 1
   vbCode_calc := lfGet_ObjectCode (inCode, zc_Object_Branch());

   -- �������� ���� ������������ ��� �������� <������������ �������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Branch(), inName);
   -- �������� ���� ������������ ��� �������� <��� �������>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Branch(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Branch(), vbCode_calc, inName
                                , inAccessKeyId:= CASE WHEN vbCode_calc = 1 -- ������ �����
                                                            THEN zc_Enum_Process_AccessKey_TrasportDnepr()

                                                       WHEN vbCode_calc = 2 -- ������ ����
                                                            THEN zc_Enum_Process_AccessKey_TrasportKiev()

                                                       WHEN vbCode_calc = 3 -- ������ �������� (������)
                                                            THEN zc_Enum_Process_AccessKey_TrasportNikolaev()

                                                       -- WHEN vbCode_calc = 4 -- ������ ������
                                                       --      THEN zc_Enum_Process_AccessKey_()

                                                       WHEN vbCode_calc = 5 -- ������ �������� ( ����������)
                                                            THEN zc_Enum_Process_AccessKey_TrasportCherkassi()

                                                       -- WHEN vbCode_calc = 6 -- ������ ����
                                                       --      THEN zc_Enum_Process_AccessKey_()

                                                       WHEN vbCode_calc = 7 -- ������ ��.���
                                                            THEN zc_Enum_Process_AccessKey_TrasportKrRog()

                                                       WHEN vbCode_calc = 8 -- ������ ������
                                                            THEN zc_Enum_Process_AccessKey_TrasportDoneck()

                                                       WHEN vbCode_calc = 9 -- ������ �������
                                                            THEN zc_Enum_Process_AccessKey_TrasportKharkov()

                                                       -- WHEN vbCode_calc = 10 -- ������ ��������
                                                       --      THEN zc_Enum_Process_AccessKey_()
                                                  END);
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Branch (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.12.13                                        * add inAccessKeyId
 10.05.13          *
 05.06.13          
 02.07.13                        * ����� JuridicalId     
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Branch(1,1,'','')