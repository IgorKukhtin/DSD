--DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Income_AmountManual(Integer, Integer, TFloat, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Income_AmountManual(Integer, Integer, Integer, TFloat, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Income_AmountManual(Integer, Integer, Integer, TFloat, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Income_AmountManual(
    IN inMovementId          Integer   , -- документ
 INOUT ioMovementItemId      Integer   , -- строка документа
    IN inGoodsId             Integer   , -- строка документа
    IN inAmountManual        TFloat    , -- Кол-во ручное
    IN inReasonDifferences   Integer   , -- Причина разногласия
    IN inAccommodationName   TVarChar  , -- Код прив.
   OUT outAmountDiff         TFloat    , -- Причина разногласия
   OUT outColor_AmountManual Integer   , -- Цвет ечейки
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Record AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbInvNumber TVarChar;
   DECLARE vbAmountOld TFloat;
   DECLARE vbOperDate TDateTime;
   DECLARE vbDescId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbFromId Integer;
   DECLARE vbToId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
     vbUserId := lpGetUserBySession (inSession);

    -- определяется
    SELECT
        StatusId
      , InvNumber
      , OperDate
      , vbDescId
      , vbAccessKeyId
      , MovementLinkObject_From.ObjectId      AS FromId
      , MovementLinkObject_To.ObjectId      AS ToId
    INTO
        vbStatusId
      , vbInvNumber
      , vbOperDate
      , vbDescId
      , vbAccessKeyId
      , vbFromId
      , vbToId
    FROM Movement
         LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
         LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                      ON MovementLinkObject_To.MovementId = Movement.Id
                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
    WHERE Id = inMovementId;

    -- !!!НОВАЯ СХЕМА ПРОВЕРКИ - Закрытый период!!!
--    PERFORM lpCheckPeriodClose (inUserId        := vbUserId
--                              , inMovementId    := inMovementId);
    --
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION 'Ошибка. Изменение документа № <%> в статусе <%> не возможно.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
    END IF;
    
    
    IF COALESCE(vbFromId, 0) = 722768 AND vbUserId = 4127945 
    THEN
       -- сохранили <Элемент документа>
       ioMovementItemId := lpInsertUpdate_MovementItem (ioMovementItemId, zc_MI_Master(), inGoodsId, inMovementId, inAmountManual, NULL);
    
       -- пересчитали Итоговые суммы
       PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

    ELSEIF COALESCE(ioMovementItemId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. Позиция не сохранена.';
    END IF;

    -- Сохраним предыдущее количество для проведения
    IF EXISTS(SELECT ValueData FROM MovementItemFloat WHERE DescId = zc_MIFloat_AmountManual()
                                                        AND MovementItemId = ioMovementItemId)
    THEN
      SELECT ValueData
      INTO vbAmountOld
      FROM MovementItemFloat
      WHERE DescId = zc_MIFloat_AmountManual()
        AND MovementItemId = ioMovementItemId;
    ELSE
      vbAmountOld := 0;
    END IF;

    -- Проверяем на уменьшение количества
/*    IF vbAmountOld > inAmountManual and
      NOT EXISTS (SELECT 1
             FROM ObjectLink AS Object_UserRole_User -- Связь пользователя с объектом роли пользователя
                      JOIN ObjectLink AS Object_UserRole_Role -- Связь ролей с объектом роли пользователя
                                      ON Object_UserRole_Role.DescId = zc_ObjectLink_UserRole_Role()
                                     AND Object_UserRole_Role.ObjectId = Object_UserRole_User.ObjectId
                                     AND Object_UserRole_Role.ChildObjectId = zc_Enum_Role_Admin()
             WHERE Object_UserRole_User.DescId = zc_ObjectLink_UserRole_User()
               AND Object_UserRole_User.ChildObjectId = vbUserId) AND
      NOT EXISTS (SELECT 1
                 FROM ObjectLink AS Object_UserRole_User -- Связь пользователя с объектом роли пользователя
                      JOIN ObjectLink AS Object_UserRole_Role -- Связь ролей с объектом роли пользователя
                                      ON Object_UserRole_Role.DescId = zc_ObjectLink_UserRole_Role()
                                     AND Object_UserRole_Role.ObjectId = Object_UserRole_User.ObjectId
                      JOIN ObjectLink AS RoleRight_Role -- Связь роли с объектом процессы ролей
                                      ON RoleRight_Role.ChildObjectId = Object_UserRole_Role.ChildObjectId
                                     AND RoleRight_Role.DescId = zc_ObjectLink_RoleRight_Role()
                      JOIN ObjectLink AS RoleRight_Process -- Связь процесса с объектом процессы ролей
                                      ON RoleRight_Process.ObjectId = RoleRight_Role.ObjectId
                                     AND RoleRight_Process.DescId = zc_ObjectLink_RoleRight_Process()
                                     AND RoleRight_Process.ChildObjectId =  zc_Enum_Process_SetErased_MI_Income()
                 WHERE Object_UserRole_User.DescId = zc_ObjectLink_UserRole_User()
                   AND Object_UserRole_User.ChildObjectId = vbUserId)
    THEN
        RAISE EXCEPTION 'Ошибка. Уменьшать количество запрещено.';
    END IF; */

    -- Отменяем проведение если уменьшаеться количество
    IF vbAmountOld > COALESCE (inAmountManual, 0) AND vbAmountOld > 0 AND
      EXISTS(SELECT ValueData FROM MovementItemBoolean WHERE DescId = zc_MIBoolean_Conduct()
                                                        AND MovementItemId = ioMovementItemId
                                                        AND ValueData = TRUE)
    THEN
      PERFORM lpUnConduct_MovementItem_Income (inMovementId, ioMovementItemId, vbUserId);
    END IF;

    -- Сохранили <кол-во ручное>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountManual(), ioMovementItemId, inAmountManual);

    outAmountDiff := COALESCE(inAmountManual,0) - coalesce((Select Amount from MovementItem Where Id = ioMovementItemId),0);

/*    IF outAmountDiff = 0
    THEN
        inReasonDifferences := 0;
    END IF;*/
    
    
    -- Сохранили <Сохранили код размещения>
    PERFORM gpUpdate_AccommodationUnit(inGoodsId, vbToId, inAccommodationName, inSession);

    -- Сохранили <причину разногласия>
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReasonDifferences(), ioMovementItemId, inReasonDifferences);

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioMovementItemId, vbUserId, FALSE);

    -- Перепровели с введенным количеством
/*    IF vbAmountOld <> COALESCE (inAmountManual, 0) AND COALESCE (inAmountManual, 0) > 0
    THEN
      PERFORM lpConduct_MovementItem_Income (inMovementId, ioMovementItemId, inSession);
    END IF; */


    IF EXISTS(SELECT 1 FROM MovementItemBoolean WHERE MovementItemBoolean.DescId = zc_MIBoolean_Conduct()
                                                  AND MovementItemBoolean.MovementItemId = ioMovementItemId
                                                  AND MovementItemBoolean.ValueData = TRUE)
    THEN
      outColor_AmountManual := zc_Color_Greenl();
    ELSE
      outColor_AmountManual := zc_Color_White();
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.   Шаблий О.В.
 03.07.08
 17.11.15                                                                       *
*/


--select * from gpUpdate_MovementItem_Income_AmountManual(ioMovementId := 22076213 , ioMovementItemId := 0 , inAmountManual := 1 , inReasonDifferences := 0 ,  inSession := '4127945');
