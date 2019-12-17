-- Function: gpInsertUpdate_MovementItem_Send_Child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send_Child (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Send_Child(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inAmount              TFloat    , -- Количество
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbUnitId Integer;
   DECLARE vbFromId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbUserUnitId Integer;
   
   DECLARE vbParentId Integer; 
   DECLARE vbGoodsId Integer;
   DECLARE vbContainerId Integer;   
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
    vbUserId := inSession;
    
    IF COALESCE (ioId, 0) < 0
    THEN
       RAISE EXCEPTION 'Ошибка. Строки по перемещению товаров без продаж 100 дней редактировать нельзя.';
    END IF;

    IF COALESCE (ioId, 0) = 0
    THEN
       RAISE EXCEPTION 'Ошибка. Редактировать можно реальные сроки, виртуальные для отображения!';
    END IF;

    --определяем подразделение получателя
    SELECT MovementLinkObject_To.ObjectId AS UnitId
    INTO vbUnitId
    FROM MovementLinkObject AS MovementLinkObject_To
    WHERE MovementLinkObject_To.MovementId = inMovementId
      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To();
      
    -- Получаем предыдущее значение количеств
    SELECT
           MovementItem.ParentId
         , MovementItem.ObjectId
         , MIFloat_ContainerId.ValueData::Integer
    INTO vbParentId, vbGoodsId, vbContainerId
    FROM MovementItem
         LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                     ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                    AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId() 
    WHERE MovementItem.Id = ioId;
      

    -- Для роли "Безнал" отключаем проверки
    IF NOT EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
              WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = zc_Enum_Role_Cashless())
    THEN
      -- Для роли "Кассир аптеки"
      IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
                WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = zc_Enum_Role_CashierPharmacy())
      THEN
        vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
        IF vbUnitKey = '' THEN
          vbUnitKey := '0';
        END IF;
        vbUserUnitId := vbUnitKey::Integer;

        IF COALESCE (vbUserUnitId, 0) = 0
        THEN
          RAISE EXCEPTION 'Ошибка. Не найдено подразделение сотрудника.';
        END IF;

        --определяем подразделение отправителя
        SELECT MovementLinkObject_From.ObjectId AS vbFromId
               INTO vbFromId
        FROM MovementLinkObject AS MovementLinkObject_From
        WHERE MovementLinkObject_From.MovementId = inMovementId
          AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From();

        IF COALESCE (vbFromId, 0) <> COALESCE (vbUserUnitId, 0) AND COALESCE (vbUnitId, 0) <> COALESCE (vbUserUnitId, 0)
        THEN
          RAISE EXCEPTION 'Ошибка. Вам разрешено работать только с подразделением <%>.', (SELECT ValueData FROM Object WHERE ID = vbUserUnitId);
        END IF;
      END IF;
    END IF;

     -- сохранили
    ioId := lpInsertUpdate_MovementItem_Send_Child (ioId          := ioId
                                                  , inParentId    := vbParentId  
                                                  , inMovementId  := inMovementId
                                                  , inGoodsId     := vbGoodsId
                                                  , inAmount      := inAmount
                                                  , inContainerId := vbContainerId
                                                  , inUserId      := vbUserId
                                                   );
                                                   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_MovementItem_Send_Child (Integer, Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 07.08.19                                                                      *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Send_Child (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')