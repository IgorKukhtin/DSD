-- Function: gpInsertUpdate_Object_Email()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Email (Integer, Integer, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Email (Integer, Integer, TVarChar, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Email(
 INOUT ioId                            Integer   , -- ���� �������
    IN inCode                          Integer   , -- ��� ������� 
    IN inName                          TVarChar  , -- ��������
    IN inErrorTo                       TVarChar  , -- ���� ���������� ��������� �� ������ ��� �������� ������ � �/�
    IN inEmailKindId                   Integer   , -- ��� ��������� �����
    IN inSession                       TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Email());
   vbUserId := inSession;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Email());
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Email(), vbCode_calc, inName);

   -- ��������� ����� � <
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Email_EmailKind(), ioId, inEmailKindId);
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Email_ErrorTo(), ioId, inErrorTo);
 

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

  
/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.06.16         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Email (ioId:=0, inCode:=0, inValue:='����', inEmailKindId:=0, inSession:='2')
