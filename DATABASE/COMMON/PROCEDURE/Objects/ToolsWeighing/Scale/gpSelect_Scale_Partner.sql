-- Function: gpSelect_Scale_Partner()

DROP FUNCTION IF EXISTS gpSelect_Scale_Partner (Integer, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpSelect_Scale_Partner (Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Scale_Partner (Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Scale_Partner(
    IN inIsGoodsComplete Boolean  , -- склад ГП/производство/упаковка or обвалка
    IN inBranchCode      Integer  , --
    IN inSession         TVarChar   -- сессия пользователя
)
RETURNS TABLE (PartnerId     Integer
             , PartnerCode   Integer
             , PartnerName   TVarChar
             , JuridicalName TVarChar
             , PaidKindId    Integer
             , PaidKindName  TVarChar
             , ContractId    Integer, ContractCode      Integer, ContractNumber    TVarChar, ContractTagName TVarChar
             , InfoMoneyId   Integer
             , InfoMoneyCode Integer
             , InfoMoneyName TVarChar
             , ChangePercent TFloat
             , ChangePercentAmount TFloat

             , isEdiOrdspr   Boolean
             , isEdiInvoice  Boolean
             , isEdiDesadv   Boolean

             , isMovement    Boolean, CountMovement   TFloat   -- Накладная
             , isAccount     Boolean, CountAccount    TFloat   -- Счет
             , isTransport   Boolean, CountTransport  TFloat   -- ТТН
             , isQuality     Boolean, CountQuality    TFloat   -- Качественное
             , isPack        Boolean, CountPack       TFloat   -- Упаковочный
             , isSpec        Boolean, CountSpec       TFloat   -- Спецификация
             , isTax         Boolean, CountTax        TFloat   -- Налоговая

             , ObjectDescId   Integer
             , MovementDescId Integer
             , ItemName       TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsIrna Boolean;

   DECLARE vbIsConstraint Boolean;
   DECLARE vbObjectId_Constraint Integer;
   DECLARE vbBranchId_Constraint Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Scale_Partner());
   vbUserId:= lpGetUserBySession (inSession);

   -- !!!Ирна!!!
   vbIsIrna:= zfCalc_User_isIrna (vbUserId);


   IF (inBranchCode > 1000)
   THEN


    -- Результат
    RETURN QUERY
       WITH tmpInfoMoney AS (-- 2.1.
                             SELECT View_InfoMoney_find.InfoMoneyId
                                  , View_InfoMoney_find.InfoMoneyGroupId
                                  , zc_Movement_Sale() AS MovementDescId
                             FROM Object_InfoMoney_View AS View_InfoMoney_find
                             WHERE (View_InfoMoney_find.InfoMoneyId IN (zc_Enum_InfoMoney_30101()) -- Доходы + Продукция + Готовая продукция
                                 OR View_InfoMoney_find.InfoMoneyId IN (zc_Enum_InfoMoney_30103()) -- Доходы + Продукция + Хлеб
                                 OR View_InfoMoney_find.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30300() -- Доходы + Переработка
                                                                                  )
                                   )
                            )
          , tmpPartner AS (SELECT DISTINCT
                                  Object_Partner.Id         AS PartnerId
                                , Object_Partner.ObjectCode AS PartnerCode
                                , Object_Partner.ValueData  AS PartnerName
                                , View_Contract.JuridicalId AS JuridicalId
                                , View_Contract.PaidKindId  AS PaidKindId
                                  /*-- преобразование, т.к. в гриде будет фильтр или для УП-приход, или УП-реализация
                                , CASE WHEN tmpInfoMoney.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_10000() -- Основное сырье
                                            THEN zc_Enum_InfoMoney_10101() -- Основное сырье + Мясное сырье + Живой вес
                                       WHEN tmpInfoMoney.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_30000() -- Доходы !!!не лишнее, т.к. ниже может понадобиться OR!!!
                                        AND tmpInfoMoney.InfoMoneyId = zc_Enum_InfoMoney_30101() -- Доходы + Продукция + Готовая продукция
                                            THEN zc_Enum_InfoMoney_30101()
                                       ELSE tmpInfoMoney.InfoMoneyId
                                  END AS InfoMoneyId*/
                                , View_Contract.InfoMoneyId
                                , zc_Movement_Sale() AS MovementDescId
                                , (View_Contract.ContractId) AS ContractId
                           FROM Object AS Object_Partner
                                LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                     ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                                                    AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                                                                               -- AND View_Contract.isErased = FALSE
                                                                               -- AND View_Contract.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                           LIMIT 1
                          )
          , tmpPrintKindItem AS (SELECT * FROM lpSelect_Object_PrintKindItem())

       SELECT tmpPartner.PartnerId
            , tmpPartner.PartnerCode
            , tmpPartner.PartnerName
            , Object_Juridical.ValueData           AS JuridicalName
            , Object_PaidKind.Id                   AS PaidKindId
            , Object_PaidKind.ValueData            AS PaidKindName

            , Object_Contract_View.ContractId      AS ContractId
            , Object_Contract_View.ContractCode    AS ContractCode
            , Object_Contract_View.InvNumber       AS ContractNumber
            , Object_Contract_View.ContractTagName AS ContractTagName

            , tmpPartner.InfoMoneyId
            , View_InfoMoney.InfoMoneyCode
            , View_InfoMoney.InfoMoneyName

            , Object_ContractCondition_PercentView.ChangePercent :: TFloat AS ChangePercent
            , CASE WHEN View_InfoMoney.InfoMoneyGroupId IN (zc_Enum_InfoMoneyGroup_10000() -- Основное сырье
                                                          , zc_Enum_InfoMoneyGroup_20000() -- Общефирменные
                                                           )
                        THEN 0 -- !!!поставщики!!!!
                   WHEN inIsGoodsComplete = FALSE
                    AND tmpPartner.JuridicalId = 15384 -- Фізична особа-підприємець Соколюк Аліса Борисівна
                        THEN 1 -- покупатели сырья, захардкодил
                   WHEN inIsGoodsComplete = FALSE
                        THEN 0 -- покупатели сырья, ВСЕ
                   WHEN tmpPartner.PartnerCode IN (12345678) -- ???
                        THEN 1 -- покупатели гп, может надо будет захардкодить
                   ELSE 1 -- покупатели гп, ВСЕ
              END :: TFloat AS ChangePercentAmount

            , COALESCE (ObjectBoolean_Partner_EdiOrdspr.ValueData, FALSE)  :: Boolean AS isEdiOrdspr
            , COALESCE (ObjectBoolean_Partner_EdiInvoice.ValueData, FALSE) :: Boolean AS isEdiInvoice
            , COALESCE (ObjectBoolean_Partner_EdiDesadv.ValueData, FALSE)  :: Boolean AS isEdiDesadv

            , CASE WHEN tmpPrintKindItem.isPack = TRUE OR tmpPrintKindItem.isSpec = TRUE THEN COALESCE (tmpPrintKindItem.isMovement, FALSE) ELSE TRUE END :: Boolean AS isMovement
            , CASE WHEN tmpPrintKindItem.CountMovement > 0 THEN tmpPrintKindItem.CountMovement ELSE 2 END :: TFloat AS CountMovement
            , COALESCE (tmpPrintKindItem.isAccount, FALSE)   :: Boolean AS isAccount,   COALESCE (tmpPrintKindItem.CountAccount, 0)   :: TFloat  AS CountAccount
            , COALESCE (tmpPrintKindItem.isTransport, FALSE) :: Boolean AS isTransport, COALESCE (tmpPrintKindItem.CountTransport, 0) :: TFloat  AS CountTransport
            , CASE WHEN inBranchCode BETWEEN 201 AND 210 THEN TRUE ELSE COALESCE (tmpPrintKindItem.isQuality, FALSE) END              :: Boolean AS isQuality
            , CASE WHEN inBranchCode BETWEEN 201 AND 210 THEN 1    ELSE COALESCE (tmpPrintKindItem.CountQuality, 0)  END              :: TFloat  AS CountQuality
            , COALESCE (tmpPrintKindItem.isPack, FALSE)      :: Boolean AS isPack     , COALESCE (tmpPrintKindItem.CountPack, 0)      :: TFloat  AS CountPack
            , COALESCE (tmpPrintKindItem.isSpec, FALSE)      :: Boolean AS isSpec     , COALESCE (tmpPrintKindItem.CountSpec, 0)      :: TFloat  AS CountSpec
            , COALESCE (tmpPrintKindItem.isTax, FALSE)       :: Boolean AS isTax      , COALESCE (tmpPrintKindItem.CountTax, 0)       :: TFloat  AS CountTax

            , ObjectDesc.Id AS ObjectDescId
            , tmpPartner.MovementDescId
            , ObjectDesc.ItemName

       FROM tmpPartner
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = zc_Object_Partner()
            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = tmpPartner.JuridicalId
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
            LEFT JOIN ObjectLink AS ObjectLink_Retail_PrintKindItem
                                 ON ObjectLink_Retail_PrintKindItem.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                AND ObjectLink_Retail_PrintKindItem.DescId = zc_ObjectLink_Retail_PrintKindItem()
            LEFT JOIN ObjectLink AS ObjectLink_Juridical_PrintKindItem
                                 ON ObjectLink_Juridical_PrintKindItem.ObjectId = tmpPartner.JuridicalId
                                AND ObjectLink_Juridical_PrintKindItem.DescId = zc_ObjectLink_Juridical_PrintKindItem()
            LEFT JOIN tmpPrintKindItem ON tmpPrintKindItem.Id = CASE WHEN ObjectLink_Juridical_Retail.ChildObjectId > 0 THEN ObjectLink_Retail_PrintKindItem.ChildObjectId ELSE ObjectLink_Juridical_PrintKindItem.ChildObjectId END

            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpPartner.InfoMoneyId
            LEFT JOIN Object_ContractCondition_PercentView ON Object_ContractCondition_PercentView.ContractId = tmpPartner.ContractId
                                                          AND CURRENT_DATE BETWEEN Object_ContractCondition_PercentView.StartDate AND Object_ContractCondition_PercentView.EndDate

            LEFT JOIN Object_Contract_View ON Object_Contract_View.ContractId = tmpPartner.ContractId
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpPartner.PaidKindId

            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpPartner.JuridicalId

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
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Guide_Irna
                                    ON ObjectBoolean_Guide_Irna.ObjectId = Object_Juridical.Id
                                   AND ObjectBoolean_Guide_Irna.DescId = zc_ObjectBoolean_Guide_Irna()
       WHERE COALESCE (vbIsIrna, FALSE) = FALSE
          OR (vbIsIrna = TRUE AND ObjectBoolean_Guide_Irna.ValueData = TRUE)
           ;
   ELSE

   -- определяется уровень доступа
   vbObjectId_Constraint:= COALESCE ((SELECT Object_RoleAccessKeyGuide_View.JuridicalGroupId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.JuridicalGroupId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.JuridicalGroupId), 0);
   vbBranchId_Constraint:= COALESCE ((SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId), 0);
   vbIsConstraint:= (vbObjectId_Constraint > 0 OR vbBranchId_Constraint > 0) AND COALESCE (vbIsIrna, FALSE) = FALSE;


    -- Результат
    RETURN QUERY
       WITH tmpUnit_not AS (SELECT 954062 AS UnitId -- Отдел Х
                           /*UNION
                            SELECT lfSelect.LocationId FROM lfSelect_Object_Unit_List (8382) AS lfSelect -- Админ
                           UNION
                            SELECT lfSelect.LocationId FROM lfSelect_Object_Unit_List (8427) AS lfSelect WHERE lfSelect.LocationId <> 8429 -- Общефирменные + Отдел логистики
                           -- UNION
                           --  SELECT lfSelect.LocationId FROM lfSelect_Object_Unit_List (8432) AS lfSelect -- Общепроизводственные
                           */

                           )
             , tmpCar AS (SELECT Object_Car.Id         AS CarId
                               , Object_Car.DescId     AS DescId
                               , Object_Car.ObjectCode AS CarCode
                               , TRIM (COALESCE (Object_CarModel.ValueData, '')|| COALESCE (' ' || Object_CarType.ValueData, '') || ' ' || COALESCE (Object_Car.ValueData, ''))  AS CarName
                               , Object_PersonalDriver.ObjectCode   AS PersonalDriverCode
                               , Object_PersonalDriver.ValueData    AS PersonalDriverName
                          FROM Object AS Object_Car
                               LEFT JOIN ObjectLink AS Car_CarModel
                                                    ON Car_CarModel.ObjectId = Object_Car.Id
                                                   AND Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
                               LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = Car_CarModel.ChildObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                                    ON ObjectLink_Car_CarType.ObjectId = Object_Car.Id
                                                   AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
                               LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId

                               /*LEFT JOIN ObjectLink AS ObjectLink_Car_Unit
                                                    ON ObjectLink_Car_Unit.ObjectId = Object_Car.Id
                                                   AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
                               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Car_Unit.ChildObjectId*/

                               LEFT JOIN ObjectLink AS ObjectLink_Car_PersonalDriver
                                                    ON ObjectLink_Car_PersonalDriver.ObjectId = Object_Car.Id
                                                   AND ObjectLink_Car_PersonalDriver.DescId = zc_ObjectLink_Car_PersonalDriver()
                               LEFT JOIN Object AS Object_PersonalDriver ON Object_PersonalDriver.Id = ObjectLink_Car_PersonalDriver.ChildObjectId

                          WHERE Object_Car.DescId = zc_Object_Car()
                            AND Object_Car.isErased = FALSE
                            AND (inBranchCode BETWEEN 301 AND 310)
                         )
          , tmpMember AS (SELECT lfSelect.MemberId        AS MemberId
                               , Object_Member.DescId     AS DescId
                               , Object_Member.ObjectCode AS MemberCode
                               , Object_Member.ValueData  AS MemberName
                               , Object_Unit.ObjectCode   AS UnitCode
                               , Object_Unit.ValueData    AS UnitName
                          FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                               INNER JOIN Object AS Object_Member ON Object_Member.Id = lfSelect.MemberId
                               LEFT  JOIN Object AS Object_Unit   ON Object_Unit.Id   = lfSelect.UnitId
                               LEFT  JOIN tmpUnit_not ON tmpUnit_not.UnitId = lfSelect.UnitId
                          WHERE tmpUnit_not.UnitId IS NULL
                            AND Object_Member.isErased = FALSE
                            -- AND (inBranchCode BETWEEN 301 AND 310 OR (inBranchCode= 1 AND inIsGoodsComplete = TRUE))
                         )
          , tmpInfoMoney AS (-- 1.1.
                             SELECT View_InfoMoney_find.InfoMoneyId
                                  , View_InfoMoney_find.InfoMoneyGroupId
                                  , zc_Movement_Income() AS MovementDescId
                             FROM Object_InfoMoney_View AS View_InfoMoney_find
                             WHERE View_InfoMoney_find.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                               AND inIsGoodsComplete = FALSE
                               AND inBranchCode      NOT BETWEEN 301 AND 310
                            UNION
                             -- 1.1.
                             SELECT View_InfoMoney_find.InfoMoneyId
                                  , View_InfoMoney_find.InfoMoneyGroupId
                                  , zc_Movement_Income() AS MovementDescId
                             FROM Object_InfoMoney_View AS View_InfoMoney_find
                             WHERE View_InfoMoney_find.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20700() -- Общефирменные + Товары
                                                                                , zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                                                                                , zc_Enum_InfoMoneyDestination_21000() -- Общефирменные + Чапли
                                                                                , zc_Enum_InfoMoneyDestination_21100() -- Общефирменные + Дворкин
                                                                                 )
                               AND inIsGoodsComplete = TRUE
                            UNION
                             -- 1.2.
                             SELECT View_InfoMoney_find.InfoMoneyId
                                  , View_InfoMoney_find.InfoMoneyGroupId
                                  , zc_Movement_Income() AS MovementDescId
                             FROM Object_InfoMoney_View AS View_InfoMoney_find
                             WHERE View_InfoMoney_find.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10200() -- Основное сырье + Прочее сырье
                                                                                , zc_Enum_InfoMoneyDestination_20100() -- Запчасти и Ремонты
                                                                                , zc_Enum_InfoMoneyDestination_20200() -- Прочие ТМЦ
                                                                                , zc_Enum_InfoMoneyDestination_20300() -- МНМА
                                                                                , zc_Enum_InfoMoneyDestination_20400() -- ГСМ
                                                                                , zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                                                                                , zc_Enum_InfoMoneyDestination_20600() -- Прочие материалы
                                                                                 )
                               AND inBranchCode BETWEEN 301 AND 310
                            UNION
                             -- 2.1.
                             SELECT View_InfoMoney_find.InfoMoneyId
                                  , View_InfoMoney_find.InfoMoneyGroupId
                                  , zc_Movement_Sale() AS MovementDescId
                             FROM Object_InfoMoney_View AS View_InfoMoney_find
                             WHERE (View_InfoMoney_find.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                                                                                  )
                                 OR View_InfoMoney_find.InfoMoneyId = zc_Enum_InfoMoney_30501() -- Прочие доходы
                                   )
                               AND inBranchCode BETWEEN 301 AND 310
                            UNION
                             -- 2.2.
                             SELECT View_InfoMoney_find.InfoMoneyId
                                  , View_InfoMoney_find.InfoMoneyGroupId
                                  , zc_Movement_Sale() AS MovementDescId
                             FROM Object_InfoMoney_View AS View_InfoMoney_find
                             WHERE View_InfoMoney_find.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье
                                                                                , zc_Enum_InfoMoneyDestination_30300() -- Доходы + Переработка
                                                                                 )
                               AND inIsGoodsComplete = FALSE
                               AND inBranchCode      NOT BETWEEN 301 AND 310
                            UNION
                             -- 2.3.
                             SELECT View_InfoMoney_find.InfoMoneyId
                                  , View_InfoMoney_find.InfoMoneyGroupId
                                  , zc_Movement_Sale() AS MovementDescId
                             FROM Object_InfoMoney_View AS View_InfoMoney_find
                             WHERE (View_InfoMoney_find.InfoMoneyId IN (zc_Enum_InfoMoney_30101()) -- Доходы + Продукция + Готовая продукция
                                 OR View_InfoMoney_find.InfoMoneyId IN (zc_Enum_InfoMoney_30103()) -- Доходы + Продукция + Хлеб
                                 OR View_InfoMoney_find.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30300() -- Доходы + Переработка
                                                                                  )
                                   )
                               AND inIsGoodsComplete = TRUE
                            )
         , tmpContractPartner AS (SELECT ObjectLink_ContractPartner_Contract.ChildObjectId AS ContractId
                                       , ObjectLink_ContractPartner_Partner.ChildObjectId  AS PartnerId
                                       , ObjectLink_Partner_Juridical.ChildObjectId        AS JuridicalId
                                  FROM ObjectLink AS ObjectLink_ContractPartner_Partner
                                       INNER JOIN Object AS Object_ContractPartner ON Object_ContractPartner.Id = ObjectLink_ContractPartner_Partner.ObjectId
                                                                                  AND Object_ContractPartner.isErased = FALSE
                                       INNER JOIN ObjectLink AS ObjectLink_ContractPartner_Contract
                                                             ON ObjectLink_ContractPartner_Contract.ObjectId = Object_ContractPartner.Id
                                                            AND ObjectLink_ContractPartner_Contract.DescId = zc_ObjectLink_ContractPartner_Contract()
                                                            AND ObjectLink_ContractPartner_Contract.ChildObjectId >0
                                       LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                            ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_ContractPartner_Partner.ChildObjectId
                                                           AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                  WHERE ObjectLink_ContractPartner_Partner.DescId = zc_ObjectLink_ContractPartner_Partner()
                                    AND ObjectLink_ContractPartner_Partner.ChildObjectId >0
                                  --AND 1=0
                                 )
          , tmpPartner AS (SELECT DISTINCT
                                  Object_Partner.Id         AS PartnerId
                                , Object_Partner.ObjectCode AS PartnerCode
                                , Object_Partner.ValueData  AS PartnerName
                                , View_Contract.JuridicalId AS JuridicalId
                                , View_Contract.PaidKindId  AS PaidKindId
                                  /*-- преобразование, т.к. в гриде будет фильтр или для УП-приход, или УП-реализация
                                , CASE WHEN tmpInfoMoney.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_10000() -- Основное сырье
                                            THEN zc_Enum_InfoMoney_10101() -- Основное сырье + Мясное сырье + Живой вес
                                       WHEN tmpInfoMoney.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_30000() -- Доходы !!!не лишнее, т.к. ниже может понадобиться OR!!!
                                        AND tmpInfoMoney.InfoMoneyId = zc_Enum_InfoMoney_30101() -- Доходы + Продукция + Готовая продукция
                                            THEN zc_Enum_InfoMoney_30101()
                                       ELSE tmpInfoMoney.InfoMoneyId
                                  END AS InfoMoneyId*/
                                , tmpInfoMoney.InfoMoneyId
                                , tmpInfoMoney.MovementDescId
                                , (View_Contract.ContractId) AS ContractId
                           FROM tmpInfoMoney
                                LEFT JOIN Object_Contract_View AS View_Contract ON View_Contract.InfoMoneyId = tmpInfoMoney.InfoMoneyId
                                                                               AND View_Contract.isErased = FALSE
                                                                               AND View_Contract.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                LEFT JOIN tmpContractPartner ON tmpContractPartner.ContractId = View_Contract.ContractId
                                                            AND tmpContractPartner.JuridicalId = View_Contract.JuridicalId
                                LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                     ON ObjectLink_Partner_Juridical.ChildObjectId = View_Contract.JuridicalId
                                                    AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                                    AND tmpContractPartner.ContractId IS NULL
                                LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = COALESCE (tmpContractPartner.PartnerId, ObjectLink_Partner_Juridical.ObjectId)

                                LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                                                     ON ObjectLink_Juridical_JuridicalGroup.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                    AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()

                                LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                                     ON ObjectLink_Partner_PersonalTrade.ObjectId = Object_Partner.Id
                                                    AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                                LEFT JOIN ObjectLink AS ObjectLink_PersonalTrade_Unit
                                                     ON ObjectLink_PersonalTrade_Unit.ObjectId = ObjectLink_Partner_PersonalTrade.ChildObjectId
                                                    AND ObjectLink_PersonalTrade_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch_PersonalTrade
                                                     ON ObjectLink_Unit_Branch_PersonalTrade.ObjectId = ObjectLink_PersonalTrade_Unit.ChildObjectId
                                                    AND ObjectLink_Unit_Branch_PersonalTrade.DescId = zc_ObjectLink_Unit_Branch()

                           WHERE Object_Partner.IsErased = FALSE
                             AND (ObjectLink_Juridical_JuridicalGroup.ChildObjectId = vbObjectId_Constraint
                                  OR ObjectLink_Unit_Branch_PersonalTrade.ChildObjectId = vbBranchId_Constraint
                                  -- филиал Киев + филиал Львов
                                  OR (ObjectLink_Unit_Branch_PersonalTrade.ChildObjectId = 8379 AND vbBranchId_Constraint = 3080683)
                                  -- филиал Львов + филиал Киев
                                  OR (ObjectLink_Unit_Branch_PersonalTrade.ChildObjectId = 3080683 AND vbBranchId_Constraint = 8379)
                                  OR vbIsConstraint = FALSE
                                --OR 1=1
                                 )
                           /*GROUP BY Object_Partner.Id
                                  , Object_Partner.ObjectCode
                                  , Object_Partner.ValueData
                                  , View_Contract.JuridicalId
                                  , View_Contract.PaidKindId
                                  , tmpInfoMoney.InfoMoneyId
                                  , tmpInfoMoney.MovementDescId*/
                          )
          , tmpPrintKindItem AS (SELECT * FROM lpSelect_Object_PrintKindItem())

       SELECT tmpPartner.PartnerId
            , tmpPartner.PartnerCode
            , tmpPartner.PartnerName
            , Object_Juridical.ValueData           AS JuridicalName
            , Object_PaidKind.Id                   AS PaidKindId
            , Object_PaidKind.ValueData            AS PaidKindName

            , Object_Contract_View.ContractId      AS ContractId
            , Object_Contract_View.ContractCode    AS ContractCode
            , Object_Contract_View.InvNumber       AS ContractNumber
            , Object_Contract_View.ContractTagName AS ContractTagName

            , tmpPartner.InfoMoneyId
            , View_InfoMoney.InfoMoneyCode
            , View_InfoMoney.InfoMoneyName

            , Object_ContractCondition_PercentView.ChangePercent :: TFloat AS ChangePercent
            , CASE WHEN View_InfoMoney.InfoMoneyGroupId IN (zc_Enum_InfoMoneyGroup_10000() -- Основное сырье
                                                          , zc_Enum_InfoMoneyGroup_20000() -- Общефирменные
                                                           )
                        THEN 0 -- !!!поставщики!!!!
                   WHEN inIsGoodsComplete = FALSE
                    AND tmpPartner.JuridicalId = 15384 -- Фізична особа-підприємець Соколюк Аліса Борисівна
                        THEN 1 -- покупатели сырья, захардкодил
                   WHEN inIsGoodsComplete = FALSE
                        THEN 0 -- покупатели сырья, ВСЕ
                   WHEN tmpPartner.PartnerCode IN (12345678) -- ???
                        THEN 1 -- покупатели гп, может надо будет захардкодить
                   ELSE 1 -- покупатели гп, ВСЕ
              END :: TFloat AS ChangePercentAmount

            , COALESCE (ObjectBoolean_Partner_EdiOrdspr.ValueData, FALSE)  :: Boolean AS isEdiOrdspr
            , COALESCE (ObjectBoolean_Partner_EdiInvoice.ValueData, FALSE) :: Boolean AS isEdiInvoice
            , COALESCE (ObjectBoolean_Partner_EdiDesadv.ValueData, FALSE)  :: Boolean AS isEdiDesadv

            , CASE WHEN tmpPrintKindItem.isPack = TRUE OR tmpPrintKindItem.isSpec = TRUE THEN COALESCE (tmpPrintKindItem.isMovement, FALSE) ELSE TRUE END :: Boolean AS isMovement
            , CASE WHEN tmpPrintKindItem.CountMovement > 0 THEN tmpPrintKindItem.CountMovement ELSE 2 END :: TFloat AS CountMovement
            , COALESCE (tmpPrintKindItem.isAccount, FALSE)   :: Boolean AS isAccount,   COALESCE (tmpPrintKindItem.CountAccount, 0)   :: TFloat  AS CountAccount
            , COALESCE (tmpPrintKindItem.isTransport, FALSE) :: Boolean AS isTransport, COALESCE (tmpPrintKindItem.CountTransport, 0) :: TFloat  AS CountTransport
            , CASE WHEN inBranchCode BETWEEN 201 AND 210 THEN TRUE ELSE COALESCE (tmpPrintKindItem.isQuality, FALSE) END              :: Boolean AS isQuality
            , CASE WHEN inBranchCode BETWEEN 201 AND 210 THEN 1    ELSE COALESCE (tmpPrintKindItem.CountQuality, 0)  END              :: TFloat  AS CountQuality
            , COALESCE (tmpPrintKindItem.isPack, FALSE)      :: Boolean AS isPack     , COALESCE (tmpPrintKindItem.CountPack, 0)      :: TFloat  AS CountPack
            , COALESCE (tmpPrintKindItem.isSpec, FALSE)      :: Boolean AS isSpec     , COALESCE (tmpPrintKindItem.CountSpec, 0)      :: TFloat  AS CountSpec
            , COALESCE (tmpPrintKindItem.isTax, FALSE)       :: Boolean AS isTax      , COALESCE (tmpPrintKindItem.CountTax, 0)       :: TFloat  AS CountTax

            , ObjectDesc.Id AS ObjectDescId
            , tmpPartner.MovementDescId
            , ObjectDesc.ItemName

       FROM tmpPartner
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = zc_Object_Partner()
            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = tmpPartner.JuridicalId
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
            LEFT JOIN ObjectLink AS ObjectLink_Retail_PrintKindItem
                                 ON ObjectLink_Retail_PrintKindItem.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                AND ObjectLink_Retail_PrintKindItem.DescId = zc_ObjectLink_Retail_PrintKindItem()
            LEFT JOIN ObjectLink AS ObjectLink_Juridical_PrintKindItem
                                 ON ObjectLink_Juridical_PrintKindItem.ObjectId = tmpPartner.JuridicalId
                                AND ObjectLink_Juridical_PrintKindItem.DescId = zc_ObjectLink_Juridical_PrintKindItem()
            LEFT JOIN tmpPrintKindItem ON tmpPrintKindItem.Id = CASE WHEN ObjectLink_Juridical_Retail.ChildObjectId > 0 THEN ObjectLink_Retail_PrintKindItem.ChildObjectId ELSE ObjectLink_Juridical_PrintKindItem.ChildObjectId END

            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpPartner.InfoMoneyId
            LEFT JOIN Object_ContractCondition_PercentView ON Object_ContractCondition_PercentView.ContractId = tmpPartner.ContractId

            LEFT JOIN Object_Contract_View ON Object_Contract_View.ContractId = tmpPartner.ContractId
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpPartner.PaidKindId

            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpPartner.JuridicalId

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
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Guide_Irna
                                    ON ObjectBoolean_Guide_Irna.ObjectId = Object_Juridical.Id
                                   AND ObjectBoolean_Guide_Irna.DescId = zc_ObjectBoolean_Guide_Irna()

       WHERE COALESCE (vbIsIrna, FALSE) = FALSE
          OR (vbIsIrna = TRUE AND ObjectBoolean_Guide_Irna.ValueData = TRUE)

      UNION ALL
       SELECT Object_ArticleLoss.Id          AS PartnerId
            , Object_ArticleLoss.ObjectCode  AS PartnerCode
            , Object_ArticleLoss.ValueData   AS PartnerName
            , '' :: TVarChar  AS JuridicalName
            , NULL :: Integer AS PaidKindId
            , '' :: TVarChar  AS PaidKindName

            , NULL :: Integer AS ContractId
            , View_ProfitLossDirection.ProfitLossDirectionCode             AS ContractCode
            , View_ProfitLossDirection.ProfitLossDirectionCode :: TVarChar AS ContractNumber
            , View_ProfitLossDirection.ProfitLossDirectionName             AS ContractTagName

            , NULL :: Integer                     AS InfoMoneyId
            , Object_InfoMoney_View.InfoMoneyCode AS InfoMoneyCode
            , Object_InfoMoney_View.InfoMoneyName AS InfoMoneyName

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

            , ObjectDesc.Id AS ObjectDescId
            , zc_Movement_Loss() AS MovementDescId
            , ObjectDesc.ItemName

       FROM Object AS Object_ArticleLoss
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_ArticleLoss.DescId

            LEFT JOIN ObjectLink AS ObjectLink_ArticleLoss_InfoMoney
                                 ON ObjectLink_ArticleLoss_InfoMoney.ObjectId = Object_ArticleLoss.Id
                                AND ObjectLink_ArticleLoss_InfoMoney.DescId = zc_ObjectLink_ArticleLoss_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_ArticleLoss_InfoMoney.ChildObjectId

            INNER JOIN ObjectLink AS ObjectLink_ArticleLoss_ProfitLossDirection
                                  ON ObjectLink_ArticleLoss_ProfitLossDirection.ObjectId = Object_ArticleLoss.Id
                                 AND ObjectLink_ArticleLoss_ProfitLossDirection.DescId = zc_ObjectLink_ArticleLoss_ProfitLossDirection()
                                 AND ObjectLink_ArticleLoss_ProfitLossDirection.ChildObjectId > 0
            LEFT JOIN Object_ProfitLossDirection_View AS View_ProfitLossDirection ON View_ProfitLossDirection.ProfitLossDirectionId = ObjectLink_ArticleLoss_ProfitLossDirection.ChildObjectId

       WHERE Object_ArticleLoss.DescId   = zc_Object_ArticleLoss()
         AND Object_ArticleLoss.isErased = FALSE


      UNION ALL
       SELECT Object_Unit.Id          AS PartnerId
            , Object_Unit.ObjectCode  AS PartnerCode
            , Object_Unit.ValueData   AS PartnerName
            , '' :: TVarChar  AS JuridicalName
            , NULL :: Integer AS PaidKindId
            , '' :: TVarChar  AS PaidKindName

            , View_Contract.ContractId      AS ContractId
            , View_Contract.ContractCode    AS ContractCode
            , View_Contract.InvNumber       AS ContractNumber
            , View_Contract.ContractTagName AS ContractTagName

            , NULL :: Integer AS InfoMoneyId
            , NULL :: Integer AS InfoMoneyCode
            , '' :: TVarChar  AS InfoMoneyName

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

            , ObjectDesc.Id AS ObjectDescId
            , zc_Movement_Loss() AS MovementDescId
            , ObjectDesc.ItemName

       FROM Object AS Object_Unit
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Unit.DescId

            INNER JOIN ObjectLink AS ObjectLink_Unit_Contract
                                  ON ObjectLink_Unit_Contract.ObjectId = Object_Unit.Id
                                 AND ObjectLink_Unit_Contract.DescId   = zc_ObjectLink_Unit_Contract()

            INNER JOIN Object_Contract_View AS View_Contract ON View_Contract.ContractId = ObjectLink_Unit_Contract.ChildObjectId

       WHERE Object_Unit.DescId   = zc_Object_Unit()
         AND Object_Unit.isErased = FALSE


      UNION ALL
       SELECT tmpMember.MemberId     AS PartnerId
            , tmpMember.MemberCode   AS PartnerCode
            , tmpMember.MemberName   AS PartnerName
            , '' :: TVarChar  AS JuridicalName
            , NULL :: Integer AS PaidKindId
            , '' :: TVarChar  AS PaidKindName

            , (-1 * zc_Object_Member()) :: Integer AS ContractId
            , tmpMember.UnitCode             AS ContractCode
            , tmpMember.UnitCode :: TVarChar AS ContractNumber
            , tmpMember.UnitName             AS ContractTagName

            , (-1 * zc_Object_Member()) :: Integer AS InfoMoneyId
            , NULL :: Integer  AS InfoMoneyCode
            , NULL :: TVarChar AS InfoMoneyName

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

            , CASE WHEN inBranchCode NOT BETWEEN 301 AND 301 THEN tmpMember.DescId   ELSE zc_Object_ArticleLoss() END :: Integer AS ObjectDescId
            , tmpDesc.MovementDescId :: Integer AS MovementDescId
            , ObjectDesc.ItemName

       FROM tmpMember
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = tmpMember.DescId
            LEFT JOIN (SELECT zc_Movement_Send() AS MovementDescId WHERE inBranchCode <> 301
                 UNION SELECT zc_Movement_Loss() AS MovementDescId WHERE inBranchCode BETWEEN 301 AND 310
                      ) AS tmpDesc ON 1=1

      UNION ALL
       SELECT tmpCar.CarId               AS PartnerId
            , tmpCar.CarCode             AS PartnerCode
            , tmpCar.CarName :: TVarChar AS PartnerName
            , '' :: TVarChar             AS JuridicalName
            , NULL :: Integer            AS PaidKindId
            , '' :: TVarChar             AS PaidKindName

            , (-1 * zc_Object_Car()) :: Integer AS ContractId
            , tmpCar.PersonalDriverCode             AS ContractCode
            , tmpCar.PersonalDriverCode :: TVarChar AS ContractNumber
            , tmpCar.PersonalDriverName             AS ContractTagName

            , (-1 * zc_Object_Car()) :: Integer AS InfoMoneyId
            , NULL :: Integer  AS InfoMoneyCode
            , NULL :: TVarChar AS InfoMoneyName

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

            , tmpCar.DescId                     AS ObjectDescId
            , tmpDesc.MovementDescId :: Integer AS MovementDescId
            , ObjectDesc.ItemName

       FROM tmpCar
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = tmpCar.DescId
            LEFT JOIN (SELECT zc_Movement_Send() AS MovementDescId
                 UNION SELECT zc_Movement_Loss() AS MovementDescId
                      ) AS tmpDesc ON 1=1
       WHERE inBranchCode BETWEEN 302 AND 310

      UNION ALL
       SELECT Object_Unit.Id          AS PartnerId
            , Object_Unit.ObjectCode  AS PartnerCode
            , Object_Unit.ValueData   AS PartnerName
            , Object_Branch.ObjectCode :: TVarChar AS JuridicalName -- для сортировки
            , NULL :: Integer AS PaidKindId
            , '' :: TVarChar  AS PaidKindName

            , NULL :: Integer AS ContractId
            , View_AccountDirection.AccountDirectionCode             AS ContractCode
            , View_AccountDirection.AccountDirectionCode :: TVarChar AS ContractNumber
            , View_AccountDirection.AccountDirectionName             AS ContractTagName

            , NULL :: Integer                     AS InfoMoneyId
            , Object_Branch.ObjectCode            AS InfoMoneyCode
            , Object_Branch.ValueData             AS InfoMoneyName

            , NULL :: TFloat AS ChangePercent
            , CASE WHEN Object_Unit.Id IN (301309 -- Склад ГП ф.Запорожье
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

            , ObjectDesc.Id             AS ObjectDescId
            , zc_Movement_SendOnPrice() AS MovementDescId
            , ObjectDesc.ItemName

       FROM Object AS Object_Unit
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Unit.DescId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                 ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                 ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_AccountDirection
                                 ON ObjectLink_Unit_AccountDirection.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_AccountDirection.DescId = zc_ObjectLink_Unit_AccountDirection()
            LEFT JOIN Object_AccountDirection_View AS View_AccountDirection ON View_AccountDirection.AccountDirectionId = ObjectLink_Unit_AccountDirection.ChildObjectId

       WHERE Object_Unit.DescId = zc_Object_Unit()
         AND Object_Unit.isErased = FALSE
/*         AND (ObjectLink_Unit_AccountDirection.ChildObjectId = zc_Enum_AccountDirection_20700() -- Запасы + на филиалах
           OR ((ObjectLink_Unit_Parent.ChildObjectId = 8460 -- группа - Возвраты общие
                OR Object_Unit.Id = 8459) -- Склад Реализации
               AND vbBranchId_Constraint > 0
             ))*/
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
                                , 3080691-- 50010	Склад ГП ф.Львов
                                , 3080696-- 50011	Склад возвратов ф.Львов
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

       ORDER BY 4 -- Object_Juridical.ValueData
              , 3 -- tmpPartner.PartnerName
              , 2 -- tmpPartner.PartnerCode
              , 12 -- View_InfoMoney.InfoMoneyCode
              , 8 -- Object_Contract_View.ContractCode
      ;

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
-- SELECT * FROM gpSelect_Scale_Partner (inIsGoodsComplete:= FALSE, inBranchCode:= 301, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Scale_Partner (inIsGoodsComplete:= TRUE, inBranchCode:= 1, inSession:= zfCalc_UserAdmin())
