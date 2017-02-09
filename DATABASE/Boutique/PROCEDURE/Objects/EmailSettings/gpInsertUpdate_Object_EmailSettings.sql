-- Function: gpInsertUpdate_Object_EmailSettings()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_EmailSettings (Integer, Integer, TVarChar, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_EmailSettings(
 INOUT ioId                            Integer   , -- ���� �������
    IN inCode                          Integer   , -- ��� ������� 
    IN inValue                         TVarChar  , -- ��������
    IN inEmailKindId                   Integer   , -- ��� ����� 
    IN inEmailToolsId                  Integer   , -- ��������� ��������� ��� �����
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

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_EmailSettings());
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_EmailSettings(), vbCode_calc, inValue);

   -- ��������� ����� � <
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_EmailSettings_EmailKind(), ioId, inEmailKindId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_EmailSettings_EmailTools(), ioId, inEmailToolsId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

  
/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.03.16         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_EmailSettings (ioId:=0, inCode:=0, inValue:='����', inEmailKindId:=0, inEmailToolsId:=0, inSession:='2')
