-- Function: gpSelect_Object_ContractPrices_effie

DROP FUNCTION IF EXISTS gpSelect_Object_ContractPrices_effie ( TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractPrices_effie(
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (priceHeaderExtId      TVarChar   -- Идентификатор прайса
             , contractHeaderExtId   TVarChar   -- Идентификатор контракта
             , validFrom             TVarChar   -- Дата начала (минимальная дата 1753-01-01)
             , validTo               TVarChar   -- Дата окончания (максимальная дата 9999-12-31)
             , isDeleted             Boolean    -- Признак активности: false = активна / true = не активна. По умолчанию false = активна.
) AS

$BODY$
   DECLARE vbUserId Integer;
 BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
     WITH
     tmpContract AS (SELECT Object_Contract_View.ContractId
                          , Object_Contract_View.JuridicalId
                          , Object_Contract_View.StartDate
                          , Object_Contract_View.EndDate
                     FROM Object_Contract_View
                     WHERE Object_Contract_View.isErased = FALSE 
                       -- !!!ТОЛЬКО ГП!!!
                       AND Object_Contract_View.InfoMoneyId = zc_Enum_InfoMoney_30101() 
                       AND Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                       )
     
   , tmpContractPriceList AS (SELECT ObjectLink_ContractPriceList_PriceList.ChildObjectId  AS PriceListId
                                   , ObjectLink_ContractPriceList_Contract.ChildObjectId   AS ContractId
                                   , ObjectDate_StartDate.ValueData :: TDateTime AS StartDate
                                   , ObjectDate_EndDate.ValueData   :: TDateTime AS EndDate
                              FROM Object AS Object_ContractPriceList
                                   INNER JOIN ObjectLink AS ObjectLink_ContractPriceList_Contract
                                                         ON ObjectLink_ContractPriceList_Contract.ObjectId = Object_ContractPriceList.Id
                                                        AND ObjectLink_ContractPriceList_Contract.DescId = zc_ObjectLink_ContractPriceList_Contract()
                                   LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = ObjectLink_ContractPriceList_Contract.ChildObjectId
                                                   AND Object_Contract.isErased = FALSE

                                   LEFT JOIN ObjectLink AS ObjectLink_ContractPriceList_PriceList
                                                        ON ObjectLink_ContractPriceList_PriceList.ObjectId = Object_ContractPriceList.Id
                                                       AND ObjectLink_ContractPriceList_PriceList.DescId = zc_ObjectLink_ContractPriceList_PriceList()
                                   INNER JOIN Object AS Object_PriceList ON Object_PriceList.Id = ObjectLink_ContractPriceList_PriceList.ChildObjectId
                                                    AND Object_PriceList.isErased = FALSE  

                                   LEFT JOIN ObjectDate AS ObjectDate_StartDate
                                                        ON ObjectDate_StartDate.ObjectId = Object_ContractPriceList.Id
                                                       AND ObjectDate_StartDate.DescId = zc_ObjectDate_ContractPriceList_StartDate()
                                   LEFT JOIN ObjectDate AS ObjectDate_EndDate
                                                        ON ObjectDate_EndDate.ObjectId = Object_ContractPriceList.Id
                                                       AND ObjectDate_EndDate.DescId = zc_ObjectDate_ContractPriceList_EndDate()

                              WHERE Object_ContractPriceList.DescId = zc_Object_ContractPriceList()
                                AND Object_ContractPriceList.isErased = FALSE
                              )

     SELECT tmp.PriceListId         ::TVarChar AS priceHeaderExtId
          , tmp.ContractId          ::TVarChar AS contractHeaderExtId
          , tmp.StartDate           ::TVarChar AS validFrom
          , tmp.EndDate             ::TVarChar AS validTo
          , FALSE                   ::Boolean  AS isDeleted
     FROM tmpContractPriceList AS tmp
   UNION
     SELECT ObjectLink_Juridical_PriceList.ChildObjectId   ::TVarChar AS priceHeaderExtId
          , tmpContract.ContractId                         ::TVarChar AS contractHeaderExtId
          , tmpContract.StartDate                          ::TVarChar AS validFrom
          , tmpContract.EndDate                            ::TVarChar AS validTo
          , FALSE                                          ::Boolean  AS isDeleted
     FROM tmpContract
        LEFT JOIN tmpContractPriceList ON tmpContractPriceList.ContractId = tmpContract.ContractId
         
        LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                             ON ObjectLink_Juridical_PriceList.ObjectId = tmpContract.JuridicalId
                            AND ObjectLink_Juridical_PriceList.DescId = zc_ObjectLink_Juridical_PriceList()
        INNER JOIN Object AS Object_PriceList ON Object_PriceList.Id = ObjectLink_Juridical_PriceList.ChildObjectId
                         AND Object_PriceList.isErased = FALSE
     WHERE tmpContractPriceList.ContractId IS NULL
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.03.26         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ContractPrices_effie (zfCalc_UserAdmin()::TVarChar);


/*

 1) zc_Object_ContractPriceList 2) union остальные договора gpSelect_Object_ContractHeaders_effie - по ним zc_ObjectLink_Juridical_PriceList

*/