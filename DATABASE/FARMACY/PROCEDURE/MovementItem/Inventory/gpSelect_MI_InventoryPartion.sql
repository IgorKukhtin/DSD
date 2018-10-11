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
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_InventoryPartion());
    --vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
  
        RETURN QUERY
        WITH 
        -- выбираем все MIContainer данного документа
        tmpMIContainer AS (SELECT MIContainer.MovementItemId         AS Id
                                , MIContainer.ContainerId
                                , MIContainer.Amount
                           FROM MovementItemContainer AS MIContainer
                           WHERE MIContainer.MovementId = inMovementId
                             AND MIContainer.DescId = zc_MIContainer_Count() 
                           )
      -- привязываем ссылку на партии
      , tmpCLO AS (SELECT tmpMIContainer.Id
                        , tmpMIContainer.ContainerId
                        , tmpMIContainer.Amount
                        , CLO_MI.ObjectId
                   FROM tmpMIContainer
                        LEFT JOIN ContainerlinkObject AS CLO_MI 
                                                      ON CLO_MI.Containerid = tmpMIContainer.ContainerId
                                                     AND CLO_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()         
                   )
      -- привязываем Object к партии
      , tmpObject AS (SELECT tmpCLO.Id
                           , tmpCLO.Amount
                           , Object_PartionMovementItem.ObjectCode ::Integer
                      FROM tmpCLO
                           LEFT JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = tmpCLO.ObjectId  
                      )
      -- данные по партии / док. приход
      , tmpData AS (SELECT tmpObject.Id
                         , tmpObject.Amount
                         , MI_Income.Id                              AS MIId_Income
                         , MI_Income.ObjectId                        AS GoodsId
                         , Movement_Income.Id                        AS MovementId_Income
                         , Movement_Income.DescId                    AS DescId_MovementIncome
                         , MIFloat_Income_Price.ValueData ::Integer  AS MIId_Price

                         , MovementDesc_Income.ItemName       AS PartionDescName
                         , Movement_Income.InvNumber          AS PartionInvNumber
                         , Movement_Income.OperDate           AS PartionOperDate
       
                    FROM tmpObject
                         LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = tmpObject.ObjectCode
                         LEFT JOIN Movement AS Movement_Income ON Movement_Income.Id = MI_Income.MovementId
                         LEFT JOIN MovementDesc AS MovementDesc_Income ON MovementDesc_Income.Id = Movement_Income.DescId

                         LEFT JOIN MovementItemFloat AS MIFloat_Income_Price
                                                     ON MIFloat_Income_Price.MovementItemId = MI_Income.Id
                                                    AND MIFloat_Income_Price.DescId = zc_MIFloat_MovementItemId()
                    )
       -- данные по партии / док. приход/, документ определяющий цену партии
       , tmpData_All AS (SELECT tmpData.Id
                              , tmpData.Amount
                              , tmpData.GoodsId                
                              , tmpData.MIId_Price
                              , tmpData.PartionDescName
                              , tmpData.PartionInvNumber
                              , tmpData.PartionOperDate

                              , MovementDesc_Price.ItemName        AS PartionPriceDescName
                              , Movement_Price.InvNumber           AS PartionPriceInvNumber
                              , Movement_Price.OperDate            AS PartionPriceOperDate

                         FROM tmpData
                              LEFT JOIN MovementItem AS MI_Price ON MI_Price.Id = tmpData.MIId_Price
                              LEFT JOIN Movement AS Movement_Price 
                                                 ON Movement_Price.Id = CASE WHEN tmpData.DescId_MovementIncome = zc_Movement_Inventory() THEN MI_Price.MovementId ELSE tmpData.MovementId_Income END
                              LEFT JOIN MovementDesc AS MovementDesc_Price ON MovementDesc_Price.Id = Movement_Price.DescId
                         )
           
           -- Результат
           SELECT  tmpData_All.Id
                 , Object_Goods.Id                    AS GoodsId
                 , Object_Goods.ObjectCode            AS GoodsCode
                 , Object_Goods.ValueData             AS GoodsName

                 , tmpData_All.PartionDescName
                 , tmpData_All.PartionInvNumber
                 , tmpData_All.PartionOperDate
                 , tmpData_All.PartionPriceDescName
                 , tmpData_All.PartionPriceInvNumber
                 , tmpData_All.PartionPriceOperDate
                 , MIFloat_JuridicalPrice.ValueData ::TFloat  AS JuridicalPrice

                 , CASE WHEN tmpData_All.Amount >=0 THEN tmpData_All.Amount     ELSE 0 END ::TFloat  AS Amount
                 , CASE WHEN tmpData_All.Amount <0  THEN -1* tmpData_All.Amount ELSE 0 END ::TFloat  AS AmountDeficit
                 , (tmpData_All.Amount * MIFloat_JuridicalPrice.ValueData)                 ::TFloat  AS SummAmount
           
            FROM tmpData_All
               LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice
                                            ON MIFloat_JuridicalPrice.MovementItemId = tmpData_All.MIId_Price
                                           AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()
                
               LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData_All.GoodsId

;            
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.A.   Воробкало А.А.
 24.11.16         *
 15.03.16         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_InventoryPartion (inMovementId:= 1457049, inSession:= '2')