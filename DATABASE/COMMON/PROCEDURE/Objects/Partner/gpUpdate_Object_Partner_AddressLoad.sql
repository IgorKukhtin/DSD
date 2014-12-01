-- Function: gpUpdate_Object_Partner_Address()

DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_AddressLoad (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar,  TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar
                                                       , TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Partner_AddressLoad(
    IN inId                  Integer   ,    -- ���� ������� <����������> 
    IN inPartnerName         TVarChar  ,    -- ������������ �����������
    IN inOKPO                TVarChar  ,    -- ����
    IN inRegionName          TVarChar  ,    -- ������������ �������
    IN inProvinceName        TVarChar  ,    -- ������������ �����
    IN inCityName            TVarChar  ,    -- ������������ ���������� �����
    IN inCityKindName        TVarChar  ,    -- ��� ����������� ������
    IN inProvinceCityName    TVarChar  ,    -- ������������ ������ ����������� ������
    IN inPostalCode          TVarChar  ,    -- ������
    IN inStreetName          TVarChar  ,    -- ������������ �����
    IN inStreetKindName      TVarChar  ,    -- ��� �����
    IN inHouseNumber         TVarChar  ,    -- ����� ����
    IN inCaseNumber          TVarChar  ,    -- ����� �������
    IN inRoomNumber          TVarChar  ,    -- ����� ��������
    IN inShortName           TVarChar  ,    -- �������� �����������

    IN inOrderName           TVarChar  ,    -- ������
    IN inOrderPhone          TVarChar  ,    --
    IN inOrderMail           TVarChar  ,    --

    IN inDocName             TVarChar  ,    -- ��������
    IN inDocPhone            TVarChar  ,    --
    IN inDocMail             TVarChar  ,    --

    IN inActName             TVarChar  ,    -- ����
    IN inActPhone            TVarChar  ,    --
    IN inActMail             TVarChar  ,    --
    
    IN inPersonal            TVarChar  ,    -- ��������� (�����������)
    IN inPersonalTrade       TVarChar  ,    -- ��������� (��������)
    IN inArea                TVarChar  ,    -- ������
    IN inPartnerTag          TVarChar  ,    -- ������� �������� ����� 

    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId                Integer;
   DECLARE vbPersonalId            Integer;
   DECLARE vbPersonalTradeId       Integer;
   DECLARE vbAreaId                Integer;
   DECLARE vbPartnerTagId          Integer; 
   DECLARE vbCityKindId            Integer; 
   DECLARE vbStreetKindId          Integer; 
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Partner_Address());

   IF COALESCE(inId, 0 = 0) THEN
      RAISE EXCEPTION '������. ���������� "%" �� ������ � ����������� ������������.', inPartnerName;
   END IF;

   SELECT ID INTO vbPersonalId 
             FROM OBJECT WHERE DescId = zc_Object_Personal() AND ValueData = inPersonal;
   IF COALESCE(vbPersonalId, 0) = 0 THEN
      RAISE EXCEPTION '������. ����������� "%" �� ������ � ����������� �����������.', inPersonal;
   END IF;

   SELECT ID INTO vbPersonalTradeId 
             FROM OBJECT WHERE DescId = zc_Object_Personal() AND ValueData = inPersonalTrade;
   IF COALESCE(vbPersonalTradeId, 0) = 0 THEN
      RAISE EXCEPTION '������. �������� ������������� "%" �� ������ � ����������� �����������.', inPersonalTrade;
   END IF;

   SELECT ID INTO vbAreaId 
             FROM OBJECT WHERE DescId = zc_Object_Area() AND ValueData = inArea;
   IF COALESCE(vbAreaId, 0) = 0 THEN
      RAISE EXCEPTION '������. ������ "%" �� ������ � ����������� ��������.', inArea;
   END IF;

   SELECT ID INTO vbPartnerTagId 
             FROM OBJECT WHERE DescId = zc_Object_PartnerTag() AND ValueData = inPartnerTag;
   IF COALESCE(vbPartnerTagId, 0) = 0 THEN
      RAISE EXCEPTION '������. ������� �������� ����� "%" �� ������ � ����������� ��������� �������� �����.', inPartnerTag;
   END IF;

   SELECT ID INTO vbCityKindId 
             FROM OBJECT WHERE DescId = zc_Object_CityKind() AND ValueData = inCityKindName;
   IF COALESCE(vbCityKindId, 0) = 0 THEN
      RAISE EXCEPTION '������. ��� ����������� ������ "%" �� ������ � ����������� ����� ���������� �������.', inCityKindName;
   END IF;

   SELECT ID INTO vbStreetKindId 
             FROM OBJECT WHERE DescId = zc_Object_StreetKind() AND ValueData = inStreetKindName;
   IF COALESCE(vbStreetKindId, 0) = 0 THEN
      RAISE EXCEPTION '������. ��� ����� "%" �� ������ � ����������� ����� ����.', inStreetKindName;
   END IF;

  -- ���������
  PERFORM  lpUpdate_Object_Partner_Address( inId                := inId
                                          , inJuridicalId       := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = inId AND DescId = zc_ObjectLink_Partner_Juridical())
                                          , inShortName         := inShortName
                                          , inCode              := (SELECT ObjectCode FROM Object WHERE Id = inId)
                                          , inRegionName        := inRegionName
                                          , inProvinceName      := inProvinceName
                                          , inCityName          := inCityName
                                          , inCityKindId        := vbCityKindId
                                          , inProvinceCityName  := inProvinceCityName  
                                          , inPostalCode        := inPostalCode
                                          , inStreetName        := inStreetName
                                          , inStreetKindId      := vbStreetKindId
                                          , inHouseNumber       := inHouseNumber
                                          , inCaseNumber        := inCaseNumber  
                                          , inRoomNumber        := inRoomNumber
                                          , inSession           := inSession
                                          , inUserId            := vbUserId
                                           );

   -- ��������� ����� � <��������� (�����������)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Personal(), inId, inPersonalId);
   -- ��������� ����� � <��������� (��������)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PersonalTrade(), inId, inPersonalTradeId);
   -- ��������� ����� � <������>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Area(), inId, inAreaId);
   -- ��������� ����� � <������� �������� �����>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PartnerTag(), inId, inPartnerTagId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 01.12.14                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_Partner_Address()


