-- Function: lpUpdate_Object_Partner_Address()

DROP FUNCTION IF EXISTS lpUpdate_Object_Partner_Address (Integer, Integer, TVarChar, Integer, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar,  TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Object_Partner_Address(
    IN inId                  Integer   ,    -- ���� ������� <����������> 
    IN inJuridicalId         Integer   ,    -- ����������� ����
    IN inShortName           TVarChar  ,    -- �������� �����������
    IN inCode                Integer   ,    -- ��� ������� <����������> 
   OUT outPartnerName        TVarChar  ,    -- 
   OUT outAddress            TVarChar  ,    -- 
    IN inRegionName          TVarChar  ,    -- ������������ �������
    IN inProvinceName        TVarChar  ,    -- ������������ �����
    IN inCityName            TVarChar  ,    -- ������������ ���������� �����
    IN inCityKindId          Integer   ,    -- ��� ����������� ������
    IN inProvinceCityName    TVarChar  ,    -- ������������ ������ ����������� ������
    IN inPostalCode          TVarChar  ,    -- ������
    IN inStreetName          TVarChar  ,    -- ������������ �����
    IN inStreetKindId        Integer   ,    -- ��� �����
    IN inHouseNumber         TVarChar  ,    -- ����� ����
    IN inCaseNumber          TVarChar  ,    -- ����� �������
    IN inRoomNumber          TVarChar  ,    -- ����� ��������
    IN inSession             TVarChar  ,    -- ������ ������������
    IN inUserId              Integer        -- ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbRegionId Integer;
   DECLARE vbProvinceId Integer;
   DECLARE vbCityId Integer;
   DECLARE vbProvinceCityId Integer;
   DECLARE vbStreetId Integer;
BEGIN

    -- !!!�������� ��������!!!
    inShortName         := TRIM (inShortName);
    inRegionName        := TRIM (inRegionName);
    inProvinceName      := TRIM (inProvinceName);
    inCityName          := TRIM (inCityName);
    inProvinceCityName  := TRIM (inProvinceCityName);
    inPostalCode        := TRIM (inPostalCode);
    inStreetName        := TRIM (inStreetName);
    inHouseNumber       := TRIM (inHouseNumber);
    inCaseNumber        := TRIM (inCaseNumber);
    inRoomNumber        := TRIM (inRoomNumber);

    -- !!!����� �����!!!
    outAddress := TRIM (COALESCE ((SELECT ValueData FROM ObjectString WHERE ObjectId = inCityKindId AND DescId = zc_ObjectString_CityKind_ShortName()), '')
              || ' ' || COALESCE (inCityName, '')
              || ' ' || COALESCE ((SELECT ValueData FROM ObjectString WHERE ObjectId = inStreetKindId AND DescId = zc_ObjectString_StreetKind_ShortName()), '')
              || ' ' || COALESCE (inStreetName, '')
                     || CASE WHEN COALESCE (inHouseNumber, '') <> ''
                                  THEN ' ' || COALESCE (inHouseNumber, '')
                             ELSE ''
                        END
                     || CASE WHEN COALESCE (inCaseNumber, '') <> ''
                                  THEN ' ' || COALESCE (inCaseNumber, '')
                             ELSE ''
                        END
                       );


    -- !!!�������� ������� ��: <����������� ����> + <�������� �����������> + <����� ����� ��������>!!!
    outPartnerName:= COALESCE ((SELECT ValueData FROM Object WHERE Id = inJuridicalId), '')
                   || CASE WHEN inShortName <> ''
                                THEN ' ' || inShortName
                           ELSE ''
                      END
                   || CASE WHEN TRIM (outAddress) <> ''
                                THEN ' ' || TRIM (outAddress)
                           ELSE ''
                      END;

    -- �������� ������������ <��������>
    PERFORM lpCheckUnique_Object_ValueData (inId, zc_Object_Partner(), outPartnerName);


    -- ��������� <������>
    PERFORM lpInsertUpdate_Object (inId, zc_Object_Partner(), inCode, outPartnerName);

    -- ��������� �������� <����� ����� ��������>
    PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_Address(), inId, outAddress);
    -- ��������� �������� <�������� �����������>
    PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_ShortName(), inId, inShortName);

    -- ��������� �������� <���>
    PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_HouseNumber(), inId, inHouseNumber);
    -- ��������� �������� <������>
    PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_CaseNumber(), inId, inCaseNumber);
    -- ��������� �������� <��������>
    PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_RoomNumber(), inId, inRoomNumber);

    -- � ���� ������ "���������" ������
    IF inCityName <> '' OR inStreetName <> '' OR inHouseNumber <> '' OR inCaseNumber <> ''
       OR COALESCE (inShortName, '') = ''
    THEN

    -- �������
    IF inRegionName <> ''
    THEN
         -- �����
         vbRegionId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Region() AND Object.ValueData = inRegionName);
         -- ��������
         IF COALESCE (vbRegionId, 0) = 0
         THEN
             vbRegionId:= gpInsertUpdate_Object_Region (vbRegionId, 0, inRegionName, inSession);
         END IF;
    END IF;
     
    -- �����
    IF inProvinceName <> ''
    THEN
         -- ��������
         IF COALESCE (vbRegionId, 0) = 0 THEN RAISE EXCEPTION '������.�� ���������� �������� <�������>.'; END IF;
         -- �����
         vbProvinceId:= (SELECT Object.Id 
                         FROM Object 
                             JOIN ObjectLink AS ObjectLink_Province_Region ON ObjectLink_Province_Region.ObjectId = Object.Id
                                                                          AND ObjectLink_Province_Region.DescId = zc_ObjectLink_Province_Region()
                                                                          AND ObjectLink_Province_Region.ChildObjectId = vbRegionId
                         WHERE Object.DescId = zc_Object_Province() AND Object.ValueData = inProvinceName);
         -- ��������
         IF COALESCE (vbProvinceId, 0) = 0
         THEN
             vbProvinceId := gpInsertUpdate_Object_Province (vbProvinceId, 0, inProvinceName, vbRegionId, inSession);
         END IF;
    END IF;


    -- �����
         -- ��������
          IF COALESCE (inCityName, '') = '' THEN RAISE EXCEPTION '������.�� ���������� �������� <���������� �����>.'; END IF;
          -- ��������
          IF COALESCE (inCityKindId, 0) = 0 THEN RAISE EXCEPTION '������.�� ���������� �������� <��� ����������� ������>.'; END IF;

      -- �����
      vbCityId:= (SELECT Object_City.Id
                  FROM Object AS Object_City
                       JOIN ObjectLink AS ObjectLink_City_CityKind ON ObjectLink_City_CityKind.ObjectId = Object_City.Id
                                                                  AND ObjectLink_City_CityKind.DescId = zc_ObjectLink_City_CityKind()
                                                                  AND ObjectLink_City_CityKind.ChildObjectId = inCityKindId
                       LEFT JOIN ObjectLink AS ObjectLink_City_Region ON ObjectLink_City_Region.ObjectId = Object_City.Id
                                                                     AND ObjectLink_City_Region.DescId = zc_ObjectLink_City_Region()
                       LEFT JOIN ObjectLink AS ObjectLink_City_Province ON ObjectLink_City_Province.ObjectId = Object_City.Id
                                                                       AND ObjectLink_City_Province.DescId = zc_ObjectLink_City_Province()
                  WHERE Object_City.DescId = zc_Object_City() AND Object_City.ValueData = inCityName
                    AND COALESCE (ObjectLink_City_Region.ChildObjectId, 0) = COALESCE (vbRegionId, 0)
                    AND COALESCE (ObjectLink_City_Province.ChildObjectId, 0) = COALESCE (vbProvinceId, 0)
                  );
      -- ��������
      IF COALESCE (vbCityId, 0) = 0
      THEN
          vbCityId := gpInsertUpdate_Object_City (vbCityId, 0, inCityName, inCityKindId, vbRegionId, vbProvinceId, inSession);
      END IF;


      -- ���������� � ���������� ������
      IF inProvinceCityName <> ''
      THEN
          -- ��������
          IF COALESCE (vbCityId, 0) = 0 THEN RAISE EXCEPTION '������.�� ���������� �������� <���������� �����>.'; END IF;   -- �� ���� ������ �� ����� ����
          -- �����
          vbProvinceCityId:= (SELECT Object_ProvinceCity.Id 
                              FROM Object AS Object_ProvinceCity
                                   INNER JOIN ObjectLink AS ObjectLink_ProvinceCity_City ON ObjectLink_ProvinceCity_City.ObjectId = Object_ProvinceCity.Id
                                                                                        AND ObjectLink_ProvinceCity_City.DescId = zc_ObjectLink_ProvinceCity_City()
                                                                                        AND ObjectLink_ProvinceCity_City.ChildObjectId = vbCityId
                              WHERE Object_ProvinceCity.DescId = zc_Object_ProvinceCity() AND Object_ProvinceCity.ValueData = inProvinceCityName);
          -- ��������
          IF COALESCE (vbProvinceCityId, 0) = 0
          THEN
              --
              vbProvinceCityId := gpInsertUpdate_Object_ProvinceCity (vbProvinceCityId, 0, inProvinceCityName, vbCityId, inSession);
          END IF;
      END IF;


   -- �����
      -- ��������
      IF COALESCE (inStreetName, '') = '' THEN RAISE EXCEPTION '������.�� ���������� �������� <�����/��������>.' ; END IF;
      -- ��������
      IF COALESCE (inStreetKindId, 0) = 0 THEN RAISE EXCEPTION '������.�� ���������� �������� <���(�����,��������)>.' ; END IF;
      -- ��������
      IF COALESCE (vbCityId, 0) = 0 THEN RAISE EXCEPTION '������.�� ���������� �������� <���������� �����>.'; END IF;   -- �� ���� ������ �� ����� ����

      vbStreetId:= (SELECT Object_Street.Id
                    FROM Object AS Object_Street
                       JOIN ObjectLink AS ObjectLink_Street_StreetKind ON ObjectLink_Street_StreetKind.ObjectId = Object_Street.Id
                                                                      AND ObjectLink_Street_StreetKind.DescId = zc_ObjectLink_Street_StreetKind()
                                                                      AND ObjectLink_Street_StreetKind.ChildObjectId = inStreetKindId
                       INNER JOIN ObjectLink AS ObjectLink_Street_City ON ObjectLink_Street_City.ObjectId = Object_Street.Id
                                                                      AND ObjectLink_Street_City.DescId = zc_ObjectLink_Street_City()
                                                                      AND ObjectLink_Street_City.ChildObjectId  = vbCityId
                       LEFT JOIN ObjectLink AS ObjectLink_Street_ProvinceCity ON ObjectLink_Street_ProvinceCity.ObjectId = Object_Street.Id
                                                                             AND ObjectLink_Street_ProvinceCity.DescId = zc_ObjectLink_Street_ProvinceCity()
                  WHERE Object_Street.DescId = zc_Object_Street() AND Object_Street.ValueData = inStreetName
                    AND COALESCE (ObjectLink_Street_ProvinceCity.ChildObjectId, 0) = COALESCE (vbProvinceCityId, 0)
                  );
      -- ��������
      IF COALESCE (vbStreetId, 0) = 0
      THEN
          vbStreetId := gpInsertUpdate_Object_Street (vbStreetId, 0, inStreetName, inPostalCode, inStreetKindId, vbCityId, vbProvinceCityId, inSession);
      END IF;
      
    
    END IF; -- if � ���� ������ "���������" ������


   -- ����� - ��������� ����� � <�����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_Street(), inId, vbStreetId);

 
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, inUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.11.14                                        * all
 11.11.14         *
*/

-- ����
-- SELECT * FROM lpUpdate_Object_Partner_Address()
