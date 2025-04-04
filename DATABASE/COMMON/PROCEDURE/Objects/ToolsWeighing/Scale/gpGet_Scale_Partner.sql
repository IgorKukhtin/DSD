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

             , isMovement    Boolean, CountMovement   TFloat   -- Накладная
             , isAccount     Boolean, CountAccount    TFloat   -- Счет
             , isTransport   Boolean, CountTransport  TFloat   -- ТТН
             , isQuality     Boolean, CountQuality    TFloat   -- Качественное
             , isPack        Boolean, CountPack       TFloat   -- Упаковочный
             , isSpec        Boolean, CountSpec       TFloat   -- Спецификация
             , isTax         Boolean, CountTax        TFloat   -- Налоговая
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
                                        , tmp.isMovement, tmp.CountMovement
                                        , tmp.isAccount, tmp.CountAccount
                                        , tmp.isTransport, tmp.CountTransport
                                        , tmp.isQuality, tmp.CountQuality
                                        , tmp.isPack, tmp.CountPack
                                        , tmp.isSpec, tmp.CountSpec
                                        , tmp.isTax, tmp.CountTax
                                   FROM lpGet_Object_Juridical_PrintKindItem ((SELECT tmpPartnerJuridical.JuridicalId FROM tmpPartnerJuridical LIMIT 1)) AS tmp
                                  )
           , tmpJuridical_find AS (SELECT DISTINCT tmpPartnerJuridical.JuridicalId FROM tmpPartnerJuridical)
            , tmpContract_find AS (SELECT tmpJuridical_find.JuridicalId               AS JuridicalId
                                        , OL_Contract.ObjectId                        AS ContractId
                                        , Object_Contract.ObjectCode                  AS ContractCode
                                        , Object_Contract.ValueData                   AS InvNumber
                                        , Object_Contract.isErased                    AS isErased
                                        , Object_ContractTag.ValueData                AS ContractTagName
                                        , ObjectLink_Contract_PaidKind.ChildObjectId  AS PaidKindId
                                        , ObjectLink_Contract_InfoMoney.ChildObjectId AS InfoMoneyId
                                        , COALESCE (ObjectLink_Contract_ContractStateKind.ChildObjectId, 0) AS ContractStateKindId
                                   FROM tmpJuridical_find
                                        INNER JOIN ObjectLink AS OL_Contract
                                                              ON OL_Contract.ChildObjectId = tmpJuridical_find.JuridicalId
                                                             AND OL_Contract.DescId        = zc_ObjectLink_Contract_Juridical()
                                        LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = OL_Contract.ObjectId

                                        LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractTag
                                                             ON ObjectLink_Contract_ContractTag.ObjectId = OL_Contract.ObjectId
                                                            AND ObjectLink_Contract_ContractTag.DescId   = zc_ObjectLink_Contract_ContractTag()
                                        LEFT JOIN Object AS Object_ContractTag ON Object_ContractTag.Id = ObjectLink_Contract_ContractTag.ChildObjectId

                                        LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                                             ON ObjectLink_Contract_InfoMoney.ObjectId = OL_Contract.ObjectId
                                                            AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()

                                        LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                                                             ON ObjectLink_Contract_PaidKind.ObjectId = OL_Contract.ObjectId
                                                            AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
                                        LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractStateKind
                                                             ON ObjectLink_Contract_ContractStateKind.ObjectId = OL_Contract.ObjectId
                                                            AND ObjectLink_Contract_ContractStateKind.DescId = zc_ObjectLink_Contract_ContractStateKind() 
                                  )
 --          , tmpContract_find AS (SELECT Object_Contract_View.* FROM tmpContract_find2 INNER JOIN Object_Contract_View ON Object_Contract_View.ContractId = tmpContract_find2.ContractId)
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
                                         LEFT JOIN tmpContract_find AS Object_Contract_View
                                                                    ON Object_Contract_View.JuridicalId = tmpPartnerJuridical.JuridicalId
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
                   WHEN inInfoMoneyId = zc_Enum_InfoMoney_30101() -- Доходы + Продукция
                    AND ObjectLink_Juridical_Retail.ChildObjectId IN (310855) -- Варус
                        THEN 1.5
                   ELSE 1
              END :: TFloat AS ChangePercentAmount

            , COALESCE (ObjectBoolean_Partner_EdiOrdspr.ValueData,  FALSE) :: Boolean AS isEdiOrdspr
            , COALESCE (ObjectBoolean_Partner_EdiInvoice.ValueData, FALSE) :: Boolean AS isEdiInvoice
            , COALESCE (ObjectBoolean_Partner_EdiDesadv.ValueData,  FALSE) :: Boolean AS isEdiDesadv

            , CASE WHEN tmpJuridicalPrint.isPack = TRUE OR tmpJuridicalPrint.isSpec = TRUE THEN COALESCE (tmpJuridicalPrint.isMovement, FALSE) ELSE TRUE END :: Boolean AS isMovement
            , CASE WHEN tmpJuridicalPrint.CountMovement > 0 THEN tmpJuridicalPrint.CountMovement ELSE 2 END :: TFloat AS CountMovement
            , COALESCE (tmpJuridicalPrint.isAccount,   FALSE) :: Boolean AS isAccount,   COALESCE (tmpJuridicalPrint.CountAccount, 0)        :: TFloat  AS CountAccount
            , CASE WHEN Object_PaidKind.Id = zc_Enum_PaidKind_FirstForm() THEN TRUE ELSE COALESCE (tmpJuridicalPrint.isTransport, FALSE) END :: Boolean AS isTransport
            , CASE WHEN Object_PaidKind.Id = zc_Enum_PaidKind_FirstForm() THEN 1    ELSE COALESCE (tmpJuridicalPrint.CountTransport, 0)  END :: TFloat  AS CountTransport
              -- Доходы + Мясное сырье
            , CASE WHEN inInfoMoneyId = zc_Enum_InfoMoney_30201() THEN TRUE ELSE COALESCE (tmpJuridicalPrint.isQuality,   FALSE)         END :: Boolean AS isQuality
            , CASE WHEN inInfoMoneyId = zc_Enum_InfoMoney_30201() THEN 1    ELSE COALESCE (tmpJuridicalPrint.CountQuality, 0)            END :: TFloat  AS CountQuality
            , COALESCE (tmpJuridicalPrint.isPack,      FALSE) :: Boolean AS isPack     , COALESCE (tmpJuridicalPrint.CountPack, 0)           :: TFloat  AS CountPack
            , COALESCE (tmpJuridicalPrint.isSpec,      FALSE) :: Boolean AS isSpec     , COALESCE (tmpJuridicalPrint.CountSpec, 0)           :: TFloat  AS CountSpec
            , COALESCE (tmpJuridicalPrint.isTax,       FALSE) :: Boolean AS isTax      , COALESCE (tmpJuridicalPrint.CountTax, 0)            :: TFloat  AS CountTax
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
                  , zfCalc_GoodsPropertyId (tmpPartnerContract_find.ContractId, tmpPartnerContract_find.JuridicalId, tmpPartnerContract_find.PartnerId) AS GoodsPropertyId
                  , lfGet_Object_Partner_PriceList_onDate_get (tmpPartnerContract_find.ContractId
                                                             , tmpPartnerContract_find.PartnerId
                                                             , inMovementDescId
                                                             , NULL :: TDateTime
                                                             , inOperDate
                                                             , FALSE
                                                             , NULL :: TDateTime
                                                              ) AS PriceListId

             FROM tmpPartnerContract_find
            ) AS tmpPartner
            LEFT JOIN tmpJuridicalPrint ON tmpJuridicalPrint.JuridicalId = tmpPartner.JuridicalId

            LEFT JOIN Object_ContractCondition_PercentView ON Object_ContractCondition_PercentView.ContractId = tmpPartner.ContractId
                                                          AND inOperDate BETWEEN Object_ContractCondition_PercentView.StartDate AND Object_ContractCondition_PercentView.EndDate
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
            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = tmpPartner.JuridicalId
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
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
                                 AND Object_ArticleLoss.DescId     = zc_Object_ArticleLoss()
                                 AND Object_ArticleLoss.isErased   = FALSE
                                 AND inPartnerCode > 0
                                 AND inInfoMoneyId >=0 
                              UNION
                               -- zc_Object_Member() OR zc_Object_Car()
                               SELECT Object_Member.DescId         AS ObjectDescId
                                    , Object_Member.Id             AS PartnerId
                                    , Object_Member.ObjectCode     AS PartnerCode
                                    , Object_Member.ValueData      AS PartnerName
                               FROM Object AS Object_Member
                               WHERE Object_Member.ObjectCode = inPartnerCode
                                 AND Object_Member.DescId     = (-1 * inInfoMoneyId)
                                 AND Object_Member.isErased   = FALSE
                                 AND inPartnerCode > 0
                                 AND inInfoMoneyId IN (-1 * zc_Object_Member(), -1 * zc_Object_Car())
                              )
       -- zc_Object_ArticleLoss() OR zc_Object_Member() OR zc_Object_Car()
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

            , TRUE        :: Boolean AS isMovement,  2 :: TFloat AS CountMovement
            , FALSE       :: Boolean AS isAccount,   0 :: TFloat AS CountAccount
            , FALSE       :: Boolean AS isTransport, 0 :: TFloat AS CountTransport
            , FALSE       :: Boolean AS isQuality,   0 :: TFloat AS CountQuality
            , FALSE       :: Boolean AS isPack   ,   0 :: TFloat AS CountPack
            , FALSE       :: Boolean AS isSpec   ,   0 :: TFloat AS CountSpec
            , FALSE       :: Boolean AS isTax    ,   0 :: TFloat AS CountTax

       FROM tmpArticleLoss
            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = zc_PriceList_Basis()
            LEFT JOIN ObjectLink AS ObjectLink_ArticleLoss_ProfitLossDirection
                                 ON ObjectLink_ArticleLoss_ProfitLossDirection.ObjectId = tmpArticleLoss.PartnerId
                                AND ObjectLink_ArticleLoss_ProfitLossDirection.DescId = zc_ObjectLink_ArticleLoss_ProfitLossDirection()
            LEFT JOIN Object_ProfitLossDirection_View AS View_ProfitLossDirection ON View_ProfitLossDirection.ProfitLossDirectionId = ObjectLink_ArticleLoss_ProfitLossDirection.ChildObjectId
      ;
   ELSE
   IF inMovementDescId IN (zc_Movement_Send())
   THEN
       -- Результат для zc_Object_Member() OR zc_Object_Car()
       RETURN QUERY
       WITH tmpMember AS (SELECT Object_Member.DescId         AS ObjectDescId
                               , Object_Member.Id             AS PartnerId
                               , Object_Member.ObjectCode     AS PartnerCode
                               , Object_Member.ValueData      AS PartnerName
                               , Object_Unit.ObjectCode       AS UnitCode
                               , Object_Unit.ValueData        AS UnitName
                          FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                               INNER JOIN Object AS Object_Member ON Object_Member.Id = lfSelect.MemberId
                               LEFT  JOIN Object AS Object_Unit   ON Object_Unit.Id   = lfSelect.UnitId
                          WHERE lfSelect.UnitId NOT IN (954062) -- Отдел Х
                            AND Object_Member.ObjectCode = inPartnerCode
                            AND Object_Member.DescId     = zc_Object_Member()
                            AND Object_Member.isErased   = FALSE
                            AND inPartnerCode > 0
                         UNION
                          SELECT Object_Member.DescId         AS ObjectDescId
                               , Object_Member.Id             AS PartnerId
                               , Object_Member.ObjectCode     AS PartnerCode
                               , TRIM (COALESCE (Object_CarModel.ValueData, '')|| COALESCE (' ' || Object_CarType.ValueData, '')  || ' ' || COALESCE (Object_Member.ValueData, '')) AS PartnerName
                               
                               , COALESCE (Object_PersonalDriver.ObjectCode, Object_Unit.ObjectCode)  AS UnitCode
                               , COALESCE (Object_PersonalDriver.ValueData,  Object_Unit.ValueData)   AS UnitName
                          FROM Object AS Object_Member
                               LEFT JOIN lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                                                                                         ON lfSelect.MemberId    = Object_Member.Id
                                                                                        AND Object_Member.DescId = zc_Object_Member()
                               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = lfSelect.UnitId

                               LEFT JOIN ObjectLink AS Car_CarModel
                                                    ON Car_CarModel.ObjectId = Object_Member.Id
                                                   AND Car_CarModel.DescId   = zc_ObjectLink_Car_CarModel()
                               LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = Car_CarModel.ChildObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                                    ON ObjectLink_Car_CarType.ObjectId = Object_Member.Id
                                                   AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
                               LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_Car_PersonalDriver
                                                    ON ObjectLink_Car_PersonalDriver.ObjectId = Object_Member.Id
                                                   AND ObjectLink_Car_PersonalDriver.DescId   = zc_ObjectLink_Car_PersonalDriver()
                               LEFT JOIN Object AS Object_PersonalDriver ON Object_PersonalDriver.Id = ObjectLink_Car_PersonalDriver.ChildObjectId

                          WHERE Object_Member.ObjectCode = inPartnerCode
                            AND Object_Member.DescId     = (-1 * inInfoMoneyId)
                            AND Object_Member.isErased   = FALSE
                            AND inPartnerCode > 0
                            AND inInfoMoneyId IN (-1 * zc_Object_Member(), -1 * zc_Object_Car())
                         )
       SELECT tmpMember.ObjectDescId
            , tmpMember.PartnerId   :: Integer   AS PartnerId
            , tmpMember.PartnerCode :: Integer   AS PartnerCode
            , tmpMember.PartnerName :: TVarChar  AS PartnerName

            , NULL :: Integer  AS PaidKindId
            , ''   :: TVarChar AS PaidKindName

            , Object_PriceList.Id                  AS PriceListId
            , Object_PriceList.ObjectCode          AS PriceListCode
            , Object_PriceList.ValueData           AS PriceListName

            , (-1 * tmpMember.ObjectDescId) :: Integer AS ContractId
            , tmpMember.UnitCode             AS ContractCode
            , tmpMember.UnitCode :: TVarChar AS ContractNumber
            , tmpMember.UnitName             AS ContractTagName

            , NULL :: Integer AS GoodsPropertyId
            , NULL :: Integer AS GoodsPropertyCode
            , '' :: TVarChar  AS GoodsPropertyName

            , NULL :: TFloat AS ChangePercent
            , NULL :: TFloat AS ChangePercentAmount

            , FALSE       :: Boolean AS isEdiOrdspr
            , FALSE       :: Boolean AS isEdiInvoice
            , FALSE       :: Boolean AS isEdiDesadv

            , TRUE        :: Boolean AS isMovement,  2 :: TFloat AS CountMovement
            , FALSE       :: Boolean AS isAccount,   0 :: TFloat AS CountAccount
            , FALSE       :: Boolean AS isTransport, 0 :: TFloat AS CountTransport
            , FALSE       :: Boolean AS isQuality,   0 :: TFloat AS CountQuality
            , FALSE       :: Boolean AS isPack   ,   0 :: TFloat AS CountPack
            , FALSE       :: Boolean AS isSpec   ,   0 :: TFloat AS CountSpec
            , FALSE       :: Boolean AS isTax    ,   0 :: TFloat AS CountTax

       FROM tmpMember
            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = zc_PriceList_Basis()
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

                                                 , 346093 -- 22081	Склад ГП ф.Одесса	филиал Одесса
                                                 , 346094 -- 22082	Склад возвратов ф.Одесса	филиал Одесса

                                                 , 8411   -- 22021	Склад ГП ф.Киев	филиал Киев
                                                 , 428365 -- 22022	Склад возвратов ф.Киев	филиал Киев

                                                 , 8413   -- 22031	Склад ГП ф.Кривой Рог	филиал Кр.Рог
                                                 , 428366 -- 22032	Склад возвратов ф.Кривой Рог	филиал Кр.Рог

                                                 , 8417   -- 22051	Склад ГП ф.Николаев (Херсон)	филиал Николаев (Херсон)
                                                 , 428364 -- 22052	Склад возвратов ф.Николаев (Херсон)	филиал Николаев (Херсон)

                                                 , 8425   -- 22091	Склад ГП ф.Харьков	филиал Харьков
                                                 , 409007 -- 22092	Склад возвратов ф.Харьков	филиал Харьков

                                                 , 8415   -- 22041	Склад ГП ф.Черкассы (Кировоград)	филиал Черкассы (Кировоград)
                                                 , 428363 -- 22042	Склад возвратов ф.Черкассы (Кировоград)	филиал Черкассы (Кировоград)

                                                 , 3080691 -- Склад ГП ф.Львов
                                                 , 3080696 -- Склад возвратов ф.Львов

                                                 , 11921035 -- Склад ГП ф.Вінниця
                                                 , 11921036 -- Склад повернень ф.Вінниця
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

                                                 , 346093 -- 22081	Склад ГП ф.Одесса	филиал Одесса
                                                 , 346094 -- 22082	Склад возвратов ф.Одесса	филиал Одесса

                                                 , 8411   -- 22021	Склад ГП ф.Киев	филиал Киев
                                                 , 428365 -- 22022	Склад возвратов ф.Киев	филиал Киев

                                                 , 8413   -- 22031	Склад ГП ф.Кривой Рог	филиал Кр.Рог
                                                 , 428366 -- 22032	Склад возвратов ф.Кривой Рог	филиал Кр.Рог

                                                 , 8417   -- 22051	Склад ГП ф.Николаев (Херсон)	филиал Николаев (Херсон)
                                                 , 428364 -- 22052	Склад возвратов ф.Николаев (Херсон)	филиал Николаев (Херсон)

                                                 , 8425   -- 22091	Склад ГП ф.Харьков	филиал Харьков
                                                 , 409007 -- 22092	Склад возвратов ф.Харьков	филиал Харьков

                                                 , 8415   -- 22041	Склад ГП ф.Черкассы (Кировоград)	филиал Черкассы (Кировоград)
                                                 , 428363 -- 22042	Склад возвратов ф.Черкассы (Кировоград)	филиал Черкассы (Кировоград)

                                                 , 3080691 -- Склад ГП ф.Львов
                                                 , 3080696 -- Склад возвратов ф.Львов

                                                 , 11921035 -- Склад ГП ф.Вінниця
                                                 , 11921036 -- Склад повернень ф.Вінниця
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
                                            , 8413   -- 22031	Склад ГП ф.Кривой Рог	филиал Кр.Рог
                                            , 8417   -- 22051	Склад ГП ф.Николаев (Херсон)	филиал Николаев (Херсон)
                                            , 8425   -- 22091	Склад ГП ф.Харьков	филиал Харьков
                                            , 8415   -- 22041	Склад ГП ф.Черкассы (Кировоград)	филиал Черкассы (Кировоград)
                                             )
                        THEN 0
                        ELSE 0
              END :: TFloat AS ChangePercentAmount

            , FALSE       :: Boolean AS isEdiOrdspr
            , FALSE       :: Boolean AS isEdiInvoice
            , FALSE       :: Boolean AS isEdiDesadv

            , TRUE        :: Boolean AS isMovement,  2 :: TFloat AS CountMovement
            , FALSE       :: Boolean AS isAccount,   0 :: TFloat AS CountAccount
            , FALSE       :: Boolean AS isTransport, 0 :: TFloat AS CountTransport
            , FALSE       :: Boolean AS isQuality,   0 :: TFloat AS CountQuality
            , FALSE       :: Boolean AS isPack   ,   0 :: TFloat AS CountPack
            , FALSE       :: Boolean AS isSpec   ,   0 :: TFloat AS CountSpec
            , FALSE       :: Boolean AS isTax    ,   0 :: TFloat AS CountTax

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
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 21.01.15                                        *
*/

-- тест
-- SELECT * FROM gpGet_Scale_Partner (inOperDate:= '01.01.2015', inMovementDescId:= zc_Movement_Sale(), inPartnerCode:= '0', inInfoMoneyId:= zc_Enum_InfoMoney_30101(), inPaidKindId:=0, inSession:= zfCalc_UserAdmin())
