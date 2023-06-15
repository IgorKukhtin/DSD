-- Function: gpSetErased_MovementItem_TechnicalRediscount (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_MovementItem_TechnicalRediscount (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_MovementItem_TechnicalRediscount(
    IN inMovementItemId      Integer              , -- ключ объекта <Элемент документа>
   OUT outIsErased           Boolean              , -- новое значение
    IN inSession             TVarChar               -- текущий пользователь
)                              
  RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId      Integer;
   DECLARE vbMovementId  Integer;
   DECLARE vbOperDate    TDateTime;
   DECLARE vbMISendId    Integer;
   DECLARE vbAmount      TFloat;
   DECLARE vbSaldo       TFloat;
   DECLARE vbGoodsId     Integer;
   DECLARE vbUnitId     Integer;
   DECLARE vbDescId      Integer;
BEGIN

  SELECT MovementItem.MovementId, Movement.OperDate, MIFloat_MISendId.ValueData
       , MovementItem.Amount, MovementItem.ObjectId, MovementSend.DescId
       , MovementLinkObject_Unit.ObjectId
  INTO vbMovementId, vbOperDate, vbMISendId, vbAmount, vbGoodsId, vbDescId, vbUnitId
  FROM MovementItem 
       INNER JOIN Movement ON Movement.ID = MovementItem.MovementId
       LEFT JOIN MovementItemFloat AS MIFloat_MISendId
                                   ON MIFloat_MISendId.MovementItemId = MovementItem.Id
                                  AND MIFloat_MISendId.DescId = zc_MIFloat_MovementItemId()
       LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                    ON MovementLinkObject_Unit.MovementId = Movement.Id
                                   AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
       LEFT JOIN MovementItem AS MISend ON MISend.ID = MIFloat_MISendId.ValueData::Integer

       LEFT JOIN Movement AS MovementSend ON MovementSend.ID = MISend.MovementId
  WHERE MovementItem.ID = inMovementItemId;
  
  vbSaldo = COALESCE((SELECT SUM(MovementItem.Amount)
                      FROM MovementItem 
                      WHERE MovementItem.MovementId = vbMovementId
                        AND MovementItem.Id <> inMovementItemId
                        AND MovementItem.ObjectId = vbGoodsId
                        AND MovementItem.isErased = False), 0) - 
            COALESCE((SELECT SUM(Container.Amount)
                      FROM Container
                      WHERE Container.DescId  = zc_Container_Count()
                        AND Container.Amount <> 0
                        AND Container.ObjectId = vbGoodsId
                        AND Container.WhereObjectId = vbUnitId), 0);

  -- проверка прав пользователя на вызов процедуры
/*  IF vbAmount = 0 AND vbMISendId IS NOT NULL
  THEN
    vbUserId:= lpGetUserBySession (inSession);  
  ELSE*/
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_SetErased_MI_TechnicalRediscount());
--  END IF;

  IF COALESCE (inMovementItemId, 0) = 0
  THEN
      RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
  END IF;
  

  IF COALESCE (vbMISendId, 0) <> 0 AND COALESCE (vbAmount, 0) <> 0 AND 
   (vbDescId <> zc_Movement_Check() or vbSaldo >= vbAmount) AND 
   NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
  THEN
    IF vbDescId = zc_Movement_Check()
    THEN
      RAISE EXCEPTION 'Ошибка.Элемент документа создан из заказа таблеток удаление запрещено.';
    ELSE
      RAISE EXCEPTION 'Ошибка.Элемент документа создан из перемещения СУН удаление запрещено.';
    END IF;
  END IF;


/*  IF date_part('DAY',  vbOperDate)::Integer <= 15
  THEN
      vbOperDate := date_trunc('month', vbOperDate) + INTERVAL '14 DAY';
  ELSE
      vbOperDate := date_trunc('month', vbOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY';
  END IF;

  -- Для роли "Кассир" проверяем период
  IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
            WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = zc_Enum_Role_CashierPharmacy())
     AND  vbOperDate < CURRENT_DATE
  THEN
      RAISE EXCEPTION 'Ошибка. По документу технической инвентаризации истек срок корректировки для кассиров аптек.';
  END IF;
*/
  -- устанавливаем новое значение
  outIsErased:= gpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inSession:= inSession);

  -- Пересчитываем суммы
  PERFORM lpUpdate_Movement_TechnicalRediscount_TotalDiff (vbMovementId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSetErased_MovementItem_TechnicalRediscount (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.10.14                                        *
*/

-- тест
-- SELECT * FROM gpSetErased_MovementItem_TechnicalRediscount (inMovementItemId:= 0, inSession:= '2')

select * from gpSetErased_MovementItem_TechnicalRediscount(inMovementItemId := 591658049 ,  inSession := '3');