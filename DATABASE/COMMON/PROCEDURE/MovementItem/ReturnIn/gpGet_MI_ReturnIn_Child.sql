-- Function: gpGet_MI_ReturnIn_Child()

DROP FUNCTION IF EXISTS gpGet_MI_ReturnIn_Child (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_ReturnIn_Child(
    IN inMovementId      Integer      , -- ключ Документа  
    IN inId_master       Integer      , -- строка док  Мастер - откуда показать товар
    IN inId_Child        Integer      , -- строка док  Чайлд - для проверки   isCalculated - Строка с автозаполнением
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS TABLE (FromId Integer, FromName TVarChar
             , JuridicalId_From Integer, JuridicalName_From TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractId Integer, ContractName TVarChar
             , StartDateTax TDateTime
             , OperDatePartner TDateTime
             , GoodsId Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , Amount TFloat, Price TFloat
             , MovementId_sale Integer, InvNumber_sale TVarChar
             --, isCalculated Boolean
              )
AS
$BODY$
    DECLARE vbUserId  Integer;
            vbAmount  TFloat;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Sale());
    vbUserId:= lpGetUserBySession (inSession);

    --проверка
    IF COALESCE (inId_Child, 0) <> 0 
       AND TRUE = COALESCE ( (SELECT MIBoolean_Calculated.ValueData
                              FROM MovementItemBoolean AS MIBoolean_Calculated
                              WHERE MIBoolean_Calculated.MovementItemId = inId_Child
                                AND MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()
                              ), FALSE)
    THEN 
         RAISE EXCEPTION 'Ошибка.Строка с автозаполнением, ручной режим не возможен.';
    END IF;
    
    --итого по чайлдам тек мастера
    vbAmount:= (SELECT SUM (COALESCE (MovementItem.Amount,0)) AS Amount
                FROM MovementItem
                WHERE MovementItem.ParentId = inId_master
                  AND MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId = zc_MI_Child() 
                  AND MovementItem.isErased = FALSE
                );

    -- РЕЗУЛЬТАТ
    RETURN QUERY

    SELECT Object_From.Id                                  AS FromId
         , Object_From.ValueData                           AS FromName
         , Object_JuridicalFrom.id                         AS JuridicalId_From
         , Object_JuridicalFrom.ValueData                  AS JuridicalName_From
         , Object_PaidKind.Id                	           AS PaidKindId
         , Object_PaidKind.ValueData         	           AS PaidKindName
         , Object_Contract.Id                              AS ContractId
         , Object_Contract.ValueData                       AS ContractName
         , (DATE_TRUNC ('MONTH', MovementDate_OperDatePartner.ValueData) - INTERVAL '4 MONTH') ::TDateTime AS StartDateTax
         , MovementDate_OperDatePartner.ValueData                                              ::TDateTime AS OperDatePartner
           
         , Object_Goods.Id                                 AS GoodsId
         , Object_Goods.ValueData                          AS GoodsName
         , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)   AS GoodsKindId
         , Object_GoodsKind.ValueData                      AS GoodsKindName
         , CASE WHEN COALESCE (inId_Child,0) = 0 THEN (COALESCE (MI_Master.Amount) - COALESCE (vbAmount,0)) ELSE MovementItem.Amount END ::TFloat AS Amount
         , MIFloat_Price.ValueData                        ::TFloat AS Price
         , MIFloat_MovementId.ValueData         :: Integer AS MovementId_sale
         , zfCalc_PartionMovementName (Movement_sale.DescId, MovementDesc_sale.ItemName, Movement_sale.InvNumber, COALESCE (MovementDate_OperDatePartner_sale.ValueData, Movement_sale.OperDate) )::TVarChar AS InvNumber_sale
    FROM Movement
         LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
         LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId 

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                              ON ObjectLink_Partner_Juridical.ObjectId = Object_From.Id
                             AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
         LEFT JOIN Object AS Object_JuridicalFrom ON Object_JuridicalFrom.Id = ObjectLink_Partner_Juridical.ChildObjectId

         LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                      ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                     AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
         LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

         LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                      ON MovementLinkObject_Contract.MovementId = Movement.Id
                                     AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
         LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

         LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                ON MovementDate_OperDatePartner.MovementId = Movement.Id
                               AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

         LEFT JOIN MovementItem ON MovementItem.Id = inId_Child 
         LEFT JOIN MovementItem AS MI_Master ON MI_Master.Id = inId_master
         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = CASE WHEN COALESCE (inId_Child,0) <> 0 THEN MovementItem.ObjectId ELSE MI_Master.ObjectId END

         LEFT JOIN MovementItemFloat AS MIFloat_Price
                                     ON MIFloat_Price.MovementItemId = inId_master
                                    AND MIFloat_Price.DescId = zc_MIFloat_Price()
         LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                          ON MILinkObject_GoodsKind.MovementItemId = inId_master
                                         AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
         LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId     

         LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                     ON MIFloat_MovementId.MovementItemId = inId_Child
                                    AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()  
         LEFT JOIN Movement AS Movement_sale ON Movement_sale.id = MIFloat_MovementId.ValueData :: Integer          
         LEFT JOIN MovementDesc AS MovementDesc_sale ON MovementDesc_sale.Id = Movement_sale.DescId
       
         LEFT JOIN MovementDate AS MovementDate_OperDatePartner_sale
                                ON MovementDate_OperDatePartner_sale.MovementId = Movement_sale.Id
                               AND MovementDate_OperDatePartner_sale.DescId = zc_MovementDate_OperDatePartner()

    WHERE Movement.Id = inMovementId
    ;
                     
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.06.25         *
*/

-- select * from gpGet_MI_ReturnIn_Child(inMovementId := 31551958 , inId_master := 328135567 , inId_Child := 0 ,  inSession := '9457');