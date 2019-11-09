-- Function: gpSelect_MovementItem_Loyalty_GUID()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Loyalty_GUID (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Loyalty_GUID(
    IN inGUID                TVarChar  , --
   OUT outID                 Integer   , -- Ключ объекта <Документ>
   OUT outAmount             TFloat    , -- Сумма скидки
   OUT outError              TVarChar  , -- Ошибка
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;

   DECLARE vbMovementId Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbisErased Boolean;
   DECLARE vbParentId Integer;

   DECLARE vbInvNumber Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbStartSale TDateTime;
   DECLARE vbEndSale TDateTime;
   DECLARE vbIsInsert Boolean;
   DECLARE vbMovementChackId Integer;
BEGIN

      -- проверка прав пользователя на вызов процедуры
      -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;


    SELECT MovementItem.ID, MovementItem.MovementID, MovementItem.Amount, MovementItem.isErased, MovementItem.ParentId, MovementFloat_MovementItemId.MovementId
    INTO vbMovementItemId, vbMovementId, vbAmount, vbisErased, vbParentId, vbMovementChackId
    FROM MovementItemString
         INNER JOIN MovementItem ON MovementItem.ID = MovementItemString.MovementItemID
         LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                                 ON MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()         
                                AND MovementFloat_MovementItemId.ValueData = MovementItem.ID
    WHERE MovementItemString.DescId = zc_MIString_GUID()
      AND MovementItemString.ValueData = inGUID;
      
    IF COALESCE(vbMovementChackId, 0) <> 0
    THEN
      outError := 'Ошибка. Продажа по промокоду '||COALESCE(inGUID, '')||' уже произведена.';
      RETURN;
    END IF;

    IF COALESCE(vbMovementItemId, 0) = 0
    THEN
      outError := 'Ошибка. Промокод '||COALESCE(inGUID, '')||' не найден.';
      RETURN;
    END IF;

    IF vbisErased = TRUE
    THEN
      outError := 'Ошибка. Промокод '||COALESCE(inGUID, '')||' удален.';
      RETURN;
    END IF;

    IF COALESCE(vbParentId, 0) = 0
    THEN
      outError := 'Ошибка. По промокоду '||COALESCE(inGUID, '')||' нет подтверждения продажи.';
      RETURN;
    END IF;

    SELECT Movement.InvNumber::Integer, Movement.StatusId, MovementDate_StartSale.ValueData, MovementDate_EndSale.ValueData
    INTO vbInvNumber, vbStatusId, vbStartSale, vbEndSale
    FROM Movement
         LEFT JOIN MovementDate AS MovementDate_StartSale
                                ON MovementDate_StartSale.MovementId = Movement.Id
                               AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
         LEFT JOIN MovementDate AS MovementDate_EndSale
                                ON MovementDate_EndSale.MovementId = Movement.Id
                               AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
    WHERE Movement.ID = vbMovementId;

    -- Если документ неподписан
    IF COALESCE(vbStatusId, 0) <> zc_Enum_Status_Complete()
    THEN
      outError := 'Ошибка. Документ "Программы лояльности" по промокоду '||COALESCE(inGUID, '')||' не найден.';
      RETURN;
    END IF;

    -- Если неподходят даты
    IF vbStartSale > CURRENT_DATE OR vbEndSale < CURRENT_DATE
    THEN
      outError := 'Ошибка. Срок действия "Программы лояльности" по промокоду '||COALESCE(inGUID, '')||' закончен.';
      RETURN;
    END IF;

    -- Если аптека невходит
    IF NOT EXISTS(SELECT 1 FROM MovementItem AS MI_Loyalty
                  WHERE MI_Loyalty.MovementId = vbMovementId
                    AND MI_Loyalty.DescId = zc_MI_Child()
                    AND MI_Loyalty.isErased = FALSE
                    AND MI_Loyalty.ObjectId = vbUnitId)
    THEN
      outError := 'Ошибка. "Программы лояльности" по промокоду '||COALESCE(inGUID, '')||' на аптеку не распространяеться.';
      RETURN;
    END IF;

   outID := vbMovementItemId;
   outAmount := vbAmount;
   outError := '';


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 08.11.19                                                       *
 */

-- zfCalc_FromHex

-- SELECT * FROM gpSelect_MovementItem_Loyalty_GUID ('1119-A887-001F-A46F', '3');
-- SELECT * FROM gpSelect_MovementItem_Loyalty_GUID ('1119-B800-E1DB-F51E', '3');