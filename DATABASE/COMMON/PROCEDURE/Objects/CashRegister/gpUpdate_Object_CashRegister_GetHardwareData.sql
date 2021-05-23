-- Function: gpUpdate_Object_CashRegister_GetHardwareData()

DROP FUNCTION IF EXISTS gpUpdate_Object_CashRegister_GetHardwareData (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_CashRegister_GetHardwareData(
    IN inId                     Integer   ,     -- ���� ������� <�����>
    IN inGetHardwareData        Boolean ,     -- 
    IN inSession                TVarChar        -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_CashRegister());
   vbUserId:= lpGetUserBySession (inSession);


   IF COALESCE(inId, 0) = 0 OR
      COALESCE((SELECT ObjectBoolean.ValueData FROM ObjectBoolean 
               WHERE ObjectBoolean.ObjectId = inId 
                 AND ObjectBoolean.DescId = zc_ObjectBoolean_CashRegister_GetHardwareData()), False) = inGetHardwareData
   THEN
     RETURN;
   END IF;


   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashRegister_GetHardwareData(), inId, inGetHardwareData);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_CashRegister_GetHardwareData (Integer, Boolean, TVarChar) OWNER TO postgres;


-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ������ �.�.   ������ �.�.
 08.04.20                                                                      *  
 04.03.19                                                                      *  
 22.05.15                        *  
*/

-- ����
-- SELECT * FROM gpUpdate_Object_CashRegister_GetHardwareData(ioId:=null, inGetHardwareData := False, inSession:='2')