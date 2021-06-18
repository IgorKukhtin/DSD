-- Function: gpInsertUpdate_Object_Reason(Integer,Integer,TVarChar,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Reason(Integer,Integer,TVarChar,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Reason(
 INOUT ioId	             Integer,       -- ���� ������� <>
    IN inCode                Integer,       -- ��� ������� <>
    IN inName                TVarChar,      -- �������� ������� <>
    IN inReturnKindId        Integer,       -- ��� ��������
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;  
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Reason());

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   inCode:=lfGet_ObjectCode (inCode, zc_Object_Reason());
   
   -- �������� ���� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Reason(), inName);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Reason(), inCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Reason(), inCode, inName);
   
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Reason_ReturnKind(), ioId, inReturnKindId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.06.21         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Reason ()
                            