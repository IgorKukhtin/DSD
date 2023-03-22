-- Function: gpReport_MovementCheck_DiscountExternal()

DROP FUNCTION IF EXISTS gpReport_MovementCheck_DiscountExternal (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MovementCheck_DiscountExternal(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inUnitId             Integer,    -- Подразделение
    IN inDiscountExternalId Integer,    -- Подразделение
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer
             , UnitName TVarChar, MainJuridicalId Integer, MainJuridicalName TVarChar, RetailId Integer, RetailName TVarChar
             , CashRegisterName TVarChar, PaidTypeName TVarChar
             , DiscountCardName TVarChar, DiscountExternalName TVarChar
             , DateCompensation TDateTime
             , MovementItemContainerID Integer 
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat
             , Price TFloat
             , Summa TFloat
             , NDS TFloat
             , PriceSale TFloat
             , SummSale TFloat
             , ChangePercent TFloat
             , SummChangePercent TFloat
             , FromName TVarChar
             , InvNumberIncome TVarChar
             , OperDateIncome TDateTime
             , PriceWithVAT TFloat
             , ActNumber TVarChar
             , AmountAct TFloat
             , isClosed boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbRetailId Integer;
   DECLARE vbDayCompensDiscount Integer;
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
                   WHERE (ObjectLink_Unit_Juridical.ObjectId = inUnitId or COALESCE(inUnitId, 0) = 0)
                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                   LIMIT 1
                   )
                   END;
                   
     --raise notice   'Value 1: %', CLOCK_TIMESTAMP();

     CREATE TEMP TABLE tmpMovement ON COMMIT DROP AS 
      SELECT Movement.*
           , MovementLinkObject_Unit.ObjectId                    AS UnitId
           , MovementLinkObject_DiscountCard.ObjectId            AS DiscountCardID
           , ObjectLink_DiscountExternal.ChildObjectId           AS DiscountExternalId
      FROM Movement


           INNER JOIN MovementLinkObject AS MovementLinkObject_DiscountCard
                                         ON MovementLinkObject_DiscountCard.MovementId = Movement.ID
                                        AND MovementLinkObject_DiscountCard.DescId = zc_MovementLinkObject_DiscountCard()

           INNER JOIN ObjectLink AS ObjectLink_DiscountExternal
                                 ON ObjectLink_DiscountExternal.ObjectId = MovementLinkObject_DiscountCard.ObjectId
                                AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountCard_Object()

           INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

      WHERE Movement.OperDate >= DATE_TRUNC ('DAY', inStartDate)
        AND Movement.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
        AND Movement.DescId = zc_Movement_Check()
        AND (ObjectLink_DiscountExternal.ChildObjectId = inDiscountExternalId
         OR COALESCE (ObjectLink_DiscountExternal.ChildObjectId, 0) <> 0 AND COALESCE (inDiscountExternalId, 0) = 0)
        AND (MovementLinkObject_Unit.ObjectId = inUnitId OR COALESCE (inUnitId, 0) = 0)
        AND  Movement.StatusId = zc_Enum_Status_Complete();
        
     ANALYSE tmpMovement;
     
     --raise notice   'Value 2: %', CLOCK_TIMESTAMP();

     CREATE TEMP TABLE tmpMI ON COMMIT DROP AS 
     SELECT MovementItem.*
          , COALESCE (MB_RoundingDown.ValueData, False)  AS isRoundingDown
          , COALESCE (MB_RoundingTo10.ValueData, False)  AS isRoundingTo10
          , COALESCE (MB_RoundingTo50.ValueData, False)  AS isRoundingTo50
          , MILinkObject_NDSKind.ObjectId                AS NDSKindId
     FROM tmpMovement AS Movement

          LEFT JOIN MovementBoolean AS MB_RoundingTo10
                                    ON MB_RoundingTo10.MovementId = Movement.Id
                                   AND MB_RoundingTo10.DescId = zc_MovementBoolean_RoundingTo10()
          LEFT JOIN MovementBoolean AS MB_RoundingDown
                                    ON MB_RoundingDown.MovementId = Movement.Id
                                   AND MB_RoundingDown.DescId = zc_MovementBoolean_RoundingDown()
          LEFT JOIN MovementBoolean AS MB_RoundingTo50
                                    ON MB_RoundingTo50.MovementId = Movement.Id
                                   AND MB_RoundingTo50.DescId = zc_MovementBoolean_RoundingTo50()

          LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                AND MovementItem.DescId = zc_MI_Master()
                                AND MovementItem.Amount > 0                                                                     

          LEFT JOIN MovementItemLinkObject AS MILinkObject_NDSKind
                                           ON MILinkObject_NDSKind.MovementItemId = MovementItem.Id
                                          AND MILinkObject_NDSKind.DescId = zc_MILinkObject_NDSKind()
          ;

     ANALYSE tmpMI;
     
     --raise notice   'Value 3: %', CLOCK_TIMESTAMP();

     CREATE TEMP TABLE tmpMIPrice ON COMMIT DROP AS 
     SELECT MovementItem.*
          , MIFloat_Price.ValueData             AS Price
          , MIFloat_PriceSale.ValueData         AS PriceSale
          , MIFloat_ChangePercent.ValueData     AS ChangePercent
          , MIFloat_SummChangePercent.ValueData AS SummChangePercent
          , zfCalc_SummaCheck(COALESCE (MovementItem.Amount, 0) * MIFloat_Price.ValueData
                            , MovementItem.isRoundingDown
                            , MovementItem.isRoundingTo10
                            , MovementItem.isRoundingTo50) AS AmountSumm
     FROM tmpMI AS MovementItem

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
          ;

     ANALYSE tmpMIPrice;
     
     --raise notice   'Value 4: %', CLOCK_TIMESTAMP();

     CREATE TEMP TABLE tmpMIC ON COMMIT DROP AS 
      SELECT MovementItem.Id                     AS Id
           , MovementItem.MovementId             AS MovementId
           , MovementItem.ObjectId               AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , Object_Goods.Name                   AS GoodsName
           , MovementItem.Amount                 AS Amount
           , MovementItem.Price
           , MovementItem.PriceSale
           , MovementItem.ChangePercent
           , MovementItem.SummChangePercent
           , MovementItem.AmountSumm
           , ObjectFloat_NDSKind_NDS.ValueData   AS NDS

           , MovementItemContainer.Id                                   AS MovementItemContainerID    
           , (-1.0 * MovementItemContainer.Amount) :: TFloat            AS AmountMIC
           , COALESCE (MI_Income_find.Id,MI_Income.Id)                  AS MI_IncomeId
           , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)  AS M_IncomeId
      FROM tmpMIPrice AS MovementItem

           LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = MovementItem.ObjectId
           LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = Object_Goods_Retail.GoodsMainId

           LEFT JOIN (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                           , ObjectFloat_NDSKind_NDS.ValueData
                      FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                      WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()) AS ObjectFloat_NDSKind_NDS
                         ON ObjectFloat_NDSKind_NDS.ObjectId = COALESCE (MovementItem.NDSKindId, Object_Goods.NDSKindId)
                          
           LEFT JOIN MovementItemContainer ON MovementItemContainer.MovementItemId = MovementItem.ID

           LEFT JOIN ContainerLinkObject AS CLI_MI
                                         ON CLI_MI.ContainerId = MovementItemContainer.ContainerId
                                        AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
           LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
           -- элемент прихода
           LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
           -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
           LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                       ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                      AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
           -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
           LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                                                -- AND 1=0

    ;     

     ANALYSE tmpMIC;
     
     --raise notice   'Value 5: %', CLOCK_TIMESTAMP();

     -- Результат
     RETURN QUERY
         SELECT
             Movement_Check.Id
           , Movement_Check.InvNumber
           , Movement_Check.OperDate
           , Object_Status.ObjectCode                           AS StatusCode

           , Object_Unit.ValueData                              AS UnitName
           , Object_MainJuridical.Id                            AS MainJuridicalId
           , Object_MainJuridical.ValueData                     AS MainJuridicalName
           , Object_Retail.ID                                   AS RetailId
           , Object_Retail.ValueData                            AS RetailName
           , Object_CashRegister.ValueData                      AS CashRegisterName
           , Object_PaidType.ValueData                          AS PaidTypeName

           , Object_DiscountCard.ValueData                      AS DiscountCardName
           , Object_DiscountExternal.ValueData                  AS DiscountExternalName
           
           , MovementDate_Compensation.ValueData                AS DateCompensation

           , MovementItem.MovementItemContainerID   
           , MovementItem.GoodsId
           , MovementItem.GoodsCode
           , MovementItem.GoodsName
           , MovementItem.AmountMIC
           , MovementItem.Price
           , (MovementItem.AmountSumm * MovementItem.AmountMIC / MovementItem.Amount) :: TFloat
           , MovementItem.NDS
           , MovementItem.PriceSale
           , (MovementItem.PriceSale * MovementItem.AmountMIC) :: TFloat AS SummSale
           , MovementItem.ChangePercent
           , (MovementItem.SummChangePercent * MovementItem.AmountMIC / MovementItem.Amount) :: TFloat
           , Object_From.ValueData                      AS FromName
           , Movement_Income.InvNumber                  AS InvNumberIncome
           , Movement_Income.OperDate                   AS OperDateIncome
           , MIFloat_PriceWithVAT.ValueData             AS PriceWithVAT
           , COALESCE(Object_AccountSalesDE.ValueData, MovementString_ActNumber.ValueData)         AS ActNumber
           , COALESCE (AccountSalesDE_Amount.ValueData, MovementFloat_AmountAct.ValueData)         AS AmountAct
           , COALESCE (MovementBoolean_Closed.ValueData, False) AS isClosed

        FROM tmpMovement AS Movement_Check

             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Check.StatusId

             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Movement_Check.UnitId

             LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                  ON ObjectLink_Unit_Juridical.ObjectId = Movement_Check.UnitId
                                 AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
             LEFT JOIN Object AS Object_MainJuridical ON Object_MainJuridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                  ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                 AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
             LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                          ON MovementLinkObject_CashRegister.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
             LEFT JOIN Object AS Object_CashRegister ON Object_CashRegister.Id = MovementLinkObject_CashRegister.ObjectId

             LEFT JOIN Object AS Object_DiscountCard ON Object_DiscountCard.Id = Movement_Check.DiscountCardId
             LEFT JOIN Object AS Object_DiscountExternal ON Object_DiscountExternal.Id = Movement_Check.DiscountExternalId

             LEFT JOIN MovementDate AS MovementDate_Compensation
                                    ON MovementDate_Compensation.MovementId = Movement_Check.Id
                                   AND MovementDate_Compensation.DescId = zc_MovementDate_Compensation()
                                   
             LEFT JOIN MovementString AS MovementString_ActNumber
                                      ON MovementString_ActNumber.MovementId = Movement_Check.Id
                                     AND MovementString_ActNumber.DescId = zc_MovementString_ActNumber()

             LEFT JOIN MovementFloat AS MovementFloat_AmountAct
                                     ON MovementFloat_AmountAct.MovementId = Movement_Check.Id
                                    AND MovementFloat_AmountAct.DescId = zc_MovementFloat_AmountAct()

             LEFT JOIN MovementBoolean AS MovementBoolean_Closed
                                       ON MovementBoolean_Closed.MovementId = Movement_Check.Id
                                      AND MovementBoolean_Closed.DescId = zc_MovementBoolean_Closed()                                   

   	         LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidType
                                          ON MovementLinkObject_PaidType.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_PaidType.DescId = zc_MovementLinkObject_PaidType()
             LEFT JOIN Object AS Object_PaidType ON Object_PaidType.Id = MovementLinkObject_PaidType.ObjectId

             LEFT JOIN tmpMIC AS MovementItem
                              ON MovementItem.MovementId = Movement_Check.Id
                             AND MovementItem.Amount > 0 
                                               
             -- Цена поставщика с учетом НДС
             LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                         ON MIFloat_PriceWithVAT.MovementItemId = MovementItem.MI_IncomeId
                                        AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()

             LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                          ON MovementLinkObject_From.MovementId = MovementItem.M_IncomeId
                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

             LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
             
             LEFT JOIN Movement AS Movement_Income ON Movement_Income.Id = MovementItem.M_IncomeId
             
             LEFT JOIN Object AS Object_AccountSalesDE ON Object_AccountSalesDE.DescId = zc_Object_AccountSalesDE()
                                                      AND Object_AccountSalesDE.ObjectCode = MovementItem.MovementItemContainerId
                                            
             LEFT JOIN ObjectFloat AS AccountSalesDE_Amount
                                   ON AccountSalesDE_Amount.ObjectId = Object_AccountSalesDE.Id
                                  AND AccountSalesDE_Amount.DescId = zc_ObjectFloat_AccountSalesDE_Amount()                                   
                                            
             ;

     --raise notice   'Value 20: %', CLOCK_TIMESTAMP();

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 29.10.19                                                       *
*/

select * from gpReport_MovementCheck_DiscountExternal(inStartDate := ('10.03.2023')::TDateTime , inEndDate := ('19.03.2023')::TDateTime , inUnitId := 0 , inDiscountExternalId := 0 ,  inSession := '3');