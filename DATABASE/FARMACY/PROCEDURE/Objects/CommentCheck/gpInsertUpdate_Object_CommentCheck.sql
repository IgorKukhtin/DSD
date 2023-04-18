-- Function: gpInsertUpdate_Object_CommentCheck()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CommentCheck(Integer, Integer, TVarChar, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CommentCheck(
 INOUT ioId                 Integer   ,     -- ���� ������� <����������> 
    IN inCode               Integer   ,     -- ��� �������  
    IN inName               TVarChar  ,     -- ��������
    IN inCommentTRId        Integer   ,     -- ����������� ����� ������������ ���������
    IN inisSendPartionDate  Boolean   ,     -- �������� ���������
    IN inisLostPositions    Boolean   ,     -- ��������� �������
    IN inSession            TVarChar        -- ����������� ������ �� ��������� �����
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
--    vbUserId:=lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_CommentCheck());

   vbUserId := inSession::Integer;

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND (RoleId IN (zc_Enum_Role_Admin(), 13536335 )))
   THEN
     RAISE EXCEPTION '��������� ������ ���������� ��������������';
   END IF;
   
   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_CommentCheck());
   
   -- �������� ���� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_CommentCheck(), inName);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_CommentCheck(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_CommentCheck(), vbCode_calc, inName);

   -- ��������� ����� � <����������� ����� ������������ ���������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_CommentCheck_CommentTR(), ioId, inCommentTRId);
   
   -- ��������� ����������� ������ �� ��������� �����
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CommentSun_SendPartionDate(), ioId, inisSendPartionDate);
   -- ��������� ����������� ������ �� ��������� �����
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CommentSun_LostPositions(), ioId, inisLostPositions);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 18.04.23                                                       *
*/

-- ����
