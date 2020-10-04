-- Function: gpSelect_MovementItem_Loyalty_GUID()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Loyalty_GUID (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Loyalty_GUID(
    IN inGUID                TVarChar  , --
   OUT outID                 Integer   , -- Ключ объекта <Строка документ>
   OUT outAmount             TFloat    , -- Сумма скидки
   OUT outError              TVarChar  , -- Ошибка
   OUT outMovementId         Integer   , -- Ключ объекта <Документ>
   OUT outisPresent          Boolean   , -- Подарок
   OUT outGoodsId            Integer   , -- Если один товар подарок в наличии
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbRetailId Integer;

   DECLARE vbMovementId Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbisErased Boolean;
   DECLARE vbParentId Integer;
   DECLARE vbOperDate TDateTime;

   DECLARE vbInvNumber Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbDescId Integer;
   DECLARE vbStartSale TDateTime;
   DECLARE vbEndSale TDateTime;
   DECLARE vbIsInsert Boolean;
   DECLARE vbMovementChackId Integer;
   DECLARE vbMonthCount Integer;
   DECLARE vbGoodsCount Integer;
BEGIN

      -- проверка прав пользователя на вызов процедуры
      -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    vbRetailId := (SELECT ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                        INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE ObjectLink_Unit_Juridical.ObjectId = vbUnitId
                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical());

    SELECT MovementItem.ID
         , MovementItem.MovementID
         , MovementItem.Amount
         , MovementItem.isErased
         , MovementItem.ParentId
         , MovementFloat_MovementItemId.MovementId
         , MIDate_OperDate.ValueData
    INTO vbMovementItemId, vbMovementId, vbAmount, vbisErased, vbParentId, vbMovementChackId, vbOperDate
    FROM MovementItem_Loyalty_GUID
         INNER JOIN MovementItem ON MovementItem.ID = MovementItem_Loyalty_GUID.MovementItemID
         LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                                 ON MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                                AND MovementFloat_MovementItemId.ValueData = MovementItem.ID
         LEFT JOIN MovementItemDate AS MIDate_OperDate
                                    ON MIDate_OperDate.MovementItemId = MovementItem.ID
                                   AND MIDate_OperDate.DescId = zc_MIDate_OperDate()
    WHERE MovementItem_Loyalty_GUID.GUID = inGUID;


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

    SELECT Movement.InvNumber::Integer
         , Movement.StatusId
         , Movement.DescId
         , MovementDate_StartSale.ValueData
         , MovementDate_EndSale.ValueData
         , MovementFloat_MonthCount.ValueData::Integer
    INTO vbInvNumber, vbStatusId, vbDescId, vbStartSale, vbEndSale, vbMonthCount
    FROM Movement
         LEFT JOIN MovementDate AS MovementDate_StartSale
                                ON MovementDate_StartSale.MovementId = Movement.Id
                               AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
         LEFT JOIN MovementDate AS MovementDate_EndSale
                                ON MovementDate_EndSale.MovementId = Movement.Id
                               AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
         LEFT JOIN MovementFloat AS MovementFloat_MonthCount
                                 ON MovementFloat_MonthCount.MovementId =  Movement.Id
                                AND MovementFloat_MonthCount.DescId = zc_MovementFloat_MonthCount()
    WHERE Movement.ID = vbMovementId
      AND Movement.DescId in (zc_Movement_Loyalty(), zc_Movement_LoyaltyPresent());

    IF COALESCE(vbParentId, 0) = 0 AND vbDescId = zc_Movement_Loyalty()
    THEN
      outError := 'Ошибка. По промокоду '||COALESCE(inGUID, '')||' нет подтверждения продажи.';
      RETURN;
    END IF;

    -- Если документ неподписан
    IF COALESCE(vbStatusId, 0) <> zc_Enum_Status_Complete()
    THEN
      outError := 'Ошибка. Документ "Программы лояльности" по промокоду '||COALESCE(inGUID, '')||' не найден.';
      RETURN;
    END IF;

    IF COALESCE((SELECT MovementLinkObject_Retail.ObjectId FROM MovementLinkObject AS MovementLinkObject_Retail
                 WHERE MovementLinkObject_Retail.MovementId = vbMovementId
                   AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()), 0) <> COALESCE (vbRetailId, 0)
    THEN
      outError := 'Ошибка. Документ "Программы лояльности" по промокоду '||COALESCE(inGUID, '')||' для другой сети.';
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
       AND EXISTS(SELECT 1 FROM MovementItem AS MI_Loyalty
                  WHERE MI_Loyalty.MovementId = vbMovementId
                    AND MI_Loyalty.DescId = zc_MI_Child()
                    AND MI_Loyalty.isErased = FALSE)
    THEN
      outError := 'Ошибка. "Программы лояльности" по промокоду '||COALESCE(inGUID, '')||' на аптеку не распространяеться.';
      RETURN;
    END IF;

    -- Если просрочен даты
    IF (vbOperDate + (vbMonthCount||' MONTH' )::INTERVAL) < CURRENT_DATE AND COALESCE (vbMonthCount, 0) > 0
    THEN
      outError := 'Ошибка. Срок действия промокода '||COALESCE(inGUID, '')||' закончен.';
      RETURN;
    END IF;

   outID := vbMovementItemId;
   outAmount := CASE WHEN  vbDescId = zc_Movement_Loyalty() THEN vbAmount ELSE 0 end;
   outError := '';
   outMovementId := vbMovementId;
   outisPresent := vbDescId = zc_Movement_LoyaltyPresent();
   outGoodsId := 0;

   if outisPresent = TRUE
   THEN
     WITH tmpLoyaltyPresentList AS (SELECT Object_Goods_Retail.Id               AS GoodsID
                                    FROM MovementItem

                                         INNER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.GoodsMainId = MovementItem.ObjectId
                                                                                              AND Object_Goods_Retail.retailid = vbRetailId

                                    WHERE MovementItem.MovementId = outMovementId
                                                               AND MovementItem.DescId = zc_MI_Master()
                                                               AND MovementItem.Amount = 1
                                                               AND MovementItem.isErased = FALSE)
        , tmpContainer AS (SELECT Container.ObjectId    AS GoodsID
                                , SUM(Container.Amount) AS Amount
                           FROM tmpLoyaltyPresentList
                                INNER JOIN Container ON Container.DescId = zc_Container_Count()
                                                    AND Container.Amount <> 0
                                                    AND Container.ObjectId = tmpLoyaltyPresentList.GoodsID
                                                    AND Container.WhereObjectId = vbUnitId
                           GROUP BY Container.ObjectId
                           HAVING SUM(Container.Amount) >= 1)
                           
     SELECT MIN(tmpContainer.GoodsID), COUNT(*)
     INTO outGoodsId, vbGoodsCount
     FROM tmpContainer;

     IF vbGoodsCount = 0
     THEN
      outError := 'Ошибка. Нет в наличии подарка. Использование промо кода невозможно.';
     ELSEIF vbGoodsCount > 1
     THEN
       outGoodsId := 0; 
     END IF;

   END IF;


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
-- SELECT * FROM gpSelect_MovementItem_Loyalty_GUID ('1119-2300-7A19-8EDC', '3');

select * from gpSelect_MovementItem_Loyalty_GUID(inGUID := '0920-0513-7203-3049' ,  inSession := '3');