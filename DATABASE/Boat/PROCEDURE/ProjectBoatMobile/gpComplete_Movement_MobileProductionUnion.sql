-- Function: gpComplete_Movement_MobileProductionUnion()

DROP FUNCTION IF EXISTS gpComplete_Movement_MobileProductionUnion  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_MobileProductionUnion(
    IN inMovementId        Integer               , -- ключ Документа
   OUT outStatusCode       Integer               , 
   OUT outStatusName       TVarChar              ,
    IN inSession           TVarChar                -- сессия пользователя
)                              
RETURNS RECORD
AS
$BODY$
  DECLARE vbUserId        Integer;
  DECLARE vbInvNumberFull TVarChar;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);
    
    WITH tmpMI AS (SELECT MovementItem.Id
                        , MovementItem.ParentId
                        , MovementItem.ObjectId
                        , MovementItem.MovementId
                   FROM Movement AS Movement
                      

                        INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                               AND MovementItem.DescId     = zc_MI_Scan()                                                  
                        LEFT JOIN MovementItem AS MI_Master
                                               ON MI_Master.Id         = MovementItem.ParentId
                                              AND MI_Master.MovementId = MovementItem.MovementId
                                              AND MI_Master.DescId     = zc_MI_Master() 

                        LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                    ON MIFloat_MovementId.MovementItemId = MI_Master.Id
                                                   AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                           
                   WHERE Movement.Id = inMovementId                                                                                 
                  )
       , tmpOrderInternal AS (SELECT MI_Master_OI.Id 
                                   , MI_Master_OI.ObjectId
                                   , MI_Master_OI.MovementId
                              FROM tmpMI AS MovementItem 

                                   INNER JOIN MovementItem AS MI_Master
                                                           ON MI_Master.Id         = MovementItem.ParentId
                                                          AND MI_Master.MovementId = MovementItem.MovementId
                                                          AND MI_Master.DescId     = zc_MI_Master() 
                                                          AND MI_Master.isErased   = FALSE

                                   INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                                ON MIFloat_MovementId.MovementItemId = MI_Master.Id
                                                               AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                                        
                                   INNER JOIN MovementItem AS MI_Master_OI
                                                           ON MI_Master_OI.ObjectId   = MI_Master.ObjectId
                                                          AND MI_Master_OI.DescId     = zc_MI_Master() 
                                                          AND MI_Master_OI.isErased   = FALSE

                                   INNER JOIN MovementItemFloat AS MIFloat_OI
                                                                ON MIFloat_OI.MovementItemId = MI_Master_OI.Id
                                                               AND MIFloat_OI.DescId         = zc_MIFloat_MovementId()
                                                               AND MIFloat_OI.valuedata      = MIFloat_MovementId.valuedata

                                   INNER JOIN Movement AS OI ON OI.Id = MI_Master_OI.MovementId 
                                                            AND OI.descid = zc_Movement_OrderInternal() 
                                                            AND OI.StatusId <> zc_Enum_Status_Erased()
                                                                                                        
                              )
                     
    SELECT zfCalc_InvNumber_isErased ('', PU.InvNumber, PU.OperDate, PU.StatusId) AS InvNumberFull
    INTO vbInvNumberFull
    FROM tmpOrderInternal AS MovementItem 

         INNER JOIN Movement AS OI ON OI.Id = MovementItem.MovementId 
                                  AND OI.descid = zc_Movement_OrderInternal() 
                                  AND OI.StatusId <> zc_Enum_Status_Erased()

         INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                      ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                     AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                    
         INNER JOIN MovementItem AS MI_Master
                                 ON MI_Master.ObjectId   = MovementItem.ObjectId
                                AND MI_Master.DescId = zc_MI_Master() 
                                AND MI_Master.isErased   = FALSE

         INNER JOIN MovementItemFloat AS MIFloat_PU
                                      ON MIFloat_PU.MovementItemId = MI_Master.Id
                                     AND MIFloat_PU.DescId         = zc_MIFloat_MovementId()
                                     AND MIFloat_PU.valuedata      = MIFloat_MovementId.valuedata

         INNER JOIN Movement AS PU ON PU.Id = MI_Master.MovementId 
                                  AND PU.descid = zc_Movement_ProductionUnion() 
                                  AND PU.StatusId <> zc_Enum_Status_Erased()
    LIMIT 1;    
    
    IF COALESCE (vbInvNumberFull, '') <> ''
    THEN
      RAISE EXCEPTION 'Ошибка. По заказу на производство активен документ сборки узла/лодки <%>. Востановить документ нельзя.', vbInvNumberFull;
    END IF;    

    -- проводки
    PERFORM gpComplete_Movement_ProductionUnion (inMovementId -- Документ
                                               , inSession    -- Пользователь  
                                                );
                                                 
    SELECT Object_Status.ObjectCode            AS StatusCode
         , Object_Status.ValueData             AS StatusName
    INTO outStatusCode, outStatusName
    FROM Movement

         LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
         
    WHERE Movement.Id = inMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 25.04.24                                                       *
 */