-- Function: gpSelect_PriceList_SupplierFailures()

--DROP FUNCTION IF EXISTS gpSelect_PriceList_SupplierFailures (TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_PriceList_SupplierFailures (TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_PriceList_SupplierFailures(
    IN inOperdate    TDateTime    , -- íà äàòó
    IN inShowAll     Boolean      , --
    IN inSession     TVarChar       -- ñåññèÿ ïîëüçîâàòåëÿ
)
RETURNS TABLE (Id Integer
             , GoodsJuridicalId Integer, GoodsJuridicalCode TVarChar, GoodsJuridicalName TVarChar, GoodsCode Integer, GoodsName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , AreaId Integer, AreaCode Integer, AreaName TVarChar
             , isSupplierFailures   Boolean
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
                            
                            WHERE PriceList.Max_Date = PriceList.OperDate)

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
        ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.   Øàáëèé Î.Â.
 22.02.22                                                       *
*/

-- òåñò
-- 
SELECT * FROM gpSelect_PriceList_SupplierFailures (inOperDate := ('23.02.2022')::TDateTime,  inShowAll := FALSE, inSession   := '3')