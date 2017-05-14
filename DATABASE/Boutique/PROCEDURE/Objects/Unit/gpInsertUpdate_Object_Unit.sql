-- Function: gpInsertUpdate_Object_Unit (Integer, TVarChar,  Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, TVarChar,  Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar,  Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, Integer, Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Unit(
 INOUT ioId                       Integer   ,    -- ���� ������� <�������������> 
 INOUT ioCode                     Integer   ,    -- ��� ������� <�������������> 
    IN inName                     TVarChar  ,    -- �������� ������� <�������������>
    IN inAddress                  TVarChar  ,    -- �����
    IN inPhone                    TVarChar  ,    -- �������
    IN inDiscountTax              TFloat    ,    -- % ������ ������
    IN inJuridicalId              Integer   ,    -- ���� ������� <����������� ����> 
    IN inParentlId                Integer   ,    -- ���� ������� <�����> 
    IN inChildId                  Integer   ,    -- ���� ������� <�����>
    IN inBankAccountId            Integer   ,    -- ���� ������� <��������� ����>
    IN inSession                  TVarChar       -- ������ ������������
)
RETURNS record
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Unit());
   vbUserId:= lpGetUserBySession (inSession);

   -- ����� ������- ��� ����� ����� � ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 AND COALESCE(ioCode,0) <> 0 THEN  ioCode := NEXTVAL ('Object_Unit_seq'); 
   END IF; 

   -- ����� ��� �������� �� Sybase �.�. ��� ��� = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE(ioCode,0) = 0  THEN  ioCode := NEXTVAL ('Object_Unit_seq'); 
   ELSEIF ioCode = 0
         THEN ioCode := COALESCE((SELECT ObjectCode FROM Object WHERE Id = ioId),0);
   END IF; 
   
   -- �������� ���� ������������ ��� �������� <������������ >
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Unit(), inName);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Unit(), ioCode, inName);

   -- ��������� �����
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Unit_Address(), ioId, inAddress);
   -- ��������� �������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Unit_Phone(), ioId, inPhone);

   -- ��������� % ������ ������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Unit_DiscountTax(), ioId, inDiscountTax);

   -- ��������� ����� � <����������� ����>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Juridical(), ioId, inJuridicalId);
   -- ��������� ����� � <�����>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Parent(), ioId, inParentlId);
   -- ��������� ����� � <�����>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Child(), ioId, inChildId);
   -- ��������� ����� � <��������� ����>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_BankAccount(), ioId, inBankAccountId);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
13.05.17                                                           *
10.05.17                                                           *
08.05.17                                                           *
28.02.17                                                           *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Unit()
