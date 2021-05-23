-- Function: gpInsertUpdate_Object_City()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CashRegister (Integer, Integer, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CashRegister (Integer, Integer, TVarChar, Integer, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CashRegister (Integer, Integer, TVarChar, Integer, TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CashRegister(
 INOUT ioId                     Integer   ,     -- ���� ������� <�����>
    IN inCode                   Integer   ,     -- ��� �������
    IN inName                   TVarChar  ,     -- �������� �������
    IN inCashRegisterKindId     Integer   ,     -- 
    IN inTimePUSHFinal1         TDateTime ,     -- 
    IN inTimePUSHFinal2         TDateTime ,     -- 
    IN inGetHardwareData        Boolean ,     -- 
    IN inSession                TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_CashRegister());
   vbUserId:= lpGetUserBySession (inSession);

   
   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_CashRegister());

   -- �������� ������������ ��� �������� <������������> 
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_CashRegister(), inName);
   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_CashRegister(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_CashRegister(), vbCode_calc, inName);

  -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_CashRegister_CashRegisterKind(), ioId, inCashRegisterKindId);
   
   IF inTimePUSHFinal1 ::Time <> '00:00'
   THEN
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_CashRegister_TimePUSHFinal1(), ioId, inTimePUSHFinal1);
   ELSE
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_CashRegister_TimePUSHFinal1(), ioId, NULL);
   END IF;
   
   IF inTimePUSHFinal2 ::Time <> '00:00'
   THEN
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_CashRegister_TimePUSHFinal2(), ioId, inTimePUSHFinal2);
   ELSE
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_CashRegister_TimePUSHFinal2(), ioId, NULL);
   END IF;

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_CashRegister_GetHardwareData(), ioId, inGetHardwareData);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_CashRegister (Integer, Integer, TVarChar, Integer, TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;


-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ������ �.�.   ������ �.�.
 08.04.20                                                                      *  
 04.03.19                                                                      *  
 22.05.15                        *  
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_CashRegister(ioId:=null, inCode:=null, inName:='������ 1', inSession:='2')