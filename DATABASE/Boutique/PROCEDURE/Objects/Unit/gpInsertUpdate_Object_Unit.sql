-- Function: gpInsertUpdate_Object_Unit (Integer, TVarChar,  Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, TVarChar,  Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar,  Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Unit(
 INOUT ioId                       Integer   ,    -- ���� ������� <�������������> 
 INOUT ioCode                     Integer   ,    -- ��� ������� <�������������> 
    IN inName                     TVarChar  ,    -- �������� ������� <�������������>
    IN inAddress                  TVarChar  ,    -- �����
    IN inPhone                    TVarChar  ,    -- �������
    IN inPrinter                  TVarChar  ,    -- ������� (������ �����)
    IN inPrint                    TVarChar  ,    -- �������� ��� ������
    IN inDiscountTax              TFloat    ,    -- % ������ ������
    IN inJuridicalId              Integer   ,    -- ���� ������� <����������� ����> 
    IN inParentId                 Integer   ,    -- ���� ������� <�����> 
    IN inChildId                  Integer   ,    -- ���� ������� <�����>
    IN inBankAccountId            Integer   ,    -- ���� ������� <��������� ����>
    IN inAccountDirectionId       Integer   ,    -- ���� ������� <��������� �������������� ������ - �����������>
    IN inSession                  TVarChar       -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Unit());
   vbUserId:= lpGetUserBySession (inSession);

   -- ����� ������- ��� ����� ����� � ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) <> 0 THEN ioCode := NEXTVAL ('Object_Unit_seq'); 
   END IF; 

   -- ����� ��� �������� �� Sybase �.�. ��� ��� = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) = 0  THEN ioCode := NEXTVAL ('Object_Unit_seq'); 
   ELSEIF ioCode = 0
         THEN ioCode := COALESCE ((SELECT ObjectCode FROM Object WHERE Id = ioId), 0);
   END IF; 
   
   -- ��� �������� �� Sybase
   IF vbUserId = zc_User_Sybase() AND ioId > 0
   THEN
        inPrinter:= (SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.ObjectId = ioId AND OS.DescId = zc_ObjectString_Unit_Printer());
   END IF;
   
   -- �������� ���� ������������ ��� �������� <������������ >
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Unit(), inName);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Unit(), ioCode, inName);

   -- ��������� �����
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Unit_Address(), ioId, inAddress);
   -- ��������� �������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Unit_Phone(), ioId, inPhone);
   -- ��������� �������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Unit_Printer(), ioId, inPrinter);
   -- ��������� 
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Unit_Print(), ioId, inPrint);

   -- ��������� % ������ ������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Unit_DiscountTax(), ioId, inDiscountTax);

   -- ��������� ����� � <����������� ����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_Juridical(), ioId, inJuridicalId);
   -- ��������� ����� � <�����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_Parent(), ioId, inParentId);
   -- ��������� ����� � <�����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_Child(), ioId, inChildId);
   -- ��������� ����� � <��������� ����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_BankAccount(), ioId, inBankAccountId);
   -- ��������� ����� � <��������� �������������� ������ - �����������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_AccountDirection(), ioId, inAccountDirectionId);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
27.02.18          * Printer
07.06.17          * add AccountDirection
23.05.17                                                           *
13.05.17                                                           *
10.05.17                                                           *
08.05.17                                                           *
28.02.17                                                           *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Unit()
