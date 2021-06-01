-- Function: lfGet_Object_Partner_PriceList_onDate (Integer, Integer, TDateTime)

DROP FUNCTION IF EXISTS lfGet_Object_Partner_PriceList_onDate (Integer, Integer, Integer, TDateTime, TDateTime, Boolean);
-- DROP FUNCTION IF EXISTS lfGet_Object_Partner_PriceList_onDate (Integer, Integer, Integer, TDateTime, TDateTime, Integer, Boolean);
DROP FUNCTION IF EXISTS lfGet_Object_Partner_PriceList_onDate (Integer, Integer, Integer, TDateTime, TDateTime, Integer, Boolean, TDateTime);

CREATE OR REPLACE FUNCTION lfGet_Object_Partner_PriceList_onDate(
    IN inContractId            Integer, 
    IN inPartnerId             Integer,
    IN inMovementDescId        Integer,
    IN inOperDate_order        TDateTime,
    IN inOperDatePartner       TDateTime,
    IN inDayPrior_PriceReturn  Integer,
    IN inIsPrior               Boolean,
    IN inOperDatePartner_order TDateTime -- DEFAULT NULL
)
RETURNS TABLE (OperDate TDateTime, PriceListId Integer, PriceListName TVarChar, PriceWithVAT Boolean, VATPercent TFloat, DescId Integer, Code TVarChar, ItemName TVarChar)
AS
$BODY$
   DECLARE vbJuridicalId Integer;
   DECLARE vbInfoMoneyId Integer;
