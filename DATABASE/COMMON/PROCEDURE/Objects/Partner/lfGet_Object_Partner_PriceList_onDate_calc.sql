-- Function: lfGet_Object_Partner_PriceList_onDate_calc (Integer, Integer, TDateTime)

DROP FUNCTION IF EXISTS lfGet_Object_Partner_PriceList_onDate_calc (Integer, Integer, Integer, TDateTime, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_Partner_PriceList_onDate_calc(
    IN inParam                  Integer, 
    IN inContractId             Integer, 
    IN inPartnerId              Integer,
    IN inOperDate               TDateTime,
    IN inInfoMoneyGroupId       Integer,
    IN inInfoMoneyDestinationId Integer,
    IN inInfoMoneyId            Integer
)
RETURNS TABLE (OperDate TDateTime, PriceListId Integer, PriceListName TVarChar, DescId Integer)
AS
$BODY$
BEGIN

       --
       /*IF inParam <> 1
       THEN inParam:= NULL;
       END IF;*/


       -- 2.1. ГП
       IF inParam = 21
       THEN IF inInfoMoneyGroupId <> zc_Enum_InfoMoneyGroup_10000() -- Основное сырье
           AND inInfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
           AND inInfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_30300() -- Доходы + Переработка
           AND inInfoMoneyId <> zc_Enum_InfoMoney_30103() -- Доходы + Продукция + Хлеб

            THEN RETURN QUERY
                 SELECT tmp.OperDate, tmp.PriceListId, tmp.PriceListName, tmp.DescId
                 FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := inContractId
                                                           , inPartnerId      := inPartnerId
                                                           , inMovementDescId := zc_Movement_Sale()
                                                           , inOperDate_order := inOperDate
                                                           , inOperDatePartner:= NULL
                                                           , inDayPrior_PriceReturn:= 14
                                                           , inIsPrior        := NULL
                                                           , inOperDatePartner_order:= inOperDate
                                                            ) AS tmp;
            ELSE RETURN QUERY
                 SELECT NULL :: TDateTime AS OperDate, NULL :: Integer AS PriceListId, '' :: TVarChar AS PriceListName, NULL :: Integer AS DescId;
            END IF;


       ELSE
       -- 2.2.1. ГП
       IF inParam = 221
       THEN IF inInfoMoneyGroupId <> zc_Enum_InfoMoneyGroup_10000() -- Основное сырье
           AND inInfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
           AND inInfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_30300() -- Доходы + Переработка
           AND inInfoMoneyId <> zc_Enum_InfoMoney_30103() -- Доходы + Продукция + Хлеб

            THEN RETURN QUERY
                 SELECT tmp.OperDate, tmp.PriceListId, tmp.PriceListName, tmp.DescId
                 FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := inContractId
                                                           , inPartnerId      := inPartnerId
                                                           , inMovementDescId := zc_Movement_ReturnIn()
                                                           , inOperDate_order := NULL
                                                           , inOperDatePartner:= inOperDate
                                                           , inDayPrior_PriceReturn:= 14
                                                           , inIsPrior        := FALSE
                                                           , inOperDatePartner_order:= NULL
                                                            ) AS tmp;
            ELSE RETURN QUERY
                 SELECT NULL :: TDateTime AS OperDate, NULL :: Integer AS PriceListId, '' :: TVarChar AS PriceListName, NULL :: Integer AS DescId;
            END IF;


       ELSE
       -- 2.2.2. ГП
       IF inParam = 222
       THEN IF inInfoMoneyGroupId <> zc_Enum_InfoMoneyGroup_10000() -- Основное сырье
           AND inInfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
           AND inInfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_30300() -- Доходы + Переработка
           AND inInfoMoneyId <> zc_Enum_InfoMoney_30103() -- Доходы + Продукция + Хлеб

            THEN RETURN QUERY
                 SELECT tmp.OperDate, tmp.PriceListId, tmp.PriceListName, tmp.DescId
                 FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := inContractId
                                                           , inPartnerId      := inPartnerId
                                                           , inMovementDescId := zc_Movement_ReturnIn()
                                                           , inOperDate_order := NULL
                                                           , inOperDatePartner:= inOperDate
                                                           , inDayPrior_PriceReturn:= 14
                                                           , inIsPrior        := TRUE
                                                           , inOperDatePartner_order:= NULL
                                                            ) AS tmp;
            ELSE RETURN QUERY
                 SELECT NULL :: TDateTime AS OperDate, NULL :: Integer AS PriceListId, '' :: TVarChar AS PriceListName, NULL :: Integer AS DescId;
            END IF;


       ELSE
       -- 4.1. Мясное сырье
       IF inParam = 41
       THEN IF inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
            OR inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30300() -- Доходы + Переработка
            THEN RETURN QUERY
                 SELECT tmp.OperDate, tmp.PriceListId, tmp.PriceListName, tmp.DescId
                 FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := inContractId
                                                           , inPartnerId      := inPartnerId
                                                           , inMovementDescId := zc_Movement_Sale()
                                                           , inOperDate_order := NULL
                                                           , inOperDatePartner:= inOperDate
                                                           , inDayPrior_PriceReturn:= 14
                                                           , inIsPrior        := NULL
                                                           , inOperDatePartner_order:= NULL
                                                            ) AS tmp;
            ELSE RETURN QUERY
                 SELECT NULL :: TDateTime AS OperDate, NULL :: Integer AS PriceListId, '' :: TVarChar AS PriceListName, NULL :: Integer AS DescId;
            END IF;

       ELSE
       -- 4.2. Мясное сырье
       IF inParam = 42
       THEN IF inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
            OR inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30300() -- Доходы + Переработка
            THEN RETURN QUERY
                 SELECT tmp.OperDate, tmp.PriceListId, tmp.PriceListName, tmp.DescId
                 FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := inContractId
                                                           , inPartnerId      := inPartnerId
                                                           , inMovementDescId := zc_Movement_ReturnIn()
                                                           , inOperDate_order := NULL
                                                           , inOperDatePartner:= inOperDate
                                                           , inDayPrior_PriceReturn:= 14
                                                           , inIsPrior        := NULL
                                                           , inOperDatePartner_order:= NULL
                                                            ) AS tmp;
            ELSE RETURN QUERY
                 SELECT NULL :: TDateTime AS OperDate, NULL :: Integer AS PriceListId, '' :: TVarChar AS PriceListName, NULL :: Integer AS DescId;
            END IF;

       ELSE
       -- 1. Приход
       IF inParam = 1
       THEN IF inInfoMoneyGroupId <> zc_Enum_InfoMoneyGroup_30000() -- Доходы
            THEN RETURN QUERY
                 SELECT tmp.OperDate, tmp.PriceListId, tmp.PriceListName, tmp.DescId
                 FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := inContractId
                                                           , inPartnerId      := inPartnerId
                                                           , inMovementDescId := zc_Movement_Income()
                                                           , inOperDate_order := NULL
                                                           , inOperDatePartner:= inOperDate
                                                           , inDayPrior_PriceReturn:= 14
                                                           , inIsPrior        := NULL
                                                           , inOperDatePartner_order:= NULL
                                                            ) AS tmp;
            ELSE RETURN QUERY
                 SELECT NULL :: TDateTime AS OperDate, NULL :: Integer AS PriceListId, '' :: TVarChar AS PriceListName, NULL :: Integer AS DescId;
            END IF;


       ELSE
       -- 3.1. Хлеб
       IF inParam = 31
       THEN IF inInfoMoneyId = zc_Enum_InfoMoney_30103() -- Доходы + Продукция + Хлеб
            THEN RETURN QUERY
                 SELECT tmp.OperDate, tmp.PriceListId, tmp.PriceListName, tmp.DescId
                 FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := inContractId
                                                           , inPartnerId      := inPartnerId
                                                           , inMovementDescId := zc_Movement_Sale()
                                                           , inOperDate_order := NULL
                                                           , inOperDatePartner:= inOperDate
                                                           , inDayPrior_PriceReturn:= 14
                                                           , inIsPrior        := NULL
                                                           , inOperDatePartner_order:= NULL
                                                            ) AS tmp;
            ELSE RETURN QUERY
                 SELECT NULL :: TDateTime AS OperDate, NULL :: Integer AS PriceListId, '' :: TVarChar AS PriceListName, NULL :: Integer AS DescId;
            END IF;


       ELSE
       -- 3.2. Хлеб
       IF inParam = 32
       THEN IF inInfoMoneyId = zc_Enum_InfoMoney_30103() -- Доходы + Продукция + Хлеб
            THEN RETURN QUERY
                 SELECT tmp.OperDate, tmp.PriceListId, tmp.PriceListName, tmp.DescId
                 FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := inContractId
                                                           , inPartnerId      := inPartnerId
                                                           , inMovementDescId := zc_Movement_ReturnIn()
                                                           , inOperDate_order := NULL
                                                           , inOperDatePartner:= inOperDate
                                                           , inDayPrior_PriceReturn:= 14
                                                           , inIsPrior        := NULL
                                                           , inOperDatePartner_order:= NULL
                                                            ) AS tmp;
            ELSE RETURN QUERY
                 SELECT NULL :: TDateTime AS OperDate, NULL :: Integer AS PriceListId, '' :: TVarChar AS PriceListName, NULL :: Integer AS DescId;
            END IF;


       ELSE RETURN QUERY
            SELECT NULL :: TDateTime AS OperDate, NULL :: Integer AS PriceListId, '' :: TVarChar AS PriceListName, NULL :: Integer AS DescId;

       END IF;
       END IF;
       END IF;
       END IF;
       END IF;
       END IF;
       END IF;
       END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.06.15                                        *
*/

-- тест
-- SELECT * FROM lfGet_Object_Partner_PriceList_onDate_calc (inParam:= 21, inContractId:= 347332, inPartnerId:= 348917, inOperDate:= '05.05.2015', inInfoMoneyGroupId:= 0, inInfoMoneyDestinationId:= 0, inInfoMoneyId:= 0)
