-- Function: gpReport_Sale_PartialSale()

DROP FUNCTION IF EXISTS gpReport_Sale_PartialSale (TDateTime, TDateTime, Integer ,Integer ,TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Sale_PartialSale(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inJuridicalId   Integer ,
    IN inFromId        Integer ,
    IN inSession       TVarChar       -- ������ ������������
)
RETURNS TABLE (Id            Integer
             , InvNumber     TVarChar
             , OperDate      TDateTime
             , FromId        Integer
             , FromName      TVarChar
             , JuridicalId   Integer
             , JuridicalName TVarChar
             , UnitId        Integer
             , UnitName      TVarChar
             , GoodsId       Integer
             , GoodsCode     Integer
             , GoodsName     TVarChar
             , Amount        TFloat
             , Price         TFloat
             , Summ          TFloat
             , PriceSale     TFloat
             , SummSale      TFloat
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
   vbUserId := inSession;

   RETURN QUERY
   WITH
        tmpContract AS ( --�������� � ������� �������
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
        tmpIncomeAll AS ( --������� �� �������
                             SELECT Movement.Id                           AS Id
                             FROM MovementLinkObject AS MovementLinkObject_Contract

                                    INNER JOIN Movement ON MovementLinkObject_Contract.MovementId = Movement.Id

                             WHERE MovementLinkObject_Contract.MovementId > 15000000
                               AND Movement.DescId = zc_Movement_Income()
                               AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                               AND MovementLinkObject_Contract.ObjectId in (SELECT tmpContract.ID FROM tmpContract)
                             ),
        tmpIncome AS ( --������� �� �������
                             SELECT Movement.Id                           AS MovementId
                                  , MovementLinkObject_From.ObjectId      AS FromId
                                  , MovementLinkObject_Juridical.ObjectId AS JuridicalId
                             FROM tmpIncomeAll AS Movement 

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                 ON MovementLinkObject_From.MovementId = Movement.Id
                                                                AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                                 ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                                                AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                             WHERE (MovementLinkObject_Juridical.ObjectId = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
                             ),
        tmpIncomeList AS ( --������� �� �������
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
                             UNION ALL
                             SELECT MovementItem_Income.MovementId  AS MovementId
                                  , MovementItem_Income.Id          AS MovementItemId
                                  , MovementItem_Income.ObjectId    AS GoodsId
                                  , MIFloat_Price.ValueData         AS Price
                                  , MovementItem_Income.Amount      AS AmountInIncome
                                  , 9526799                         AS FromId
                                  , 13310756                        AS JuridicalId
                             FROM MovementItem AS MovementItem_Income

                                    LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                ON MIFloat_Price.MovementItemId = MovementItem_Income.Id
                                                               AND MIFloat_Price.DescId = zc_MIFloat_Price()

                             WHERE MovementItem_Income.MovementId = 28398973
                               AND MovementItem_Income.DescId     = zc_MI_Master()
                               AND MovementItem_Income.isErased   = FALSE
                               AND (13310756 = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
                             ),
        tmpContainerRemainsAll AS ( --������� �� �������
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
        , Object_From.Id                             AS FromId
        , Object_From.ValueData                      AS FromName
        , Object_Juridical.Id                        AS JuridicalId
        , Object_Juridical.ValueData                 AS JuridicalName
        , MovementLinkObject_Unit.ObjectId           AS UnitId
        , Object_Unit.ValueData                      AS UnitName
        , MovementItem.ObjectId                      AS GoodsId
        , Object_Goods.ObjectCode                    AS GoodsCode
        , Object_Goods.ValueData                     AS GoodsName
        , (-1.0 * MovementItemContainer.Amount)::TFloat                               AS Amount
        , tmpIncomeList.Price                        AS Price
        , Round(-1.0 *tmpIncomeList.Price * MovementItemContainer.Amount , 2)::TFloat AS Summa
        , MIFloat_Price.ValueData                    AS PriceSale
        , zfCalc_SummaCheck(COALESCE (-1.0 * MovementItemContainer.Amount, 0) * MIFloat_Price.ValueData
                          , COALESCE (MB_RoundingDown.ValueData, False)
                          , COALESCE (MB_RoundingTo10.ValueData, False)
                          , COALESCE (MB_RoundingTo50.ValueData, False)) AS SummSale
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
        LEFT JOIN MovementBoolean AS MB_RoundingTo50
                                  ON MB_RoundingTo50.MovementId = Movement.Id
                                 AND MB_RoundingTo50.DescId = zc_MovementBoolean_RoundingTo50()

        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

        INNER JOIN MovementItem AS MovementItem ON MovementItem.ID = MovementItemContainer.MovementItemId

        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

        LEFT JOIN MovementItemFloat AS MIFloat_Price
                                    ON MIFloat_Price.MovementItemId = MovementItem.Id
                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()

        LEFT JOIN tmpIncomeList ON tmpIncomeList.MovementItemId = Container.MovementItemId
        
        LEFT JOIN Object AS Object_From ON Object_From.Id = tmpIncomeList.FromId
        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpIncomeList.JuridicalId
   ORDER BY OperDate
  ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 06.11.20                                                       *

*/

-- ����
-- 
                              
select * from gpReport_Sale_PartialSale(inStartDate := ('01.07.2022')::TDateTime , inEndDate := ('31.07.2022')::TDateTime , inJuridicalId := 0 , inFromId := 9526799 ,  inSession := '3');