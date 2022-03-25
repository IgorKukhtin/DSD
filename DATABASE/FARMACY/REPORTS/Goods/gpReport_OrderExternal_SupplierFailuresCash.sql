-- Function: gpReport_OrderExternal_SupplierFailuresCash()

DROP FUNCTION IF EXISTS gpReport_OrderExternal_SupplierFailuresCash (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderExternal_SupplierFailuresCash(
    IN inOperdate    TDateTime    , -- на дату
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsJuridicalCode TVarChar, GoodsJuridicalName TVarChar, GoodsCode Integer, GoodsName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , Amount TFloat
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;
    
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
        tmpJuridicalArea AS (SELECT DISTINCT
                                    tmp.JuridicalId              AS JuridicalId
                                  , tmp.AreaId_Juridical         AS AreaId
                             FROM lpSelect_Object_JuridicalArea_byUnit (vbUnitId , 0) AS tmp
                             ),
        tmpLastMovement AS (SELECT PriceList.JuridicalId
                                 , PriceList.ContractId
                                 , PriceList.AreaId
                                 , PriceList.MovementId
                                 , PriceList.OperDate
                            FROM tmpMovementAll AS PriceList
                            
                                 LEFT JOIN tmpJuridicalArea ON tmpJuridicalArea.JuridicalId = PriceList.JuridicalId
                                                           AND tmpJuridicalArea.AreaId = PriceList.AreaId 
                            WHERE PriceList.Max_Date = PriceList.OperDate
                              AND (COALESCE (vbUnitId, 0) = 0 OR COALESCE(tmpJuridicalArea.AreaId, 0) <> 0)),
        tmpMovementItem AS (SELECT DISTINCT
                                   LastMovement.JuridicalId
                                 , LastMovement.ContractId
                                 , MovementItem.ObjectId                AS GoodsJuridicalId 
                            FROM tmpLastMovement AS LastMovement
                            
                                 INNER JOIN MovementItem ON MovementItem.MovementId = LastMovement.MovementId
                                                        AND MovementItem.DescId = zc_MI_Child()

                                 INNER JOIN MovementItemBoolean AS MIBoolean_SupplierFailures
                                                                ON MIBoolean_SupplierFailures.MovementItemId = MovementItem.Id
                                                               AND MIBoolean_SupplierFailures.DescId         = zc_MIBoolean_SupplierFailures()
                                                               AND MIBoolean_SupplierFailures.ValueData      = True),
        tmpSupplierFailures AS (SELECT MILinkObject_Goods.ObjectId              AS GoodsId
                                     , MovementLinkObject_From.ObjectId         AS JuridicalId
                                     , MovementLinkObject_Contract.ObjectId     AS ContractId
                                     , SUM (MI_OrderExternal.Amount) ::TFloat   AS Amount
                                FROM Movement AS Movement_OrderExternal
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                              ON MovementLinkObject_Unit.MovementId = Movement_OrderExternal.Id
                                                             AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_To()
                                                             AND MovementLinkObject_Unit.ObjectId = vbUnitId
                                     INNER JOIN MovementItem AS MI_OrderExternal
                                                        ON MI_OrderExternal.MovementId = Movement_OrderExternal.Id
                                                       AND MI_OrderExternal.DescId = zc_MI_Master()
                                                       AND MI_OrderExternal.isErased = FALSE
                                     LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                  ON MovementLinkObject_From.MovementId = Movement_OrderExternal.Id
                                                                 AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                  ON MovementLinkObject_Contract.MovementId = Movement_OrderExternal.Id
                                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                     LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                                      ON MILinkObject_Goods.MovementItemId = MI_OrderExternal.Id
                                                                     AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                     LEFT JOIN tmpMovementItem ON tmpMovementItem.GoodsJuridicalId = MILinkObject_Goods.ObjectId
                                                              AND tmpMovementItem.JuridicalId      = MovementLinkObject_From.ObjectId
                                                              AND tmpMovementItem.ContractId       = MovementLinkObject_Contract.ObjectId
                                WHERE Movement_OrderExternal.DescId = zc_Movement_OrderExternal()
                                  AND Movement_OrderExternal.StatusId = zc_Enum_Status_Complete()
                                  AND Movement_OrderExternal.OperDate = inOperdate
                                  AND COALESCE (tmpMovementItem.GoodsJuridicalId, 0) <> 0
                                GROUP BY MILinkObject_Goods.ObjectId
                                       , MovementLinkObject_From.ObjectId
                                       , MovementLinkObject_Contract.ObjectId
                                HAVING SUM (MI_OrderExternal.Amount) <> 0
                               )                              

    SELECT Object_Goods.Id                      AS GoodsJuridicalId
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
        
         , tmpSupplierFailures.Amount            AS Amount
    
    FROM tmpSupplierFailures AS tmpSupplierFailures

        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpSupplierFailures.JuridicalId
        LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = tmpSupplierFailures.ContractId
                                         
        LEFT JOIN Object_Goods_Juridical AS Object_Goods ON Object_Goods.Id = tmpSupplierFailures.GoodsId 
        LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId
    UNION ALL
    SELECT NULL::INTEGER                        AS GoodsJuridicalId
         , NULL::TVarChar                       AS GoodsJuridicalCode
         , NULL::TVarChar                       AS GoodsJuridicalName
        
         , Object_Goods_Main.ObjectCode          AS GoodsCode
         , Object_Goods_Main.Name                AS GoodsName

         , NULL::INTEGER                         AS JuridicalId
         , NULL::INTEGER                         AS JuridicalCode
         , NULL::TVarChar                        AS JuridicalName
        
         , NULL::INTEGER                         AS ContractId
         , NULL::INTEGER                         AS ContractCode
         , NULL::TVarChar                        AS ContractName
        
         , MovementItem.Amount
         
    FROM Movement_OrderExternal_View 
     
         INNER JOIN MovementItem ON MovementItem.MovementId =  Movement_OrderExternal_View.Id

         LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = MovementItem.ObjectId
         LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
         
    WHERE Movement_OrderExternal_View.ToId = vbUnitId
      AND Movement_OrderExternal_View.OperDate = inOperDate
      AND COALESCE(Movement_OrderExternal_View.FromId, 0) = 0
        ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 25.03.22                                                       *
*/

-- тест
-- 
SELECT * FROM gpReport_OrderExternal_SupplierFailuresCash (inOperDate := ('25.03.2022')::TDateTime,  inSession := '3')