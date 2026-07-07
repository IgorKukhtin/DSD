-- FunctiON: gpReport_CommercBonus ()

DROP FUNCTION IF EXISTS gpReport_CommercBonus (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CommercBonus (
    IN inStartDate           TDateTime ,
    IN inEndDate             TDateTime ,
    IN inPaidKindId          Integer   ,
    IN inJuridicalId         Integer   ,
    IN inBranchId            Integer   ,
    IN inMemberId            Integer   , 
    IN inIsMovement          Boolean   , -- по документам
    IN inSessiON             TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId            Integer
             , OperDate_Movement     TDateTime
             , OperDatePartner       TDateTime
             , InvNumber_Movement    TVarChar
             , MovementDescName      TVarChar
             , PaidKindName_movement TVarChar
             , JuridicalId           Integer 
             , JuridicalName         TVarChar
             , PartnerId             Integer 
             , PartnerName           TVarChar
             , TotalSumm             TFloat  
             , TotalCountKg          TFloat  
             -- 
             , Amount_bonus              TFloat
             , Summa_bonus               TFloat
             , ContractId_bonus          Integer 
             , ContractCode_bonus        Integer 
             , ContractName_bonus        TVarChar
             , ContractId                Integer 
             , ContractCode              Integer 
             , ContractName              TVarChar
             , ContractConditionKindId   Integer 
             , ContractConditionKindCode Integer 
             , ContractConditionKindName TVarChar
             , ContractTagId         Integer 
             , ContractTagCode       Integer 
             , ContractTagName       TVarChar
             , ContractStateKindId   Integer 
             , ContractStateKindCode Integer 
             , ContractStateKindName TVarChar
             , BonusKindId               Integer 
             , BonusKindCode             Integer 
             , BonusKindName             TVarChar
             , PaidKindId                Integer 
             , PaidKindName              TVarChar 
  
             , InfoMoneyCode            Integer            
             , InfoMoneyGroupName       TVarChar
             , InfoMoneyDestinationName TVarChar
             , InfoMoneyName            TVarChar
             , InfoMoneyName_all        TVarChar
  
             , PersonalId   Integer 
             , PersonalCode Integer 
             , PersonalName TVarChar
             , PersonalTradeId   Integer 
             , PersonalTradeCode Integer 
             , PersonalTradeName TVarChar 
             , RetailName        TVarChar
             , BranchName        TVarChar
             , BranchName_inf    TVarChar
             , AreaName          TVarChar

              ) 
AS
$BODY$
    --DECLARE inisMovement Boolean ; -- по документам
    DECLARE vbUserId Integer;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- Результат
    RETURN QUERY

      WITH 
      tmpMovement AS (SELECT Movement.*
                           , MovementLinkObject_To.ObjectId             AS PartnerId
                           , ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                           , MovementLinkObject_PaidKind.ObjectId       AS PaidKindId
                           , Movement.DescId                            AS DescId_Movement
                      FROM Movement
                           INNER JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                                                        AND (MovementLinkObject_PaidKind.ObjectId = inPaidKindId OR inPaidKindId = 0)

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                        ON MovementLinkObject_To.MovementId = Movement.Id        
                                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                           LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                               AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                               AND (ObjectLink_Partner_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
                      WHERE Movement.DescId   = zc_Movement_Sale()
                        AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                        AND Movement.StatusId = zc_Enum_Status_Complete()
                        )
    
    , tmpMI_Detail AS (SELECT MovementItem.*
                       FROM MovementItem 
                       WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                         AND MovementItem.DescId     = zc_MI_Detail()
                         AND MovementItem.isErased   = FALSE
                      )

    , tmpMovementItemLinkObject AS (SELECT MovementItemLinkObject.*
                                    FROM MovementItemLinkObject
                                    WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_Detail.Id FROM tmpMI_Detail)
                                      AND MovementItemLinkObject.DescId IN (zc_MILinkObject_Contract()
                                                                          , zc_MILinkObject_ContractConditionKind()
                                                                          , zc_MILinkObject_BonusKind()
                                                                          , zc_MILinkObject_PaidKind()
                                                                          , zc_MILinkObject_InfoMoney()
                                                                          )
                                    )

    , tmpMovementFloat AS (SELECT MovementFloat.*
                           FROM MovementFloat
                           WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMI_Detail.MovementId FROM tmpMI_Detail)
                             AND MovementFloat.DescId IN (zc_MovementFloat_TotalSumm()
                                                        , zc_MovementFloat_CorrSumm()
                                                        , zc_MovementFloat_TotalCountKg()
                                                        )
                           )

    , tmpMovementDate AS (SELECT MovementDate.*
                          FROM MovementDate
                          WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMI_Detail.MovementId FROM tmpMI_Detail)
                            AND MovementDate.DescId IN (zc_MovementDate_OperDatePartner()
                                                       )
                          )



    , tmpData AS (SELECT CASE WHEN inIsMovement = TRUE THEN Movement.Id ELSE 0 END         AS MovementId
                       , CASE WHEN inIsMovement = TRUE THEN Movement.Invnumber ELSE '' END  AS Invnumber_Movement
                       , CASE WHEN inIsMovement = TRUE THEN Movement.OperDate ELSE Null END   AS OperDate_Movement
                       , CASE WHEN inIsMovement = TRUE THEN MovementDate_OperDatePartner.ValueData ELSE Null END AS OperDatePartner
                       , CASE WHEN inIsMovement = TRUE THEN MovementDesc.ItemName ELSE '' END AS MovementDescName
                       , Movement.PartnerId   AS PartnerId_Movement
                       , Movement.JuridicalId AS JuridicalId_Movement
                       , Movement.PaidKindId  AS PaidKindId_Movement
                       , SUM ((COALESCE (MovementFloat_TotalSumm.ValueData, 0) + COALESCE (MovementFloat_CorrSumm.ValueData, 0))) :: TFloat AS TotalSumm
                       , SUM (COALESCE (MovementFloat_TotalCountKg.ValueData,0)) AS TotalCountKg
                       --
                       , MovementItem.Amount
                       , MovementItem.ObjectId                  AS ContractId_bonus
                       , MILO_Contract.ObjectId                 AS ContractId
                       , MILO_ContractConditionKind.ObjectId    AS ContractConditionKindId
                       , MILO_BonusKind.ObjectId                AS BonusKindId
                       , MILinkObject_PaidKind.ObjectId         AS PaidKindId
                       , MILinkObject_InfoMoney.ObjectId        AS InfoMoneyId
                  FROM tmpMovement AS Movement
                       LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId_Movement
                       LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSumm
                                                  ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                                 AND MovementFloat_TotalSumm.DescId     = zc_MovementFloat_TotalSumm()
                       -- Корректировка суммы
                       LEFT JOIN tmpMovementFloat AS MovementFloat_CorrSumm
                                                  ON MovementFloat_CorrSumm.MovementId = Movement.Id
                                                 AND MovementFloat_CorrSumm.DescId     = zc_MovementFloat_CorrSumm()

                       LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCountKg
                                                  ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                                 AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()

                       LEFT JOIN tmpMovementDate AS MovementDate_OperDatePartner
                                                 ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                                AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

                       INNER JOIN tmpMI_Detail AS MovementItem
                                               ON MovementItem.MovementId = Movement.Id

                       LEFT JOIN tmpMovementItemLinkObject AS MILO_Contract
                                                           ON MILO_Contract.MovementItemId = MovementItem.Id
                                                          AND MILO_Contract.DescId = zc_MILinkObject_Contract()

                       LEFT JOIN tmpMovementItemLinkObject AS MILO_ContractConditionKind
                                                           ON MILO_ContractConditionKind.MovementItemId = MovementItem.Id
                                                          AND MILO_ContractConditionKind.DescId = zc_MILinkObject_ContractConditionKind()

                       LEFT JOIN tmpMovementItemLinkObject AS MILO_BonusKind
                                                           ON MILO_BonusKind.MovementItemId = MovementItem.Id
                                                          AND MILO_BonusKind.DescId = zc_MILinkObject_BonusKind()

                       LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_PaidKind
                                                           ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()

                       LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                        ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                  GROUP BY CASE WHEN inIsMovement = TRUE THEN Movement.Id ELSE 0 END
                         , CASE WHEN inIsMovement = TRUE THEN Movement.Invnumber ELSE '' END
                         , CASE WHEN inIsMovement = TRUE THEN Movement.OperDate ELSE Null END
                         , CASE WHEN inIsMovement = TRUE THEN MovementDate_OperDatePartner.ValueData ELSE Null END
                         , CASE WHEN inIsMovement = TRUE THEN MovementDesc.ItemName ELSE '' END
                         , Movement.PartnerId
                         , Movement.JuridicalId
                         , Movement.PaidKindId
                         --
                         , MovementItem.Amount
                         , MovementItem.ObjectId
                         , MILO_Contract.ObjectId
                         , MILO_ContractConditionKind.ObjectId
                         , MILO_BonusKind.ObjectId
                         , MILinkObject_PaidKind.ObjectId
                         , MILinkObject_InfoMoney.ObjectId                                  
                  )

    , tmpPersonal_byMember AS (SELECT ObjectLink_Personal_Member.ObjectId AS PersonalId
                               FROM ObjectLink AS ObjectLink_Personal_Member
                               WHERE ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                                 AND ObjectLink_Personal_Member.ChildObjectId = inMemberId
                                 AND COALESCE (inMemberId,0) <> 0
                               )
      -- супервайзер для строк где нет контрагента берем по MAX из всех контрагентов юр лица
    , tmpPersonal AS  (SELECT tmp.JuridicalId
                            , MAX (ObjectLink_Partner_Personal.ChildObjectId) AS PersonalId
                       FROM (SELECT tmpData.JuridicalId_movement AS JuridicalId FROM tmpData WHERE COALESCE (tmpData.PartnerId_movement ,0) =0) AS tmp
                            INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                  ON ObjectLink_Partner_Juridical.ChildObjectId = tmp.JuridicalId
                                                 AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                            LEFT JOIN ObjectLink AS ObjectLink_Partner_Personal
                                                 ON ObjectLink_Partner_Personal.ObjectId = ObjectLink_Partner_Juridical.ObjectId
                                                AND ObjectLink_Partner_Personal.DescId = zc_ObjectLink_Partner_Personal()
                       WHERE inPaidKindId = zc_Enum_PaidKind_SecondForm()
                       GROUP BY tmp.JuridicalId
                       )
      -- Результат
      SELECT tmpData.MovementId         ::Integer
           , tmpData.OperDate_Movement  ::TDateTime
           , tmpData.OperDatePartner    ::TDateTime
           , tmpData.InvNumber_Movement ::TVarChar
           , tmpData.MovementDescName   ::TVarChar
           , Object_PaidKind_Movement.ValueData ::TVarChar AS PaidKindName_movement
           , Object_Juridical.Id        ::Integer          AS JuridicalId
           , Object_Juridical.ValueData ::TVarChar         AS JuridicalName
           , Object_Partner.Id          ::Integer          AS PartnerId
           , Object_Partner.ValueData   ::TVarChar         AS PartnerName 
           , tmpData.TotalSumm          ::TFloat
           , tmpData.TotalCountKg       ::TFloat

           -- 
           , tmpData.Amount                             ::TFloat AS Amount_bonus
           , (tmpData.TotalSumm * tmpData.Amount / 100) ::TFloat AS Summa_bonus
           , Object_Contract_bonus.Id         ::Integer    AS ContractId_bonus
           , Object_Contract_bonus.ObjectCode ::Integer    AS ContractCode_bonus
           , Object_Contract_bonus.ValueData  ::TVarChar   AS ContractName_bonus

           , Object_Contract.Id                      ::Integer  AS ContractId
           , Object_Contract.ObjectCode              ::Integer  AS ContractCode
           , Object_Contract.ValueData               ::TVarChar AS ContractName
           , Object_ContractConditionKind.Id         ::Integer  AS ContractConditionKindId
           , Object_ContractConditionKind.ObjectCode ::Integer  AS ContractConditionKindCode
           , Object_ContractConditionKind.ValueData  ::TVarChar AS ContractConditionKindName

           , Object_ContractTag.Id                   ::Integer  AS ContractTagId
           , Object_ContractTag.ObjectCode           ::Integer  AS ContractTagCode
           , Object_ContractTag.ValueData            ::TVarChar AS ContractTagName
           , Object_ContractStateKind.Id             ::Integer  AS ContractStateKindId
           , Object_ContractStateKind.ObjectCode     ::Integer  AS ContractStateKindCode
           , Object_ContractStateKind.ValueData      ::TVarChar AS ContractStateKindName

           , Object_BonusKind.Id                     ::Integer  AS BonusKindId
           , Object_BonusKind.ObjectCode             ::Integer  AS BonusKindCode
           , Object_BonusKind.ValueData              ::TVarChar AS BonusKindName
           , Object_PaidKind.Id                      ::Integer  AS PaidKindId
           , Object_PaidKind.ValueData               ::TVarChar AS PaidKindName

           , Object_InfoMoney_View.InfoMoneyCode            ::Integer
           , Object_InfoMoney_View.InfoMoneyGroupName       ::TVarChar
           , Object_InfoMoney_View.InfoMoneyDestinationName ::TVarChar
           , Object_InfoMoney_View.InfoMoneyName            ::TVarChar
           , Object_InfoMoney_View.InfoMoneyName_all        ::TVarChar

           , Object_Personal.PersonalId              ::Integer      AS PersonalId
           , Object_Personal.PersonalCode            ::Integer      AS PersonalCode
           , Object_Personal.PersonalName            ::TVarChar     AS PersonalName
           , Object_PersonalTrade.PersonalId         ::Integer      AS PersonalTradeId
           , Object_PersonalTrade.PersonalCode       ::Integer      AS PersonalTradeCode
           , Object_PersonalTrade.PersonalName       ::TVarChar     AS PersonalTradeName  
           , Object_Retail.ValueData                 ::TVarChar     AS RetailName
           , Object_Branch.ValueData                 ::TVarChar     AS BranchName
           , Object_Branch_inf.ValueData             ::TVarChar     AS BranchName_inf
           , Object_Area.ValueData                   ::TVarChar     AS AreaName
      FROM tmpData
           LEFT JOIN Object AS Object_PaidKind_Movement ON Object_PaidKind_Movement.Id = tmpData.PaidKindId_Movement
           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpData.JuridicalId_Movement
           LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpData.PartnerId_Movement
           LEFT JOIN Object AS Object_Contract_bonus ON Object_Contract_bonus.Id = tmpData.ContractId_bonus
           LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = tmpData.ContractId
           LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = tmpData.ContractConditionKindId
           LEFT JOIN Object AS Object_BonusKind ON Object_BonusKind.Id = tmpData.BonusKindId
           LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpData.PaidKindId
           LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = tmpData.InfoMoneyId

           LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractTag
                                ON ObjectLink_Contract_ContractTag.ObjectId = tmpData.ContractId
                               AND ObjectLink_Contract_ContractTag.DescId = zc_ObjectLink_Contract_ContractTag()
           LEFT JOIN Object AS Object_ContractTag ON Object_ContractTag.Id = ObjectLink_Contract_ContractTag.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractStateKind
                                ON ObjectLink_Contract_ContractStateKind.ObjectId = tmpData.ContractId
                               AND ObjectLink_Contract_ContractStateKind.DescId = zc_ObjectLink_Contract_ContractStateKind() 
           LEFT JOIN Object AS Object_ContractStateKind ON Object_ContractStateKind.Id = ObjectLink_Contract_ContractStateKind.ChildObjectId

            --для бн берем из договора
           LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalTrade
                                ON ObjectLink_Contract_PersonalTrade.ObjectId = tmpData.ContractId
                               AND ObjectLink_Contract_PersonalTrade.DescId = zc_ObjectLink_Contract_PersonalTrade()
                               AND tmpData.PaidKindId = zc_Enum_PaidKind_FirstForm()
           --для нал берем из контрагента
           LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                ON ObjectLink_Partner_PersonalTrade.ObjectId = tmpData.PartnerId_Movement
                               AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                               AND (tmpData.PaidKindId = zc_Enum_PaidKind_SecondForm()
                                  OR COALESCE (ObjectLink_Contract_PersonalTrade.ChildObjectId,0) = 0
                                    )
           LEFT JOIN Object_Personal_View AS Object_PersonalTrade ON Object_PersonalTrade.PersonalId = COALESCE (ObjectLink_Partner_PersonalTrade.ChildObjectId, ObjectLink_Contract_PersonalTrade.ChildObjectId)

           LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                ON ObjectLink_Personal_PersonalServiceList.ObjectId = Object_PersonalTrade.PersonalId
                               AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
           LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Branch
                                ON ObjectLink_PersonalServiceList_Branch.ObjectId = ObjectLink_Personal_PersonalServiceList.ChildObjectId
                               AND ObjectLink_PersonalServiceList_Branch.DescId = zc_ObjectLink_PersonalServiceList_Branch()

           LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_PersonalServiceList_Branch.ChildObjectId
           
           --показываем информативно Филиал по подразделению Сотрудника ТП
           LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                ON ObjectLink_Unit_Branch.ObjectId = Object_PersonalTrade.UnitId
                               AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
           LEFT JOIN Object AS Object_Branch_inf ON Object_Branch_inf.Id = ObjectLink_Unit_Branch.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                ON ObjectLink_Juridical_Retail.ObjectId = tmpData.JuridicalId_Movement
                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
           LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Partner_Area
                                ON ObjectLink_Partner_Area.ObjectId = tmpData.PartnerId_Movement
                               AND ObjectLink_Partner_Area.DescId = zc_ObjectLink_Partner_Area()
           LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Partner_Area.ChildObjectId 
           
           LEFT JOIN tmpPersonal ON tmpPersonal.JuridicalId = tmpData.JuridicalId_Movement
           --для нал берем из контрагента
           LEFT JOIN ObjectLink AS ObjectLink_Partner_Personal
                                ON ObjectLink_Partner_Personal.ObjectId = tmpData.PartnerId_Movement
                               AND ObjectLink_Partner_Personal.DescId = zc_ObjectLink_Partner_Personal()
           LEFT JOIN Object_Personal_View AS Object_Personal ON Object_Personal.PersonalId = COALESCE (ObjectLink_Partner_Personal.ChildObjectId, tmpPersonal.PersonalId)

           -- ограничиваем по супервайзерам, если выбрали физ.лицо
           LEFT JOIN tmpPersonal_byMember ON tmpPersonal_byMember.PersonalId = Object_Personal.PersonalId

      WHERE (Object_Branch.Id = inBranchId OR inBranchId = 0) 
        AND (((tmpPersonal_byMember.PersonalId IS NOT NULL AND inPaidKindId = zc_Enum_PaidKind_SecondForm()) OR inMemberId = 0)
         OR  inPaidKindId = zc_Enum_PaidKind_FirstForm()
            )
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.06.26         *
*/

-- тест
-- select * from gpReport_CommercBonus(inStartDate := ('02.06.2026')::TDateTime , inEndDate := ('02.06.2026')::TDateTime , inPaidKindId := 0 , inJuridicalId := 0 , inBranchId := 0, inMemberId:=0 , inIsMovement := FALSE, inSession := '5');--
-- select * from gpReport_CommercBonus(inStartDate := ('02.06.2026')::TDateTime , inEndDate := ('02.06.2026')::TDateTime , inPaidKindId := 0 , inJuridicalId := 0 , inBranchId := 0, inMemberId:=0 , inIsMovement := FALSE, inSession := '5');--
