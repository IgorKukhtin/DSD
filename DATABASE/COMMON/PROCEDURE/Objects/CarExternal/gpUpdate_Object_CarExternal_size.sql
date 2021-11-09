 -- Function: gpUpdate_Object_CarExternal_size()

DROP FUNCTION IF EXISTS  gpUpdate_Object_CarExternal_size (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_CarExternal_size(
      IN inId               Integer,     -- ��
      IN inLength           TFloat ,     -- 
      IN inWidth            TFloat ,     -- 
      IN inHeight           TFloat ,     --
      IN inWeight           TFloat ,     --
      IN inYear             TFloat ,     -- ���  �������
      IN inVIN              TVarChar,    -- VIN ���
      IN inSession          TVarChar     -- ������������
      )
  RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_CarExternal());
   vbUserId:= lpGetUserBySession (inSession);
   
   IF inId = 0
   THEN
       RAISE EXCEPTION '������. ������� �� ��������.';
   END IF;
     
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CarExternal_Length(), inId, inLength);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CarExternal_Height(), inId, inHeight);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CarExternal_Width(), inId, inWidth);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CarExternal_Weight(), inId, inWeight);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CarExternal_Year(), inId, inYear);

   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_CarExternal_VIN(), inId, inVIN);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.11.21         *
*/

-- ����
--