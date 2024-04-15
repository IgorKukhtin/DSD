-- �������� �����

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                     , TFloat, TFloat, TFloat
                                                     , Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                     , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                     , TFloat, TFloat, TFloat
                                                     , Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                     , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                     , TFloat, TFloat, TFloat
                                                     , Integer, Integer, Integer, Integer, Integer, TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                     , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar , TVarChar, TVarChar, TVarChar
                                                     , TFloat, TFloat, TFloat
                                                     , Integer, Integer, Integer, Integer, TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                     , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar , TVarChar, TVarChar, TVarChar
                                                     , TFloat, TFloat, TFloat
                                                     , Integer, Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Partner(
 INOUT ioId              Integer,       -- ���� ������� <>
 INOUT ioCode            Integer,       -- �������� <��� >
    IN inName            TVarChar,      -- ������� ��������
    IN inComment         TVarChar,      --
    IN inFax             TVarChar,
    IN inPhone           TVarChar,
    IN inMobile          TVarChar,
    IN inIBAN            TVarChar,
    IN inStreet          TVarChar,
    IN inStreet_add      TVarChar,
    IN inMember          TVarChar,
    IN inWWW             TVarChar,
    IN inEmail           TVarChar,
    IN inCodeDB          TVarChar,
    IN inTaxNumber       TVarChar,
    IN inPLZ             TVarChar,
    IN inCityName        TVarChar,
    IN inCountryName     TVarChar,
    IN inDiscountTax     TFloat ,
    IN inDayCalendar     TFloat ,
    IN inDayBank         TFloat ,
    IN inBankId          Integer ,
    --IN inPLZId           Integer ,
    IN inInfoMoneyId     Integer ,
    IN inTaxKindId       Integer ,
    IN inPaidKindId      Integer ,
    IN inSession         TVarChar       -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbCountryId Integer;
   DECLARE vbPLZId Integer;
   DECLARE vbIsCheck_not Boolean;
BEGIN
   vbIsCheck_not:=  zfConvert_StringToNumber (inSession) < 0;

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Partner());
   IF zfConvert_StringToNumber (inSession) < 0 THEN inSession:= (-1 * zfConvert_StringToNumber (inSession)) :: TVarChar; END IF;
   vbUserId:= lpGetUserBySession (inSession);

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:= lfGet_ObjectCode (ioCode, zc_Object_Partner());

   -- �������� ���� ������������ ��� �������� <������������ >
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Partner(), inName, vbUserId);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Partner(), vbCode_calc, inName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_Fax(), ioId, inFax);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_Phone(), ioId, inPhone);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_Mobile(), ioId, inMobile);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_IBAN(), ioId, inIBAN);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_Street(), ioId, inStreet);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_Street_add(), ioId, inStreet_add);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_Member(), ioId, inMember);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_WWW(), ioId, inWWW);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_Email(), ioId, inEmail);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_CodeDB(), ioId, inCodeDB);
   -- ��������� �������� <��������� �����>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_TaxNumber(), ioId, inTaxNumber);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_Comment(), ioId, inComment);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Partner_DiscountTax(), ioId, inDiscountTax);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Partner_DayCalendar(), ioId, inDayCalendar);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Partner_Bank(), ioId, inDayBank);

   -- ��������� �������� <>
   --PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_PLZ(), ioId, inPLZId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_Bank(), ioId, inBankId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_InfoMoney(), ioId, inInfoMoneyId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_TaxKind(), ioId, CASE WHEN inTaxKindId > 0 THEN inTaxKindId ELSE zc_Enum_TaxKind_Basis() END);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_PaidKind(), ioId, CASE WHEN inPaidKindId > 0 THEN inPaidKindId ELSE zc_Enum_PaidKind_FirstForm() END);


   IF vbIsCheck_not = FALSE
   THEN
       -- �������� <inCountryName>
       IF TRIM (COALESCE (inCountryName, '')) = ''
       THEN
           RAISE EXCEPTION '������.�������� <Country> ������ ���� �����������.';
       END IF;

       -- �������� <inCityName>
       IF TRIM (COALESCE (inCityName, '')) = ''
       THEN
           RAISE EXCEPTION '������.�������� <City> ������ ���� �����������.';
       END IF;

       -- �������� <inPLZ>
       IF TRIM (COALESCE (inPLZ, '')) = ''
       THEN
           RAISE EXCEPTION '������.�������� <PLZ> ������ ���� �����������.';
       END IF;
   END IF;


   -- inPLZId �������� �� ����� � ������, ����� ������� �������, ����� ��������, ���� ����� � ������ ��� � ����������� �������    ,
   -- ������
   vbCountryId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Country() AND TRIM(Object.ValueData) ILIKE TRIM(inCountryName) AND Object.isErased = FALSE);
   --
   IF COALESCE (vbCountryId, 0) = 0
   THEN
       IF (SELECT COUNT(*) FROM Object WHERE Object.DescId = zc_Object_Country() AND TRIM(Object.ValueData) ILIKE TRIM(inCountryName))
       THEN 
           RAISE EXCEPTION '������.� ����������� ������� ��������� �������� <%>.', TRIM(inCountryName);
       END IF;
       --
       vbCountryId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Country() AND TRIM(Object.ValueData) ILIKE TRIM(inCountryName)); 
      
       --���� �� ����� ������� ����� �� ��������� �������� 
       IF COALESCE (vbCountryId,0) = 0 
       THEN
           vbCountryId := (SELECT ObjectString.ObjectId
                           FROM ObjectString
                           WHERE ObjectString.DescId = zc_ObjectString_Country_ShortName()
                           AND UPPER(TRIM(ObjectString.ValueData))  ILIKE UPPER (TRIM(inCountryName))
                           );
       END IF;
       
   END IF;
   -- ���� �� ������� �������
   IF COALESCE (vbCountryId,0) = 0 AND TRIM (inCountryName) <> ''
   THEN  
        IF LENGTH (TRIM (inCountryName)) > 3 
        THEN
        vbCountryId := (SELECT tmp.ioId
                        FROM gpInsertUpdate_Object_Country (ioId        := 0         :: Integer
                                                          , ioCode      := 0         :: Integer
                                                          , inName      := TRIM(inCountryName) :: TVarChar
                                                          , inShortName := ''        :: TVarChar
                                                          , inSession   := inSession :: TVarChar
                                                           ) AS tmp); 
        ELSE
             RAISE EXCEPTION '������.������� �������� �������� ������ <%>.', TRIM(inCountryName);
        END IF;
   END IF;

   -- ������� �����  PLZId
   vbPLZId := (SELECT Object_PLZ.Id
               FROM Object AS Object_PLZ
                    INNER JOIN ObjectString AS ObjectString_City
                                            ON ObjectString_City.ObjectId = Object_PLZ.Id
                                           AND ObjectString_City.DescId = zc_ObjectString_PLZ_City()
                                           AND UPPER (TRIM (ObjectString_City.ValueData)) = UPPER (TRIM (inCityName))

                    INNER JOIN ObjectLink AS ObjectLink_Country
                                          ON ObjectLink_Country.ObjectId = Object_PLZ.Id
                                         AND ObjectLink_Country.DescId = zc_ObjectLink_PLZ_Country()
                                         AND COALESCE (ObjectLink_Country.ChildObjectId,0) = vbCountryId

               WHERE Object_PLZ.DescId = zc_Object_PLZ()
                 AND Object_PLZ.isErased = FALSE
                 AND TRIM (Object_PLZ.ValueData) ILIKE TRIM (inPLZ)
                );

   IF COALESCE (vbPLZId,0) = 0 AND TRIM (inCityName) <> ''
   THEN
        vbPLZId := (SELECT tmp.ioId
                    FROM gpInsertUpdate_Object_PLZ (ioId        := 0
                                                  , ioCode      := 0
                                                  , inName      := TRIM (inPLZ)
                                                  , inCity      := TRIM (inCityName) :: TVarChar
                                                  , inAreaCode  := ''        ::TVarChar
                                                  , inComment   := ''        ::TVarChar
                                                  , inCountryId := vbCountryId
                                                  , inSession   := inSession :: TVarChar
                                                   ) AS tmp
                   );
   END IF;

   -- ��������� �������� <PLZ �������� �����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_PLZ(), ioId, vbPLZId);



   IF vbIsInsert = TRUE THEN
      -- ��������� �������� <���� ��������>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- ��������� �������� <������������ (��������)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   END IF;
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.08.23         *
 17.06.21         *
 02.02.21         *
 09.11.20         *
 22.10.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Partner()
