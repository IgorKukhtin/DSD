-- Function: gpUpdate_Object_Partner_AddressLoad()

DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_AddressLoad (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                          , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                          , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Partner_AddressLoad(
    IN inId                  Integer   ,    -- ���� ������� <����������> 
    IN inPartnerName         TVarChar  ,    -- ������������
    IN inJuridicalNameNew    TVarChar  ,    -- ������������ 
    IN inOKPO                TVarChar  ,    -- ����
    IN inPaidKindName        TVarChar  ,    -- 
    IN inRegionName          TVarChar  ,    -- ������������ �������
    IN inProvinceName        TVarChar  ,    -- ������������ �����
    IN inCityName            TVarChar  ,    -- ������������ ���������� �����
    IN inCityKindName        TVarChar  ,    -- ��� ����������� ������
    IN inProvinceCityName    TVarChar  ,    -- ����������
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
    IN inRetailName          TVarChar  ,    -- �������� ����
    IN inPartnerTag          TVarChar  ,    -- ������� �������� �����

    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId                Integer;

   DECLARE vbIsCheckUnique         Boolean;

   DECLARE vbJuridicalId           Integer;

   DECLARE vbRetailId              Integer;
   DECLARE vbPersonalId            Integer;
   DECLARE vbPersonalTradeId       Integer;
   DECLARE vbAreaId                Integer;
   DECLARE vbPartnerTagId          Integer; 
   DECLARE vbCityKindId            Integer; 
   DECLARE vbStreetKindId          Integer; 
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Partner_Address());


   -- ���������� ������ ������� � Excel
   IF COALESCE (inId, 0) = 0
      AND TRIM (COALESCE (inPartnerName, '')) = ''
      AND TRIM (COALESCE (inJuridicalNameNew, '')) = ''
      AND TRIM (COALESCE (inOKPO, '')) = ''
      AND TRIM (COALESCE (inPaidKindName, '')) = ''
      AND TRIM (COALESCE (inRetailName, '')) = ''
      AND TRIM (COALESCE (inRegionName, '')) = ''
      AND TRIM (COALESCE (inProvinceName, '')) = ''
      AND TRIM (COALESCE (inCityName, '')) = ''
      AND TRIM (COALESCE (inCityKindName, '')) = ''
      AND TRIM (COALESCE (inProvinceCityName, '')) = ''
      AND TRIM (COALESCE (inPostalCode, '')) = ''
      AND TRIM (COALESCE (inStreetName, '')) = ''
      AND TRIM (COALESCE (inStreetKindName, '')) = ''
      AND TRIM (COALESCE (inHouseNumber, '')) = ''
      AND TRIM (COALESCE (inCaseNumber, '')) = ''
      AND TRIM (COALESCE (inRoomNumber, '')) = ''
      AND TRIM (COALESCE (inShortName, '')) = ''

      AND TRIM (COALESCE (inOrderName, '')) = ''
      AND TRIM (COALESCE (inOrderPhone, '')) = ''
      AND TRIM (COALESCE (inOrderMail, '')) = ''

      AND TRIM (COALESCE (inDocName, '')) = ''
      AND TRIM (COALESCE (inDocPhone, '')) = ''
      AND TRIM (COALESCE (inDocMail, '')) = ''

      AND TRIM (COALESCE (inActName, '')) = ''
      AND TRIM (COALESCE (inActPhone, '')) = ''
      AND TRIM (COALESCE (inActMail, '')) = ''
    
      AND TRIM (COALESCE (inPersonal, '')) = ''
      AND TRIM (COALESCE (inPersonalTrade, '')) = ''
      AND TRIM (COALESCE (inArea, '')) = ''
      AND TRIM (COALESCE (inPartnerTag, '')) = ''
   THEN
      RETURN;
   END IF;


   -- ��������
   IF COALESCE (inId, 0) = 0
   THEN
      -- ��������
      IF 1=1 OR NOT EXISTS (SELECT Id FROM Object WHERE Id = zc_Enum_PaidKind_SecondForm() AND ValueData = inPaidKindName)
      THEN
          IF inPartnerName <> '' OR inOKPO <> ''
          THEN
              RAISE EXCEPTION '������.��� ����������� <%> c ���� <%> �� ���������� �������� <����>.', inPartnerName, inOKPO;
          ELSE RAISE EXCEPTION '������.������ ������.<%>  <%>  <%>  <%>  <%>  <%>  <%>  <%>  <%>  <%> <%>  <%>  <%>  <%>  <%>  <%>  <%>  <%>  <%>  <%> <%>  <%>  <%>  <%>  <%>  <%>  <%>  <%>  <%>  <%> <%> '
                             , COALESCE (inId, 0)
                             , COALESCE (inPartnerName, '')
                             , COALESCE (inJuridicalNameNew, '')
                             , COALESCE (inOKPO, '')
                             , COALESCE (inPaidKindName, '')
                             , COALESCE (inRetailName, '')
                             , COALESCE (inRegionName, '')
                             , COALESCE (inProvinceName, '')
                             , COALESCE (inCityName, '')
                             , COALESCE (inCityKindName, '')
                             , COALESCE (inProvinceCityName, '')
                             , COALESCE (inPostalCode, '')
                             , COALESCE (inStreetName, '')
                             , COALESCE (inStreetKindName, '')
                             , COALESCE (inHouseNumber, '')
                             , COALESCE (inCaseNumber, '')
                             , COALESCE (inRoomNumber, '')
                             , COALESCE (inShortName, '')

                             , COALESCE (inOrderName, '')
                             , COALESCE (inOrderPhone, '')
                             , COALESCE (inOrderMail, '')

                             , COALESCE (inDocName, '')
                             , COALESCE (inDocPhone, '')
                             , COALESCE (inDocMail, '')

                             , COALESCE (inActName, '')
                             , COALESCE (inActPhone, '')
                             , COALESCE (inActMail, '')
    
                             , COALESCE (inPersonal, '')
                             , COALESCE (inPersonalTrade, '')
                             , COALESCE (inArea, '')
                             , COALESCE (inPartnerTag, '')
                              ;
          END IF;
      END IF;
      -- ��������
      IF COALESCE (TRIM (inStreetName), '') = ''
      THEN
         RAISE EXCEPTION '������.��� ����������� <%> �� ���������� �������� <�������� (�����, ��������)>.', inPartnerName;
      END IF;

      -- �������� ����
      IF CHAR_LENGTH (COALESCE (TRIM (inOKPO), '')) <= 5 THEN
         RAISE EXCEPTION '������.��� ����������� <%> �� ���������� �������� <����>.', inPartnerName;
      END IF;
       
      -- ����� �� ����
      vbJuridicalId:= (SELECT JuridicalId FROM ObjectHistory_JuridicalDetails_View WHERE OKPO = TRIM (inOKPO));
      -- ��������
      IF COALESCE (vbJuridicalId, 0) = 0 THEN
         RAISE EXCEPTION '������.��� ����������� <%> �� ������� ��.���� � ���� = <%>.', inPartnerName, inOKPO;
      END IF;

   END IF;


   -- ��������
   IF inId > 0 AND NOT EXISTS (SELECT Id FROM Object WHERE Id = inId AND DescId = zc_Object_Partner()) THEN
      RAISE EXCEPTION '������.�� ������ ���������� <%> �� ��������� ���� <%>.', inPartnerName, inId;
   END IF;

   -- ��������
   IF 1=1 AND COALESCE (TRIM (inStreetName), '') = '' THEN
      RAISE EXCEPTION '������.��� ����������� <%> �� ���������� �������� <�������� (�����, ��������)>.', inPartnerName;
   END IF;


   -- �����
   vbRetailId:= (SELECT Id FROM Object WHERE DescId = zc_Object_Retail() AND TRIM (ValueData) = TRIM (inRetailName));
   -- ����������
   IF COALESCE (vbRetailId, 0) = 0 AND TRIM (inRetailName) <> '' THEN
     vbRetailId:= gpInsertUpdate_Object_Retail (ioId         := vbRetailId
                                              , inCode       := 0
                                              , inName       := TRIM (inRetailName)
                                              , inGLNCode    := ''
                                              , inSession    := inSession
                                               );
   END IF;
   -- ��������
   IF COALESCE (vbRetailId, 0) = 0 AND TRIM (inRetailName) <> '' THEN
      RAISE EXCEPTION '������.��� ����������� <%> �� ������� �������� <%> � ����������� <�������� ����>.', inPartnerName, inRetailName;
   END IF;


IF inArea = '��������������' THEN inArea:= '��������������'; END IF;
 

IF /*inId IN (293467, 296066) AND */ TRIM (inStreetKindName) = '' THEN inStreetKindName:= '������'; END IF;
IF inStreetKindName = '����' THEN inStreetKindName:= '����'; END IF;
IF inStreetKindName = '�����' THEN inStreetKindName:= '������'; END IF;
IF inStreetKindName = '�������' THEN inStreetKindName:= '�����'; END IF;
IF inStreetKindName = '���.' THEN inStreetKindName:= '��������'; END IF;


IF inPartnerTag = '����������`����' OR inPartnerTag = '�������' || CHR (39) || '����' THEN inPartnerTag:= '�������`����'; END IF;

IF inPersonal = '��������� ����� ���������' THEN inPersonal:= '��������� ���� ���������'; END IF;
IF inPersonalTrade = '��������� ����� ���������' THEN inPersonalTrade:= '��������� ���� ���������'; END IF;
IF inPersonal = '���������� ������� ��������' THEN inPersonal:= '���������� ������ �������'; END IF;
IF inPersonalTrade = '���������� ������� ��������' THEN inPersonalTrade:= '���������� ������ �������'; END IF;

IF inPersonal = '������� ����� ����������' THEN inPersonal:= '������� ����� �����������'; END IF;
IF inPersonalTrade = '������� ����� ����������' THEN inPersonalTrade:= '������� ����� �����������'; END IF;

IF inPersonal = '���� ���� ��������' THEN inPersonal:= '���� ����� ��������'; END IF;
IF inPersonalTrade = '���� ���� ��������' THEN inPersonalTrade:= '���� ����� ��������'; END IF;

IF inPersonalTrade = '����� ��������� �������������' THEN inPersonalTrade:= '����� ����������������������'; END IF;

IF inPersonalTrade = '������� �������� ����𳿿���' THEN inPersonalTrade:= '������� �������� ��������'; END IF;
IF inPersonalTrade = '������ �������' OR inPersonalTrade = '������ ������� ���������' THEN inPersonalTrade:= '����� ������ ���������'; END IF;
IF inPersonalTrade = '�������� ���������' THEN inPersonalTrade:= '��������� ��������� �����������'; END IF;
IF inPersonalTrade = '������ �������' THEN inPersonalTrade:= '������ ������� �����������'; END IF;
IF inPersonalTrade = '�������� �������' THEN inPersonalTrade:= '�������� ������ �����������'; END IF;
IF inPersonalTrade = '������� ������' THEN inPersonalTrade:= '������� ������ �����볿���'; END IF;
IF inPersonalTrade = '���� ����' THEN inPersonalTrade:= '���� ���� �������������'; END IF;
IF inPersonalTrade = '������ �������' THEN inPersonalTrade:= '������ ������� �����������'; END IF;
IF inPersonalTrade = '�������� ������' THEN inPersonalTrade:= '���䳺��� ������ ���������'; END IF;
IF inPersonalTrade = '����������� �����' THEN inPersonalTrade:= '����������� ������ ³��������'; END IF;
IF inPersonalTrade = '����������� ³�����' THEN inPersonalTrade:= '����������� ³����� ���������'; END IF;
 IF inPersonal = '��������� ����� ���������' THEN inPersonal:= '������� ����� ���`�����'; END IF;
 IF inPersonalTrade = '��������� ����� ���������' THEN inPersonalTrade:= '������� ����� ���`�����'; END IF;
 IF inPersonalTrade = '����������� ������ �����������' THEN inPersonalTrade:= '����������� ������  �����볿���'; END IF;


   -- ������
   IF POSITION (CHR (39) in inPersonal) > 0 THEN inPersonal:= left (inPersonal, POSITION (CHR (39) in inPersonal) - 1) || '`' || right (inPersonal, length (inPersonal) - POSITION (CHR (39) in inPersonal)); END IF;
   -- �����
   vbPersonalId:= (SELECT MAX (PersonalId) FROM Object_Personal_View WHERE isMain = TRUE AND TRIM (PersonalName) = TRIM (inPersonal));
   -- ��������
   IF COALESCE (vbPersonalId, 0) = 0 AND TRIM (inPersonal) <> '' AND 1=0 THEN
      RAISE EXCEPTION '������.��� ����������� <%> �� ������� �������� ������������ <%> � ����������� <����������>.', inPartnerName, inPersonal;
   END IF;


   -- ������
   IF POSITION (CHR (39) in inPersonalTrade) > 0 THEN inPersonalTrade:= left (inPersonalTrade, POSITION (CHR (39) in inPersonalTrade) - 1) || '`' || right (inPersonalTrade, length (inPersonalTrade) - POSITION (CHR (39) in inPersonalTrade)); END IF;
   -- �����
   vbPersonalTradeId:= (SELECT MAX (PersonalId) FROM Object_Personal_View WHERE isMain = TRUE AND TRIM (PersonalName) = TRIM (inPersonalTrade));
   -- ��������
   IF COALESCE (vbPersonalTradeId, 0) = 0 AND TRIM (inPersonalTrade) <> '' AND 1=0 THEN
      RAISE EXCEPTION '������.��� ����������� <%> �� ������� �������� �������� ������������� <%> � ����������� <����������>.', inPartnerName, inPersonalTrade;
   END IF;


   -- �����
   vbAreaId:= (SELECT Id FROM Object WHERE DescId = zc_Object_Area() AND TRIM (ValueData) = TRIM (inArea));
   -- ��������
   IF COALESCE (vbAreaId, 0) = 0 THEN
      RAISE EXCEPTION '������.��� ����������� <%> �� ������� �������� <%> � ����������� <�������>.', inPartnerName, inArea;
   END IF;


   -- �����
   vbPartnerTagId:= (SELECT Id FROM Object WHERE DescId = zc_Object_PartnerTag() AND TRIM (ValueData) = TRIM (inPartnerTag));
   -- ��������
   IF COALESCE (vbPartnerTagId, 0) = 0 THEN
      RAISE EXCEPTION '������.��� ����������� <%> �� ������� �������� <%> � ����������� <������� �������� �����>.', inPartnerName, inPartnerTag;
   END IF;


   -- �����
   vbCityKindId:= (SELECT Id FROM Object WHERE DescId = zc_Object_CityKind() AND TRIM (ValueData) = TRIM (inCityKindName));
   -- ��������
   IF COALESCE (vbCityKindId, 0) = 0 AND COALESCE (TRIM (inStreetName), '') <> '' THEN
      RAISE EXCEPTION '������.��� ����������� <%> �� ������� �������� <%> � ����������� <��� ����������� ������>.', inPartnerName, inCityKindName;
   END IF;


   -- �����
   vbStreetKindId:= (SELECT Id FROM Object WHERE DescId = zc_Object_StreetKind() AND TRIM (ValueData) = TRIM (inStreetKindName));
   -- ��������
   IF COALESCE (vbStreetKindId, 0) = 0 AND COALESCE (TRIM (inStreetName), '') <> '' THEN
      RAISE EXCEPTION '������.��� ����������� <%> �� ������� �������� <%> � ����������� <��� (�����,��������)>.', inPartnerName, inStreetKindName;
   END IF;




   -- !!!�������� �������� ��.����!!!
   IF inId <> 0
      AND TRIM (inJuridicalNameNew) <> ''
      AND EXISTS (SELECT Id FROM Object WHERE Id = zc_Enum_PaidKind_SecondForm() AND ValueData = inPaidKindName)
   THEN
      -- ��������
      IF NOT EXISTS (SELECT JuridicalId FROM ObjectHistory_JuridicalDetails_View WHERE JuridicalId = (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = inId AND DescId = zc_ObjectLink_Partner_Juridical()) AND OKPO = TRIM (inOKPO))
      THEN
         RAISE EXCEPTION '������.��� ����������� <%> ������ ������� �� ��.���� � ���� = <%>.', inPartnerName, inOKPO;
      END IF;

       -- 
       PERFORM gpInsertUpdate_Object_Juridical (ioId               := tmp.Id
                                              , inCode             := tmp.Code
                                              , inName             := tmp.Name
                                              , inGLNCode          := tmp.GLNCode
                                              , inisCorporate      := isCorporate
                                              , inisTaxSummary     := NULL
                                              , inisDiscountPrice  := NULL
                                              , inDayTaxSummary    := 0
                                              , inJuridicalGroupId := tmp.JuridicalGroupId
                                              , inGoodsPropertyId  := tmp.GoodsPropertyId
                                              , inRetailId         := tmp.RetailId
                                              , inRetailReportId   := tmp.RetailReportId
                                              , inInfoMoneyId      := tmp.InfoMoneyId
                                              , inPriceListId      := tmp.PriceListId
                                              , inPriceListPromoId := tmp.PriceListPromoId
                                              , inStartPromo       := tmp.StartPromo
                                              , inEndPromo         := tmp.EndPromo
                                              , inSession          := inSession
                                               )
       FROM gpGet_Object_Juridical (inId      := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = inId AND DescId = zc_ObjectLink_Partner_Juridical())
                                  , inName    := ''
                                  , inSession := inSession
                                   ) AS tmp
       WHERE tmp.Id <> 0;
   END IF;


   IF COALESCE (TRIM (inStreetName), '') <> ''
   THEN
     -- ����� �� ������
     IF COALESCE (inId, 0) = 0
     THEN
         inId:= (SELECT ObjectLink.ObjectId
                 FROM ObjectLink INNER JOIN ObjectString ON ObjectString.ObjectId = ObjectLink.ObjectId AND ObjectString.DescId = zc_ObjectString_Partner_Address() AND ObjectString.ValueData
                = TRIM (COALESCE ((SELECT ValueData FROM ObjectString WHERE ObjectId = vbCityKindId AND DescId = zc_ObjectString_CityKind_ShortName()), '')
              || ' ' || COALESCE (inCityName, '')
              || ' ' || COALESCE ((SELECT ValueData FROM ObjectString WHERE ObjectId = vbStreetKindId AND DescId = zc_ObjectString_StreetKind_ShortName()), '')
              || ' ' || COALESCE (inStreetName, '')
                     || CASE WHEN COALESCE (inHouseNumber, '') <> ''
                                  THEN ' ' || COALESCE (inHouseNumber, '')
                             ELSE ''
                        END
                     || CASE WHEN COALESCE (inCaseNumber, '') <> ''
                                  THEN ' ' || COALESCE (inCaseNumber, '')
                             ELSE ''
                        END
                       )
                 WHERE ObjectLink.ChildObjectId = vbJuridicalId AND ObjectLink.DescId = zc_ObjectLink_Partner_Juridical()

                UNION 
                 SELECT ObjectLink.ObjectId
                 FROM ObjectLink INNER JOIN ObjectString ON ObjectString.ObjectId = ObjectLink.ObjectId AND ObjectString.DescId = zc_ObjectString_Partner_Address() AND ObjectString.ValueData
                = TRIM (COALESCE ((SELECT ValueData FROM ObjectString WHERE ObjectId = vbCityKindId AND DescId = zc_ObjectString_CityKind_ShortName()), '')
              || ' ' || COALESCE (inCityName, '')
              || ' ' || COALESCE ((SELECT ValueData FROM ObjectString WHERE ObjectId = vbStreetKindId AND DescId = zc_ObjectString_StreetKind_ShortName()), '')
              || ' ' || COALESCE (inStreetName, '')
                     || CASE WHEN COALESCE (inHouseNumber, '') <> ''
                                  THEN ' ���.' || COALESCE (inHouseNumber, '')
                             ELSE ''
                        END
                     || CASE WHEN COALESCE (inCaseNumber, '') <> ''
                                  THEN ' ' || COALESCE (inCaseNumber, '')
                             ELSE ''
                        END
                       )
                 WHERE ObjectLink.ChildObjectId = vbJuridicalId AND ObjectLink.DescId = zc_ObjectLink_Partner_Juridical()
                );
     END IF;


   -- ���������
   IF COALESCE (inId, 0) = 0 THEN
   vbIsCheckUnique:= TRUE;
   inId := lpInsertUpdate_Object_Partner (ioId              := inId
                                        , inCode            := 0
                                        , inGLNCode         := ''
                                        , inGLNCodeJuridical:= ''
                                        , inGLNCodeRetail   := ''
                                        , inGLNCodeCorporate:= ''
                                        , inSchedule        := 'f;f;f;f;f;f;f'
                                        , inPrepareDayCount := 0
                                        , inDocumentDayCount:= 0
                                        , inCategory        := 0
                                        , inEdiOrdspr       := FALSE
                                        , inEdiInvoice      := FALSE
                                        , inEdiDesadv       := FALSE
                                        , inJuridicalId     := vbJuridicalId
                                        , inRouteId         := NULL
                                        , inRouteId_30201   := NULL
                                        , inRouteSortingId  := NULL
                                        , inMemberTakeId    := NULL
                                        , inPersonalId      := NULL
                                        , inPersonalTradeId := NULL
                                        , inAreaId          := NULL
                                        , inPartnerTagId    := NULL
                                        , inGoodsPropertyId := NULL
           
                                        , inPriceListId     := NULL
                                        , inPriceListId_30201:= NULL
                                        , inPriceListPromoId:= NULL
                                        , inUnitMobileId    := NULL
                                        , inStartPromo      := NULL
                                        , inEndPromo        := NULL
                                        , inUserId          := vbUserId
                                         );
   ELSE
       vbIsCheckUnique:= FALSE;
   END IF;


    -- ���������
    PERFORM lpUpdate_Object_Partner_Address( inId                := inId
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
                                           , inIsCheckUnique     := vbIsCheckUnique
                                           , inSession           := inSession
                                           , inUserId            := vbUserId
                                            );
   END IF;

   IF TRIM (inRetailName) <> ''
   THEN
       -- ��������� ����� !!!�� ����!!! � <�������� ����)>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Juridical_Retail(), (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = inId AND DescId = zc_ObjectLink_Partner_Juridical()), vbRetailId);
   END IF;

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


   -- ��������� ����� � <��������� (�����������)>
   IF vbPersonalId <> 0
   THEN
       PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Personal(), inId, vbPersonalId);
   END IF;
   -- ��������� ����� � <��������� (��������)>
   IF vbPersonalTradeId <> 0
   THEN
       PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PersonalTrade(), inId, vbPersonalTradeId);
   END IF;
   -- ��������� ����� � <������>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Area(), inId, vbAreaId);
   -- ��������� ����� � <������� �������� �����>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PartnerTag(), inId, vbPartnerTagId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.12.14                                        * all
 01.12.14                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_Partner_AddressLoad()
