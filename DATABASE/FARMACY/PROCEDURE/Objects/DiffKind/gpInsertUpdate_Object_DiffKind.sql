-- Function: gpInsertUpdate_Object_DiffKind()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiffKind (Integer, Integer, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_DiffKind(
 INOUT ioId	             Integer   ,    -- ���� ������� <> 
    IN inCode                Integer   ,    -- ��� ������� 
    IN inName                TVarChar  ,    -- �������� ������� <>
    IN inIsClose             Boolean   ,    -- ������ ��� ������
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
 
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   vbUserId := inSession;
   
   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_DiffKind());
   
   -- �������� ������������ <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_DiffKind(), inName);
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_DiffKind(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_DiffKind(), vbCode_calc, inName);

   -- ���������
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_DiffKind_Close(), ioId, inIsClose);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.12.18         * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_DiffKind()
