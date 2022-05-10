-- Function: gpUpdate_MI_OrderInternal_SupplierFailures()

DROP FUNCTION IF EXISTS gpUpdate_MI_OrderInternal_SupplierFailures (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_OrderInternal_SupplierFailures(
    IN inMovementId  Integer      , -- ID заказа
    IN inUnitId      Integer      , -- Подразделение
    IN inOperdate    TDateTime    , -- на дату
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbObjectId Integer;
  DECLARE vbStatusId Integer;
BEGIN

    vbUserId := inSession;

    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
        
    -- определяем <Статус>
    vbStatusId := (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inMovementId);
    
    -- проверка - проведенные/удаленные документы Изменять нельзя
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION 'Ошибка.Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;    

    PERFORM  lpInsertUpdate_MI_OrderInternal_SupplierFailures(inId                      := T1.Id
                                                            , inMovementId              := inMovementId
                                                            , inGoodsId                 := T1.GoodsId 
                                                            , inSupplierFailuresAmount  := T1.Amount
                                                            , inUserId                  := vbUserId
                                                            )
    FROM (
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
                             FROM lpSelect_Object_JuridicalArea_byUnit (inUnitId , 0) AS tmp
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
                              AND (COALESCE (inUnitId, 0) = 0 OR COALESCE(tmpJuridicalArea.JuridicalId, 0) <> 0)),
        tmpMovementItem AS (SELECT DISTINCT
                                   LastMovement.JuridicalId
                                 , LastMovement.ContractId
                                 , MovementItem.ObjectId                                   AS GoodsJuridicalId 
                                 , COALESCE(MIDate_Start.ValueData, LastMovement.OperDate) AS DateStart
                            FROM tmpLastMovement AS LastMovement
                            
                                 INNER JOIN MovementItem ON MovementItem.MovementId = LastMovement.MovementId
                                                        AND MovementItem.DescId = zc_MI_Child()

                                 INNER JOIN MovementItemBoolean AS MIBoolean_SupplierFailures
                                                                ON MIBoolean_SupplierFailures.MovementItemId = MovementItem.Id
                                                               AND MIBoolean_SupplierFailures.DescId         = zc_MIBoolean_SupplierFailures()
                                                               AND MIBoolean_SupplierFailures.ValueData      = True
                                 LEFT JOIN MovementItemDate AS MIDate_Start
                                                            ON MIDate_Start.MovementItemId =  MovementItem.Id
                                                           AND MIDate_Start.DescId = zc_MIDate_Start()                                 
                                 ),
        tmpOrderExternal AS (SELECT Movement_OrderExternal.Id
                             FROM Movement AS Movement_OrderExternal
                                  INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                ON MovementLinkObject_Unit.MovementId = Movement_OrderExternal.Id
                                                               AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_To()
                                                               AND MovementLinkObject_Unit.ObjectId = inUnitId
                             WHERE Movement_OrderExternal.DescId = zc_Movement_OrderExternal()
                               AND Movement_OrderExternal.StatusId = zc_Enum_Status_Complete()
                               AND Movement_OrderExternal.OperDate = inOperdate
                               ), 
        tmpProtocolOE AS (SELECT Movement.Id,
                                 MIN(MovementProtocol.OperDate) AS OperDate
                          FROM tmpOrderExternal AS Movement
                               INNER JOIN MovementProtocol ON Movement.Id = MovementProtocol.MovementId
                                                          AND MovementProtocol.ProtocolData ILIKE '%Статус" FieldValue = "Проведен%' 
                          GROUP BY Movement.Id
                          ),
        tmpSupplierFailures AS (SELECT MILinkObject_Goods.ObjectId              AS GoodsId
                                     , MovementLinkObject_From.ObjectId         AS JuridicalId
                                     , MovementLinkObject_Contract.ObjectId     AS ContractId
                                     , SUM (MI_OrderExternal.Amount) ::TFloat   AS Amount
                                FROM tmpOrderExternal AS Movement_OrderExternal
                                     INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                              ON MovementLinkObject_Unit.MovementId = Movement_OrderExternal.Id
                                                             AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_To()
                                                             AND MovementLinkObject_Unit.ObjectId = inUnitId
                                     INNER JOIN tmpProtocolOE ON tmpProtocolOE.ID = Movement_OrderExternal.Id
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
                                WHERE COALESCE (tmpMovementItem.GoodsJuridicalId, 0) <> 0
                                  AND tmpMovementItem.DateStart <= tmpProtocolOE.OperDate 
                                GROUP BY MILinkObject_Goods.ObjectId
                                       , MovementLinkObject_From.ObjectId
                                       , MovementLinkObject_Contract.ObjectId
                                HAVING SUM (MI_OrderExternal.Amount) <> 0
                               ), 
        tmpMI AS (SELECT MovementItem.*
                  FROM MovementItem  
                  WHERE MovementItem.MovementId = inMovementId
                    AND MovementItem.DescId     = zc_MI_Master()
                  ),
        tmpAll AS (SELECT Object_Goods_Retail.Id                AS GoodsId
                        , tmpSupplierFailures.Amount            AS Amount
                    
                   FROM tmpSupplierFailures AS tmpSupplierFailures

                       LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpSupplierFailures.JuridicalId
                       LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = tmpSupplierFailures.ContractId
                                                         
                       LEFT JOIN Object_Goods_Juridical AS Object_Goods ON Object_Goods.Id = tmpSupplierFailures.GoodsId 
                       LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId
                       LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.GoodsMainId = Object_Goods_Main.Id
                                                                           AND Object_Goods_Retail.RetailId = vbObjectId

                   UNION ALL
                   SELECT MovementItem.ObjectId
                        , MovementItem.Amount
                         
                   FROM Movement_OrderExternal_View 
                     
                        INNER JOIN MovementItem ON MovementItem.MovementId =  Movement_OrderExternal_View.Id
                    WHERE Movement_OrderExternal_View.ToId = inUnitId
                      AND Movement_OrderExternal_View.OperDate = inOperDate
                      AND COALESCE(Movement_OrderExternal_View.FromId, 0) = 0),
        tmpAllGroup AS (SELECT tmpAll.GoodsId                AS GoodsId
                             , Max(tmpAll.Amount)::TFloat    AS Amount
                        FROM tmpAll
                        GROUP BY tmpAll.GoodsId
                       )                      
 
    SELECT COALESCE (tmpMI.Id, 0)       AS Id
         , tmpAllGroup.GoodsId          AS GoodsId
         , tmpAllGroup.Amount   AS Amount
    
    FROM tmpAllGroup
        
        LEFT JOIN tmpMI ON tmpMI.ObjectId = tmpAllGroup.GoodsId 

        LEFT JOIN MovementItemFloat AS MIFloat_SupplierFailures     
                                    ON MIFloat_SupplierFailures.MovementItemId    = tmpMI.Id
                                   AND MIFloat_SupplierFailures.DescId = zc_MIFloat_SupplierFailures() 
                                   
    WHERE tmpAllGroup.Amount > COALESCE (MIFloat_SupplierFailures.ValueData, 0)) AS T1
        ;

    -- !!!ВРЕМЕННО для ТЕСТА!!!
    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION 'Тест прошел успешно для <%>', inSession;
    END IF;



END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 03.03.22                                                       *
*/

-- тест
-- SELECT * FROM gpUpdate_MI_OrderInternal_SupplierFailures (inMovementId := 27318608, inUnitId := 183292, inOperDate := ('28.03.2022')::TDateTime, inSession := '3')

select * from gpUpdate_MI_OrderInternal_SupplierFailures(inMovementId := 27758827 , inUnitId := 16001195 , inOperdate := ('09.05.2022')::TDateTime ,  inSession := '3');