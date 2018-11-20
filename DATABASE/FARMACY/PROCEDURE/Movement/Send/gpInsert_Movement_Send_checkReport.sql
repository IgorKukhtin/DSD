DROP FUNCTION IF EXISTS gpInsert_Movement_Send_checkReport (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Send_checkReport(
    IN inStartSale           TDateTime , -- Дата начала отчета
    IN inEndSale             TDateTime , -- Дата окончания отчета
    IN inFromId              Integer   , -- от кого
    IN inToId                Integer   , -- Кому
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbMovementId Integer;
   DECLARE vbUserId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
      vbUserId := inSession;

      -- ищем ИД документа (ключ - подразделение, нач. оконч. отчета)
      SELECT tmp.Id
      INTO vbMovementId_ReportUnLiquid
      FROM (SELECT Movement.Id  
                 , ROW_NUMBER() OVER (ORDER BY Movement.OperDate DESC, Movement.Id DESC) AS Ord
            FROM Movement
              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                            ON MovementLinkObject_Unit.MovementId = Movement.ID
                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                           AND MovementLinkObject_Unit.ObjectId = inFromId
              INNER JOIN MovementDate AS MovementDate_StartSale
                                      ON MovementDate_StartSale.MovementId = Movement.Id
                                     AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
                                     AND MovementDate_StartSale.ValueData = inStartSale
              INNER JOIN MovementDate AS MovementDate_EndSale
                                      ON MovementDate_EndSale.MovementId = Movement.Id
                                     AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
                                     AND MovementDate_EndSale.ValueData = inEndSale
            WHERE Movement.DescId = zc_Movement_ReportUnLiquid() 
              AND Movement.StatusId <> zc_Enum_Status_Erased()
           ) AS tmp
      WHERE tmp.Ord = 1;
        
         
      IF COALESCE (vbMovementId_ReportUnLiquid, 0) = 0 THEN
         RAISE EXCEPTION 'Перемещения не могут быть созданы. Документ <Отчет по неликвидному товару> не сохранен.';
      END IF;


      -- ищем ИД документа перемещение (ключ - дата, от кого, кому, создан автоматически)
      SELECT Movement.Id  
      INTO vbMovementId
      FROM Movement
        INNER JOIN MovementBoolean AS MovementBoolean_isAuto
                                   ON MovementBoolean_isAuto.MovementId = Movement.Id
                                  AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
                                  AND COALESCE(MovementBoolean_isAuto.ValueData, False) = True
 
        INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement.ID
                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                     AND MovementLinkObject_From.ObjectId = inFromId

        INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                      ON MovementLinkObject_To.MovementId = Movement.ID
                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                     AND MovementLinkObject_To.ObjectId = inToId

      WHERE Movement.DescId = zc_Movement_Send() AND Movement.OperDate = inEndSale
          AND Movement.StatusId <> zc_Enum_Status_Erased();
    
      IF COALESCE (vbMovementId,0) = 0 
      THEN
         -- записываем новый <Документ>
         vbMovementId := lpInsertUpdate_Movement_Send (ioId               := COALESCE(vbMovementId,0) ::Integer
                                                     , inInvNumber        := CAST (NEXTVAL ('Movement_Send_seq') AS TVarChar) --inInvNumber
                                                     , inOperDate         := inEndSale
                                                     , inFromId           := inFromId
                                                     , inToId             := inToId
                                                     , inComment          := '' :: TVarChar
                                                     , inChecked          := FALSE
                                                     , inUserId           := vbUserId
                                                     );
  
         -- сохранили связь с <Документ Отчет по неликвидному товару>
         PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_ReportUnLiquid(), vbMovementId, vbMovementId_ReportUnLiquid);
      END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.11.18         *
*/
--