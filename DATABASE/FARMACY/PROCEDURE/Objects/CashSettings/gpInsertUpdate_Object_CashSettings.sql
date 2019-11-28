-- Function: gpInsertUpdate_Object_CashSettings()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CashSettings(TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CashSettings(
    IN inShareFromPriceName      TVarChar  ,     -- �������� ���� � ��������� ������� ������� ����� ������ � ����� �����
    IN inShareFromPriceCode      TVarChar  ,     -- �������� ����� ������� ������� ����� ������ � ����� �����
    IN inSession                 TVarChar        -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbID Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
--    vbUserId:=lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Driver());
   vbUserId := inSession::Integer;

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
     RAISE EXCEPTION '��������� ������ ���������� ��������������';
   END IF;

   -- �������� ����� ���
   vbID := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_CashSettings());

   -- ��������� <������>
   vbID := lpInsertUpdate_Object (vbID, zc_Object_CashSettings(), 1, '����� ��������� ����');
   
   -- ��������� �������� ���� � ��������� ������� ������� ����� ������ � ����� �����
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashSettings_ShareFromPriceName(), vbID, inShareFromPriceName);
   
   -- ��������� �������� ����� ������� ������� ����� ������ � ����� �����
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_CashSettings_ShareFromPriceCode(), vbID, inShareFromPriceCode);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (vbID, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 24.11.19                                                       *
*/

-- ����
-- 