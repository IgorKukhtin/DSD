-- Function: gpSelect_GoodsNotSalePast()


DROP FUNCTION IF EXISTS gpSelect_GoodsNotSalePast (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsNotSalePast (
    IN inUnitId         Integer ,
    IN inAmountDay      Integer ,
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (UnitID Integer, UnitCode Integer, UnitName TVarChar,
               GoodsId Integer, GoodsCode Integer, GoodsName TVarChar,
               Remains TFloat,
               InvNumber TVarChar, OperDate TDateTime, Amount TFloat, PriceWithVAT TFloat, SumWithVAT TFloat
               )
AS               
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
    WITH tmpContainerAll AS (SELECT Container.ID
                                  , Container.WhereObjectId  AS UnitID
                                  , Container.ObjectId       AS GoodsID   
                                  , Container.Amount
                             FROM Container
                             WHERE Container.DescId = zc_Container_Count()
                               AND (Container.WhereObjectId = inUnitId OR inUnitId = 0)
                               AND Container.Amount > 0
                             )
       , tmpContainer AS (SELECT Container.UnitID         AS UnitID
                               , Container.GoodsID        AS GoodsID   
                               , SUM(Container.Amount)    AS Amount
                               , MAX(COALESCE (MI_Income_find.Id, MI_Income.Id)) AS MI_IncomeId
                          FROM tmpContainerAll as Container
                               LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                             ON ContainerLinkObject_MovementItem.Containerid = Container.Id
                                                            AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                               LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                               -- ������� �������
                               LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                               -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                               LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                           ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                          AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                               -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
                               LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                          GROUP BY Container.UnitID
                                 , Container.GoodsID
                         )
       , tmpMovementItemContainer AS (SELECT MovementItemContainer.WhereObjectId_Analyzer    AS UnitID
                                           , MovementItemContainer.ObjectId_Analyzer         AS GoodsID  
                                           , SUM(MovementItemContainer.Amount)               AS Amount
                                           , SUM(CASE WHEN MovementItemContainer.MovementDescId = zc_Movement_Check() THEN 1 ELSE 0 END) AS Check
                                      FROM MovementItemContainer 
                                      WHERE  (MovementItemContainer.WhereObjectId_Analyzer = inUnitId OR inUnitId = 0)
                                        AND MovementItemContainer.OperDate >= CURRENT_DATE -  (inAmountDay||' DAY')::INTERVAL 
                                      GROUP BY MovementItemContainer.WhereObjectId_Analyzer, MovementItemContainer.ObjectId_Analyzer)
       , tmpRemains AS (SELECT Container.UnitID
                             , Container.GoodsID
                             , Container.Amount      AS Remains
                             , Container.MI_IncomeId AS MI_IncomeId
                        FROM tmpContainer AS Container
                             LEFT JOIN tmpMovementItemContainer AS MovementItemContainer
                                                                ON MovementItemContainer.UnitID = Container.UnitID
                                                               AND MovementItemContainer.GoodsID = Container.GoodsID 
                        WHERE (Container.Amount > COALESCE(MovementItemContainer.Amount, 0)) AND COALESCE(MovementItemContainer.Check, 0) = 0)


    SELECT Object_Unit.ID            AS UnitID
         , Object_Unit.ObjectCode    AS UnitCode
         , Object_Unit.ValueData     AS UnitName
         , Container.GoodsID         AS GoodsId
         , Object_Goods.ObjectCode   AS GoodsCode
         , Object_Goods.ValueData    AS GoodsName
         , Container.Remains::TFloat AS Remains
         
         , MovementIncome.InvNumber
         , MovementIncome.OperDate
         , MovementItemIncome.Amount
         , MIFloat_JuridicalPriceWithVAT.ValueData
         , ROUND(MovementItemIncome.Amount * MIFloat_JuridicalPriceWithVAT.ValueData, 2) ::TFloat AS Price
         
    FROM tmpRemains AS Container

         LEFT JOIN Object AS Object_Unit
                          ON Object_Unit.Id = Container.UnitID

         LEFT JOIN Object AS Object_Goods
                          ON Object_Goods.Id = Container.GoodsID

         LEFT JOIN MovementItem AS MovementItemIncome
                                ON MovementItemIncome.Id = Container.MI_IncomeId
         
         LEFT JOIN Movement AS MovementIncome
                                ON MovementIncome.Id = MovementItemIncome.MovementId

         LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPriceWithVAT
                                     ON MIFloat_JuridicalPriceWithVAT.MovementItemId = MovementItemIncome.Id
                                    AND MIFloat_JuridicalPriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
         ;

END;
$BODY$


LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 19.07.19                                                       *
*/

-- ����
-- SELECT * FROM gpSelect_GoodsNotSalePast(inUnitId :=  375626 , inAmountDay := 100, inSession := '3')