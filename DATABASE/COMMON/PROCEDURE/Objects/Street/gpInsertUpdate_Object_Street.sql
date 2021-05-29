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
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Street());


   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Street()); 
   
   -- �������� ���� ������������ ��� �������� <������������ > + <City>
 --  PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Street(), inName);
   -- �������� ���� ������������ ��� �������� <��� >
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Street(), vbCode_calc);

   -- ��������
   IF COALESCE (inCityId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�������� <���������� �����> �� ���������.';
   END IF;
   -- ��������
   IF COALESCE (inStreetKindId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�������� <���(�����,��������)> �� ���������.';
   END IF;

   -- ��������
   IF EXISTS (SELECT 1
              FROM Object AS Object_Street
                   JOIN ObjectLink AS ObjectLink_Street_StreetKind ON ObjectLink_Street_StreetKind.ObjectId     = Object_Street.Id
                                                                  AND ObjectLink_Street_StreetKind.DescId        = zc_ObjectLink_Street_StreetKind()
                                                                  AND ObjectLink_Street_StreetKind.ChildObjectId = inStreetKindId
                   INNER JOIN ObjectLink AS ObjectLink_Street_City ON ObjectLink_Street_City.ObjectId       = Object_Street.Id
                                                                  AND ObjectLink_Street_City.DescId         = zc_ObjectLink_Street_City()
                                                                  AND ObjectLink_Street_City.ChildObjectId  = inCityId
                   LEFT JOIN ObjectLink AS ObjectLink_Street_ProvinceCity ON ObjectLink_Street_ProvinceCity.ObjectId = Object_Street.Id
                                                                         AND ObjectLink_Street_ProvinceCity.DescId = zc_ObjectLink_Street_ProvinceCity()
                 /*LEFT JOIN ObjectString AS ObjectString_PostalCode ON ObjectString_PostalCode.ObjectId  = Object_Street.Id
                                                                    AND ObjectString_PostalCode.DescId    = zc_ObjectString_Street_PostalCode()
                                                                    AND ObjectString_PostalCode.ValueData = inPostalCode*/
                                                                         
              WHERE Object_Street.Id <> COALESCE (ioId, 0)
                AND Object_Street.DescId = zc_Object_Street()
                AND Object_Street.ValueData = inName
                AND COALESCE (ObjectLink_Street_ProvinceCity.ChildObjectId, 0) = COALESCE (inProvinceCityId, 0)
              --AND COALESCE (ObjectString_PostalCode.ValueData, '') = COALESCE (inPostalCode, '')
             )
   THEN
       RAISE EXCEPTION '������.� ����������� <�����/��������> �������� <%><%> �� ��������� ��� ������ <%>.'
                     , lfGet_Object_ValueData_sh (inStreetKindId)
                     , inName
                     , lfGet_Object_ValueData_sh (inCityId)
                      ;
   END IF;


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
