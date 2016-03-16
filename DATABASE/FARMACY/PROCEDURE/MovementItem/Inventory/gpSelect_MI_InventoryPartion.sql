-- Function: gpSelect_MovementItem_Inventory()

DROP FUNCTION IF EXISTS gpSelect_MI_InventoryPartion (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_InventoryPartion(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , PartionDescName  TVarChar
             , PartionInvNumber TVarChar
             , PartionOperDate  TDateTime
             , PartionPriceDescName  TVarChar
             , PartionPriceInvNumber TVarChar
             , PartionPriceOperDate  TDateTime          
             , JuridicalPrice TFloat
             , Amount         TFloat
             , AmountDeficit  TFloat
             , SummAmount     TFloat
             )
AS
$BODY$
DECLARE
  vbUserId Integer;
  vbObjectId Integer;
  vbUnitId Integer;
  vbOperDate TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Inventory());
    -- inShowAll:= TRUE;
    vbUserId:= lpGetUserBySession (inSession);
    --vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
  
        RETURN QUERY


            SELECT MIContainer.MovementItemId         AS Id
                 , Object_Goods.Id                    AS GoodsId
                 , Object_Goods.ObjectCode            AS GoodsCode
                 , Object_Goods.ValueData             AS GoodsName

                 , MovementDesc_Income.ItemName       AS PartionDescName
                 , Movement_Income.InvNumber          AS PartionInvNumber
                 , Movement_Income.OperDate           AS PartionOperDate
                 , MovementDesc_Price.ItemName        AS PartionPriceDescName
                 , Movement_Price.InvNumber           AS PartionPriceInvNumber
                 , Movement_Price.OperDate            AS PartionPriceOperDate
                 , MIFloat_JuridicalPrice.ValueData ::TFloat  AS JuridicalPrice

                 , CASE WHEN MIContainer.Amount >=0 THEN MIContainer.Amount     ELSE 0 END ::TFloat  AS Amount
                 , CASE WHEN MIContainer.Amount <0  THEN -1* MIContainer.Amount ELSE 0 END ::TFloat  AS AmountDeficit
                 , (MIContainer.Amount * MIFloat_JuridicalPrice.ValueData)                 ::TFloat  AS SummAmount
           
            FROM MovementItemContainer  AS MIContainer
     
                LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem 
                                              ON ContainerLinkObject_MovementItem.Containerid = MIContainer.ContainerId
                                             AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()                               
                LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                LEFT JOIN Movement AS Movement_Income ON Movement_Income.Id = MI_Income.MovementId
                LEFT JOIN MovementDesc AS MovementDesc_Income ON MovementDesc_Income.Id = Movement_Income.DescId

                LEFT JOIN MovementItemFloat AS MIFloat_Income_Price
                                            ON MIFloat_Income_Price.MovementItemId = MI_Income.Id
                                           AND MIFloat_Income_Price.DescId = zc_MIFloat_MovementItemId()
                LEFT JOIN MovementItem AS MI_Price ON MI_Price.Id = MIFloat_Income_Price.ValueData
                LEFT JOIN Movement AS Movement_Price 
                                   ON Movement_Price.Id = CASE WHEN Movement_Income.DescId = zc_Movement_Inventory() THEN MI_Price.MovementId ELSE MI_Income.MovementId END
                LEFT JOIN MovementDesc AS MovementDesc_Price ON MovementDesc_Price.Id = Movement_Price.DescId

                LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice
                                            ON MIFloat_JuridicalPrice.MovementItemId = MI_Price.Id
                                           AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()
                
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MI_Income.ObjectId

            WHERE   MIContainer.MovementId = inMovementId
                --and MIContainer.MovementItemId = 13542442
               AND MIContainer.DescId = zc_MIContainer_Count() 

;            
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.A.   Воробкало А.А.
 15.03.16         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_InventoryPartion (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= TRUE, inSession:= '2')
-- SELECT * FROM gpSelect_MI_InventoryPartion (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
