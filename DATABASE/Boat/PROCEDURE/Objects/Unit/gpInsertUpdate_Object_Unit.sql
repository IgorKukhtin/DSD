-- Function: gpInsertUpdate_Object_Unit (Integer, TVarChar,  Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, TVarChar,  Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar,  Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, TVarChar, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Unit(
 INOUT ioId                       Integer   ,    -- ���� ������� <�������������> 
 INOUT ioCode                     Integer   ,    -- ��� ������� <�������������> 
    IN inName                     TVarChar  ,    -- �������� ������� <�������������>
    IN inAddress                  TVarChar  ,    -- �����
    IN inPhone                    TVarChar  ,    -- �������
    IN inPrinter                  TVarChar  ,    -- ������� (������ �����)
    IN inPrint                    TVarChar  ,    -- �������� ��� ������
    IN inIsPartnerBarCode         Boolean   ,    -- �/� ����������
    IN inDiscountTax              TFloat    ,    -- % ������ ������
    IN inJuridicalId              Integer   ,    -- ���� ������� <����������� ����> 
    IN inParentId                 Integer   ,    -- ���� ������� <�����> 
    IN inChildId                  Integer   ,    -- ���� ������� <�����>
    IN inBankAccountId            Integer   ,    -- ���� ������� <��������� ����>
    IN inAccountDirectionId       Integer   ,    -- ���� ������� <��������� �������������� ������ - �����������>
    IN inGoodsGroupId             Integer   ,    -- ���� ������� <������ ������>
    IN inPriceListId              Integer   ,    -- ���� ������� <����� ����>
    IN inSession                  TVarChar       -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Unit());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

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
        inGoodsGroupId:= (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = ioId AND OL.DescId = zc_ObjectLink_Unit_GoodsGroup());
   END IF;
   

   -- �������� ���� ������������ ��� �������� <������������ >
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Unit(), inName);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Unit(), ioCode, inName);

   -- ��������� �����
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Unit_Address(), ioId, inAddress);
   -- ��������� �������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Unit_Phone(), ioId, inPhone);
   -- ��������� ����� � <����������� ����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_Juridical(), ioId, inJuridicalId);
   -- ��������� ����� � <�����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_Parent(), ioId, inParentId);
   -- ��������� ����� � <�����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_Child(), ioId, inChildId);

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
 22.10.20          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Unit()
