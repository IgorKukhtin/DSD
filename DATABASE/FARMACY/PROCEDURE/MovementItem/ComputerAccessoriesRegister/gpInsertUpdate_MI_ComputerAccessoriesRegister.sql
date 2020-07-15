-- Function: gpInsertUpdate_MI_ComputerAccessoriesRegister()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ComputerAccessoriesRegister (Integer, Integer, Integer, TFloat, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ComputerAccessoriesRegister(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inComputerAccessoriesId Integer   , -- Компьютерный аксессуар
    IN inAmount                TFloat    , -- Количество
    IN inReplacementDate       TDateTime , -- Дата замены 
    IN inComment               TVarChar  , -- Комментарий
    IN inSession               TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbUnitId     Integer;
   DECLARE vbInvNumber  TVarChar;
BEGIN
    -- проверка прав пользователя на вызов процедуры
   vbUserId := inSession;

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
     RAISE EXCEPTION 'Разрешено только системному администратору';
   END IF;

    --определяем данные документа
    SELECT MovementLinkObject_Unit.ObjectId                             AS UnitId, Movement.InvNumber
    INTO vbUnitId, vbInvNumber 
    FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE Movement.Id = inMovementId;

/*    IF COALESCE (inAmount, 0) <> 1
    THEN
        RAISE EXCEPTION 'Ошибка.Количество должно быть 1.';    
    END IF;
*/
     -- сохранили
    ioId := lpInsertUpdate_MI_ComputerAccessoriesRegister (ioId                    := ioId
                                                      , inMovementId               := inMovementId
                                                      , inComputerAccessoriesId    := inComputerAccessoriesId
                                                      , inAmount                   := inAmount
                                                      , inReplacementDate          := inReplacementDate
                                                      , inComment                  := inComment
                                                      , inUserId                   := vbUserId
                                                       );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_MI_ComputerAccessoriesRegister (Integer, Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 14.07.20                                                                      *
*/

-- тест
-- select * from gpInsertUpdate_MI_ComputerAccessoriesRegister(ioId := 0 , inMovementId := 19386934 , inGoodsId := 427 , inAmount := 10 , inNewExpirationDate := ('22.07.2020')::TDateTime , inContainerId := 20253754 ,  inSession := '3');
