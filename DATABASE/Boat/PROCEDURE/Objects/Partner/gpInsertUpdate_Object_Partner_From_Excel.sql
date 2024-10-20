--
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner_From_Excel (Integer
                                                                , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                                , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                                , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                                , TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Partner_From_Excel(
    IN inCode            Integer,       -- �������� <���>
    IN inName            TVarChar,      -- ������� ��������
    IN inName2           TVarChar,
    IN inName3           TVarChar,
    IN inStreet          TVarChar,
    IN inShortName       TVarChar,
    IN inCity            TVarChar,
    IN inFax             TVarChar,
    IN inPhone           TVarChar,
    IN inMobile          TVarChar,
    IN inIBAN            TVarChar,
    IN inBankName        TVarChar,
    IN inMember          TVarChar,
    IN inWWW             TVarChar,
    IN inEmail           TVarChar,
    IN inCodeDB          TVarChar,
    IN inPLZ             TVarChar,
    IN inSession         TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbBankId Integer;   
   DECLARE vbPartnerId Integer;
   DECLARE vbPLZId Integer;
   DECLARE vbCountryId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Partner());
   vbUserId:= lpGetUserBySession (inSession);

   IF COALESCE (inCode, 0) <> 0 OR COALESCE (inName, '') <> ''
   THEN
       -- ������� ����� ��������
       IF COALESCE (inCode, 0) <> 0
       THEN
           vbPartnerId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Partner() AND Object.ObjectCode = inCode);
       END IF;
       -- ���� �� ����� �� ���� ������� �� ������������
       /*IF COALESCE (vbPartnerId,0) = 0 AND COALESCE (inName, '') <> ''
       THEN
           vbPartnerId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Partner() AND TRIM (Object.ValueData) Like TRIM (TRIM (inName)||' '||TRIM (inName2)||' '||TRIM (inName3)) );
       END IF;
       */
   ELSE
       RETURN;
   END IF;

   
