-- Function: gpReport_Sale_PartialSale()

DROP FUNCTION IF EXISTS gpReport_Sale_PartialSale (TDateTime, TDateTime, Integer ,Integer ,TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Sale_PartialSale(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inJuridicalId   Integer ,
    IN inFromId        Integer ,
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id          Integer
             , InvNumber   TVarChar
             , OperDate    TDateTime
             , UnitId      Integer
             , UnitName    TVarChar
             , GoodsId     Integer
             , GoodsCode   Integer
             , GoodsName   TVarChar
             , Amount      TFloat
             , Price       TFloat
             , Summ        TFloat
             , PriceSale   TFloat
             , SummSale    TFloat
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
   vbUserId := inSession;

   RETURN QUERY
   WITH
        tmpIncome AS ( --Остатки по приходу
                             SELECT Movement.Id                           AS MovementId
                                  , MovementLinkObject_From.ObjectId      AS FromId
                                  , MovementLinkObject_Juridical.ObjectId AS JuridicalId
                             FROM Movement

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                 ON MovementLinkObject_From.MovementId = Movement.Id
                                                                AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                                 ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                                                AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                 ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                                AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                    LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId
                                    LEFT JOIN ObjectBoolean AS ObjectBoolean_PartialPay
                                                            ON ObjectBoolean_PartialPay.ObjectId = Object_Contract.Id
                                                           AND ObjectBoolean_PartialPay.DescId = zc_ObjectBoolean_Contract_PartialPay()

                             WHERE Movement.Id > 15000000
                               AND MovementLinkObject_From.ObjectId = inFromId
                               AND MovementLinkObject_Juridical.ObjectId = inJuridicalId
                               AND COALESCE (ObjectBoolean_PartialPay.ValueData, FALSE) = TRUE
                             ),
        tmpIncomeList AS ( --Остатки по приходу
                             SELECT Movement.MovementId             AS MovementId
                                  , MovementItem_Income.Id          AS MovementItemId
                                  , MovementItem_Income.ObjectId    AS GoodsId
                                  , MIFloat_Price.ValueData         AS Price
                                  , MovementItem_Income.Amount      AS AmountInIncome
                                  , Movement.FromId                 AS FromId
                                  , Movement.JuridicalId            AS JuridicalId
                             FROM tmpIncome AS Movement

                                    LEFT JOIN MovementItem AS MovementItem_Income ON MovementItem_Income.DescId     = zc_MI_Master()
                                                                                 AND MovementItem_Income.MovementId = Movement.MovementId
                                                                                 AND MovementItem_Income.isErased   = FALSE

                                    LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                ON MIFloat_Price.MovementItemId = MovementItem_Income.Id
                                                               AND MIFloat_Price.DescId = zc_MIFloat_PriceWithVAT()

                             WHERE Movement.MovementId in (SELECT DISTINCT tmpIncome.MovementId FROM tmpIncome)
                             ),
        tmpContainerRemainsAll AS ( --Остатки по приходу
                             SELECT Object_PartionMovementItem.ObjectCode                             AS MovementItemId
                                  , Container.ID
                                  , Container.Amount                                                  AS Remains
                             FROM Object AS Object_PartionMovementItem

                                       INNER JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                                     ON ContainerLinkObject_MovementItem.ObjectId = Object_PartionMovementItem.Id
                                                                    AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()

                                       INNER JOIN Container ON Container.ID = ContainerLinkObject_MovementItem.ContainerId
                                                           AND Container.DescId = zc_Container_Count()


                             WHERE Object_PartionMovementItem.ObjectCode IN (SELECT DISTINCT tmpIncomeList.MovementItemId FROM tmpIncomeList)
                               AND Object_PartionMovementItem.DescId = zc_object_PartionMovementItem()
                             GROUP BY Container.ID, Object_PartionMovementItem.ObjectCode
                             )

   SELECT MovementItemContainer.MovementId           AS Id
        , Movement.InvNumber                         AS InvNumber
        , Movement.OperDate                          AS OperDate
        , MovementLinkObject_Unit.ObjectId           AS UnitId
        , Object_Unit.ValueData                      AS UnitName
        , MovementItem.ObjectId                      AS GoodsId
        , Object_Goods.ObjectCode                    AS GoodsCode
        , Object_Goods.ValueData                     AS GoodsName
        , MovementItem.Amount                        AS Amount
        , tmpIncomeList.Price                        AS Price
        , Round(tmpIncomeList.Price * MovementItem.Amount , 2)::TFloat AS  Summa
        , MIFloat_Price.ValueData                    AS PriceSale
        , CASE WHEN COALESCE (MB_RoundingDown.ValueData, False) = True
               THEN TRUNC(COALESCE (MovementItem.Amount, 0) * MIFloat_Price.ValueData, 1)::TFloat
               ELSE CASE WHEN COALESCE (MB_RoundingTo10.ValueData, False) = True
               THEN (((COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData)::NUMERIC (16, 1))::TFloat
               ELSE (((COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData)::NUMERIC (16, 2))::TFloat END END AS SummSale
   FROM tmpContainerRemainsAll AS Container

        INNER JOIN MovementItemContainer ON MovementItemContainer.ContainerID = Container.ID
                                        AND MovementItemContainer.OperDate >= inStartDate
                                        AND MovementItemContainer.OperDate < inEndDate + INTERVAL '1 DAY'
                                        AND MovementItemContainer.MovementDescId in (zc_Movement_Check(), zc_Movement_Sale())

        INNER JOIN Movement AS Movement ON Movement.ID = MovementItemContainer.MovementId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

        LEFT JOIN MovementBoolean AS MB_RoundingTo10
                                  ON MB_RoundingTo10.MovementId = Movement.Id
                                 AND MB_RoundingTo10.DescId = zc_MovementBoolean_RoundingTo10()
        LEFT JOIN MovementBoolean AS MB_RoundingDown
                                  ON MB_RoundingDown.MovementId = Movement.Id
                                 AND MB_RoundingDown.DescId = zc_MovementBoolean_RoundingDown()

        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

        INNER JOIN MovementItem AS MovementItem ON MovementItem.ID = MovementItemContainer.MovementItemId

        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

        LEFT JOIN MovementItemFloat AS MIFloat_Price
                                    ON MIFloat_Price.MovementItemId = MovementItem.Id
                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()

        LEFT JOIN tmpIncomeList ON tmpIncomeList.MovementItemId = Container.MovementItemId
  ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 06.11.20                                                       *

*/

-- тест
--
SELECT * FROM gpReport_Sale_PartialSale (inStartDate := CURRENT_DATE - INTERVAL '7 DAY',  inEndDate := CURRENT_DATE,  inJuridicalId := 13310756, inFromId := 9526799, inSession:= '3')
                              