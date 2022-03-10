-- Function: gpReport_OrderExternal_JuridicalItog()

DROP FUNCTION IF EXISTS gpReport_OrderExternal_JuridicalItog (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderExternal_JuridicalItog(
    IN inOperDate    TDateTime    , -- на дату
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (/*Id Integer, InvNumber TVarChar, OperDate TDateTime
             , UnitId Integer, UnitCode Integer, UnitName TVarChar*/
               JuridicalMainId Integer, JuridicalMainCode Integer, JuridicalMainName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , Amount TFloat, Summ TFloat, SummWithNDS TFloat
             , AmountSF TFloat, SummSF TFloat, SummWithNDSSF TFloat
             , AmountLeft TFloat, SummLeft TFloat, SummWithNDSLeft TFloat
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
        tmpJuridicalArea AS (SELECT DISTINCT
                                    tmp.UnitId                   AS UnitId
                                  , tmp.JuridicalId              AS JuridicalId
                                  , tmp.AreaId_Juridical         AS AreaId
                             FROM lpSelect_Object_JuridicalArea_byUnit (0 , 0) AS tmp
                             ),
        tmpLastMovement AS (SELECT PriceList.JuridicalId
                                 , PriceList.ContractId
                                 , PriceList.AreaId
                                 , PriceList.MovementId
                                 , PriceList.OperDate
                            FROM tmpMovementAll AS PriceList
                            
                            WHERE PriceList.Max_Date = PriceList.OperDate),
        tmpMovementItemAll AS (SELECT DISTINCT
                                   LastMovement.JuridicalId
                                 , LastMovement.ContractId
                                 , LastMovement.AreaId
                                 , MovementItem.ObjectId                AS GoodsJuridicalId 
                            FROM tmpLastMovement AS LastMovement
                            
                                 INNER JOIN MovementItem ON MovementItem.MovementId = LastMovement.MovementId
                                                        AND MovementItem.DescId = zc_MI_Child()

                                 INNER JOIN MovementItemBoolean AS MIBoolean_SupplierFailures
                                                                ON MIBoolean_SupplierFailures.MovementItemId = MovementItem.Id
                                                               AND MIBoolean_SupplierFailures.DescId         = zc_MIBoolean_SupplierFailures()
                                                               AND MIBoolean_SupplierFailures.ValueData      = True), 
        tmpMovementItem AS (SELECT tmpJuridicalArea.UnitId
                                 , LastMovement.JuridicalId
                                 , LastMovement.ContractId
                                 , LastMovement.GoodsJuridicalId
                            FROM tmpMovementItemAll AS LastMovement
                            
                                 INNER JOIN tmpJuridicalArea ON tmpJuridicalArea.JuridicalId    = LastMovement.JuridicalId
                                                            AND tmpJuridicalArea.AreaId         = LastMovement.AreaId
                            GROUP BY tmpJuridicalArea.UnitId
                                 , LastMovement.JuridicalId
                                 , LastMovement.ContractId
                                 , LastMovement.GoodsJuridicalId), 
        tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                            , ObjectFloat_NDSKind_NDS.ValueData
                       FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                       WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                       ),
        tmpMovementOrderExternal AS (SELECT Movement_OrderExternal.*
                                          , MovementLinkObject_Unit.ObjectId         AS UnitId
                                          , MovementLinkObject_From.ObjectId         AS JuridicalId
                                          , MovementLinkObject_Contract.ObjectId     AS ContractId
                                     FROM Movement AS Movement_OrderExternal
                                          INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                   ON MovementLinkObject_Unit.MovementId = Movement_OrderExternal.Id
                                                                  AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_To()
                                          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                       ON MovementLinkObject_From.MovementId = Movement_OrderExternal.Id
                                                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                       ON MovementLinkObject_Contract.MovementId = Movement_OrderExternal.Id
                                                                      AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                     WHERE Movement_OrderExternal.DescId = zc_Movement_OrderExternal()
                                       AND Movement_OrderExternal.StatusId = zc_Enum_Status_Complete()
                                       AND Movement_OrderExternal.OperDate = inOperdate
                                     ),
        tmpOrderExternal AS (SELECT Movement_OrderExternal.*
                                  , MI_OrderExternal.Id                      AS MovementItemId
                                  , MI_OrderExternal.ObjectId                AS ObjectId
                                  , MI_OrderExternal.Amount                  AS Amount
                                  , CASE WHEN COALESCE(tmpMovementItem.UnitId, 0) <> 0 THEN MI_OrderExternal.Amount END AS AmountSF
                             FROM tmpMovementOrderExternal AS Movement_OrderExternal
                                  INNER JOIN MovementItem AS MI_OrderExternal
                                                          ON MI_OrderExternal.MovementId = Movement_OrderExternal.Id
                                                         AND MI_OrderExternal.DescId = zc_MI_Master()
                                                         AND MI_OrderExternal.isErased = FALSE
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                                   ON MILinkObject_Goods.MovementItemId = MI_OrderExternal.Id
                                                                  AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                  LEFT JOIN tmpMovementItem ON tmpMovementItem.GoodsJuridicalId = MILinkObject_Goods.ObjectId
                                                           AND tmpMovementItem.UnitId           = Movement_OrderExternal.UnitId 
                                                           AND tmpMovementItem.JuridicalId      = Movement_OrderExternal.JuridicalId
                                                           AND tmpMovementItem.ContractId       = Movement_OrderExternal.ContractId
                             ),                              
        tmpOrderExternalSum AS (SELECT Movement_OrderExternal.*
                                     , MIFloat_Price.ValueData                  AS Price
                                     , Round(Movement_OrderExternal.Amount * MIFloat_Price.ValueData, 2)   AS Summ
                                     , Round(Movement_OrderExternal.Amount * MIFloat_Price.ValueData * 
                                       (100 + COALESCE(ObjectFloat_NDSKind_NDS.ValueData, 0)) / 100, 2)    AS SummWithNDS
                                     , Round(Movement_OrderExternal.AmountSF * MIFloat_Price.ValueData, 2) AS SummSF
                                     , Round(Movement_OrderExternal.AmountSF * MIFloat_Price.ValueData * 
                                       (100 + COALESCE(ObjectFloat_NDSKind_NDS.ValueData, 0)) / 100, 2)    AS SummWithNDSSF
                                     , Movement_OrderExternal.Amount - COALESCE (Movement_OrderExternal.AmountSF, 0) AS  AmountLeft
                                     , Round((Movement_OrderExternal.Amount - COALESCE (Movement_OrderExternal.AmountSF, 0)) * MIFloat_Price.ValueData, 2)   AS SummLeft
                                     , Round((Movement_OrderExternal.Amount - COALESCE (Movement_OrderExternal.AmountSF, 0)) * MIFloat_Price.ValueData * 
                                       (100 + COALESCE(ObjectFloat_NDSKind_NDS.ValueData, 0)) / 100, 2)    AS SummWithNDSLeft
                                FROM tmpOrderExternal AS Movement_OrderExternal

                                     LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                                 ON MIFloat_Price.MovementItemId = Movement_OrderExternal.MovementItemId
                                                                AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                                     
                                     LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = Movement_OrderExternal.ObjectId 
                                     LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

                                     LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                                          ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods_Main.NDSKindId
                               )                              

    SELECT /*tmpSupplierFailures.Id                AS Id
         , tmpSupplierFailures.InvNumber         AS InvNumber
         , tmpSupplierFailures.OperDate          AS OperDate
        
         , Object_Unit.Id                        AS UnitId
         , Object_Unit.ObjectCode                AS UnitCode
         , Object_Unit.ValueData                 AS UnitName*/
        
           Object_JuridicalMain.Id               AS JuridicalMainId
         , Object_JuridicalMain.ObjectCode       AS JuridicalMainCode
         , Object_JuridicalMain.ValueData        AS JuridicalMainName
        
         , Object_Juridical.Id                   AS JuridicalId
         , Object_Juridical.ObjectCode           AS JuridicalCode
         , Object_Juridical.ValueData            AS JuridicalName

         , Object_Contract.Id                    AS ContractId
         , Object_Contract.ObjectCode            AS ContractCode
         , Object_Contract.ValueData             AS ContractName
        
         , SUM(tmpSupplierFailures.Amount)::TFloat  AS Amount
         , SUM(tmpSupplierFailures.Summ)::TFloat    AS Summ
         , SUM(tmpSupplierFailures.SummWithNDS)::TFloat    AS SummWithNDS
    
         , SUM(tmpSupplierFailures.AmountSF)::TFloat  AS AmountSF
         , SUM(tmpSupplierFailures.SummSF)::TFloat    AS SummSF
         , SUM(tmpSupplierFailures.SummWithNDSSF)::TFloat    AS SummWithNDSSF

         , SUM(tmpSupplierFailures.AmountLeft)::TFloat  AS AmountLeft
         , SUM(tmpSupplierFailures.SummLeft)::TFloat    AS SummLeft
         , SUM(tmpSupplierFailures.SummWithNDSLeft)::TFloat    AS SummWithNDSLeft

    FROM tmpOrderExternalSum AS tmpSupplierFailures

        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpSupplierFailures.UnitId
        LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                             ON ObjectLink_Unit_Juridical.ObjectId = tmpSupplierFailures.UnitId
                            AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
        LEFT JOIN Object AS Object_JuridicalMain ON Object_JuridicalMain.ID = ObjectLink_Unit_Juridical.ChildObjectId
        
        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpSupplierFailures.JuridicalId
        LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = tmpSupplierFailures.ContractId
                                                 
    GROUP BY /*tmpSupplierFailures.Id
           , tmpSupplierFailures.InvNumber
           , tmpSupplierFailures.OperDate
          
           , Object_Unit.Id
           , Object_Unit.ObjectCode
           , Object_Unit.ValueData*/
           
             Object_JuridicalMain.Id
           , Object_JuridicalMain.ObjectCode
           , Object_JuridicalMain.ValueData           
          
           , Object_Juridical.Id
           , Object_Juridical.ObjectCode
           , Object_Juridical.ValueData
          
           , Object_Contract.Id
           , Object_Contract.ObjectCode
           , Object_Contract.ValueData        
    ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 09.03.22                                                       *
*/

-- тест
-- 

select * from gpReport_OrderExternal_JuridicalItog(inOperdate := ('04.03.2022')::TDateTime ,  inSession := '3');