-- Function: gpUpdate_Object_User_Language()

DROP FUNCTION IF EXISTS gpUpdate_Object_User_Language (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_User_Language(
    IN inLanguageCode Integer ,      -- 
    IN inSession      TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId     Integer;
  DECLARE vbLanguageId Integer;  
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      vbUserId:= lpGetUserBySession (inSession);
      
      -- ��������
      IF COALESCE (vbUserId, 0) = 0
      THEN
          RAISE EXCEPTION '������.�� ������ ������������ ��� ������ = <%>', inSession;
      END IF;

      -- �����
      vbLanguageId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Language() AND Object.ObjectCode = inLanguageCode);
      -- ��������
      IF COALESCE (vbLanguageId, 0) = 0
      THEN
          RAISE EXCEPTION '������.�� ������ ���� �������� ��� ���� = <%>', inLanguageCode;
      END IF;


      -- ��������� ��������  <���. ����>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_User_Language(), vbUserId, vbLanguageId);

      -- ������� ���������
       PERFORM lpInsert_ObjectProtocol (vbUserId, vbUserId);
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.08.20                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_User_Language (2, zfCalc_UserAdmin())
