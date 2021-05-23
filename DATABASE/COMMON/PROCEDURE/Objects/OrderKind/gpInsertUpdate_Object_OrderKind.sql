-- Function: gpInsertUpdate_Object_OrderKind(Integer,Integer,TVarChar,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_OrderKind(Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_OrderKind(
 INOUT ioId	             Integer,       -- ���� ������� <��� ����������� ������>
    IN inCode                Integer,       -- ��� ������� <>
    IN inName                TVarChar,      -- �������� ������� <>
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;  
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_OrderKind());
   vbUserId:= lpGetUserBySession (inSession);

   
   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_OrderKind());
   
   -- �������� ���� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_OrderKind(), inName);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_OrderKind(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_OrderKind(), vbCode_calc, inName);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_OrderKind (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 03.12.14                          * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_OrderKind ()
