-- FunctiON: gpReport_CheckBonus ()

 DROP FUNCTION IF EXISTS gpReport_CheckBonus (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpReport_CheckBonus (TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_CheckBonus (TDateTime, TDateTime, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpReport_CheckBonus (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_CheckBonus (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CheckBonus (
    IN inStartDate           TDateTime ,  
    IN inEndDate             TDateTime ,
    IN inPaidKindID          Integer   ,
    IN inJuridicalId         Integer   ,
    IN inBranchId            Integer   , 
    IN inisMovement          Boolean   , -- по документам
    IN inSessiON             TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate_Movement TDateTime, OperDatePartner TDateTime, InvNumber_Movement TVarChar, DescName_Movement TVarChar
             , ContractId_master Integer, ContractId_child Integer, ContractId_find Integer, InvNumber_master TVarChar, InvNumber_child TVarChar, InvNumber_find TVarChar
             , ContractTagName_child TVarChar, ContractStateKindCode_child Integer
             , InfoMoneyId_master Integer, InfoMoneyId_find Integer
             , InfoMoneyName_master TVarChar, InfoMoneyName_child TVarChar, InfoMoneyName_find TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , PaidKindName_Child TVarChar
             , ConditionKindId Integer, ConditionKindName TVarChar
             , BonusKindId Integer, BonusKindName TVarChar
             , BranchId Integer, BranchName TVarChar
             , RetailName TVarChar, PersonalName TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , Value TFloat
             , Sum_CheckBonus TFloat
             , Sum_CheckBonusFact TFloat 
             , Sum_Bonus TFloat
             , Sum_BonusFact TFloat
             , Sum_SaleFact TFloat
             , Sum_SaleReturnIn  TFloat
             , Sum_Account  TFloat
             , PercentRetBonus  TFloat
             , PercentRetBonus_fact  TFloat
             , PercentRetBonus_diff  TFloat
             , Comment TVarChar
             , ReportBonusId Integer, isSend Boolean
              )  
AS
$BODY$
    --DECLARE inisMovement Boolean ; -- по документам
    DECLARE vbBranchId   Integer;
    DECLARE vbUserId Integer;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);

     -- нашли филиал
     vbBranchId := (SELECT tmp.BranchId FROM gpGet_UserParams_bonus (inSession:= inSession) AS tmp);

     IF NOT EXISTS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId)
        AND (vbBranchId <> zc_Branch_Basis()) AND (COALESCE (vbBranchId,0) <> 0)
     THEN
         IF (inBranchId <> vbBranchId)
         THEN
              RAISE EXCEPTION 'Ошибка.Нет прав для просмотра данных, необходимо выбрать <%>.', lfGet_Object_ValueData_sh (vbBranchId);
         END IF;

         IF (inPaidKindId <> zc_Enum_PaidKind_SecondForm())
         THEN
              RAISE EXCEPTION 'Ошибка.Нет прав для просмотра данных, необходимо выбрать форму оплаты = <%>.', lfGet_Object_ValueData_sh (zc_Enum_PaidKind_SecondForm());
         END IF;
         
     -- Павлов Д.В. + Мурзаева Е.В.
     ELSEIF vbUserId IN (5080994, 714692)
            AND (inBranchId <> zc_Branch_Basis() OR inPaidKindId <> zc_Enum_PaidKind_SecondForm())
     THEN
         IF (inBranchId <> zc_Branch_Basis())
         THEN
              RAISE EXCEPTION 'Ошибка.Нет прав для просмотра данных, необходимо выбрать <%>.', lfGet_Object_ValueData_sh (zc_Branch_Basis());
         END IF;

         IF (inPaidKindId <> zc_Enum_PaidKind_SecondForm())
         THEN
              RAISE EXCEPTION 'Ошибка.Нет прав для просмотра данных, необходимо выбрать форму оплаты = <%>.', lfGet_Object_ValueData_sh (zc_Enum_PaidKind_SecondForm());
         END IF;

     -- Спічка Є.А. - филиал Харьков + филиал Запорожье
     ELSEIF vbUserId = 5835424
            AND (inBranchId NOT IN (8381, 301310) OR inPaidKindId <> zc_Enum_PaidKind_SecondForm())
     THEN
         IF inBranchId NOT IN (8381, 301310)
         THEN
              RAISE EXCEPTION 'Ошибка.Нет прав для просмотра данных, необходимо выбрать <%> или <%>.', lfGet_Object_ValueData_sh (8381), lfGet_Object_ValueData_sh (301310);
         END IF;

         IF (inPaidKindId <> zc_Enum_PaidKind_SecondForm())
         THEN
              RAISE EXCEPTION 'Ошибка.Нет прав для просмотра данных, необходимо выбрать форму оплаты = <%>.', lfGet_Object_ValueData_sh (zc_Enum_PaidKind_SecondForm());
         END IF;

     -- Середа Ю.В. - филиал Одесса + филиал Николаев (Херсон)
     ELSEIF vbUserId = 106596
            AND (inBranchId NOT IN (8374, 8373) OR inPaidKindId <> zc_Enum_PaidKind_SecondForm())
     THEN
         IF inBranchId NOT IN (8374, 8373)
         THEN
              RAISE EXCEPTION 'Ошибка.Нет прав для просмотра данных, необходимо выбрать <%> или <%>.', lfGet_Object_ValueData_sh (8374), lfGet_Object_ValueData_sh (8373);
         END IF;

         IF (inPaidKindId <> zc_Enum_PaidKind_SecondForm())
         THEN
              RAISE EXCEPTION 'Ошибка.Нет прав для просмотра данных, необходимо выбрать форму оплаты = <%>.', lfGet_Object_ValueData_sh (zc_Enum_PaidKind_SecondForm());
         END IF;


     -- Няйко В.И. - zc_Branch_Basis + филиал Кр.Рог
     ELSEIF vbUserId = 1058530
            AND (inBranchId NOT IN (zc_Branch_Basis(), 8377) OR inPaidKindId <> zc_Enum_PaidKind_SecondForm())
     THEN
         IF inBranchId NOT IN (zc_Branch_Basis(), 8377)
         THEN
              RAISE EXCEPTION 'Ошибка.Нет прав для просмотра данных, необходимо выбрать <%> или <%>.', lfGet_Object_ValueData_sh (zc_Branch_Basis()), lfGet_Object_ValueData_sh (8377);
         END IF;

         IF (inPaidKindId <> zc_Enum_PaidKind_SecondForm())
         THEN
              RAISE EXCEPTION 'Ошибка.Нет прав для просмотра данных, необходимо выбрать форму оплаты = <%>.', lfGet_Object_ValueData_sh (zc_Enum_PaidKind_SecondForm());
         END IF;

     END IF;

    -- Результат
    RETURN QUERY

    --!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    --правильный расчет в процке gpReport_CheckBonusTest3
    --!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
      WITH 
      tmpObjectBonus AS (SELECT ObjectLink_Juridical.ChildObjectId             AS JuridicalId
                              , COALESCE (ObjectLink_Partner.ChildObjectId, 0) AS PartnerId
                              , Object_ReportBonus.Id                          AS Id
                              , Object_ReportBonus.isErased
                         FROM Object AS Object_ReportBonus
                              INNER JOIN ObjectDate AS ObjectDate_Month
                                                   ON ObjectDate_Month.ObjectId = Object_ReportBonus.Id
                                                  AND ObjectDate_Month.DescId = zc_Object_ReportBonus_Month()
                                                  AND ObjectDate_Month.ValueData =  DATE_TRUNC ('MONTH', inEndDate)
                              LEFT JOIN ObjectLink AS ObjectLink_Juridical
                                                   ON ObjectLink_Juridical.ObjectId = Object_ReportBonus.Id
                                                  AND ObjectLink_Juridical.DescId = zc_ObjectLink_ReportBonus_Juridical()
                              LEFT JOIN ObjectLink AS ObjectLink_Partner
                                                   ON ObjectLink_Partner.ObjectId = Object_ReportBonus.Id
                                                  AND ObjectLink_Partner.DescId = zc_ObjectLink_ReportBonus_Partner()
                         WHERE Object_ReportBonus.DescId   = zc_Object_ReportBonus()
                           AND inPaidKindID                = zc_Enum_PaidKind_SecondForm()
                         --AND Object_ReportBonus.isErased = TRUE
                        )
      -- Результат
      SELECT tmp.OperDate_Movement, tmp.OperDatePartner, tmp.InvNumber_Movement, tmp.DescName_Movement
           , tmp.ContractId_master, tmp.ContractId_child, tmp.ContractId_find, tmp.InvNumber_master, tmp.InvNumber_child, tmp.InvNumber_find
           , tmp.ContractTagName_child, tmp.ContractStateKindCode_child
           , tmp.InfoMoneyId_master, tmp.InfoMoneyId_find
           , tmp.InfoMoneyName_master, tmp.InfoMoneyName_child, tmp.InfoMoneyName_find
           , tmp.JuridicalId, tmp.JuridicalName
           , tmp.PaidKindId, tmp.PaidKindName
           , tmp.PaidKindName_Child
           , tmp.ConditionKindId, tmp.ConditionKindName
           , tmp.BonusKindId, tmp.BonusKindName
           , tmp.BranchId, tmp.BranchName
           , tmp.RetailName
           , tmp.PersonalName
           , tmp.PartnerId
           , tmp.PartnerName
           , tmp.Value
           , tmp.Sum_CheckBonus
           , tmp.Sum_CheckBonusFact
           , tmp.Sum_Bonus
           , tmp.Sum_BonusFact
           , tmp.Sum_SaleFact
           , tmp.Sum_SaleReturnIn
           , tmp.Sum_Account
           , tmp.PercentRetBonus
           , tmp.PercentRetBonus_fact
           , tmp.PercentRetBonus_diff
           , tmp.Comment
           , tmpObjectBonus.Id :: Integer AS ReportBonusId
           , CASE WHEN tmpObjectBonus.Id IS NULL OR tmpObjectBonus.isErased = True THEN TRUE ELSE FALSE END :: Boolean AS isSend
      FROM gpReport_CheckBonusTest2 (inStartDate           := inStartDate                                --gpReport_CheckBonusTest2
                                   , inEndDate             := inEndDate
                                   , inPaidKindID          := zc_Enum_PaidKind_FirstForm()
                                   , inJuridicalId         := inJuridicalId
                                   , inBranchId            := inBranchId
                                   , inIsMovement          := inIsMovement
                                   , inSession             := inSession
                                    ) AS tmp
           LEFT JOIN tmpObjectBonus ON tmpObjectBonus.JuridicalId = tmp.JuridicalId
                                   AND tmpObjectBonus.PartnerId   = COALESCE (tmp.PartnerId, 0)
      WHERE inPaidKindId = zc_Enum_PaidKind_FirstForm() OR COALESCE (inPaidKindId, 0) = 0

  UNION ALL
      SELECT tmp.OperDate_Movement, tmp.OperDatePartner, tmp.InvNumber_Movement, tmp.DescName_Movement
           , tmp.ContractId_master, tmp.ContractId_child, tmp.ContractId_find, tmp.InvNumber_master, tmp.InvNumber_child, tmp.InvNumber_find
           , tmp.ContractTagName_child, tmp.ContractStateKindCode_child
           , tmp.InfoMoneyId_master, tmp.InfoMoneyId_find
           , tmp.InfoMoneyName_master, tmp.InfoMoneyName_child, tmp.InfoMoneyName_find
           , tmp.JuridicalId, tmp.JuridicalName
           , tmp.PaidKindId, tmp.PaidKindName
           , tmp.PaidKindName_Child
           , tmp.ConditionKindId, tmp.ConditionKindName
           , tmp.BonusKindId, tmp.BonusKindName
           , tmp.BranchId, tmp.BranchName
           , tmp.RetailName
           , tmp.PersonalName
           , tmp.PartnerId
           , tmp.PartnerName
           , tmp.Value
           , tmp.Sum_CheckBonus
           , tmp.Sum_CheckBonusFact
           , tmp.Sum_Bonus
           , tmp.Sum_BonusFact
           , tmp.Sum_SaleFact
           , tmp.Sum_SaleReturnIn
           , tmp.Sum_Account
           , tmp.PercentRetBonus
           , tmp.PercentRetBonus_fact
           , tmp.PercentRetBonus_diff
           , tmp.Comment
           , tmpObjectBonus.Id :: Integer AS ReportBonusId
           , CASE WHEN tmpObjectBonus.Id IS NULL OR tmpObjectBonus.isErased = TRUE THEN TRUE ELSE FALSE END :: Boolean AS isSend
      FROM gpReport_CheckBonusTest2 (inStartDate           := inStartDate                                --gpReport_CheckBonusTest2 
                                   , inEndDate             := inEndDate
                                   , inPaidKindID          := zc_Enum_PaidKind_SecondForm()
                                   , inJuridicalId         := inJuridicalId
                                   , inBranchId            := inBranchId
                                   , inIsMovement          := inIsMovement
                                   , inSession             := inSession
                                    ) AS tmp
           LEFT JOIN tmpObjectBonus ON tmpObjectBonus.JuridicalId = tmp.JuridicalId
                                   AND tmpObjectBonus.PartnerId   = COALESCE (tmp.PartnerId, 0)
      WHERE inPaidKindId = zc_Enum_PaidKind_SecondForm() OR COALESCE (inPaidKindId, 0) = 0
      ;

/*
-- старый вариант

inisMovement:= FALSE;


    RETURN QUERY
      WITH 
           tmpContract_full AS (SELECT View_Contract.*
                                FROM Object_Contract_View AS View_Contract
                                WHERE (View_Contract.JuridicalId = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
                                )
         , tmpContract_all AS (SELECT *
                               FROM tmpContract_full
                               WHERE tmpContract_full.PaidKindId = inPaidKindId OR COALESCE (inPaidKindId, 0)  = 0
                              )
           -- все договора - не закрытые или для Базы
         , tmpContract_find AS (SELECT View_Contract.*
                                FROM tmpContract_full AS View_Contract
                                WHERE View_Contract.isErased = FALSE
                                  AND (View_Contract.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
                                    OR View_Contract.InfoMoneyId IN (zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                   , zc_Enum_InfoMoney_30201() -- Мясное сырье
                                                                    )
                                      )
                               )
           -- учитываем zc_Object_ContractPartner - т.е. БАЗУ берем только по этим точкам - если они установлены, иначе по всем
         , tmpContractPartner AS (WITH
                                      -- сохраненные ContractPartner
                                      tmp1 AS (SELECT ObjectLink_ContractPartner_Contract.ChildObjectId AS ContractId
                                                    , ObjectLink_ContractPartner_Partner.ChildObjectId  AS PartnerId
                                               FROM ObjectLink AS ObjectLink_ContractPartner_Contract
                                                    INNER JOIN tmpContract_full ON tmpContract_full.ContractId = ObjectLink_ContractPartner_Contract.ChildObjectId
                                                                               AND tmpContract_full.PaidKindId <> zc_Enum_PaidKind_FirstForm()

                                                    LEFT JOIN ObjectLink AS ObjectLink_ContractPartner_Partner
                                                                         ON ObjectLink_ContractPartner_Partner.ObjectId = ObjectLink_ContractPartner_Contract.ObjectId
                                                                        AND ObjectLink_ContractPartner_Partner.DescId = zc_ObjectLink_ContractPartner_Partner()
                                               WHERE ObjectLink_ContractPartner_Contract.DescId = zc_ObjectLink_ContractPartner_Contract()
                                               )
                                      --  Partner для договоров, для которых нет ContractPartner
                                    , tmp2 AS (SELECT ObjectLink_Contract_Juridical.ObjectId AS ContractId
                                                    , ObjectLink_Partner_Juridical.ObjectId  AS PartnerId
                                               FROM tmpContract_full
                                                    LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                                         ON ObjectLink_Contract_Juridical.ObjectId = tmpContract_full.ContractId --ObjectLink_Contract_Juridical.ChildObjectId = ObjectLink_Partner_Juridical.ChildObjectId      --  AS JuridicalId-- ObjectLink_Contract_Juridical.ObjectId = Object_Contract_InvNumber_View.ContractId 
                                                                        AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                                                    LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                                         ON ObjectLink_Partner_Juridical.ChildObjectId = ObjectLink_Contract_Juridical.ChildObjectId
                                                                        AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                                    LEFT JOIN (SELECT DISTINCT tmp1.ContractId FROM tmp1) AS tmpContract ON tmpContract.ContractId = tmpContract_full.ContractId --ObjectLink_Contract_Juridical.ObjectId -- ContractId
                                                WHERE tmpContract.ContractId IS NULL
                                                )

                                  SELECT tmp1.ContractId
                                       , tmp1.PartnerId
                                  FROM tmp1
                                UNION
                                  SELECT tmp2.ContractId
                                       , tmp2.PartnerId
                                  FROM tmp2
                                  )

         -- формируется список договоров, у которых есть условие по "Бонусам"
       , tmpContractConditionKind AS (SELECT -- условие договора
                                             ObjectLink_ContractConditionKind.ChildObjectId AS ContractConditionKindId
                                           , View_Contract.JuridicalId
                                           , View_Contract.InvNumber             AS InvNumber_master
                                           , View_Contract.ContractTagId         AS ContractTagId_master
                                           , View_Contract.ContractTagName       AS ContractTagName_master
                                           , View_Contract.ContractStateKindCode AS ContractStateKindCode_master
                                           , View_Contract.ContractId            AS ContractId_master
                                             -- статья из договора
                                           , View_InfoMoney.InfoMoneyId AS InfoMoneyId_master
                                             -- статья по которой будет поиск Базы
                                           , CASE WHEN View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_21501() -- Маркетинг + Бонусы за продукцию
                                                       THEN zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                  WHEN View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_21502() -- Маркетинг + Бонусы за мясное сырье
                                                       THEN zc_Enum_InfoMoney_30201() -- Мясное сырье
                                                  -- !!!для других статей - любая база!!!
                                                  WHEN View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_21500()) -- Маркетинг
                                                       THEN 0
                                                  -- !!!если это База - тогда и другую базу подтянем!!!
                                                  WHEN View_InfoMoney.InfoMoneyGroupId NOT IN (zc_Enum_InfoMoneyGroup_30000()) -- Доходы
                                                       THEN 0
                                                  ELSE COALESCE (View_InfoMoney.InfoMoneyId, 0)
                                             END AS InfoMoneyId_child

                                             -- статья из условия - ограничение при поиске Базы
                                           , COALESCE (ObjectLink_ContractCondition_InfoMoney.ChildObjectId, 0) AS InfoMoneyId_Condition
                                             -- форма оплаты
                                           , View_Contract.PaidKindId AS PaidKindId
                                             -- форма оплаты из усл.договора для расчета базы 
                                           , ObjectLink_ContractCondition_PaidKind.ChildObjectId AS PaidKindId_ContractCondition
                                             -- вид бонуса
                                           , ObjectLink_ContractCondition_BonusKind.ChildObjectId    AS BonusKindId
                                           , COALESCE (ObjectFloat_Value.ValueData, 0)               AS Value
                                           , COALESCE (ObjectFloat_PercentRetBonus.ValueData,0)      AS PercentRetBonus
                                           , COALESCE (Object_Comment.ValueData, '')                 AS Comment

                                             -- !!!прописано - где брать "базу"!!!
                                           , ObjectLink_ContractCondition_ContractSend.ChildObjectId AS ContractId_send

                                      FROM ObjectLink AS ObjectLink_ContractConditionKind
                                           INNER JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id = ObjectLink_ContractConditionKind.ObjectId
                                                                                        AND Object_ContractCondition.isErased = FALSE
                                           INNER JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                                                                ON ObjectLink_ContractCondition_Contract.ObjectId = Object_ContractCondition.Id
                                                               AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
                                           INNER JOIN tmpContract_find AS View_Contract ON View_Contract.ContractId = ObjectLink_ContractCondition_Contract.ChildObjectId
                                                                                  --  AND (View_Contract.JuridicalId = inJuridicalId OR inJuridicalId = 0)

                                           INNER JOIN ObjectFloat AS ObjectFloat_Value 
                                                                  ON ObjectFloat_Value.ObjectId = Object_ContractCondition.Id
                                                                 AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                                                                 AND ObjectFloat_Value.ValueData <> 0  

                                           LEFT JOIN ObjectFloat AS ObjectFloat_PercentRetBonus
                                                                 ON ObjectFloat_PercentRetBonus.ObjectId = Object_ContractCondition.Id
                                                                AND ObjectFloat_PercentRetBonus.DescId = zc_ObjectFloat_ContractCondition_PercentRetBonus()

                                           LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_ContractSend
                                                                ON ObjectLink_ContractCondition_ContractSend.ObjectId = Object_ContractCondition.Id
                                                               AND ObjectLink_ContractCondition_ContractSend.DescId = zc_ObjectLink_ContractCondition_ContractSend()

                                           LEFT JOIN Object AS Object_Comment ON Object_Comment.Id = Object_ContractCondition.Id
                                           LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_BonusKind
                                                                ON ObjectLink_ContractCondition_BonusKind.ObjectId = Object_ContractCondition.Id
                                                               AND ObjectLink_ContractCondition_BonusKind.DescId   = zc_ObjectLink_ContractCondition_BonusKind()
                                           LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_InfoMoney
                                                                ON ObjectLink_ContractCondition_InfoMoney.ObjectId = Object_ContractCondition.Id
                                                               AND ObjectLink_ContractCondition_InfoMoney.DescId   = zc_ObjectLink_ContractCondition_InfoMoney()
                                           LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract.InfoMoneyId

                                           LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_PaidKind
                                                                ON ObjectLink_ContractCondition_PaidKind.ObjectId = Object_ContractCondition.Id
                                                               AND ObjectLink_ContractCondition_PaidKind.DescId = zc_ObjectLink_ContractCondition_PaidKind()
                                           LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = ObjectLink_ContractCondition_PaidKind.ChildObjectId

                                      WHERE ObjectLink_ContractConditionKind.ChildObjectId IN (zc_Enum_ContractConditionKind_BonusPercentAccount()
                                                                                             , zc_Enum_ContractConditionKind_BonusPercentSaleReturn()
                                                                                             , zc_Enum_ContractConditionKind_BonusPercentSale()
                                                                                              )
                                        AND ObjectLink_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                     )
      -- для договоров (если !!!заполнены уп-статьи для условий!!!) надо найти бонусный договор (по 4-м ключам + пусто в "Типы условий договоров")
      -- т.е. условие есть в базовых, но надо подставить "маркет-договор" и начисления провести на него
    , tmpContractBonus AS (SELECT tmpContract_find.ContractId_master
                                , tmpContract_find.ContractId_find
                                , View_Contract_InvNumber_find.InfoMoneyId AS InfoMoneyId_find
                                , View_Contract_InvNumber_find.InvNumber   AS InvNumber_find
                           FROM (-- базовые договора в которых "бонусное" условие + прописано какой подставить "маркет-договор"
                                 SELECT DISTINCT
                                        tmpContractConditionKind.ContractId_master
                                      , tmpContractConditionKind.ContractId_send AS ContractId_find
                                 FROM tmpContractConditionKind
                                 WHERE tmpContractConditionKind.ContractId_send > 0
                                UNION
                                 -- остальные базовые договора для которых находим "маркет-договор"
                                 SELECT tmpContractConditionKind.ContractId_master
                                      , MAX (COALESCE (View_Contract_find_tag.ContractId, View_Contract_find.ContractId)) AS ContractId_find
                                 FROM tmpContractConditionKind
                                      -- все другие ContractCondition с этим видом бонуса
                                      INNER JOIN ObjectLink AS ObjectLink_ContractCondition_BonusKind
                                                            ON ObjectLink_ContractCondition_BonusKind.ChildObjectId = tmpContractConditionKind.BonusKindId
                                                           AND ObjectLink_ContractCondition_BonusKind.DescId        = zc_ObjectLink_ContractCondition_BonusKind()
                                      -- вид бонуса НЕ удален
                                      INNER JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id       = ObjectLink_ContractCondition_BonusKind.ObjectId
                                                                                   AND Object_ContractCondition.isErased = FALSE
                                      -- с этим процентом
                                      INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                             ON ObjectFloat_Value.ObjectId  = ObjectLink_ContractCondition_BonusKind.ObjectId
                                                            AND ObjectFloat_Value.DescId    = zc_ObjectFloat_ContractCondition_Value()
                                                            AND ObjectFloat_Value.ValueData = tmpContractConditionKind.Value

                                      -- получили сам договор
                                      INNER JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                                                            ON ObjectLink_ContractCondition_Contract.ObjectId = ObjectLink_ContractCondition_BonusKind.ObjectId
                                                           AND ObjectLink_ContractCondition_Contract.DescId   = zc_ObjectLink_ContractCondition_Contract()

                                      -- ПОИСК 1 - по 3 - м условиям, главное - ContractTagId_master
                                      LEFT JOIN tmpContract_all AS View_Contract_find_tag
                                                                ON View_Contract_find_tag.JuridicalId   = tmpContractConditionKind.JuridicalId
                                                               AND View_Contract_find_tag.InfoMoneyId   = tmpContractConditionKind.InfoMoneyId_Condition
                                                               AND View_Contract_find_tag.ContractTagId = tmpContractConditionKind.ContractTagId_master
                                                               AND tmpContractConditionKind.ContractId_send IS NULL
                                                               -- как-то работало и без этого условия
                                                               AND View_Contract_find_tag.ContractId    = ObjectLink_ContractCondition_Contract.ChildObjectId

                                      -- ПОИСК 2 - по 3 - м условиям - любой, т.е. в нем будет другой ContractTagId_master
                                      LEFT JOIN tmpContract_all AS View_Contract_find
                                                                ON View_Contract_find.JuridicalId = tmpContractConditionKind.JuridicalId
                                                               AND View_Contract_find.InfoMoneyId = tmpContractConditionKind.InfoMoneyId_Condition
                                                               AND View_Contract_find.ContractId  = ObjectLink_ContractCondition_Contract.ChildObjectId
                                                               AND View_Contract_find_tag.ContractId        IS NULL
                                                               AND tmpContractConditionKind.ContractId_send IS NULL
                                      LEFT JOIN ObjectLink AS ObjectLink_ContractConditionKind
                                                           ON ObjectLink_ContractConditionKind.ObjectId = ObjectLink_ContractCondition_Contract.ObjectId
                                                          AND ObjectLink_ContractConditionKind.DescId   = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                 WHERE -- есть статья в условии договора
                                       tmpContractConditionKind.InfoMoneyId_Condition <> 0
                                       -- !!!НЕТ самого условия договора!!!
                                   AND COALESCE (ObjectLink_ContractConditionKind.ChildObjectId, 0) = 0
                                       -- !!!НЕ прописано - где брать "базу"!!!
                                   AND tmpContractConditionKind.ContractId_send IS NULL

                                 GROUP BY tmpContractConditionKind.ContractId_master
                                ) AS tmpContract_find
                                LEFT JOIN tmpContract_all AS View_Contract_InvNumber_find ON View_Contract_InvNumber_find.ContractId = tmpContract_find.ContractId_find
                           WHERE tmpContract_find.ContractId_find <> 0
                          )
      -- для всех юр лиц, у кого есть "Бонусы" формируется список всех других договоров (по ним будем делать расчет "базы")
    , tmpContract AS (SELECT tmpContractConditionKind.JuridicalId
                           , tmpContractConditionKind.InvNumber_master
                           , tmpContractConditionKind.InvNumber_master  AS InvNumber_child
                           , tmpContractConditionKind.ContractId_master
                           , tmpContractConditionKind.ContractId_master AS ContractId_child
                           , tmpContractConditionKind.ContractTagName_master       AS ContractTagName_child
                           , tmpContractConditionKind.ContractStateKindCode_master AS ContractStateKindCode_child
                           , tmpContractConditionKind.InfoMoneyId_master
                           , tmpContractConditionKind.InfoMoneyId_child
                           , tmpContractConditionKind.InfoMoneyId_Condition
                           , tmpContractConditionKind.PaidKindId
                           , tmpContractConditionKind.PaidKindId        AS PaidKindId_byBase
                           , tmpContractConditionKind.ContractConditionKindId
                           , tmpContractConditionKind.BonusKindId
                           , tmpContractConditionKind.Value
                           , tmpContractConditionKind.PercentRetBonus
                           , tmpContractConditionKind.Comment
                      FROM tmpContractConditionKind
                      WHERE tmpContractConditionKind.InfoMoneyId_master = tmpContractConditionKind.InfoMoneyId_child -- это будут не бонусные договора (но в них есть бонусы)
                    UNION ALL
                      SELECT tmpContractConditionKind.JuridicalId
                           , tmpContractConditionKind.InvNumber_master
                           , View_Contract_child.InvNumber  AS InvNumber_child
                           , tmpContractConditionKind.ContractId_master
                           , View_Contract_child.ContractId AS ContractId_child
                           , View_Contract_child.ContractTagName       AS ContractTagName_child
                           , View_Contract_child.ContractStateKindCode AS ContractStateKindCode_child
                           , tmpContractConditionKind.InfoMoneyId_master
                           , tmpContractConditionKind.InfoMoneyId_child
                           , tmpContractConditionKind.InfoMoneyId_Condition
                           , tmpContractConditionKind.PaidKindId
                           -- берем ФО из усл.договора для нач. базы если не пусто , если фо не выбрана берем из догоовра 
                           --(т.е. договор по форме НАЛ, отчет по форме НАЛ, а базу надо будет вытянуть по форме БН)
                           , CASE WHEN COALESCE (tmpContractConditionKind.PaidKindId_ContractCondition, 0) <> 0 THEN tmpContractConditionKind.PaidKindId_ContractCondition ELSE tmpContractConditionKind.PaidKindId END AS PaidKindId_byBase
                           , tmpContractConditionKind.ContractConditionKindId
                           , tmpContractConditionKind.BonusKindId
                           , tmpContractConditionKind.Value
                           , tmpContractConditionKind.PercentRetBonus
                           , tmpContractConditionKind.Comment
                      FROM tmpContractConditionKind
                           INNER JOIN tmpContract_full AS View_Contract_child
                                                       ON View_Contract_child.JuridicalId = tmpContractConditionKind.JuridicalId
                                                      AND View_Contract_child.InfoMoneyId = tmpContractConditionKind.InfoMoneyId_child
                      WHERE tmpContractConditionKind.InfoMoneyId_master <> tmpContractConditionKind.InfoMoneyId_child -- это будут бонусные договора
                     )
        
      -- группируем договора, т.к. "базу" будем формировать по 4-м ключам
    ,tmpContractGroup AS (SELECT tmpContract.JuridicalId
                               , tmpContract.ContractId_child
                               , tmpContract.InfoMoneyId_child
                               , tmpContract.PaidKindId_byBase
                           FROM tmpContract
                           -- WHERE (tmpContract.PaidKindId = inPaidKindId OR inPaidKindId = 0)
                           --  AND (tmpContract.JuridicalId = inJuridicalId OR inJuridicalId = 0)
                           GROUP BY tmpContract.JuridicalId
                                  , tmpContract.ContractId_child
                                  , tmpContract.InfoMoneyId_child
                                  , tmpContract.PaidKindId_byBase
                          )
                          
      -- список ContractId по которым будет расчет "базы"
    , tmpAccount AS (SELECT Object_Account_View.AccountId FROM Object_Account_View WHERE Object_Account_View.AccountGroupId <> zc_Enum_AccountGroup_110000()) -- Транзит
    , tmpContainer AS (SELECT DISTINCT
                              Container.Id  AS ContainerId
                            , tmpContractGroup.JuridicalId
                            , tmpContractGroup.ContractId_child
                            , tmpContractGroup.InfoMoneyId_child
                            , tmpContractGroup.PaidKindId_byBase
                            , COALESCE (ContainerLO_Branch.ObjectId,0) AS BranchId
                       FROM tmpAccount
                            JOIN Container ON Container.ObjectId = tmpAccount.AccountId
                                          AND Container.DescId = zc_Container_Summ()

                            JOIN ContainerLinkObject AS ContainerLO_Juridical ON ContainerLO_Juridical.ContainerId = Container.Id
                                                                             AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical() 
                            JOIN ContainerLinkObject AS ContainerLO_Contract ON ContainerLO_Contract.ContainerId = Container.Id
                                                                            AND ContainerLO_Contract.DescId = zc_ContainerLinkObject_Contract() 
                            JOIN ContainerLinkObject AS ContainerLO_InfoMoney ON ContainerLO_InfoMoney.ContainerId = Container.Id
                                                                             AND ContainerLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()                               
                            JOIN ContainerLinkObject AS ContainerLO_PaidKind ON ContainerLO_PaidKind.ContainerId = Container.Id
                                                                            AND ContainerLO_PaidKind.DescId = zc_ContainerLinkObject_PaidKind() 

                            JOIN ContainerLinkObject AS CLO_Partner
                                                     ON CLO_Partner.ContainerId = Container.Id
                                                    AND CLO_Partner.DescId = zc_ContainerLinkObject_Partner()
                            -- ограничиваем контрагентами --
                            INNER JOIN tmpContractPartner ON tmpContractPartner.PartnerId = CLO_Partner.ObjectId

                            -- ограничение по 4-м ключам
                            JOIN tmpContractGroup ON tmpContractGroup.JuridicalId       = ContainerLO_Juridical.ObjectId 
                                                 AND tmpContractGroup.ContractId_child  = ContainerLO_Contract.ObjectId
                                                 AND tmpContractGroup.InfoMoneyId_child = ContainerLO_InfoMoney.ObjectId
                                                 AND tmpContractGroup.PaidKindId_byBase = ContainerLO_PaidKind.ObjectId
                                                 
                            LEFT JOIN ContainerLinkObject AS ContainerLO_Branch
                                                          ON ContainerLO_Branch.ContainerId = Container.Id
                                                         AND ContainerLO_Branch.DescId = zc_ContainerLinkObject_Branch()
                       WHERE COALESCE (ContainerLO_Branch.ObjectId,0) = inBranchId OR inBranchId = 0
                       -- WHERE Container.ObjectId <> zc_Enum_Account_50401() -- "Маркетинг"
                       --   AND Container.ObjectId <> zc_Enum_AccountDirection_70300() нужно убрать проводки по оплате маркетинга
                       )
 
      , tmpMovementCont AS (SELECT tmpContainer.JuridicalId
                                 , tmpContainer.ContractId_child
                                 , tmpContainer.InfoMoneyId_child
                                 , tmpContainer.PaidKindId_byBase
                                 , tmpContainer.BranchId
                                 , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Sale() THEN MIContainer.Amount ELSE 0 END) AS Sum_Sale -- Только продажи
                                 , SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn()) THEN MIContainer.Amount ELSE 0 END) AS Sum_SaleReturnIn -- продажи - возвраты
                                 , SUM (CASE WHEN MIContainer.MovementDescId IN (zc_Movement_BankAccount(), zc_Movement_Cash()/*, zc_Movement_SendDebt()*/)
                                                  THEN -1 * MIContainer.Amount
                                             ELSE 0
                                        END) AS Sum_Account -- оплаты
                                 
                                 , SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_ReturnIn() THEN MIContainer.Amount ELSE 0 END) AS Sum_Return  -- возврат
                                 , CASE WHEN inisMovement = TRUE THEN MIContainer.MovementDescId ELSE 0 END  AS MovementDescId
                                 , CASE WHEN inisMovement = TRUE THEN MIContainer.MovementId ELSE 0 END      AS MovementId

                            FROM MovementItemContainer AS MIContainer
                                 JOIN tmpContainer ON tmpContainer.ContainerId = MIContainer.ContainerId
                            WHERE MIContainer.DescId = zc_MIContainer_Summ()
                              AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                              AND MIContainer.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_BankAccount(),zc_Movement_Cash()/*, zc_Movement_SendDebt()*/)
                            GROUP BY tmpContainer.JuridicalId
                                   , tmpContainer.ContractId_child
                                   , tmpContainer.InfoMoneyId_child
                                   , tmpContainer.PaidKindId_byBase
                                   , CASE WHEN inisMovement = TRUE THEN MIContainer.MovementDescId ELSE 0 END
                                   , CASE WHEN inisMovement = TRUE THEN MIContainer.MovementId ELSE 0 END
                                   , tmpContainer.BranchId
                            )

      , tmpMovement AS (SELECT tmpGroup.JuridicalId
                             , tmpGroup.ContractId_child 
                             , tmpGroup.InfoMoneyId_child
                             , tmpGroup.PaidKindId_byBase
                             , tmpGroup.BranchId
                             , tmpGroup.MovementId
                             , tmpGroup.MovementDescId
                             , tmpGroup.Sum_Sale
                             , tmpGroup.Sum_SaleReturnIn
                             , tmpGroup.Sum_Account
                             --расчитывем % возврата факт = факт возврата / факт отгрузки * 100
                             , CASE WHEN COALESCE (tmpGroup.Sum_Sale,0) <> 0 THEN tmpGroup.Sum_Return / tmpGroup.Sum_Sale * 100 ELSE 0 END AS PercentRetBonus_fact
                        FROM 
                            (SELECT tmpGroup.JuridicalId
                                  , tmpGroup.ContractId_child 
                                  , tmpGroup.InfoMoneyId_child
                                  , tmpGroup.PaidKindId_byBase
                                  , tmpGroup.BranchId
                                  , tmpGroup.MovementId
                                  , tmpGroup.MovementDescId
                                  , SUM (tmpGroup.Sum_Sale)    AS Sum_Sale
                                  , SUM (tmpGroup.Sum_SaleReturnIn) AS Sum_SaleReturnIn
                                  , SUM (tmpGroup.Sum_Account) AS Sum_Account
                                  , SUM (tmpGroup.Sum_Return)  AS Sum_Return
                             FROM tmpMovementCont AS tmpGroup
                             GROUP BY tmpGroup.JuridicalId
                                    , tmpGroup.ContractId_child
                                    , tmpGroup.InfoMoneyId_child
                                    , tmpGroup.PaidKindId_byBase
                                    , tmpGroup.MovementId
                                    , tmpGroup.MovementDescId
                                    , tmpGroup.BranchId
                             ) AS tmpGroup
                       )

           , tmpAll as(SELECT tmpContract.InvNumber_master
                            , tmpContract.InvNumber_child
                            , CASE WHEN tmpContract.InfoMoneyId_Condition <> 0
                                        THEN tmpContractBonus.InvNumber_find
                                   ELSE tmpContract.InvNumber_master
                              END AS InvNumber_find

                            , tmpContract.ContractTagName_child
                            , tmpContract.ContractStateKindCode_child

                            , tmpContract.ContractId_master
                            , tmpContract.ContractId_child 
                            , CASE WHEN tmpContract.InfoMoneyId_Condition <> 0
                                        THEN tmpContractBonus.ContractId_find
                                   ELSE tmpContract.ContractId_master
                              END AS ContractId_find

                            , tmpContract.InfoMoneyId_master
                            , tmpContract.InfoMoneyId_child 
                            , CASE WHEN tmpContract.InfoMoneyId_Condition <> 0
                                        THEN tmpContractBonus.InfoMoneyId_find
                                   WHEN tmpContract.InfoMoneyId_master = zc_Enum_InfoMoney_30101() -- Готовая продукция
                                        THEN zc_Enum_InfoMoney_21501() -- Маркетинг + Бонусы за продукцию
                                   WHEN tmpContract.InfoMoneyId_master = zc_Enum_InfoMoney_30201() -- Мясное сырье
                                        THEN zc_Enum_InfoMoney_21502() -- Маркетинг + Бонусы за мясное сырье
                                   ELSE tmpContract.InfoMoneyId_master
                              END AS InfoMoneyId_find

                            , tmpContract.JuridicalId AS JuridicalId
                            -- подменяем обратно ФО bз усл.договора на ФО из договора
                            , tmpContract.PaidKindId                                 --tmpMovement.PaidKindId AS PaidKindId
                            , tmpContract.ContractConditionKindId
                            , tmpContract.BonusKindId
                            , tmpContract.Value

                            , CAST (CASE WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentSale() THEN tmpMovement.Sum_Sale 
                                         WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentSaleReturn() THEN tmpMovement.Sum_SaleReturnIn
                                         WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentAccount() THEN tmpMovement.Sum_Account
                                    ELSE 0 END  AS TFloat) AS Sum_CheckBonus

                            --когда % возврата факт превышает % возврата план, бонус не начисляется 
                            , CAST (CASE WHEN (COALESCE (tmpContract.PercentRetBonus,0) <> 0 AND tmpMovement.PercentRetBonus_fact > tmpContract.PercentRetBonus) THEN 0 
                                         ELSE 
                                            CASE WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentSale() THEN (tmpMovement.Sum_Sale/100 * tmpContract.Value)
                                                 WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentSaleReturn() THEN (tmpMovement.Sum_SaleReturnIn/100 * tmpContract.Value) 
                                                 WHEN tmpContract.ContractConditionKindID = zc_Enum_ContractConditionKind_BonusPercentAccount() THEN (tmpMovement.Sum_Account/100 * tmpContract.Value)
                                            ELSE 0 END
                                    END  AS NUMERIC (16, 2)) AS Sum_Bonus
                            , 0 :: TFloat                  AS Sum_BonusFact
                            , 0 :: TFloat                  AS Sum_CheckBonusFact
                            , 0 :: TFloat                  AS Sum_SaleFact
                            , tmpContract.Comment
                  
                            , tmpMovement.MovementId
                            , tmpMovement.MovementDescId
                            , tmpMovement.BranchId
                       FROM tmpContract
                            INNER JOIN tmpMovement ON tmpMovement.JuridicalId       = tmpContract.JuridicalId
                                                  AND tmpMovement.ContractId_child  = tmpContract.ContractId_child
                                                  AND tmpMovement.InfoMoneyId_child = tmpContract.InfoMoneyId_child
                                                  AND tmpMovement.PaidKindId_byBase = tmpContract.PaidKindId_byBase
                            LEFT JOIN tmpContractBonus ON tmpContractBonus.ContractId_master = tmpContract.ContractId_master

                     UNION ALL 
                       SELECT View_Contract_InvNumber_master.InvNumber AS InvNumber_master
                            , View_Contract_InvNumber_child.InvNumber AS InvNumber_child
                            , View_Contract_InvNumber_find.InvNumber AS InvNumber_find

                            , View_Contract_InvNumber_child.ContractTagName  AS ContractTagName_child
                            , View_Contract_InvNumber_child.ContractStateKindCode AS ContractStateKindCode_child

                            , MILinkObject_ContractMaster.ObjectId           AS ContractId_master  
                            , MILinkObject_ContractChild.ObjectId            AS ContractId_child            
                            , MILinkObject_Contract.ObjectId                 AS ContractId_find

                            , View_Contract_InvNumber_master.InfoMoneyId     AS InfoMoneyId_master
                            , View_Contract_InvNumber_child.InfoMoneyId      AS InfoMoneyId_child
                            , MILinkObject_InfoMoney.ObjectId                AS InfoMoneyId_find

                            , MovementItem.ObjectId                          AS JuridicalId
                            , MILinkObject_PaidKind.ObjectId                 AS PaidKindId
                            , MILinkObject_ContractConditionKind.ObjectId    AS ContractConditionKindId
                            , MILinkObject_BonusKind.ObjectId                AS BonusKindId
                            , MIFloat_BonusValue.ValueData                   AS Value

                            , 0 :: TFloat                                    AS Sum_CheckBonus
                            , 0 :: TFloat                                    AS Sum_Bonus
                            , MovementItem.Amount                            AS Sum_BonusFact
                            , MIFloat_Summ.ValueData                         AS Sum_CheckBonusFact
                            , MIFloat_AmountPartner.ValueData                AS Sum_SaleFact
  
                            , MIString_Comment.ValueData                     AS Comment

                            , CASE WHEN inisMovement = TRUE THEN Movement.Id ELSE 0 END      AS MovementId
                            , CASE WHEN inisMovement = TRUE THEN Movement.DescId ELSE 0 END  AS MovementDescId
                            , MILinkObject_Branch.ObjectId                   AS BranchId
                     FROM Movement 
                            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()

                            LEFT JOIN MovementItemFloat AS MIFloat_BonusValue
                                                        ON MIFloat_BonusValue.MovementItemId = MovementItem.Id
                                                       AND MIFloat_BonusValue.DescId = zc_MIFloat_BonusValue()
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                            LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                                        ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                       AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                            LEFT JOIN MovementItemString AS MIString_Comment
                                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                                        AND MIString_Comment.DescId = zc_MIString_Comment()

                            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                                             ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractMaster
                                                             ON MILinkObject_ContractMaster.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_ContractMaster.DescId = zc_MILinkObject_ContractMaster()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractChild
                                                             ON MILinkObject_ContractChild.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_ContractChild.DescId = zc_MILinkObject_ContractChild()

                            LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                                             ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractConditionKind
                                                             ON MILinkObject_ContractConditionKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_ContractConditionKind.DescId = zc_MILinkObject_ContractConditionKind()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_BonusKind
                                                             ON MILinkObject_BonusKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_BonusKind.DescId = zc_MILinkObject_BonusKind()

                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                                             ON MILinkObject_Branch.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()

                            LEFT JOIN tmpContract_all AS View_Contract_InvNumber_find ON View_Contract_InvNumber_find.ContractId = MILinkObject_Contract.ObjectId
                            LEFT JOIN tmpContract_all AS View_Contract_InvNumber_master ON View_Contract_InvNumber_master.ContractId = MILinkObject_ContractMaster.ObjectId
                            LEFT JOIN tmpContract_all AS View_Contract_InvNumber_child ON View_Contract_InvNumber_child.ContractId = MILinkObject_ContractChild.ObjectId
           
                       WHERE Movement.DescId = zc_Movement_ProfitLossService()
                         AND Movement.StatusId = zc_Enum_Status_Complete()
                         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                         AND MILinkObject_InfoMoney.ObjectId IN (zc_Enum_InfoMoney_21501() -- Маркетинг + Бонусы за продукцию
                                                               , zc_Enum_InfoMoney_21502()) -- Маркетинг + Бонусы за мясное сырье
                         -- AND MILinkObject_ContractConditionKind.ObjectId IN (zc_Enum_ContractConditionKind_BonusPercentAccount(), zc_Enum_ContractConditionKind_BonusPercentSaleReturn(), zc_Enum_ContractConditionKind_BonusPercentSale())
                      )


      SELECT  Movement.OperDate                             AS OperDate_Movement
            , Movement.InvNumber                            AS InvNumber_Movement
            , MovementDesc.ItemName                         AS DescName_Movement
            , tmpAll.ContractId_master
            , tmpAll.ContractId_child
            , tmpAll.ContractId_find
            , tmpAll.InvNumber_master
            , tmpAll.InvNumber_child
            , tmpAll.InvNumber_find

            , tmpAll.ContractTagName_child
            , tmpAll.ContractStateKindCode_child

            , Object_InfoMoney_master.Id                    AS InfoMoneyId_master
            , Object_InfoMoney_find.Id                      AS InfoMoneyId_find

            , Object_InfoMoney_master.ValueData             AS InfoMoneyName_master
            , Object_InfoMoney_child.ValueData              AS InfoMoneyName_child
            , Object_InfoMoney_find.ValueData               AS InfoMoneyName_find

            , Object_Juridical.Id                           AS JuridicalId
            , Object_Juridical.ValueData                    AS JuridicalName

            , Object_PaidKind.Id                            AS PaidKindId
            , Object_PaidKind.ValueData                     AS PaidKindName

            , Object_ContractConditionKind.Id               AS ConditionKindId
            , Object_ContractConditionKind.ValueData        AS ConditionKindName

            , Object_BonusKind.Id                           AS BonusKindId
            , Object_BonusKind.ValueData                    AS BonusKindName
            
            , Object_Branch.Id                              AS BranchId
            , Object_Branch.ValueData                       AS BranchName

            , CAST (tmpAll.Value AS TFloat)                 AS Value

            , CAST (SUM (tmpAll.Sum_CheckBonus) AS TFloat)     AS Sum_CheckBonus
            , CAST (SUM (tmpAll.Sum_CheckBonusFact) AS TFloat) AS Sum_CheckBonusFact
            , CAST (SUM (tmpAll.Sum_Bonus) AS TFloat)          AS Sum_Bonus
            , CAST (SUM (tmpAll.Sum_BonusFact)*(-1) AS TFloat) AS Sum_BonusFact
            , CAST (SUM (tmpAll.Sum_SaleFact)       AS TFloat) AS Sum_SaleFact
            , MAX (tmpAll.Comment) :: TVarChar                 AS Comment
      FROM tmpAll

            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpAll.JuridicalId 
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpAll.PaidKindId
            LEFT JOIN Object AS Object_BonusKind ON Object_BonusKind.Id = tmpAll.BonusKindId
            LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = tmpAll.ContractConditionKindId
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpAll.BranchId

            LEFT JOIN Object AS Object_InfoMoney_master ON Object_InfoMoney_master.Id = tmpAll.InfoMoneyId_master
            LEFT JOIN Object AS Object_InfoMoney_child ON Object_InfoMoney_child.Id = tmpAll.InfoMoneyId_child
            LEFT JOIN Object AS Object_InfoMoney_find ON Object_InfoMoney_find.Id = tmpAll.InfoMoneyId_find

            LEFT JOIN Movement ON Movement.Id = tmpAll.MovementId
            LEFT JOIN MovementDesc ON MovementDesc.Id = tmpAll.MovementDescId
      WHERE (tmpAll.Sum_CheckBonus > 0
         OR tmpAll.Sum_Bonus > 0
         OR tmpAll.Sum_BonusFact <> 0)
        AND (tmpAll.PaidKindId = inPaidKindId OR inPaidKindId = 0)
        AND (tmpAll.JuridicalId = inJuridicalId OR inJuridicalId = 0)
        
      
      GROUP BY  tmpAll.ContractId_master
              , tmpAll.ContractId_child
              , tmpAll.ContractId_find
              , tmpAll.InvNumber_master
              , tmpAll.InvNumber_child
              , tmpAll.InvNumber_find

              , tmpAll.ContractTagName_child
              , tmpAll.ContractStateKindCode_child

              , Object_InfoMoney_master.Id
              , Object_InfoMoney_find.Id

              , Object_InfoMoney_master.ValueData
              , Object_InfoMoney_child.ValueData
              , Object_InfoMoney_find.ValueData

              , Object_Juridical.Id
              , Object_Juridical.ValueData

              , Object_PaidKind.Id
              , Object_PaidKind.ValueData

              , Object_ContractConditionKind.Id
              , Object_ContractConditionKind.ValueData

              , Object_BonusKind.Id
              , Object_BonusKind.ValueData

              , tmpAll.Value

              , Movement.OperDate
              , Movement.InvNumber 
              , MovementDesc.ItemName
              , Object_Branch.Id
              , Object_Branch.ValueData
              -- , tmpAll.Comment
    ;*/

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.05.20         * add inBranchId
 14.06.17         *
 20.05.14                                        * add View_Contract_find_tag
 08.05.14                                        * add <> 0
 01.05.14         * 
 26.04.14                                        * add ContractTagName_child and ContractStateKindCode_child
 17.04.14                                        * all
 10.04.14         *
