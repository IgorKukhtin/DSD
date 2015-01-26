-- Function: gpGet_Scale_Partner()

DROP FUNCTION IF EXISTS gpGet_Scale_Partner (TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Scale_Partner(
    IN inOperDate    TDateTime   ,
    IN inPartnerCode Integer     ,
    IN inSession     TVarChar      -- сессия пользователя
)
RETURNS TABLE (PartnerId    Integer
             , PartnerCode  Integer
             , PartnerName  TVarChar
             , PaidKindId   Integer
             , PaidKindName TVarChar

             , PriceListId  Integer, PriceListCode  Integer, PriceListName TVarChar
             , ContractId   Integer, ContractCode   Integer, ContractNumber TVarChar, ContractTagName TVarChar

             , ChangePercent TFloat
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpGetUserBySession (inSession);


    -- Результат
    RETURN QUERY
       WITH Object_Partner AS (SELECT Object_Partner.Id             AS PartnerId
                                    , Object_Partner.ObjectCode     AS PartnerCode
                                    , Object_Partner.ValueData      AS PartnerName
                                    , lfGet_Object_Partner_PriceList_record (Object_Partner.Id, inOperDate) AS PriceListId
                               FROM Object AS Object_Partner
                               WHERE Object_Partner.ObjectCode = inPartnerCode
                                 AND Object_Partner.DescId = zc_Object_Partner()
                              )

       SELECT Object_Partner.PartnerId
            , Object_Partner.PartnerCode
            , Object_Partner.PartnerName
            , Object_PaidKind.Id                             AS PaidKindId
            , Object_PaidKind.ValueData                      AS PaidKindName

            , Object_PriceList.Id                            AS PriceListId
            , Object_PriceList.ObjectCode                    AS PriceListCode
            , Object_PriceList.ValueData                     AS PriceListName
            , Object_Contract_View.ContractId                AS ContractId
            , Object_Contract_View.ContractCode              AS ContractCode
            , Object_Contract_View.InvNumber                 AS ContractNumber
            , Object_Contract_View.ContractTagName           AS ContractTagName

            , CASE WHEN Object_Partner.PartnerCode = 1 THEN 1.5 WHEN Object_Partner.PartnerCode = 3 THEN 0 ELSE 1 END :: TFloat AS ChangePercent

       FROM Object_Partner
            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = Object_Partner.PriceListId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.PartnerId
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN Object_Contract_View ON Object_Contract_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                                          AND Object_Contract_View.InfoMoneyId = zc_Enum_InfoMoney_30101()
                                          AND Object_Contract_View.isErased = FALSE
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Object_Contract_View.PaidKindId
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Scale_Partner (TDateTime, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 21.01.15                                        *
*/

-- тест
-- SELECT * FROM gpGet_Scale_Partner ('01.01.2015', '0', zfCalc_UserAdmin())
