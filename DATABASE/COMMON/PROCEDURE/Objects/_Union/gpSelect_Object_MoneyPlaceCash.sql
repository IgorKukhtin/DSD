-- Function: gpSelect_Object_MoneyPlaceCash()

DROP FUNCTION IF EXISTS gpSelect_Object_MoneyPlaceCash (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MoneyPlaceCash(
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, ItemName TVarChar, isErased Boolean
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar
             , InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , ContractId Integer, ContractCode Integer, ContractNumber TVarChar, ContractStateKindCode Integer, StartDate TDateTime, EndDate TDateTime
             , ContractTagName TVarChar, ContractKindName TVarChar
             , MovementId_Partion Integer, PartionMovementName TVarChar, PaymentDate TDateTime
             , OKPO TVarChar
             , AmountDebet TFloat
             , AmountKredit TFloat
             , BranchName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , CurrencyId Integer, CurrencyName TVarChar
             , CarId Integer, CarName TVarChar
             , CarModelName TVarChar, UnitName_Car TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbIsConstraint Boolean;
  DECLARE vbObjectId_Constraint Integer;

   DECLARE vbIsConstraint_Branch Boolean;
   DECLARE vbObjectId_Constraint_Branch Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Object_StoragePlace());
     vbUserId:= lpGetUserBySession (inSession);

     -- определяется уровень доступа (группа юр.лиц)
     vbObjectId_Constraint:= (SELECT DISTINCT Object_RoleAccessKeyGuide_View.JuridicalGroupId
                              FROM Object_RoleAccessKeyGuide_View
                              WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.JuridicalGroupId <> 0
                                AND vbUserId <> 14599 -- Коротченко Т.Н.
                              GROUP BY Object_RoleAccessKeyGuide_View.JuridicalGroupId
                             );
     vbIsConstraint:= COALESCE (vbObjectId_Constraint, 0) > 0;

     -- определяется уровень доступа (филиал)
     vbObjectId_Constraint_Branch:= (SELECT DISTINCT  Object_RoleAccessKeyGuide_View.BranchId
                                     FROM Object_RoleAccessKeyGuide_View
                                     WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0
                                       AND vbUserId <> 14599 -- Коротченко Т.Н.
                                    );
     vbIsConstraint_Branch:= COALESCE (vbObjectId_Constraint_Branch, 0) > 0;


     -- Результат
     RETURN QUERY
     WITH View_InfoMoney_40801 AS (SELECT * FROM Object_InfoMoney_View WHERE Object_InfoMoney_View.InfoMoneyCode = 40801) -- Внутренний оборот
        , tmpPersonal_Branch AS (SELECT DISTINCT View_Personal.MemberId
                                 FROM ObjectLink AS ObjectLink_Unit_Branch
                                      INNER JOIN Object_Personal_View AS View_Personal ON View_Personal.UnitId = ObjectLink_Unit_Branch.ObjectId
                                 WHERE ObjectLink_Unit_Branch.ChildObjectId = vbObjectId_Constraint_Branch
                                   AND ObjectLink_Unit_Branch.DescId        = zc_ObjectLink_Unit_Branch()

                                UNION
                                 SELECT DISTINCT View_Personal.MemberId
                                 FROM Object_Personal_View AS View_Personal
                                 WHERE View_Personal.UnitId = 413386 -- Наши

                                UNION
                                 SELECT DISTINCT View_Personal.MemberId
                                 FROM Object_Personal_View AS View_Personal
                                 WHERE View_Personal.PositionId = 81178 -- экспедитор
                                    OR View_Personal.UnitId     = 8409  -- Отдел экспедиторов
                                )
        , tmpMember_Car AS (SELECT ObjectLink_Personal_Member.ChildObjectId AS MemberId
                                 , Object_Car.Id              AS CarId
                                 , Object_Car.ValueData       AS CarName
                                 , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName
                                 , Object_Unit.ValueData      AS UnitName
                                   -- № п/п
                                 , ROW_NUMBER() OVER (PARTITION BY ObjectLink_Personal_Member.ChildObjectId ORDER BY Object_Car.Id DESC) AS Ord
                            FROM ObjectLink AS ObjectLink_Car_PersonalDriver
                                 INNER JOIN Object AS Object_Car ON Object_Car.Id       = ObjectLink_Car_PersonalDriver.ObjectId
                                                                AND Object_Car.isErased = FALSE
                                 INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                       ON ObjectLink_Personal_Member.ObjectId = ObjectLink_Car_PersonalDriver.ChildObjectId
                                                      AND ObjectLink_Personal_Member.DescId   = zc_ObjectLink_Personal_Member()
                                 LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel
                                                      ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                     AND ObjectLink_Car_CarModel.DescId   = zc_ObjectLink_Car_CarModel()
                                 LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId

                                 LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                                      ON ObjectLink_Car_CarType.ObjectId = Object_Car.Id
                                                     AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
                                 LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId

                                 LEFT JOIN ObjectLink AS ObjectLink_Car_Unit 
                                                      ON ObjectLink_Car_Unit.ObjectId = Object_Car.Id
                                                     AND ObjectLink_Car_Unit.DescId   = zc_ObjectLink_Car_Unit()
                                 LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Car_Unit.ChildObjectId
                            WHERE ObjectLink_Car_PersonalDriver.DescId = zc_ObjectLink_Car_PersonalDriver()
                           )
        , tmpContainer_Partner_View AS (SELECT * FROM Container_Partner_View)
        -- , tmpObject_InfoMoney_View AS (SELECT * FROM gpSelect_Object_InfoMoney_Desc ('zc_Object_Juridical', inSession))

        , tmpContract_View AS (SELECT * FROM Object_Contract_View WHERE Object_Contract_View.isErased = FALSE)
        , tmpJuridicalDetails_View AS (SELECT * FROM ObjectHistory_JuridicalDetails_View)
        , tmpInfoMoney_View AS (SELECT * FROM Object_InfoMoney_View)
        , tmpPartner AS
     -- 1
    (SELECT Object_Partner.Id
          , Object_Partner.ObjectCode     
          , Object_Partner.ValueData AS Name
          , ObjectDesc.ItemName
          , Object_Partner.isErased
          , Object_InfoMoney_View.InfoMoneyId
          , Object_InfoMoney_View.InfoMoneyCode
          , Object_InfoMoney_View.InfoMoneyGroupName
          , Object_InfoMoney_View.InfoMoneyDestinationName
          , Object_InfoMoney_View.InfoMoneyName
          , Object_InfoMoney_View.InfoMoneyName_all
          , View_Contract.ContractId      :: Integer   AS ContractId
          , View_Contract.ContractCode    :: Integer   AS Code
          , View_Contract.InvNumber       :: TVarChar  AS InvNumber
          , View_Contract.ContractStateKindCode        AS ContractStateKindCode
          , View_Contract.StartDate       :: TDateTime AS StartDate
          , View_Contract.EndDate         :: TDateTime AS EndDate
          , View_Contract.ContractTagName :: TVarChar  AS ContractTagName
          , View_Contract.ContractKindName :: TVarChar AS ContractKindName
          , Container_Partner_View.MovementId_Partion
          , Container_Partner_View.PartionMovementName
          , Container_Partner_View.PaymentDate
          , ObjectHistory_JuridicalDetails_View.OKPO
          , Container_Partner_View.AmountDebet
          , Container_Partner_View.AmountKredit
          , Object_Branch.ValueData   AS BranchName
          , Object_PaidKind.Id        AS PaidKindId
          , Object_PaidKind.ValueData AS PaidKindName
          , Object_Currency.Id         AS CurrencyId
          , Object_Currency.ValueData  AS CurrencyName
          , 0            AS CarId
          , ''::TVarChar AS CarName
          , ''::TVarChar AS CarModelName
          , ''::TVarChar AS UnitName_Car
          , View_Contract.isErased AS isErased_Contract
     FROM Object AS Object_Partner
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Partner.DescId

          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
          LEFT JOIN tmpContract_View AS View_Contract ON View_Contract.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId

          LEFT JOIN tmpContainer_Partner_View AS Container_Partner_View ON Container_Partner_View.PartnerId   = Object_Partner.Id
                                                                       AND Container_Partner_View.ContractId  = View_Contract.ContractId
                                                                       AND Container_Partner_View.InfoMoneyId = View_Contract.InfoMoneyId

          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = COALESCE (Container_Partner_View.JuridicalId, ObjectLink_Partner_Juridical.ChildObjectId)
          LEFT JOIN tmpJuridicalDetails_View AS ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id

          -- LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = COALESCE (Container_Partner_View.InfoMoneyId, View_Contract.InfoMoneyId)
          LEFT JOIN tmpInfoMoney_View AS Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = COALESCE (Container_Partner_View.InfoMoneyId, View_Contract.InfoMoneyId)
          LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = COALESCE (Container_Partner_View.PaidKindId, View_Contract.PaidKindId)

          LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                               ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id
                              AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
          LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = Container_Partner_View.BranchId

          LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                               ON ObjectLink_Partner_PersonalTrade.ObjectId = Object_Partner.Id 
                              AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
          LEFT JOIN Object_Personal_View AS Object_PersonalTrade ON Object_PersonalTrade.PersonalId = ObjectLink_Partner_PersonalTrade.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Partner_Personal
                               ON ObjectLink_Partner_Personal.ObjectId = Object_Partner.Id 
                              AND ObjectLink_Partner_Personal.DescId = zc_ObjectLink_Partner_Personal()
          LEFT JOIN Object_Personal_View AS Object_Personal ON Object_Personal.PersonalId = ObjectLink_Partner_Personal.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Contract_Currency
                               ON ObjectLink_Contract_Currency.ObjectId = View_Contract.ContractId 
                              AND ObjectLink_Contract_Currency.DescId = zc_ObjectLink_Contract_Currency()
          LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = ObjectLink_Contract_Currency.ChildObjectId

          LEFT JOIN ObjectBoolean AS ObjectBoolean_isBranchAll
                                  ON ObjectBoolean_isBranchAll.ObjectId = Object_Juridical.Id
                                 AND ObjectBoolean_isBranchAll.DescId   = zc_ObjectBoolean_Juridical_isBranchAll()

     WHERE Object_Partner.DescId = zc_Object_Partner()
       AND Object_Partner.isErased = FALSE
       -- AND View_Contract.isErased = FALSE
       -- AND COALESCE (Object_Contract_View_Container.PaidKindId, View_Contract.PaidKindId) = zc_Enum_PaidKind_SecondForm()
       AND (ObjectLink_Juridical_JuridicalGroup.ChildObjectId IN (vbObjectId_Constraint
                                                                , 8359 -- 04-Услуги
                                                                , 8357 -- 02-Поставщики
                                                                 )
            OR Object_PersonalTrade.BranchId = vbObjectId_Constraint_Branch
            OR Object_Personal.BranchId = vbObjectId_Constraint_Branch
            OR ObjectBoolean_isBranchAll.ValueData = TRUE
            OR vbIsConstraint = FALSE
           )
-- AND vbUserId <> 5

    UNION ALL
     SELECT Object_Partner.Id
          , Object_Partner.ObjectCode     
          , Object_Partner.ValueData AS Name
          , ObjectDesc.ItemName
          , Object_Partner.isErased
          , Object_InfoMoney_View.InfoMoneyId
          , Object_InfoMoney_View.InfoMoneyCode
          , Object_InfoMoney_View.InfoMoneyGroupName
          , Object_InfoMoney_View.InfoMoneyDestinationName
          , Object_InfoMoney_View.InfoMoneyName
          , Object_InfoMoney_View.InfoMoneyName_all
          , View_Contract.ContractId      :: Integer   AS ContractId
          , View_Contract.ContractCode    :: Integer   AS Code
          , View_Contract.InvNumber       :: TVarChar  AS InvNumber
          , View_Contract.ContractStateKindCode        AS ContractStateKindCode
          , View_Contract.StartDate       :: TDateTime AS StartDate
          , View_Contract.EndDate         :: TDateTime AS EndDate
          , View_Contract.ContractTagName :: TVarChar  AS ContractTagName
          , View_Contract.ContractKindName :: TVarChar AS ContractKindName
          , Container_Partner_View.MovementId_Partion
          , Container_Partner_View.PartionMovementName
          , Container_Partner_View.PaymentDate
          , ObjectHistory_JuridicalDetails_View.OKPO
          , Container_Partner_View.AmountDebet
          , Container_Partner_View.AmountKredit
          , Object_Branch.ValueData   AS BranchName
          , Object_PaidKind.Id        AS PaidKindId
          , Object_PaidKind.ValueData AS PaidKindName
          , Object_Currency.Id         AS CurrencyId
          , Object_Currency.ValueData  AS CurrencyName
          , 0            AS CarId
          , ''::TVarChar AS CarName
          , ''::TVarChar AS CarModelName
          , ''::TVarChar AS UnitName_Car
          , View_Contract.isErased AS isErased_Contract
     FROM Object AS Object_Partner
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Partner.DescId

          LEFT JOIN tmpContainer_Partner_View AS Container_Partner_View ON Container_Partner_View.PartnerId = Object_Partner.Id

          LEFT JOIN tmpContract_View AS View_Contract ON View_Contract.ContractId  = Container_Partner_View.ContractId

          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                              AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
          LEFT JOIN tmpContract_View AS View_Contract_check ON View_Contract_check.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                                                           AND View_Contract_check.InfoMoneyId = Container_Partner_View.InfoMoneyId
                                                           AND View_Contract_check.ContractId  = Container_Partner_View.ContractId


          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = COALESCE (Container_Partner_View.JuridicalId, ObjectLink_Partner_Juridical.ChildObjectId)
          LEFT JOIN tmpJuridicalDetails_View AS ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id

          -- LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = COALESCE (Container_Partner_View.InfoMoneyId, View_Contract.InfoMoneyId)
          LEFT JOIN tmpInfoMoney_View AS Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = COALESCE (Container_Partner_View.InfoMoneyId, View_Contract.InfoMoneyId)
          LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = COALESCE (Container_Partner_View.PaidKindId, View_Contract.PaidKindId)

          LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                               ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id
                              AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
          LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = Container_Partner_View.BranchId

          LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                               ON ObjectLink_Partner_PersonalTrade.ObjectId = Object_Partner.Id 
                              AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
          LEFT JOIN Object_Personal_View AS Object_PersonalTrade ON Object_PersonalTrade.PersonalId = ObjectLink_Partner_PersonalTrade.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Partner_Personal
                               ON ObjectLink_Partner_Personal.ObjectId = Object_Partner.Id 
                              AND ObjectLink_Partner_Personal.DescId = zc_ObjectLink_Partner_Personal()
          LEFT JOIN Object_Personal_View AS Object_Personal ON Object_Personal.PersonalId = ObjectLink_Partner_Personal.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Contract_Currency
                               ON ObjectLink_Contract_Currency.ObjectId = View_Contract.ContractId 
                              AND ObjectLink_Contract_Currency.DescId = zc_ObjectLink_Contract_Currency()
          LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = ObjectLink_Contract_Currency.ChildObjectId

          LEFT JOIN ObjectBoolean AS ObjectBoolean_isBranchAll
                                  ON ObjectBoolean_isBranchAll.ObjectId = Object_Juridical.Id
                                 AND ObjectBoolean_isBranchAll.DescId   = zc_ObjectBoolean_Juridical_isBranchAll()

     WHERE Object_Partner.DescId = zc_Object_Partner()
       AND Object_Partner.isErased = FALSE
       -- AND View_Contract.isErased = FALSE
       -- AND COALESCE (Object_Contract_View_Container.PaidKindId, View_Contract.PaidKindId) = zc_Enum_PaidKind_SecondForm()
       AND (ObjectLink_Juridical_JuridicalGroup.ChildObjectId IN (vbObjectId_Constraint
                                                                , 8359 -- 04-Услуги
                                                                , 8357 -- 02-Поставщики
                                                                 )
            OR Object_PersonalTrade.BranchId = vbObjectId_Constraint_Branch
            OR Object_Personal.BranchId = vbObjectId_Constraint_Branch
            OR ObjectBoolean_isBranchAll.ValueData = TRUE
            OR vbIsConstraint = FALSE
           )
       -- !!! есть долг, но статья не такая как в договоре!!!
       AND View_Contract_check.ContractId IS NULL
       AND (Container_Partner_View.AmountDebet <> 0 OR Container_Partner_View.AmountKredit <> 0)

    )

     -- Результат
     SELECT Object_Cash.Id
          , Object_Cash.ObjectCode
          , Object_Cash.Valuedata AS Name
          , ObjectDesc.ItemName
          , Object_Cash.isErased
          , View_InfoMoney.InfoMoneyId
          , View_InfoMoney.InfoMoneyCode
          , View_InfoMoney.InfoMoneyGroupName
          , View_InfoMoney.InfoMoneyDestinationName
          , View_InfoMoney.InfoMoneyName
          , View_InfoMoney.InfoMoneyName_all
          , NULL::Integer AS ContractId
          , NULL::Integer AS ContractCode
          , ''::TVarChar  AS ContractNumber
          , NULL::Integer AS ContractStateKindCode
          , NULL::TDateTime AS StartDate
          , NULL::TDateTime AS EndDate
          , ''::TVarChar AS ContractTagName
          , ''::TVarChar AS ContractKindName
          , NULL :: Integer   AS MovementId_Partion
          , ''   :: TVarChar  AS PartionMovementName
          , NULL :: TDateTime AS PaymentDate
          , ''::TVarChar AS OKPO
          , 0 :: TFloat  AS AmountDebet
          , 0 :: TFloat  AS AmountKredit
          , ''::TVarChar AS BranchName
          , 0 :: Integer AS PaidKindId
          , ''::TVarChar AS PaidKindName
          , Object_Currency.Id        AS CurrencyId
          , Object_Currency.ValueData AS CurrencyName
          , 0            AS CarId
          , ''::TVarChar AS CarName
          , ''::TVarChar AS CarModelName
          , ''::TVarChar AS UnitName_Car
     FROM Object AS Object_Cash
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Cash.DescId
          LEFT JOIN View_InfoMoney_40801 AS View_InfoMoney ON 1 = 1
          LEFT JOIN ObjectLink AS ObjectLink_Cash_Currency
                               ON ObjectLink_Cash_Currency.ObjectId = Object_Cash.Id
                              AND ObjectLink_Cash_Currency.DescId   = zc_ObjectLink_Cash_Currency()
          LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = ObjectLink_Cash_Currency.ChildObjectId
     WHERE Object_Cash.DescId = zc_Object_Cash()
    UNION ALL
     SELECT Object_BankAccount_View.Id
          , Object_BankAccount_View.Code     
          , (Object_BankAccount_View.Name || ' * '|| Object_BankAccount_View.BankName) ::TVarChar AS Name
          , ObjectDesc.ItemName
          , Object_BankAccount_View.isErased
          , View_InfoMoney.InfoMoneyId
          , View_InfoMoney.InfoMoneyCode
          , View_InfoMoney.InfoMoneyGroupName
          , View_InfoMoney.InfoMoneyDestinationName
          , View_InfoMoney.InfoMoneyName
          , View_InfoMoney.InfoMoneyName_all
          , NULL::Integer AS ContractId
          , NULL::Integer AS ContractCode
          , ''::TVarChar  AS ContractNumber
          , NULL::Integer AS ContractStateKindCode
          , NULL::TDateTime AS StartDate
          , NULL::TDateTime AS EndDate
          , ''::TVarChar AS ContractTagName
          , ''::TVarChar AS ContractKindName
          , NULL :: Integer   AS MovementId_Partion
          , ''   :: TVarChar  AS PartionMovementName
          , NULL :: TDateTime AS PaymentDate
          , ''::TVarChar AS OKPO
          , 0 :: TFloat  AS AmountDebet
          , 0 :: TFloat  AS AmountKredit
          , ''::TVarChar AS BranchName
          , 0 :: Integer AS PaidKindId
          , ''::TVarChar AS PaidKindName
          , Object_Currency.Id        AS CurrencyId
          , Object_Currency.ValueData AS CurrencyName
          , 0            AS CarId
          , ''::TVarChar AS CarName
          , ''::TVarChar AS CarModelName
          , ''::TVarChar AS UnitName_Car
     FROM Object_BankAccount_View
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = zc_Object_BankAccount()
          LEFT JOIN View_InfoMoney_40801 AS View_InfoMoney ON 1 = 1
          LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = Object_BankAccount_View.CurrencyId
     WHERE (Object_BankAccount_View.JuridicalId IN (zc_Juridical_Basis()
                                                  , 15505 -- ДУКО ТОВ 
                                                  , 9926679  -- "ВК" МІТ ГРУП" ТОВ
                                                  , 15512 -- Ірна-1 Фірма ТОВ
                                                   )
         OR Object_BankAccount_View.isCorporate = TRUE
           )
     --AND vbIsConstraint = FALSE

    UNION ALL
     SELECT Object_Member.Id
          , Object_Member.ObjectCode     
          , Object_Member.ValueData
          , ObjectDesc.ItemName
          , Object_Member.isErased
          , NULL::Integer AS InfoMoneyId
          , NULL::Integer AS InfoMoneyCode
          , ''::TVarChar AS InfoMoneyGroupName
          , ''::TVarChar AS InfoMoneyDestinationName
          , ''::TVarChar AS InfoMoneyName
          , ''::TVarChar AS InfoMoneyName_all
          , NULL::Integer AS ContractId
          , NULL::Integer AS ContractCode
          , ''::TVarChar  AS ContractNumber
          , NULL::Integer AS ContractStateKindCode
          , NULL::TDateTime AS StartDate
          , NULL::TDateTime AS EndDate
          , ''::TVarChar AS ContractTagName
          , ''::TVarChar AS ContractKindName
          , NULL :: Integer   AS MovementId_Partion
          , ''   :: TVarChar  AS PartionMovementName
          , NULL :: TDateTime AS PaymentDate
          , ''::TVarChar AS OKPO
          , 0 :: TFloat  AS AmountDebet
          , 0 :: TFloat  AS AmountKredit
          , ''::TVarChar AS BranchName
          , 0 :: Integer AS PaidKindId
          , ''::TVarChar AS PaidKindName
          , Object_Currency.Id        AS CurrencyId
          , Object_Currency.ValueData AS CurrencyName
          , tmpMember_Car.CarId
          , tmpMember_Car.CarName
          , tmpMember_Car.CarModelName
          , tmpMember_Car.UnitName AS UnitName_Car
     FROM Object AS Object_Member
          LEFT JOIN tmpPersonal_Branch ON tmpPersonal_Branch.MemberId = Object_Member.Id
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Member.DescId
          LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = zc_Enum_Currency_Basis()
          LEFT JOIN tmpMember_Car ON tmpMember_Car.MemberId = Object_Member.Id
                                 AND tmpMember_Car.Ord      = 1

    WHERE Object_Member.DescId = zc_Object_Member()
      AND Object_Member.isErased = FALSE
      AND (tmpPersonal_Branch.MemberId > 0
           OR vbIsConstraint_Branch = FALSE
         --OR Object_Member.Id = 4218193 -- Клиент Харьков-Одесса
         --OR Object_Member.Id = 5034716 -- Клиент Киев-Одесса
          )
    UNION ALL
     SELECT tmpPartner.Id
          , tmpPartner.ObjectCode     
          , tmpPartner.Name
          , tmpPartner.ItemName
          , tmpPartner.isErased
          , tmpPartner.InfoMoneyId
          , tmpPartner.InfoMoneyCode
          , tmpPartner.InfoMoneyGroupName
          , tmpPartner.InfoMoneyDestinationName
          , tmpPartner.InfoMoneyName
          , tmpPartner.InfoMoneyName_all
          , tmpPartner.ContractId
          , tmpPartner.Code
          , tmpPartner.InvNumber
          , tmpPartner.ContractStateKindCode
          , tmpPartner.StartDate
          , tmpPartner.EndDate
          , tmpPartner.ContractTagName
          , tmpPartner.ContractKindName
          , tmpPartner.MovementId_Partion
          , tmpPartner.PartionMovementName
          , tmpPartner.PaymentDate
          , tmpPartner.OKPO
          , tmpPartner.AmountDebet
          , tmpPartner.AmountKredit
          , tmpPartner.BranchName
          , tmpPartner.PaidKindId
          , tmpPartner.PaidKindName
          , tmpPartner.CurrencyId
          , tmpPartner.CurrencyName
          , tmpPartner.CarId
          , tmpPartner.CarName
          , tmpPartner.CarModelName
          , tmpPartner.UnitName_Car
     FROM tmpPartner
     WHERE tmpPartner.isErased_Contract = FALSE

    UNION ALL
     SELECT Object_Juridical.Id
          , Object_Juridical.ObjectCode     
          , Object_Juridical.ValueData AS Name
          , ObjectDesc.ItemName
          , Object_Juridical.isErased
          , Object_InfoMoney_View.InfoMoneyId
          , Object_InfoMoney_View.InfoMoneyCode
          , Object_InfoMoney_View.InfoMoneyGroupName
          , Object_InfoMoney_View.InfoMoneyDestinationName
          , Object_InfoMoney_View.InfoMoneyName
          , Object_InfoMoney_View.InfoMoneyName_all
          , View_Contract.ContractId 
          , View_Contract.ContractCode
          , View_Contract.InvNumber
          , View_Contract.ContractStateKindCode
          , View_Contract.StartDate
          , View_Contract.EndDate
          , View_Contract.ContractTagName
          , View_Contract.ContractKindName
          , NULL :: Integer   AS MovementId_Partion
          , ''   :: TVarChar  AS PartionMovementName
          , NULL :: TDateTime AS PaymentDate
          , ObjectHistory_JuridicalDetails_View.OKPO
          , 0 :: TFloat  AS AmountDebet
          , 0 :: TFloat  AS AmountKredit
          , ''::TVarChar AS BranchName
          , Object_PaidKind.Id            AS PaidKindId
          , Object_PaidKind.ValueData     AS PaidKindName
          , Object_Currency.Id         AS CurrencyId
          , Object_Currency.ValueData  AS CurrencyName
          , 0            AS CarId
          , ''::TVarChar AS CarName
          , ''::TVarChar AS CarModelName
          , ''::TVarChar AS UnitName_Car
     FROM Object AS Object_Juridical
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Juridical.DescId
          INNER JOIN tmpContract_View AS View_Contract ON View_Contract.JuridicalId = Object_Juridical.Id 
          LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = View_Contract.PaidKindId
          -- LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = View_Contract.InfoMoneyId
          LEFT JOIN tmpInfoMoney_View AS Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = View_Contract.InfoMoneyId
          LEFT JOIN tmpJuridicalDetails_View AS ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id

          LEFT JOIN ObjectLink AS ObjectLink_Contract_Currency
                               ON ObjectLink_Contract_Currency.ObjectId = View_Contract.ContractId 
                              AND ObjectLink_Contract_Currency.DescId = zc_ObjectLink_Contract_Currency()
          LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = ObjectLink_Contract_Currency.ChildObjectId

     WHERE Object_Juridical.DescId = zc_Object_Juridical()
       AND Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_40900()
       -- AND View_Contract.isErased = FALSE
       AND Object_Juridical.isErased = FALSE
       AND vbIsConstraint = FALSE
    UNION ALL
     SELECT Object_Founder.Id
          , Object_Founder.ObjectCode     
          , Object_Founder.ValueData
          , ObjectDesc.ItemName
          , Object_Founder.isErased
          , Object_InfoMoney_View.InfoMoneyId
          , Object_InfoMoney_View.InfoMoneyCode
          , Object_InfoMoney_View.InfoMoneyGroupName
          , Object_InfoMoney_View.InfoMoneyDestinationName
          , Object_InfoMoney_View.InfoMoneyName
          , Object_InfoMoney_View.InfoMoneyName_all
          , NULL::Integer AS ContractId
          , NULL::Integer AS ContractCode
          , ''::TVarChar  AS ContractNumber
          , NULL::Integer AS ContractStateKindCode
          , NULL::TDateTime AS StartDate
          , NULL::TDateTime AS EndDate
          , ''::TVarChar AS ContractTagName
          , ''::TVarChar AS ContractKindName
          , NULL :: Integer   AS MovementId_Partion
          , ''   :: TVarChar  AS PartionMovementName
          , NULL :: TDateTime AS PaymentDate
          , ''::TVarChar AS OKPO
          , 0 :: TFloat  AS AmountDebet
          , 0 :: TFloat  AS AmountKredit
          , ''::TVarChar AS BranchName
          , 0 :: Integer AS PaidKindId
          , ''::TVarChar AS PaidKindName
          , Object_Currency.Id        AS CurrencyId
          , Object_Currency.ValueData AS CurrencyName
          , 0            AS CarId
          , ''::TVarChar AS CarName
          , ''::TVarChar AS CarModelName
          , ''::TVarChar AS UnitName_Car
     FROM Object AS Object_Founder
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Founder.DescId
          LEFT JOIN ObjectLink AS ObjectLink_Founder_InfoMoney
                               ON ObjectLink_Founder_InfoMoney.ObjectId = Object_Founder.Id
                              AND ObjectLink_Founder_InfoMoney.DescId = zc_ObjectLink_Founder_InfoMoney()
          -- LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Founder_InfoMoney.ChildObjectId
          LEFT JOIN tmpInfoMoney_View AS Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Founder_InfoMoney.ChildObjectId
          LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = zc_Enum_Currency_Basis()
    WHERE Object_Founder.DescId = zc_Object_Founder()
      AND Object_Founder.isErased = FALSE
      AND vbIsConstraint = FALSE
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_MoneyPlaceCash (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 01.09.18         * add Car
 21.05.17         * 
 03.09.14                                        * add zc_Object_Founder
 28.08.14                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_MoneyPlaceCash (inSession:= '300547') AS tmp WHERE CarName <> ''
