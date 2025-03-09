-- Function: gpSelect_Movement_IncomeFuel()

DROP FUNCTION IF EXISTS gpSelect_Movement_IncomeFuel (TDateTime, TDateTime, Integer, Boolean , TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_IncomeFuel(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inJuridicalBasisId  Integer , -- гл. юр.лицо
    IN inIsErased          Boolean ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, OperDate TDateTime, InvNumberMaster TVarChar, OperDateMaster TDateTime, StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime, InvNumberPartner TVarChar
             , PriceWithVAT Boolean
             , isChangePriceUser Boolean -- Ручная скидка в цене (да/нет)
             , VATPercent TFloat, ChangePrice TFloat
             , TotalCount TFloat, TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat, TotalSummVAT TFloat
             , JuridicalName_from TVarChar, FromName TVarChar, ToName TVarChar, ItemName TVarChar
             , PaidKindName TVarChar
             , ContractId Integer, ContractName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , RouteName TVarChar
             , PersonalDriverName TVarChar
             , BranchCode Integer, BranchName TVarChar
             , GoodsCode Integer, GoodsName TVarChar
             , FuelCode Integer, FuelName TVarChar
             , StartOdometre TFloat, EndOdometre TFloat
             , AmountFuel TFloat    -- норма авто
             , Reparation TFloat    -- амортизация за 1 км., грн.
             , Distance   TFloat    -- ***Пробег факт км
             , LimitMoney    TFloat, LimitMoneyChange    TFloat -- лимит грн
             , LimitDistance TFloat, LimitDistanceChange TFloat -- лимит км

             , DistanceReal   TFloat -- *Пробег общий км
             , FuelCalc       TFloat -- *Кол-во л. (расч. на пробег ф.км.)
             , FuelRealCalc   TFloat -- *Кол-во л. (использовано)

             , FuelDiff       TFloat -- *Кол-во л. (остаток лим. км.)
             , FuelSummDiff   TFloat -- *Сумма грн (остаток лим. км.)
             , SummDiff       TFloat -- *Сумма грн (остаток лим. грн)
             , SummDiffTotal  TFloat -- *Сумма грн (остаток ИТОГО)
             , SummReparation TFloat -- *Сумма грн (амортизация)
             , SummPersonal   TFloat -- *Сумма грн (ЗП итог)

             , FuelReal       TFloat -- Кол-во л. (заправка)
             , PriceCalc      TFloat -- Цена заправки
             , SummReal       TFloat -- Сумма заправки
             , SummaExp       TFloat -- Сумма затраты

             , strSign        TVarChar -- ФИО пользователей. - есть эл. подпись
             , strSignNo      TVarChar -- ФИО пользователей. - ожидается эл. подпись
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_IncomeFuel());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     -- Результат
     RETURN QUERY 
     WITH tmpRoleAccessKey_all AS (SELECT AccessKeyId, UserId FROM Object_RoleAccessKey_View)
        , tmpRoleAccessKey_user AS (SELECT AccessKeyId FROM tmpRoleAccessKey_all WHERE UserId = vbUserId GROUP BY AccessKeyId)
        , tmpAccessKey_IsDocumentAll AS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId
                                   UNION SELECT 1 AS Id FROM tmpRoleAccessKey_user WHERE AccessKeyId = zc_Enum_Process_AccessKey_DocumentAll()
                                        )
        , tmpRoleAccessKey AS (SELECT tmpRoleAccessKey_user.AccessKeyId FROM tmpRoleAccessKey_user WHERE NOT EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll)
                         UNION SELECT tmpRoleAccessKey_all.AccessKeyId FROM tmpRoleAccessKey_all WHERE EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll) GROUP BY tmpRoleAccessKey_all.AccessKeyId
                         UNION SELECT 0 AS AccessKeyId WHERE EXISTS (SELECT tmpAccessKey_IsDocumentAll.Id FROM tmpAccessKey_IsDocumentAll)
                              )
        , tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
       --
       SELECT
             Movement.Id
           , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
           , Movement.OperDate
           , Movement_Master.InvNumber         AS InvNumberMaster
           , Movement_Master.OperDate          AS OperDateMaster
           , zfCalc_StatusCode_next (Movement.StatusId, Movement.StatusId_next)                          ::Integer  AS StatusCode
           , zfCalc_StatusName_next (Object_Status.ValueData, Movement.StatusId, Movement.StatusId_next) ::TVarChar AS StatusName

           , MovementDate_OperDatePartner.ValueData    AS OperDatePartner
           , MovementString_InvNumberPartner.ValueData AS InvNumberPartner

           , MovementBoolean_PriceWithVAT.ValueData      AS PriceWithVAT
           , COALESCE (MovementBoolean_ChangePriceUser.ValueData, FALSE) AS isChangePriceUser
           , MovementFloat_VATPercent.ValueData          AS VATPercent
           , MovementFloat_ChangePrice.ValueData         AS ChangePrice

           , MovementFloat_TotalCount.ValueData          AS TotalCount
           , MovementFloat_TotalSummMVAT.ValueData       AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData       AS TotalSummPVAT
           , MovementFloat_TotalSumm.ValueData           AS TotalSumm
           , CAST (COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0) - COALESCE (MovementFloat_TotalSummMVAT.ValueData, 0) AS TFloat) AS TotalSummVAT

           , Object_JuridicalFrom.ValueData    AS JuridicalName_from
           , Object_From.ValueData             AS FromName
           , Object_To.ValueData               AS ToName
           , ObjectDesc_To.ItemName
           , Object_PaidKind.ValueData         AS PaidKindName
           , View_Contract_InvNumber.ContractId
           , View_Contract_InvNumber.InvNumber AS ContractName
           , View_InfoMoney.InfoMoneyGroupName
           , View_InfoMoney.InfoMoneyDestinationName
           , View_InfoMoney.InfoMoneyCode
           , View_InfoMoney.InfoMoneyName
           , Object_Route.ValueData            AS RouteName
           , View_PersonalDriver.PersonalName  AS PersonalDriverName
           , View_Unit.BranchCode
           , View_Unit.BranchName

           , Object_Goods.ObjectCode AS GoodsCode
           , Object_Goods.ValueData  AS GoodsName
           , Object_Fuel.ObjectCode  AS FuelCode
           , Object_Fuel.ValueData   AS FuelName

           , MovementFloat_StartOdometre.ValueData       AS StartOdometre
           , MovementFloat_EndOdometre.ValueData         AS EndOdometre
           , MovementFloat_AmountFuel.ValueData          AS AmountFuel     -- норма авто
           , MovementFloat_Reparation.ValueData          AS Reparation     -- амортизация за 1 км., грн.
           , MovementFloat_Distance.ValueData            AS Distance       -- ***Пробег факт км

           , MovementFloat_Limit.ValueData               AS LimitMoney            -- лимит грн
           , MovementFloat_LimitChange.ValueData         AS LimitMoneyChange      -- лимит грн
           , MovementFloat_LimitDistance.ValueData       AS LimitDistance         -- лимит км
           , MovementFloat_LimitDistanceChange.ValueData AS LimitDistanceChange   -- лимит км

             -- *Пробег общий км
           , (COALESCE (MovementFloat_EndOdometre.ValueData , 0) - COALESCE (MovementFloat_StartOdometre.ValueData , 0)) :: TFloat AS DistanceReal
             -- *Кол-во л. (расч. на пробег ф.км.) = пробег ф.км. * норму
           , (MovementFloat_Distance.ValueData * COALESCE (MovementFloat_AmountFuel.ValueData, 0) / 100)                 :: TFloat AS FuelCalc
             -- *Кол-во л. (использовано) = если есть лимит км. ТОГДА = МИН (пробег ф.км. ИЛИ лимит км.) * норму
           , CASE WHEN COALESCE (MovementFloat_LimitDistance.ValueData, 0) = 0 AND COALESCE (MovementFloat_LimitDistanceChange.ValueData, 0)  = 0
                       THEN 0
                  WHEN COALESCE (MovementFloat_LimitDistance.ValueData, 0) + COALESCE (MovementFloat_LimitDistanceChange.ValueData, 0) < COALESCE (MovementFloat_Distance.ValueData, 0)
                       THEN (COALESCE (MovementFloat_LimitDistance.ValueData, 0) + COALESCE (MovementFloat_LimitDistanceChange.ValueData, 0)) * COALESCE (MovementFloat_AmountFuel.ValueData, 0) / 100
                  ELSE COALESCE (MovementFloat_Distance.ValueData, 0) * COALESCE (MovementFloat_AmountFuel.ValueData, 0) / 100
             END :: TFloat AS FuelRealCalc
             -- *Кол-во л. (остаток по лим. км.) = если есть лимит км. ТОГДА = Заправка л.ф. - Кол-во л. (использовано)
           , (CASE WHEN COALESCE (MovementFloat_LimitDistance.ValueData, 0) = 0 AND COALESCE (MovementFloat_LimitDistanceChange.ValueData, 0)  = 0
                       THEN 0
                  WHEN COALESCE (MovementFloat_LimitDistance.ValueData, 0) + COALESCE (MovementFloat_LimitDistanceChange.ValueData, 0) < COALESCE (MovementFloat_Distance.ValueData, 0)
                       THEN COALESCE (MovementItem.Amount, 0) - (COALESCE (MovementFloat_LimitDistance.ValueData, 0) + COALESCE (MovementFloat_LimitDistanceChange.ValueData, 0)) * COALESCE (MovementFloat_AmountFuel.ValueData, 0) / 100
                  ELSE COALESCE (MovementItem.Amount, 0) - COALESCE (MovementFloat_Distance.ValueData, 0) * COALESCE (MovementFloat_AmountFuel.ValueData, 0) / 100
             END) :: TFloat AS FuelDiff
             -- *Сумма грн (остаток лим. км.)= если есть лимит км. ТОГДА = (факт заправки л. - "то что выше л.") * цену факт запраки
           , (CASE WHEN COALESCE (MovementFloat_LimitDistance.ValueData, 0) = 0 AND COALESCE (MovementFloat_LimitDistanceChange.ValueData, 0)  = 0
                       THEN 0
                  WHEN COALESCE (MovementFloat_LimitDistance.ValueData, 0) + COALESCE (MovementFloat_LimitDistanceChange.ValueData, 0) < COALESCE (MovementFloat_Distance.ValueData, 0)
                       THEN COALESCE (MovementItem.Amount, 0) - (COALESCE (MovementFloat_LimitDistance.ValueData, 0) + COALESCE (MovementFloat_LimitDistanceChange.ValueData, 0)) * COALESCE (MovementFloat_AmountFuel.ValueData, 0) / 100
                  ELSE COALESCE (MovementItem.Amount, 0) - COALESCE (MovementFloat_Distance.ValueData, 0) * COALESCE (MovementFloat_AmountFuel.ValueData, 0) / 100
             END
           * CASE WHEN MovementFloat_TotalCount.ValueData <> 0 THEN COALESCE (MovementFloat_TotalSumm.ValueData, 0) / MovementFloat_TotalCount.ValueData ELSE 0 END
             ) :: TFloat AS FuelSummDiff

             -- *Сумма грн (остаток лим. грн) = если есть лимит грн. И он меньше чем факт заправки грн. ТОГДА = факт заправки грн. - лимит грн.
           , (CASE WHEN COALESCE (MovementFloat_Limit.ValueData, 0) + COALESCE (MovementFloat_LimitChange.ValueData, 0) < COALESCE (MovementFloat_TotalSumm.ValueData, 0)
                   AND (MovementFloat_Limit.ValueData <> 0 OR MovementFloat_LimitChange.ValueData <> 0)
                       THEN COALESCE (MovementFloat_TotalSumm.ValueData, 0) - COALESCE (MovementFloat_Limit.ValueData, 0) - COALESCE (MovementFloat_LimitChange.ValueData, 0)
                  ELSE 0
             END) :: TFloat AS SummDiff

             -- *Сумма грн (остаток ИТОГО) = Остаток грн за лим. км. + Остаток грн за лим. грн.
           , (CASE WHEN COALESCE (MovementFloat_LimitDistance.ValueData, 0) = 0 AND COALESCE (MovementFloat_LimitDistanceChange.ValueData, 0)  = 0
                       THEN 0
                  WHEN COALESCE (MovementFloat_LimitDistance.ValueData, 0) + COALESCE (MovementFloat_LimitDistanceChange.ValueData, 0) < COALESCE (MovementFloat_Distance.ValueData, 0)
                       THEN COALESCE (MovementItem.Amount, 0) - (COALESCE (MovementFloat_LimitDistance.ValueData, 0) + COALESCE (MovementFloat_LimitDistanceChange.ValueData, 0)) * COALESCE (MovementFloat_AmountFuel.ValueData, 0) / 100
                  ELSE COALESCE (MovementItem.Amount, 0) - COALESCE (MovementFloat_Distance.ValueData, 0) * COALESCE (MovementFloat_AmountFuel.ValueData, 0) / 100
             END
           * CASE WHEN MovementFloat_TotalCount.ValueData <> 0 THEN COALESCE (MovementFloat_TotalSumm.ValueData, 0) / MovementFloat_TotalCount.ValueData ELSE 0 END
           + CASE WHEN COALESCE (MovementFloat_Limit.ValueData, 0) + COALESCE (MovementFloat_LimitChange.ValueData, 0) < COALESCE (MovementFloat_TotalSumm.ValueData, 0)
                   AND (MovementFloat_Limit.ValueData <> 0 OR MovementFloat_LimitChange.ValueData <> 0)
                       THEN COALESCE (MovementFloat_TotalSumm.ValueData, 0) - COALESCE (MovementFloat_Limit.ValueData, 0) - COALESCE (MovementFloat_LimitChange.ValueData, 0)
                  ELSE 0
             END) :: TFloat AS SummDiffTotal

             -- *Сумма грн (амортизация) = есть лим. км. = 0 ТОГДА = пробег ф.км. * цена аморт. ИНАЧЕ = МИН (пробег ф.км. ИЛИ лимит км.) * цена аморт.
           , (CASE WHEN COALESCE (MovementFloat_LimitDistance.ValueData, 0) = 0 AND COALESCE (MovementFloat_LimitDistanceChange.ValueData, 0)  = 0
                       THEN COALESCE (MovementFloat_Distance.ValueData, 0)
                  WHEN COALESCE (MovementFloat_LimitDistance.ValueData, 0) + COALESCE (MovementFloat_LimitDistanceChange.ValueData, 0) < COALESCE (MovementFloat_Distance.ValueData, 0)
                       THEN (COALESCE (MovementFloat_LimitDistance.ValueData, 0) + COALESCE (MovementFloat_LimitDistanceChange.ValueData, 0))
                  ELSE COALESCE (MovementFloat_Distance.ValueData, 0)
             END * COALESCE (MovementFloat_Reparation.ValueData, 0)) :: TFloat AS SummReparation

             -- *Сумма грн (ЗП итог) = Сумма грн (остаток ИТОГО) - Сумма грн (амортизация)
           , ((CASE WHEN COALESCE (MovementFloat_LimitDistance.ValueData, 0) = 0 AND COALESCE (MovementFloat_LimitDistanceChange.ValueData, 0)  = 0
                       THEN 0
                  WHEN COALESCE (MovementFloat_LimitDistance.ValueData, 0) + COALESCE (MovementFloat_LimitDistanceChange.ValueData, 0) < COALESCE (MovementFloat_Distance.ValueData, 0)
                       THEN COALESCE (MovementItem.Amount, 0) - (COALESCE (MovementFloat_LimitDistance.ValueData, 0) + COALESCE (MovementFloat_LimitDistanceChange.ValueData, 0)) * COALESCE (MovementFloat_AmountFuel.ValueData, 0) / 100
                  ELSE COALESCE (MovementItem.Amount, 0) - COALESCE (MovementFloat_Distance.ValueData, 0) * COALESCE (MovementFloat_AmountFuel.ValueData, 0) / 100
             END
           * CASE WHEN MovementFloat_TotalCount.ValueData <> 0 THEN COALESCE (MovementFloat_TotalSumm.ValueData, 0) / MovementFloat_TotalCount.ValueData ELSE 0 END
           + CASE WHEN COALESCE (MovementFloat_Limit.ValueData, 0) + COALESCE (MovementFloat_LimitChange.ValueData, 0) < COALESCE (MovementFloat_TotalSumm.ValueData, 0)
                   AND (MovementFloat_Limit.ValueData <> 0 OR MovementFloat_LimitChange.ValueData <> 0)
                       THEN COALESCE (MovementFloat_TotalSumm.ValueData, 0) - COALESCE (MovementFloat_Limit.ValueData, 0) - COALESCE (MovementFloat_LimitChange.ValueData, 0)
                  ELSE 0
             END
             -- SummReparation
           - CASE WHEN COALESCE (MovementFloat_LimitDistance.ValueData, 0) = 0 AND COALESCE (MovementFloat_LimitDistanceChange.ValueData, 0)  = 0
                       THEN COALESCE (MovementFloat_Distance.ValueData, 0)
                  WHEN COALESCE (MovementFloat_LimitDistance.ValueData, 0) + COALESCE (MovementFloat_LimitDistanceChange.ValueData, 0) < COALESCE (MovementFloat_Distance.ValueData, 0)
                       THEN (COALESCE (MovementFloat_LimitDistance.ValueData, 0) + COALESCE (MovementFloat_LimitDistanceChange.ValueData, 0))
                  ELSE COALESCE (MovementFloat_Distance.ValueData, 0)
             END * COALESCE (MovementFloat_Reparation.ValueData, 0)

           + CASE WHEN MovementFloat_LimitDistance.ValueData <> 0 OR MovementFloat_LimitDistanceChange.ValueData <> 0
                    OR MovementFloat_Limit.ValueData <> 0 OR MovementFloat_LimitChange.ValueData <> 0
                       THEN 0
                  ELSE COALESCE (MovementFloat_TotalSumm.ValueData, 0)
             END
             ) * CASE WHEN Object_To.DescId = zc_Object_Member() THEN -1 ELSE 0 END) :: TFloat AS SummPersonal

             -- Кол-во л. (заправка)
           , COALESCE (MovementItem.Amount, 0) :: TFloat AS FuelReal
             -- Цена заправки
           , CASE WHEN MovementFloat_TotalCount.ValueData <> 0 THEN COALESCE (MovementFloat_TotalSumm.ValueData, 0) / MovementFloat_TotalCount.ValueData ELSE 0 END :: TFloat AS PriceCalc
             -- Сумма заправки
           , MovementFloat_TotalSumm.ValueData AS SummReal

             -- *Сумма затрат
           , ((CASE WHEN COALESCE (MovementFloat_LimitDistance.ValueData, 0) = 0 AND COALESCE (MovementFloat_LimitDistanceChange.ValueData, 0)  = 0
                       THEN 0
                  WHEN COALESCE (MovementFloat_LimitDistance.ValueData, 0) + COALESCE (MovementFloat_LimitDistanceChange.ValueData, 0) < COALESCE (MovementFloat_Distance.ValueData, 0)
                       THEN COALESCE (MovementItem.Amount, 0) - (COALESCE (MovementFloat_LimitDistance.ValueData, 0) + COALESCE (MovementFloat_LimitDistanceChange.ValueData, 0)) * COALESCE (MovementFloat_AmountFuel.ValueData, 0) / 100
                  ELSE COALESCE (MovementItem.Amount, 0) - COALESCE (MovementFloat_Distance.ValueData, 0) * COALESCE (MovementFloat_AmountFuel.ValueData, 0) / 100
             END
           * CASE WHEN MovementFloat_TotalCount.ValueData <> 0 THEN COALESCE (MovementFloat_TotalSumm.ValueData, 0) / MovementFloat_TotalCount.ValueData ELSE 0 END
           + CASE WHEN COALESCE (MovementFloat_Limit.ValueData, 0) + COALESCE (MovementFloat_LimitChange.ValueData, 0) < COALESCE (MovementFloat_TotalSumm.ValueData, 0)
                   AND (MovementFloat_Limit.ValueData <> 0 OR MovementFloat_LimitChange.ValueData <> 0)
                       THEN COALESCE (MovementFloat_TotalSumm.ValueData, 0) - COALESCE (MovementFloat_Limit.ValueData, 0) - COALESCE (MovementFloat_LimitChange.ValueData, 0)
                  ELSE 0
             END

           + CASE WHEN MovementFloat_LimitDistance.ValueData <> 0 OR MovementFloat_LimitDistanceChange.ValueData <> 0
                    OR MovementFloat_Limit.ValueData <> 0 OR MovementFloat_LimitChange.ValueData <> 0
                       THEN 0
                  ELSE COALESCE (MovementFloat_TotalSumm.ValueData, 0)
             END

           + -1 * MovementFloat_TotalSumm.ValueData

             ) * CASE WHEN Object_To.DescId IN (zc_Object_Member(), zc_Object_Founder()) THEN -1 ELSE 0 END) :: TFloat AS SummaExp

           -- СУММА затраты 
             -- Сумма заправки
           /*, CASE WHEN Object_To.DescId = zc_Object_Member() 
                  THEN (MovementFloat_TotalSumm.ValueData       
                        -- *Сумма грн (амортизация)
                        - (CASE WHEN COALESCE (MovementFloat_LimitDistance.ValueData, 0) = 0 AND COALESCE (MovementFloat_LimitDistanceChange.ValueData, 0)  = 0
                                 THEN COALESCE (MovementFloat_Distance.ValueData, 0)
                             WHEN COALESCE (MovementFloat_LimitDistance.ValueData, 0) + COALESCE (MovementFloat_LimitDistanceChange.ValueData, 0) < COALESCE (MovementFloat_Distance.ValueData, 0)
                                 THEN (COALESCE (MovementFloat_LimitDistance.ValueData, 0) + COALESCE (MovementFloat_LimitDistanceChange.ValueData, 0))
                             ELSE COALESCE (MovementFloat_Distance.ValueData, 0)
                        END * COALESCE (MovementFloat_Reparation.ValueData, 0))
             -- 
                       - ((CASE WHEN COALESCE (MovementFloat_LimitDistance.ValueData, 0) = 0 AND COALESCE (MovementFloat_LimitDistanceChange.ValueData, 0)  = 0
                                 THEN 0
                                WHEN COALESCE (MovementFloat_LimitDistance.ValueData, 0) + COALESCE (MovementFloat_LimitDistanceChange.ValueData, 0) < COALESCE (MovementFloat_Distance.ValueData, 0)
                                 THEN COALESCE (MovementItem.Amount, 0) - (COALESCE (MovementFloat_LimitDistance.ValueData, 0) + COALESCE (MovementFloat_LimitDistanceChange.ValueData, 0)) * COALESCE (MovementFloat_AmountFuel.ValueData, 0) / 100
                                ELSE COALESCE (MovementItem.Amount, 0) - COALESCE (MovementFloat_Distance.ValueData, 0) * COALESCE (MovementFloat_AmountFuel.ValueData, 0) / 100
                           END
                         * CASE WHEN MovementFloat_TotalCount.ValueData <> 0 THEN COALESCE (MovementFloat_TotalSumm.ValueData, 0) / MovementFloat_TotalCount.ValueData ELSE 0 END
                         + CASE WHEN COALESCE (MovementFloat_Limit.ValueData, 0) + COALESCE (MovementFloat_LimitChange.ValueData, 0) < COALESCE (MovementFloat_TotalSumm.ValueData, 0)
                                 AND (MovementFloat_Limit.ValueData <> 0 OR MovementFloat_LimitChange.ValueData <> 0)
                                 THEN COALESCE (MovementFloat_TotalSumm.ValueData, 0) - COALESCE (MovementFloat_Limit.ValueData, 0) - COALESCE (MovementFloat_LimitChange.ValueData, 0)
                               ELSE 0
                           END
                         - CASE WHEN COALESCE (MovementFloat_LimitDistance.ValueData, 0) = 0 AND COALESCE (MovementFloat_LimitDistanceChange.ValueData, 0)  = 0
                                     THEN COALESCE (MovementFloat_Distance.ValueData, 0)
                                WHEN COALESCE (MovementFloat_LimitDistance.ValueData, 0) + COALESCE (MovementFloat_LimitDistanceChange.ValueData, 0) < COALESCE (MovementFloat_Distance.ValueData, 0)
                                     THEN (COALESCE (MovementFloat_LimitDistance.ValueData, 0) + COALESCE (MovementFloat_LimitDistanceChange.ValueData, 0))
                                ELSE COALESCE (MovementFloat_Distance.ValueData, 0)
                           END * COALESCE (MovementFloat_Reparation.ValueData, 0)
                         + CASE WHEN MovementFloat_LimitDistance.ValueData <> 0 OR MovementFloat_LimitDistanceChange.ValueData <> 0
                                  OR MovementFloat_Limit.ValueData <> 0 OR MovementFloat_LimitChange.ValueData <> 0
                                     THEN 0
                                ELSE COALESCE (MovementFloat_TotalSumm.ValueData, 0)
                           END) * (-1)) )
                 ELSE 0 END  :: TFloat  AS SummaExp*/

           , tmpSign.strSign
           , tmpSign.strSignNo

       FROM (SELECT Movement.id
             FROM tmpStatus
                  JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_Income() AND Movement.StatusId = tmpStatus.StatusId
                  JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = COALESCE (Movement.AccessKeyId, 0)
            ) AS tmpMovement

            LEFT JOIN Movement ON Movement.id = tmpMovement.id
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN Movement AS Movement_Master ON Movement_Master.Id = Movement.ParentId
            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                  AND MovementItem.DescId = zc_MI_Master()
                                  AND MovementItem.isErased = FALSE
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
            LEFT JOIN MovementItemContainer AS MIContainer_Count ON MIContainer_Count.MovementId     = MovementItem.MovementId
                                                                AND MIContainer_Count.DescId         = zc_MIContainer_Count()
                                                                AND MIContainer_Count.MovementItemId = MovementItem.Id
                                                                AND MIContainer_Count.isActive       = TRUE
            LEFT JOIN Container AS Container_Count ON Container_Count.Id = MIContainer_Count.ContainerId
            LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = Container_Count.ObjectId

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
            LEFT JOIN MovementBoolean AS MovementBoolean_ChangePriceUser
                                      ON MovementBoolean_ChangePriceUser.MovementId =  Movement.Id
                                     AND MovementBoolean_ChangePriceUser.DescId = zc_MovementBoolean_ChangePriceUser()

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
            LEFT JOIN MovementFloat AS MovementFloat_ChangePrice
                                    ON MovementFloat_ChangePrice.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePrice.DescId = zc_MovementFloat_ChangePrice()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementFloat AS MovementFloat_StartOdometre
                                    ON MovementFloat_StartOdometre.MovementId =  Movement.Id
                                   AND MovementFloat_StartOdometre.DescId = zc_MovementFloat_StartOdometre()
            LEFT JOIN MovementFloat AS MovementFloat_EndOdometre
                                    ON MovementFloat_EndOdometre.MovementId =  Movement.Id
                                   AND MovementFloat_EndOdometre.DescId = zc_MovementFloat_EndOdometre()
            LEFT JOIN MovementFloat AS MovementFloat_AmountFuel
                                    ON MovementFloat_AmountFuel.MovementId =  Movement.Id
                                   AND MovementFloat_AmountFuel.DescId = zc_MovementFloat_AmountFuel()
            LEFT JOIN MovementFloat AS MovementFloat_Reparation
                                    ON MovementFloat_Reparation.MovementId =  Movement.Id
                                   AND MovementFloat_Reparation.DescId = zc_MovementFloat_Reparation()
            LEFT JOIN MovementFloat AS MovementFloat_Limit
                                    ON MovementFloat_Limit.MovementId =  Movement.Id
                                   AND MovementFloat_Limit.DescId = zc_MovementFloat_Limit()
            LEFT JOIN MovementFloat AS MovementFloat_LimitChange
                                    ON MovementFloat_LimitChange.MovementId =  Movement.Id
                                   AND MovementFloat_LimitChange.DescId = zc_MovementFloat_LimitChange()
            LEFT JOIN MovementFloat AS MovementFloat_LimitDistance
                                    ON MovementFloat_LimitDistance.MovementId =  Movement.Id
                                   AND MovementFloat_LimitDistance.DescId = zc_MovementFloat_LimitDistance()
            LEFT JOIN MovementFloat AS MovementFloat_LimitDistanceChange
                                    ON MovementFloat_LimitDistanceChange.MovementId =  Movement.Id
                                   AND MovementFloat_LimitDistanceChange.DescId = zc_MovementFloat_LimitDistanceChange()
            LEFT JOIN MovementFloat AS MovementFloat_Distance
                                    ON MovementFloat_Distance.MovementId =  Movement.Id
                                   AND MovementFloat_Distance.DescId = zc_MovementFloat_Distance()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_CardFuel_Juridical
                                 ON ObjectLink_CardFuel_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                AND ObjectLink_CardFuel_Juridical.DescId   = zc_ObjectLink_CardFuel_Juridical()
            LEFT JOIN Object AS Object_JuridicalFrom ON Object_JuridicalFrom.Id = ObjectLink_CardFuel_Juridical.ChildObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Car_Unit ON ObjectLink_Car_Unit.ObjectId = Object_To.Id
                                                       AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
            LEFT JOIN Object_Unit_View AS View_Unit ON View_Unit.Id = ObjectLink_Car_Unit.ChildObjectId

            LEFT JOIN ObjectDesc AS ObjectDesc_To ON ObjectDesc_To.Id = Object_To.DescId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = View_Contract_InvNumber.InfoMoneyId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                         ON MovementLinkObject_Route.MovementId = Movement.Id
                                        AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementLinkObject_Route.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                         ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
            LEFT JOIN Object_Personal_View AS View_PersonalDriver ON View_PersonalDriver.PersonalId = MovementLinkObject_PersonalDriver.ObjectId

            -- эл.подписи
            LEFT JOIN lpSelect_MI_Sign (inMovementId:= Movement.Id) AS tmpSign ON tmpSign.Id = Movement.Id

    -- WHERE COALESCE (Object_To.DescId, 0) IN (0, zc_Object_Car(), zc_Object_Member(), zc_Object_Founder()) -- !!!САМОЕ НЕКРАСИВОЕ РЕШЕНИЕ!!!
       WHERE View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_20401() -- !!!САМОЕ НЕКРАСИВОЕ РЕШЕНИЕ!!!
         
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Movement_IncomeFuel (TDateTime, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 01.11.22         * add isChangePriceUser
 07.10.16         * add inJuridicalBasisId
 15.01.16         * add               
 10.02.14                                        * add убрал !!!САМОЕ НЕКРАСИВОЕ РЕШЕНИЕ!!!, т.к. AccessKeyId будет достаточно
 09.02.14                                        * add Object_Contract_InvNumber_View and Object_InfoMoney_View
 06.02.14                                        * add Branch...
 03.02.14                                        * add Goods... and Fuel...
 14.12.13                                        * add Object_RoleAccessKey_View
 31.10.13                                        * add OperDatePartner
 23.10.13                                        * add zfConvert_StringToNumber
 19.10.13                                        * add ChangePrice
 12.10.13                                        * add InvNumberMaster and OperDateMaster
 07.10.13                                        * add lpCheckRight
 04.10.13                                        * add Route
 30.09.13                                        * add Object_Personal_View
 27.09.13                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_IncomeFuel (inStartDate:= '01.02.2018', inEndDate:= '01.02.2018', inJuridicalBasisId:= 0, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
