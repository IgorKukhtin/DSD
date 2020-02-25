-- Function: gpInsertUpdate_User_PasswordEHels()

DROP FUNCTION IF EXISTS gpInsertUpdate_User_PasswordEHels (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_User_PasswordEHels(
    IN inId               Integer   ,    -- ���� ������� <������������> 
    IN inPasswordEHels    TVarChar  ,    -- ������ �-����
    IN inSession          TVarChar       -- ������ ������������
)
  RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE Code_max Integer;  
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_User());

   IF 3 <> inSession::Integer AND 375661 <> inSession::Integer AND 4183126 <> inSession::Integer AND
     8001630 <> inSession::Integer AND 9560329 <> inSession::Integer
   THEN
     RAISE EXCEPTION '� ��� ��� ���� ���������� ��������.';
   END IF;

   IF COALESCE (inId, 0) = 0
   THEN
     RAISE EXCEPTION '������ �� ���������.';
   END IF;

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Helsi_PasswordEHels(), inId, inPasswordEHels);

   -- ������� ���������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 29.04.19                                                       *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_User_PasswordEHels ('3')

