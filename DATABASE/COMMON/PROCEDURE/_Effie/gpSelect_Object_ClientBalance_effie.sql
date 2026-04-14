-- Function: gpSelect_Object_ClientBalance_effie

DROP FUNCTION IF EXISTS gpSelect_Object_ClientBalance_effie ( TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ClientBalance_effie(
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (ExtId                TVarChar   -- Идентификатор записи по долгам
             , employeeExtId        TVarChar   -- Идентификатор сотрудников
             , ttExtId              TVarChar   -- Идентификатор торговой точки
             , clientExtId          TVarChar   -- Идентификатор контрагента
             , contractHeaderExtId  TVarChar   -- Уникальный идентификатор контракта
             , balanceValue         TFloat     -- Текущая задолженность, Должно быть больше или равно чем balanceOverdue
             , balanceOverdue       TFloat     -- Просроченная задолженность
             , balanceDate          TVarChar   -- Дата формирования сальдо = current date (текущий РАБОЧИЙ день)
             , limitOverdue         Boolean    -- Превышение лимита по баллансу (false - отгрузка разрешена, true - блокировка отгрузок)
             , PaidKindId           Integer    -- Форма оплата - для внутреннего использования
             , PaidKindName         TVarChar   -- Форма оплата - для внутреннего использования
) AS

$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
     

     -- временная таблица Contract_Client
     CREATE TEMP TABLE _tmpContract_Client (PartnerId            Integer
                                          , ContractId           Integer
                                          , PaidKindId           Integer
                                          , PaidKindName         TVarChar
                                           ) ON COMMIT DROP;

     -- Данные Contract_Client
     INSERT INTO _tmpContract_Client (PartnerId, ContractId, PaidKindId, PaidKindName)
        SELECT DISTINCT
               gpSelect.clientExtId         :: Integer AS PartnerId
             , gpSelect.contractHeaderExtId :: Integer AS ContractId
             , gpSelect.PaidKindId
             , gpSelect.PaidKindName
        FROM gpSelect_Object_ContractHeaderClients_effie (inSession) AS gpSelect
       ;
          

     -- Формируются НОВЫЕ ключи
     INSERT INTO Object_ClientBalance_effie (PartnerId, ContractId, PaidKindId, InsertDate)
     SELECT _tmpContract_Client.PartnerId
          , _tmpContract_Client.ContractId
          , _tmpContract_Client.PaidKindId
          , CURRENT_TIMESTAMP AS InsertDate
      FROM _tmpContract_Client
           LEFT JOIN Object_ClientBalance_effie ON Object_ClientBalance_effie.PartnerId  = _tmpContract_Client.PartnerId
                                               AND Object_ClientBalance_effie.ContractId = _tmpContract_Client.ContractId
                                               AND Object_ClientBalance_effie.PaidKindId = _tmpContract_Client.PaidKindId
     WHERE Object_ClientBalance_effie.Id IS NULL
    ;


     --
     RETURN QUERY
     WITH tmpContainer AS (SELECT SUM (Container.Amount) AS Amount
                                , Object_ClientBalance_effie.PartnerId
                                , Object_ClientBalance_effie.ContractId
                                , Object_ClientBalance_effie.PaidKindId
                           FROM Object_ClientBalance_effie
                                INNER JOIN ContainerLinkObject AS CLO_Partner
                                                               ON CLO_Partner.ObjectId = Object_ClientBalance_effie.PartnerId
                                                              AND CLO_Partner.DescId = zc_ContainerLinkObject_Partner()
                                INNER JOIN ContainerLinkObject AS CLO_Contract
                                                               ON CLO_Contract.ContainerId = CLO_Partner.ContainerId
                                                              AND CLO_Contract.DescId      = zc_ContainerLinkObject_Contract()
                                                              AND CLO_Contract.ObjectId    = Object_ClientBalance_effie.ContractId
                                INNER JOIN ContainerLinkObject AS CLO_PaidKind
                                                               ON CLO_PaidKind.ContainerId = CLO_Partner.ContainerId
                                                              AND CLO_PaidKind.DescId      = zc_ContainerLinkObject_PaidKind()
                                                              AND CLO_PaidKind.ObjectId    = Object_ClientBalance_effie.PaidKindId
                                INNER JOIN Container ON Container.Id = CLO_Partner.ContainerId

                           -- Только НАЛ
                           WHERE Object_ClientBalance_effie.PaidKindId = zc_Enum_PaidKind_SecondForm()
                           GROUP BY Object_ClientBalance_effie.PartnerId
                                  , Object_ClientBalance_effie.ContractId
                                  , Object_ClientBalance_effie.PaidKindId
                           -- Только
                           HAVING SUM (Container.Amount) <> 0
                           
                          )
        , tmpTwins AS (SELECT gpSelect.ttExtId     :: Integer AS ttExtId
                            , gpSelect.clientExtId :: Integer AS PartnerId
                       FROM gpSelect_Object_Twins_effie (inSession) AS gpSelect
                      )
     -- Результат
     SELECT Object_ClientBalance_effie.Id          :: TVarChar AS ExtId
          , Object_Member.Id                       :: TVarChar AS employeeExtId
          , tmpTwins.ttExtId                       :: TVarChar AS ttExtId
          , Object_ClientBalance_effie.PartnerId   :: TVarChar AS clientExtId
          , Object_ClientBalance_effie.ContractId  :: TVarChar AS contractHeaderExtId

            -- Текущая задолженность, Должно быть больше или равно чем balanceOverdue
          , COALESCE (tmpContainer.Amount, 0)      :: TFloat   AS balanceValue
            -- Просроченная задолженность
          , tmpContainer.Amount                    :: TFloat   AS balanceOverdue

          , zfConvert_DateToString (CURRENT_DATE)  :: TVarChar AS balanceDate

            -- Превышение лимита по баллансу (false - отгрузка разрешена, true - блокировка отгрузок)
          , FALSE                                  :: Boolean  AS limitOverdue

          , _tmpContract_Client.PaidKindId
          , _tmpContract_Client.PaidKindName

     FROM Object_ClientBalance_effie
          -- информативно
          LEFT JOIN _tmpContract_Client ON _tmpContract_Client.PartnerId  = Object_ClientBalance_effie.PartnerId
                                       AND _tmpContract_Client.ContractId = Object_ClientBalance_effie.ContractId 
                                       AND _tmpContract_Client.PaidKindId = Object_ClientBalance_effie.PaidKindId 
          -- Долги
          LEFT JOIN tmpContainer ON tmpContainer.PartnerId  = Object_ClientBalance_effie.PartnerId
                                AND tmpContainer.ContractId = Object_ClientBalance_effie.ContractId 
                                AND tmpContainer.PaidKindId = Object_ClientBalance_effie.PaidKindId 
          -- нашли ТТ
          LEFT JOIN tmpTwins ON tmpTwins.PartnerId = Object_ClientBalance_effie.PartnerId

          -- нашли Сотрудника
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Personal
                               ON ObjectLink_Partner_Personal.ObjectId = _tmpContract_Client.PartnerId
                              AND ObjectLink_Partner_Personal.DescId IN (zc_ObjectLink_Partner_Personal()
                                                                     --, zc_ObjectLink_Partner_PersonalTrade()
                                                                     --, zc_ObjectLink_Partner_PersonalMerch()
                                                                        )
          INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                ON ObjectLink_Personal_Member.ObjectId = ObjectLink_Partner_Personal.ChildObjectId
                               AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                               AND ObjectLink_Personal_Member.ChildObjectId  > 0
          -- Сотрудник не удален
          INNER JOIN Object AS Object_Member ON Object_Member.Id       = ObjectLink_Personal_Member.ChildObjectId
                                            AND Object_Member.isErased = FALSE
     WHERE tmpContainer.Amount <> 0 AND tmpTwins.ttExtId :: Integer > 0
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.03.26         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ClientBalance_effie (zfCalc_UserAdmin()::TVarChar);
