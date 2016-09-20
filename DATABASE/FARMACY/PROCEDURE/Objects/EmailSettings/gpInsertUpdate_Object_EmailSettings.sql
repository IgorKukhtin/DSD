-- Function: gpInsertUpdate_Object_EmailSettings()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_EmailSettings (Integer, Integer, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_EmailSettings (Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_EmailSettings(
 INOUT ioId                            Integer   , -- ���� �������
    IN inCode                          Integer   , -- ��� ������� 
    IN inValue                         TVarChar  , -- ��������
    IN inEmailId                       Integer   , -- �������� ����
    IN inEmailToolsId                  Integer   , -- ��������� ��������� ��� �����
    IN inJuridicalId                   Integer   , -- ����������� ����
    IN inSession                       TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_EmailSettings());

   -- ��������
   IF COALESCE (inEmailId, 0) = 0 THEN
      RAISE EXCEPTION '�� ��������� <�������� ����>';
   END IF;
   -- ��������
   IF COALESCE (inEmailToolsId, 0) = 0 THEN
      RAISE EXCEPTION '�� ��������� <�������� ��������� ��� �����>';
   END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_EmailSettings());
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_EmailSettings(), vbCode_calc, inValue);

   -- ��������� ����� � <
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_EmailSettings_Email(), ioId, inEmailId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_EmailSettings_EmailTools(), ioId, inEmailToolsId);

   -- ��������� ����� � <��.����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_EmailSettings_Juridical(), ioId, inJuridicalId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

  
/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.09.16         * add inJuridicalId
 28.06.16         *
 03.03.16         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_EmailSettings (ioId:=0, inCode:=0, inValue:='����', inEmailKindId:=0, inEmailToolsId:=0, inSession:='2')
