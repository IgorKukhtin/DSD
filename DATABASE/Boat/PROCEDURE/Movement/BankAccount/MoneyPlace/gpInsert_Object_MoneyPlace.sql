--
DROP FUNCTION IF EXISTS gpInsert_Object_MoneyPlace (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Object_MoneyPlace(
    INOUT ioId              Integer,       -- ���� ������� <�����>
    INOUT ioCode            Integer,       -- �������� <��� ������>
    INOUT ioName            TVarChar,      -- ������� �������� ������
    INOUT ioIBAN            TVarChar,
    INOUT ioStreet          TVarChar,
    INOUT ioStreet_add      TVarChar,
    INOUT ioTaxNumber       TVarChar, 
    INOUT ioPLZ             TVarChar,
    INOUT ioCityName        TVarChar,
    INOUT ioCountryName     TVarChar,
    INOUT ioTaxKindId       Integer ,
       IN inAmountIn        TFloat  ,
       IN inAmountOut       TFloat  ,
       IN inSession         TVarChar       -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbDescId Integer;
   DECLARE vbObjectId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Client());
   vbUserId:= lpGetUserBySession (inSession);

   --��������
   IF COALESCE (ioId,0) <> 0
   THEN 
       RAISE EXCEPTION '������.������� ��� ��������. ��� ������ ������ ������� <��������>';
   END IF;
    
   --���������� � ����� ���������� ��������� ���������� 
   vbDescId := (CASE WHEN COALESCE (inAmountIn,0) <> 0  THEN zc_Object_Client() 
                     WHEN COALESCE (inAmountOut,0) <> 0 THEN zc_Object_Partner()
                END);
    
   --����� �� �������� 
   vbObjectId := (SELECT Object.Id
                  FROM Object
                  WHERE Object.DescId IN (zc_Object_Client(), zc_Object_Partner())
                     AND UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioName))
                  );
   --����� ��TaxNumber
   IF COALESCE (vbObjectId,0) = 0
   THEN    
       --
       vbObjectId := (SELECT Object.Id
                      FROM Object
                           INNER JOIN ObjectString AS ObjectString_TaxNumber
                                                   ON ObjectString_TaxNumber.ObjectId = Object.Id
                                                  AND ObjectString_TaxNumber.DescId IN (zc_ObjectString_Partner_TaxNumber(), zc_ObjectString_Client_TaxNumber())
                                                  AND ObjectString_TaxNumber.ValueData = TRIM (ioTaxNumber)
                      WHERE Object.DescId IN (zc_Object_Client(), zc_Object_Partner())
                         AND UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (ioName))
                      );
   END IF;

   --���� ����� ���������� ����������� ��������
   IF COALESCE (vbObjectId,0) <> 0
   THEN
       SELECT tmp.Id
            , tmp.Code               :: Integer
            , TRIM (tmp.Name)        :: TVarChar
            , TRIM (tmp.IBAN)        :: TVarChar
            , TRIM (tmp.Street)      :: TVarChar
            , TRIM (tmp.Street_add)  :: TVarChar
            , TRIM (tmp.TaxNumber)   :: TVarChar
            , TRIM (tmp.PLZName)     :: TVarChar
            , TRIM (tmp.CityName)    :: TVarChar
            , TRIM (tmp.CountryName) :: TVarChar
            , COALESCE (tmp.TaxKindId, zc_Enum_TaxKind_Basis())::Integer -- 19.0%
      INTO ioId, ioCode, ioName, ioIBAN, ioStreet, ioStreet_add, ioTaxNumber, ioPLZ, ioCityName, ioCountryName, ioTaxKindId
        FROM gpGet_Object_MoneyPlace (0, vbObjectId, inSession) AS tmp
       ;
      RETURN; 
   END IF;


   IF vbDescId = zc_Object_Partner()
   THEN 
        --
       SELECT tmp.ioId
     INTO ioId
       FROM gpInsertUpdate_Object_Partner(ioId           := 0                    :: Integer
                                        , ioCode         := ioCode               :: Integer
                                        , inName         := TRIM (ioName)        :: TVarChar
                                        , inComment      := ''                   :: TVarChar
                                        , inFax          := ''                   :: TVarChar
                                        , inPhone        := ''                   :: TVarChar
                                        , inMobile       := ''                   :: TVarChar
                                        , inIBAN         := TRIM (ioIBAN)        :: TVarChar
                                        , inStreet       := TRIM (ioStreet)      :: TVarChar
                                        , inStreet_add   := TRIM (ioStreet_add)  :: TVarChar
                                        , inMember       := ''                   :: TVarChar
                                        , inWWW          := ''                   :: TVarChar
                                        , inEmail        := ''                   :: TVarChar
                                        , inCodeDB       := ''                   :: TVarChar
                                        , inTaxNumber    := TRIM (ioTaxNumber)   :: TVarChar
                                        , inPLZ          := TRIM (ioPLZ)         :: TVarChar
                                        , inCityName     := TRIM (ioCityName)    :: TVarChar
                                        , inCountryName  := TRIM (ioCountryName) :: TVarChar
                                        , inDiscountTax  := 0                    :: TFloat
                                        , inDayCalendar  := 0                    :: TFloat
                                        , inDayBank      := 0                    :: TFloat
                                        , inBankId       := 0                    :: Integer  
                                        , inInfoMoneyId  := zc_Enum_InfoMoney_10101()  ::Integer
                                        , inTaxKindId    := COALESCE (ioTaxKindId, zc_Enum_TaxKind_Basis())::Integer -- 19.0%
                                        , inPaidKindId   := zc_Enum_PaidKind_FirstForm() ::Integer
                                        , inSession      := inSession       :: TVarChar
                                         ) AS tmp;
   END IF; 
   
   --
   IF vbDescId = zc_Object_Client()
   THEN 
        --
        SELECT tmp.ioId
      INTO ioId
        FROM gpInsertUpdate_Object_Client(ioId           := 0                    :: Integer
                                        , ioCode         := inCode               :: Integer
                                        , inName         := TRIM (ioName)        :: TVarChar
                                        , inComment      := ''                   :: TVarChar
                                        , inFax          := ''                   :: TVarChar
                                        , inPhone        := ''                   :: TVarChar
                                        , inMobile       := ''                   :: TVarChar
                                        , inIBAN         := TRIM (inIBAN)        :: TVarChar
                                        , inStreet       := TRIM (inStreet)      :: TVarChar
                                        , inStreet_add   := TRIM (inStreet_add)  :: TVarChar
                                        , inMember       := ''                   :: TVarChar
                                        , inWWW          := ''                   :: TVarChar
                                        , inEmail        := ''                   :: TVarChar
                                        , inCodeDB       := ''                   :: TVarChar
                                        , inTaxNumber    := TRIM (inTaxNumber)   :: TVarChar
                                        , inPLZ          := TRIM (inPLZ)         :: TVarChar
                                        , inCityName     := TRIM (inCityName)    :: TVarChar
                                        , inCountryName  := TRIM (inCountryName) :: TVarChar
                                        , inDiscountTax  := 0                    :: TFloat
                                        , inDayCalendar  := 0                    :: TFloat
                                        , inDayBank      := 0                    :: TFloat
                                        , inBankId       := 0                    :: Integer  
                                        , inInfoMoneyId  := zc_Enum_InfoMoney_10101()  ::Integer
                                        , inTaxKindId    := COALESCE (inTaxKindId, zc_Enum_TaxKind_Basis())::Integer -- 19.0%
                                        , inPaidKindId   := zc_Enum_PaidKind_FirstForm() ::Integer
                                        , inSession      := inSession       :: TVarChar
                                        ) AS tmp;
   END IF; 
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.02.24         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Client()

select * from gpInsert_Object_MoneyPlace(ioid := 0 , ioCode := 0 , ioName := 'PAYONE GmbH' , ioIBAN := 'DE82300500000001685817' , ioStreet := '' , ioStreet_add := '' , ioTaxNumber := '' , ioPLZ := '26723' , ioCityName := 'Emden' , ioCountryName := 'Germany' , ioTaxKindId := 39396 , inAmountIn := 0 , inAmountOut := 23.8 ,  inSession := '5');