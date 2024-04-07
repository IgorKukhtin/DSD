-- FunctiON: gpReport_CheckBonus ()

DROP FUNCTION IF EXISTS gpReport_CheckBonus (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpReport_CheckBonus (TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_CheckBonus (TDateTime, TDateTime, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpReport_CheckBonus (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpReport_CheckBonus (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpReport_CheckBonus (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_CheckBonus (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CheckBonus (
    IN inStartDate           TDateTime ,
    IN inEndDate             TDateTime ,
    IN inPaidKindID          Integer   ,
    IN inJuridicalId         Integer   ,
    IN inBranchId            Integer   ,
    IN inMemberId            Integer   , 
    IN inIsMovement          Boolean   , -- по документам
    IN inisDetail            Boolean   , -- детализация  выводим группу тов, произ площадку, Goods_Business, GoodsTag, GoodsGroupAnalyst
    IN inisGoods             Boolean   , -- выводим товар + вид товара
    IN inSessiON             TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate_Movement TDateTime, OperDatePartner TDateTime, InvNumber_Movement TVarChar, DescName_Movement TVarChar
             , ContractId_master Integer, ContractId_child Integer, ContractId_find Integer
             , InvNumber_master TVarChar, InvNumber_child TVarChar, InvNumber_find TVarChar
             , ContractCode_master Integer, ContractCode_child Integer, ContractCode_find Integer
             , ContractTagName_child TVarChar, ContractStateKindCode_child Integer
             , InfoMoneyId_master Integer, InfoMoneyId_child Integer, InfoMoneyId_find Integer
             , InfoMoneyName_master TVarChar, InfoMoneyName_child TVarChar, InfoMoneyName_find TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , PaidKindId_Child Integer, PaidKindName_Child TVarChar
             , ConditionKindId Integer, ConditionKindName TVarChar
             , BonusKindId Integer, BonusKindName TVarChar
             , BranchId Integer, BranchName TVarChar
             , BranchId_inf Integer, BranchName_inf TVarChar
             , RetailName TVarChar
             , PersonalTradeId Integer, PersonalTradeCode Integer, PersonalTradeName TVarChar
             , PersonalId Integer, PersonalCode Integer, PersonalName TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , AreaId Integer, AreaName TVarChar
             , Value TFloat

             , Sum_CheckBonus      TFloat
             , Sum_CheckBonusFact  TFloat 
             , Sum_Bonus           TFloat
             , Sum_BonusFact       TFloat
             , Sum_SaleFact        TFloat
             , Sum_SaleReturnIn    TFloat
             , Sum_Account         TFloat
             , Sum_AccountSendDebt TFloat
             , Sum_Sale            TFloat
             , Sum_Return          TFloat

             , Sum_Sale_weight TFloat
             , Sum_ReturnIn_weight TFloat

             , PercentRetBonus  TFloat
             , PercentRetBonus_fact  TFloat
             , PercentRetBonus_diff  TFloat
             , PercentRetBonus_fact_weight TFloat
             , PercentRetBonus_diff_weight TFloat

             , AmountKg  TFloat
             , AmountSh  TFloat
             , PartKg    TFloat

             , Comment TVarChar
             , ReportBonusId Integer, isSend Boolean
             , isSalePart Boolean

            , GoodsCode Integer
            , GoodsName TVarChar
            , GoodsKindName TVarChar
            , GoodsGroupName        TVarChar
            , GoodsGroupNameFull    TVarChar
            , BusinessName          TVarChar
            , GoodsTagName          TVarChar
            , GoodsPlatformName     TVarChar
            , GoodsGroupAnalystName TVarChar 

            , CurrencyId_child         Integer
            , CurrencyName_child       TVarChar
            , Sum_CheckBonus_curr      TFloat
            , Sum_Bonus_curr           TFloat
            , Sum_Account_curr         TFloat
            , Sum_AccountSendDebt_curr TFloat
            , Sum_Sale_curr            TFloat
            , Sum_Return_curr          TFloat
            , Sum_SaleReturnIn_curr    TFloat
              ) 
AS
$BODY$
    --DECLARE inisMovement Boolean ; -- по документам
    DECLARE vbBranchId   Integer;
    DECLARE vbUserId Integer;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     -- нашли филиал
     vbBranchId := (SELECT tmp.BranchId FROM gpGet_UserParams_bonus (inSession:= inSession) AS tmp);

     IF NOT EXISTS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId)
        AND (vbBranchId <> zc_Branch_Basis()) AND (COALESCE (vbBranchId,0) <> 0)
        AND vbUserId <> 471654 -- Холод А.В.
     THEN
         IF (inBranchId <> vbBranchId)
         THEN
              RAISE EXCEPTION 'Ошибка.Нет прав для просмотра данных, необходимо выбрать <%>.', lfGet_Object_ValueData_sh (vbBranchId);
         END IF;

         IF (inPaidKindId <> zc_Enum_PaidKind_SecondForm())
         THEN
              RAISE EXCEPTION 'Ошибка.Нет прав для просмотра данных, необходимо выбрать форму оплаты = <%>.', lfGet_Object_ValueData_sh (zc_Enum_PaidKind_SecondForm());
         END IF;
         
     -- Павлов Д.В.
     ELSEIF vbUserId IN (5080994)
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


     -- Няйко В.И. + Мурзаева Е.В. - zc_Branch_Basis + филиал Кр.Рог
     ELSEIF vbUserId IN (1058530, 714692)
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
    
     /* -- расче в  lpReport_CheckBonus  - 
      WITH 
      tmpObjectBonus AS (SELECT DISTINCT
                                ObjectLink_Juridical.ChildObjectId             AS JuridicalId
                              , COALESCE (ObjectLink_Partner.ChildObjectId, 0) AS PartnerId
                              , ObjectLink_ContractMaster.ChildObjectId        AS ContractId_master
                              , ObjectLink_ContractChild.ChildObjectId         AS ContractId_child
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
                              LEFT JOIN ObjectLink AS ObjectLink_ContractMaster
                                                   ON ObjectLink_ContractMaster.ObjectId = Object_ReportBonus.Id
                                                  AND ObjectLink_ContractMaster.DescId = zc_ObjectLink_ReportBonus_ContractMaster()
                              LEFT JOIN ObjectLink AS ObjectLink_ContractChild
                                                   ON ObjectLink_ContractChild.ObjectId = Object_ReportBonus.Id
                                                  AND ObjectLink_ContractChild.DescId = zc_ObjectLink_ReportBonus_ContractChild()
                         WHERE Object_ReportBonus.DescId   = zc_Object_ReportBonus()
                           AND inPaidKindID                = zc_Enum_PaidKind_SecondForm()
                         --AND Object_ReportBonus.isErased = TRUE
                        )
      */ 
      -- Результат
      SELECT tmp.OperDate_Movement, tmp.OperDatePartner, tmp.InvNumber_Movement, tmp.DescName_Movement
           , tmp.ContractId_master, tmp.ContractId_child, tmp.ContractId_find
           , tmp.InvNumber_master, tmp.InvNumber_child, tmp.InvNumber_find
           , Contract_Master.ObjectCode AS ContractCode_master
           , Contract_Child.ObjectCode  AS ContractCode_child
           , Contract_Find.ObjectCode   AS ContractCode_find

           , tmp.ContractTagName_child, tmp.ContractStateKindCode_child
           , tmp.InfoMoneyId_master, tmp.InfoMoneyId_child, tmp.InfoMoneyId_find
           , tmp.InfoMoneyName_master, tmp.InfoMoneyName_child, tmp.InfoMoneyName_find
           , tmp.JuridicalId, tmp.JuridicalName
           , tmp.PaidKindId, tmp.PaidKindName
           , tmp.PaidKindId_Child, tmp.PaidKindName_Child
           , tmp.ConditionKindId, tmp.ConditionKindName
           , tmp.BonusKindId, tmp.BonusKindName
           , tmp.BranchId, tmp.BranchName
           , tmp.BranchId_inf, tmp.BranchName_inf
           , tmp.RetailName
           , tmp.PersonalTradeId
           , tmp.PersonalTradeCode
           , tmp.PersonalTradeName
           , tmp.PersonalId
           , tmp.PersonalCode
           , tmp.PersonalName
           , tmp.PartnerId
           , tmp.PartnerName
           , tmp.AreaId
           , tmp.AreaName
           , tmp.Value
           , tmp.Sum_CheckBonus
           , tmp.Sum_CheckBonusFact
           , tmp.Sum_Bonus
           , tmp.Sum_BonusFact
           , tmp.Sum_SaleFact
           , tmp.Sum_SaleReturnIn
           , tmp.Sum_Account
           , tmp.Sum_AccountSendDebt
           , tmp.Sum_Sale
           , tmp.Sum_Return
           , tmp.Sum_Sale_weight
           , tmp.Sum_ReturnIn_weight
           , tmp.PercentRetBonus
           , tmp.PercentRetBonus_fact
           , tmp.PercentRetBonus_diff
           , tmp.PercentRetBonus_fact_weight
           , tmp.PercentRetBonus_diff_weight
           , tmp.AmountKg  ::TFloat
           , tmp.AmountSh  ::TFloat
           , tmp.PartKg    ::TFloat
           , tmp.Comment
           --, tmpObjectBonus.Id :: Integer AS ReportBonusId
           --, CASE WHEN tmpObjectBonus.Id IS NULL OR tmpObjectBonus.isErased = TRUE THEN TRUE ELSE FALSE END :: Boolean AS isSend
           , tmp.ReportBonusId
           , tmp.isSend
           , tmp.isSalePart

           , tmp.GoodsCode             ::Integer
           , tmp.GoodsName             ::TVarChar
           , tmp.GoodsKindName         ::TVarChar 
           , tmp.GoodsGroupName        ::TVarChar
           , tmp.GoodsGroupNameFull    ::TVarChar
           , tmp.BusinessName          ::TVarChar
           , tmp.GoodsTagName          ::TVarChar
           , tmp.GoodsPlatformName     ::TVarChar
           , tmp.GoodsGroupAnalystName ::TVarChar

           , tmp.CurrencyId_child         ::Integer 
           , tmp.CurrencyName_child       ::TVarChar
           , tmp.Sum_CheckBonus_curr      ::TFloat
           , tmp.Sum_Bonus_curr           ::TFloat
           , tmp.Sum_Account_curr         ::TFloat
           , tmp.Sum_AccountSendDebt_curr ::TFloat
           , tmp.Sum_Sale_curr            ::TFloat
           , tmp.Sum_Return_curr          ::TFloat
           , tmp.Sum_SaleReturnIn_curr    ::TFloat
      FROM lpReport_CheckBonus (inStartDate    := inStartDate                                --gpReport_CheckBonusTest2_old
                              , inEndDate      := inEndDate
                              , inPaidKindID   := zc_Enum_PaidKind_FirstForm()
                              , inJuridicalId  := inJuridicalId
                              , inBranchId     := inBranchId
                              , inMemberId     := inMemberId
                              , inIsMovement   := inIsMovement
                              , inisDetail     := inisDetail
                              , inisGoods      := inisGoods
                              , inSession      := inSession
                               ) AS tmp
          /* LEFT JOIN tmpObjectBonus ON tmpObjectBonus.JuridicalId = tmp.JuridicalId
                                   AND tmpObjectBonus.PartnerId   = COALESCE (tmp.PartnerId, 0)
                                   */
           LEFT JOIN Object AS Contract_Master ON Contract_Master.Id = tmp.ContractId_master
           LEFT JOIN Object AS Contract_Child ON Contract_Child.Id = tmp.ContractId_child
           LEFT JOIN Object AS Contract_Find ON Contract_Find.Id = tmp.ContractId_find

      WHERE (inPaidKindId = zc_Enum_PaidKind_FirstForm() OR COALESCE (inPaidKindId, 0) = 0)
        AND (tmp.BranchId = inBranchId OR inBranchId = 0)

  UNION ALL
      SELECT tmp.OperDate_Movement, tmp.OperDatePartner, tmp.InvNumber_Movement, tmp.DescName_Movement
           , tmp.ContractId_master, tmp.ContractId_child, tmp.ContractId_find
           , tmp.InvNumber_master, tmp.InvNumber_child, tmp.InvNumber_find
           , Contract_Master.ObjectCode AS ContractCode_master
           , Contract_Child.ObjectCode  AS ContractCode_child
           , Contract_Find.ObjectCode   AS ContractCode_find
           
           , tmp.ContractTagName_child, tmp.ContractStateKindCode_child
           , tmp.InfoMoneyId_master, tmp.InfoMoneyId_child, tmp.InfoMoneyId_find
           , tmp.InfoMoneyName_master, tmp.InfoMoneyName_child, tmp.InfoMoneyName_find
           , tmp.JuridicalId, tmp.JuridicalName
           , tmp.PaidKindId, tmp.PaidKindName
           , tmp.PaidKindId_Child, tmp.PaidKindName_Child
           , tmp.ConditionKindId, tmp.ConditionKindName
           , tmp.BonusKindId, tmp.BonusKindName
           , tmp.BranchId, tmp.BranchName
           , tmp.BranchId_inf, tmp.BranchName_inf
           , tmp.RetailName
           , tmp.PersonalTradeId
           , tmp.PersonalTradeCode
           , tmp.PersonalTradeName
           , tmp.PersonalId
           , tmp.PersonalCode
           , tmp.PersonalName
           , tmp.PartnerId
           , tmp.PartnerName
           , tmp.AreaId
           , tmp.AreaName
           , tmp.Value

           , tmp.Sum_CheckBonus
           , tmp.Sum_CheckBonusFact
           , tmp.Sum_Bonus
           , tmp.Sum_BonusFact
           , tmp.Sum_SaleFact
           , tmp.Sum_SaleReturnIn
           , tmp.Sum_Account
           , tmp.Sum_AccountSendDebt
           , tmp.Sum_Sale
           , tmp.Sum_Return

           , tmp.Sum_Sale_weight
           , tmp.Sum_ReturnIn_weight

           , tmp.PercentRetBonus
           , tmp.PercentRetBonus_fact
           , tmp.PercentRetBonus_diff
           , tmp.PercentRetBonus_fact_weight
           , tmp.PercentRetBonus_diff_weight

           , tmp.AmountKg  ::TFloat
           , tmp.AmountSh  ::TFloat
           , tmp.PartKg    ::TFloat
            
           , tmp.Comment
           --, tmpObjectBonus.Id :: Integer AS ReportBonusId
           --, CASE WHEN tmpObjectBonus.Id IS NULL OR tmpObjectBonus.isErased = TRUE THEN TRUE ELSE FALSE END :: Boolean AS isSend
           , tmp.ReportBonusId
           , tmp.isSend
           , tmp.isSalePart

           , tmp.GoodsCode             ::Integer
           , tmp.GoodsName             ::TVarChar
           , tmp.GoodsKindName         ::TVarChar 
           , tmp.GoodsGroupName        ::TVarChar
           , tmp.GoodsGroupNameFull    ::TVarChar
           , tmp.BusinessName          ::TVarChar
           , tmp.GoodsTagName          ::TVarChar
           , tmp.GoodsPlatformName     ::TVarChar
           , tmp.GoodsGroupAnalystName ::TVarChar

           , tmp.CurrencyId_child         ::Integer 
           , tmp.CurrencyName_child       ::TVarChar
           , tmp.Sum_CheckBonus_curr      ::TFloat
           , tmp.Sum_Bonus_curr           ::TFloat
           , tmp.Sum_Account_curr         ::TFloat
           , tmp.Sum_AccountSendDebt_curr ::TFloat
           , tmp.Sum_Sale_curr            ::TFloat
           , tmp.Sum_Return_curr          ::TFloat
           , tmp.Sum_SaleReturnIn_curr    ::TFloat
      FROM lpReport_CheckBonus (inStartDate     := inStartDate                                --gpReport_CheckBonusTest2_old
                              , inEndDate       := inEndDate
                              , inPaidKindID    := zc_Enum_PaidKind_SecondForm()
                              , inJuridicalId   := inJuridicalId
                              , inBranchId      := inBranchId
                              , inMemberId      := inMemberId
                              , inIsMovement    := inIsMovement
                              , inisDetail     := inisDetail
                              , inisGoods      := inisGoods
                              , inSession       := inSession
                               ) AS tmp
         /*  LEFT JOIN tmpObjectBonus ON tmpObjectBonus.JuridicalId = tmp.JuridicalId
                                   AND tmpObjectBonus.PartnerId   = COALESCE (tmp.PartnerId, 0)
                                   */

           LEFT JOIN Object AS Contract_Master ON Contract_Master.Id = tmp.ContractId_master
           LEFT JOIN Object AS Contract_Child ON Contract_Child.Id = tmp.ContractId_child
           LEFT JOIN Object AS Contract_Find ON Contract_Find.Id = tmp.ContractId_find
      
      WHERE (inPaidKindId = zc_Enum_PaidKind_SecondForm() OR COALESCE (inPaidKindId, 0) = 0)
        AND (tmp.BranchId = inBranchId OR inBranchId = 0)
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
-- select * from gpReport_CheckBonus(inStartDate := ('28.05.2020')::TDateTime , inEndDate := ('28.05.2020')::TDateTime , inPaidKindId := 3 , inJuridicalId := 344240 , inBranchId :=  8374, inMemberId:=0 ,  inIsMovement := FALSE, inSession := '5');--
-- select * from gpReport_CheckBonus(inStartDate := ('28.05.2020')::TDateTime , inEndDate := ('28.05.2020')::TDateTime , inPaidKindId := 3 , inJuridicalId := 344240 , inBranchId :=  8374, inMemberId:=0 ,  inIsMovement := FALSE,inisDetail := TRUE, inisGoods:= false, inSession := '5');--
