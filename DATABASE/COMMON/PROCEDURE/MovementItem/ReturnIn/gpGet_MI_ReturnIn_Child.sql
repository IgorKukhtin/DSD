-- Function: gpGet_MI_ReturnIn_Child()

DROP FUNCTION IF EXISTS gpGet_MI_ReturnIn_Child (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_ReturnIn_Child(
    IN inMovementId      Integer      , -- ключ Документа  
    IN inId_master       Integer      , -- строка док  Мастер - откуда показать товар
    IN inId_Child        Integer      , -- строка док  Чайлд - для проверки   isCalculated - Строка с автозаполнением
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS TABLE (FromId Integer, FromName TVarChar
             , GoodsId Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , Amount TFloat, Price TFloat
             , MovementId_sale Integer, InvNumber_sale TVarChar
             --, isCalculated Boolean
              )
AS
$BODY$
    DECLARE vbUserId     Integer;
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
     
    -- РЕЗУЛЬТАТ
    RETURN QUERY
  SELECT Object_From.Id                                    AS FromId
         , Object_From.ValueData                           AS FromName
         , Object_Goods.Id                                 AS GoodsId
         , Object_Goods.ValueData                          AS GoodsName
         , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)   AS GoodsKindId
         , Object_GoodsKind.ValueData                      AS GoodsKindName
         , COALESCE (MovementItem.Amount,MI_Master.Amount)::TFloat AS Amount
         , MIFloat_Price.ValueData                        ::TFloat AS Price
         , MIFloat_MovementId.ValueData         :: Integer AS MovementId_sale
         , zfCalc_PartionMovementName (Movement_sale.DescId, MovementDesc_sale.ItemName, Movement_sale.InvNumber, COALESCE (MovementDate_OperDatePartner.ValueData, Movement_sale.OperDate) )::TVarChar AS InvNumber_sale
    FROM Movement
         LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
         LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId 

         LEFT JOIN MovementItem ON MovementItem.Id = inId_Child 
         LEFT JOIN MovementItem AS MI_Master ON MI_Master.Id = inId_master
         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = CASE WHEN COALESCE (inId_Child,0) <> 0 THEN MovementItem.ObjectId ELSE MI_Master.ObjectId END

         LEFT JOIN MovementItemFloat AS MIFloat_Price
                                     ON MIFloat_Price.MovementItemId = CASE WHEN COALESCE (inId_Child,0) <> 0 THEN inId_Child ELSE inId_master END
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
       
         LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                ON MovementDate_OperDatePartner.MovementId = Movement_sale.Id
                               AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

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

-- SELECT * FROM gpSelect_MovementItemChild_ReturnIn (inMovementId:= 3662505 ::Integer , inisErased := 'False'::Boolean , inSession := '5'::TVarChar);
