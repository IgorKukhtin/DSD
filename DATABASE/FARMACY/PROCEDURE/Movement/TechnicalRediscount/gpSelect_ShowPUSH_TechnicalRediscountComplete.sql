-- Function: gpSelect_ShowPUSH_TechnicalRediscountComplete(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_ShowPUSH_TechnicalRediscountComplete(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ShowPUSH_TechnicalRediscountComplete(
    IN inMovementID   integer,          -- ID инвентаризации
   OUT outShowMessage Boolean,          -- Показыват сообщение
   OUT outPUSHType    Integer,          -- Тип сообщения
   OUT outText        Text,             -- Текст сообщения
    IN inSession      TVarChar          -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbText  Text;
   DECLARE vbOperDate TDateTime;
   DECLARE vbUnitID Integer;
   DECLARE vbMovementID Integer;
   DECLARE vbInvNumber TVarChar;
BEGIN

  outShowMessage := False;

  -- вытягиваем подразделение ...
  SELECT Movement.OperDate
       , MLO_Unit.ObjectId                   AS UnitId
  INTO vbOperDate, vbUnitId
  FROM Movement
       INNER JOIN MovementLinkObject AS MLO_Unit
                                     ON MLO_Unit.MovementId = Movement.Id
                                    AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
  WHERE Movement.Id = inMovementID;

   -- Ищем предыдущее перемещение
  IF EXISTS(SELECT 1
            FROM Movement

                 INNER JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                               ON MovementLinkObject_PartionDateKind.MovementId =  Movement.Id
                                              AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
                                              AND MovementLinkObject_PartionDateKind.ObjectId = zc_Enum_PartionDateKind_0()

                 INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                               ON MovementLinkObject_From.MovementId = Movement.Id
                                              AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                              AND MovementLinkObject_From.ObjectId = vbUnitID

            WHERE Movement.DescId = zc_Movement_Send()
              AND Movement.StatusId = zc_Enum_Status_UnComplete())
  THEN


    SELECT Movement.ID,  Movement.InvNumber
    INTO vbMovementID, vbInvNumber
    FROM Movement

         INNER JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                       ON MovementLinkObject_PartionDateKind.MovementId =  Movement.Id
                                      AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
                                      AND MovementLinkObject_PartionDateKind.ObjectId = zc_Enum_PartionDateKind_0()

         INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                      AND MovementLinkObject_From.ObjectId = vbUnitID

    WHERE Movement.DescId = zc_Movement_Send()
      AND Movement.StatusId = zc_Enum_Status_UnComplete()
    ORDER BY Movement.OperDate DESC
    LIMIT 1;
  
  ELSE
    RETURN;
  END IF;
            
  -- Если не отложено выходим
  IF NOT EXISTS (SELECT MIC.Id FROM MovementItemContainer AS MIC WHERE MIC.Movementid = vbMovementID)
  THEN
    RETURN;
  END IF;
    
  IF EXISTS(SELECT * 
            FROM MovementItem AS MI_TechnicalRediscount
            
                 INNER JOIN MovementItem AS MI_Send
                                         ON MI_Send.MovementId = vbMovementID
                                        AND MI_Send.ObjectId = MI_TechnicalRediscount.ObjectId
                                        AND MI_Send.DescId = zc_MI_Master()
                                        AND MI_Send.Amount > 0
                                        AND MI_Send.isErased = False
              
            WHERE MI_TechnicalRediscount.MovementId = inMovementID
              AND MI_TechnicalRediscount.DescId = zc_MI_Master()
              AND MI_TechnicalRediscount.Amount < 0
              AND MI_TechnicalRediscount.isErased = False)
  THEN

    SELECT 'Проверьте отложенное перемещение на Виртуальный склад Сроки, там есть такой же товар '||CHR(13)||CHR(13)||
           string_agg('<'||Object_Goods.ObjectCode::Text||'> - '||Object_Goods.ValueData, CHR(13))||CHR(13)||CHR(13)||
           'но с худшим сроком.'||CHR(13)||CHR(13)||'Провести ТП?'
    INTO outText
    FROM MovementItem AS MI_TechnicalRediscount
            
         INNER JOIN MovementItem AS MI_Send
                                 ON MI_Send.MovementId = vbMovementID
                                AND MI_Send.ObjectId = MI_TechnicalRediscount.ObjectId
                                AND MI_Send.DescId = zc_MI_Master()
                                AND MI_Send.Amount > 0
                                AND MI_Send.isErased = False
                                
         INNER JOIN Object AS Object_Goods ON Object_Goods.Id = MI_TechnicalRediscount.ObjectId
              
    WHERE MI_TechnicalRediscount.MovementId = inMovementID
      AND MI_TechnicalRediscount.DescId = zc_MI_Master()
      AND MI_TechnicalRediscount.Amount < 0
      AND MI_TechnicalRediscount.isErased = False;

    outShowMessage := True;
    outPUSHType := zc_TypePUSH_Confirmation();
  END IF;


END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 10.05.23                                                       *

*/

-- 
SELECT * FROM gpSelect_ShowPUSH_TechnicalRediscountComplete(31826101  , '3')