-- Function: gpSelect_Object_ContractPrices_effie
-- Перевязки: Договор-прайс

DROP FUNCTION IF EXISTS gpSelect_Object_ContractPrices_effie ( TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractPrices_effie(
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (priceHeaderExtId      TVarChar   -- Идентификатор прайса
             , contractHeaderExtId   TVarChar   -- Идентификатор контракта
             , validFrom             TVarChar   -- Дата начала (минимальная дата 1753-01-01)
             , validTo               TVarChar   -- Дата окончания (максимальная дата 9999-12-31)
             , isDeleted             Boolean    -- Признак активности: false = активна / true = не активна. По умолчанию false = активна.
             , PartnerId             Integer    -- Контрагент инф.
             , StreetId              Integer    -- Street инф.
             , defaultPrice          Boolean    --
             , PaidKindId            Integer    -- Форма оплата - для внутреннего использования
             , PaidKindName          TVarChar   -- Форма оплата - для внутреннего использования
              )
AS
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
                       -- !!!Не закрытые!!!
                       AND Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                    )
    , tmpPartner AS (SELECT Object_Partner.*
                          , COALESCE (ObjectLink_Partner_Street.ChildObjectId, 0) AS StreetId
                     FROM Object AS Object_Partner
                          -- есть Адрес
                          INNER JOIN ObjectLink AS ObjectLink_Partner_Street
                                               ON ObjectLink_Partner_Street.ObjectId      = Object_Partner.Id
                                              AND ObjectLink_Partner_Street.DescId        = zc_ObjectLink_Partner_Street()
                                              AND ObjectLink_Partner_Street.ChildObjectId > 0
                     WHERE Object_Partner.DescId = zc_Object_Partner()
                       AND Object_Partner.isErased = FALSE
                    )
     -- прайс только в Контрагенте
   , tmpPartner_PriceList AS (SELECT ObjectLink_Partner_PriceList.ObjectId      AS PartnerId
                                   , ObjectLink_Partner_PriceList.ChildObjectId AS PriceListId
                                   , ObjectLink_Contract_Juridical.ObjectId     AS ContractId
                                   , tmpPartner.StreetId                        AS StreetId
                                   , TRUE                                       AS defaultPrice
                              FROM ObjectLink AS ObjectLink_Partner_PriceList
                                  INNER JOIN tmpPartner ON tmpPartner.Id = ObjectLink_Partner_PriceList.ObjectId
                                  -- нашли Юр.лицо
                                  INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                        ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_Partner_PriceList.ObjectId
                                                       AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                                  -- на ВСЕ договора
                                  INNER JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                        ON ObjectLink_Contract_Juridical.ChildObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                       AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()

                                  INNER JOIN tmpContract ON tmpContract.ContractId = ObjectLink_Contract_Juridical.ObjectId

                              WHERE ObjectLink_Partner_PriceList.DescId = zc_ObjectLink_Partner_PriceList()
                                -- есть прайс
                                AND ObjectLink_Partner_PriceList.ChildObjectId > 0
                              )

     -- прайсы из ContractPriceList для Остальных
   , tmpContractPriceList AS (SELECT ObjectLink_Partner_Juridical.ObjectId                 AS PartnerId
                                   , ObjectLink_ContractPriceList_PriceList.ChildObjectId  AS PriceListId
                                   , ObjectLink_ContractPriceList_Contract.ChildObjectId   AS ContractId
                                   , ObjectDate_StartDate.ValueData                        AS StartDate
                                   , ObjectDate_EndDate.ValueData                          AS EndDate
                                   , tmpPartner.StreetId                                   AS StreetId
                                   , FALSE                                                 AS defaultPrice

                              FROM Object AS Object_ContractPriceList
                                   INNER JOIN ObjectLink AS ObjectLink_ContractPriceList_Contract
                                                         ON ObjectLink_ContractPriceList_Contract.ObjectId = Object_ContractPriceList.Id
                                                        AND ObjectLink_ContractPriceList_Contract.DescId = zc_ObjectLink_ContractPriceList_Contract()
                                                        -- Кроме таких Договоров
                                                        AND ObjectLink_ContractPriceList_Contract.ChildObjectId NOT IN (SELECT DISTINCT tmpPartner_PriceList.ContractId FROM tmpPartner_PriceList)

                                   -- только такие договора
                                   INNER JOIN tmpContract ON tmpContract.ContractId = ObjectLink_ContractPriceList_Contract.ChildObjectId

                                   LEFT JOIN ObjectLink AS ObjectLink_ContractPriceList_PriceList
                                                        ON ObjectLink_ContractPriceList_PriceList.ObjectId = Object_ContractPriceList.Id
                                                       AND ObjectLink_ContractPriceList_PriceList.DescId = zc_ObjectLink_ContractPriceList_PriceList()
                                   -- удаленные прайсы - пусть пока участвуют
                                   INNER JOIN Object AS Object_PriceList ON Object_PriceList.Id = ObjectLink_ContractPriceList_PriceList.ChildObjectId
                                                  --AND Object_PriceList.isErased = FALSE

                                   LEFT JOIN ObjectDate AS ObjectDate_StartDate
                                                        ON ObjectDate_StartDate.ObjectId = Object_ContractPriceList.Id
                                                       AND ObjectDate_StartDate.DescId = zc_ObjectDate_ContractPriceList_StartDate()
                                   LEFT JOIN ObjectDate AS ObjectDate_EndDate
                                                        ON ObjectDate_EndDate.ObjectId = Object_ContractPriceList.Id
                                                       AND ObjectDate_EndDate.DescId = zc_ObjectDate_ContractPriceList_EndDate()

                                   INNER JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                         ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_ContractPriceList_Contract.ChildObjectId
                                                        AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                                   -- ВСЕ Контрагенты
                                   INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                         ON ObjectLink_Partner_Juridical.ChildObjectId = ObjectLink_Contract_Juridical.ChildObjectId
                                                        AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                   -- удаленные Контрагенты - НЕ участвуют
                                   INNER JOIN tmpPartner ON tmpPartner.Id = ObjectLink_Partner_Juridical.ObjectId

                              WHERE Object_ContractPriceList.DescId = zc_Object_ContractPriceList()
                                AND Object_ContractPriceList.isErased = FALSE
                                AND ObjectDate_StartDate.ValueData <= CURRENT_DATE
                                AND ObjectDate_EndDate.ValueData > CURRENT_DATE
                             )

     -- оптимизация
   , tmpList_1 AS (SELECT tmpPartner.Id AS PartnerId, tmpPartner.StreetId
                   FROM tmpPartner
                        -- этим контрагентам уже определили прайс
                        LEFT JOIN (SELECT DISTINCT tmpPartner_PriceList.PartnerId FROM tmpPartner_PriceList
                           -- эти не здесь
                           --UNION SELECT DISTINCT tmpContractPriceList.PartnerId FROM tmpContractPriceList
                                   ) AS tmp
                                     ON tmp.PartnerId = tmpPartner.Id
                   -- исключили таких
                   WHERE tmp.PartnerId IS NULL
                  )
     -- Остальные - у Юр лица - все его контрагенты + если у него есть прайс
   , tmpContractPriceList_list AS (SELECT DISTINCT tmpContractPriceList.PartnerId, tmpContractPriceList.ContractId FROM tmpContractPriceList)

     -- оптимизация
   , tmpContract_Juridical AS (SELECT ObjectLink_Contract_Juridical.*
                               FROM ObjectLink AS ObjectLink_Contract_Juridical
                               WHERE -- только такие договора
                                     ObjectLink_Contract_Juridical.ObjectId IN (SELECT DISTINCT tmpContract.ContractId FROM tmpContract)
                                 AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                              )

     -- Остальные - у Юр лица - все его контрагенты + если у него есть прайс
   , tmpIts AS (SELECT tmpPartner.PartnerId                                 AS PartnerId
                       -- всегда будет прайс
                     , COALESCE (Object_PriceList.Id, zc_PriceList_Basis()) AS PriceListId
                       --
                     , ObjectLink_Contract_Juridical.ObjectId               AS ContractId
                     , tmpPartner.StreetId                                  AS StreetId
                     , FALSE                                                AS defaultPrice

                FROM tmpList_1 AS tmpPartner
                    -- нашли Юр.лицо
                    INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                          ON ObjectLink_Partner_Juridical.ObjectId = tmpPartner.PartnerId
                                         AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()

                    INNER JOIN tmpContract_Juridical AS ObjectLink_Contract_Juridical
                                                     ON ObjectLink_Contract_Juridical.ChildObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                    AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()

                    -- нашли прайс
                    LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                                         ON ObjectLink_Juridical_PriceList.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                        AND ObjectLink_Juridical_PriceList.DescId = zc_ObjectLink_Juridical_PriceList()
                    -- все прайсы
                    LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id       = ObjectLink_Juridical_PriceList.ChildObjectId
                                                      --AND Object_PriceList.isErased = FALSE

                    -- эти здесь
                    LEFT JOIN tmpContractPriceList_list AS tmpContractPriceList
                                                        ON tmpContractPriceList.PartnerId  = tmpPartner.PartnerId
                                                       AND tmpContractPriceList.ContractId = ObjectLink_Contract_Juridical.ObjectId
                -- Если по договору нет Контрагента, берем всех
                WHERE tmpContractPriceList.ContractId IS NULL
               )

          -- только такие договора
        , tmp_Contract AS (SELECT DISTINCT gpSelect.extId :: Integer AS ContractId, gpSelect.PaidKindId, gpSelect.PaidKindName FROM gpSelect_Object_ContractHeaders_effie (inSession) AS gpSelect)

     -- Результат
     SELECT tmp.PriceListId         ::TVarChar AS priceHeaderExtId
          , tmp.ContractId          ::TVarChar AS contractHeaderExtId
          , zfConvert_DateToString (zc_DateStart()) ::TVarChar AS validFrom
          , zfConvert_DateToString (zc_DateEnd())   ::TVarChar AS validTo
          , FALSE                   ::Boolean  AS isDeleted
          , tmp.PartnerId           ::Integer  AS PartnerId
          , tmp.StreetId            ::Integer  AS StreetId
          , tmp.defaultPrice        ::Boolean  AS defaultPrice
          , tmp_Contract.PaidKindId
          , tmp_Contract.PaidKindName
     FROM tmpPartner_PriceList AS tmp
          INNER JOIN tmp_Contract ON tmp_Contract.ContractId = tmp.ContractId
   UNION
     SELECT tmp.PriceListId         ::TVarChar AS priceHeaderExtId
          , tmp.ContractId          ::TVarChar AS contractHeaderExtId
          , zfConvert_DateToString (tmp.StartDate)                  ::TVarChar AS validFrom
          , zfConvert_DateToString (/*tmp.EndDate*/ zc_DateEnd())   ::TVarChar AS validTo
          , FALSE                   ::Boolean  AS isDeleted
          , tmp.PartnerId           ::Integer  AS PartnerId
          , tmp.StreetId            ::Integer  AS StreetId
          , tmp.defaultPrice        ::Boolean  AS defaultPrice
          , tmp_Contract.PaidKindId
          , tmp_Contract.PaidKindName
     FROM tmpContractPriceList AS tmp
          INNER JOIN tmp_Contract ON tmp_Contract.ContractId = tmp.ContractId
   UNION
     SELECT tmp.PriceListId         ::TVarChar AS priceHeaderExtId
          , tmp.ContractId          ::TVarChar AS contractHeaderExtId
          , zfConvert_DateToString (zc_DateStart()) ::TVarChar AS validFrom
          , zfConvert_DateToString (zc_DateEnd())   ::TVarChar AS validTo
          , FALSE                   ::Boolean  AS isDeleted
          , tmp.PartnerId           ::Integer  AS PartnerId
          , tmp.StreetId            ::Integer  AS StreetId
          , tmp.defaultPrice        ::Boolean  AS defaultPrice
          , tmp_Contract.PaidKindId
          , tmp_Contract.PaidKindName
     FROM tmpIts AS tmp
          INNER JOIN tmp_Contract ON tmp_Contract.ContractId = tmp.ContractId
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

/*

 добавляется поля PartnerId + defaultPrice
 1) сначала берем zc_ObjectLink_Partner_PriceList - юр лицо и все его договора, только здесь defaultPrice = TRUE, для 2 и 3 будет FALSE
 2) только КЛИЕНТОВ которых нет в (1) -  юр лицо  INNER JOIN  zc_Object_ContractPriceList + учесть если заполнено zc_Object_ContractPartner, для таких договоров только эти КЛИЕНТЫ
 3) только КЛИЕНТОВ которых нет в (1) + (2)  берется zc_ObjectLink_Juridical_PriceList


-- 1) zc_Object_ContractPriceList 2) union остальные договора gpSelect_Object_ContractHeaders_effie - по ним zc_ObjectLink_Juridical_PriceList

*/


-- тест
-- SELECT * FROM gpSelect_Object_ContractPrices_effie (zfCalc_UserAdmin()::TVarChar) where priceHeaderExtId not in (SELECT priceHeaderExtId FROM gpSelect_Object_ContractPrices_effie (zfCalc_UserAdmin()::TVarChar) where isDeleted = FALSE)
-- SELECT * FROM gpSelect_Object_ContractPrices_effie (zfCalc_UserAdmin()::TVarChar) where contractHeaderExtId not in (SELECT ExtId FROM gpSelect_Object_ContractHeaders_effie (zfCalc_UserAdmin()::TVarChar) where isDeleted = FALSE)
-- тест
-- SELECT * FROM gpSelect_Object_ContractPrices_effie (zfCalc_UserAdmin()::TVarChar) where priceHeaderExtId not in (SELECT priceHeaderExtId FROM gpSelect_Object_PriceForTwin_effie (zfCalc_UserAdmin()::TVarChar))

-- тест
-- SELECT * FROM gpSelect_Object_ContractPrices_effie (zfCalc_UserAdmin()::TVarChar);
