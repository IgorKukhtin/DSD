-- Function: gpSelect_Movement_TransportIncome (Integer, Boolean, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Movement_TransportIncome (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_TransportIncome(
    IN inParentId    Integer      , -- Ключ Master <Документ>
    IN inShowAll     Boolean      , -- 
    IN inIsErased    Boolean      , -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, InvNumber Integer, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime, InvNumberPartner TVarChar
             , PriceWithVAT Boolean
             , isChangePriceUser Boolean -- Ручная скидка в цене (да/нет)
             , VATPercent TFloat, ChangePrice TFloat
             , FromId Integer, FromCode Integer, FromName TVarChar, PaidKindId Integer, PaidKindName TVarChar, ContractId Integer, ContractName TVarChar
             , RouteId Integer, RouteName TVarChar
             , MovementItemId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, FuelCode Integer, FuelName TVarChar
             , Amount TFloat, Price TFloat, CountForPrice TFloat, AmountSumm TFloat, AmountSummTotal TFloat
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_TransportIncome());
     vbUserId:= lpGetUserBySession (inSession);


    IF COALESCE (inParentId, 0) = 0 THEN RETURN; END IF;


     RETURN QUERY 
       WITH lfObject_Account AS (SELECT * FROM lfSelect_Object_Account_byAccountGroup (zc_Enum_AccountGroup_20000())) -- 20000; "Запасы"
          , tmpMovement AS (SELECT Movement.* FROM Movement WHERE Movement.ParentId = inParentId)
          , tmpMIContainer_all AS (SELECT MIContainer.*
                                   FROM MovementItemContainer AS MIContainer
                                   WHERE MIContainer.MovementId IN (SELECT tmpMovement.Id FROM tmpMovement)
                                     AND MIContainer.DescId = zc_MIContainer_Summ()
                                  )
          , tmpMIContainer AS (SELECT MIContainer.MovementItemId, SUM (MIContainer.Amount) AS Amount
                               FROM Movement
                                    JOIN tmpMIContainer_all AS MIContainer ON MIContainer.MovementId = Movement.Id
                                                                         AND MIContainer.DescId = zc_MIContainer_Summ()
                                    JOIN Container ON Container.Id = MIContainer.ContainerId
                                    JOIN lfObject_Account ON lfObject_Account.AccountId = Container.ObjectId
                               WHERE Movement.ParentId = inParentId
                               GROUP BY MIContainer.MovementItemId
                              )
          , tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE)
       --
       SELECT
             Movement.Id AS MovementId
           , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode          AS StatusCode
           , Object_Status.ValueData           AS StatusName

           , MovementDate_OperDatePartner.ValueData    AS OperDatePartner
           , MovementString_InvNumberPartner.ValueData AS InvNumberPartner

           , MovementBoolean_PriceWithVAT.ValueData      AS PriceWithVAT
           , COALESCE (MovementBoolean_ChangePriceUser.ValueData, FALSE) AS isChangePriceUser
           , MovementFloat_VATPercent.ValueData          AS VATPercent
           , MovementFloat_ChangePrice.ValueData         AS ChangePrice

           , Object_From.Id                    AS FromId
           , Object_From.ObjectCode            AS FromCode
           , Object_From.ValueData             AS FromName
           , Object_PaidKind.Id                AS PaidKindId
           , Object_PaidKind.ValueData         AS PaidKindName
           , Object_Contract.Id                AS ContractId
           , Object_Contract.ValueData         AS ContractName
           , Object_Route.Id                   AS RouteId
           , Object_Route.ValueData            AS RouteName

           , MovementItem.Id          AS MovementItemId
           , Object_Goods.Id          AS GoodsId
           , Object_Goods.ObjectCode  AS GoodsCode
           , Object_Goods.ValueData   AS GoodsName
           , Object_Fuel.ObjectCode   AS FuelCode
           , Object_Fuel.ValueData    AS FuelName
           , MovementItem.Amount

           , MIFloat_Price.ValueData         AS Price
           , MIFloat_CountForPrice.ValueData AS CountForPrice

           , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                           THEN CAST ( MovementItem.Amount * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                        ELSE CAST ( MovementItem.Amount * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                   END AS TFloat) AS AmountSumm
           , CAST (tmpMIContainer.Amount AS TFloat) AS AmountSummTotal

           , MovementItem.isErased

     --FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
          --JOIN Movement ON Movement.ParentId = inParentId
          --             AND Movement.DescId = zc_Movement_Income()
                     -- AND Movement.isErased = tmpIsErased.isErased !!!убрал т.к. удаляются только элементы!!!
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN MovementBoolean AS MovementBoolean_ChangePriceUser
                                      ON MovementBoolean_ChangePriceUser.MovementId = Movement.Id
                                     AND MovementBoolean_ChangePriceUser.DescId = zc_MovementBoolean_ChangePriceUser()

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
            LEFT JOIN MovementFloat AS MovementFloat_ChangePrice
                                    ON MovementFloat_ChangePrice.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePrice.DescId = zc_MovementFloat_ChangePrice()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                         ON MovementLinkObject_Route.MovementId = Movement.Id
                                        AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementLinkObject_Route.ObjectId

            JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                             AND MovementItem.DescId     = zc_MI_Master()
            JOIN tmpIsErased ON tmpIsErased.isErased = MovementItem.isErased

            LEFT JOIN tmpMIContainer ON tmpMIContainer.MovementItemId = MovementItem.Id

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN tmpMIContainer_all AS MIContainer_Count ON MIContainer_Count.MovementItemId = MovementItem.Id
                                                             AND MIContainer_Count.DescId = zc_MIContainer_Count()
                                                             AND MIContainer_Count.isActive = TRUE
                                                           --AND 1=0
            LEFT JOIN Container AS Container_Count ON Container_Count.Id = MIContainer_Count.ContainerId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Fuel ON ObjectLink_Goods_Fuel.ObjectId = MovementItem.ObjectId
                                                         AND ObjectLink_Goods_Fuel.DescId = zc_ObjectLink_Goods_Fuel()
            LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = COALESCE (Container_Count.ObjectId, ObjectLink_Goods_Fuel.ChildObjectId)
       WHERE Movement.ParentId = inParentId
         AND Movement.DescId = zc_Movement_Income()

       ;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.11.22         * add isChangePriceUser
 31.10.13                                        * add OperDatePartner
 26.10.13                                        * add MIContainer_Count.isActive = TRUE
 23.10.13                                        * add zfConvert_StringToNumber
 07.10.13                                        * add lpCheckRight
 05.10.13                                        * add InvNumberPartner
 04.10.13                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_TransportIncome (inParentId:= 688, inShowAll:= TRUE, inIsErased:= TRUE, inSession:= zfCalc_UserAdmin())
-- select * from gpSelect_Movement_TransportIncome (inParentId := 15468824 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '10909');
