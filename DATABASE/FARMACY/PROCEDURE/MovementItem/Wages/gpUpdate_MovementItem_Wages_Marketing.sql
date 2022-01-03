-- Function: gpUpdate_MovementItem_Wages_Marketing()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Wages_Marketing(TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Wages_Marketing(
    IN inOperDate            TDateTime , -- ���� �������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbStatusId Integer;
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

    PERFORM gpInsertUpdate_MovementItem_Wages_Marketing (ioId         := T1.Id
                                                       , inMovementId := vbMovementId
                                                       , inUserId     := T1.UserID
                                                       , inUnitId     := T1.UnitID
                                                       , inMarketing  := T1.Total
                                                       , inSession    := inSession)
    FROM (SELECT COALESCE(MovementItem.id, 0) AS Id, IPE.UnitID, IPE.UserID, ROUND(COALESCE (IPE.Total, 0)) AS Total
          FROM gpReport_ImplementationPlanEmployeeAll(inStartDate := DATE_TRUNC ('MONTH', inOperDate) - INTERVAL '1 DAY', inSession := inSession) AS IPE
         
               LEFT JOIN MovementItem ON MovementItem.MovementId = vbMovementId
                                     AND MovementItem.ObjectId = IPE.UserID
                                     AND MovementItem.DescId = zc_MI_Master()

               LEFT JOIN MovementItemFloat AS MIFloat_Marketing
                                           ON MIFloat_Marketing.MovementItemId = MovementItem.Id
                                          AND MIFloat_Marketing.DescId = zc_MIFloat_Marketing()
                                           
          WHERE COALESCE (MIFloat_Marketing.ValueData, 0) <> 
                CASE WHEN ROUND(COALESCE (IPE.Total, 0)) > 0 OR ROUND(COALESCE (IPE.Total, 0)) < 0 AND
                COALESCE (IPE.isReleasedMarketingPlan, False) = False THEN  ROUND(COALESCE (IPE.Total, 0)) ELSE 0 END
            AND IPE.UnitName NOT ILIKE '�� %'
          ) AS T1;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.04.21                                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_MovementItem_Wages_Marketing (CURRENT_DATE, inSession:= '3')