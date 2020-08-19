-- Function: lpUpdate_Object_Partner_Params()

DROP FUNCTION IF EXISTS lpUpdate_Object_Partner_Params (Integer, Integer, TVarChar, Integer, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar,  TVarChar, Integer);
DROP FUNCTION IF EXISTS lpUpdate_Object_Partner_Params (Integer, Integer, TVarChar, Integer, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar,  TVarChar, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Object_Partner_Params(
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
    IN inIsCheckUnique       Boolean   ,    -- 
    IN inUserId              Integer        -- ������������
)
RETURNS RECORD
AS
$BODY$
BEGIN

    -- �������� ��������� ��������
    IF COALESCE (inJuridicalId, 0) = 0 
    THEN
      RAISE EXCEPTION '������.�� ����������� <����������� ����>.';
    END IF;

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
                                  THEN ' ���.' || COALESCE (inHouseNumber, '')
                             ELSE ''
                        END
                     || CASE WHEN COALESCE (inCaseNumber, '') <> ''
                                  THEN ' ����.' || COALESCE (inCaseNumber, '')
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


    IF inIsCheckUnique = TRUE
    THEN
        -- �������� ������������ <��������>
        PERFORM lpCheckUnique_Object_ValueData (inId, zc_Object_Partner(), outPartnerName);
    END IF;


    -- ��������� <������>
    PERFORM lpInsertUpdate_Object (inId, zc_Object_Partner(), inCode, outPartnerName);

    -- ��������� �������� <����� ����� ��������>
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Partner_Address(), inId, outAddress);

   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 03.12.14                                        *
*/

-- ����
-- SELECT * FROM lpUpdate_Object_Partner_Params()
