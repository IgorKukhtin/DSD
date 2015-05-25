-- Function: gpGet_Scale_Partner()

-- DROP FUNCTION IF EXISTS gpGet_Scale_Partner (TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Scale_Partner (TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Scale_Partner (TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Scale_Partner(
    IN inOperDate    TDateTime   ,
    IN inPartnerCode Integer     ,
    IN inInfoMoneyId Integer     ,
    IN inPaidKindId  Integer     ,
    IN inSession     TVarChar      -- сессия пользователя
)
RETURNS TABLE (PartnerId    Integer
             , PartnerCode  Integer
             , PartnerName  TVarChar
             , PaidKindId   Integer
             , PaidKindName TVarChar

             , PriceListId     Integer, PriceListCode     Integer, PriceListName     TVarChar
             , ContractId      Integer, ContractCode      Integer, ContractNumber    TVarChar, ContractTagName TVarChar
             , GoodsPropertyId Integer, GoodsPropertyCode Integer, GoodsPropertyName TVarChar

             , ChangePercent TFloat
             , ChangePercentAmount TFloat
             , isEdiOrdspr      Boolean
             , isEdiInvoice     Boolean
             , isEdiDesadv      Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpGetUserBySession (inSession);


    -- Результат
    RETURN QUERY
       WITH tmpPartner_find AS (SELECT Object_Partner.Id             AS PartnerId
                                     , Object_Partner.ObjectCode     AS PartnerCode
                                     , Object_Partner.ValueData      AS PartnerName
                                FROM Object AS Object_Partner
                                WHERE Object_Partner.ObjectCode = inPartnerCode
                                  AND Object_Partner.DescId = zc_Object_Partner()
                                  AND inPartnerCode > 0
                               UNION ALL
                                SELECT Object_Partner.Id             AS PartnerId
                                     , Object_Partner.ObjectCode     AS PartnerCode
                                     , Object_Partner.ValueData      AS PartnerName
                                FROM Object AS Object_Partner
                                WHERE Object_Partner.Id = -1 * inPartnerCode
                                  AND Object_Partner.DescId = zc_Object_Partner()
                                  AND inPartnerCode < 0
                               )
           , tmpPartnerContract AS (SELECT tmpPartner_find.PartnerId
                                         , tmpPartner_find.PartnerCode
                                         , tmpPartner_find.PartnerName
                                         , Object_Contract_View.ContractId
                                         , Object_Contract_View.ContractCode     AS ContractCode
                                         , Object_Contract_View.InvNumber        AS ContractNumber
                                         , Object_Contract_View.ContractTagName  AS ContractTagName
                                         , Object_Contract_View.PaidKindId       AS PaidKindId
                                         , ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                                    FROM tmpPartner_find
                                         LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                              ON ObjectLink_Partner_Juridical.ObjectId = tmpPartner_find.PartnerId
                                                             AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                         LEFT JOIN Object_Contract_View ON Object_Contract_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                                                                       AND Object_Contract_View.InfoMoneyId = inInfoMoneyId -- zc_Enum_InfoMoney_30101()
                                                                       AND Object_Contract_View.isErased = FALSE
                                                                       AND Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                    )
      , tmpPartnerContract_find AS (SELECT tmpPartnerContract.PartnerId
                                         , tmpPartnerContract.PartnerCode
                                         , tmpPartnerContract.PartnerName
                                         , tmpPartnerContract.ContractId
                                         , tmpPartnerContract.ContractCode
                                         , tmpPartnerContract.ContractNumber
                                         , tmpPartnerContract.ContractTagName
                                         , tmpPartnerContract.PaidKindId
                                         , tmpPartnerContract.JuridicalId
                                    FROM tmpPartnerContract
                                    WHERE tmpPartnerContract.PaidKindId = inPaidKindId
                                   UNION ALL
                                    SELECT tmpPartnerContract.PartnerId
                                         , tmpPartnerContract.PartnerCode
                                         , tmpPartnerContract.PartnerName
                                         , tmpPartnerContract.ContractId
                                         , tmpPartnerContract.ContractCode
                                         , tmpPartnerContract.ContractNumber
                                         , tmpPartnerContract.ContractTagName
                                         , tmpPartnerContract.PaidKindId
                                         , tmpPartnerContract.JuridicalId
                                    FROM tmpPartnerContract
                                         LEFT JOIN tmpPartnerContract AS tmpPartnerContract_two ON tmpPartnerContract_two.PaidKindId = inPaidKindId
                                    WHERE tmpPartnerContract_two.PaidKindId IS NULL
                                    )

       SELECT tmpPartner.PartnerId
            , tmpPartner.PartnerCode
            , tmpPartner.PartnerName
            , Object_PaidKind.Id                   AS PaidKindId
            , Object_PaidKind.ValueData            AS PaidKindName

            , Object_PriceList.Id                  AS PriceListId
            , Object_PriceList.ObjectCode          AS PriceListCode
            , Object_PriceList.ValueData           AS PriceListName
            , tmpPartner.ContractId                AS ContractId
            , tmpPartner.ContractCode              AS ContractCode
            , tmpPartner.ContractNumber            AS ContractNumber
            , tmpPartner.ContractTagName           AS ContractTagName

            , Object_GoodsProperty.Id              AS GoodsPropertyId
            , Object_GoodsProperty.ObjectCode      AS GoodsPropertyCode
            , Object_GoodsProperty.ValueData       AS GoodsPropertyName

            , Object_ContractCondition_PercentView.ChangePercent :: TFloat AS ChangePercent
            , CASE WHEN tmpPartner.PartnerCode = 1 THEN 1 WHEN tmpPartner.PartnerCode = 3 THEN 1 ELSE 1 END :: TFloat AS ChangePercentAmount

            , COALESCE (ObjectBoolean_Partner_EdiOrdspr.ValueData, FALSE)  :: Boolean AS isEdiOrdspr
            , COALESCE (ObjectBoolean_Partner_EdiInvoice.ValueData, FALSE) :: Boolean AS isEdiInvoice
            , COALESCE (ObjectBoolean_Partner_EdiDesadv.ValueData, FALSE)  :: Boolean AS isEdiDesadv

       FROM (SELECT tmpPartnerContract_find.PartnerId
                  , tmpPartnerContract_find.PartnerCode
                  , tmpPartnerContract_find.PartnerName
                  , tmpPartnerContract_find.ContractId
                  , tmpPartnerContract_find.ContractCode
                  , tmpPartnerContract_find.ContractNumber
                  , tmpPartnerContract_find.ContractTagName
                  , tmpPartnerContract_find.PaidKindId
                  , zfCalc_GoodsPropertyId (tmpPartnerContract_find.ContractId, tmpPartnerContract_find.JuridicalId) AS GoodsPropertyId
                  , lfGet_Object_Partner_PriceList_record (tmpPartnerContract_find.ContractId, tmpPartnerContract_find.PartnerId, inOperDate) AS PriceListId

             FROM tmpPartnerContract_find
            ) AS tmpPartner
            LEFT JOIN Object_ContractCondition_PercentView ON Object_ContractCondition_PercentView.ContractId = tmpPartner.ContractId
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpPartner.PaidKindId

            -- LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = tmpPartner.PriceListId
            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = tmpPartner.PriceListId

            LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = tmpPartner.GoodsPropertyId
                                                     
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Partner_EdiOrdspr
                                    ON ObjectBoolean_Partner_EdiOrdspr.ObjectId =  tmpPartner.PartnerId
                                   AND ObjectBoolean_Partner_EdiOrdspr.DescId = zc_ObjectBoolean_Partner_EdiOrdspr()
                                   AND 1=0 -- убрал, т.к. проверка по связи заявки с EDI
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Partner_EdiInvoice
                                    ON ObjectBoolean_Partner_EdiInvoice.ObjectId =  tmpPartner.PartnerId
                                   AND ObjectBoolean_Partner_EdiInvoice.DescId = zc_ObjectBoolean_Partner_EdiInvoice()
                                   AND 1=0 -- убрал, т.к. проверка по связи заявки с EDI
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Partner_EdiDesadv
                                    ON ObjectBoolean_Partner_EdiDesadv.ObjectId =  tmpPartner.PartnerId
                                   AND ObjectBoolean_Partner_EdiDesadv.DescId = zc_ObjectBoolean_Partner_EdiDesadv()
                                   AND 1=0 -- убрал, т.к. проверка по связи заявки с EDI
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
-- SELECT * FROM gpGet_Scale_Partner (inOperDate:= '01.01.2015', inPartnerCode:= '0', inPaidKindId:=0, inInfoMoneyId:= zc_Enum_InfoMoney_30101(), inSession:= zfCalc_UserAdmin())
