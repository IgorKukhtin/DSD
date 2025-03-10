-- Function: gpGet_Movement_IncomeFuel (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_IncomeFuel (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_IncomeFuel (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_IncomeFuel(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime, InvNumberPartner TVarChar
             , PriceWithVAT Boolean
             , isChangePriceUser Boolean -- Ручная скидка в цене (да/нет)
             , VATPercent TFloat, ChangePrice TFloat
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar, ToParentId Integer
             , PaidKindId Integer, PaidKindName TVarChar, ContractId Integer, ContractName TVarChar
             , RouteId Integer, RouteName TVarChar
             , PersonalDriverId Integer, PersonalDriverName TVarChar
             , StartOdometre TFloat, EndOdometre TFloat, AmountFuel TFloat
             , Reparation TFloat, LimitMoney TFloat, LimitDistance TFloat
             , LimitChange TFloat, LimitDistanceChange TFloat, Distance TFloat
            
             --, DistanceDiff TFloat
             , DistanceReal   TFloat -- *Пробег общий км
             , FuelReal       TFloat -- Кол-во л. (заправка)
             , FuelCalc       TFloat -- *Кол-во л. (расч. на пробег ф.км.)
             , FuelRealCalc   TFloat -- *Кол-во л. (использовано)

             , FuelDiff       TFloat -- *Кол-во л. (остаток лим. км.)
             , FuelSummDiff   TFloat -- *Сумма грн (остаток лим. км.)
             , SummDiff       TFloat -- *Сумма грн (остаток лим. грн)
             , SummLimit      TFloat -- *Сумма грн (лим. грн) !!!используется только для проведения!!!
             , SummDiffTotal  TFloat -- *Сумма грн (остаток ИТОГО)
             , SummReparation TFloat -- *Сумма грн (амортизация)
             , SummPersonal   TFloat -- *Сумма грн (ЗП итог)

             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Get_Movement_IncomeFuel());


     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY 
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('Movement_Income_seq') AS TVarChar) AS InvNumber
             , inOperDate                       AS OperDate
             , Object_Status.Code               AS StatusCode
             , Object_Status.Name               AS StatusName

             , inOperDate             AS OperDatePartner
             , CAST ('' AS TVarChar)  AS InvNumberPartner

             , CAST (TRUE AS Boolean) AS PriceWithVAT
             , CAST (FALSE AS Boolean) AS isChangePriceUser
             , CAST (20 AS TFloat)    AS VATPercent
             , CAST (0 AS TFloat)     AS ChangePrice

             , 0                     AS FromId
             , CAST ('' AS TVarChar) AS FromName
             , 0                     AS ToId
             , CAST ('' AS TVarChar) AS ToName
             , 0                     AS ToParentId
             , 0                     AS PaidKindId
             , CAST ('' AS TVarChar) AS PaidKindName
             , 0                     AS ContractId
             , CAST ('' AS TVarChar) AS ContractName
             , 0                     AS RouteId
             , CAST ('' AS TVarChar) AS RouteName
             , 0                     AS PersonalDriverId
             , CAST ('' AS TVarChar) AS PersonalDriverName

             , CAST (0 AS TFloat)     AS StartOdometre
             , CAST (0 AS TFloat)     AS EndOdometre
             , CAST (0 AS TFloat)     AS AmountFuel
             , CAST (0 AS TFloat)     AS Reparation
             , CAST (0 AS TFloat)     AS LimitMoney
             , CAST (0 AS TFloat)     AS LimitDistance
             , CAST (0 AS TFloat)     AS LimitChange
             , CAST (0 AS TFloat)     AS LimitDistanceChange
             , CAST (0 AS TFloat)     AS Distance

             , CAST (0 AS TFloat)     AS DistanceReal
             , CAST (0 AS TFloat)     AS FuelReal
             , CAST (0 AS TFloat)     AS FuelCalc       
             , CAST (0 AS TFloat)     AS FuelRealCalc 

             , CAST (0 AS TFloat)     AS FuelDiff      
             , CAST (0 AS TFloat)     AS FuelSummDiff  
             , CAST (0 AS TFloat)     AS SummDiff      
             , CAST (0 AS TFloat)     AS SummLimit
             , CAST (0 AS TFloat)     AS SummDiffTotal 
             , CAST (0 AS TFloat)     AS SummReparation
             , CAST (0 AS TFloat)     AS SummPersonal  

          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
     ELSE
       RETURN QUERY 
         WITH MIContainer AS (SELECT MIContainer_Count.*
                              FROM MovementItemContainer AS MIContainer_Count 
                              WHERE MIContainer_Count.MovementId     = inMovementId 
                                AND MIContainer_Count.DescId         = zc_MIContainer_Count()
                             )
         SELECT
               Movement.Id
             , Movement.InvNumber
             , Movement.OperDate
             , zfCalc_StatusCode_next (Movement.StatusId, Movement.StatusId_next)                          ::Integer  AS StatusCode
             , zfCalc_StatusName_next (Object_Status.ValueData, Movement.StatusId, Movement.StatusId_next) ::TVarChar AS StatusName

             , MovementDate_OperDatePartner.ValueData    AS OperDatePartner
             , MovementString_InvNumberPartner.ValueData AS InvNumberPartner

             , MovementBoolean_PriceWithVAT.ValueData      AS PriceWithVAT
             , COALESCE (MovementBoolean_ChangePriceUser.ValueData, FALSE) AS isChangePriceUser
             , MovementFloat_VATPercent.ValueData          AS VATPercent
             , MovementFloat_ChangePrice.ValueData         AS ChangePrice

             , Object_From.Id                     AS FromId
             , Object_From.ValueData              AS FromName
             , Object_To.Id                       AS ToId
             , Object_To.ValueData                AS ToName
             , 0                                  AS ToParentId
             , Object_PaidKind.Id                 AS PaidKindId
             , Object_PaidKind.ValueData          AS PaidKindName
             , View_Contract_InvNumber.ContractId AS ContractId
             , View_Contract_InvNumber.InvNumber  AS ContractName
             , Object_Route.Id                    AS RouteId
             , Object_Route.ValueData             AS RouteName
             , View_PersonalDriver.PersonalId     AS PersonalDriverId
             , View_PersonalDriver.PersonalName   AS PersonalDriverName

             , MovementFloat_StartOdometre.ValueData       AS StartOdometre
             , MovementFloat_EndOdometre.ValueData         AS EndOdometre
             , MovementFloat_AmountFuel.ValueData          AS AmountFuel
             , MovementFloat_Reparation.ValueData          AS Reparation
             , MovementFloat_Limit.ValueData               AS LimitMoney
             , MovementFloat_LimitDistance.ValueData       AS LimitDistance
             , MovementFloat_LimitChange.ValueData         AS LimitChange
             , MovementFloat_LimitDistanceChange.ValueData AS LimitDistanceChange
             , MovementFloat_Distance.ValueData            AS Distance
            -- , COALESCE (MovementFloat_EndOdometre.ValueData - MovementFloat_StartOdometre.ValueData, 0)  ::TFloat    AS DistanceDiff

             -- *Пробег общий км
           , (COALESCE (MovementFloat_EndOdometre.ValueData , 0) - COALESCE (MovementFloat_StartOdometre.ValueData , 0)) :: TFloat AS DistanceReal
             -- Кол-во л. (заправка)
           , COALESCE (MovementItem.Amount, 0) :: TFloat AS FuelReal 
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
             -- *Сумма грн (лим. грн), !!!используется только для проведения!!!
           , (COALESCE (MovementFloat_Limit.ValueData, 0) + COALESCE (MovementFloat_LimitChange.ValueData, 0)) :: TFloat AS SummLimit

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

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN Movement AS Movement_Master ON Movement_Master.Id = Movement.ParentId
            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                  AND MovementItem.DescId = zc_MI_Master()
                                  AND MovementItem.isErased = FALSE
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
            LEFT JOIN MIContainer AS MIContainer_Count ON MIContainer_Count.MovementId     = MovementItem.MovementId 
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
                                                                        
            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
            LEFT JOIN MovementFloat AS MovementFloat_ChangePrice
                                    ON MovementFloat_ChangePrice.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePrice.DescId = zc_MovementFloat_ChangePrice()

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
            LEFT JOIN MovementFloat AS MovementFloat_LimitDistance
                                    ON MovementFloat_LimitDistance.MovementId =  Movement.Id
                                   AND MovementFloat_LimitDistance.DescId = zc_MovementFloat_LimitDistance()
            LEFT JOIN MovementFloat AS MovementFloat_LimitChange
                                    ON MovementFloat_LimitChange.MovementId =  Movement.Id
                                   AND MovementFloat_LimitChange.DescId = zc_MovementFloat_LimitChange()
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
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                         ON MovementLinkObject_Route.MovementId = Movement.Id
                                        AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementLinkObject_Route.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                         ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
            LEFT JOIN Object_Personal_View AS View_PersonalDriver ON View_PersonalDriver.PersonalId = MovementLinkObject_PersonalDriver.ObjectId

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_Income()
       LIMIT 1
      ;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 01.11.22         * add isChangePriceUser
 30.01.16         * 
 15.01.16         * add
 09.02.14                                        * add Object_Contract_InvNumber_View
 31.10.13                                        * add OperDatePartner
 23.10.13                                        * add NEXTVAL
 20.10.13                                        * CURRENT_TIMESTAMP -> CURRENT_DATE
 19.10.13                                        * add ChangePrice
 07.10.13                                        * add lpCheckRight
 05.10.13                                        * add InvNumberPartner
 04.10.13                                        * add Route
 30.09.13                                        * add Object_Personal_View
 29.09.13                                        * add lf?Get_InvNumber
 27.09.13                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_IncomeFuel (inMovementId := 3158828, inOperDate:= NULL, inSession:= zfCalc_UserAdmin())
