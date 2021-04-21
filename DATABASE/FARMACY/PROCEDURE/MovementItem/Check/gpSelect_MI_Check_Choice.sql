-- Function: gpSelect_MI_Check_Choice()

DROP FUNCTION IF EXISTS gpSelect_MI_Check_Choice (TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_Check_Choice(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inUnitId        Integer,    -- Подразделение
    IN inGoodsId       Integer,    -- Товар
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer
             , TotalCount TFloat, TotalSumm TFloat, TotalSummPayAdd TFloat, TotalSummChangePercent TFloat
             , UnitName TVarChar, CashRegisterName TVarChar, PaidTypeName TVarChar
             , CashMember TVarChar, Bayer TVarChar, FiscalCheckNumber TVarChar
             --, NotMCS Boolean
             , IsDeferred Boolean
             --, DiscountCardName TVarChar, DiscountExternalName TVarChar
             , BayerPhone TVarChar
             , InvNumberOrder TVarChar
             --, ConfirmedKindName TVarChar
             --, ConfirmedKindClientName TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             /*, OperDateSP TDateTime
             , PartnerMedicalName TVarChar
             , MedicSPName TVarChar
             , Ambulance TVarChar
             , SPKindName TVarChar
             */
           --  , InvNumber_Invoice_Full TVarChar

            /* , MemberSPId Integer, MemberSPName TVarChar
             , GroupMemberSPId Integer, GroupMemberSPName TVarChar

            */ , MovementItemId Integer
             , Amount TFloat
             , Price TFloat
             , Summ TFloat
             , PriceSale TFloat
             , ChangePercent TFloat
             , SummChangePercent TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbRetailId Integer;   
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

     -- определяется <Торговая сеть>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

     -- определяем Торговую сеть входящего подразделения
     vbRetailId:= CASE WHEN vbUserId IN (3, 183242, 375661) -- Админ + Люба + Юра
                          OR vbUserId IN (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId IN (393039)) -- Старший менеджер
                       THEN vbObjectId
                  ELSE
                  (SELECT ObjectLink_Juridical_Retail.ChildObjectId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                      INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                            ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                           AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE ObjectLink_Unit_Juridical.ObjectId = inUnitId
                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                   )
                   END;

     -- Результат
     RETURN QUERY
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         )

    , Movement_Check AS (SELECT Movement.*
                              , MovementLinkObject_Unit.ObjectId                    AS UnitId
                              , MovementLinkObject_CheckMember.ObjectId             AS MemberId
                              , COALESCE(MovementBoolean_Deferred.ValueData, False) AS IsDeferred
                         FROM Movement
                              INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId

                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()    
                                                           AND (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0)

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckMember
                                                           ON MovementLinkObject_CheckMember.MovementId = Movement.Id
                                                          AND MovementLinkObject_CheckMember.DescId = zc_MovementLinkObject_CheckMember()
                              LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                                        ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                       AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
              		                      
                         WHERE Movement.OperDate >= inStartDate 
                           AND Movement.OperDate < inEndDate + INTERVAL '1 DAY'
                           AND Movement.DescId = zc_Movement_Check()
                           AND vbRetailId = vbObjectId
                        )

    , tmpMI_All AS (SELECT MovementItem.*
                    FROM Movement_Check
                         INNER JOIN MovementItem ON MovementItem.MovementId = Movement_Check.Id
                                                AND MovementItem.DescId     = zc_MI_Master()
                                                AND MovementItem.isErased   = FALSE
                                                AND MovementItem.ObjectId   = inGoodsId
                    )
    , tmpMI AS (SELECT MovementItem.Id                     AS Id
                     , MovementItem.MovementId             AS MovementId
                     , MovementItem.Amount                 AS Amount
                     , MIFloat_Price.ValueData             AS Price
                     , (((COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData)::NUMERIC (16, 2)) ::TFloat AS AmountSumm
                     , MIFloat_PriceSale.ValueData         AS PriceSale
                     , MIFloat_ChangePercent.ValueData     AS ChangePercent
                     , MIFloat_SummChangePercent.ValueData AS SummChangePercent
                FROM tmpMI_All AS MovementItem
                     LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                 ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                AND MIFloat_Price.DescId = zc_MIFloat_Price()
                     LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                 ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                                AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
                     LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                 ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                     LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                 ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                                AND MIFloat_SummChangePercent.DescId = zc_MIFloat_SummChangePercent()
                )

    , tmpMovementDate AS (SELECT MovementDate.*
                          FROM MovementDate
                          WHERE MovementDate.MovementId IN (SELECT DISTINCT Movement_Check.Id FROM Movement_Check)
                            AND MovementDate.DescId = zc_MovementDate_Insert()
                         )

    , tmpMovementFloat AS (SELECT MovementFloat.*
                           FROM MovementFloat
                           WHERE MovementFloat.MovementId IN (SELECT DISTINCT Movement_Check.Id FROM Movement_Check)
                             AND MovementFloat.DescId IN (zc_MovementFloat_TotalCount()
                                                        , zc_MovementFloat_TotalSumm()
                                                        , zc_MovementFloat_TotalSummPayAdd()
                                                        , zc_MovementFloat_TotalSummChangePercent()
                                                        )
                         )

    , tmpMovementString AS (SELECT MovementString.*
                          FROM MovementString
                          WHERE MovementString.MovementId IN (SELECT DISTINCT Movement_Check.Id FROM Movement_Check)
                            AND MovementString.DescId IN (zc_MovementString_InvNumberOrder()
                                                        , zc_MovementString_Bayer()
                                                        , zc_MovementString_BayerPhone()
                                                        , zc_MovementString_FiscalCheckNumber()
                                                         )
                         )

    , tmpMovementLinkObject AS (SELECT MovementLinkObject.*
                                FROM MovementLinkObject
                                WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT Movement_Check.Id FROM Movement_Check)
                                  AND MovementLinkObject.DescId IN (zc_MovementLinkObject_CashRegister()
                                                                  , zc_MovementLinkObject_PaidType()
                                                                  , zc_MovementLinkObject_Insert()
                                                                   )
                         )



         SELECT       
             Movement_Check.Id
           , Movement_Check.InvNumber
           , Movement_Check.OperDate
           , Object_Status.ObjectCode                           AS StatusCode
           , MovementFloat_TotalCount.ValueData                 AS TotalCount
           , MovementFloat_TotalSumm.ValueData                  AS TotalSumm
           , MovementFloat_TotalSummPayAdd.ValueData            AS TotalSummPatAdd
           , MovementFloat_TotalSummChangePercent.ValueData     AS TotalSummChangePercent
           , Object_Unit.ValueData                              AS UnitName
           , Object_CashRegister.ValueData                      AS CashRegisterName
           , Object_PaidType.ValueData                          AS PaidTypeName 
           , CASE WHEN MovementString_InvNumberOrder.ValueData <> '' AND COALESCE (Object_CashMember.ValueData, '') = '' THEN zc_Member_Site() ELSE Object_CashMember.ValueData END :: TVarChar AS CashMember
           , COALESCE(Object_BuyerForSite.ValueData,
                      MovementString_Bayer.ValueData)           AS Bayer
           , MovementString_FiscalCheckNumber.ValueData         AS FiscalCheckNumber
          -- , COALESCE(MovementBoolean_NotMCS.ValueData,FALSE)   AS NotMCS
           , Movement_Check.IsDeferred                          AS IsDeferred
           --, Object_DiscountCard.ValueData                      AS DiscountCardName
           --, Object_DiscountExternal.ValueData                  AS DiscountExternalName
           , COALESCE (ObjectString_BuyerForSite_Phone.ValueData, 
                       MovementString_BayerPhone.ValueData)     AS BayerPhone
           , MovementString_InvNumberOrder.ValueData            AS InvNumberOrder
           --, Object_ConfirmedKind.ValueData                     AS ConfirmedKindName
           --, Object_ConfirmedKindClient.ValueData               AS ConfirmedKindClientName

           , Object_Insert.ValueData                            AS InsertName
           , MovementDate_Insert.ValueData                      AS InsertDate

          -- , Object_PartnerMedical.ValueData                    AS PartnerMedicalName
           --, MovementString_MedicSP.ValueData                   AS MedicSPName
           --, MovementString_Ambulance.ValueData                 AS Ambulance
           --, Object_SPKind.ValueData                            AS SPKindName
          -- , ('№ ' || Movement_Invoice.InvNumber || ' от ' || Movement_Invoice.OperDate  :: Date :: TVarChar )     :: TVarChar  AS InvNumber_Invoice_Full 

           --, Object_MemberSP.Id                                           AS MemberSPId
           --, Object_MemberSP.ValueData                                    AS MemberSPName
           --, Object_GroupMemberSP.Id                                      AS GroupMemberSPId
           --, Object_GroupMemberSP.ValueData                               AS GroupMemberSPName

           -- строки документа
           , tmpMI.Id             AS MovementItemId
           , tmpMI.Amount             :: TFloat
           , tmpMI.Price              :: TFloat
           , tmpMI.AmountSumm         :: TFloat
           , tmpMI.PriceSale          :: TFloat
           , tmpMI.ChangePercent      :: TFloat
           , tmpMI.SummChangePercent  :: TFloat

        FROM Movement_Check 
             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Check.StatusId
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Movement_Check.UnitId

             LEFT JOIN tmpMovementDate AS MovementDate_Insert
                                       ON MovementDate_Insert.MovementId = Movement_Check.Id

             LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCount
                                        ON MovementFloat_TotalCount.MovementId = Movement_Check.Id
                                       AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

             LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSumm
                                        ON MovementFloat_TotalSumm.MovementId =  Movement_Check.Id
                                       AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

             LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummPayAdd
                                        ON MovementFloat_TotalSummPayAdd.MovementId =  Movement_Check.Id
                                       AND MovementFloat_TotalSummPayAdd.DescId = zc_MovementFloat_TotalSummPayAdd()

             LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummChangePercent
                                        ON MovementFloat_TotalSummChangePercent.MovementId =  Movement_Check.Id
                                       AND MovementFloat_TotalSummChangePercent.DescId = zc_MovementFloat_TotalSummChangePercent()

             LEFT JOIN tmpMovementString AS MovementString_InvNumberOrder
                                         ON MovementString_InvNumberOrder.MovementId = Movement_Check.Id
                                        AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

	         LEFT JOIN tmpMovementString AS MovementString_Bayer
                                         ON MovementString_Bayer.MovementId = Movement_Check.Id
                                        AND MovementString_Bayer.DescId = zc_MovementString_Bayer()
             LEFT JOIN tmpMovementString AS MovementString_BayerPhone
                                         ON MovementString_BayerPhone.MovementId = Movement_Check.Id
                                        AND MovementString_BayerPhone.DescId = zc_MovementString_BayerPhone()
             LEFT JOIN tmpMovementString AS MovementString_FiscalCheckNumber
                                         ON MovementString_FiscalCheckNumber.MovementId = Movement_Check.Id
                                        AND MovementString_FiscalCheckNumber.DescId = zc_MovementString_FiscalCheckNumber()

             LEFT JOIN MovementLinkObject AS MovementLinkObject_BuyerForSite
                                          ON MovementLinkObject_BuyerForSite.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_BuyerForSite.DescId = zc_MovementLinkObject_BuyerForSite()
             LEFT JOIN Object AS Object_BuyerForSite ON Object_BuyerForSite.Id = MovementLinkObject_BuyerForSite.ObjectId
             LEFT JOIN ObjectString AS ObjectString_BuyerForSite_Phone
                                    ON ObjectString_BuyerForSite_Phone.ObjectId = Object_BuyerForSite.Id 
                                   AND ObjectString_BuyerForSite_Phone.DescId = zc_ObjectString_BuyerForSite_Phone()
                                  
  /*           LEFT JOIN MovementString AS MovementString_MedicSP
                                      ON MovementString_MedicSP.MovementId = Movement_Check.Id
                                     AND MovementString_MedicSP.DescId = zc_MovementString_MedicSP() and 1=0
             LEFT JOIN MovementString AS MovementString_Ambulance
                                      ON MovementString_Ambulance.MovementId = Movement_Check.Id
                                     AND MovementString_Ambulance.DescId = zc_MovementString_Ambulance() and 1=0

             LEFT JOIN MovementBoolean AS MovementBoolean_NotMCS
                                       ON MovementBoolean_NotMCS.MovementId = Movement_Check.Id
                                      AND MovementBoolean_NotMCS.DescId = zc_MovementBoolean_NotMCS() and 1=0
*/
             LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_CashRegister
                                          ON MovementLinkObject_CashRegister.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
             LEFT JOIN Object AS Object_CashRegister ON Object_CashRegister.Id = MovementLinkObject_CashRegister.ObjectId
 
   	     LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_PaidType
                                          ON MovementLinkObject_PaidType.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_PaidType.DescId = zc_MovementLinkObject_PaidType()
             LEFT JOIN Object AS Object_PaidType ON Object_PaidType.Id = MovementLinkObject_PaidType.ObjectId								  

 	     LEFT JOIN Object AS Object_CashMember ON Object_CashMember.Id = Movement_Check.MemberId

/*           LEFT JOIN MovementLinkObject AS MovementLinkObject_DiscountCard
                                          ON MovementLinkObject_DiscountCard.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_DiscountCard.DescId = zc_MovementLinkObject_DiscountCard()
             LEFT JOIN Object AS Object_DiscountCard ON Object_DiscountCard.Id = MovementLinkObject_DiscountCard.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                          ON MovementLinkObject_ConfirmedKind.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
             LEFT JOIN Object AS Object_ConfirmedKind ON Object_ConfirmedKind.Id = MovementLinkObject_ConfirmedKind.ObjectId
                        
             LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKindClient
                                          ON MovementLinkObject_ConfirmedKindClient.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_ConfirmedKindClient.DescId = zc_MovementLinkObject_ConfirmedKindClient()
             LEFT JOIN Object AS Object_ConfirmedKindClient ON Object_ConfirmedKindClient.Id = MovementLinkObject_ConfirmedKindClient.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                          ON MovementLinkObject_PartnerMedical.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
             LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = MovementLinkObject_PartnerMedical.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                          ON MovementLinkObject_SPKind.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
             LEFT JOIN Object AS Object_SPKind ON Object_SPKind.Id = MovementLinkObject_SPKind.ObjectId

             LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                  ON ObjectLink_DiscountExternal.ObjectId = Object_DiscountCard.Id
                                 AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountCard_Object()
             LEFT JOIN Object AS Object_DiscountExternal ON Object_DiscountExternal.Id = ObjectLink_DiscountExternal.ChildObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_MemberSP
                                          ON MovementLinkObject_MemberSP.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_MemberSP.DescId = zc_MovementLinkObject_MemberSP()
             LEFT JOIN Object AS Object_MemberSP ON Object_MemberSP.Id = MovementLinkObject_MemberSP.ObjectId

             LEFT JOIN ObjectLink AS ObjectLink_MemberSP_GroupMemberSP
                                  ON ObjectLink_MemberSP_GroupMemberSP.ObjectId = MovementLinkObject_MemberSP.ObjectId
                                 AND ObjectLink_MemberSP_GroupMemberSP.DescId = zc_ObjectLink_MemberSP_GroupMemberSP()
             LEFT JOIN Object AS Object_GroupMemberSP ON Object_GroupMemberSP.Id = ObjectLink_MemberSP_GroupMemberSP.ChildObjectId
*/
             LEFT JOIN tmpMovementLinkObject AS MLO_Insert
                                             ON MLO_Insert.MovementId = Movement_Check.Id
                                            AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
             LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

             -- строки документа
             INNER JOIN tmpMI ON tmpMI.MovementId = Movement_Check.Id
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.04.21                                                       * add BuyerForSite
 23.01.19         *
*/

-- тест
--SELECT * FROM gpSelect_MI_Check_Choice (inStartDate:= '01.01.2019', inEndDate:= '15.01.2019', inUnitId:= 183292 , inGoodsId:= 26479  , inIsErased := FALSE, inSession:= '2')