--
DROP FUNCTION IF EXISTS gpUpdate_Object_MoneyPlace (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_MoneyPlace (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_MoneyPlace(
    IN inId              Integer,       -- ключ объекта <Бренд>
    IN inCode            Integer,       -- свойство <Код Бренда>
    IN inName            TVarChar,      -- главное Название Бренда
    IN inIBAN            TVarChar,
    IN inStreet          TVarChar,
    IN inStreet_add      TVarChar,
    IN inTaxNumber       TVarChar, 
    IN inPLZ             TVarChar,
    IN inCityName        TVarChar,
    IN inCountryName     TVarChar,
    IN inTaxKindId       Integer ,
    IN inInfoMoneyId     Integer ,
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbDescId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Client());
   vbUserId:= lpGetUserBySession (inSession);

   -- проверка
   IF COALESCE (inId,0) = 0
   THEN 
       RAISE EXCEPTION 'Ошибка.Элемент справочника еще не сохранен.%Для сохранения изменений выберите кнопку <Сохранить>'
                      , CHR (13)
                       ;
   END IF;
   
   --определяем в какой справочник обновлять информацию 
   vbDescId := (SELECT Object.DescId FROM Object WHERE Object.Id = inId);

   IF vbDescId = zc_Object_Partner()
   THEN 
        --
        PERFORM gpInsertUpdate_Object_Partner(ioId           := inId                 :: Integer
                                            , ioCode         := inCode               :: Integer
                                            , inName         := TRIM (inName)        :: TVarChar
                                            , inComment      := tmp.Comment          :: TVarChar
                                            , inFax          := tmp.Fax              :: TVarChar
                                            , inPhone        := tmp.Phone            :: TVarChar
                                            , inMobile       := tmp.Mobile           :: TVarChar
                                            , inIBAN         := TRIM (inIBAN)        :: TVarChar
                                            , inStreet       := TRIM (inStreet)      :: TVarChar
                                            , inStreet_add   := TRIM (inStreet_add)  :: TVarChar
                                            , inMember       := tmp.Member           :: TVarChar
                                            , inWWW          := tmp.WWW              :: TVarChar
                                            , inEmail        := tmp.Email            :: TVarChar
                                            , inCodeDB       := tmp.CodeDB           :: TVarChar
                                            , inTaxNumber    := TRIM (inTaxNumber)   :: TVarChar
                                            , inPLZ          := TRIM (inPLZ)         :: TVarChar
                                            , inCityName     := TRIM (inCityName)    :: TVarChar
                                            , inCountryName  := TRIM (inCountryName) :: TVarChar
                                            , inDiscountTax  := tmp.DiscountTax      :: TFloat
                                            , inDayCalendar  := tmp.DayCalendar      :: TFloat
                                            , inDayBank      := tmp.DayBank          :: TFloat
                                            , inBankId       := tmp.BankId           :: Integer  
                                            , inInfoMoneyId  := COALESCE (tmp.InfoMoneyId, zc_Enum_InfoMoney_10101())  ::Integer
                                            , inTaxKindId    := COALESCE (inTaxKindId, zc_Enum_TaxKind_Basis())        ::Integer -- 19.0%
                                            , inPaidKindId   := COALESCE (tmp.PaidKindId, zc_Enum_PaidKind_FirstForm()) ::Integer
                                            , inSession      := inSession       :: TVarChar
                                             )    
        FROM gpGet_Object_Partner (inId, inSession) AS tmp;
   END IF; 
   
   --
   IF vbDescId = zc_Object_Client()
   THEN 
        --
        PERFORM gpInsertUpdate_Object_Client(ioId           := inId                 :: Integer
                                           , ioCode         := inCode               :: Integer
                                           , inName         := TRIM (inName)        :: TVarChar
                                           , inComment      := tmp.Comment          :: TVarChar
                                           , inFax          := tmp.Fax              :: TVarChar
                                           , inPhone        := tmp.Phone            :: TVarChar
                                           , inMobile       := tmp.Mobile           :: TVarChar
                                           , inIBAN         := TRIM (inIBAN)        :: TVarChar
                                           , inStreet       := TRIM (inStreet)      :: TVarChar
                                           , inStreet_add   := TRIM (inStreet_add)  :: TVarChar
                                           , inMember       := tmp.Member           :: TVarChar
                                           , inWWW          := tmp.WWW              :: TVarChar
                                           , inEmail        := tmp.Email            :: TVarChar
                                           , inCodeDB       := tmp.CodeDB           :: TVarChar
                                           , inTaxNumber    := TRIM (inTaxNumber)   :: TVarChar
                                           , inPLZ          := TRIM (inPLZ)         :: TVarChar
                                           , inCityName     := TRIM (inCityName)    :: TVarChar
                                           , inCountryName  := TRIM (inCountryName) :: TVarChar
                                           , inDiscountTax  := tmp.DiscountTax      :: TFloat
                                           , inDayCalendar  := tmp.DayCalendar      :: TFloat
                                           , inDayBank      := tmp.DayBank          :: TFloat
                                           , inBankId       := tmp.BankId           :: Integer  
                                           , inInfoMoneyId  := COALESCE (tmp.InfoMoneyId, zc_Enum_InfoMoney_10101())  ::Integer
                                           , inTaxKindId    := COALESCE (inTaxKindId, zc_Enum_TaxKind_Basis())        ::Integer -- 19.0%
                                           , inPaidKindId   := COALESCE (tmp.PaidKindId, zc_Enum_PaidKind_FirstForm()) ::Integer
                                           , inSession      := inSession       :: TVarChar
                                           )    
        FROM gpGet_Object_Client (inId, inSession) AS tmp;
   END IF; 
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.02.24         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Client()
