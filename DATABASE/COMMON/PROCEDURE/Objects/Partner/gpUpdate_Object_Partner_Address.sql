-- Function: gpUpdate_Object_Partner_Address()


DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Address (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar
                                                       , Integer, TVarChar, TVarChar, TVarChar
                                                       , Integer, TVarChar, TVarChar,  TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);


DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Address (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar
                                                       , Integer, TVarChar, TVarChar, TVarChar
                                                       , Integer, TVarChar, TVarChar,  TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar
                                                       , Integer, Integer, Integer, Integer, Integer
                                                       , TVarChar);




CREATE OR REPLACE FUNCTION gpUpdate_Object_Partner_Address(
 INOUT ioId                  Integer   ,    -- ���� ������� <����������> 
   --OUT outPartnerName        TVarChar  ,    -- ���� ������� <����������> 
    IN inCode                Integer   ,    -- ��� ������� <����������> 
    IN inName                TVarChar  ,    -- <����������> 
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
    IN inShortName           TVarChar  ,    -- ����������

    IN inOrderName           TVarChar  ,    -- ������
    IN inOrderPhone          TVarChar  ,    --
    IN inOrderMail           TVarChar  ,    --

    IN inDocName             TVarChar  ,    -- ��������
    IN inDocPhone            TVarChar  ,    --
    IN inDocMail             TVarChar  ,    --

    IN inActName             TVarChar  ,    -- ����
    IN inActPhone            TVarChar  ,    --
    IN inActMail             TVarChar  ,    --
    
    IN inMemberTakeId        Integer   ,    -- ��� ����(��������� ����������) 
    IN inMemberId            Integer   ,    -- ��� ���� (������������� ����)
    IN inMemberTradeId       Integer   ,    -- ��� ����(��������)
    IN inAreaId              Integer   ,    -- ������
    IN inPartnerTagId        Integer   ,    -- ������� �������� ����� 


    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;   
   DECLARE vbAddress TVarChar;

   DECLARE vbRegionId Integer;
   DECLARE vbProvinceId Integer;
   DECLARE vbCityId Integer;
   DECLARE vbStreetId Integer;
   DECLARE vbProvinceCityId Integer;
   DECLARE vbContactPersonId Integer;
   DECLARE vbContactPersonKindId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Partner_Address());

   -- !!! ���� ��� �� ����������, ���������� ��� ��� ���������+1 (!!! ����� ���� ����� ��� �������� !!!)
   -- !!! vbCode:= lfGet_ObjectCode (inCode, zc_Object_Partner());
   IF COALESCE (inCode, 0) = 0  THEN vbCode := 0; ELSE vbCode := inCode; END IF; -- !!! � ��� ������ !!!

 
   -- ���������
   ioId := lpUpdate_Object_Partner_Address( ioId                := ioId
                                          , inCode              := vbCode 
                                          , inName              := inName   
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
                                          , inShortName         := inShortName
                                          , inSession           := inSession);


  -- ���������� ���� 
  -- ������
   IF inOrderName <> '' THEN
      -- ��������
      vbContactPersonKindId := zc_Enum_ContactPersonKind_CreateOrder();
      
      vbContactPersonId:= (SELECT Object_ContactPerson.Id
                           FROM Object AS Object_ContactPerson
                                JOIN ObjectString AS ObjectString_Phone
                                                  ON ObjectString_Phone.ObjectId = Object_ContactPerson.Id 
                                                 AND ObjectString_Phone.DescId = zc_ObjectString_ContactPerson_Phone()
                                                 AND ObjectString_Phone.ValueData = inOrderPhone
                                JOIN ObjectString AS ObjectString_Mail
                                                  ON ObjectString_Mail.ObjectId = Object_ContactPerson.Id 
                                                 AND ObjectString_Mail.DescId = zc_ObjectString_ContactPerson_Mail()
                                                 AND ObjectString_Mail.ValueData = inOrderMail
                                                            
                                JOIN ObjectLink AS ContactPerson_ContactPerson_Object
                                                ON ContactPerson_ContactPerson_Object.ObjectId = Object_ContactPerson.Id
                                                AND ContactPerson_ContactPerson_Object.DescId = zc_ObjectLink_ContactPerson_Object()
                                JOIN Object AS ContactPerson_Object 
                                            ON ContactPerson_Object.Id = ContactPerson_ContactPerson_Object.ChildObjectId
                                           AND ContactPerson_Object.DescId = zc_Object_Partner()
                                           AND ContactPerson_Object.Id = ioId
            
                                JOIN ObjectLink AS ObjectLink_ContactPerson_ContactPersonKind
                                                ON ObjectLink_ContactPerson_ContactPersonKind.ObjectId = Object_ContactPerson.Id
                                               AND ObjectLink_ContactPerson_ContactPersonKind.DescId = zc_ObjectLink_ContactPerson_ContactPersonKind()
                                               AND ObjectLink_ContactPerson_ContactPersonKind.ChildObjectId = vbContactPersonKindId
                           WHERE Object_ContactPerson.DescId = zc_Object_ContactPerson()
                             AND Object_ContactPerson.ValueData = inOrderName
                           );
      IF COALESCE (vbContactPersonId, 0) = 0
      THEN
          vbContactPersonId := gpInsertUpdate_Object_ContactPerson (vbContactPersonId, 0, inOrderName, inOrderPhone, inOrderMail, '+', ioId, 0, 0, vbContactPersonKindId, inSession);
          
      END IF;

   END IF;

 -- ��������
   IF inDocName <> '' THEN
      -- ��������
      vbContactPersonId := 0;
      vbContactPersonKindId := zc_Enum_ContactPersonKind_CheckDocument();
      
      vbContactPersonId:= (SELECT Object_ContactPerson.Id
                           FROM Object AS Object_ContactPerson
                                JOIN ObjectString AS ObjectString_Phone
                                                  ON ObjectString_Phone.ObjectId = Object_ContactPerson.Id 
                                                 AND ObjectString_Phone.DescId = zc_ObjectString_ContactPerson_Phone()
                                                 AND ObjectString_Phone.ValueData = inDocPhone
                                JOIN ObjectString AS ObjectString_Mail
                                                  ON ObjectString_Mail.ObjectId = Object_ContactPerson.Id 
                                                 AND ObjectString_Mail.DescId = zc_ObjectString_ContactPerson_Mail()
                                                 AND ObjectString_Mail.ValueData = inDocMail
                                                            
                                JOIN ObjectLink AS ContactPerson_ContactPerson_Object
                                                ON ContactPerson_ContactPerson_Object.ObjectId = Object_ContactPerson.Id
                                                AND ContactPerson_ContactPerson_Object.DescId = zc_ObjectLink_ContactPerson_Object()
                                JOIN Object AS ContactPerson_Object 
                                            ON ContactPerson_Object.Id = ContactPerson_ContactPerson_Object.ChildObjectId
                                           AND ContactPerson_Object.DescId = zc_Object_Partner()
                                           AND ContactPerson_Object.Id = ioId
            
                                JOIN ObjectLink AS ObjectLink_ContactPerson_ContactPersonKind
                                                ON ObjectLink_ContactPerson_ContactPersonKind.ObjectId = Object_ContactPerson.Id
                                               AND ObjectLink_ContactPerson_ContactPersonKind.DescId = zc_ObjectLink_ContactPerson_ContactPersonKind()
                                               AND ObjectLink_ContactPerson_ContactPersonKind.ChildObjectId = vbContactPersonKindId
                           WHERE Object_ContactPerson.DescId = zc_Object_ContactPerson()
                             AND Object_ContactPerson.ValueData = inDocName
                           );

      IF COALESCE (vbContactPersonId, 0) = 0
      THEN
          vbContactPersonId := gpInsertUpdate_Object_ContactPerson (vbContactPersonId, 0, inDocName, inDocPhone, inDocMail, '+', ioId, 0, 0, vbContactPersonKindId, inSession);
      END IF;

   END IF;

 -- ���� ������
   IF inActName <> '' THEN
      -- ��������
      vbContactPersonId := 0;
      vbContactPersonKindId := zc_Enum_ContactPersonKind_AktSverki();
      
      vbContactPersonId:= (SELECT Object_ContactPerson.Id
                           FROM Object AS Object_ContactPerson
                                JOIN ObjectString AS ObjectString_Phone
                                                  ON ObjectString_Phone.ObjectId = Object_ContactPerson.Id 
                                                 AND ObjectString_Phone.DescId = zc_ObjectString_ContactPerson_Phone()
                                                 AND ObjectString_Phone.ValueData = inActPhone
                                JOIN ObjectString AS ObjectString_Mail
                                                  ON ObjectString_Mail.ObjectId = Object_ContactPerson.Id 
                                                 AND ObjectString_Mail.DescId = zc_ObjectString_ContactPerson_Mail()
                                                 AND ObjectString_Mail.ValueData = inActMail
                                                            
                                JOIN ObjectLink AS ContactPerson_ContactPerson_Object
                                                ON ContactPerson_ContactPerson_Object.ObjectId = Object_ContactPerson.Id
                                                AND ContactPerson_ContactPerson_Object.DescId = zc_ObjectLink_ContactPerson_Object()
                                JOIN Object AS ContactPerson_Object 
                                            ON ContactPerson_Object.Id = ContactPerson_ContactPerson_Object.ChildObjectId
                                           AND ContactPerson_Object.DescId = zc_Object_Partner()
                                           AND ContactPerson_Object.Id = ioId
            
                                JOIN ObjectLink AS ObjectLink_ContactPerson_ContactPersonKind
                                                ON ObjectLink_ContactPerson_ContactPersonKind.ObjectId = Object_ContactPerson.Id
                                               AND ObjectLink_ContactPerson_ContactPersonKind.DescId = zc_ObjectLink_ContactPerson_ContactPersonKind()
                                               AND ObjectLink_ContactPerson_ContactPersonKind.ChildObjectId = vbContactPersonKindId
                           WHERE Object_ContactPerson.DescId = zc_Object_ContactPerson()
                             AND Object_ContactPerson.ValueData = inActName
                           );

      IF COALESCE (vbContactPersonId, 0) = 0
      THEN
          vbContactPersonId := gpInsertUpdate_Object_ContactPerson (vbContactPersonId, 0, inActName, inActPhone, inActMail, '+', ioId, 0, 0, vbContactPersonKindId, inSession);
      END IF;

   END IF;


   -- ��������� ����� � <��������� (����������)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_MemberTake(), ioId, inMemberTakeId);
   -- ��������� ����� � <��������� ()>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Member(), ioId, inMemberId);
   -- ��������� ����� � <��������� ()>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_MemberTrade(), ioId, inMemberTradeId);
   -- ��������� ����� � <������>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Area(), ioId, inAreaId);
   -- ��������� ����� � <������� �������� �����>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PartnerTag(), ioId, inPartnerTagId);


    -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpUpdate_Object_Partner_Address (Integer, Integer,  TVarChar, TVarChar,  TVarChar, TVarChar, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.11.14         *
 19.06.14         *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_Partner_Address()


