-- Function: gpGet_Scale_Partner()

-- DROP FUNCTION IF EXISTS gpGet_Scale_Partner (TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Scale_Partner (TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Scale_Partner (TDateTime, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Scale_Partner (TDateTime, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Scale_Partner(
    IN inOperDate       TDateTime   ,
    IN inMovementDescId Integer     ,
    IN inPartnerCode    Integer     ,
    IN inInfoMoneyId    Integer     ,
    IN inPaidKindId     Integer     ,
    IN inSession        TVarChar      -- сессия пользователя
)
RETURNS TABLE (ObjectDescId Integer
             , PartnerId    Integer
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

             , isMovement    Boolean   -- Накладная
             , isAccount     Boolean   -- Счет
             , isTransport   Boolean   -- ТТН
             , isQuality     Boolean   -- Качественное
             , isPack        Boolean   -- Упаковочный
             , isSpec        Boolean   -- Спецификация
             , isTax         Boolean   -- Налоговая
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbBranchId_Constraint Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);


   -- определяется уровень доступа
   vbBranchId_Constraint:= COALESCE ((SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId), 0);


   IF inMovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut(), zc_Movement_Sale(), zc_Movement_ReturnIn())
   THEN
       -- Результат для Partner
       RETURN QUERY
       WITH tmpPartner_find AS (SELECT Object_Partner.DescId         AS ObjectDescId
                                     , Object_Partner.Id             AS PartnerId
                                     , Object_Partner.ObjectCode     AS PartnerCode
                                     , Object_Partner.ValueData      AS PartnerName
                                FROM Object AS Object_Partner
                                WHERE Object_Partner.ObjectCode = inPartnerCode
                                  AND Object_Partner.DescId     = zc_Object_Partner()
                                  AND Object_Partner.isErased   = FALSE
                                  AND inPartnerCode > 0
                               UNION ALL
                                SELECT Object_Partner.DescId         AS ObjectDescId
                                     , Object_Partner.Id             AS PartnerId
                                     , Object_Partner.ObjectCode     AS PartnerCode
                                     , Object_Partner.ValueData      AS PartnerName
                                FROM Object AS Object_Partner
                                WHERE Object_Partner.Id = -1 * inPartnerCode
                                  AND Object_Partner.DescId = zc_Object_Partner()
                                  AND inPartnerCode < 0
                               )
         , tmpPartnerJuridical AS (SELECT tmpPartner_find.ObjectDescId
                                        , tmpPartner_find.PartnerId
                                        , tmpPartner_find.PartnerCode
                                        , tmpPartner_find.PartnerName
                                        , ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                                    FROM tmpPartner_find
                                         LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                              ON ObjectLink_Partner_Juridical.ObjectId = tmpPartner_find.PartnerId
                                                             AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                  )
           , tmpJuridicalPrint AS (SELECT tmp.Id AS JuridicalId
                                        , tmp.isMovement
                                        , tmp.isAccount
                                        , tmp.isTransport
                                        , tmp.isQuality
                                        , tmp.isPack
                                        , tmp.isSpec
                                        , tmp.isTax
                                   FROM lpGet_Object_Juridical_PrintKindItem ((SELECT tmpPartnerJuridical.JuridicalId FROM tmpPartnerJuridical LIMIT 1)) AS tmp
                                  )
           , tmpPartnerContract AS (SELECT tmpPartnerJuridical.ObjectDescId
                                         , tmpPartnerJuridical.PartnerId
                                         , tmpPartnerJuridical.PartnerCode
                                         , tmpPartnerJuridical.PartnerName
                                         , Object_Contract_View.ContractId
                                         , Object_Contract_View.ContractCode     AS ContractCode
                                         , Object_Contract_View.InvNumber        AS ContractNumber
                                         , Object_Contract_View.ContractTagName  AS ContractTagName
                                         , Object_Contract_View.PaidKindId       AS PaidKindId
                                         , Object_Contract_View.InfoMoneyId      AS InfoMoneyId
                                         , tmpPartnerJuridical.JuridicalId
                                    FROM tmpPartnerJuridical
                                         LEFT JOIN Object_Contract_View ON Object_Contract_View.JuridicalId = tmpPartnerJuridical.JuridicalId
                                                                       AND Object_Contract_View.InfoMoneyId IN (inInfoMoneyId, zc_Enum_InfoMoney_30301()) -- Доходы + Переработка + Переработка
                                                                       AND Object_Contract_View.isErased = FALSE
                                                                       AND Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                    )
      , tmpPartnerContract_find AS (SELECT tmpPartnerContract.ObjectDescId
                                         , tmpPartnerContract.PartnerId
                                         , tmpPartnerContract.PartnerCode
                                         , tmpPartnerContract.PartnerName
                                         , tmpPartnerContract.ContractId
                                         , tmpPartnerContract.ContractCode
                                         , tmpPartnerContract.ContractNumber
                                         , tmpPartnerContract.ContractTagName
                                         , tmpPartnerContract.PaidKindId
                                         , tmpPartnerContract.InfoMoneyId
                                         , tmpPartnerContract.JuridicalId
                                    FROM tmpPartnerContract
                                    WHERE tmpPartnerContract.PaidKindId = inPaidKindId
                                   UNION ALL
                                    SELECT tmpPartnerContract.ObjectDescId
                                         , tmpPartnerContract.PartnerId
                                         , tmpPartnerContract.PartnerCode
                                         , tmpPartnerContract.PartnerName
                                         , tmpPartnerContract.ContractId
                                         , tmpPartnerContract.ContractCode
                                         , tmpPartnerContract.ContractNumber
                                         , tmpPartnerContract.ContractTagName
                                         , tmpPartnerContract.PaidKindId
                                         , tmpPartnerContract.InfoMoneyId
                                         , tmpPartnerContract.JuridicalId
                                    FROM tmpPartnerContract
                                         LEFT JOIN tmpPartnerContract AS tmpPartnerContract_two ON tmpPartnerContract_two.PaidKindId = inPaidKindId
                                    WHERE tmpPartnerContract_two.PaidKindId IS NULL
                                    )

       SELECT tmpPartner.ObjectDescId
            , tmpPartner.PartnerId
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
            , CASE WHEN inMovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut())
                        THEN 0
                   WHEN tmpPartner.InfoMoneyId = zc_Enum_InfoMoney_30301() -- Доходы + Переработка + Переработка
                        THEN 0
                   WHEN inInfoMoneyId = zc_Enum_InfoMoney_30201() -- Доходы + Мясное сырье
                    AND tmpPartner.JuridicalId = 15384            -- Фізична особа-підприємець Соколюк Аліса Борисівна
                        THEN 1
                   WHEN inInfoMoneyId = zc_Enum_InfoMoney_30201() -- Доходы + Мясное сырье
                        THEN 0
                   WHEN tmpPartner.PartnerCode IN (12345678) -- ???
                        THEN 1
                   ELSE 1
              END :: TFloat AS ChangePercentAmount

            , COALESCE (ObjectBoolean_Partner_EdiOrdspr.ValueData,  FALSE) :: Boolean AS isEdiOrdspr
            , COALESCE (ObjectBoolean_Partner_EdiInvoice.ValueData, FALSE) :: Boolean AS isEdiInvoice
            , COALESCE (ObjectBoolean_Partner_EdiDesadv.ValueData,  FALSE) :: Boolean AS isEdiDesadv

            , CASE WHEN tmpJuridicalPrint.isPack = TRUE OR tmpJuridicalPrint.isSpec = TRUE THEN COALESCE (tmpJuridicalPrint.isMovement, FALSE) ELSE TRUE END :: Boolean AS isMovement
            , COALESCE (tmpJuridicalPrint.isAccount,   FALSE) :: Boolean AS isAccount
            , COALESCE (tmpJuridicalPrint.isTransport, FALSE) :: Boolean AS isTransport
            , COALESCE (tmpJuridicalPrint.isQuality,   FALSE) :: Boolean AS isQuality
            , COALESCE (tmpJuridicalPrint.isPack,      FALSE) :: Boolean AS isPack
            , COALESCE (tmpJuridicalPrint.isSpec,      FALSE) :: Boolean AS isSpec
            , COALESCE (tmpJuridicalPrint.isTax,       FALSE) :: Boolean AS isTax

       FROM (SELECT tmpPartnerContract_find.ObjectDescId
                  , tmpPartnerContract_find.PartnerId
                  , tmpPartnerContract_find.PartnerCode
                  , tmpPartnerContract_find.PartnerName
                  , tmpPartnerContract_find.ContractId
                  , tmpPartnerContract_find.ContractCode
                  , tmpPartnerContract_find.ContractNumber
                  , tmpPartnerContract_find.ContractTagName
                  , tmpPartnerContract_find.PaidKindId
                  , tmpPartnerContract_find.InfoMoneyId
                  , tmpPartnerContract_find.JuridicalId
                  , zfCalc_GoodsPropertyId (tmpPartnerContract_find.ContractId, tmpPartnerContract_find.JuridicalId) AS GoodsPropertyId
                  , lfGet_Object_Partner_PriceList_record (tmpPartnerContract_find.ContractId, tmpPartnerContract_find.PartnerId, inOperDate) AS PriceListId

             FROM tmpPartnerContract_find
            ) AS tmpPartner
            LEFT JOIN tmpJuridicalPrint ON tmpJuridicalPrint.JuridicalId = tmpPartner.JuridicalId

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
   ELSE
   IF inMovementDescId IN (zc_Movement_Loss())
   THEN
       -- Результат для ArticleLoss
       RETURN QUERY
       WITH tmpArticleLoss AS (SELECT Object_ArticleLoss.DescId         AS ObjectDescId
                                    , Object_ArticleLoss.Id             AS PartnerId
                                    , Object_ArticleLoss.ObjectCode     AS PartnerCode
                                    , Object_ArticleLoss.ValueData      AS PartnerName
                               FROM Object AS Object_ArticleLoss
                               WHERE Object_ArticleLoss.ObjectCode = inPartnerCode
                                 AND Object_ArticleLoss.DescId = zc_Object_ArticleLoss()
                                 AND Object_ArticleLoss.isErased = FALSE
                                 AND inPartnerCode > 0
                              )
       SELECT tmpArticleLoss.ObjectDescId
            , tmpArticleLoss.PartnerId
            , tmpArticleLoss.PartnerCode
            , tmpArticleLoss.PartnerName
            , NULL :: Integer AS PaidKindId
            , '' :: TVarChar  AS PaidKindName

            , Object_PriceList.Id                  AS PriceListId
            , Object_PriceList.ObjectCode          AS PriceListCode
            , Object_PriceList.ValueData           AS PriceListName

            , NULL :: Integer AS ContractId
            , View_ProfitLossDirection.ProfitLossDirectionCode             AS ContractCode
            , View_ProfitLossDirection.ProfitLossDirectionCode :: TVarChar AS ContractNumber
            , View_ProfitLossDirection.ProfitLossDirectionName             AS ContractTagName

            , NULL :: Integer AS GoodsPropertyId
            , NULL :: Integer AS GoodsPropertyCode
            , '' :: TVarChar  AS GoodsPropertyName

            , NULL :: TFloat AS ChangePercent
            , NULL :: TFloat AS ChangePercentAmount

            , FALSE       :: Boolean AS isEdiOrdspr
            , FALSE       :: Boolean AS isEdiInvoice
            , FALSE       :: Boolean AS isEdiDesadv

            , TRUE        :: Boolean AS isMovement
            , FALSE       :: Boolean AS isAccount
            , FALSE       :: Boolean AS isTransport
            , FALSE       :: Boolean AS isQuality
            , FALSE       :: Boolean AS isPack
            , FALSE       :: Boolean AS isSpec
            , FALSE       :: Boolean AS isTax

       FROM tmpArticleLoss
            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = zc_PriceList_Basis()
            LEFT JOIN ObjectLink AS ObjectLink_ArticleLoss_ProfitLossDirection
                                 ON ObjectLink_ArticleLoss_ProfitLossDirection.ObjectId = tmpArticleLoss.PartnerId
                                AND ObjectLink_ArticleLoss_ProfitLossDirection.DescId = zc_ObjectLink_ArticleLoss_ProfitLossDirection()
            LEFT JOIN Object_ProfitLossDirection_View AS View_ProfitLossDirection ON View_ProfitLossDirection.ProfitLossDirectionId = ObjectLink_ArticleLoss_ProfitLossDirection.ChildObjectId
      ;
   ELSE
   IF inMovementDescId IN (zc_Movement_SendOnPrice())
   THEN
       -- Результат для Unit
       RETURN QUERY
       WITH tmpUnit AS (SELECT Object_Unit.DescId         AS ObjectDescId
                             , Object_Unit.Id             AS PartnerId
                             , Object_Unit.ObjectCode     AS PartnerCode
                             , Object_Unit.ValueData      AS PartnerName
                        FROM Object AS Object_Unit
                             LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                                  ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                                                 AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
                        WHERE Object_Unit.ObjectCode = inPartnerCode
                          AND Object_Unit.DescId = zc_Object_Unit()
                          AND Object_Unit.isErased = FALSE
                          AND inPartnerCode > 0
                          AND ((Object_Unit.Id IN (301309 -- 22121	Склад ГП ф.Запорожье	филиал Запорожье
                                                 , 309599 -- 22122	Склад возвратов ф.Запорожье	филиал Запорожье
                                                 , 8411   -- 22021	Склад ГП ф.Киев	филиал Киев
                                                 , 428365 -- 22022	Склад возвратов ф.Киев	филиал Киев
                                                 , 8413   -- 22031	Склад ГП ф.Кривой Рог	филиал Кр.Рог
                                                 , 428366 -- 22032	Склад возвратов ф.Кривой Рог	филиал Кр.Рог
                                                 , 8417   -- 22051	Склад ГП ф.Николаев (Херсон)	филиал Николаев (Херсон)
                                                 , 428364 -- 22052	Склад возвратов ф.Николаев (Херсон)	филиал Николаев (Херсон)
                                                 , 346093 -- 22081	Склад ГП ф.Одесса	филиал Одесса
                                                 , 346094 -- 22082	Склад возвратов ф.Одесса	филиал Одесса
                                                 , 8425   -- 22091	Склад ГП ф.Харьков	филиал Харьков
                                                 , 409007 -- 22092	Склад возвратов ф.Харьков	филиал Харьков
                                                 , 8415   -- 22041	Склад ГП ф.Черкассы (Кировоград)	филиал Черкассы (Кировоград)
                                                 , 428363 -- 22042	Склад возвратов ф.Черкассы (Кировоград)	филиал Черкассы (Кировоград)
                                                 )
                             AND (vbBranchId_Constraint = 0
                               OR vbUserId = zfCalc_UserAdmin() :: Integer)
                               )
                            OR ((ObjectLink_Unit_Parent.ChildObjectId = 8460 -- группа - Возвраты общие
                                 OR Object_Unit.Id = 8459) -- Склад Реализации
                                AND (vbBranchId_Constraint > 0
                                 OR vbUserId = zfCalc_UserAdmin() :: Integer))
                               )
                       UNION ALL
                        SELECT Object_Unit.DescId         AS ObjectDescId
                             , Object_Unit.Id             AS PartnerId
                             , Object_Unit.ObjectCode     AS PartnerCode
                             , Object_Unit.ValueData      AS PartnerName
                        FROM Object AS Object_Unit
                             LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                                  ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                                                 AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
                        WHERE Object_Unit.Id = -1 * inPartnerCode
                          AND Object_Unit.DescId = zc_Object_Unit()
                          AND Object_Unit.isErased = FALSE
                          AND inPartnerCode < 0
                          AND ((Object_Unit.Id IN (301309 -- 22121	Склад ГП ф.Запорожье	филиал Запорожье
                                                 , 309599 -- 22122	Склад возвратов ф.Запорожье	филиал Запорожье
                                                 , 8411   -- 22021	Склад ГП ф.Киев	филиал Киев
                                                 , 428365 -- 22022	Склад возвратов ф.Киев	филиал Киев
                                                 , 8413   -- 22031	Склад ГП ф.Кривой Рог	филиал Кр.Рог
                                                 , 428366 -- 22032	Склад возвратов ф.Кривой Рог	филиал Кр.Рог
                                                 , 8417   -- 22051	Склад ГП ф.Николаев (Херсон)	филиал Николаев (Херсон)
                                                 , 428364 -- 22052	Склад возвратов ф.Николаев (Херсон)	филиал Николаев (Херсон)
                                                 , 346093 -- 22081	Склад ГП ф.Одесса	филиал Одесса
                                                 , 346094 -- 22082	Склад возвратов ф.Одесса	филиал Одесса
                                                 , 8425   -- 22091	Склад ГП ф.Харьков	филиал Харьков
                                                 , 409007 -- 22092	Склад возвратов ф.Харьков	филиал Харьков
                                                 , 8415   -- 22041	Склад ГП ф.Черкассы (Кировоград)	филиал Черкассы (Кировоград)
                                                 , 428363 -- 22042	Склад возвратов ф.Черкассы (Кировоград)	филиал Черкассы (Кировоград)
                                                 )
                             AND (vbBranchId_Constraint = 0
                               OR vbUserId = zfCalc_UserAdmin() :: Integer)
                               )
                            OR ((ObjectLink_Unit_Parent.ChildObjectId = 8460 -- группа - Возвраты общие
                                 OR Object_Unit.Id = 8459) -- Склад Реализации
                                AND (vbBranchId_Constraint > 0
                                 OR vbUserId = zfCalc_UserAdmin() :: Integer))
                               )
                       )
       SELECT tmpUnit.ObjectDescId
            , tmpUnit.PartnerId
            , tmpUnit.PartnerCode
            , tmpUnit.PartnerName
            , NULL :: Integer AS PaidKindId
            , '' :: TVarChar  AS PaidKindName

            , Object_PriceList.Id                  AS PriceListId
            , Object_PriceList.ObjectCode          AS PriceListCode
            , Object_PriceList.ValueData           AS PriceListName

            , NULL :: Integer AS ContractId
            , View_AccountDirection.AccountDirectionCode             AS ContractCode
            , View_AccountDirection.AccountDirectionCode :: TVarChar AS ContractNumber
            , View_AccountDirection.AccountDirectionName             AS ContractTagName

            , NULL :: Integer AS GoodsPropertyId
            , NULL :: Integer AS GoodsPropertyCode
            , '' :: TVarChar  AS GoodsPropertyName

            , NULL :: TFloat AS ChangePercent
            , CASE WHEN tmpUnit.PartnerId IN (301309 -- Склад ГП ф.Запорожье
                                            , 346093 -- Склад ГП ф.Одесса
                                             )
                        THEN 0
                        ELSE 1
              END :: TFloat AS ChangePercentAmount

            , FALSE       :: Boolean AS isEdiOrdspr
            , FALSE       :: Boolean AS isEdiInvoice
            , FALSE       :: Boolean AS isEdiDesadv

            , TRUE        :: Boolean AS isMovement
            , FALSE       :: Boolean AS isAccount
            , FALSE       :: Boolean AS isTransport
            , FALSE       :: Boolean AS isQuality
            , FALSE       :: Boolean AS isPack
            , FALSE       :: Boolean AS isSpec
            , FALSE       :: Boolean AS isTax

       FROM tmpUnit
            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = zc_PriceList_Basis()
            LEFT JOIN ObjectLink AS ObjectLink_Unit_AccountDirection
                                 ON ObjectLink_Unit_AccountDirection.ObjectId = tmpUnit.PartnerId
                                AND ObjectLink_Unit_AccountDirection.DescId = zc_ObjectLink_Unit_AccountDirection()
            LEFT JOIN Object_AccountDirection_View AS View_AccountDirection ON View_AccountDirection.AccountDirectionId = ObjectLink_Unit_AccountDirection.ChildObjectId
      ;
   END IF;
   END IF;
   END IF;

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
-- SELECT * FROM gpGet_Scale_Partner (inOperDate:= '01.01.2015', inMovementDescId:= zc_Movement_SendOnPrice(),inPartnerCode:= '0', inPaidKindId:=0, inInfoMoneyId:= zc_Enum_InfoMoney_30101(), inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpGet_Scale_Partner (inOperDate:= '01.01.2015', inMovementDescId:= zc_Movement_Loss(),inPartnerCode:= '0', inPaidKindId:=0, inInfoMoneyId:= zc_Enum_InfoMoney_30101(), inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpGet_Scale_Partner (inOperDate:= '01.01.2015', inMovementDescId:= zc_Movement_Sale(),inPartnerCode:= '0', inPaidKindId:=0, inInfoMoneyId:= zc_Enum_InfoMoney_30101(), inSession:= zfCalc_UserAdmin())
