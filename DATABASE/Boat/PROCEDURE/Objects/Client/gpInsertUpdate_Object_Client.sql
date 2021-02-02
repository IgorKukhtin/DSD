-- �������� �����

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Client (Integer, Integer, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Client (Integer, Integer, TVarChar, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Client (Integer, Integer
                                                    , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                    , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                    , TFloat, TFloat, TFloat, Integer, Integer, Integer, Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Client(
 INOUT ioId              Integer,       -- ���� ������� <�����>
 INOUT ioCode            Integer,       -- �������� <��� ������>
    IN inName            TVarChar,      -- ������� �������� ������
    IN inComment         TVarChar,      --
    IN inFax             TVarChar,
    IN inPhone           TVarChar,
    IN inMobile          TVarChar,
    IN inIBAN            TVarChar,
    IN inStreet          TVarChar,
    IN inMember          TVarChar,
    IN inWWW             TVarChar,
    IN inEmail           TVarChar,
    IN inCodeDB          TVarChar,
    IN inDiscountTax     TFloat  ,      -- % ������
    IN inDayCalendar     TFloat ,
    IN inDayBank         TFloat ,
    IN inBankId          Integer , 
    IN inPLZId           Integer ,
    IN inInfoMoneyId     Integer ,
    IN inTaxKindId       Integer ,
    IN inSession         TVarChar       -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Client());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;
   
    -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   ioCode:= lfGet_ObjectCode (ioCode, zc_Object_Client());

   -- �������� ���� ������������ ��� �������� <������������ >
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Client(), inName, vbUserId);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Client(), ioCode, inName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Client_Comment(), ioId, inComment);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Client_Fax(), ioId, inFax);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Client_Phone(), ioId, inPhone);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Client_Mobile(), ioId, inMobile);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Client_IBAN(), ioId, inIBAN);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Client_Street(), ioId, inStreet);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Client_Member(), ioId, inMember);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Client_WWW(), ioId, inWWW);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Client_Email(), ioId, inEmail);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Client_CodeDB(), ioId, inCodeDB);


   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Client_DiscountTax(), ioId, inDiscountTax);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Client_DayCalendar(), ioId, inDayCalendar);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Client_Bank(), ioId, inDayBank);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Client_PLZ(), ioId, inPLZId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Client_Bank(), ioId, inBankId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Client_InfoMoney(), ioId, inInfoMoneyId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Client_TaxKind(), ioId, inTaxKindId);


   IF vbIsInsert = TRUE THEN
      -- ��������� �������� <���� ��������>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- ��������� �������� <������������ (��������)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   END IF;
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.02.21         *
 04.01.21         *
 08.10.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Client()
