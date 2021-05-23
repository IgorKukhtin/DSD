-- Function: gpUpdate_Object_ArticleLoss()

DROP FUNCTION IF EXISTS gpUpdate_Object_ArticleLoss (Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_ArticleLoss (Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_ArticleLoss(
    IN inId                       Integer   ,     -- ���� ������� <������ ��������>  
    IN inBusinessId               Integer   ,     -- ������
    IN inBranchId                 Integer   ,     -- ������
    IN inComment                  TVarChar  ,     -- ���������� 
    IN inSession                  TVarChar        -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ArticleLoss());


   -- ��������� ����� � <������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ArticleLoss_Business(), inId, inBusinessId);
   -- ��������� ����� � <������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ArticleLoss_Branch(), inId, inBranchId);
   -- ��������� c�������� � <����������>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ArticleLoss_Comment(), inId, inComment);
  
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ������ �.�.
 16.11.20         * inBranchId
 27.07.17         *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_ArticleLoss(inId:=null, inBusinessId:=0, inComment:= '', inSession:='2')
