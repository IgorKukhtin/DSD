-- Function: gpUpdate_MovementItem_Wages_IlliquidAssets()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Wages_IlliquidAssets(TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Wages_IlliquidAssets(
    IN inOperDate            TDateTime , -- ���� �������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbStatusId Integer;

   DECLARE vbProcGoods TFloat;
   DECLARE vbProcUnit TFloat;
   DECLARE vbPlanAmount TFloat;
   DECLARE vbPenalty TFloat;
   DECLARE vbPenaltySum TFloat;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

    -- �������� vbMovementId
    SELECT Movement.Id, Movement.StatusId
    INTO vbMovementId, vbStatusId
    FROM Movement
    WHERE Movement.OperDate = DATE_TRUNC ('MONTH', inOperDate)
      AND Movement.DescId = zc_Movement_Wages();

    -- �������� - �����������/��������� ��������� �������� ������
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION '������. ��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    IF COALESCE (vbMovementId, 0) = 0
    THEN
      -- ��������� <��������>
      vbMovementId := lpInsertUpdate_Movement_Wages (ioId              := 0
                                                   , inInvNumber       := CAST (NEXTVAL ('Movement_Wages_seq')  AS TVarChar) 
                                                   , inOperDate        := DATE_TRUNC ('MONTH', inOperDate)
                                                   , inUserId          := vbUserId
                                                     );
    END IF;

    IF COALESCE (vbMovementId, 0) = 0
    THEN
      RAISE EXCEPTION '������. �������� �� �� ������.';
    END IF;

    SELECT GetIlliquidReduction.ProcGoods
         , GetIlliquidReduction.ProcUnit
         , GetIlliquidReduction.PlanAmount
         , GetIlliquidReduction.Penalty 
         , GetIlliquidReduction.PenaltySum
    INTO vbProcGoods 
       , vbProcUnit
       , vbPlanAmount
       , vbPenalty
       , vbPenaltySum
    FROM gpReport_GetIlliquidReductionPlanUser (DATE_TRUNC ('MONTH', inOperDate) - INTERVAL '1 DAY', inSession) AS GetIlliquidReduction;

    PERFORM gpInsertUpdate_MovementItem_Wages_IlliquidAssets (ioId              := T1.Id
                                                            , inMovementId      := vbMovementId
                                                            , inUserId          := T1.UserID
                                                            , inUnitId          := T1.UnitID
                                                            , inIlliquidAssets  := T1.SummaPenalty
                                                            , inSession         := inSession)
    FROM (SELECT COALESCE(MovementItem.id, 0) AS Id, IPE.UnitID, IPE.UserID, ROUND(COALESCE (- IPE.SummaPenalty, 0)) AS SummaPenalty
          FROM gpReport_IlliquidReductionPlanAll(inStartDate := DATE_TRUNC ('MONTH', inOperDate) - INTERVAL '1 DAY',  
                                                 inProcGoods := vbProcGoods, 
                                                 inProcUnit := vbProcUnit, 
                                                 inPlanAmount := vbPlanAmount, 
                                                 inPenalty := vbPenalty, 
                                                 inisPenaltyInfo := FALSE,
                                                 inPenaltySum := vbPenaltySum, 
                                                 inisPenaltySumInfo := inOperDate < '01.05.2021'::TDateTime,
                                                 inSession := inSession) AS IPE
         
               LEFT JOIN MovementItem ON MovementItem.MovementId = vbMovementId
                                     AND MovementItem.ObjectId = IPE.UserID
                                     AND MovementItem.DescId = zc_MI_Master()

               LEFT JOIN MovementItemFloat AS MIFloat_IlliquidAssets
                                           ON MIFloat_IlliquidAssets.MovementItemId = MovementItem.Id
                                          AND MIFloat_IlliquidAssets.DescId = zc_MIFloat_SummaIlliquidAssets()
                                           
          WHERE COALESCE (MIFloat_IlliquidAssets.ValueData, 0) <> ROUND(COALESCE (- IPE.SummaPenalty, 0))
            AND COALESCE (IPE.SummaPenalty, 0) > 0
            AND COALESCE (IPE.ManDays, 0) > 0
          ) AS T1;

       -- RAISE EXCEPTION '���� ������ ������� ��� <%>', inSession;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.04.21                                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_MovementItem_Wages_IlliquidAssets (CURRENT_DATE, inSession:= '3')