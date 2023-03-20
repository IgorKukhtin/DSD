-- Function: gpInsertUpdate_Object_HelsiUser()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_HelsiUser (Integer, Integer, TVarChar, TVarChar, TBlob, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_HelsiUser(
    IN inId                        Integer   ,    -- ���� ������� <������������> 
    IN inUnitId                    Integer   ,    -- �������������� ��� �������� ��������������� ����
    IN inUserName                  TVarChar  ,    -- ��� ������������ �� ����� �����
    IN inUserPassword              TVarChar  ,    -- ������ ������������ �� ����� �����
    IN inKey                       TBlob     ,    -- �������� �����
    IN inKeyPassword               TVarChar  ,    -- ������ � ��������� �����
    IN inLikiDnepr_UnitId          Integer   ,    -- ������������� � ��� �������
    IN inLikiDnepr_UserEmail       TVarChar  ,    -- E-mail ��������� �-���� ��� ��� �������
    IN inLikiDnepr_PasswordEHels   TVarChar  ,    -- ������ �-���� ��� ����������� ����� ��� �������
    IN inSession                   TVarChar       -- ������ ������������
)
  RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE Code_max Integer;  
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_User());

  /* IF 3 <> inSession::Integer AND 375661 <> inSession::Integer AND 4183126 <> inSession::Integer AND
     8001630 <> inSession::Integer AND 9560329 <> inSession::Integer
   THEN
     RAISE EXCEPTION '� ��� ��� ���� ���������� ��������.';
   END IF;*/

   IF COALESCE (inId, 0) = 0
   THEN
     RAISE EXCEPTION '������ �� ���������.';
   END IF;

   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_User_Helsi_Unit(), inId, inUnitId);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Helsi_UserName(), inId, inUserName);
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Helsi_UserPassword(), inId, inUserPassword);
   PERFORM lpInsertUpdate_ObjectBlob(zc_ObjectBlob_User_Helsi_Key(), inId, inKey);
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_Helsi_KeyPassword(), inId, inKeyPassword);

   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_User_LikiDnepr_Unit(), inId, inLikiDnepr_UnitId);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_LikiDnepr_UserEmail(), inId, inLikiDnepr_UserEmail);
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_User_LikiDnepr_PasswordEHels(), inId, inLikiDnepr_PasswordEHels);

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
-- SELECT * FROM gpInsertUpdate_Object_HelsiUser ('3')
