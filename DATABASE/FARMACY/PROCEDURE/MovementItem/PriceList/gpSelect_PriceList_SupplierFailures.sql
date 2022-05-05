-- Function: gpSelect_PriceList_SupplierFailures()

--DROP FUNCTION IF EXISTS gpSelect_PriceList_SupplierFailures (TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_PriceList_SupplierFailures (TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_PriceList_SupplierFailures(
    IN inOperdate    TDateTime    , -- на дату
    IN inShowAll     Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsJuridicalId Integer, GoodsJuridicalCode TVarChar, GoodsJuridicalName TVarChar, GoodsCode Integer, GoodsName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , AreaId Integer, AreaCode Integer, AreaName TVarChar
             , isSupplierFailures   Boolean
             , DateStart            TDateTime
             , DateUpdate           TDateTime
             , UserUpdate           TVarChar
             , OperDate             TDateTime
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
                              AND Movement.OperDate <= inOperdate
                            ),
        tmpLastMovement AS (SELECT PriceList.JuridicalId
                                 , PriceList.ContractId
                                 , PriceList.AreaId
                                 , PriceList.MovementId
                                 , PriceList.OperDate
                            FROM tmpMovementAll AS PriceList
                            
                            WHERE PriceList.Max_Date = PriceList.OperDate),
        tmpOrderExternal AS (SELECT Movement_OrderExternal_View.Id
                                  , Movement_OrderExternal_View.OperDate
                             FROM Movement_OrderExternal_View 
     
                             WHERE Movement_OrderExternal_View.OperDate = inOperDate
                               AND COALESCE(Movement_OrderExternal_View.FromId, 0) = 0),
        tmpProtocolOE AS (SELECT Movement.Id,
                                 Min(MovementProtocol.OperDate) AS OperDate
                          FROM tmpOrderExternal AS Movement
                               INNER JOIN MovementProtocol ON Movement.Id = MovementProtocol.MovementId
                          GROUP BY Movement.Id
                          )
                               

    SELECT MovementItem.Id                      AS Id 
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

         , COALESCE(MIBoolean_SupplierFailures.ValueData, False) AS isSupplierFailures
         
         , MIDate_Start.ValueData               AS DateStart
         , MIDate_Update.ValueData              AS DateUpdate
         , Object_Update.ValueData              AS UserUpdate

         , LastMovement.OperDate                AS OperDate
    
    FROM tmpLastMovement AS LastMovement

        INNER JOIN MovementItem ON MovementItem.MovementId = LastMovement.MovementId
                               AND MovementItem.DescId = zc_MI_Child()

        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = LastMovement.JuridicalId
        LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = LastMovement.ContractId
        LEFT JOIN Object AS Object_Area ON Object_Area.Id = LastMovement.AreaId

        LEFT JOIN MovementItemBoolean AS MIBoolean_SupplierFailures
                                      ON MIBoolean_SupplierFailures.MovementItemId = MovementItem.Id
                                     AND MIBoolean_SupplierFailures.DescId = zc_MIBoolean_SupplierFailures()
                                         
        LEFT JOIN MovementItemDate AS MIDate_Start
                                   ON MIDate_Start.MovementItemId =  MovementItem.Id
                                  AND MIDate_Start.DescId = zc_MIDate_Start()

        LEFT JOIN MovementItemDate AS MIDate_Update
                                   ON MIDate_Update.MovementItemId =  MovementItem.Id
                                  AND MIDate_Update.DescId = zc_MIDate_Update()

        LEFT JOIN MovementItemLinkObject AS MILinkObject_Update
                                         ON MILinkObject_Update.MovementItemId = MovementItem.Id
                                        AND MILinkObject_Update.DescId = zc_MILinkObject_Update()
        LEFT JOIN Object AS Object_Update ON Object_Update.Id = MILinkObject_Update.ObjectId

        LEFT JOIN Object_Goods_Juridical AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId 
        LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId
   WHERE COALESCE(MIBoolean_SupplierFailures.ValueData, False) = True OR inShowAll = TRUE
    UNION ALL
    SELECT Max(Movement_OrderExternal_View.Id)::Integer
         , NULL::INTEGER                        AS GoodsJuridicalId
         , NULL::TVarChar                       AS GoodsJuridicalCode
         , NULL::TVarChar                       AS GoodsJuridicalName
        
         , Object_Goods_Main.ObjectCode          AS GoodsCode
         , Object_Goods_Main.Name                AS GoodsName

         , NULL::INTEGER                         AS JuridicalId
         , NULL::INTEGER                         AS JuridicalCode
         , 'Дефектура рынка'::TVarChar           AS JuridicalName
        
         , NULL::INTEGER                         AS ContractId
         , NULL::INTEGER                         AS ContractCode
         , NULL::TVarChar                        AS ContractName
        
         , NULL::INTEGER                         AS AreaId
         , NULL::INTEGER                         AS AreaCode
         , NULL::TVarChar                        AS AreaName

         , False                                 AS isSupplierFailures

         , COALESCE(MIN(tmpProtocolOE.OperDate), inOperdate)::TDateTime AS DateStart

         , NULL::TDateTime                       AS DateUpdate
         , NULL::TVarChar                        AS UserUpdate
         , NULL::TDateTime                       AS OperDate
         
    FROM tmpOrderExternal AS Movement_OrderExternal_View 
     
         INNER JOIN MovementItem ON MovementItem.MovementId =  Movement_OrderExternal_View.Id

         LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = MovementItem.ObjectId
         LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
         
         LEFT JOIN tmpProtocolOE ON tmpProtocolOE.Id = Movement_OrderExternal_View.Id
         
    GROUP BY Object_Goods_Main.ObjectCode
           , Object_Goods_Main.Name       
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
select * from gpSelect_PriceList_SupplierFailures(inOperdate := ('25.03.2022')::TDateTime , inShowAll := 'True' ,  inSession := '3');