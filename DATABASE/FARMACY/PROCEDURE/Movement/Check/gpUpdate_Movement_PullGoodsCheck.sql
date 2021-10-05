-- Function: gpUpdate_Movement_PullGoodsCheck()

DROP FUNCTION IF EXISTS gpUpdate_Movement_PullGoodsCheck (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_PullGoodsCheck(
    IN inMovementId        Integer   , -- Ключ объекта <Документ ЧЕК>
    IN inMovementItemId    Integer   , -- Ключ объекта <Содержимое документа ЧЕК>
   OUT outMovementId       Integer   , -- Ключ объекта <Документ ЧЕК>
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbDate TDateTime;
   DECLARE vbInvNumber Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpGetUserBySession (inSession);
    
    IF COALESCE(inMovementId,0) = 0
    THEN
        RAISE EXCEPTION 'Документ не записан.';
    END IF;

    SELECT Movement.StatusId
         , Movement.OperDate
         , MovementLinkObject_Unit.ObjectId
    INTO vbStatusId
       , vbDate
       , vbUnitId
    FROM Movement
         LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE Movement.Id = inMovementId;

    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION 'Ошибка.Разбить чек в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;
    
    SELECT COALESCE(MAX(zfConvert_StringToNumber(InvNumber)), 0) + 1 
    INTO vbInvNumber
    FROM Movement_Check_View 
    WHERE Movement_Check_View.UnitId = vbUnitId 
      AND Movement_Check_View.OperDate >= date_trunc('day',vbDate)
      AND Movement_Check_View.OperDate < date_trunc('day',vbDate) + INTERVAL '1 DAY';

    -- сохранили <Документ>
    outMovementId := lpInsertUpdate_Movement (0, zc_Movement_Check(), vbInvNumber::TVarChar, vbDate, NULL);
   
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), outMovementId, MovementLinkObject_Unit.ObjectId)
          , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ConfirmedKind(), outMovementId, zc_Enum_ConfirmedKind_Complete())
          , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_BuyerForSite(), outMovementId, MovementLinkObject_BuyerForSite.ObjectId)
          , lpInsertUpdate_MovementString (zc_MovementString_Bayer(), outMovementId, MovementString_Bayer.ValueData)
          , lpInsertUpdate_MovementString (zc_MovementString_BayerPhone(), outMovementId, MovementString_BayerPhone.ValueData)
          , lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Deferred(), outMovementId, TRUE)
          , lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_CheckMember(), outMovementId, MovementLinkObject_CheckMember.ObjectId)
    FROM Movement
         LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
	     LEFT JOIN MovementString AS MovementString_Bayer
                                  ON MovementString_Bayer.MovementId = Movement.Id
                                 AND MovementString_Bayer.DescId = zc_MovementString_Bayer()
         LEFT JOIN MovementString AS MovementString_BayerPhone
                                  ON MovementString_BayerPhone.MovementId = Movement.Id
                                 AND MovementString_BayerPhone.DescId = zc_MovementString_BayerPhone()

         LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckMember
                                      ON MovementLinkObject_CheckMember.MovementId = Movement.Id
                                     AND MovementLinkObject_CheckMember.DescId = zc_MovementLinkObject_CheckMember()
         LEFT JOIN MovementLinkObject AS MovementLinkObject_BuyerForSite
                                      ON MovementLinkObject_BuyerForSite.MovementId = Movement.Id
                                     AND MovementLinkObject_BuyerForSite.DescId = zc_MovementLinkObject_BuyerForSite()
    WHERE Movement.Id = inMovementId;    
    
    IF EXISTS (SELECT * FROM MovementString AS MovementString_InvNumberOrder
               WHERE MovementString_InvNumberOrder.MovementId = inMovementId
                 AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder())
    THEN
    
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberOrder(), outMovementId, MovementString_InvNumberOrder.ValueData)
            , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ConfirmedKindClient(), outMovementId, zc_Enum_ConfirmedKind_SmsYes())
      FROM Movement

           LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                    ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                   AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

      WHERE Movement.Id = inMovementId;    
    
    END IF;

    UPDATE MovementItem SET MovementId = outMovementId WHERE MovementItem.ID = inMovementItemId;
    
    PERFORM lpInsertUpdate_MovementFloat_TotalSummCheck (inMovementId);
    PERFORM lpInsertUpdate_MovementFloat_TotalSummCheck (outMovementId);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (outMovementId, vbUserId, True);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. Шаблий О.В.
 21.04.21                                                     * add BuyerForSite
 25.11.19                                                     *
*/
-- тест
-- select * from gpUpdate_Movement_PullGoodsCheck(inMovementId := 22853746 , inMovementItemId := 421643416 ,  inSession := '3');' ,  inSession := '3');