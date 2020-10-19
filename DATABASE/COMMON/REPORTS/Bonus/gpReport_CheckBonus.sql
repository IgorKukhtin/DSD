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
      FROM gpReport_CheckBonusTest (inStartDate           := inStartDate                                --gpReport_CheckBonusTest2_old
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
      FROM gpReport_CheckBonusTest (inStartDate           := inStartDate                                --gpReport_CheckBonusTest2_old
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
