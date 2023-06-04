-- Function: gpSelect_Calculation_PartialSale()

DROP FUNCTION IF EXISTS gpSelect_Calculation_PartialSale (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Calculation_PartialSale(
    IN inOperDate    TDateTime,     -- �� ����
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (JuridicalId      Integer
             , JuridicalName    TVarChar
             , FromId           Integer
             , FromName         TVarChar
             , Summa            TFloat
             , SummaNoPay       TFloat
             , SummaRemains     TFloat
             , SummaRemainsInv  TFloat
             , SummaPartialSale TFloat
             , DateStart        TDateTime
             , DateEnd          TDateTime
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
   vbUserId := inSession;

   IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpContainer'))
   THEN
     DROP TABLE tmpContainer;
   END IF;
   
   CREATE TEMP TABLE tmpContainer ON COMMIT DROP AS (
      SELECT Object_Movement.ObjectCode AS MovementId, Container.Amount, Container.KeyValue
      FROM Container
           LEFT JOIN Object AS Object_Movement ON Object_Movement.Id = Container.ObjectId
                                              AND Object_Movement.DescId = zc_Object_PartionMovement()
      WHERE Container.DescId = zc_Container_SummIncomeMovementPayment()
        AND Object_Movement.ObjectCode > 15000000);
                              
   ANALYSE tmpContainer;
   
   RETURN QUERY
   WITH tmpContainerPartialPay AS
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
        tmpIncome AS ( --������� �� �������
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
        tmpIncomeList AS ( --������� �� �������
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
        tmpContainerRemainsAll AS ( --������� �� �������
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
        tmpContainerRemains AS ( --������� �� �������
                             SELECT tmpContainerRemainsAll.MovementItemId         AS MovementItemId
                                  , SUM(tmpContainerRemainsAll.Remains)           AS Remains
                             FROM tmpContainerRemainsAll
                             GROUP BY tmpContainerRemainsAll.MovementItemId
                             ),
        tmpIncomeRemains AS (SELECT tmpIncomeList.MovementId, Sum(Round(tmpIncomeList.Price * tmpContainerRemains.Remains, 2)) AS  SummaRemains
                             FROM tmpIncomeList

                                  LEFT JOIN tmpContainerRemains ON tmpContainerRemains.MovementItemId = tmpIncomeList.MovementItemId
                             GROUP BY tmpIncomeList.MovementId),

        tmpContainerAll AS ( --������� �� �������
                             SELECT Object_PartionMovementItem.ObjectCode                             AS MovementItemId
                                  , ContainerLinkObject_MovementItem.ContainerId
                             FROM Object AS Object_PartionMovementItem

                                  INNER JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                                 ON ContainerLinkObject_MovementItem.ObjectId = Object_PartionMovementItem.Id
                                                                AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()

                             WHERE Object_PartionMovementItem.ObjectCode IN (SELECT DISTINCT tmpIncomeList.MovementItemId FROM tmpIncomeList)
                               AND Object_PartionMovementItem.DescId = zc_object_PartionMovementItem()
                             GROUP BY ContainerLinkObject_MovementItem.ContainerId, Object_PartionMovementItem.ObjectCode
                             ),

        tmpContainerInv AS ( --������ �� ��������������
                             SELECT tmpContainerRemainsAll.MovementItemId
                                  , CLI_MI.ContainerId
                                  , Container.Amount
                             FROM tmpContainerAll AS tmpContainerRemainsAll

                                  INNER JOIN MovementItemFloat AS MIFloat_MovementItem 
                                                               ON MIFloat_MovementItem.ValueData = tmpContainerRemainsAll.MovementItemId
                                                              AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()

                                  INNER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.ObjectCode = MIFloat_MovementItem.MovementItemId
                                                                                 AND Object_PartionMovementItem.DescId = zc_Object_PartionMovementItem()

                                  INNER JOIN ContainerLinkObject AS CLI_MI
                                                                 ON CLI_MI.ObjectId = Object_PartionMovementItem.Id
                                                                AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()

                                  INNER JOIN Container ON Container.ID = CLI_MI.ContainerId
                                                      AND Container.DescId = zc_Container_Count()
                                                      AND Container.Amount <> 0

                             GROUP BY tmpContainerRemainsAll.MovementItemId, CLI_MI.ContainerId, Container.Amount
                             ),
        tmpContainerRemainsInvAll AS ( --������� �� �������
                                     SELECT tmpContainerInv.MovementItemId
                                          , tmpContainerInv.ContainerID
                                          , tmpContainerInv.Amount - COALESCE(SUM(MovementItemContainer.Amount), 0) AS Remains
                                     FROM tmpContainerInv

                                          /*INNER JOIN Container ON Container.ID = tmpContainerInv.ContainerId
                                                              AND Container.DescId = zc_Container_Count()
                                                              AND Container.Amount <> 0*/

                                          LEFT JOIN MovementItemContainer ON MovementItemContainer.ContainerID = tmpContainerInv.ContainerID
                                                                         AND MovementItemContainer.OperDate >= inOperDate

                                     GROUP BY tmpContainerInv.MovementItemId, tmpContainerInv.ContainerID, tmpContainerInv.Amount
                                     ),
        tmpContainerRemainsInv AS ( --������� �� �������
                                   SELECT tmpContainerRemainsInvAll.MovementItemId         AS MovementItemId
                                        , SUM(tmpContainerRemainsInvAll.Remains)           AS Remains
                                   FROM tmpContainerRemainsInvAll
                                   GROUP BY tmpContainerRemainsInvAll.MovementItemId
                                   ),                                   
        tmpIncomeRemainsInv AS (SELECT tmpIncomeList.MovementId, Sum(Round(tmpIncomeList.Price * tmpContainerRemainsInv.Remains, 2)) AS  SummaRemains
                             FROM tmpIncomeList

                                  LEFT JOIN tmpContainerRemainsInv ON tmpContainerRemainsInv.MovementItemId = tmpIncomeList.MovementItemId
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
         tmpNoPay AS (SELECT tmpIncome.JuridicalId, tmpIncome.FromId
                           , SUM(tmpContainerPartialPay.Amount - COALESCE(tmpIncomeRemains.SummaRemains, 0) - 
                                                              COALESCE(tmpIncomeRemainsInv.SummaRemains, 0)) AS Summa
                           , SUM(tmpContainerPartialPay.Amount)                                              AS SummaNoPay
                           , COALESCE(SUM(tmpIncomeRemains.SummaRemains), 0)                                 AS SummaRemains
                           , COALESCE(SUM(tmpIncomeRemainsInv.SummaRemains), 0)                              AS SummaRemainsInv
                      FROM tmpContainerPartialPay

                           INNER JOIN tmpIncomeRemains ON tmpIncomeRemains.MovementId = tmpContainerPartialPay.MovementId

                           INNER JOIN tmpIncome ON tmpIncome.MovementId = tmpContainerPartialPay.MovementId

                           LEFT JOIN tmpIncomeRemainsInv ON tmpIncomeRemainsInv.MovementId = tmpContainerPartialPay.MovementId

                      GROUP BY tmpIncome.JuridicalId, tmpIncome.FromId)

   SELECT tmpNoPay.JuridicalId
        , Object_Juridical.ValueData                 AS JuridicalName
        , tmpNoPay.FromId
        , Object_From.ValueData                      AS FromName
        , (tmpNoPay.Summa - COALESCE(tmpPartialSale.Amount, 0))::TFloat AS Summa
        , tmpNoPay.SummaNoPay::TFloat                                   AS SummaNoPay
        , tmpNoPay.SummaRemains::TFloat                                 AS SummaRemains
        , tmpNoPay.SummaRemainsInv::TFloat                              AS SummaRemainsInv
        , tmpPartialSale.Amount::TFloat                                 AS SummaPartialSale
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
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.      ������ �.�.
 05.11.20                                                          *

*/

-- ����
-- 
SELECT * FROM gpSelect_Calculation_PartialSale (inOperDate := CURRENT_DATE + INTERVAL '10 day', inSession:= '3')
where FromId = 9526799
                              