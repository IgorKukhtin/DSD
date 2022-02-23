-- Function: gpSelect_PriceList_AllGoods()

DROP FUNCTION IF EXISTS gpSelect_PriceList_AllGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_PriceList_AllGoods(
    IN inRetailId    Integer      , -- Сеть
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (GoodsId Integer
)
AS
$BODY$
  DECLARE vbMainJuridicalId Integer;
  DECLARE vbAreaId   Integer;
  DECLARE vbCostCredit TFloat;
BEGIN

    RETURN QUERY
    WITH tmpMovementAll AS (SELECT MAX (Movement.OperDate)
                                   OVER (PARTITION BY MovementLinkObject_Juridical.ObjectId
                                                    , COALESCE (MovementLinkObject_Contract.ObjectId, 0)
                                                    , COALESCE (MovementLinkObject_Area.ObjectId, 0)
                                        ) AS Max_Date
                                 , Movement.OperDate                                  AS OperDate
                                 , Movement.Id                                        AS MovementId
                                 , MovementLinkObject_Juridical.ObjectId              AS JuridicalId
                                 , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId
                                 , COALESCE (MovementLinkObject_Area.ObjectId, 0)     AS AreaId
                            FROM Movement
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                              ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                                             AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                              ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                             AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Area
                                                              ON MovementLinkObject_Area.MovementId = Movement.Id
                                                             AND MovementLinkObject_Area.DescId = zc_MovementLinkObject_Area()
                            WHERE Movement.DescId = zc_Movement_PriceList()
                              AND Movement.StatusId = zc_Enum_Status_UnComplete()
                            ),
        tmpLastMovement AS (SELECT PriceList.JuridicalId
                                 , PriceList.ContractId
                                 , PriceList.AreaId
                                 , PriceList.MovementId
                                 , PriceList.OperDate
                            FROM tmpMovementAll AS PriceList
                            
                            WHERE PriceList.Max_Date = PriceList.OperDate)

    SELECT DISTINCT
           Object_Goods_Retail.Id                AS GoodsJuridicalId 
             
    FROM tmpLastMovement AS LastMovement

        INNER JOIN MovementItem ON MovementItem.MovementId = LastMovement.MovementId
                               AND MovementItem.DescId = zc_MI_Master()
                               AND MovementItem.isErased = False
                               
        INNER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.GoodsMainId = MovementItem.ObjectId
                                      AND Object_Goods_Retail.RetailID = inRetailId

        ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 22.02.22                                                       *
*/

-- тест
-- 
SELECT * FROM gpSelect_PriceList_AllGoods (inRetailId := 4, inSession   := '3')        