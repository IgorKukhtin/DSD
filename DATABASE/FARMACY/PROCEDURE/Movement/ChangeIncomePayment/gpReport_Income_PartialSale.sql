-- Function: gpReport_Income_PartialSale()

DROP FUNCTION IF EXISTS gpReport_Income_PartialSale (TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Income_PartialSale(
    IN inOperDate      TDateTime,     -- На дату
    IN inJuridicalId   Integer ,
    IN inFromId        Integer ,
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE (MovementId     Integer
             , InvNumber      TVarChar
             , OperDate       TDateTime
             , JuridicalId    Integer
             , JuridicalName  TVarChar
             , FromId         Integer
             , FromName       TVarChar
             , UnitId         Integer
             , UnitName       TVarChar
             , TotalSumm      TFloat
             , NoPay          TFloat
             , Remains        TFloat
             , ToPay          TFloat
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
   vbUserId := inSession;

   RETURN QUERY
   WITH tmpContract AS ( --Договора с оплатой частями
                        SELECT 
                               Object_Contract_View.Id
                             , Object_Contract_View.JuridicalId
                        FROM Object_Contract_View

                             LEFT JOIN ObjectBoolean AS ObjectBoolean_PartialPay
                                                     ON ObjectBoolean_PartialPay.ObjectId = Object_Contract_View.ContractId
                                                    AND ObjectBoolean_PartialPay.DescId = zc_ObjectBoolean_Contract_PartialPay()
                        WHERE Object_Contract_View.isErased = False
                          AND COALESCE (ObjectBoolean_PartialPay.ValueData, FALSE) = TRUE
                          AND (Object_Contract_View.JuridicalId = inFromId OR COALESCE (inFromId, 0) = 0)
                        ),
        tmpIncomeAll AS ( --Остатки по приходу
                             SELECT Movement.Id                           AS Id
                                  , Movement.InvNumber                    AS InvNumber
                                  , Movement.OperDate                     AS OperDate
                             FROM MovementLinkObject AS MovementLinkObject_Contract

                                    INNER JOIN Movement ON MovementLinkObject_Contract.MovementId = Movement.Id

                             WHERE MovementLinkObject_Contract.MovementId > 15000000
                               AND Movement.DescId = zc_Movement_Income()
                               AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                               AND MovementLinkObject_Contract.ObjectId in (SELECT tmpContract.ID FROM tmpContract)
                             ),
        tmpIncome AS ( --Остатки по приходу
                             SELECT Movement.Id                           AS MovementId
                                  , Movement.InvNumber                    AS InvNumber
                                  , Movement.OperDate                     AS OperDate
                                  , MovementLinkObject_From.ObjectId      AS FromId
                                  , MovementLinkObject_Juridical.ObjectId AS JuridicalId
                                  , MovementLinkObject_To.ObjectId        AS UnitId
                                  , MovementFloat_TotalSumm.ValueData     AS TotalSumm
                             FROM tmpIncomeAll AS Movement 

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                 ON MovementLinkObject_From.MovementId = Movement.Id
                                                                AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                                 ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                                                AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                                 ON MovementLinkObject_To.MovementId = Movement.Id
                                                                AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                    LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                            ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                                           AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                             WHERE (MovementLinkObject_Juridical.ObjectId = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
                             ),
        tmpIncomeList AS ( --Остатки по приходу
                             SELECT Movement.MovementId             AS MovementId
                                  , MovementItem_Income.Id          AS MovementItemId
                                  , MovementItem_Income.ObjectId    AS GoodsId
                                  , MIFloat_Price.ValueData         AS Price
                                  , MovementItem_Income.Amount      AS AmountInIncome
                                  , Movement.FromId                 AS FromId
                                  , Movement.JuridicalId            AS JuridicalId
                             FROM MovementItem AS MovementItem_Income

                                    LEFT JOIN tmpIncome AS Movement ON MovementItem_Income.MovementId = Movement.MovementId

                                    LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                ON MIFloat_Price.MovementItemId = MovementItem_Income.Id
                                                               AND MIFloat_Price.DescId = zc_MIFloat_PriceWithVAT()

                             WHERE MovementItem_Income.MovementId in (SELECT DISTINCT tmpIncome.MovementId FROM tmpIncome)
                               AND MovementItem_Income.DescId     = zc_MI_Master()
                               AND MovementItem_Income.MovementId = Movement.MovementId
                               AND MovementItem_Income.isErased   = FALSE
                             ),
        tmpContainer AS  -- Остаток оплаты по приходу
                           (SELECT tmpIncome.MovementId AS MovementId, Container.Amount
                            FROM tmpIncome
                            
                                 LEFT JOIN MovementItemContainer AS MIC 
                                                                 ON MIC.MovementId = tmpIncome.MovementId
                                                                AND MIC.DescId = zc_MIContainer_SummIncomeMovementPayment()
                                 LEFT JOIN Container ON Container.DescId = zc_Container_SummIncomeMovementPayment()
                                                    AND Container.ID = MIC.ContainerId
                           ),
        tmpContainerRemainsAll AS ( --Остатки по приходу

                             SELECT tmpIncomeList.MovementId                                          AS MovementId
                                  , tmpIncomeList.MovementItemId                                      AS MovementItemId
                                  , tmpIncomeList.Price                                               AS Price
                                  , Container.ID
                                  , Container.Amount - COALESCE(SUM(MovementItemContainer.Amount), 0) AS Remains
                             FROM Object AS Object_PartionMovementItem

                                       INNER JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                                     ON ContainerLinkObject_MovementItem.ObjectId = Object_PartionMovementItem.Id
                                                                    AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()

                                       INNER JOIN Container ON Container.ID = ContainerLinkObject_MovementItem.ContainerId
                                                           AND Container.DescId = zc_Container_Count()
                                                           
                                       INNER JOIN tmpIncomeList ON tmpIncomeList.MovementItemId = Object_PartionMovementItem.ObjectCode

                                       LEFT JOIN MovementItemContainer ON MovementItemContainer.ContainerID = Container.ID
                                                                      AND MovementItemContainer.OperDate >= inOperDate
                                                                      AND MovementItemContainer.MovementId <> tmpIncomeList.MovementId

                             WHERE Object_PartionMovementItem.ObjectCode IN (SELECT DISTINCT tmpIncomeList.MovementItemId FROM tmpIncomeList)
                               AND Object_PartionMovementItem.DescId = zc_object_PartionMovementItem()
                             GROUP BY tmpIncomeList.MovementId
                                    , tmpIncomeList.MovementItemId 
                                    , tmpIncomeList.Price
                                    , Container.ID
                                    , Container.Amount
                             ),
        tmpContainerRemains AS ( --Остатки по приходу
                             SELECT tmpContainerRemainsAll.MovementId                                            AS MovementId
                                  , SUM(Round(tmpContainerRemainsAll.Price * tmpContainerRemainsAll.Remains, 2)) AS Remains
                             FROM tmpContainerRemainsAll
                             GROUP BY tmpContainerRemainsAll.MovementId
                             )
  
  SELECT tmpIncome.MovementId                   AS MovementId
       , tmpIncome.InvNumber                    AS InvNumber
       , tmpIncome.OperDate                     AS OperDate
       , tmpIncome.FromId                       AS FromId
       , Object_From.ValueData                  AS FromName
       , tmpIncome.JuridicalId                  AS JuridicalId
       , Object_Juridical.ValueData             AS JuridicalName
       , tmpIncome.UnitId                       AS UnitId
       , Object_Unit.ValueData                  AS UnitName
       , tmpIncome.TotalSumm                    AS TotalSumm
       , tmpContainer.Amount::TFloat            AS NoPay
       , tmpContainerRemains.Remains::TFloat    AS Remains
       , (tmpContainer.Amount - tmpContainerRemains.Remains)::TFloat AS ToPay
  FROM tmpIncome
       LEFT JOIN Object AS Object_From ON Object_From.Id = tmpIncome.FromId
       LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpIncome.JuridicalId
       LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpIncome.UnitId
       LEFT JOIN tmpContainer ON tmpContainer.MovementId = tmpIncome.MovementId
       LEFT JOIN tmpContainerRemains ON tmpContainerRemains.MovementId = tmpIncome.MovementId
  ORDER BY tmpIncome.OperDate
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
                              
--select * from gpReport_Income_PartialSale(inOperDate := ('28.12.2020')::TDateTime, inJuridicalId := 13310756 , inFromId := 9526799, inSession := '3');

select * from gpReport_Income_PartialSale(inOperDate := ('15.02.2021')::TDateTime , inJuridicalId := 13310756 , inFromId := 9526799 ,  inSession := '3');