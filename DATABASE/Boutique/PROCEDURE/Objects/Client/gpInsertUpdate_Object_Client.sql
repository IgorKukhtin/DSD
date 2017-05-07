-- ����������

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Client (Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Client(
 INOUT ioId                       Integer   ,    -- ���� ������� <����������> 
    IN inCode                     Integer   ,    -- ��� ������� <����������>     
    IN inName                     TVarChar  ,    -- �������� ������� <����������>
    IN inDiscountCard             TVarChar  ,    -- ����� �����
    IN inDiscountTax              TFloat    ,    -- ������� ������
    IN inDiscountTaxTwo           TFloat    ,    -- ������� ������ �������������
    IN inAddress                  TVarChar  ,    -- �����
    IN inHappyDate                TDateTime ,    -- ���� ��������
    IN inPhoneMobile              TVarChar  ,    -- ��������� �������
    IN inPhone                    TVarChar  ,    -- �������
    IN inMail                     TVarChar  ,    -- ����������� �����
    IN inComment                  TVarChar  ,    -- ����������
    IN inCityId                   Integer   ,    -- ���������� �����
    IN inDiscountKindId           Integer   ,    -- ��� ������������� ������
    IN inSession                  TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Client());
   vbUserId:= lpGetUserBySession (inSession);

   -- ����� ��� �������� �� Sybase �.�. ��� ��� = 0 
   IF inCode = 0 THEN  inCode := NEXTVAL ('Object_Client_seq'); END IF; 

   -- �������� ���� ������������ ��� �������� <������������ >
   --PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Client(), inName);


   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Client(), inCode, inName);
 
   -- ��������� ����� �����
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Client_DiscountCard(), ioId, inDiscountCard);
   -- ��������� ������� ������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_DiscountTax(), ioId, inDiscountTax);
   -- ��������� ������� ������ �������������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Client_DiscountTaxTwo(), ioId, inDiscountTaxTwo);
   -- ��������� �����
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Client_Address(), ioId, inAddress);
   -- ��������� ���� ��������
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Client_HappyDate(), ioId, inHappyDate);
   -- ��������� ��������� �������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Client_PhoneMobile(), ioId, inPhoneMobile);
   -- ��������� �������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Client_Phone(), ioId, inPhone);
   -- ��������� ����������� �����
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Client_Mail(), ioId, inMail);
   -- ��������� ����������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Client_Comment(), ioId, inComment);

   -- ��������� ����� � <���������� �����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Client_City(), ioId, inCityId);
   -- ��������� ����� � <��� ������������� ������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Client_DiscountKind(), ioId, inDiscountKindId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
02.03.17                                                           *
01.03.17                                                           *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Client()
