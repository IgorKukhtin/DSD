DROP FUNCTION IF EXISTS gpSetErased_Movement_Check (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_Check(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbOperDate TDateTime;
  DECLARE vbCashRegisterId Integer;
  DECLARE vbFiscalCheckNumber TVarChar;
  DECLARE vbJackdawsChecksId Integer;
  DECLARE vbInvNumberOrder TVarChar;
  DECLARE vbCheckSourceKindId Integer;
  DECLARE vbisDiscountCommit Boolean;
BEGIN
    --Если документ уже проведен то проверим права
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
              WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = zc_Enum_Role_CashierPharmacy()) -- Для роли "Кассир аптеки"
    THEN

      SELECT 
        Movement.OperDate,
        COALESCE(MovementLinkObject_CashRegister.ObjectId, 0),
        COALESCE(MovementString_FiscalCheckNumber.ValueData, ''),
        COALESCE(MovementLinkObject_JackdawsChecks.ObjectId, 0),
        COALESCE (MovementString_InvNumberOrder.ValueData, ''),
        COALESCE (MovementLinkObject_CheckSourceKind.ObjectId, 0), 
        COALESCE(MovementBoolean_DiscountCommit.ValueData, False) 
      INTO
        vbOperDate,
        vbCashRegisterId,
        vbFiscalCheckNumber,
        vbJackdawsChecksId,
        vbInvNumberOrder,
        vbCheckSourceKindId,
        vbisDiscountCommit
      FROM Movement 
           LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                        ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                       AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
           LEFT JOIN MovementLinkObject AS MovementLinkObject_JackdawsChecks
                                        ON MovementLinkObject_JackdawsChecks.MovementId =  Movement.Id
                                       AND MovementLinkObject_JackdawsChecks.DescId = zc_MovementLinkObject_JackdawsChecks()
           LEFT JOIN MovementString AS MovementString_FiscalCheckNumber
                                    ON MovementString_FiscalCheckNumber.MovementId = Movement.Id
                                   AND MovementString_FiscalCheckNumber.DescId = zc_MovementString_FiscalCheckNumber()
           LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckSourceKind
                                        ON MovementLinkObject_CheckSourceKind.MovementId =  Movement.Id
                                       AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind()
           LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                    ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                   AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
           LEFT JOIN MovementBoolean AS MovementBoolean_DiscountCommit
                                     ON MovementBoolean_DiscountCommit.MovementId = Movement.Id
                                    AND MovementBoolean_DiscountCommit.DescId = zc_MovementBoolean_DiscountCommit()
      WHERE Id = inMovementId;
      
      IF (NOT (vbCashRegisterId = 0 OR
              vbFiscalCheckNumber = '-5' OR
              vbJackdawsChecksId <> 0)
         OR vbOperDate < '05.07.2021'
         OR vbOperDate < CURRENT_DATE - INTERVAL '3 DAY')
         OR vbInvNumberOrder <> '' 
         OR vbCheckSourceKindId <> 0
         OR vbisDiscountCommit = TRUE
      THEN
        RAISE EXCEPTION 'Ошибка. Удаление чеков вам запрещено.';     
      END IF;
    END IF;     

    IF EXISTS(SELECT 1
              FROM Movement
              WHERE
                  ID = inMovementId
                  AND
                  StatusId = zc_Enum_Status_Complete())
    THEN
        IF inSession = zfCalc_UserSite()
        THEN
          RETURN;
        END IF;
        RAISE EXCEPTION 'Ошибка. Документ проведен сначала разпроведите его.';     
    END IF;

    -- Если есть распределение по партиям удаляем
    IF EXISTS(SELECT * FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescID = zc_MI_Child() AND MovementItem.isErased = False)
    THEN
      PERFORM lpSetErased_MovementItem(MovementItem.Id, vbUserId)
      FROM MovementItem
      WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescID = zc_MI_Child() AND MovementItem.isErased = False;
    END IF;

    -- Программа лояльности накопительная возвращаем списанную сумму
    IF COALESCE((SELECT MovementFloat.ValueData
                 FROM MovementFloat
                 WHERE MovementFloat.DescID = zc_MovementFloat_LoyaltySMDiscount()
                   AND MovementFloat.MovementId = inMovementId), 0) <> 0
    THEN
      PERFORM gpUpdate_LoyaltySaveMoney_SummaDiscount (MovementFloat_LoyaltySMID.ValueData::INTEGER, -1.0 * MovementFloat.ValueData, inSession)
      FROM MovementFloat
           INNER JOIN MovementFloat AS MovementFloat_LoyaltySMID
                                    ON MovementFloat_LoyaltySMID.DescID = zc_MovementFloat_LoyaltySMID()
                                   AND MovementFloat_LoyaltySMID. MovementId = inMovementId
      WHERE MovementFloat.DescID = zc_MovementFloat_LoyaltySMDiscount()
        AND MovementFloat.MovementId = inMovementId;
    END IF;

    -- Удаляем Документ
    PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.   Шаблий О.В.
 13.05.19                                                                                     *
 05.07.15                                                                        *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_Income (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())