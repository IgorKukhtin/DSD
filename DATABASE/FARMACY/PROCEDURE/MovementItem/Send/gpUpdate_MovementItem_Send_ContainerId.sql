-- Function: gpUpdate_MovementItem_Send_ContainerId()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Send_ContainerId (Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Send_ContainerId(
     IN inMovementItemId      Integer   , -- Ключ объекта <Элемент документа>
     IN inParentId            Integer   , -- Ключ объекта <Элемент документа>
     IN inContainerID         Integer   , -- Контейнер
     IN inisAddNewLine        Boolean   , -- Создать новую строку
     IN inSession             TVarChar    -- пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbAmount     Integer;
   DECLARE vbAmountUse  Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;

     -- Разрешаем только сотрудникам с правами админа
    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin()))
    THEN
      RAISE EXCEPTION 'Изменение привязки вам запрещено, обратитесь к системному администратору';
    END IF;
    
    

    IF EXISTS (SELECT 1
               FROM MovementItem

                    INNER JOIN MovementItemFloat AS MIFloat_ContainerId
                                                 ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
                                                AND MIFloat_ContainerId.ValueData      = inContainerID

               WHERE MovementItem.ParentId = inParentId
                 AND MovementItem.isErased = True)
    THEN
      UPDATE MovementItem SET isErased = False
      WHERE MovementItem.Id = 
              (SELECT MovementItem.Id
               FROM MovementItem

                    INNER JOIN MovementItemFloat AS MIFloat_ContainerId
                                                 ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
                                                AND MIFloat_ContainerId.ValueData      = inContainerID

               WHERE MovementItem.ParentId = inParentId
                 AND MovementItem.Amount = 0);
    
      RETURN;
    ELSEIF EXISTS (SELECT 1
               FROM MovementItem

                    INNER JOIN MovementItemFloat AS MIFloat_ContainerId
                                                 ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
                                                AND MIFloat_ContainerId.ValueData      = inContainerID

               WHERE MovementItem.ParentId = inParentId
                 AND MovementItem.Amount = 0)
    THEN
      vbAmount := COALESCE((SELECT Container.Amount
                            FROM Container
                            WHERE Container.ID = inContainerID), 0);

      UPDATE MovementItem SET Amount = vbAmount
      WHERE MovementItem.Id = 
              (SELECT MovementItem.Id
               FROM MovementItem

                    INNER JOIN MovementItemFloat AS MIFloat_ContainerId
                                                 ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
                                                AND MIFloat_ContainerId.ValueData      = inContainerID

               WHERE MovementItem.ParentId = inParentId
                 AND MovementItem.Amount = 0);
    
      RETURN;
    ELSEIF EXISTS (SELECT 1
               FROM MovementItem

                    INNER JOIN MovementItemFloat AS MIFloat_ContainerId
                                                 ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
                                                AND MIFloat_ContainerId.ValueData      = inContainerID

               WHERE MovementItem.ParentId = inParentId)
    THEN
      RAISE EXCEPTION 'К указанному контейнеру связь уже есть.';
    END IF;

    IF inisAddNewLine = TRUE
    THEN

      IF COALESCE (inParentId, 0) = 0
      THEN
        RAISE EXCEPTION 'Не заполнеа главная строка докусента.';
      END IF;

      vbAmount := COALESCE((SELECT Container.Amount
                            FROM Container
                            WHERE Container.ID = inContainerID), 0);

      vbAmountUse := COALESCE((SELECT SUM(MovementItem.Amount)
                               FROM MovementItem
                               WHERE MovementItem.ParentId = inParentId), 0);

      PERFORM lpInsertUpdate_MovementItem_Send_Child(ioId                  := 0,
                                                     inParentId            := MovementItem.ID,
                                                     inMovementId          := MovementItem.MovementID  ,
                                                     inGoodsId             := MovementItem.ObjectId,
                                                     inAmount              := CASE WHEN MovementItem.Amount <= vbAmountUse THEN 0
                                                                                   WHEN (MovementItem.Amount - vbAmountUse) > vbAmount THEN vbAmount
                                                                                   ELSE MovementItem.Amount - vbAmountUse END,
                                                     inContainerId         := inContainerID,
                                                     inUserId              := vbUserId
                                                  )
      FROM MovementItem
      WHERE MovementItem.ID = inParentId;
    ELSE

      IF COALESCE (inMovementItemId, 0) = 0
      THEN
        RAISE EXCEPTION 'Изменить привязку к партии можно только на связанные строки.';
      END IF;

      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContainerId(), inMovementItemId, inContainerID);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Шаблий О.В.
  22.09.20                                                       *
*/

-- тест
-- select * from gpUpdate_MovementItem_Send_ContainerId(inMovementItemId := 367430631 , inParentId := 367429823 , inContainerID := 23812831 , inisAddNewLine := False, inSession := '3');

--select * from gpUpdate_MovementItem_Send_ContainerId(inMovementItemId := 0 , inParentId := 400731454 , inContainerID := 23354530 , inisAddNewLine := 'False' ,  inSession := '3');