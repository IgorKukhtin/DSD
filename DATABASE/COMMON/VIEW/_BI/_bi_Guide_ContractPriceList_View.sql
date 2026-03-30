-- View: _bi_Guide_ContractPriceList_View

DROP VIEW IF EXISTS _bi_Guide_ContractPriceList_View;

-- Справочник Contract + PriceList
/*

*/

CREATE OR REPLACE VIEW _bi_Guide_ContractPriceList_View
AS
     SELECT Object_Contract.Id             AS ContractId
          , Object_Contract.ObjectCode     AS ContractCode
          , Object_Contract.ValueData      AS InvNumber

          , Object_PriceList.Id            AS PriceListId
          , Object_PriceList.ValueData     AS PriceListName

          , Object_Juridical.Id            AS JuridicalId
          , Object_Juridical.ValueData     AS JuridicalName

             -- Св-во "Дата цены"
          , ObjectDate_StartDate.ValueData AS StartDate
          , ObjectDate_EndDate.ValueData   AS EndDate

            -- УП Статья назначения
          , Object_InfoMoney.Id         AS InfoMoneyId
          , Object_InfoMoney.ObjectCode AS InfoMoneyCode
          , Object_InfoMoney.ValueData  AS InfoMoneyName

     FROM Object AS Object_ContractPriceList
          INNER JOIN ObjectDate AS ObjectDate_StartDate
                                ON ObjectDate_StartDate.ObjectId = Object_ContractPriceList.Id
                               AND ObjectDate_StartDate.DescId   = zc_ObjectDate_ContractPriceList_StartDate()
          INNER JOIN ObjectDate AS ObjectDate_EndDate
                                ON ObjectDate_EndDate.ObjectId  = Object_ContractPriceList.Id
                               AND ObjectDate_EndDate.DescId    = zc_ObjectDate_ContractPriceList_EndDate()
                               -- Последняя цена
                               -- AND ObjectDate_EndDate.ValueData = zc_DateEnd()

          LEFT JOIN ObjectLink AS OL_ContractPriceList_PriceList
                               ON OL_ContractPriceList_PriceList.ObjectId = Object_ContractPriceList.Id
                              AND OL_ContractPriceList_PriceList.DescId   = zc_ObjectLink_ContractPriceList_PriceList()
          LEFT JOIN ObjectLink AS OL_ContractPriceList_Contract
                               ON OL_ContractPriceList_Contract.ObjectId = Object_ContractPriceList.Id
                              AND OL_ContractPriceList_Contract.DescId   = zc_ObjectLink_ContractPriceList_Contract()

          LEFT JOIN ObjectLink AS OL_Contract_Juridical
                               ON OL_Contract_Juridical.ObjectId = OL_ContractPriceList_Contract.ChildObjectId
                              AND OL_Contract_Juridical.DescId   = zc_ObjectLink_Contract_Juridical()

          LEFT JOIN Object AS Object_Contract  ON Object_Contract.Id  = OL_ContractPriceList_Contract.ChildObjectId
          LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = OL_ContractPriceList_PriceList.ChildObjectId
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = OL_Contract_Juridical.ChildObjectId

          -- УП Статья назначения
          LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                               ON ObjectLink_Contract_InfoMoney.ObjectId = Object_Contract.Id
                              AND ObjectLink_Contract_InfoMoney.DescId   = zc_ObjectLink_Contract_InfoMoney()
          LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_Contract_InfoMoney.ChildObjectId

     WHERE Object_ContractPriceList.DescId       = zc_Object_ContractPriceList()
       AND Object_ContractPriceList.isErased = FALSE
    ;

ALTER TABLE _bi_Guide_ContractPriceList_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.03.26                                        *
*/

