-- Function: gpUpdate_Object_Partner_Address()

DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Address (Integer, TVarChar, TVarChar, TVarChar
                                                       , Integer, TVarChar, TVarChar, TVarChar
                                                       , Integer, TVarChar, TVarChar,  TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar
                                                       , Integer, Integer, Integer, Integer, Integer
                                                       , TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Address (Integer, TVarChar, TVarChar, TVarChar
                                                       , Integer, TVarChar, TVarChar, TVarChar
                                                       , Integer, TVarChar, TVarChar,  TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar
                                                       , Integer, Integer, Integer, Integer, Integer, Integer
                                                       , TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Address (Integer, TVarChar, TVarChar, TVarChar
                                                       , Integer, TVarChar, TVarChar, TVarChar
                                                       , Integer, TVarChar, TVarChar,  TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar
                                                       , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                       , TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Partner_Address(
    IN inId                  Integer   ,    -- ���� ������� <����������> 
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
    
    IN inMemberTakeId        Integer   ,    -- ��� ���� (��������� ����������)
    IN inPersonalId          Integer   ,    -- ��������� (�����������)
    IN inPersonalTradeId     Integer   ,    -- ��������� (��������)
    IN inPersonalMerchId     Integer   ,    -- ��������� (������������)
    IN inAreaId              Integer   ,    -- ������
    IN inPartnerTagId        Integer   ,    -- ������� �������� ����� 

    IN inRouteId             Integer   ,    --
    IN inRetailId            Integer   ,    -- �������� ���� ������ � ��.����

    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   
   DECLARE vbRouteId Integer;
   DECLARE vbRetailId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbOrderName TVarChar; vbOrderPhone TVarChar; vbOrderMail TVarChar;
   DECLARE vbDocName TVarChar; vbDocPhone TVarChar; vbDocMail TVarChar;
   DECLARE vbActName TVarChar; vbActPhone TVarChar; vbActMail TVarChar;
   
   DECLARE vbRegionName          TVarChar  ;    -- ������������ �������
           vbProvinceName        TVarChar  ;    -- ������������ �����
           vbCityName            TVarChar  ;    -- ������������ ���������� �����
           vbCityKindId          Integer   ;    -- ��� ����������� ������
           vbProvinceCityName    TVarChar  ;    -- ������������ ������ ����������� ������
           vbPostalCode          TVarChar  ;    -- ������
           vbStreetName          TVarChar  ;    -- ������������ �����
           vbStreetKindId        Integer   ;    -- ��� �����
           vbHouseNumber         TVarChar  ;    -- ����� ����
           vbCaseNumber          TVarChar  ;    -- ����� �������
           vbRoomNumber          TVarChar  ;    -- ����� ��������
           vbShortName           TVarChar  ;    -- �������� �����������
           vbMemberTakeId        Integer   ;    -- ��� ���� (��������� ����������)
           vbPersonalId          Integer   ;    -- ��������� (�����������)
           vbPersonalTradeId     Integer   ;    -- ��������� (��������)
           vbPersonalMerchId     Integer   ;    -- ��������� (������������)
           vbAreaId              Integer   ;    -- ������
           vbPartnerTagId        Integer   ;   -- ������� �������� ����� 
BEGIN


   CREATE TEMP TABLE tmpContactPerson (Id Integer, Name TVarChar/*, Phone TVarChar, Mail TVarChar*/, ContactPersonKindId Integer) ON COMMIT DROP;
   INSERT INTO tmpContactPerson (Id, Name, ContactPersonKindId)
           SELECT Object_ContactPerson.Id          AS Id
                , Object_ContactPerson.ValueData   AS Name
                --, ObjectString_Phone.ValueData     AS Phone
                --, ObjectString_Mail.ValueData      AS Mail
                , ObjectLink_ContactPerson_ContactPersonKind.ChildObjectId AS ContactPersonKindId
           FROM ObjectLink
                LEFT JOIN Object AS Object_ContactPerson
                                 ON Object_ContactPerson.Id = ObjectLink.ObjectId
                                AND Object_ContactPerson.DescId = zc_Object_ContactPerson()

                JOIN ObjectLink AS ObjectLink_ContactPerson_ContactPersonKind
                                ON ObjectLink_ContactPerson_ContactPersonKind.ObjectId = Object_ContactPerson.Id
                               AND ObjectLink_ContactPerson_ContactPersonKind.DescId = zc_ObjectLink_ContactPerson_ContactPersonKind()
                /*LEFT JOIN ObjectString AS ObjectString_Phone
                                       ON ObjectString_Phone.ObjectId = Object_ContactPerson.Id
                                      AND ObjectString_Phone.DescId = zc_ObjectString_ContactPerson_Phone()
                LEFT JOIN ObjectString AS ObjectString_Mail
                                       ON ObjectString_Mail.ObjectId = Object_ContactPerson.Id
                                      AND ObjectString_Mail.DescId = zc_ObjectString_ContactPerson_Mail()*/
           WHERE ObjectLink.ChildObjectId = inId
             AND ObjectLink.DescId = zc_ObjectLink_ContactPerson_Object()
           ;
  
   vbOrderName := (SELECT tmpContactPerson.Name FROM tmpContactPerson WHERE tmpContactPerson.ContactPersonKindId = 153272);    --"������������ �������"
   vbDocName   := (SELECT tmpContactPerson.Name FROM tmpContactPerson WHERE tmpContactPerson.ContactPersonKindId = 153273);      --"�������� ����������"
   vbActName   := (SELECT tmpContactPerson.Name FROM tmpContactPerson WHERE tmpContactPerson.ContactPersonKindId = 153274);      --"���� ������ � ���������� �����"
   vbRouteId        := (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.ObjectId = inId AND ObjectLink.DescId = zc_ObjectLink_Partner_Route());

   SELECT ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
        , ObjectLink_Juridical_Retail.ChildObjectId  AS RetailId
  INTO vbJuridicalId, vbRetailId
   FROM ObjectLink AS ObjectLink_Partner_Juridical
        INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
   WHERE ObjectLink_Partner_Juridical.ObjectId = inId
     AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical();

   -- ����������� ������
   SELECT tmp.RegionName  
      , tmp.ProvinceName    
      , tmp.CityName
      , tmp.CityKindId      
      , tmp.ProvinceCityName
      , tmp.PostalCode      
      , tmp.StreetName      
      , tmp.StreetKindId    
      , tmp.HouseNumber     
      , tmp.CaseNumber      
      , tmp.RoomNumber      
      , tmp.ShortName       
      , tmp.MemberTakeId    
      , tmp.PersonalId      
      , tmp.PersonalTradeId 
      , tmp.PersonalMerchId 
      , tmp.AreaId          
      , tmp.PartnerTagId
  INTO vbRegionName  
      , vbProvinceName    
      , vbCityName        
      , vbCityKindId      
      , vbProvinceCityName
      , vbPostalCode      
      , vbStreetName      
      , vbStreetKindId    
      , vbHouseNumber     
      , vbCaseNumber      
      , vbRoomNumber      
      , vbShortName       
      , vbMemberTakeId    
      , vbPersonalId      
      , vbPersonalTradeId 
      , vbPersonalMerchId 
      , vbAreaId          
      , vbPartnerTagId  
   FROM gpGet_Object_Partner(inId          := inId ::Integer        -- ����������� 
                           , inMaskId      := 0    ::Integer       -- 
                           , inJuridicalId := 0    ::Integer        -- 
                           , inSession     := inSession) AS tmp;

   
   IF vbRouteId <> inRouteId OR vbRetailId <> inRetailId
   OR vbActName <> inActName OR vbActPhone <> inActPhone OR vbActMail <> inActMail
   OR vbDocName <> inDocName OR vbDocPhone <> inDocPhone OR vbDocMail <> inDocMail
   OR vbOrderName <> inOrderName OR vbOrderPhone <> inOrderPhone OR vbOrderMail <> inOrderMail
   THEN
       -- �������� ���� ������������ �� ����� ���������
       vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Partner_Trade());
       
       -- ��������� �����  <��.����> � �������� ����
       PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_Retail(), vbJuridicalId, inRetailId);

       -- ��������� ����� � <> 
       PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Route(), inId, inRouteId);

       -- ���������� ���� 
       PERFORM lpUpdate_Object_Partner_ContactPerson (inId        := inId
                                                    , inOrderName := inOrderName
                                                    , inOrderPhone:= inOrderPhone
                                                    , inOrderMail := inOrderMail
                                                    , inDocName   := inDocName
                                                    , inDocPhone  := inDocPhone
                                                    , inDocMail   := inDocMail
                                                    , inActName   := inActName
                                                    , inActPhone  := inActPhone
                                                    , inActMail   := inActMail
                                                    , inSession   := inSession
                                                     );

   END IF;

   --���� �������� �� ������ ���������� ���� �������� ������ ����
   IF inRegionName          <> vbRegionName
      OR inProvinceName     <> vbProvinceName
      OR inCityName         <> vbCityName
      OR inCityKindId       <> vbCityKindId
      OR inProvinceCityName <> vbProvinceCityName
      OR inPostalCode       <> vbPostalCode
      OR inStreetName       <> vbStreetName
      OR inStreetKindId     <> vbStreetKindId
      OR inHouseNumber      <> vbHouseNumber
      OR inCaseNumber       <> vbCaseNumber
      OR inRoomNumber       <> vbRoomNumber
      OR inShortName        <> vbShortName
      OR inMemberTakeId     <> vbMemberTakeId
      OR inPersonalId       <> vbPersonalId
      OR inPersonalTradeId  <> vbPersonalTradeId
      OR inPersonalMerchId  <> vbPersonalMerchId
      OR inAreaId           <> vbAreaId
      OR inPartnerTagId     <> vbPartnerTagId
   THEN
       -- �������� ���� ������������ �� ����� ���������
       vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Partner_Address());
 

       -- ��������� ����� � <��� ���� (��������� ����������)>
       PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_MemberTake(), inId, inMemberTakeId);
       -- ��������� ����� � <��������� (�����������)>
       PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Personal(), inId, inPersonalId);
       -- ��������� ����� � <��������� (��������)>
       PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PersonalTrade(), inId, inPersonalTradeId);
       -- ��������� ����� � <��������� (������������)>
       PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PersonalMerch(), inId, inPersonalMerchId);
       -- ��������� ����� � <������>
       PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Area(), inId, inAreaId);
       -- ��������� ����� � <������� �������� �����>
       PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PartnerTag(), inId, inPartnerTagId);


       -- ���������
       SELECT tmp.outPartnerName, tmp.outAddress
             INTO outPartnerName, outAddress
          FROM lpUpdate_Object_Partner_Address( inId                := inId
                                              , inJuridicalId       := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = inId AND DescId = zc_ObjectLink_Partner_Juridical())
                                              , inShortName         := inShortName
                                              , inCode              := (SELECT ObjectCode FROM Object WHERE Id = inId)
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
                                              , inSession           := inSession
                                              , inUserId            := vbUserId
                                               ) AS tmp;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.02.22         * ���������� �� ������
 19.06.17         * add inPersonalMerchId
 12.11.14         *
 19.06.14         *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_Partner_Address()
