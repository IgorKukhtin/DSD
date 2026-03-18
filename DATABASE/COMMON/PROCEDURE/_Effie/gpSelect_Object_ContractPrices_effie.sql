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
             , PartnerId             Integer    --Контрагент инф.
             , defaultPrice          Boolean    --
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
   , tmpPartner AS (SELECT Object_Partner.*
                    FROM Object AS Object_Partner
                    WHERE Object_Partner.DescId = zc_Object_Partner()
                      AND Object_Partner.isErased = FALSE
                    )
     --прайс контрагента
   , tmpPartner_PriceList AS (SELECT ObjectLink_Partner_PriceList.ObjectId      AS PartnerId
                                   , ObjectLink_Partner_PriceList.ChildObjectId AS PriceListId
                                   , ObjectLink_Contract_Juridical.ObjectId     AS ContractId
                                   , TRUE                                       AS defaultPrice
                              FROM ObjectLink AS ObjectLink_Partner_PriceList
                                  INNER JOIN tmpPartner ON tmpPartner.Id = ObjectLink_Partner_PriceList.ObjectId

                                  -- нашли Юр.лицо
                                  INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                        ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_Partner_PriceList.ObjectId
                                                       AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()

                                  INNER JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                        ON ObjectLink_Contract_Juridical.ChildObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                       AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()

                                  INNER JOIN tmpContract ON tmpContract.ContractId = ObjectLink_Contract_Juridical.ObjectId

                              WHERE ObjectLink_Partner_PriceList.DescId = zc_ObjectLink_Partner_PriceList()
                                AND COALESCE (ObjectLink_Partner_PriceList.ChildObjectId,0) <> 0
                              )
                              
    -- прайсы из ContractPriceList для  
   , tmpContractPriceList AS (SELECT ObjectLink_ContractPartner_Partner.ChildObjectId      AS PartnerId
                                   , ObjectLink_ContractPriceList_PriceList.ChildObjectId  AS PriceListId
                                   , ObjectLink_ContractPriceList_Contract.ChildObjectId   AS ContractId
                                   , ObjectDate_StartDate.ValueData           :: TDateTime AS StartDate
                                   , ObjectDate_EndDate.ValueData             :: TDateTime AS EndDate            
                                   , FALSE                                                 AS defaultPrice
                              
                              FROM Object AS Object_ContractPriceList
                                   INNER JOIN ObjectLink AS ObjectLink_ContractPriceList_Contract
                                                         ON ObjectLink_ContractPriceList_Contract.ObjectId = Object_ContractPriceList.Id
                                                        AND ObjectLink_ContractPriceList_Contract.DescId = zc_ObjectLink_ContractPriceList_Contract()
                                   LEFT JOIN tmpContract ON tmpContract.ContractId = ObjectLink_ContractPriceList_Contract.ChildObjectId

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

                                   INNER JOIN ObjectLink AS ObjectLink_ContractPartner_Contract
                                                         ON ObjectLink_ContractPartner_Contract.ChildObjectId = ObjectLink_ContractPriceList_Contract.ChildObjectId
                                                        AND ObjectLink_ContractPartner_Contract.DescId = zc_ObjectLink_ContractPartner_Contract()
                                  
                                   INNER JOIN ObjectLink AS ObjectLink_ContractPartner_Partner
                                                         ON ObjectLink_ContractPartner_Partner.ObjectId = ObjectLink_ContractPartner_Contract.ObjectId
                                                        AND ObjectLink_ContractPartner_Partner.DescId = zc_ObjectLink_ContractPartner_Partner()
                                                        AND ObjectLink_ContractPartner_Partner.ChildObjectId NOT IN (SELECT DISTINCT tmpPartner_PriceList.PartnerId FROM tmpPartner_PriceList)
                                   INNER JOIN tmpPartner ON tmpPartner.Id = ObjectLink_ContractPartner_Partner.ChildObjectId

                              WHERE Object_ContractPriceList.DescId = zc_Object_ContractPriceList()
                                AND Object_ContractPriceList.isErased = FALSE
                                AND ObjectDate_StartDate.ValueData <= CURRENT_DATE
                                AND ObjectDate_EndDate.ValueData > CURRENT_DATE
                             )
 
   -- Остальные контргагенты и прайсы
   , tmpIts AS (SELECT tmp.PartnerId                                AS PartnerId
                     , ObjectLink_Juridical_PriceList.ChildObjectId AS PriceListId
                     , ObjectLink_Contract_Juridical.ObjectId       AS ContractId
                     , FALSE                                        AS defaultPrice
                FROM (SELECT tmpPartner.Id AS PartnerId
                      FROM tmpPartner
                          LEFT JOIN (SELECT DISTINCT tmpPartner_PriceList.PartnerId FROM tmpPartner_PriceList
                               UNION SELECT DISTINCT tmpContractPriceList.PartnerId FROM tmpContractPriceList) AS tmp ON tmp.PartnerId = tmpPartner.Id
                      WHERE tmp.PartnerId IS NULL
                      ) AS tmp
                
                    -- нашли Юр.лицо
                    INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                          ON ObjectLink_Partner_Juridical.ObjectId = tmp.PartnerId
                                         AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()

                    INNER JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                          ON ObjectLink_Contract_Juridical.ChildObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                         AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()

                    INNER JOIN tmpContract ON tmpContract.ContractId = ObjectLink_Contract_Juridical.ObjectId                   
 
                    LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                                         ON ObjectLink_Juridical_PriceList.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                        AND ObjectLink_Juridical_PriceList.DescId = zc_ObjectLink_Juridical_PriceList()
                    LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = ObjectLink_Juridical_PriceList.ChildObjectId
                )          
                             
                              
     SELECT tmp.PriceListId         ::TVarChar AS priceHeaderExtId
          , tmp.ContractId          ::TVarChar AS contractHeaderExtId
          , zc_DateStart()          ::TVarChar AS validFrom
          , zc_DateEnd()            ::TVarChar AS validTo
          , FALSE                   ::Boolean  AS isDeleted
          , tmp.PartnerId           ::Integer  AS PartnerId
          , tmp.defaultPrice        ::Boolean  AS defaultPrice
     FROM tmpPartner_PriceList AS tmp
   UNION
     SELECT tmp.PriceListId         ::TVarChar AS priceHeaderExtId
          , tmp.ContractId          ::TVarChar AS contractHeaderExtId
          , tmp.StartDate           ::TVarChar AS validFrom
          , tmp.EndDate             ::TVarChar AS validTo
          , FALSE                   ::Boolean  AS isDeleted
          , tmp.PartnerId           ::Integer  AS PartnerId
          , tmp.defaultPrice        ::Boolean  AS defaultPrice
     FROM tmpContractPriceList AS tmp
   UNION
     SELECT tmp.PriceListId         ::TVarChar AS priceHeaderExtId
          , tmp.ContractId          ::TVarChar AS contractHeaderExtId
          , zc_DateStart()          ::TVarChar AS validFrom
          , zc_DateEnd()            ::TVarChar AS validTo
          , FALSE                   ::Boolean  AS isDeleted
          , tmp.PartnerId           ::Integer  AS PartnerId
          , tmp.defaultPrice        ::Boolean  AS defaultPrice
     FROM tmpIts AS tmp
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

 добавляется поля PartnerId + defaultPrice 
 1) сначала берем zc_ObjectLink_Partner_PriceList - юр лицо и все его договора, только здесь defaultPrice = TRUE, для 2 и 3 будет FALSE 
 2) только КЛИЕНТОВ которых нет в (1) -  юр лицо  INNER JOIN  zc_Object_ContractPriceList + учесть если заполнено zc_Object_ContractPartner, для таких договоров только эти КЛИЕНТЫ 
 3) только КЛИЕНТОВ которых нет в (1) + (2)  берется zc_ObjectLink_Juridical_PriceList
 

-- 1) zc_Object_ContractPriceList 2) union остальные договора gpSelect_Object_ContractHeaders_effie - по ним zc_ObjectLink_Juridical_PriceList

*/