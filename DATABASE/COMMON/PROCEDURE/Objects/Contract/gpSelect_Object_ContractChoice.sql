-- Function: gpSelect_Object_Contract()

DROP FUNCTION IF EXISTS gpSelect_Object_ContractChoice (Integer, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractChoice(
    IN inPaidKindId     Integer,       -- Форма оплаты
    IN inShowAll        Boolean,       --
    IN inJuridicalId    Integer,       -- Юр лицо
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , InvNumber TVarChar
             , StartDate TDateTime, EndDate TDateTime
             , ContractTagId Integer, ContractTagName TVarChar, ContractKindName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , RetailId Integer, RetailName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , InfoMoneyId Integer
             , InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , ContractStateKindId Integer, ContractStateKindCode Integer, ContractStateKindName TVarChar
             , ContractComment TVarChar
             , CurrencyId Integer, CurrencyName TVarChar
             , OKPO TVarChar
             , ChangePercent TFloat
             , JuridicalBasisId Integer, JuridicalBasisName TVarChar
             , isRealEx Boolean
             , isNotTareReturning Boolean
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsConstraint Boolean;
   DECLARE vbObjectId_Constraint Integer;
   DECLARE vbBranchId_Constraint Integer;
   DECLARE vbJuridicalDescId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_ContractChoice());
   vbUserId:= lpGetUserBySession (inSession);

   -- определяется уровень доступа
   vbObjectId_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.JuridicalGroupId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.JuridicalGroupId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.JuridicalGroupId );
   vbBranchId_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId);
   vbIsConstraint:= COALESCE (vbObjectId_Constraint, 0) > 0 OR COALESCE (vbBranchId_Constraint, 0) > 0;

   -- ограничение
   CREATE TEMP TABLE _tmpPaidKind (PaidKindId Integer, PaidKindName TVarChar) ON COMMIT DROP;
   IF COALESCE (inPaidKindId,0) <> 0 
   THEN 
       INSERT INTO _tmpPaidKind (PaidKindId, PaidKindName)
          SELECT Object.Id, Object.ValueData FROM Object WHERE Object.Id = inPaidKindId;
   ELSE 
       INSERT INTO _tmpPaidKind (PaidKindId, PaidKindName)
          SELECT Object.Id, Object.ValueData FROM Object WHERE Object.DescId = zc_Object_PaidKind();
   END IF;

   IF inShowAll= TRUE AND inJuridicalId <> 0 THEN
   -- 1.1. Результат такой

    Select Object.DescId INTO vbJuridicalDescId
    FROM Object
    Where Object.Id = inJuridicalId;

    RETURN QUERY 
   WITH tmpListBranch_Constraint AS (SELECT ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                                     FROM ObjectLink AS ObjectLink_Unit_Branch
                                          INNER JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                                ON ObjectLink_Personal_Unit.ChildObjectId = ObjectLink_Unit_Branch.ObjectId
                                                               AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                          INNER JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                                                ON ObjectLink_Partner_PersonalTrade.ChildObjectId = ObjectLink_Personal_Unit.ObjectId
                                                               AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                                          INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                                ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_Partner_PersonalTrade.ObjectId
                                                               AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                     WHERE ObjectLink_Unit_Branch.ChildObjectId = vbBranchId_Constraint
                                       AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                                     GROUP BY ObjectLink_Partner_Juridical.ChildObjectId
                                    ),
        tmpJuridical AS (
                            SELECT DISTINCT
                                Object.Id
                            FROM
                                Object
                                LEFT OUTER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                           ON ObjectLink_Partner_Juridical.ChildObjectId = Object.ID
                                                          AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                LEFT OUTER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                           ON ObjectLink_Juridical_Retail.ObjectId = Object.ID
                                                          AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                            WHERE
                                (
                                    vbJuridicalDescId = zc_Object_Juridical()
                                    AND
                                    Object.Id = inJuridicalId
                                )
                                OR
                                (
                                    vbJuridicalDescId = zc_Object_Partner()
                                    AND
                                    ObjectLink_Partner_Juridical.ObjectId = inJuridicalId
                                )
                                OR
                                (
                                    vbJuridicalDescId = zc_Object_Retail()
                                    AND
                                    ObjectLink_Juridical_Retail.ChildObjectId = inJuridicalId
                                )
                        )
   SELECT
         Object_Contract_View.ContractId AS Id
       , Object_Contract_View.ContractCode AS Code
       , Object_Contract_View.InvNumber
       , Object_Contract_View.StartDate
       , Object_Contract_View.EndDate
       , Object_Contract_View.ContractTagId
       , Object_Contract_View.ContractTagName
       , Object_ContractKind.ValueData AS ContractKindName
       , Object_Juridical.Id           AS JuridicalId
       , Object_Juridical.ObjectCode   AS JuridicalCode
       , Object_Juridical.ValueData    AS JuridicalName
       , Object_Retail.Id              AS RetailId
       , Object_Retail.ValueData       AS RetailName
       , _tmpPaidKind.PaidKindId
       , _tmpPaidKind.PaidKindName

       , Object_InfoMoney_View.InfoMoneyId
       , Object_InfoMoney_View.InfoMoneyGroupCode
       , Object_InfoMoney_View.InfoMoneyGroupName
       , Object_InfoMoney_View.InfoMoneyDestinationCode
       , Object_InfoMoney_View.InfoMoneyDestinationName
       , Object_InfoMoney_View.InfoMoneyCode
       , Object_InfoMoney_View.InfoMoneyName
       , Object_InfoMoney_View.InfoMoneyName_all

       , Object_Contract_View.ContractStateKindId
       , Object_Contract_View.ContractStateKindCode
       , Object_Contract_View.ContractStateKindName
       , ObjectString_Comment.ValueData AS ContractComment 

       , Object_Currency.Id         AS CurrencyId 
       , Object_Currency.ValueData  AS CurrencyName 

       , ObjectHistory_JuridicalDetails_View.OKPO
       , tmpChangePercent.ChangePercent :: TFloat  AS ChangePercent

       , Object_JuridicalBasis.Id           AS JuridicalBasisId
       , Object_JuridicalBasis.ValueData    AS JuridicalBasisName

       , COALESCE (ObjectBoolean_RealEx.ValueData, False)             :: Boolean AS isRealEx
       , COALESCE (ObjectBoolean_NotTareReturning.ValueData, FALSE)   :: Boolean AS isNotTareReturning
       , Object_Contract_View.isErased
       
   FROM 
        tmpJuridical
        INNER JOIN Object_Contract_View ON Object_Contract_View.JuridicalId = tmpJuridical.Id
                                    -- AND Object_Contract_View.isErased = FALSE
        INNER JOIN _tmpPaidKind ON Object_Contract_View.PaidKindId = _tmpPaidKind.PaidKindId
        LEFT JOIN tmpListBranch_Constraint ON tmpListBranch_Constraint.JuridicalId = Object_Contract_View.JuridicalId
        LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractKind
                             ON ObjectLink_Contract_ContractKind.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_ContractKind.DescId = zc_ObjectLink_Contract_ContractKind()
        LEFT JOIN Object AS Object_ContractKind ON Object_ContractKind.Id = ObjectLink_Contract_ContractKind.ChildObjectId

        LEFT JOIN ObjectString AS ObjectString_Comment
                               ON ObjectString_Comment.ObjectId = Object_Contract_View.ContractId
                              AND ObjectString_Comment.DescId = zc_objectString_Contract_Comment()

        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Object_Contract_View.JuridicalId
        LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id 
              
        LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId

 	    LEFT JOIN (SELECT ObjectLink_ContractCondition_Contract.ChildObjectId AS ContractId
                        , ObjectFloat_Value.ValueData AS ChangePercent
                   FROM ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                        INNER JOIN ObjectFloat AS ObjectFloat_Value
                                               ON ObjectFloat_Value.ObjectId = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                              AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                                              AND ObjectFloat_Value.ValueData <> 0
                        INNER JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                                                     AND Object_ContractCondition.isErased = FALSE
                        LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                                              ON ObjectLink_ContractCondition_Contract.ObjectId = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                             AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                   WHERE ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = zc_Enum_ContractConditionKind_ChangePercent()
                     AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                  ) AS tmpChangePercent ON tmpChangePercent.ContractId = Object_Contract_View.ContractId

 	    LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = Object_Contract_View.JuridicalBasisId

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                             ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id
                            AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                             ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
        LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Contract_Currency
                             ON ObjectLink_Contract_Currency.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_Currency.DescId = zc_ObjectLink_Contract_Currency()
        LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = ObjectLink_Contract_Currency.ChildObjectId

        LEFT JOIN ObjectBoolean AS ObjectBoolean_RealEx
                                ON ObjectBoolean_RealEx.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_RealEx.DescId = zc_ObjectBoolean_Contract_RealEx()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_NotTareReturning
                                ON ObjectBoolean_NotTareReturning.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_NotTareReturning.DescId = zc_ObjectBoolean_Contract_NotTareReturning()

    WHERE (ObjectLink_Juridical_JuridicalGroup.ChildObjectId IN (vbObjectId_Constraint
                                                               , 8359 -- 04-Услуги
                                                                )
           OR tmpListBranch_Constraint.JuridicalId > 0
           OR vbIsConstraint = FALSE
           OR inJuridicalId <> 0
          )
   ;

   ELSE
   IF inShowAll= FALSE AND inJuridicalId <> 0 THEN

    Select Object.DescId INTO vbJuridicalDescId
    FROM Object Where Object.Id = inJuridicalId;

   -- 1.2. Результат другой
   RETURN QUERY 
   WITH tmpListBranch_Constraint AS (SELECT ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                                     FROM ObjectLink AS ObjectLink_Unit_Branch
                                          INNER JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                                ON ObjectLink_Personal_Unit.ChildObjectId = ObjectLink_Unit_Branch.ObjectId
                                                               AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                          INNER JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                                                ON ObjectLink_Partner_PersonalTrade.ChildObjectId = ObjectLink_Personal_Unit.ObjectId
                                                               AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                                          INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                                ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_Partner_PersonalTrade.ObjectId
                                                               AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                     WHERE ObjectLink_Unit_Branch.ChildObjectId = vbBranchId_Constraint
                                       AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                                     GROUP BY ObjectLink_Partner_Juridical.ChildObjectId
                                    ),
        tmpJuridical AS (
                            SELECT DISTINCT
                                Object.Id
                            FROM
                                Object
                                LEFT OUTER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                           ON ObjectLink_Partner_Juridical.ChildObjectId = Object.ID
                                                          AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                LEFT OUTER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                           ON ObjectLink_Juridical_Retail.ObjectId = Object.ID
                                                          AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                            WHERE
                                (
                                    vbJuridicalDescId = zc_Object_Juridical()
                                    AND
                                    Object.Id = inJuridicalId
                                )
                                OR
                                (
                                    vbJuridicalDescId = zc_Object_Partner()
                                    AND
                                    ObjectLink_Partner_Juridical.ObjectId = inJuridicalId
                                )
                                OR
                                (
                                    vbJuridicalDescId = zc_Object_Retail()
                                    AND
                                    ObjectLink_Juridical_Retail.ChildObjectId = inJuridicalId
                                )
                        )
   SELECT
         Object_Contract_View.ContractId AS Id
       , Object_Contract_View.ContractCode AS Code
       , Object_Contract_View.InvNumber
       , Object_Contract_View.StartDate
       , Object_Contract_View.EndDate
       , Object_Contract_View.ContractTagId
       , Object_Contract_View.ContractTagName
       , Object_ContractKind.ValueData AS ContractKindName
       , Object_Juridical.Id           AS JuridicalId
       , Object_Juridical.ObjectCode   AS JuridicalCode
       , Object_Juridical.ValueData    AS JuridicalName
       , Object_Retail.Id              AS RetailId
       , Object_Retail.ValueData       AS RetailName
       , _tmpPaidKind.PaidKindId
       , _tmpPaidKind.PaidKindName

       , Object_InfoMoney_View.InfoMoneyId
       , Object_InfoMoney_View.InfoMoneyGroupCode
       , Object_InfoMoney_View.InfoMoneyGroupName
       , Object_InfoMoney_View.InfoMoneyDestinationCode
       , Object_InfoMoney_View.InfoMoneyDestinationName
       , Object_InfoMoney_View.InfoMoneyCode
       , Object_InfoMoney_View.InfoMoneyName
       , Object_InfoMoney_View.InfoMoneyName_all

       , Object_Contract_View.ContractStateKindId
       , Object_Contract_View.ContractStateKindCode
       , Object_Contract_View.ContractStateKindName
       , ObjectString_Comment.ValueData AS ContractComment 

       , Object_Currency.Id         AS CurrencyId 
       , Object_Currency.ValueData  AS CurrencyName 

       , ObjectHistory_JuridicalDetails_View.OKPO
       , tmpChangePercent.ChangePercent :: TFloat  AS ChangePercent


       , Object_JuridicalBasis.Id           AS JuridicalBasisId
       , Object_JuridicalBasis.ValueData    AS JuridicalBasisName  
       
       , COALESCE (ObjectBoolean_RealEx.ValueData, False)             :: Boolean AS isRealEx
       , COALESCE (ObjectBoolean_NotTareReturning.ValueData, FALSE)   :: Boolean AS isNotTareReturning

       , Object_Contract_View.isErased
       
   FROM 
        tmpJuridical
        INNER JOIN Object_Contract_View ON Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                       AND Object_Contract_View.isErased = FALSE
                                       AND Object_Contract_View.JuridicalId = tmpJuridical.Id
        INNER JOIN _tmpPaidKind ON Object_Contract_View.PaidKindId = _tmpPaidKind.PaidKindId
        LEFT JOIN tmpListBranch_Constraint ON tmpListBranch_Constraint.JuridicalId = Object_Contract_View.JuridicalId
        LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractKind
                             ON ObjectLink_Contract_ContractKind.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_ContractKind.DescId = zc_ObjectLink_Contract_ContractKind()
        LEFT JOIN Object AS Object_ContractKind ON Object_ContractKind.Id = ObjectLink_Contract_ContractKind.ChildObjectId

        LEFT JOIN ObjectString AS ObjectString_Comment
                               ON ObjectString_Comment.ObjectId = Object_Contract_View.ContractId
                              AND ObjectString_Comment.DescId = zc_objectString_Contract_Comment()

        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Object_Contract_View.JuridicalId
        LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id 
              
        LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId

 	    LEFT JOIN (SELECT ObjectLink_ContractCondition_Contract.ChildObjectId AS ContractId
                        , ObjectFloat_Value.ValueData AS ChangePercent
                   FROM ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                        INNER JOIN ObjectFloat AS ObjectFloat_Value
                                               ON ObjectFloat_Value.ObjectId = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                              AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                                              AND ObjectFloat_Value.ValueData <> 0
                        INNER JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                                                     AND Object_ContractCondition.isErased = FALSE
                        LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                                              ON ObjectLink_ContractCondition_Contract.ObjectId = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                             AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                   WHERE ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = zc_Enum_ContractConditionKind_ChangePercent()
                     AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                  ) AS tmpChangePercent ON tmpChangePercent.ContractId = Object_Contract_View.ContractId

 	    LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = Object_Contract_View.JuridicalBasisId

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                             ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id
                            AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                             ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
        LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Contract_Currency
                             ON ObjectLink_Contract_Currency.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_Currency.DescId = zc_ObjectLink_Contract_Currency()
        LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = ObjectLink_Contract_Currency.ChildObjectId

        LEFT JOIN ObjectBoolean AS ObjectBoolean_RealEx
                                ON ObjectBoolean_RealEx.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_RealEx.DescId = zc_ObjectBoolean_Contract_RealEx()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_NotTareReturning
                                ON ObjectBoolean_NotTareReturning.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_NotTareReturning.DescId = zc_ObjectBoolean_Contract_NotTareReturning()

    WHERE (ObjectLink_Juridical_JuridicalGroup.ChildObjectId IN (vbObjectId_Constraint
                                                               , 8359 -- 04-Услуги
                                                                )
           OR tmpListBranch_Constraint.JuridicalId > 0
           OR vbIsConstraint = FALSE
           OR inJuridicalId <> 0
          )
   ;

   ELSE
   IF inShowAll= TRUE THEN
   -- 2.1. Результат такой
   RETURN QUERY 
   WITH tmpListBranch_Constraint AS (SELECT DISTINCT ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                                     FROM ObjectLink AS ObjectLink_Unit_Branch
                                          INNER JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                                ON ObjectLink_Personal_Unit.ChildObjectId = ObjectLink_Unit_Branch.ObjectId
                                                               AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                          INNER JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                                                ON ObjectLink_Partner_PersonalTrade.ChildObjectId = ObjectLink_Personal_Unit.ObjectId
                                                               AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                                          INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                                ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_Partner_PersonalTrade.ObjectId
                                                               AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                     WHERE ObjectLink_Unit_Branch.ChildObjectId = vbBranchId_Constraint
                                       AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                                    UNION
                                     SELECT DISTINCT ObjectLink_Contract_Juridical.ChildObjectId AS JuridicalId
                                     FROM ObjectLink AS ObjectLink_Unit_Branch
                                          INNER JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                                ON ObjectLink_Personal_Unit.ChildObjectId = ObjectLink_Unit_Branch.ObjectId
                                                               AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                          INNER JOIN ObjectLink AS ObjectLink_Contract_Personal
                                                                ON ObjectLink_Contract_Personal.ChildObjectId = ObjectLink_Personal_Unit.ObjectId
                                                               AND ObjectLink_Contract_Personal.DescId = zc_ObjectLink_Contract_Personal()
                                          INNER JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                                ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_Contract_Personal.ObjectId
                                                               AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                                     WHERE ObjectLink_Unit_Branch.ChildObjectId = vbBranchId_Constraint
                                       AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                                    )
   SELECT
         Object_Contract_View.ContractId AS Id
       , Object_Contract_View.ContractCode AS Code
       , Object_Contract_View.InvNumber
       , Object_Contract_View.StartDate
       , Object_Contract_View.EndDate
       , Object_Contract_View.ContractTagId
       , Object_Contract_View.ContractTagName
       , Object_ContractKind.ValueData AS ContractKindName
       , Object_Juridical.Id           AS JuridicalId
       , Object_Juridical.ObjectCode   AS JuridicalCode
       , Object_Juridical.ValueData    AS JuridicalName
       , Object_Retail.Id              AS RetailId
       , Object_Retail.ValueData       AS RetailName
       , _tmpPaidKind.PaidKindId
       , _tmpPaidKind.PaidKindName

       , Object_InfoMoney_View.InfoMoneyId
       , Object_InfoMoney_View.InfoMoneyGroupCode
       , Object_InfoMoney_View.InfoMoneyGroupName
       , Object_InfoMoney_View.InfoMoneyDestinationCode
       , Object_InfoMoney_View.InfoMoneyDestinationName
       , Object_InfoMoney_View.InfoMoneyCode
       , Object_InfoMoney_View.InfoMoneyName
       , Object_InfoMoney_View.InfoMoneyName_all

       , Object_Contract_View.ContractStateKindId
       , Object_Contract_View.ContractStateKindCode
       , Object_Contract_View.ContractStateKindName
       , ObjectString_Comment.ValueData AS ContractComment 

       , Object_Currency.Id         AS CurrencyId 
       , Object_Currency.ValueData  AS CurrencyName 

       , ObjectHistory_JuridicalDetails_View.OKPO
       , tmpChangePercent.ChangePercent :: TFloat  AS ChangePercent

       , Object_JuridicalBasis.Id           AS JuridicalBasisId
       , Object_JuridicalBasis.ValueData    AS JuridicalBasisName   
       
       , COALESCE (ObjectBoolean_RealEx.ValueData, False)             :: Boolean AS isRealEx
       , COALESCE (ObjectBoolean_NotTareReturning.ValueData, FALSE)   :: Boolean AS isNotTareReturning

       , Object_Contract_View.isErased
       
   FROM _tmpPaidKind
        INNER JOIN Object_Contract_View ON Object_Contract_View.PaidKindId = _tmpPaidKind.PaidKindId
                                       AND Object_Contract_View.isErased = FALSE
                                       -- AND (Object_Contract_View.JuridicalId = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
        LEFT JOIN tmpListBranch_Constraint ON tmpListBranch_Constraint.JuridicalId = Object_Contract_View.JuridicalId
        LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractKind
                             ON ObjectLink_Contract_ContractKind.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_ContractKind.DescId = zc_ObjectLink_Contract_ContractKind()
        LEFT JOIN Object AS Object_ContractKind ON Object_ContractKind.Id = ObjectLink_Contract_ContractKind.ChildObjectId

        LEFT JOIN ObjectString AS ObjectString_Comment
                               ON ObjectString_Comment.ObjectId = Object_Contract_View.ContractId
                              AND ObjectString_Comment.DescId = zc_objectString_Contract_Comment()

        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Object_Contract_View.JuridicalId
        LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id 
              
        LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId

 	    LEFT JOIN (SELECT ObjectLink_ContractCondition_Contract.ChildObjectId AS ContractId
                        , ObjectFloat_Value.ValueData AS ChangePercent
                   FROM ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                        INNER JOIN ObjectFloat AS ObjectFloat_Value
                                               ON ObjectFloat_Value.ObjectId = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                              AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                                              AND ObjectFloat_Value.ValueData <> 0
                        INNER JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                                                     AND Object_ContractCondition.isErased = FALSE
                        LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                                              ON ObjectLink_ContractCondition_Contract.ObjectId = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                                             AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                   WHERE ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = zc_Enum_ContractConditionKind_ChangePercent()
                     AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                  ) AS tmpChangePercent ON tmpChangePercent.ContractId = Object_Contract_View.ContractId

 	    LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = Object_Contract_View.JuridicalBasisId

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                             ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id
                            AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                             ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
        LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Contract_Currency
                             ON ObjectLink_Contract_Currency.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_Currency.DescId = zc_ObjectLink_Contract_Currency()
        LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = ObjectLink_Contract_Currency.ChildObjectId

        LEFT JOIN ObjectBoolean AS ObjectBoolean_RealEx
                                ON ObjectBoolean_RealEx.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_RealEx.DescId = zc_ObjectBoolean_Contract_RealEx()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_NotTareReturning
                                ON ObjectBoolean_NotTareReturning.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_NotTareReturning.DescId = zc_ObjectBoolean_Contract_NotTareReturning()

    WHERE (ObjectLink_Juridical_JuridicalGroup.ChildObjectId IN (vbObjectId_Constraint
                                                               , 8359 -- 04-Услуги
                                                                )
           OR tmpListBranch_Constraint.JuridicalId > 0
           OR vbIsConstraint = FALSE)
   ;

   ELSE
   -- 2.2. Результат другой
   RETURN QUERY 
   WITH tmpListBranch_Constraint AS (SELECT DISTINCT ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                                     FROM ObjectLink AS ObjectLink_Unit_Branch
                                          INNER JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                                ON ObjectLink_Personal_Unit.ChildObjectId = ObjectLink_Unit_Branch.ObjectId
                                                               AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                          INNER JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                                                ON ObjectLink_Partner_PersonalTrade.ChildObjectId = ObjectLink_Personal_Unit.ObjectId
                                                               AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                                          INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                                ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_Partner_PersonalTrade.ObjectId
                                                               AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                     WHERE ObjectLink_Unit_Branch.ChildObjectId = vbBranchId_Constraint
                                       AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                                    UNION
                                     SELECT DISTINCT ObjectLink_Contract_Juridical.ChildObjectId AS JuridicalId
                                     FROM ObjectLink AS ObjectLink_Unit_Branch
                                          INNER JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                                ON ObjectLink_Personal_Unit.ChildObjectId = ObjectLink_Unit_Branch.ObjectId
                                                               AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                          INNER JOIN ObjectLink AS ObjectLink_Contract_Personal
                                                                ON ObjectLink_Contract_Personal.ChildObjectId = ObjectLink_Personal_Unit.ObjectId
                                                               AND ObjectLink_Contract_Personal.DescId = zc_ObjectLink_Contract_Personal()
                                          INNER JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                                ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_Contract_Personal.ObjectId
                                                               AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                                     WHERE ObjectLink_Unit_Branch.ChildObjectId = vbBranchId_Constraint
                                       AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                                    )
     --, tmpObject_ContractCondition_PercentView AS (SELECT * FROM Object_ContractCondition_PercentView WHERE CURRENT_DATE BETWEEN Object_ContractCondition_PercentView.StartDate AND Object_ContractCondition_PercentView.EndDate)
   SELECT
         Object_Contract_View.ContractId AS Id
       , Object_Contract_View.ContractCode AS Code
       , Object_Contract_View.InvNumber
       , Object_Contract_View.StartDate
       , Object_Contract_View.EndDate
       , Object_Contract_View.ContractTagId
       , Object_Contract_View.ContractTagName
       , Object_ContractKind.ValueData AS ContractKindName
       , Object_Juridical.Id           AS JuridicalId
       , Object_Juridical.ObjectCode   AS JuridicalCode
       , Object_Juridical.ValueData    AS JuridicalName
       , Object_Retail.Id              AS RetailId
       , Object_Retail.ValueData       AS RetailName
       , _tmpPaidKind.PaidKindId
       , _tmpPaidKind.PaidKindName

       , Object_InfoMoney_View.InfoMoneyId
       , Object_InfoMoney_View.InfoMoneyGroupCode
       , Object_InfoMoney_View.InfoMoneyGroupName
       , Object_InfoMoney_View.InfoMoneyDestinationCode
       , Object_InfoMoney_View.InfoMoneyDestinationName
       , Object_InfoMoney_View.InfoMoneyCode
       , Object_InfoMoney_View.InfoMoneyName
       , Object_InfoMoney_View.InfoMoneyName_all

       , Object_Contract_View.ContractStateKindId
       , Object_Contract_View.ContractStateKindCode
       , Object_Contract_View.ContractStateKindName
       , ObjectString_Comment.ValueData AS ContractComment 

       , Object_Currency.Id         AS CurrencyId 
       , Object_Currency.ValueData  AS CurrencyName 

       , ObjectHistory_JuridicalDetails_View.OKPO
     --, tmpChangePercent.ChangePercent :: TFloat  AS ChangePercent
       , Object_Contract_View.ChangePercent


       , Object_JuridicalBasis.Id           AS JuridicalBasisId
       , Object_JuridicalBasis.ValueData    AS JuridicalBasisName

       , COALESCE (ObjectBoolean_RealEx.ValueData, False)             :: Boolean AS isRealEx
       , COALESCE (ObjectBoolean_NotTareReturning.ValueData, FALSE)   :: Boolean AS isNotTareReturning

       , Object_Contract_View.isErased
       
   FROM _tmpPaidKind
        INNER JOIN Object_Contract_View ON Object_Contract_View.PaidKindId = _tmpPaidKind.PaidKindId
                                       AND Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                       AND Object_Contract_View.isErased = FALSE
                                       -- AND (Object_Contract_View.JuridicalId = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
        LEFT JOIN tmpListBranch_Constraint ON tmpListBranch_Constraint.JuridicalId = Object_Contract_View.JuridicalId

        LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractKind
                             ON ObjectLink_Contract_ContractKind.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_ContractKind.DescId = zc_ObjectLink_Contract_ContractKind()
        LEFT JOIN Object AS Object_ContractKind ON Object_ContractKind.Id = ObjectLink_Contract_ContractKind.ChildObjectId

        LEFT JOIN ObjectString AS ObjectString_Comment
                               ON ObjectString_Comment.ObjectId = Object_Contract_View.ContractId
                              AND ObjectString_Comment.DescId = zc_objectString_Contract_Comment()

        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Object_Contract_View.JuridicalId
        LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id 
              
        LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId

      --LEFT JOIN tmpObject_ContractCondition_PercentView AS tmpChangePercent ON tmpChangePercent.ContractId = Object_Contract_View.ContractId

 	   LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = Object_Contract_View.JuridicalBasisId

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                             ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id
                            AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                             ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
        LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Contract_Currency
                             ON ObjectLink_Contract_Currency.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_Currency.DescId = zc_ObjectLink_Contract_Currency()
        LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = ObjectLink_Contract_Currency.ChildObjectId

        LEFT JOIN ObjectBoolean AS ObjectBoolean_isBranchAll
                                ON ObjectBoolean_isBranchAll.ObjectId = Object_Juridical.Id
                               AND ObjectBoolean_isBranchAll.DescId   = zc_ObjectBoolean_Juridical_isBranchAll()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_RealEx
                                ON ObjectBoolean_RealEx.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_RealEx.DescId = zc_ObjectBoolean_Contract_RealEx()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_NotTareReturning
                                ON ObjectBoolean_NotTareReturning.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_NotTareReturning.DescId = zc_ObjectBoolean_Contract_NotTareReturning()

    WHERE (ObjectLink_Juridical_JuridicalGroup.ChildObjectId IN (vbObjectId_Constraint
                                                               , 8359 -- 04-Услуги
                                                                )
           OR tmpListBranch_Constraint.JuridicalId > 0
           OR ObjectBoolean_isBranchAll.ValueData = TRUE
           OR vbIsConstraint = FALSE
           OR inJuridicalId <> 0
          )
   ;
   END IF;
   END IF;
   END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ContractChoice (Integer, Boolean, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 26.09.23         * isNotTareReturning
 21.05.17         * add Contract_Currency
 17.11.15                                                                     *
 08.09.14                                        * add Object_RoleAccessKeyGuide_View
 29.08.14                                        * add InfoMoneyName_all
 21.08.14                                        * add ContractComment
 20.05.14                                        * !!!ContractKindName - всегда!!!
 06.05.14                                        * add ChangePercent TFloat
 25.04.14                                        * add ContractTagName
 27.03.14                         * add inJuridicalId
 27.02.14         * add inPaidKindId,inShowAll
 13.02.14                                         * add zc_Enum_ContractStateKind_Close
 13.02.14                                         * change Object_Contract_View.ContractStateKindCode
 06.01.14                                         * add OKPO
 18.11.13                         *                
*/

-- тест
-- SELECT * FROM gpSelect_Object_ContractChoice (inPaidKindId:=NULL, inShowAll:= true, inJuridicalId:=1, inSession := zfCalc_UserAdmin())
