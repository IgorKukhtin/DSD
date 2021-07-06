-- Function: gpUnComplete_Movement_Income (Integer, TVarChar, TVarChar)

-- DROP FUNCTION IF EXISTS gpUnComplete_Movement_Check (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUnComplete_Movement_Check (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_Check(
    IN inMovementId        Integer               , -- ключ Документа
    IN inUsersession	   TVarChar              , -- сессия пользователя (подменяем реальную)
--    IN inSession         TVarChar DEFAULT ''     -- сессия пользователя
    IN inSession           TVarChar                -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId      Integer;
  DECLARE vbOperDate    TDateTime;
  DECLARE vbUnit        Integer;
  DECLARE vbStatusId    Integer;
  DECLARE vbLoyaltySMID Integer;
  DECLARE vbLoyaltySMDiscount TFloat;
  DECLARE vbLoyaltySMSumma TFloat;
  DECLARE vbCashRegisterId Integer;
  DECLARE vbFiscalCheckNumber TVarChar;
  DECLARE vbJackdawsChecksId Integer;
BEGIN

    if coalesce(inUserSession, '') <> '' then
     inSession := inUserSession;
    end if;

    -- проверка прав пользователя на вызов процедуры
    IF (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inMovementId) = zc_Enum_Status_Complete()
    THEN

      IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
                WHERE Object_RoleUser.ID = inSession::Integer AND Object_RoleUser.RoleId = zc_Enum_Role_CashierPharmacy()) -- Для роли "Кассир аптеки"
      THEN

        SELECT 
          Movement.OperDate,
          COALESCE(MovementLinkObject_CashRegister.ObjectId, 0),
          COALESCE(MovementString_FiscalCheckNumber.ValueData, ''),
          COALESCE(MovementLinkObject_JackdawsChecks.ObjectId, 0)
        INTO
          vbOperDate,
          vbCashRegisterId,
          vbFiscalCheckNumber,
          vbJackdawsChecksId
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
        WHERE Id = inMovementId;
        
        IF NOT (vbCashRegisterId = 0 OR
                vbFiscalCheckNumber = '-5' OR
                vbJackdawsChecksId <> 0)
           OR vbOperDate < '05.07.2021'
           OR vbOperDate < CURRENT_DATE - INTERVAL '3 DAY'
        THEN
          RAISE EXCEPTION 'Ошибка. Распроведение чеков вам запрещено.';     
        END IF;

      ELSE
        vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_Income());

        -- Разрешаем только сотрудникам с правами админа
        IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin(), zc_Enum_Role_UnComplete()))
        THEN
          RAISE EXCEPTION 'Распроведение вам запрещено, обратитесь к системному администратору';
        END IF;
      END IF;     
    ELSE
        vbUserId:=inSession::Integer;
    END IF;

    -- проверка - если <Master> Удален, то <Ошибка>
    PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_UnComplete(), inComment:= 'распровести');

    -- Проверить, что бы не было переучета позже даты документа
    SELECT
        date_trunc('day', Movement.OperDate),
        Movement_Unit.ObjectId AS Unit,
        Movement.StatusId,
        COALESCE (MovementFloat_LoyaltySMID.ValueData, 0)::INTEGER,
        COALESCE (MovementFloat_LoyaltySMDiscount.ValueData, 0),
        COALESCE (MovementFloat_LoyaltySMSumma.ValueData, 0)
    INTO
        vbOperDate,
        vbUnit,
        vbStatusId,
        vbLoyaltySMID,
        vbLoyaltySMDiscount,
        vbLoyaltySMSumma
        
    FROM Movement
        INNER JOIN MovementLinkObject AS Movement_Unit
                                      ON Movement_Unit.MovementId = Movement.Id
                                     AND Movement_Unit.DescId = zc_MovementLinkObject_Unit()
        LEFT JOIN MovementFloat AS MovementFloat_LoyaltySMID
                                ON MovementFloat_LoyaltySMID.DescID = zc_MovementFloat_LoyaltySMID()
                               AND MovementFloat_LoyaltySMID. MovementId = Movement.Id
        LEFT JOIN MovementFloat AS MovementFloat_LoyaltySMDiscount
                               ON MovementFloat_LoyaltySMDiscount.DescID = zc_MovementFloat_LoyaltySMDiscount()
                              AND MovementFloat_LoyaltySMDiscount. MovementId = Movement.Id
        LEFT JOIN MovementFloat AS MovementFloat_LoyaltySMSumma
                               ON MovementFloat_LoyaltySMSumma.DescID = zc_MovementFloat_LoyaltySMSumma()
                              AND MovementFloat_LoyaltySMSumma. MovementId = Movement.Id
    WHERE Movement.Id = inMovementId;

    -- Программа лояльности накопительная возвращаем списанную сумму
    IF vbStatusId = zc_Enum_Status_Erased() AND vbLoyaltySMDiscount <> 0
    THEN
      PERFORM gpUpdate_LoyaltySaveMoney_SummaDiscount (vbLoyaltySMID, vbLoyaltySMDiscount, inSession);
    END IF;

    -- Программа лояльности накопительная накапливаем сумму
    IF vbStatusId = zc_Enum_Status_Complete() AND vbLoyaltySMSumma <> 0
    THEN
      UPDATE MovementItem SET Amount = Amount - vbLoyaltySMSumma WHERE MovementItem.ID = vbLoyaltySMID;
    END IF;

