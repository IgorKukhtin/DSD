-- Function: gpInsertUpdate_Object_DriverSun()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DriverSun(Integer, Integer, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DriverSun(Integer, Integer, TVarChar, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_DriverSun(
 INOUT ioId             Integer   ,     -- ���� ������� <��������> 
    IN inCode           Integer   ,     -- ��� �������  
    IN inName           TVarChar  ,     -- �������� ������� 
    IN inPhone          TVarChar  ,     -- �������
    IN inChatIDSendVIP  Integer   ,     -- ��� ID ��� �������� ��������� � Telegram �� ������������ VIP
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
--    vbUserId:=lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_DriverSun());

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_DriverSun());
   
   -- �������� ���� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_DriverSun(), inName);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_DriverSun(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_DriverSun(), vbCode_calc, inName);
   
   -- ��������� �������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_DriverSun_Phone(), ioId, inPhone);
   
   -- ��������� ��� ID ��� �������� ��������� � Telegram �� ������������ VIP
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_DriverSun_ChatIDSendVIP(), ioId, inChatIDSendVIP);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 26.05.20                                                       *
 05.03.20                                                       *
*/

-- ����
-- 