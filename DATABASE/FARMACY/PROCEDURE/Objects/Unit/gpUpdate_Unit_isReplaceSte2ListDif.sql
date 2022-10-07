-- Function: gpUpdate_Object_Goods_IsUpload()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isReplaceSte2ListDif(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_isReplaceSte2ListDif(
    IN inId                       Integer   ,    -- ���� ������� <�������������>
    IN inisReplaceSte2ListDif     Boolean   ,    -- ������� ����� ���� 2 ��� ���������� � ����� �������
   OUT outisReplaceSte2ListDif    Boolean   ,
    IN inSession                  TVarChar       -- ������� ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   -- �������� - �����������/��������� ��������� �������� ������
   IF NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
      RAISE EXCEPTION '������. ��������� �������� <������� ����� ���� 2 ��� ���������� � ����� �������> ��������� ������ ��������������.';
   END IF;

   -- ���������� �������
   outisReplaceSte2ListDif:= NOT inisReplaceSte2ListDif;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_ReplaceSte2ListDif(), inId, outisReplaceSte2ListDif);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.10.22                                                       *
*/