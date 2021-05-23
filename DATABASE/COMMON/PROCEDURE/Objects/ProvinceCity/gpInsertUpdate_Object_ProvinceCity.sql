-- Function: gpInsertUpdate_Object_ProvinceCity()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProvinceCity (Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProvinceCity(
 INOUT ioId             Integer   ,     -- ���� ������� <>
    IN inCode           Integer   ,     -- ��� �������
    IN inName           TVarChar  ,     -- �������� �������
    IN inCityId         Integer   ,     -- 
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ProvinceCity());

  
   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ProvinceCity());

   -- �������� ���� ������������ ��� �������� <������������>
   --PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_ProvinceCity(), inName);

  -- �������� ������������ <������������> ��� !!!������!! ����������� ������
   IF TRIM (inName) <> '' AND COALESCE (inCityId, 0) <> 0 
   THEN
       IF EXISTS (SELECT Object.Id
                  FROM Object
                       JOIN ObjectLink AS ObjectLink_ProvinceCity_City
                                       ON ObjectLink_ProvinceCity_City.ObjectId = Object.Id
                                      AND ObjectLink_ProvinceCity_City.DescId = zc_ObjectLink_ProvinceCity_City()
                                      AND ObjectLink_ProvinceCity_City.ChildObjectId = inCityId
                                   
                  WHERE TRIM (Object.ValueData) = TRIM (inName)
                   AND Object.Id <> COALESCE (ioId, 0))
       THEN
           RAISE EXCEPTION '������. ����� <%> ��� ���������� � <%>.', TRIM (inName), lfGet_Object_ValueData (inCityId);
       END IF;
   END IF;

   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ProvinceCity(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ProvinceCity(), vbCode_calc, inName);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ProvinceCity_City(), ioId, inCityId);
 
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ProvinceCity (Integer, Integer, TVarChar, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ������ �.�.
 31.05.14         * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ProvinceCity(ioId:=null, inCode:=null, inName:='������ 1', inSession:='2')