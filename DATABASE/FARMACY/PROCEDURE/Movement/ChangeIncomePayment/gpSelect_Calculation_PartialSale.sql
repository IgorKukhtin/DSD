-- Function: gpSelect_Calculation_PartialSale()

DROP FUNCTION IF EXISTS gpSelect_Calculation_PartialSale (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Calculation_PartialSale(
    IN inOperDate    TDateTime,     -- На дату
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (JuridicalId    Integer
             , JuridicalName  TVarChar
             , FromId         Integer
             , FromName       TVarChar
             , Summa          TFloat
             , DateStart      TDateTime
             , DateEnd        TDateTime
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
   vbUserId := inSession;

   RETURN QUERY
   WITH tmpContainer AS
                           (SELECT Object_Movement.ObjectCode AS MovementId, Container.Amount, Container.KeyValue
                            FROM Container
                                 LEFT JOIN Object AS Object_Movement ON Object_Movement.Id = Container.ObjectId
                                                                    AND Object_Movement.DescId = zc_Object_PartionMovement()
                            WHERE Container.DescId = zc_Container_SummIncomeMovementPayment()
                              AND Object_Movement.ObjectCode > 15000000
                           ),
        tmpContainerPartialPay AS
                           (SELECT tmpContainer.MovementId, tmpContainer.Amount, tmpContainer.KeyValue
                            FROM tmpContainer
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                              ON MovementLinkObject_Contract.MovementId = tmpContainer.MovementId
                                                             AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                 LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId
                                 LEFT JOIN ObjectBoolean AS ObjectBoolean_PartialPay
                                                         ON ObjectBoolean_PartialPay.ObjectId = Object_Contract.Id
                                                        AND ObjectBoolean_PartialPay.DescId = zc_ObjectBoolean_Contract_PartialPay()
                            WHERE COALESCE (ObjectBoolean_PartialPay.ValueData, FALSE) = TRUE
                           ),
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

                             WHERE Movement.Id in (SELECT DISTINCT tmpContainerPartialPay.MovementId FROM tmpContainerPartialPay)
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

                             WHERE Movement.MovementId in (SELECT DISTINCT tmpContainerPartialPay.MovementId FROM tmpContainerPartialPay)
                             ),
        tmpContainerRemainsAll AS ( --Остатки по приходу
                             SELECT Object_PartionMovementItem.ObjectCode                             AS MovementItemId
                                  , Container.ID
                                  , Container.Amount - COALESCE(SUM(MovementItemContainer.Amount), 0) AS Remains
                             FROM Object AS Object_PartionMovementItem

                                       INNER JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                                     ON ContainerLinkObject_MovementItem.ObjectId = Object_PartionMovementItem.Id
                                                                    AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()

                                       INNER JOIN Container ON Container.ID = ContainerLinkObject_MovementItem.ContainerId
                                                           AND Container.DescId = zc_Container_Count()
                                                           AND Container.Amount <> 0

                                       LEFT JOIN MovementItemContainer ON MovementItemContainer.ContainerID = Container.ID
                                                                      AND MovementItemContainer.OperDate >= inOperDate
                                                                      AND MovementItemContainer.MovementItemId <> Object_PartionMovementItem.ObjectCode

                             WHERE Object_PartionMovementItem.ObjectCode IN (SELECT DISTINCT tmpIncomeList.MovementItemId FROM tmpIncomeList)
                               AND Object_PartionMovementItem.DescId = zc_object_PartionMovementItem()
                             GROUP BY Container.ID, Object_PartionMovementItem.ObjectCode
                             ),
        tmpContainerRemains AS ( --Остатки по приходу
                             SELECT tmpContainerRemainsAll.MovementItemId         AS MovementItemId
                                  , SUM(tmpContainerRemainsAll.Remains)           AS Remains
                             FROM tmpContainerRemainsAll
                             GROUP BY tmpContainerRemainsAll.MovementItemId
                             ),
        tmpIncomeRemains AS (SELECT tmpIncomeList.MovementId, Sum(Round(tmpIncomeList.Price * tmpContainerRemains.Remains, 2)) AS  SummaRemains
                             FROM tmpIncomeList

                                  LEFT JOIN tmpContainerRemains ON tmpContainerRemains.MovementItemId = tmpIncomeList.MovementItemId
                             GROUP BY tmpIncomeList.MovementId),
        tmpPartialSale AS (SELECT Income.JuridicalId, Income.FromId, Container.Amount
                           FROM (SELECT DISTINCT tmpIncome.FromId, tmpIncome.JuridicalId FROM tmpIncome) AS Income

                                INNER JOIN ContainerLinkObject AS CLO_JuridicalBasis
                                                               ON CLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
                                                              AND CLO_JuridicalBasis.ObjectId = Income.JuridicalId

                                INNER JOIN Container ON Container.Id =  CLO_JuridicalBasis.ContainerId
                                                    AND Container.DescId = zc_Container_SummIncomeMovementPayment()
                                                  --  AND Container.Amount <> 0
                                                    AND Container.ObjectId = zc_Enum_ChangeIncomePaymentKind_PartialSale()

                                INNER JOIN ContainerLinkObject AS CLO_Juridical
                                                              ON CLO_Juridical.ContainerId = Container.Id
                                                             AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                                             AND CLO_Juridical.ObjectId = Income.FromId),
         tmpNoPay AS (SELECT tmpIncome.JuridicalId, tmpIncome.FromId, SUM(tmpContainerPartialPay.Amount - COALESCE(tmpIncomeRemains.SummaRemains, 0)) AS Summa
                      FROM tmpContainerPartialPay

                           INNER JOIN tmpIncomeRemains ON tmpIncomeRemains.MovementId = tmpContainerPartialPay.MovementId

                           INNER JOIN tmpIncome ON tmpIncome.MovementId = tmpContainerPartialPay.MovementId

                      GROUP BY tmpIncome.JuridicalId, tmpIncome.FromId)

   SELECT tmpNoPay.JuridicalId
        , Object_Juridical.ValueData                 AS JuridicalName
        , tmpNoPay.FromId
        , Object_From.ValueData                      AS FromName
        , (tmpNoPay.Summa - COALESCE(tmpPartialSale.Amount, 0))::TFloat AS  Summa
        , (inOperDate - INTERVAL '7 DAY')::TDateTime AS DateStart
        , (inOperDate - INTERVAL '1 DAY')::TDateTime AS DateEnd
   FROM tmpNoPay

        LEFT JOIN tmpPartialSale ON tmpPartialSale.JuridicalId = tmpNoPay.JuridicalId
                                AND tmpPartialSale.FromId = tmpNoPay.FromId

        LEFT JOIN Object AS Object_From ON Object_From.Id = tmpNoPay.FromId
        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpNoPay.JuridicalId
   WHERE (tmpNoPay.Summa - COALESCE(tmpPartialSale.Amount, 0)) > 0
  ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.      Шаблий О.В.
 05.11.20                                                          *

*/

-- тест
-- 
SELECT * FROM gpSelect_Calculation_PartialSale (inOperDate := CURRENT_DATE, inSession:= '3')
                              