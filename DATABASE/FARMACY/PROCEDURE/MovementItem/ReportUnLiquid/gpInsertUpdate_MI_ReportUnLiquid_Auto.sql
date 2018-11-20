-- Function: gpInsertUpdate_MI_ReportUnLiquid_Auto)

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ReportUnLiquid_Auto(TDateTime, TDateTime, Integer, Integer
                                                            , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                                            , TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ReportUnLiquid_Auto(
    IN inStartSale           TDateTime , -- Дата начала отчета
    IN inEndSale             TDateTime , -- Дата окончания отчета
    IN inUnitId              Integer   , -- Юридические лица
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- 
    IN inRemainsStart        TFloat    , --
    IN inRemainsEnd          TFloat    , --
    IN inAmountM1            TFloat    , --
    IN inAmountM3            TFloat    , --
    IN inAmountM6            TFloat    , --
    IN inAmountIncome        TFloat    , --
    IN inSumm                TFloat    , --
    IN inSummStart           TFloat    , --
    IN inSummEnd             TFloat    , --
    IN inSummM1              TFloat    , --
    IN inSummM3              TFloat    , --
    IN inSummM6              TFloat    , --
    IN inDateIncome          TDateTime , -- 
    IN inMinExpirationDate   TDateTime , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbMovementItemId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_ReportUnLiquid());
     vbUserId := inSession;

      -- ищем ИД документа (ключ - дата, подразделение, нач. оконч. отчета)
      SELECT Movement.Id  
      INTO vbMovementId
      FROM Movement
        INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.ID
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                     AND MovementLinkObject_Unit.ObjectId = inUnitId
        INNER JOIN MovementDate AS MovementDate_StartSale
                                ON MovementDate_StartSale.MovementId = Movement.Id
                               AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
                               AND MovementDate_StartSale.ValueData = inStartSale
        INNER JOIN MovementDate AS MovementDate_EndSale
                                ON MovementDate_EndSale.MovementId = Movement.Id
                               AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
                               AND MovementDate_EndSale.ValueData = inEndSale

      WHERE Movement.DescId = zc_Movement_ReportUnLiquid() 
        AND Movement.OperDate = CURRENT_DATE
        AND Movement.StatusId <> zc_Enum_Status_Erased();


      IF COALESCE (vbMovementId,0) = 0
      THEN
          vbMovementId := lpInsertUpdate_Movement_ReportUnLiquid (ioId         := 0
                                                                , inInvNumber  := CAST (NEXTVAL ('movement_ReportUnLiquid_seq') AS TVarChar)
                                                                , inOperDate   := CURRENT_DATE       :: TDateTime
                                                                , inStartSale  := inStartSale
                                                                , inEndSale    := inEndSale
                                                                , inUnitId     := inUnitId
                                                                , inComment    := ''                 :: TVarChar
                                                                , inUserId     := vbUserId
                                                                  );
      END IF;
      

      -- Ищеи ИД строки (ключ - ид документа, товар)
      SELECT MovementItem.Id
       INTO vbMovementItemId
      FROM MovementItem
      WHERE MovementItem.MovementId = vbMovementId 
        AND MovementItem.ObjectId = inGoodsId;
      
      PERFORM lpInsertUpdate_MI_ReportUnLiquid (ioId                  := COALESCE (vbMovementItemId, 0)
                                              , inMovementId          := vbMovementId
                                              , inGoodsId             := inGoodsId
                                              , inAmount              := inAmount
                                              , inRemainsStart        := inRemainsStart
                                              , inRemainsEnd          := inRemainsEnd
                                              , inAmountM1            := inAmountM1
                                              , inAmountM3            := inAmountM3
                                              , inAmountM6            := inAmountM6
                                              , inAmountIncome        := inAmountIncome
                                              , inSumm                := inSumm
                                              , inSummStart           := inSummStart
                                              , inSummEnd             := inSummEnd
                                              , inSummM1              := inSummM1
                                              , inSummM3              := inSummM3
                                              , inSummM6              := inSummM6
                                              , inDateIncome          := inDateIncome
                                              , inMinExpirationDate   := inMinExpirationDate
                                              , inUserId              := vbUserId
                                                );

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.11.18         *
*/

-- тест
--