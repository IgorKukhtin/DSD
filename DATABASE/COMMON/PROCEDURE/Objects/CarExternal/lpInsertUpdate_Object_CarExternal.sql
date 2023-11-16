-- Function: lpInsertUpdate_Object_CarExternal (Integer, Integer, TVarChar, TVarChar)

--DROP FUNCTION IF EXISTS lpInsertUpdate_Object_CarExternal (Integer, Integer, TVarChar, TVarChar,TVarChar,Integer,Integer,Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_CarExternal (Integer, Integer, TVarChar, TVarChar, TVarChar,TVarChar,Integer,Integer, TFloat, TFloat, TFloat, TFloat, TFloat,Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_CarExternal (Integer, Integer, TVarChar, TVarChar, TVarChar,TVarChar,Integer,Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat,Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_CarExternal (Integer, Integer, TVarChar, TVarChar, TVarChar,TVarChar,Integer,Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat,Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_CarExternal(
   INOUT ioId                       Integer, 
      IN incode                     Integer, 
      IN inName                     TVarChar, 
      IN inRegistrationCertificate  TVarChar,
      IN inVIN                      TVarChar,    -- VIN ���
      IN inComment                  TVarChar  ,    -- ����������
      IN inCarModelId               Integer, 
      IN inCarTypeId                Integer,     -- ������ ����������
      IN inCarPropertyId            Integer,     -- ��� ����
      IN inObjectColorId            Integer,     -- ���� ����
      IN inJuridicalId              Integer,
      IN inLength                   TFloat ,     -- 
      IN inWidth                    TFloat ,     -- 
      IN inHeight                   TFloat ,     -- 
      IN inWeight                   TFloat ,     --
      IN inYear                     TFloat ,     --      
      IN inUserId                   Integer
)
RETURNS Integer
AS
$BODY$
   DECLARE vbCode_calc Integer;
BEGIN
   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ��������� + 1
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_CarExternal());
   
   -- �������� ������������ <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_CarExternal(), TRIM (inName));
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_CarExternal(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_CarExternal(), vbCode_calc, TRIM (inName), NULL);


   -- ��������� ��-�� <����������>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_CarExternal_RegistrationCertificate(), ioId, inRegistrationCertificate);
   -- ��������� ��-�� <����������>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_CarExternal_Comment(), ioId, inComment);
   -- ��������� ����� � <������ ����>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_CarExternal_CarModel(), ioId, inCarModelId);
   -- ��������� ����� � <������ ����>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_CarExternal_CarType(), ioId, inCarTypeId);
   -- ��������� ����� � <��� ����>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_CarExternal_CarProperty(), ioId, inCarPropertyId);
   -- ��������� ����� � <����>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_CarExternal_ObjectColor(), ioId, inObjectColorId);
   -- ��������� ����� � <��.�����>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_CarExternal_Juridical(), ioId, inJuridicalId);

   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_CarExternal_VIN(), ioId, inVIN);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CarExternal_Length(), ioId, inLength);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CarExternal_Height(), ioId, inHeight);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CarExternal_Width(), ioId, inWidth);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CarExternal_Weight(), ioId, inWeight);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CarExternal_Year(), ioId, inYear);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, inUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.11.23         *
 09.11.21         *
 17.03.16         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Object_CarExternal()
