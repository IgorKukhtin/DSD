-- Function: gpInsertUpdate_MovementItem_EmployeeScheduleVIP_User()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_EmployeeScheduleVIP_User(TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_EmployeeScheduleVIP_User(
    IN inStartHour           TVarChar  , -- 
    IN inStartMin            TVarChar  , -- 
    IN inEndHour             TVarChar  , -- 
    IN inEndMin              TVarChar  , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbMIId Integer;
   DECLARE vbChildId Integer;
   DECLARE vbPayrollTypeVIP Integer;

   DECLARE vbDate TDateTime;
   DECLARE vbDateStart TDateTime;
   DECLARE vbDateEnd TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());

     vbUserId:= lpGetUserBySession (inSession);

     IF vbUserId = 3
     THEN
       vbUserId := 390046;
     END IF;

     IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_VIPManager())
     THEN
        RAISE EXCEPTION 'По вам не предусмотрено заполнение графика.';   
     END IF;

     vbDate := DATE_TRUNC ('MONTH', CURRENT_DATE);

     -- проверка наличия графика
     IF NOT EXISTS(SELECT 1 FROM Movement
                   WHERE Movement.OperDate = vbDate
                     AND Movement.DescId = zc_Movement_EmployeeScheduleVIP())
     THEN
       RAISE EXCEPTION 'Ошибка. График работы сотрудеиков не найден. Обратитесь к Колеуш И. И.';
     END IF;

     SELECT Movement.ID
     INTO vbMovementId
     FROM Movement
     WHERE Movement.DescId = zc_Movement_EmployeeScheduleVIP()
       AND Movement.OperDate = vbDate;

    IF inStartHour <> ''
    THEN
      vbDateStart := CURRENT_DATE + (inStartHour||':'||inStartMin)::Time;

      IF date_part('minute',  vbDateStart) not in (0, 30) 
      THEN
        RAISE EXCEPTION 'Ошибка. Время прихода и ухода должны быть кратны 30 мин.';
      END IF;
    ELSE
      RAISE EXCEPTION 'Ошибка. Не заполнено время прихода.';
    END IF;

    IF inEndHour <> ''
    THEN
      vbDateEnd := CURRENT_DATE + (inEndHour||':'||inEndMin)::Time;

      IF date_part('minute',  vbDateEnd) not in (0, 30)
      THEN
        RAISE EXCEPTION 'Ошибка. Время прихода и ухода должны быть кратны 30 мин.';
      END IF;
    ELSE
      RAISE EXCEPTION 'Ошибка. Не заполнено время ухода.';
    END IF;
      
    IF vbDateStart > vbDateEnd
    THEN
        RAISE EXCEPTION 'Ошибка. Время прихода должна быть меньше даты ухода.';
    END IF;
    
    IF EXISTS(SELECT ID FROM MovementItem
              WHERE MovementItem.MovementId = vbMovementId
                AND MovementItem.ObjectId = vbUserId
                AND MovementItem.DescId = zc_MI_Master())
    THEN
      SELECT ID FROM MovementItem
      INTO vbMIId
      WHERE MovementItem.MovementId = vbMovementId
        AND MovementItem.ObjectId = vbUserId
        AND MovementItem.DescId = zc_MI_Master();    
    ELSE
 
      vbMIId := lpInsertUpdate_MovementItem_EmployeeScheduleVIP (ioId                  := 0                  -- Ключ объекта <Элемент мастера>
                                                               , inMovementId          := vbMovementId          -- ключ Документа
                                                               , inPersonId            := vbUserId              -- сотрудник
                                                               , inUserId              := vbUserId              -- пользователь
                                                                 );
    END IF;
    
    IF EXISTS(SELECT ID
              FROM MovementItem
              WHERE MovementItem.MovementId = vbMovementId
                AND MovementItem.ParentID = vbMIId
                AND MovementItem.Amount = date_part('DAY', CURRENT_DATE)
                AND MovementItem.DescId = zc_MI_Child())
    THEN
       SELECT MovementItem.ID, MovementItem.ObjectId, COALESCE (MIDate_Start.ValueData, vbDateStart)
       INTO vbChildId, vbPayrollTypeVIP, vbDateStart
       FROM MovementItem

            LEFT JOIN MovementItemDate AS MIDate_Start
                                       ON MIDate_Start.MovementItemId = MovementItem.Id
                                      AND MIDate_Start.DescId = zc_MIDate_Start()

       WHERE MovementItem.MovementId = vbMovementId
         AND MovementItem.ParentID = vbMIId
         AND MovementItem.Amount = date_part('DAY', CURRENT_DATE)
         AND MovementItem.DescId = zc_MI_Child();
    ELSE 
      vbChildId := 0;
      vbPayrollTypeVIP := 0;
    END IF;
            
    -- сохранили
    vbChildId := lpInsertUpdate_MovementItem_EmployeeScheduleVIP_Child (ioId                  := vbChildId            -- Ключ объекта <Элемент документа>
                                                                      , inMovementId          := vbMovementId         -- ключ Документа
                                                                      , inParentId            := vbMIId               -- элемент мастер
                                                                      , inAmount              := date_part('DAY', CURRENT_DATE)::TFloat              -- День
                                                                      , inPayrollTypeVIPID    := vbPayrollTypeVIP      -- Тип дня
                                                                      , inDateStart           := vbDateStart           -- Приходы на работу по дням
                                                                      , inDateEnd             := vbDateEnd             -- Приходы на работу по дням
                                                                      , inUserId              := vbUserId              -- пользователь
                                                                       );

   -- RAISE EXCEPTION 'Ошибка. В разработке % % % % %', vbChildId, date_part('DAY', CURRENT_DATE), vbPayrollTypeVIP, vbDateStart, vbDateEnd;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
16.09.21                                                        *
*/

-- тест
-- select * from gpInsertUpdate_MovementItem_EmployeeScheduleVIP_User(inStartHour := '8' , inStartMin := '00' , inEndHour := '21' , inEndMin := '00' ,  inSession := '3');

