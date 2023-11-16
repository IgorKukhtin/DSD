 -- Function: gpInsertUpdate_Object_Car(Integer, Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_Car (Integer, Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_Car (Integer, Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_Car (Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_Car (Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_Car (Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_Car (Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_Car (Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_Car (Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_Car (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_Car (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_Car (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Car(
   INOUT ioId                       Integer,     -- ��
      IN incode                     Integer,     -- ��� ����������
      IN inName                     TVarChar,    -- ������������ 
      IN inRegistrationCertificate  TVarChar,    -- ����������
      IN inVIN                      TVarChar,    -- VIN ���
      IN inEngineNum                TVarChar,    -- ����� ���������
      IN inComment                  TVarChar,    -- ����������
      IN inCarModelId               Integer,     -- ����� ����������
      IN inCarTypeId                Integer,     -- ������ ����������
      IN inBodyTypeId               Integer,     -- ��� ������
      IN inCarPropertyId            Integer,     -- ��� ����
      IN inObjectColorId            Integer,     -- ���� ����
      IN inUnitId                   Integer,     -- �������������
      IN inPersonalDriverId         Integer,     -- ��������� (��������)
      IN inFuelMasterId             Integer,     -- ��� ������� (��������)
      IN inFuelChildId              Integer,     -- ��� ������� (��������������)
      IN inJuridicalId              Integer,     -- ����������� ����(���������)
      --IN inAssetId                  Integer,     -- �������� ��������
      IN inKoeffHoursWork           TFloat ,     -- �����. ��� ������ ������� ����� �� �������� �����
      IN inPartnerMin               TFloat ,     -- ���-�� ����� �� ��
      IN inLength                   TFloat ,     -- 
      IN inWidth                    TFloat ,     -- 
      IN inHeight                   TFloat ,     -- 
      IN inWeight                   TFloat ,     --
      IN inYear                     TFloat ,     --
      IN inSession                  TVarChar     -- ������������
      )
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Car());
   
   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Car()); 
   
   -- �������� ���� ������������ ��� �������� <������������ ����������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Car(), inName);
   -- �������� ���� ������������ ��� �������� <��� ����������>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Car(), vbCode_calc);
   -- �������� ���� ������������ ��� �������� <����������> 
   -- PERFORM lpCheckUnique_ObjectString_ValueData(ioId, zc_ObjectString_Car_RegistrationCertificate(), inRegistrationCertificate);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Car(), vbCode_calc, inName
                                , inAccessKeyId:= COALESCE ((SELECT Object_Branch.AccessKeyId FROM ObjectLink LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink.ChildObjectId WHERE ObjectLink.ObjectId = inUnitId AND ObjectLink.DescId = zc_ObjectLink_Unit_Branch()), zc_Enum_Process_AccessKey_TrasportDnepr()));
   -- ��������� ��-�� <����������>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Car_RegistrationCertificate(), ioId, inRegistrationCertificate);
   -- ��������� ��-�� <����������>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Car_Comment(), ioId, inComment);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Car_VIN(), ioId, inVIN);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Car_EngineNum(), ioId, inEngineNum);
   
   -- ��������� ����� � <����� ����������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Car_CarModel(), ioId, inCarModelId);
   -- ��������� ����� � <������ ����>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Car_CarType(), ioId, inCarTypeId);
   -- ��������� ����� � <��� ������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Car_BodyType(), ioId, inBodyTypeId);
   -- ��������� ����� � <��� ����>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Car_CarProperty(), ioId, inCarPropertyId);
   -- ��������� ����� � <����>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Car_ObjectColor(), ioId, inObjectColorId);

   -- ��������� ����� � <��������������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Car_Unit(), ioId, inUnitId);
   -- ��������� ����� � <��������� (��������)>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Car_PersonalDriver(), ioId, inPersonalDriverId);
   -- ��������� ����� � <��� ������� (��������)>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Car_FuelMaster(), ioId, inFuelMasterId);
   -- ��������� ����� � <��� ������� (��������������)>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Car_FuelChild(), ioId, inFuelChildId);
   -- ��������� ����� � <��.�����>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Car_Juridical(), ioId, inJuridicalId);
   -- ��������� ����� � <���.���������>
   --PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Car_Asset(), ioId, inAssetId);
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Car_KoeffHoursWork(), ioId, inKoeffHoursWork);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Car_PartnerMin(), ioId, inPartnerMin);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Car_Length(), ioId, inLength);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Car_Height(), ioId, inHeight);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Car_Width(), ioId, inWidth);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Car_Weight(), ioId, inWeight);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Car_Year(), ioId, inYear);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.11.23         *
 17.07.23         *
 07.12.21         * del inAssetId
 01.11.21         *
 05.10.21         *
 27.04.21         * PartnerMin
 29.10.19         * inKoeffHoursWork
 28.11.16         * add Asset
 18.11.15         * add comment
 17.12.14         * add Juridical               
 04.09.14                                        * !!!RESTORE!!!
*/

-- ����
-- SELECT * FROM 