/*
                          WITH tmpPriceList_jur AS (SELECT Id AS JuridicalId, PriceListId AS PriceListId_calc, PriceListName as PriceListName_calc FROM _bi_Guide_Juridical_View)
                             , tmpPriceList_partner AS (SELECT Id AS PartnerId, PriceListId AS PriceListId_calc, PriceListName as PriceListName_calc FROM _bi_Guide_Partner_View)
                          SELECT Object_PriceList.Id AS PriceListId_doc
                              , Object_PriceList.ValueData AS PriceListName_doc
                              , COALESCE (tmpPriceList_partner.PriceListId_calc, _bi_Guide_ContractPriceList_View.PriceListId, tmpPriceList_jur.PriceListId_calc) AS PriceListId_calc
                              , COALESCE (tmpPriceList_partner.PriceListName_calc, _bi_Guide_ContractPriceList_View.PriceListName, tmpPriceList_jur.PriceListName_calc) AS PriceListName_calc
                              , Object_Juridical.Id AS JuridicalId, Object_Juridical.ValueData AS JuridicalName
                              , Object_Contract.ObjectCode
                              , Object_Contract.Id AS ContractId

                              , _bi_Guide_ContractPriceList_View.PriceListId AS PriceListId_contract, _bi_Guide_ContractPriceList_View.PriceListName AS PriceListName_contract
                              , tmpPriceList_jur.PriceListId_calc AS PriceListId_jur, tmpPriceList_jur.PriceListName_calc AS PriceListName_jur
                              , tmpPriceList_partner.PriceListId_calc AS PriceListId_partner, tmpPriceList_partner.PriceListName_calc AS PriceListName_partner

                              , Movement.OperDate, Movement.InvNumber

                          FROM Movement
                               LEFT JOIN MovementLinkObject AS MLO_To
                                                            ON MLO_To.MovementId = Movement.Id
                                                           AND MLO_To.DescId     = zc_MovementLinkObject_To()
                               LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                    ON ObjectLink_Partner_Juridical.ObjectId = MLO_To.ObjectId
                                                   AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                               LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId

                               LEFT JOIN MovementLinkObject AS MLO_Contract
                                                            ON MLO_Contract.MovementId = Movement.Id
                                                           AND MLO_Contract.DescId     = zc_MovementLinkObject_Contract()
                               LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MLO_Contract.ObjectId
                               -- УП Статья назначения
                               LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                                    ON ObjectLink_Contract_InfoMoney.ObjectId = Object_Contract.Id
                                                   AND ObjectLink_Contract_InfoMoney.DescId   = zc_ObjectLink_Contract_InfoMoney()
                               LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_Contract_InfoMoney.ChildObjectId


                               -- №1. Отдельно если назначен у Контрагента
                               LEFT JOIN tmpPriceList_partner ON tmpPriceList_partner.PartnerId = MLO_To.ObjectId

                               -- №2. Отдельно если назначен в договорах
                               LEFT JOIN _bi_Guide_ContractPriceList_View ON _bi_Guide_ContractPriceList_View.ContractId = Object_Contract.Id
                                                                          AND Movement.OperDate BETWEEN _bi_Guide_ContractPriceList_View.StartDate
                                                                                                   AND  _bi_Guide_ContractPriceList_View.EndDate

                               LEFT JOIN MovementLinkObject AS MLO_PriceList
                                                            ON MLO_PriceList.MovementId = Movement.Id
                                                           AND MLO_PriceList.DescId     = zc_MovementLinkObject_PriceList()
                               LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = MLO_PriceList.ObjectId

                               -- №3. Отдельно если назначен у Юр.лица
                               LEFT JOIN tmpPriceList_jur ON tmpPriceList_jur.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId

                          WHERE Movement.OperDate BETWEEN '01.01.2026' AND '31.01.2026'
                            AND Movement.DescId = zc_Movement_Sale()
                            AND Movement.StatusId = zc_Enum_Status_Complete()
                            AND Object_InfoMoney.Id = zc_Enum_InfoMoney_30101()
                            AND COALESCE (tmpPriceList_partner.PriceListId_calc, _bi_Guide_ContractPriceList_View.PriceListId, tmpPriceList_jur.PriceListId_calc) <> MLO_PriceList.ObjectId
*/

-- тест
-- SELECT * FROM _bi_Guide_ContractPriceList_View