BEGIN

      -- выход
      IF COALESCE (inContractId, 0) = 0
      THEN RETURN;
      END IF;


      -- определили Статью
      vbInfoMoneyId:= (SELECT ObjectLink_Contract_InfoMoney.ChildObjectId
                       FROM ObjectLink AS ObjectLink_Contract_InfoMoney
                       WHERE ObjectLink_Contract_InfoMoney.ObjectId = inContractId
                         AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
                      );
      -- определили Юр.лицо
      vbJuridicalId:= (SELECT ObjectLink_Partner_Juridical.ChildObjectId
                       FROM ObjectLink AS ObjectLink_Partner_Juridical
                       WHERE ObjectLink_Partner_Juridical.ObjectId = inPartnerId
                         AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                      );

      IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = '_tmppricelist_ondate')
      THEN
          --
          DELETE FROM _tmpPriceList_onDate;
      ELSE
          -- 
          CREATE TEMP TABLE _tmpPriceList_onDate (OperDate TDateTime, PriceListId Integer, DescId Integer) ON COMMIT DROP;
      END IF;

      -- 1.1. так для возвратов + ГП
      IF inMovementDescId = zc_Movement_ReturnIn() AND vbInfoMoneyId = zc_Enum_InfoMoney_30101() -- Доходы + Продукция + Готовая продукция
      THEN
          IF inIsPrior = TRUE
          THEN
              -- 1.1.1. так для возвратов ГП по "старым ценам"
              WITH tmpPartner AS (SELECT inPartnerId AS PartnerId, vbJuridicalId AS JuridicalId)
              -- Результат
              INSERT INTO _tmpPriceList_onDate (OperDate, PriceListId, DescId)
                 SELECT inOperDatePartner :: Date - inDayPrior_PriceReturn AS OperDate
                      , COALESCE (ObjectLink_Partner_PriceListPrior.ChildObjectId
                      , COALESCE (ObjectLink_Juridical_PriceListPrior.ChildObjectId
                                , zc_PriceList_BasisPrior())) AS PriceListId

                      , COALESCE (ObjectLink_Partner_PriceListPrior.DescId
                      , COALESCE (ObjectLink_Juridical_PriceListPrior.DescId
                                , 0)) AS DescId
                 FROM tmpPartner
                      LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceListPrior
                                           ON ObjectLink_Partner_PriceListPrior.ObjectId = tmpPartner.PartnerId
                                          AND ObjectLink_Partner_PriceListPrior.DescId = zc_ObjectLink_Partner_PriceListPrior()
                                          AND ObjectLink_Partner_PriceListPrior.ChildObjectId > 0
                      LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceListPrior
                                           ON ObjectLink_Juridical_PriceListPrior.ObjectId = tmpPartner.JuridicalId
                                          AND ObjectLink_Juridical_PriceListPrior.DescId = zc_ObjectLink_Juridical_PriceListPrior()
                                          AND ObjectLink_Juridical_PriceListPrior.ChildObjectId > 0
                 ;
          ELSE
              -- 1.1.2. так для возвратов ГП по "обычным ценам"
              WITH tmpPartner AS (SELECT inPartnerId AS PartnerId, inContractId AS ContractId, vbJuridicalId AS JuridicalId)
                 , tmpContract_PriceList AS (SELECT tmpPartner.ContractId, OL_ContractPriceList_PriceList.ChildObjectId AS PriceListId, OL_ContractPriceList_PriceList.DescId
                                                  , ObjectDate_StartDate.ValueData AS StartDate, ObjectDate_EndDate.ValueData AS EndDate
                                             FROM tmpPartner
                                                  INNER JOIN ObjectLink AS OL_ContractPriceList_Contract
                                                                        ON OL_ContractPriceList_Contract.ChildObjectId = tmpPartner.ContractId
                                                                       AND OL_ContractPriceList_Contract.DescId        = zc_ObjectLink_ContractPriceList_Contract()
                                                  INNER JOIN Object AS Object_ContractPriceList ON Object_ContractPriceList.Id       = OL_ContractPriceList_Contract.ObjectId
                                                                                               AND Object_ContractPriceList.isErased = FALSE
                                                  INNER JOIN ObjectDate AS ObjectDate_StartDate
                                                                        ON ObjectDate_StartDate.ObjectId = Object_ContractPriceList.Id
                                                                       AND ObjectDate_StartDate.DescId   = zc_ObjectDate_ContractPriceList_StartDate()
                                                  INNER JOIN ObjectDate AS ObjectDate_EndDate
                                                                        ON ObjectDate_EndDate.ObjectId = Object_ContractPriceList.Id
                                                                       AND ObjectDate_EndDate.DescId   = zc_ObjectDate_ContractPriceList_EndDate()
                                                  LEFT JOIN ObjectLink AS OL_ContractPriceList_PriceList
                                                                       ON OL_ContractPriceList_PriceList.ObjectId = Object_ContractPriceList.Id
                                                                      AND OL_ContractPriceList_PriceList.DescId   = zc_ObjectLink_ContractPriceList_PriceList()
                                            )
              -- Результат
              INSERT INTO _tmpPriceList_onDate (OperDate, PriceListId, DescId)
                 SELECT inOperDatePartner :: Date - inDayPrior_PriceReturn AS OperDate
                      , COALESCE (ObjectLink_Partner_PriceList.ChildObjectId
                                , tmpContract_PriceList.PriceListId
                              --, ObjectLink_Contract_PriceList.ChildObjectId
                                , ObjectLink_Juridical_PriceList.ChildObjectId
                                , zc_PriceList_Basis()) AS PriceListId

                      , COALESCE (ObjectLink_Partner_PriceList.DescId
                                , tmpContract_PriceList.DescId
                              --, ObjectLink_Contract_PriceList.DescId
                                , ObjectLink_Juridical_PriceList.DescId
                                , 0) AS DescId
                 FROM tmpPartner
                      LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList
                                           ON ObjectLink_Partner_PriceList.ObjectId      = tmpPartner.PartnerId
                                          AND ObjectLink_Partner_PriceList.DescId        = zc_ObjectLink_Partner_PriceList()
                                          AND ObjectLink_Partner_PriceList.ChildObjectId > 0
                      LEFT JOIN tmpContract_PriceList ON tmpContract_PriceList.ContractId  = tmpPartner.ContractId
                                                     AND tmpContract_PriceList.PriceListId > 0
                                                     AND inOperDatePartner :: Date - inDayPrior_PriceReturn
                                                         BETWEEN tmpContract_PriceList.StartDate AND tmpContract_PriceList.EndDate
                    /*LEFT JOIN ObjectLink AS ObjectLink_Contract_PriceList
                                           ON ObjectLink_Contract_PriceList.ObjectId      = tmpPartner.ContractId
                                          AND ObjectLink_Contract_PriceList.DescId        = zc_ObjectLink_Contract_PriceList()
                                          AND ObjectLink_Contract_PriceList.ChildObjectId > 0*/
                      LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                                           ON ObjectLink_Juridical_PriceList.ObjectId      = tmpPartner.JuridicalId
                                          AND ObjectLink_Juridical_PriceList.DescId        = zc_ObjectLink_Juridical_PriceList()
                                          AND ObjectLink_Juridical_PriceList.ChildObjectId > 0
                 ;

          END IF;

      ELSE
          -- 1.2. так для возвратов + НЕ ГП
          IF inMovementDescId = zc_Movement_ReturnIn()
          THEN
              WITH tmpPartner AS (SELECT inPartnerId AS PartnerId, inContractId AS ContractId, vbJuridicalId AS JuridicalId)
                 , tmpContract_PriceList AS (SELECT tmpPartner.ContractId, OL_ContractPriceList_PriceList.ChildObjectId AS PriceListId, OL_ContractPriceList_PriceList.DescId
                                                  , ObjectDate_StartDate.ValueData AS StartDate, ObjectDate_EndDate.ValueData AS EndDate
                                             FROM tmpPartner
                                                  INNER JOIN ObjectLink AS OL_ContractPriceList_Contract
                                                                        ON OL_ContractPriceList_Contract.ChildObjectId = tmpPartner.ContractId
                                                                       AND OL_ContractPriceList_Contract.DescId        = zc_ObjectLink_ContractPriceList_Contract()
                                                  INNER JOIN Object AS Object_ContractPriceList ON Object_ContractPriceList.Id       = OL_ContractPriceList_Contract.ObjectId
                                                                                               AND Object_ContractPriceList.isErased = FALSE
                                                  INNER JOIN ObjectDate AS ObjectDate_StartDate
                                                                        ON ObjectDate_StartDate.ObjectId = Object_ContractPriceList.Id
                                                                       AND ObjectDate_StartDate.DescId   = zc_ObjectDate_ContractPriceList_StartDate()
                                                  INNER JOIN ObjectDate AS ObjectDate_EndDate
                                                                        ON ObjectDate_EndDate.ObjectId = Object_ContractPriceList.Id
                                                                       AND ObjectDate_EndDate.DescId   = zc_ObjectDate_ContractPriceList_EndDate()
                                                  LEFT JOIN ObjectLink AS OL_ContractPriceList_PriceList
                                                                       ON OL_ContractPriceList_PriceList.ObjectId = Object_ContractPriceList.Id
                                                                      AND OL_ContractPriceList_PriceList.DescId   = zc_ObjectLink_ContractPriceList_PriceList()
                                            )
              -- Результат
              INSERT INTO _tmpPriceList_onDate (OperDate, PriceListId, DescId)
                 SELECT inOperDatePartner AS OperDate
                      , COALESCE (ObjectLink_Partner_PriceList30103.ChildObjectId
                                , ObjectLink_Partner_PriceList30201.ChildObjectId
                                , tmpContract_PriceList.PriceListId
                              --, ObjectLink_Contract_PriceList.ChildObjectId
                                , ObjectLink_Juridical_PriceList30103.ChildObjectId
                                , ObjectLink_Juridical_PriceList30201.ChildObjectId
                                , zc_PriceList_Basis()) AS PriceListId

                      , COALESCE (ObjectLink_Partner_PriceList30103.DescId
                                , ObjectLink_Partner_PriceList30201.DescId

                                , tmpContract_PriceList.DescId
                              --, ObjectLink_Contract_PriceList.DescId

                                , ObjectLink_Juridical_PriceList30103.DescId
                                , ObjectLink_Juridical_PriceList30201.DescId

                                , 0) AS DescId
                 FROM tmpPartner
                      LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList30103
                                           ON ObjectLink_Partner_PriceList30103.ObjectId = tmpPartner.PartnerId
                                          AND ObjectLink_Partner_PriceList30103.DescId = zc_ObjectLink_Partner_PriceList30103()
                                          AND ObjectLink_Partner_PriceList30103.ChildObjectId > 0
                                          AND vbInfoMoneyId = zc_Enum_InfoMoney_30103() -- Доходы + Продукция + Хлеб
                      LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList30201
                                           ON ObjectLink_Partner_PriceList30201.ObjectId = tmpPartner.PartnerId
                                          AND ObjectLink_Partner_PriceList30201.DescId = zc_ObjectLink_Partner_PriceList30201()
                                          AND ObjectLink_Partner_PriceList30201.ChildObjectId > 0
                                          AND vbInfoMoneyId = zc_Enum_InfoMoney_30201() -- Доходы + Мясное сырье + Мясное сырье

                      LEFT JOIN tmpContract_PriceList ON tmpContract_PriceList.ContractId  = tmpPartner.ContractId
                                                     AND tmpContract_PriceList.PriceListId > 0
                                                     AND inOperDatePartner :: Date
                                                         BETWEEN tmpContract_PriceList.StartDate AND tmpContract_PriceList.EndDate
                    /*LEFT JOIN ObjectLink AS ObjectLink_Contract_PriceList
                                           ON ObjectLink_Contract_PriceList.ObjectId = tmpPartner.ContractId
                                          AND ObjectLink_Contract_PriceList.DescId = zc_ObjectLink_Contract_PriceList()
                                          AND ObjectLink_Contract_PriceList.ChildObjectId > 0*/

                      LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList30103
                                           ON ObjectLink_Juridical_PriceList30103.ObjectId = tmpPartner.JuridicalId
                                          AND ObjectLink_Juridical_PriceList30103.DescId = zc_ObjectLink_Juridical_PriceList30103()
                                          AND ObjectLink_Juridical_PriceList30103.ChildObjectId > 0
                                          AND vbInfoMoneyId = zc_Enum_InfoMoney_30103() -- Доходы + Продукция + Хлеб
                      LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList30201
                                           ON ObjectLink_Juridical_PriceList30201.ObjectId = tmpPartner.JuridicalId
                                          AND ObjectLink_Juridical_PriceList30201.DescId = zc_ObjectLink_Juridical_PriceList30201()
                                          AND ObjectLink_Juridical_PriceList30201.ChildObjectId > 0
                                          AND vbInfoMoneyId = zc_Enum_InfoMoney_30201() -- Доходы + Мясное сырье + Мясное сырье

                 ;
          ELSE
          -- 2.1. так для продажи + ГП
          IF inMovementDescId = zc_Movement_Sale() AND vbInfoMoneyId = zc_Enum_InfoMoney_30101() -- Доходы + Продукция + Готовая продукция
          THEN
              IF inOperDate_order IS NULL
              THEN
                  -- поиск даты для заявки
                  inOperDate_order:= inOperDatePartner :: Date - COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = inPartnerId AND ObjectFloat.DescId = zc_ObjectFloat_Partner_PrepareDayCount()), 0) :: Integer
                                                               - COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = inPartnerId AND ObjectFloat.DescId = zc_ObjectFloat_Partner_DocumentDayCount()), 0) :: Integer
                                                               ;
              END IF;
              IF inOperDatePartner IS NULL
              THEN
                  IF inOperDatePartner_order IS NOT NULL
                  THEN
                     -- поиск даты для акций
                     inOperDatePartner:= inOperDatePartner_order :: Date + COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = inPartnerId AND ObjectFloat.DescId = zc_ObjectFloat_Partner_DocumentDayCount()), 0) :: Integer
                                                                         ;
                  ELSE
                     -- поиск даты для акций
                     inOperDatePartner:= inOperDate_order :: Date + COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = inPartnerId AND ObjectFloat.DescId = zc_ObjectFloat_Partner_PrepareDayCount()), 0) :: Integer
                                                                  + COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = inPartnerId AND ObjectFloat.DescId = zc_ObjectFloat_Partner_DocumentDayCount()), 0) :: Integer
                                                                  ;
                  END IF;
              END IF;
              -- 2.1. в следующем порядке: 1.1) акционный у контрагента 1.2) акционный у договора 1.3) акционный у юр.лица 2.1) обычный у контрагента 2.2) обычный у договора 2.3) обычный у юр.лица 3) zc_PriceList_Basis
              WITH tmpPartner AS (SELECT inPartnerId AS PartnerId, inContractId AS ContractId, vbJuridicalId AS JuridicalId)
                 , tmpContract_PriceList AS (SELECT tmpPartner.ContractId, OL_ContractPriceList_PriceList.ChildObjectId AS PriceListId, OL_ContractPriceList_PriceList.DescId
                                                  , ObjectDate_StartDate.ValueData AS StartDate, ObjectDate_EndDate.ValueData AS EndDate
                                             FROM tmpPartner
                                                  INNER JOIN ObjectLink AS OL_ContractPriceList_Contract
                                                                        ON OL_ContractPriceList_Contract.ChildObjectId = tmpPartner.ContractId
                                                                       AND OL_ContractPriceList_Contract.DescId        = zc_ObjectLink_ContractPriceList_Contract()
                                                  INNER JOIN Object AS Object_ContractPriceList ON Object_ContractPriceList.Id       = OL_ContractPriceList_Contract.ObjectId
                                                                                               AND Object_ContractPriceList.isErased = FALSE
                                                  INNER JOIN ObjectDate AS ObjectDate_StartDate
                                                                        ON ObjectDate_StartDate.ObjectId = Object_ContractPriceList.Id
                                                                       AND ObjectDate_StartDate.DescId   = zc_ObjectDate_ContractPriceList_StartDate()
                                                  INNER JOIN ObjectDate AS ObjectDate_EndDate
                                                                        ON ObjectDate_EndDate.ObjectId = Object_ContractPriceList.Id
                                                                       AND ObjectDate_EndDate.DescId   = zc_ObjectDate_ContractPriceList_EndDate()
                                                  LEFT JOIN ObjectLink AS OL_ContractPriceList_PriceList
                                                                       ON OL_ContractPriceList_PriceList.ObjectId = Object_ContractPriceList.Id
                                                                      AND OL_ContractPriceList_PriceList.DescId   = zc_ObjectLink_ContractPriceList_PriceList()
                                            )
              -- Результат
              INSERT INTO _tmpPriceList_onDate (OperDate, PriceListId, DescId)
                 SELECT CASE WHEN ObjectBoolean_OperDateOrder.ValueData = TRUE
                                  THEN inOperDate_order
                             ELSE inOperDatePartner
                        END AS OperDate


                      , COALESCE (ObjectLink_Partner_PriceList.ChildObjectId
                                , tmpContract_PriceList.PriceListId
                              --, ObjectLink_Contract_PriceList.ChildObjectId
                                , ObjectLink_Juridical_PriceList.ChildObjectId
                                , zc_PriceList_Basis()) AS PriceListId

                      , COALESCE (ObjectLink_Partner_PriceList.DescId
                                , tmpContract_PriceList.DescId
                              --, ObjectLink_Contract_PriceList.DescId
                                , ObjectLink_Juridical_PriceList.DescId
                                , 0) AS DescId

                 FROM tmpPartner
                      LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                           ON ObjectLink_Juridical_Retail.ObjectId = tmpPartner.JuridicalId
                                          AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()
                      LEFT JOIN ObjectBoolean AS ObjectBoolean_OperDateOrder
                                              ON ObjectBoolean_OperDateOrder.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId 
                                             AND ObjectBoolean_OperDateOrder.DescId   = zc_ObjectBoolean_Retail_OperDateOrder() 

                      LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList
                                           ON ObjectLink_Partner_PriceList.ObjectId = tmpPartner.PartnerId
                                          AND ObjectLink_Partner_PriceList.DescId = zc_ObjectLink_Partner_PriceList()
                                          AND ObjectLink_Partner_PriceList.ChildObjectId > 0
                      LEFT JOIN tmpContract_PriceList ON tmpContract_PriceList.ContractId  = tmpPartner.ContractId
                                                     AND tmpContract_PriceList.PriceListId > 0
                                                     AND CASE WHEN ObjectBoolean_OperDateOrder.ValueData = TRUE
                                                                   THEN inOperDate_order
                                                              ELSE inOperDatePartner
                                                         END
                                                         BETWEEN tmpContract_PriceList.StartDate AND tmpContract_PriceList.EndDate
                    /*LEFT JOIN ObjectLink AS ObjectLink_Contract_PriceList
                                           ON ObjectLink_Contract_PriceList.ObjectId = tmpPartner.ContractId
                                          AND ObjectLink_Contract_PriceList.DescId = zc_ObjectLink_Contract_PriceList()
                                          AND ObjectLink_Contract_PriceList.ChildObjectId > 0*/
                      LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                                           ON ObjectLink_Juridical_PriceList.ObjectId = tmpPartner.JuridicalId
                                          AND ObjectLink_Juridical_PriceList.DescId = zc_ObjectLink_Juridical_PriceList()
                                          AND ObjectLink_Juridical_PriceList.ChildObjectId > 0
                 ;
         
          ELSE
          -- 2.2. так для продажи + НЕ ГП
          IF inMovementDescId = zc_Movement_Sale()
          THEN
              IF inOperDatePartner IS NULL
              THEN
                  -- поиск даты для ...
                  inOperDatePartner:= inOperDate_order :: Date + COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = inPartnerId AND ObjectFloat.DescId = zc_ObjectFloat_Partner_PrepareDayCount()), 0) :: Integer
                                                               + COALESCE ((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = inPartnerId AND ObjectFloat.DescId = zc_ObjectFloat_Partner_DocumentDayCount()), 0) :: Integer
                                                               ;
              END IF;
              --
              WITH tmpPartner AS (SELECT inPartnerId AS PartnerId, inContractId AS ContractId, vbJuridicalId AS JuridicalId)
                 , tmpContract_PriceList AS (SELECT tmpPartner.ContractId, OL_ContractPriceList_PriceList.ChildObjectId AS PriceListId, OL_ContractPriceList_PriceList.DescId
                                                  , ObjectDate_StartDate.ValueData AS StartDate, ObjectDate_EndDate.ValueData AS EndDate
                                             FROM tmpPartner
                                                  INNER JOIN ObjectLink AS OL_ContractPriceList_Contract
                                                                        ON OL_ContractPriceList_Contract.ChildObjectId = tmpPartner.ContractId
                                                                       AND OL_ContractPriceList_Contract.DescId        = zc_ObjectLink_ContractPriceList_Contract()
                                                  INNER JOIN Object AS Object_ContractPriceList ON Object_ContractPriceList.Id       = OL_ContractPriceList_Contract.ObjectId
                                                                                               AND Object_ContractPriceList.isErased = FALSE
                                                  INNER JOIN ObjectDate AS ObjectDate_StartDate
                                                                        ON ObjectDate_StartDate.ObjectId = Object_ContractPriceList.Id
                                                                       AND ObjectDate_StartDate.DescId   = zc_ObjectDate_ContractPriceList_StartDate()
                                                  INNER JOIN ObjectDate AS ObjectDate_EndDate
                                                                        ON ObjectDate_EndDate.ObjectId = Object_ContractPriceList.Id
                                                                       AND ObjectDate_EndDate.DescId   = zc_ObjectDate_ContractPriceList_EndDate()
                                                  LEFT JOIN ObjectLink AS OL_ContractPriceList_PriceList
                                                                       ON OL_ContractPriceList_PriceList.ObjectId = Object_ContractPriceList.Id
                                                                      AND OL_ContractPriceList_PriceList.DescId   = zc_ObjectLink_ContractPriceList_PriceList()
                                            )
              -- Результат
              INSERT INTO _tmpPriceList_onDate (OperDate, PriceListId, DescId)
                 SELECT inOperDatePartner AS OperDate
                      , COALESCE (ObjectLink_Partner_PriceList30103.ChildObjectId
                                , ObjectLink_Partner_PriceList30201.ChildObjectId
                                , tmpContract_PriceList.PriceListId
                              --, ObjectLink_Contract_PriceList.ChildObjectId
                                , ObjectLink_Juridical_PriceList30103.ChildObjectId
                                , ObjectLink_Juridical_PriceList30201.ChildObjectId
                                , zc_PriceList_Basis()) AS PriceListId

                      , COALESCE (ObjectLink_Partner_PriceList30103.DescId
                                , ObjectLink_Partner_PriceList30201.DescId
                                , tmpContract_PriceList.DescId
                              --, ObjectLink_Contract_PriceList.DescId
                                , ObjectLink_Juridical_PriceList30103.DescId
                                , ObjectLink_Juridical_PriceList30201.DescId
                                , 0) AS DescId
                 FROM tmpPartner
                      LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList30103
                                           ON ObjectLink_Partner_PriceList30103.ObjectId = tmpPartner.PartnerId
                                          AND ObjectLink_Partner_PriceList30103.DescId = zc_ObjectLink_Partner_PriceList30103()
                                          AND ObjectLink_Partner_PriceList30103.ChildObjectId > 0
                                          AND vbInfoMoneyId = zc_Enum_InfoMoney_30103() -- Доходы + Продукция + Хлеб
                      LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList30201
                                           ON ObjectLink_Partner_PriceList30201.ObjectId = tmpPartner.PartnerId
                                          AND ObjectLink_Partner_PriceList30201.DescId = zc_ObjectLink_Partner_PriceList30201()
                                          AND ObjectLink_Partner_PriceList30201.ChildObjectId > 0
                                          AND vbInfoMoneyId = zc_Enum_InfoMoney_30201() -- Доходы + Мясное сырье + Мясное сырье

                      LEFT JOIN tmpContract_PriceList ON tmpContract_PriceList.ContractId  = tmpPartner.ContractId
                                                     AND tmpContract_PriceList.PriceListId > 0
                                                     AND inOperDatePartner
                                                         BETWEEN tmpContract_PriceList.StartDate AND tmpContract_PriceList.EndDate
                    /*LEFT JOIN ObjectLink AS ObjectLink_Contract_PriceList
                                           ON ObjectLink_Contract_PriceList.ObjectId = tmpPartner.ContractId
                                          AND ObjectLink_Contract_PriceList.DescId = zc_ObjectLink_Contract_PriceList()
                                          AND ObjectLink_Contract_PriceList.ChildObjectId > 0*/

                      LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList30103
                                           ON ObjectLink_Juridical_PriceList30103.ObjectId = tmpPartner.JuridicalId
                                          AND ObjectLink_Juridical_PriceList30103.DescId = zc_ObjectLink_Juridical_PriceList30103()
                                          AND ObjectLink_Juridical_PriceList30103.ChildObjectId > 0
                                          AND vbInfoMoneyId = zc_Enum_InfoMoney_30103() -- Доходы + Продукция + Хлеб
                      LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList30201
                                           ON ObjectLink_Juridical_PriceList30201.ObjectId = tmpPartner.JuridicalId
                                          AND ObjectLink_Juridical_PriceList30201.DescId = zc_ObjectLink_Juridical_PriceList30201()
                                          AND ObjectLink_Juridical_PriceList30201.ChildObjectId > 0
                                          AND vbInfoMoneyId = zc_Enum_InfoMoney_30201() -- Доходы + Мясное сырье + Мясное сырье
                 ;
          ELSE
              -- 3. так для всего остального : Приход от поставщика + Возврат Поставщику
              WITH tmpPartner AS (SELECT inPartnerId AS PartnerId, inContractId AS ContractId, vbJuridicalId AS JuridicalId)
                 , tmpContract_PriceList AS (SELECT tmpPartner.ContractId, OL_ContractPriceList_PriceList.ChildObjectId AS PriceListId, OL_ContractPriceList_PriceList.DescId
                                                  , ObjectDate_StartDate.ValueData AS StartDate, ObjectDate_EndDate.ValueData AS EndDate
                                             FROM tmpPartner
                                                  INNER JOIN ObjectLink AS OL_ContractPriceList_Contract
                                                                        ON OL_ContractPriceList_Contract.ChildObjectId = tmpPartner.ContractId
                                                                       AND OL_ContractPriceList_Contract.DescId        = zc_ObjectLink_ContractPriceList_Contract()
                                                  INNER JOIN Object AS Object_ContractPriceList ON Object_ContractPriceList.Id       = OL_ContractPriceList_Contract.ObjectId
                                                                                               AND Object_ContractPriceList.isErased = FALSE
                                                  INNER JOIN ObjectDate AS ObjectDate_StartDate
                                                                        ON ObjectDate_StartDate.ObjectId = Object_ContractPriceList.Id
                                                                       AND ObjectDate_StartDate.DescId   = zc_ObjectDate_ContractPriceList_StartDate()
                                                  INNER JOIN ObjectDate AS ObjectDate_EndDate
                                                                        ON ObjectDate_EndDate.ObjectId = Object_ContractPriceList.Id
                                                                       AND ObjectDate_EndDate.DescId   = zc_ObjectDate_ContractPriceList_EndDate()
                                                  LEFT JOIN ObjectLink AS OL_ContractPriceList_PriceList
                                                                       ON OL_ContractPriceList_PriceList.ObjectId = Object_ContractPriceList.Id
                                                                      AND OL_ContractPriceList_PriceList.DescId   = zc_ObjectLink_ContractPriceList_PriceList()
                                            )
              -- Результат
              INSERT INTO _tmpPriceList_onDate (OperDate, PriceListId, DescId)
                 SELECT COALESCE (inOperDatePartner, inOperDate_order) AS OperDate
                      , COALESCE (ObjectLink_Partner_PriceList.ChildObjectId
                                , tmpContract_PriceList.PriceListId
                              --, ObjectLink_Contract_PriceList.ChildObjectId
                                , ObjectLink_Juridical_PriceList.ChildObjectId
                                , zc_PriceList_Basis()
                                 ) AS PriceListId
                      , COALESCE (ObjectLink_Partner_PriceList.DescId
                                , tmpContract_PriceList.DescId
                              --, ObjectLink_Contract_PriceList.DescId
                                , ObjectLink_Juridical_PriceList.DescId
                                , 0
                                 ) AS DescId
                 FROM tmpPartner
                      LEFT JOIN tmpContract_PriceList ON tmpContract_PriceList.ContractId  = tmpPartner.ContractId
                                                     AND tmpContract_PriceList.PriceListId > 0
                                                     AND COALESCE (inOperDatePartner, inOperDate_order)
                                                         BETWEEN tmpContract_PriceList.StartDate AND tmpContract_PriceList.EndDate
                    /*LEFT JOIN ObjectLink AS ObjectLink_Contract_PriceList
                                           ON ObjectLink_Contract_PriceList.ObjectId = tmpPartner.ContractId
                                          AND ObjectLink_Contract_PriceList.DescId = zc_ObjectLink_Contract_PriceList()
                                          AND ObjectLink_Contract_PriceList.ChildObjectId > 0*/
                      LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList
                                           ON ObjectLink_Partner_PriceList.ObjectId = tmpPartner.PartnerId
                                          AND ObjectLink_Partner_PriceList.DescId = zc_ObjectLink_Partner_PriceList()
                                          AND ObjectLink_Partner_PriceList.ChildObjectId > 0
                      LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                                           ON ObjectLink_Juridical_PriceList.ObjectId = tmpPartner.JuridicalId
                                          AND ObjectLink_Juridical_PriceList.DescId = zc_ObjectLink_Juridical_PriceList()
                                          AND ObjectLink_Juridical_PriceList.ChildObjectId > 0
                 ;
          END IF;
          END IF;
          END IF;
      END IF;

      -- Результат
      RETURN QUERY
      SELECT tmpPriceList.OperDate
           , tmpPriceList.PriceListId
           , Object_PriceList.ValueData           AS PriceListName
           , ObjectBoolean_PriceWithVAT.ValueData AS PriceWithVAT
           , ObjectFloat_VATPercent.ValueData     AS VATPercent
           , tmpPriceList.DescId
           , ObjectLinkDesc.Code
           , ObjectLinkDesc.ItemName
      FROM _tmpPriceList_onDate AS tmpPriceList
           LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = tmpPriceList.PriceListId
           LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceWithVAT
                                   ON ObjectBoolean_PriceWithVAT.ObjectId = Object_PriceList.Id
                                  AND ObjectBoolean_PriceWithVAT.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()
           LEFT JOIN ObjectFloat AS ObjectFloat_VATPercent
                                 ON ObjectFloat_VATPercent.ObjectId = Object_PriceList.Id
                                AND ObjectFloat_VATPercent.DescId = zc_ObjectFloat_PriceList_VATPercent()
           LEFT JOIN ObjectLinkDesc ON ObjectLinkDesc.Id = tmpPriceList.DescId
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.06.15                                        *
*/

-- тест
-- SELECT * FROM lfGet_Object_Partner_PriceList_onDate (inContractId:= 347332, inPartnerId:= 348917, inMovementDescId:= zc_Movement_Sale(), inOperDate_order:= CURRENT_DATE, inOperDatePartner:= NULL, inDayPrior_PriceReturn:= 10, inIsPrior:= NULL, inOperDatePartner_order:= CURRENT_DATE)