*/
/*
     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     select lpInsertUpdate_Movement_ProfitLossService (ioId              := 0
                                                     , inInvNumber       := CAST (NEXTVAL ('movement_profitlossservice_seq') AS TVarChar) 
                                                     , inOperDate        :='31.10.2014'
                                                     , inAmountIn        := 0
                                                     , inAmountOut       := Sum_Bonus
                                                     , inComment         := ''
                                                     , inContractId      := ContractId_find
                                                     , inInfoMoneyId     := InfoMoneyId_find
                                                     , inJuridicalId     := JuridicalId
                                                     , inPaidKindId      := zc_Enum_PaidKind_FirstForm()
                                                     , inUnitId          := 0
                                                     , inContractConditionKindId   := ConditionKindId
                                                     , inBonusKindId     := BonusKindId
                                                     , inisLoad          := TRUE
                                                     , inUserId          := zfCalc_UserAdmin() :: Integer
                                                      )
    from gpReport_CheckBonus (inStartDate:= '01.10.2014', inEndDate:= '31.10.2014', inSession:= '5') as a
    where Sum_Bonus <> 0 -- and Sum_Bonus =30
*/
-- тест
-- select * from gpReport_CheckBonus (inStartDate:= '15.03.2016', inEndDate:= '15.03.2016', inPaidKindID:= zc_Enum_PaidKind_FirstForm(), inJuridicalId:= 0, inBranchId:= 0, inSession:= zfCalc_UserAdmin());
-- select * from gpReport_CheckBonus(inStartDate := ('28.05.2020')::TDateTime , inEndDate := ('28.05.2020')::TDateTime , inPaidKindId := 3 , inJuridicalId := 344240 , inBranchId :=  8374 ,  inSession := '5');--
