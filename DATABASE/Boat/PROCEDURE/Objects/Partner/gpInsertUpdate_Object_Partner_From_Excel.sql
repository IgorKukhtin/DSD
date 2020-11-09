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

   -- ������� ����� ��������
   IF COALESCE (inName, '') <> ''
   THEN
       vbPartnerId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Partner() AND TRIM (Object.ValueData) Like TRIM (TRIM (inName)||' '||TRIM (inName2)||' '||TRIM (inName3)) );
   ELSE
       RETURN;
   END IF;

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
                        INNER JOIN ObjectLink AS ObjectLink_Country
                                              ON ObjectLink_Country.ObjectId = Object_PLZ.Id
                                             AND ObjectLink_Country.DescId = zc_ObjectLink_PLZ_Country()
                                             AND COALESCE (ObjectLink_Country.ChildObjectId,0) = COALESCE (vbCountryId,0)
                   WHERE Object_PLZ.DescId = zc_Object_PLZ() 
                     AND TRIM (Object_PLZ.ValueData) Like TRIM (inPLZ));

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
                                           , ioCode     := 0               :: Integer
                                           , inName     := TRIM (TRIM (inName)||' '||TRIM (inName2)||' '||TRIM (inName3)) :: TVarChar
                                           , inComment  := inCode          :: TVarChar
                                           , inFax      := TRIM (inFax)    :: TVarChar
                                           , inPhone    := TRIM (inPhone)  :: TVarChar
                                           , inMobile   := TRIM (inMobile) :: TVarChar
                                           , inIBAN     := TRIM (inIBAN)   :: TVarChar
                                           , inStreet   := TRIM (inStreet) :: TVarChar
                                           , inMember   := TRIM (inMember) :: TVarChar
                                           , inWWW      := TRIM (inWWW)    :: TVarChar
                                           , inEmail    := TRIM (inEmail)  :: TVarChar
                                           , inCodeDB   := TRIM (inCodeDB) :: TVarChar
                                           , inBankId   := COALESCE (vbBankId,0) :: Integer  
                                           , inPLZId    := COALESCE (vbPLZId,0)  :: Integer 
                                           , inSession  := inSession       :: TVarChar);
   ELSE
       -- ��������� ������
       PERFORM gpInsertUpdate_Object_Partner(ioId       := tmp.Id          :: Integer
                                           , ioCode     := tmp.Code        :: Integer
                                           , inName     := tmp.Name        :: TVarChar
                                           , inComment  := tmp.Comment     :: TVarChar
                                           , inFax      := COALESCE (tmp.Fax,    TRIM (inFax))    :: TVarChar
                                           , inPhone    := COALESCE (tmp.Phone,  TRIM (inPhone))  :: TVarChar
                                           , inMobile   := COALESCE (tmp.Mobile, TRIM (inMobile)) :: TVarChar
                                           , inIBAN     := COALESCE (tmp.IBAN,   TRIM (inIBAN))   :: TVarChar
                                           , inStreet   := COALESCE (tmp.Street, TRIM (inStreet)) :: TVarChar
                                           , inMember   := COALESCE (tmp.Member, TRIM (inMember)) :: TVarChar
                                           , inWWW      := COALESCE (tmp.WWW,    TRIM (inWWW))    :: TVarChar
                                           , inEmail    := COALESCE (tmp.Email,  TRIM (inEmail))  :: TVarChar
                                           , inCodeDB   := COALESCE (tmp.CodeDB, TRIM (inCodeDB)) :: TVarChar
                                           , inBankId   := COALESCE (tmp.BankId, vbBankId)        :: Integer  
                                           , inPLZId    := COALESCE (tmp.PLZId, vbPLZId)          :: Integer 
                                           , inSession  := inSession                              :: TVarChar)
       FROM gpSelect_Object_Partner(FALSE, inSession) AS tmp
       WHERE tmp.Id = vbPartnerId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.11.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Partner_From_Excel()
