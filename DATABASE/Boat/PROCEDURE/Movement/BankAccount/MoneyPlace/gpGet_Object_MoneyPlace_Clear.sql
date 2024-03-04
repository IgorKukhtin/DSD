--
DROP FUNCTION IF EXISTS gpGet_Object_MoneyPlace_Clear (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_MoneyPlace_Clear(
    IN inMovementId       Integer,       -- ключ объекта <>
   OUT outId              Integer,
   OUT outCode            Integer,       --
   OUT outName            TVarChar,      --
   OUT outIBAN            TVarChar,
   OUT outStreet          TVarChar,
   OUT outStreet_add      TVarChar,
   OUT outTaxNumber       TVarChar,
   OUT outPLZ             TVarChar,
   OUT outCityName        TVarChar,
   OUT outCountryName     TVarChar,
   OUT outTaxKindId       Integer ,
   OUT outTaxKindName     TVarChar,
   OUT outInfoMoneyId     Integer,
   OUT outInfoMoneyName   TVarChar,
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Client());
   vbUserId:= lpGetUserBySession (inSession);


   SELECT 0  ::Integer  AS Id
        , 0  ::Integer  AS Code
        , MovementString_7.ValueData   ::TVarChar AS Name
        , MovementString_8.ValueData   ::TVarChar AS IBAN
        , '' ::TVarChar AS Street
        , '' ::TVarChar AS Street_add
        , '' ::TVarChar AS TaxNumber
        , '' ::TVarChar AS PLZ
        , '' ::TVarChar AS CityName
        , '' ::TVarChar AS CountryName
        , 0  ::Integer  AS TaxKindId
        , '' ::TVarChar AS TaxKindName  
        , 0  ::Integer  AS InfoMoneyId
        , '' ::TVarChar AS InfoMoneyName

  INTO outId, outCode, outName, outIBAN, outStreet, outStreet_add, outTaxNumber, outPLZ, outCityName, outCountryName, outTaxKindId, outTaxKindName, outInfoMoneyId, outInfoMoneyName


   FROM MovementString AS MovementString_7
        LEFT JOIN MovementString AS MovementString_8
                                 ON MovementString_8.MovementId = MovementString_7.MovementId
                                AND MovementString_8.DescId = zc_MovementString_8()
   WHERE MovementString_7.MovementId = inMovementId
     AND MovementString_7.DescId = zc_MovementString_7()
   ;

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
--SELECT * FROM gpGet_Object_MoneyPlace_Clear(2242, '5')
