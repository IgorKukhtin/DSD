-- Function: gpInsertUpdate_Object_Car(Integer,Integer,TVarChar,TVarChar,TDateTime,TDateTime,Integer,Integer,Integer,Integer,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Car (Integer,Integer,TVarChar,TVarChar,TDateTime,TDateTime,Integer,Integer,Integer,Integer,Integer,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Car (Integer,Integer,TVarChar,TVarChar,Integer,Integer,Integer,Integer,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Car(
 INOUT ioId                       Integer   ,    -- ���� ������� <����������> 
    IN inCode                     Integer   ,    -- ��� ������� <����������>
    IN inName                     TVarChar  ,    -- �������� ������� <����������>
    IN inRegistrationCertificate  TVarChar  ,    -- ���������� ������� <����������>
    IN inCarModelId               Integer   ,    -- ������ ����          
    IN inUnitId                   Integer   ,    -- �������������
    IN inPersonalDriverId         Integer   ,    -- ��������� (��������)
    IN inFuelMasterId             Integer   ,    -- ��� ������� (��������)
    IN inFuelChildId              Integer   ,    -- ��� ������� (��������������)
    IN inSession                  TVarChar       -- ������ ������������
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

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
-- ALTER FUNCTION gpInsertUpdate_Object_Car (Integer,Integer,TVarChar,TVarChar,Integer,Integer,Integer,Integer,Integer,TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.12.13                                        * add inAccessKeyId
 09.10.13                                        * �������� ����� ���
 26.09.13          * del StartDateRate, EndDateRate, RateFuelKind 
 24.09.13          * add StartDateRate, EndDateRate, Unit, PersonalDriver, FuelMaster, FuelChild, RateFuelKind
 10.06.13          *
 05.06.13          
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Car()
