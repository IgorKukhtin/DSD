-- Function: gpUpdate_Object_MemberExternal_GLN()

DROP FUNCTION IF EXISTS gpUpdate_Object_MemberExternal_GLN (Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_MemberExternal_GLN(
    IN inMemberExternalId      Integer   ,    -- ���� ������� <������������> 
    IN inGLN                   TVarChar  ,    -- 
    IN inSession               TVarChar       -- ������ ������������
)
  RETURNS Void 
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_MemberExternal_GLN());
   
   
   IF COALESCE (inMemberExternalId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�� ���������� ���.����.';
   END IF;

   --
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_MemberExternal_GLN(), inMemberExternalId, inGLN);
  
   -- C�������� ��������
   PERFORM lpInsert_ObjectProtocol (inMemberExternalId, vbUserId);
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.05.23         *
*/

-- ����
--