-- Function: lpUpdate_Object_Partner_Params_excel()

DROP FUNCTION IF EXISTS lpUpdate_Object_Partner_Params_excel (Integer, Integer, TVarChar, Integer, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar,  TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Object_Partner_Params_excel(
    IN inId                  Integer   ,    -- ���� ������� <����������> 
    IN inJuridicalId         Integer   ,    -- ����������� ����
    IN inShortName           TVarChar  ,    -- �������� �����������
    IN inCode                Integer   ,    -- ��� ������� <����������> 
--   OUT outPartnerName        TVarChar  ,    -- 
--   OUT outAddress            TVarChar  ,    -- 
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
    IN inUserId              Integer        -- ������������
)
RETURNS VOID
AS
$BODY$
BEGIN

    -- ���������
    PERFORM lpUpdate_Object_Partner_Params( inId                := inId
                                          , inJuridicalId       := inJuridicalId
                                          , inShortName         := inShortName
                                          , inCode              := inCode
                                          , inRegionName        := inRegionName
                                          , inProvinceName      := inProvinceName
                                          , inCityName          := inCityName
                                          , inCityKindId        := inCityKindId
                                          , inProvinceCityName  := inProvinceCityName  
                                          , inPostalCode        := inPostalCode
                                          , inStreetName        := inStreetName
                                          , inStreetKindId      := inStreetKindId
                                          , inHouseNumber       := inHouseNumber
                                          , inCaseNumber        := inCaseNumber  
                                          , inRoomNumber        := inRoomNumber
                                          , inIsCheckUnique     := FALSE
                                          , inUserId            := inUserId
                                           );

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, inUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 03.12.14                                        *
*/

-- ����
-- SELECT * FROM lpUpdate_Object_Partner_Params_excel()
