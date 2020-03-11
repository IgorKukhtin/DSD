-- Function: gpInsertUpdate_Object_CommentTR()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CommentTR(Integer, Integer, TVarChar, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CommentTR(
 INOUT ioId             Integer   ,     -- ���� ������� <����������> 
    IN inCode           Integer   ,     -- ��� �������  
    IN inName           TVarChar  ,     -- ��������
    IN inisExplanation  Boolean   ,     -- ������������ ���������� ���������
    IN inisResort       Boolean   ,     -- �������� ���������
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
--    vbUserId:=lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_CommentTR());

   vbUserId := inSession::Integer;

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
     RAISE EXCEPTION '��������� ������ ���������� ��������������';
   END IF;
   
   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_CommentTR());
   
   -- �������� ���� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_CommentTR(), inName);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_CommentTR(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_CommentTR(), vbCode_calc, inName);
   
   -- ��������� ������������ ���������� ���������
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CommentTR_Explanation(), ioId, inisExplanation);

   -- ��������� ������������ ���������� ���������
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CommentTR_Resort(), ioId, inisResort);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.02.20                                                       *
*/

-- ����
