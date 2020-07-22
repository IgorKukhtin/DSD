-- Function: gpInsert_MovementItem_Loyalty_PromoCode()

DROP FUNCTION IF EXISTS gpInsert_MovementItem_Loyalty_PromoCode (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MovementItem_Loyalty_PromoCode(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inCount               Integer   , -- Количество
    IN inAmount              TFloat    , -- Сумма
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbId Integer;
   DECLARE vbisElectron Boolean;
   DECLARE vbGUID TVarChar;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbIndex Integer;
BEGIN

      -- проверка прав пользователя на вызов процедуры
      -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
    THEN
      RAISE EXCEPTION 'Генерация промокод вам запрещена, обратитесь к системному администратору';
    END IF;

    SELECT COALESCE(MovementBoolean_Electron.ValueData, FALSE) ::Boolean
    INTO vbisElectron
    FROM Movement
         LEFT JOIN MovementBoolean AS MovementBoolean_Electron
                                   ON MovementBoolean_Electron.MovementId =  Movement.Id
                                  AND MovementBoolean_Electron.DescId = zc_MovementBoolean_Electron()
    WHERE Movement.ID = inMovementId;

    -- Если документ не для сайта то неформируем
    IF vbisElectron <> TRUE
    THEN
      RAISE EXCEPTION 'Генерация промокод разрешена только в программах лояльности для сайта';
    END IF;

    vbIndex := 0;

    -- строим строчку для кросса
    WHILE (vbIndex < inCount) LOOP
      vbIndex := vbIndex + 1;


        -- сохранили <Элемент документа>
        vbId := lpInsertUpdate_MovementItem (0, zc_MI_Sign(), 0, inMovementId, inAmount, NULL, zc_Enum_Process_Auto_PartionClose());

        -- Сформировали промокод
        vbGUID := TO_CHAR(CURRENT_DATE, 'MMYY')||'-';

        vbUnitKey := (random() * 9999)::Integer::TVarChar;
        WHILE LENGTH(vbUnitKey) < 4
        LOOP
          vbUnitKey := '0'||vbUnitKey;
        END LOOP;
        vbGUID := vbGUID||vbUnitKey||'-';

        vbUnitKey := (random() * 9999)::Integer::TVarChar;
        WHILE LENGTH(vbUnitKey) < 4
        LOOP
          vbUnitKey := '0'||vbUnitKey;
        END LOOP;
        vbGUID := vbGUID||vbUnitKey||'-';

        vbUnitKey := (random() * 9999)::Integer::TVarChar;
        WHILE LENGTH(vbUnitKey) < 4
        LOOP
          vbUnitKey := '0'||vbUnitKey;
        END LOOP;
        vbGUID := upper(vbGUID||vbUnitKey);

        -- сохранили свойство <>
        PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GUID(), vbId, vbGUID);
        PERFORM lpInsertUpdate_MovementItem_Loyalty_GUID (vbId, vbGUID, vbUserId);

        -- сохранили свойство <>
        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_OperDate(), vbId, CURRENT_DATE);

        -- сохранили связь с <>
        PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), vbId, vbUserId);
        -- сохранили свойство <>
        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), vbId, CURRENT_TIMESTAMP);

    END LOOP;

/*    IF inSession = '3'
    THEN
      RAISE EXCEPTION 'Ошибка. Прошло % % ...', inAmount, vbGUID;
    END IF;*/

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 22.07.20                                                       *
 */

-- SELECT * FROM gpInsert_MovementItem_Loyalty_PromoCode (19620044 , 1, 20, '3');