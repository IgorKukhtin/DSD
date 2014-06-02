-- Function: gpInsertUpdate_Object_Street (Integer,Integer,TVarChar,TVarChar,Integer,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Street (Integer,Integer,TVarChar,TVarChar,Integer,Integer,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Street(
 INOUT ioId                       Integer   ,    -- ���� ������� < �����/��������> 
    IN inCode                     Integer   ,    -- ��� ������� <>
    IN inName                     TVarChar  ,    -- �������� ������� <>
    IN inPostalCode               TVarChar  ,    -- 
    IN inStreetKindId             Integer   ,    --          
    IN inCityId                   Integer   ,    --
    IN inProvinceCityId           Integer   ,    -- 
    IN inSession                  TVarChar       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Street());
   
   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Street()); 
   
   -- �������� ���� ������������ ��� �������� <������������ >
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Street(), inName);
   -- �������� ���� ������������ ��� �������� <��� >
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Street(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Street(), vbCode_calc, inName);
   -- ��������� ��-�� <����������>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Street_PostalCode(), ioId, inPostalCode);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Street_StreetKind(), ioId, inStreetKindId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Street_City(), ioId, inCityId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Street_ProvinceCity(), ioId, inProvinceCityId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 31.05.14         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Street()
