-- Function: gpSelect_Movement_IncomeFuel_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_IncomeFuel_Print (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Movement_IncomeFuel_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbPriceWithVAT Boolean;
    DECLARE vbVATPercent TFloat;
    DECLARE vbDiscountPercent TFloat;
    DECLARE vbExtraChargesPercent TFloat;
    DECLARE vbChangePercentTo TFloat;
    DECLARE vbPaidKindId Integer;

    DECLARE vbOperSumm_MVAT TFloat;
    DECLARE vbOperSumm_PVAT TFloat;
    DECLARE vbTotalCountKg  TFloat;
    DECLARE vbTotalCountSh  TFloat;

    DECLARE vbGoodsPropertyId Integer;
    DECLARE vbGoodsPropertyId_basis Integer;
    DECLARE vbContractId Integer;
    DECLARE vbIsProcess_BranchIn Boolean;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income_Print());
     vbUserId:= inSession;

    -- очень важная проверка
    IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete()
    THEN
        IF vbStatusId = zc_Enum_Status_Erased()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        IF vbStatusId = zc_Enum_Status_UnComplete()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> не проведен.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        -- это уже странная ошибка
       -- RAISE EXCEPTION 'Ошибка.Документ <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId);
    END IF;



      --
    OPEN Cursor1 FOR
      SELECT
               Movement.Id
             , Movement.InvNumber
             , Movement.OperDate
   
             , MovementDate_OperDatePartner.ValueData    AS OperDatePartner
             , EXTRACT (YEAR FROM Movement.OperDate ::TDateTime) ::TVarChar AS OperDatePartnerYear
             , zfCalc_MonthName(MovementDate_OperDatePartner.ValueData)    AS OperDatePartnerMonth
             , MovementString_InvNumberPartner.ValueData AS InvNumberPartner

             , MovementBoolean_PriceWithVAT.ValueData      AS PriceWithVAT
             , MovementFloat_VATPercent.ValueData          AS VATPercent
             , MovementFloat_ChangePrice.ValueData         AS ChangePrice

             , Object_From.ValueData              AS FromName
             , Object_To.ValueData                AS ToName
             , COALESCE(Object_Position.ValueData,'' )::TVarChar  AS PositionName
             , Object_PaidKind.ValueData          AS PaidKindName
             , View_Contract_InvNumber.InvNumber  AS ContractName
             , Object_Route.ValueData             AS RouteName
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

             -- Кол-во л. (заправка)
           , COALESCE (MovementItem.Amount, 0) :: TFloat AS FuelReal
             -- Цена заправки
           , CASE WHEN MovementFloat_TotalCount.ValueData <> 0 THEN COALESCE (MovementFloat_TotalSumm.ValueData, 0) / MovementFloat_TotalCount.ValueData ELSE 0 END :: TFloat AS PriceCalc
             -- Сумма заправки
           , MovementFloat_TotalSumm.ValueData AS SummReal

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN Movement AS Movement_Master ON Movement_Master.Id = Movement.ParentId
            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                  AND MovementItem.DescId = zc_MI_Master()
                                  AND MovementItem.isErased = FALSE
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
            LEFT JOIN MovementItemContainer AS MIContainer_Count ON MIContainer_Count.MovementItemId = MovementItem.Id
                                                                AND MIContainer_Count.DescId = zc_MIContainer_Count()
                                                                AND MIContainer_Count.isActive = TRUE
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

           -- для физ.лица получить должность
           LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                            ON ObjectLink_Personal_Member.ChildObjectId = Object_To.Id
                           AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
           LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                ON ObjectLink_Personal_Position.ObjectId = ObjectLink_Personal_Member.ObjectId
                               AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
           LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Personal_Position.ChildObjectId

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_Income()
       LIMIT 1;
     
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
             SELECT
             MovementItem.Id
           , CASE WHEN MovementItem.Id <> 0 THEN CAST (row_number() OVER (ORDER BY MIDate_OperDate.ValueData) AS Integer) ELSE 0 END AS LineNum
           , Object_RouteMember.Id                      AS RouteMemberId
           , Object_RouteMember.ObjectCode ::TVarChar   AS RouteMemberCode
           , OB_RouteMember_Description.ValueData       AS RouteMemberName
           , MIDate_OperDate.ValueData                  AS OperDate
           , tmpWeekDay.DayOfWeekName_Full              AS DayOfWeekName
           , MovementItem.Amount
           , MIFloat_StartOdometre.ValueData    AS StartOdometre
           , MIFloat_EndOdometre.ValueData      AS EndOdometre

           , CAST ((COALESCE (MIFloat_EndOdometre.ValueData, 0) - COALESCE (MIFloat_StartOdometre.ValueData, 0))  AS TFloat) AS Distance_calc

           , MovementItem.isErased

       FROM MovementItem
            LEFT JOIN MovementItemFloat AS MIFloat_StartOdometre
                                        ON MIFloat_StartOdometre.MovementItemId = MovementItem.Id
                                       AND MIFloat_StartOdometre.DescId = zc_MIFloat_StartOdometre()
            LEFT JOIN MovementItemFloat AS MIFloat_EndOdometre
                                        ON MIFloat_EndOdometre.MovementItemId = MovementItem.Id
                                       AND MIFloat_EndOdometre.DescId = zc_MIFloat_EndOdometre()
            LEFT JOIN Object AS Object_RouteMember ON Object_RouteMember.Id =  MovementItem.ObjectId 
            LEFT JOIN ObjectBlob AS OB_RouteMember_Description
                                 ON OB_RouteMember_Description.ObjectId =  Object_RouteMember.Id
                                AND OB_RouteMember_Description.DescId = zc_ObjectBlob_RouteMember_Description()

            LEFT JOIN MovementItemDate AS MIDate_OperDate
                                        ON MIDate_OperDate.MovementItemId = MovementItem.Id
                                       AND MIDate_OperDate.DescId = zc_MIDate_OperDate()
            LEFT JOIN zfCalc_DayOfWeekName (MIDate_OperDate.ValueData) AS tmpWeekDay ON 1=1
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId     = zc_MI_Child()
          AND MovementItem.isErased   = False

       ;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_IncomeFuel_Print (Integer,  TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 24.08.16         * 
*/

-- тест
-- SELECT * FROM gpSelect_Movement_IncomeFuel_Print (inMovementId := 432692, inSession:= '5');