/*    IF EXISTS(SELECT 1
              FROM Movement AS Movement_Inventory
                  INNER JOIN MovementItem AS MI_Inventory
                                          ON MI_Inventory.MovementId = Movement_Inventory.Id
                                         AND MI_Inventory.DescId = zc_MI_Master()
                                         AND MI_Inventory.IsErased = FALSE
                  INNER JOIN MovementLinkObject AS Movement_Inventory_Unit
                                                ON Movement_Inventory_Unit.MovementId = Movement_Inventory.Id
                                               AND Movement_Inventory_Unit.DescId = zc_MovementLinkObject_Unit()
                                               AND Movement_Inventory_Unit.ObjectId = vbUnit
                  Inner Join MovementItem AS MI_Send
                                          ON MI_Inventory.ObjectId = MI_Send.ObjectId
                                         AND MI_Send.DescId = zc_MI_Master()
                                         AND MI_Send.IsErased = FALSE
                                         AND MI_Send.Amount > 0
                                         AND MI_Send.MovementId = inMovementId

              WHERE
                  Movement_Inventory.DescId = zc_Movement_Inventory()
                  AND
                  Movement_Inventory.OperDate >= vbOperDate
                  AND
                  Movement_Inventory.StatusId = zc_Enum_Status_Complete()
              )
    THEN
        RAISE EXCEPTION 'Ошибка. По одному или более товарам есть документ переучета позже даты текущей продажи. Отмена проведения документа запрещена!';
    END IF;*/
     -- Распроводим Документ
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

    IF EXISTS(SELECT * FROM MovementBoolean AS MovementBoolean_CorrectMarketing
              WHERE MovementBoolean_CorrectMarketing.ValueData = True
                AND MovementBoolean_CorrectMarketing.MovementId = inMovementId
                AND MovementBoolean_CorrectMarketing.DescId = zc_MovementBoolean_CorrectMarketing()) 
    THEN
      PERFORM gpInsertUpdate_MovementItem_WagesMarketingRepayment (inMovementID := inMovementId, inSession:= zfCalc_UserAdmin());
    END IF;

    IF EXISTS(SELECT * FROM MovementBoolean AS MovementBoolean_CorrectIlliquidMarketing
              WHERE MovementBoolean_CorrectIlliquidMarketing.ValueData = True
                AND MovementBoolean_CorrectIlliquidMarketing.MovementId = inMovementId
                AND MovementBoolean_CorrectIlliquidMarketing.DescId = zc_MovementBoolean_CorrectIlliquidMarketing()) 
    THEN
      PERFORM gpInsertUpdate_MovementItem_WagesIlliquidAssetsRepayment (inMovementID := inMovementId, inSession:= zfCalc_UserAdmin());
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 02.07.19                                                                     *
 03.07.14                                                       *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement_Check (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
-- select * from gpUpdate_Status_Check(inMovementId := 23950999 , ioStatusCode := 1 ,  inSession := '11278106');