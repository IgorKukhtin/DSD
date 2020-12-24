-- Function: gpSelect_Movement_CheckToReturn()

DROP FUNCTION IF EXISTS gpSelect_Movement_CheckToReturn (Integer, TDateTime, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_CheckToReturn(
    IN inUnitId        Integer ,
    IN inOperDate      TDateTime ,
    IN inSumma         TFloat ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE Cursor1 refcursor;
   DECLARE Cursor2 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inUnitId, 0) = 0
     THEN
       vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
       IF vbUnitKey = '' THEN
          vbUnitKey := '0';
       END IF;
       inUnitId := vbUnitKey::Integer;
     END IF;

     CREATE TEMP TABLE _tmpMovement ON COMMIT DROP AS
     SELECT Movement.Id
     FROM Movement

          INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                    ON MovementLinkObject_Unit.MovementId = Movement.Id
                   AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

          LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                  ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                 AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

     WHERE Movement.DescId = zc_Movement_Check()
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND Movement.OperDate BETWEEN inOperDate AND inOperDate + INTERVAL '1 DAY'
       AND COALESCE(MovementFloat_TotalSumm.ValueData, 0) = inSumma
       AND MovementLinkObject_Unit.ObjectId = inUnitId;
       
    CREATE INDEX idx_tmpMovement_Id ON _tmpMovement(Id);

    OPEN Cursor1 FOR
       SELECT Movement.Id
            , Movement.InvNumber
            , Movement.OperDate
            , Movement.StatusId
            , Object_Status.ObjectCode                   AS StatusCode
            , MovementFloat_TotalCount.ValueData         AS TotalCount
            , MovementFloat_TotalSumm.ValueData          AS TotalSumm
            , Object_Unit.ValueData                      AS UnitName
            , Object_CashRegister.ValueData              AS CashRegisterName
            , MovementLinkObject_PaidType.ObjectId       AS PaidTypeId
            , Object_PaidType.ValueData                  AS PaidTypeName

	        , Object_DiscountExternal.Id                 AS DiscountExternalId
	        , Object_DiscountExternal.ValueData          AS DiscountExternalName
	        , Object_DiscountCard.ValueData              AS DiscountCardNumber

            , zc_Color_White()            AS Color_CalcDoc
            , MovementFloat_ManualDiscount.ValueData::Integer AS ManualDiscount

            , Object_PartionDateKind.ID                         AS PartionDateKindId
            , Object_PartionDateKind.ValueData                  AS PartionDateKindName
            , ObjectFloat_Month.ValueData                       AS AmountMonth
       FROM _tmpMovement

            LEFT JOIN Movement ON Movement.Id = _tmpMovement.Id


            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

   	        LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
		                              ON MovementBoolean_Deferred.MovementId = Movement.Id
		                             AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummChangePercent
                                    ON MovementFloat_TotalSummChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummChangePercent.DescId = zc_MovementFloat_TotalSummChangePercent()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                         ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                        AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
            LEFT JOIN Object AS Object_CashRegister ON Object_CashRegister.Id = MovementLinkObject_CashRegister.ObjectId

	        LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidType
                                         ON MovementLinkObject_PaidType.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidType.DescId = zc_MovementLinkObject_PaidType()
            LEFT JOIN Object AS Object_PaidType ON Object_PaidType.Id = MovementLinkObject_PaidType.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_DiscountCard
                                         ON MovementLinkObject_DiscountCard.MovementId = Movement.Id
                                        AND MovementLinkObject_DiscountCard.DescId = zc_MovementLinkObject_DiscountCard()
            LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                 ON ObjectLink_DiscountExternal.ObjectId = MovementLinkObject_DiscountCard.ObjectId
                                AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountCard_Object()
            LEFT JOIN Object AS Object_DiscountExternal ON Object_DiscountExternal.Id = ObjectLink_DiscountExternal.ChildObjectId
            LEFT JOIN Object AS Object_DiscountCard ON Object_DiscountCard.Id = MovementLinkObject_DiscountCard.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_ManualDiscount
                                    ON MovementFloat_ManualDiscount.MovementId =  Movement.Id
                                   AND MovementFloat_ManualDiscount.DescId = zc_MovementFloat_ManualDiscount()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                         ON MovementLinkObject_PartionDateKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
            LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = MovementLinkObject_PartionDateKind.ObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                  ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                 AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()

       ;
    RETURN NEXT Cursor1;

    OPEN Cursor2 FOR
       SELECT
             MovementItem.Id
           , MovementItem.ParentId
           , MovementItem.GoodsId
           , MovementItem.GoodsCode
           , MovementItem.GoodsName
           , MovementItem.Amount
           , MovementItem.Price
           , MovementItem.AmountSumm
           , MovementItem.NDS                                                    AS NDS
           , MovementItem.PriceSale
           , MovementItem.ChangePercent
           , MovementItem.SummChangePercent
           , MovementItem.AmountOrder
           , MovementItem.isErased
           , MovementItem.List_UID
           , MovementItem.Amount
           , zc_Color_White()                                                    AS Color_calc
           , zc_Color_Black()                                                    AS Color_ExpirationDate
           , Null::TVArChar                                                      AS AccommodationName
           , Null::TFloat                                                        AS Multiplicity
           , COALESCE (ObjectBoolean_DoesNotShare.ValueData, FALSE)              AS DoesNotShare
           , Null::TVArChar                                                      AS IdSP
           , Null::TFloat                                                        AS CountSP
           , Null::TFloat                                                        AS PriceRetSP
           , Null::TFloat                                                        AS PaymentSP
           , Object_PartionDateKind.Id                                           AS PartionDateKindId
           , Object_PartionDateKind.ValueData                                    AS PartionDateKindName
           , MIFloat_MovementItem.ValueData                                      AS PricePartionDate
           , MovementItem.MovementId                                             AS MovementId
       FROM _tmpMovement

            LEFT JOIN MovementItem_Check_View AS MovementItem
                                              ON MovementItem.MovementId = _tmpMovement.ID

            LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                        ON MIFloat_MovementItem.MovementItemId = MovementItem.Id
                                       AND MIFloat_MovementItem.DescId = zc_MIFloat_PricePartionDate()
            -- получаем GoodsMainId
            LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = MovementItem.GoodsId

            -- Не делить медикамент на кассах
            LEFT JOIN ObjectBoolean AS ObjectBoolean_DoesNotShare
                                    ON ObjectBoolean_DoesNotShare.ObjectId = MovementItem.GoodsId
                                   AND ObjectBoolean_DoesNotShare.DescId = zc_ObjectBoolean_Goods_DoesNotShare()
            --Типы срок/не срок
            LEFT JOIN MovementItemLinkObject AS MI_PartionDateKind
                                             ON MI_PartionDateKind.MovementItemId = MovementItem.Id
                                            AND MI_PartionDateKind.DescId = zc_MILinkObject_PartionDateKind()
            LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = MI_PartionDateKind.ObjectId
            LEFT JOIN ObjectFloat AS ObjectFloatDay
                                  ON ObjectFloatDay.ObjectId = Object_PartionDateKind.Id
                                 AND ObjectFloatDay.DescId = zc_ObjectFloat_PartionDateKind_Day()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_DiscountExternal
                                             ON MILinkObject_DiscountExternal.MovementItemId = MovementItem.Id
                                            AND MILinkObject_DiscountExternal.DescId         = zc_MILinkObject_DiscountExternal()
       ;
    RETURN NEXT Cursor2;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_CheckToReturn (Integer, TDateTime, TFloat, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Шаблий О.В.
 23.05.19                                                                    *
*/

-- тест
--

select * from gpSelect_Movement_CheckToReturn(inUnitId := 377605 , inOperDate := ('24.12.2020')::TDateTime , inSumma := 2.2 ,  inSession := '3990942');