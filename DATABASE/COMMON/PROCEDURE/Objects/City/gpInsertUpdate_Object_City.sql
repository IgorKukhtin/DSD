-- Function: gpInsertUpdate_Object_City()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_City (Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_City (Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_City(
 INOUT ioId             Integer   ,     -- ���� ������� <�����>
    IN inCode           Integer   ,     -- ��� �������
    IN inName           TVarChar  ,     -- �������� �������
    IN inCityKindId     Integer   ,     -- 
    IN inRegionId       Integer   ,     -- 
    IN inProvinceId     Integer   ,     -- 
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_City());


   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_City());

   -- �������� ������������ ��� �������� <������������> + <�������>
   IF EXISTS (SELECT Object_City.ValueData
              FROM Object AS Object_City
                   LEFT JOIN ObjectLink AS ObjectLink_City_Region
                                        ON ObjectLink_City_Region.ObjectId = Object_City.Id
                                       AND ObjectLink_City_Region.DescId = zc_ObjectLink_City_Region()
              WHERE Object_City.ValueData = inName
                AND Object_City.DescId = zc_Object_City()
                AND COALESCE (ObjectLink_City_Region.ChildObjectId, 0) = COALESCE (inRegionId, 0)
                AND Object_City.Id <> COALESCE (ioId, 0)
             )
   THEN
       RAISE EXCEPTION '�������� <%> ��� ������� <%> �� ��������� � ����������� <%>.'
                    , inName
                    , lfGet_Object_ValueData (inRegionId)
                    , (SELECT ItemName FROM ObjectDesc WHERE Id = zc_Object_City());
   END IF; 

   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_City(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_City(), vbCode_calc, inName);

  -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_City_CityKind(), ioId, inCityKindId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_City_Region(), ioId, inRegionId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_City_Province(), ioId, inProvinceId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_City (Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ������ �.�.
 31.05.14         * add CityKind, Region, Province 
 14.01.14                                                         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_City(ioId:=null, inCode:=null, inName:='������ 1', inSession:='2')