/*   inName := REPLACE (REPLACE (REPLACE (REPLACE(inName, 'o','$') , 'a','$'), 'u','$'), '?','$');
   inName2 := REPLACE (REPLACE (REPLACE (REPLACE(inName2, 'o','$') , 'a','$'), 'u','$'), '?','$');
   inName3 := REPLACE (REPLACE (REPLACE (REPLACE(inName3, 'o','$') , 'a','$'), 'u','$'), '?','$');
   inStreet := REPLACE (REPLACE (REPLACE (REPLACE(inStreet, 'o','$') , 'a','$'), 'u','$'), '?','$');
   inCity := REPLACE (REPLACE (REPLACE (REPLACE(inCity, 'o','$') , 'a','$'), 'u','$'), '?','$');
   inMember := REPLACE (REPLACE (REPLACE (REPLACE(inMember, 'o','$') , 'a','$'), 'u','$'), '?','$');
  */ 
   IF COALESCE (inBankName, '') <> ''
   THEN
       -- ������� ����� ����
       vbBankId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Bank() AND TRIM (Object.ValueData) Like TRIM (inBankName));
       --���� ��� ������ ����� �������
       IF COALESCE (vbBankId,0) = 0
       THEN
            vbBankId := (SELECT tmp.ioId
                        FROM gpInsertUpdate_Object_Bank(ioId      := 0          :: Integer
                                                      , inCode    := 0          :: Integer
                                                      , inName    := inBankName :: TVarChar
                                                      , inIBAN    := ''         :: TVarChar
                                                      , inComment := ''         :: TVarChar
                                                      , inSession := inSession  :: TVarChar) AS tmp);
       END IF;
   END IF;
 
   IF COALESCE (inShortName,'') <> ''
   THEN
       vbCountryId = (SELECT Object_Country.Id 
                      FROM Object AS Object_Country
                           INNER JOIN ObjectString AS ObjectString_ShortName
                                                   ON ObjectString_ShortName.ObjectId = Object_Country.Id
                                                  AND ObjectString_ShortName.DescId = zc_ObjectString_Country_ShortName()
                                                  AND TRIM (ObjectString_ShortName.ValueData) = TRIM (inShortName)
                      WHERE Object_Country.DescId = zc_Object_Country());
       IF COALESCE (vbCountryId,0) = 0
       THEN
           vbCountryId := (SELECT tmp.ioId
                          FROM gpInsertUpdate_Object_Country(ioId          := 0 ::Integer
                                                           , ioCode        := 0 ::Integer
                                                           , inName        := TRIM (inShortName) :: TVarChar
                                                           , inShortName   := TRIM (inShortName) :: TVarChar
                                                           , inSession     := inSession) AS tmp);
       END IF;
   END IF;

   IF COALESCE (inPLZ,'') <> ''
   THEN
       vbPLZId := (SELECT Object_PLZ.Id
                   FROM Object AS Object_PLZ
                        INNER JOIN ObjectString AS ObjectString_City
                                                ON ObjectString_City.ObjectId = Object_PLZ.Id
                                               AND ObjectString_City.DescId = zc_ObjectString_PLZ_City()
                                               AND TRIM (ObjectString_City.ValueData) = TRIM (inCity)
                        LEFT JOIN ObjectLink AS ObjectLink_Country
                                             ON ObjectLink_Country.ObjectId = Object_PLZ.Id
                                            AND ObjectLink_Country.DescId = zc_ObjectLink_PLZ_Country()
                   WHERE Object_PLZ.DescId = zc_Object_PLZ() 
                     AND TRIM (Object_PLZ.ValueData) ILIKE TRIM (inPLZ)
                     AND COALESCE (ObjectLink_Country.ChildObjectId,0) = COALESCE (vbCountryId,0)
                   );

       IF COALESCE (vbPLZId,0) = 0
       THEN
           vbPLZId := (SELECT tmp.ioId
                      FROM gpInsertUpdate_Object_PLZ(ioId        := 0             :: Integer
                                                   , ioCode      := 0             :: Integer
                                                   , inName      := TRIM (inPLZ)  :: TVarChar
                                                   , inCity      := TRIM (inCity) :: TVarChar
                                                   , inAreaCode  := ''            :: TVarChar
                                                   , inComment   := ''            :: TVarChar
                                                   , inCountryId :=  COALESCE (vbCountryId,0) :: Integer
                                                   , inSession   := inSession     ::TVarChar) AS tmp);
       END IF;
   END IF;
   
   IF COALESCE (vbPartnerId,0) = 0
   THEN
       -- �������
       PERFORM gpInsertUpdate_Object_Partner(ioId       := 0               :: Integer
                                           , ioCode     := inCode          :: Integer
                                           , inName     := TRIM (TRIM (inName)||' '||TRIM (inName2)||' '||TRIM (inName3)) :: TVarChar
                                           , inComment  := inCode          :: TVarChar
                                           , inFax      := TRIM (inFax)    :: TVarChar
                                           , inPhone    := TRIM (inPhone)  :: TVarChar
                                           , inMobile   := TRIM (inMobile) :: TVarChar
                                           , inIBAN     := TRIM (inIBAN)   :: TVarChar
                                           , inStreet   := TRIM (inStreet) :: TVarChar
                                           , inStreet_add := ''            :: TVarChar
                                           , inMember   := TRIM (inMember) :: TVarChar
                                           , inWWW      := TRIM (inWWW)    :: TVarChar
                                           , inEmail    := TRIM (inEmail)  :: TVarChar
                                           , inCodeDB   := TRIM (inCodeDB) :: TVarChar
                                           , inTaxNumber    := ''
                                           , inDiscountTax  := 0
                                           , inDayCalendar  := 3
                                           , inDayBank      := 3
                                           , inBankId   := COALESCE (vbBankId,0) :: Integer  
                                           , inPLZId    := COALESCE (vbPLZId,0)  :: Integer 
                                           , inInfoMoneyId:= zc_Enum_InfoMoney_10101()
                                           , inTaxKindId  := zc_Enum_TaxKind_Basis() -- 19.0%
                                           , inPaidKindId := zc_Enum_PaidKind_FirstForm() ::Integer
                                           , inSession  := inSession       :: TVarChar
                                            );
   ELSE
       IF EXISTS (SELECT 1 FROM Object WHERE Object.Id = vbPartnerId AND Object.isErased = TRUE)
       THEN
           PERFORM lpUpdate_Object_isErased (inObjectId:= vbPartnerId
                                           , inIsErased:= FALSE
                                           , inUserId  := vbUserId
                                            );
       END IF;

       -- ��������� ������
       PERFORM gpInsertUpdate_Object_Partner(ioId       := tmp.Id
                                           , ioCode     := tmp.Code
                                           , inName     := TRIM (TRIM (inName)||' '||TRIM (inName2)||' '||TRIM (inName3))
                                           , inComment  := tmp.Comment
                                           , inFax      := TRIM (inFax)
                                           , inPhone    := TRIM (inPhone)
                                           , inMobile   := TRIM (inMobile)
                                           , inIBAN     := TRIM (inIBAN)
                                           , inStreet   := TRIM (inStreet)
                                           , inStreet_add:= TRIM (tmp.Street_add)
                                           , inMember   := TRIM (inMember)
                                           , inWWW      := TRIM (inWWW)
                                           , inEmail    := TRIM (inEmail)
                                           , inCodeDB   := TRIM (inCodeDB)
                                           , inTaxNumber    := COALESCE (tmp.TaxNumber, '')
                                           , inDiscountTax  := COALESCE (tmp.DiscountTax, 0)
                                           , inDayCalendar  := COALESCE (tmp.DayCalendar, 3)
                                           , inDayBank      := COALESCE (tmp.DayBank, 3)
                                           , inBankId       := vbBankId
                                           , inPLZId        := vbPLZId
                                           , inInfoMoneyId  := COALESCE (tmp.InfoMoneyId, zc_Enum_InfoMoney_10101())
                                           , inTaxKindId    := COALESCE (tmp.TaxKindId, zc_Enum_TaxKind_Basis())
                                           , inPaidKindId   := COALESCE (tmp.PaidKindId, zc_Enum_PaidKind_FirstForm() ::Integer) 
                                           , inSession      := inSession :: TVarChar
                                            )
       FROM gpSelect_Object_Partner (TRUE, inSession) AS tmp
       WHERE tmp.Id = vbPartnerId;
   END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.11.23         *
 17.06.21         *
 09.11.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Partner_From_Excel()


