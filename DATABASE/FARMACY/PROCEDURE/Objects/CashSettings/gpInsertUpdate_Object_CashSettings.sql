-- Function: gpInsertUpdate_Object_CashSettings()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CashSettings(TVarChar, TVarChar, Boolean, TDateTime, TFloat, TFloat, Integer, Integer, Boolean, Boolean, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CashSettings(
    IN inShareFromPriceName      TVarChar  ,     -- �������� ���� � ��������� ������� ������� ����� ������ � ����� �����
    IN inShareFromPriceCode      TVarChar  ,     -- �������� ����� ������� ������� ����� ������ � ����� �����
    IN inisGetHardwareData       Boolean   ,     -- �������� ������ ���������� �����
    IN inDateBanSUN              TDateTime ,     -- ������ ������ �� ���
    IN inSummaFormSendVIP        TFloat    ,     -- ����� �� ������� ������� ����� ��� ������������ ����������� VIP
    IN inSummaUrgentlySendVIP    TFloat    ,     -- ����� ����������� �� ������� �������� ������� ������
    IN inDaySaleForSUN           Integer   ,     -- ���������� ���� ��� �������� <�������/������� �� ���� ���>
    IN inDayNonCommoditySUN      Integer   ,     -- ���������� ���� ��� �������� ����������� "���������� ���"
    IN inisBlockVIP              Boolean   ,     -- ����������� ������������ ����������� VIP
    IN inisPairedOnlyPromo       Boolean   ,     -- ��� ��������� ������ �������������� ������ ���������
    IN inAttemptsSub             TFloat    ,     -- ���������� ������� �� �������� ����� ����� ��� ����������� ������
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

   -- ��������� �������� ������ ���������� �����
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_GetHardwareData(), vbID, inisGetHardwareData);
   -- ��������� ������ ������ �� ���
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_CashSettings_DateBanSUN(), vbID, inDateBanSUN);

   -- ��������� ����� �� ������� ������� ����� ��� ������������ ����������� VIP
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_SummaFormSendVIP(), vbID, inSummaFormSendVIP);
      -- ��������� ����� ����������� �� ������� �������� ������� ������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_SummaUrgentlySendVIP(), vbID, inSummaUrgentlySendVIP);
      -- ��������� ���������� ���� ��� �������� <�������/������� �� ���� ���>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_DaySaleForSUN(), vbID, inDaySaleForSUN);
      -- ��������� ���������� ���� ��� �������� ����������� "���������� ���"
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_DayNonCommoditySUN(), vbID, inDayNonCommoditySUN);
      -- ��������� ���������� ������� �� �������� ����� ����� ��� ����������� ������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CashSettings_AttemptsSub(), vbID, inAttemptsSub);

   -- ��������� ����������� ������������ ����������� VIP
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_BlockVIP(), vbID, inisBlockVIP);
   -- ��������� ��� ��������� ������ �������������� ������ ���������
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashSettings_PairedOnlyPromo(), vbID, inisPairedOnlyPromo);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (vbID, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 24.11.19                                                       *
*/