DROP FUNCTION IF EXISTS gpSelect_PriceList_GoodsDate (TDateTime, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_PriceList_GoodsDate(
    IN inOperdate    TDateTime    , -- на дату
    IN inGoodsId     Integer      , -- Товар поставщика
    IN inUnitId      Integer      , -- Подразделение
    IN inJuridicalId Integer      , -- Поставщик
    IN inContractId  Integer      , -- Договор
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, OperDate TDateTime
             , GoodsJuridicalId Integer, GoodsJuridicalCode TVarChar, GoodsJuridicalName TVarChar, GoodsCode Integer, GoodsName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , AreaId Integer, AreaCode Integer, AreaName TVarChar
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
                                 , Movement.Id                                        AS Id
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
                              AND MovementLinkObject_Juridical.ObjectId = inJuridicalId
                              AND COALESCE (MovementLinkObject_Contract.ObjectId, 0) = inContractId
                              AND COALESCE (MovementLinkObject_Area.ObjectId, 0) IN 
                                     (SELECT DISTINCT tmp.AreaId_Juridical         AS AreaId
                                      FROM lpSelect_Object_JuridicalArea_byUnit (inUnitId , 0) AS tmp
                                      WHERE tmp.JuridicalId = inJuridicalId
                                      )
                              AND Movement.OperDate <= inOperdate
                            ),
        tmpLastMovement AS (SELECT PriceList.JuridicalId
                                 , PriceList.ContractId
                                 , PriceList.AreaId
                                 , PriceList.Id
                                 , PriceList.OperDate
                            FROM tmpMovementAll AS PriceList
                            
                            WHERE PriceList.Max_Date = PriceList.OperDate)

    SELECT LastMovement.Id                      AS Id 
         , LastMovement.OperDate                AS OperDate

         , MovementItem.ObjectId                AS GoodsJuridicalId 
         , Object_Goods.Code                    AS GoodsJuridicalCode
         , Object_Goods.Name                    AS GoodsJuridicalName
        
         , Object_Goods_Main.ObjectCode          AS GoodsCode
         , Object_Goods_Main.Name                AS GoodsName

         , Object_Juridical.Id                   AS JuridicalId
         , Object_Juridical.ObjectCode           AS JuridicalCode
         , Object_Juridical.ValueData            AS JuridicalName
        
         , Object_Contract.Id                    AS ContractId
         , Object_Contract.ObjectCode            AS ContractCode
         , Object_Contract.ValueData             AS ContractName
        
         , Object_Area.Id                        AS AreaId
         , Object_Area.ObjectCode                AS AreaCode
         , Object_Area.ValueData                 AS AreaName
    
    FROM tmpLastMovement AS LastMovement

        INNER JOIN MovementItem ON MovementItem.MovementId = LastMovement.Id
                               AND MovementItem.DescId = zc_MI_Master()

        INNER JOIN MovementItemLinkObject AS MILinkObject_Goods
                                          ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                         AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                         AND MILinkObject_Goods.ObjectId = inGoodsId

        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = LastMovement.JuridicalId
        LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = LastMovement.ContractId
        LEFT JOIN Object AS Object_Area ON Object_Area.Id = LastMovement.AreaId

        LEFT JOIN Object_Goods_Juridical AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId 
        LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId

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
SELECT * FROM gpSelect_PriceList_GoodsDate (inOperDate := ('03.01.2022')::TDateTime,  inGoodsId := 177023, inUnitId := 3457773, inJuridicalId := 59610, inContractId := 183257, inSession := '3')