/*
select * from gpInsertUpdate_Object_Partner_From_Excel
(inCode := 47 ::Integer, 
inName := 'KOLIBRI Boat manufacturin' :: TVarChar , 
inName2 := ''  :: TVarChar, 
inName3 := ''  :: TVarChar, 
inStreet := 'A.  4, K. Gordienka' :: TVarChar , 
inShortName := 'UA'  :: TVarChar, 
inCity := 'Dnipro'  :: TVarChar, 
inFax := ''  :: TVarChar, 
inPhone := '+38 (056) 375-37-76' :: TVarChar, 
inMobile := ''  :: TVarChar, 
inIBAN := ''  :: TVarChar, 
inBankName := ''  :: TVarChar, 
inMember := ''  :: TVarChar, 
inWWW := ''  :: TVarChar, 
inEmail := 'star@kolibriboats.com.ua' :: TVarChar , 
inCodeDB := ''  :: TVarChar, 
inPLZ := '49000'  :: TVarChar,  
inSession := '5' :: TVarChar);

select * from gpInsertUpdate_Object_Partner_From_Excel(inCode := 38 , inName := 'Wilks Mfgs. Co. Ltd':: TVarChar , inName2 := '' :: TVarChar, inName3 := '':: TVarChar , inStreet := 'Woodrolfe Road,':: TVarChar , inShortName := 'UK' :: TVarChar
, inCity := 'Tollesbury, Maldon, Essex' :: TVarChar, inFax := '' :: TVarChar, inPhone := '+44 (0) 1621 869609' :: TVarChar, inMobile := '+44 (0) 7834 551 916' :: TVarChar
, inIBAN := '' :: TVarChar, inBankName := '':: TVarChar , inMember := 'Jeff Webber' :: TVarChar, inWWW := 'www.wilks.co.uk':: TVarChar , inEmail := 'Jeff@wilks.co.uk' :: TVarChar
, inCodeDB := '' :: TVarChar, inPLZ := 'CM98RY':: TVarChar ,  inSession := '5':: TVarChar);

*/
