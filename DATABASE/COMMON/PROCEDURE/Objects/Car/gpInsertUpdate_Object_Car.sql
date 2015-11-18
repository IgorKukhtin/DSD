 -- Function: gpInsertUpdate_Object_Car(Integer, Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_Car (Integer, Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_Car (Integer, Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_Car (Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Car(
   INOUT ioId                       Integer, 
      IN incode                     Integer, 
      IN inName                     TVarChar, 
      IN inRegistrationCertificate  TVarChar, 
      IN inComment                  TVarChar  ,    -- ����������
      IN inCarModelId               Integer, 
      IN inUnitId                   Integer, 
      IN inPersonalDriverId         Integer, 
      IN inFuelMasterId             Integer,
      IN inFuelChildId              Integer,
      IN inJuridicalId              Integer,        
      IN inSession                  TVarChar
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

   -- ��������� ����� � <������ ����>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Car_CarModel(), ioId, inCarModelId);
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

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_Car (Integer, Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.11.15         * add comment
 17.12.14         * add Juridical               
 04.09.14                                        * !!!RESTORE!!!
*/

-- ����
-- SELECT * FROM 
