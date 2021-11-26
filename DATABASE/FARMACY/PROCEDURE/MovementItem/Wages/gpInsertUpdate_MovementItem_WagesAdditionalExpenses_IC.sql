-- Function: gpInsertUpdate_MovementItem_WagesAdditionalExpenses_IC()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WagesAdditionalExpenses_IC(TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_WagesAdditionalExpenses_IC(
    IN inOperDate              TDateTime   , -- ����� �������
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());
    vbUserId:= lpGetUserBySession (inSession);
    vbStartDate := date_trunc('month', inOperDate);
    vbEndDate := vbStartDate + INTERVAL '1 MONTH';

    SELECT Movement.ID
    INTO vbMovementId  
    FROM Movement 
    WHERE Movement.OperDate = vbStartDate
      AND Movement.DescId = zc_Movement_Wages();
      

    IF COALESCE (vbMovementId, 0) = 0
    THEN
      RAISE EXCEPTION '������. �������� �� �� ������.';
    END IF;
          
    -- ���������� <������>
    vbStatusId := (SELECT StatusId FROM Movement WHERE Id = vbMovementId);
    -- �������� - �����������/��������� ��������� �������� ������
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
    END IF;
   
    PERFORM lpInsertUpdate_MovementItem_WagesAdditionalExpenses_IC (ioId         := tmp.Id
                                                                  , inMovementId := vbMovementId
                                                                  , inUnitID     := tmp.UnitId
                                                                  , inSummaIC    := tmp.SummaIC
                                                                  , inUserId     := vbUserId)
    FROM (
    WITH
         -- ����� ���������
      tmpSummaIC AS (SELECT * 
                     FROM gpReport_SummaInsuranceCompanies(inStartDate := vbStartDate
                                                         , inEndDate := vbEndDate
                                                         , inJuridicalOurId := 0 
                                                         , inUnitId := 0 
                                                         , inSession := inSession)
                     )

    , tmpMI AS (SELECT MovementItem.Id                       AS Id
                     , MovementItem.ObjectId                 AS UnitID
                     , MIFloat_SummaIC.ValueData             AS SummaIC
               FROM  MovementItem

                     LEFT JOIN MovementItemFloat AS MIFloat_SummaIC
                                                 ON MIFloat_SummaIC.MovementItemId = MovementItem.Id
                                                AND MIFloat_SummaIC.DescId = zc_MIFloat_SummaIC()

               WHERE MovementItem.MovementId = vbMovementId
                 AND MovementItem.DescId = zc_MI_Sign())
                         
     -- ���������  
     SELECT tmpMI.ID
          , COALESCE(tmp.UnitId, tmpMI.UnitID)  AS UnitID
          , COALESCE (tmp.SummWages, 0) AS SummaIC
     FROM tmpSummaIC AS tmp
          FULL JOIN tmpMI ON tmpMI.UnitID = tmp.UnitId
     WHERE COALESCE (tmp.SummWages, 0) <> COALESCE (tmpMI.SummaIC, 0)) AS tmp;
              

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.11.21                                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_WagesAdditionalExpenses_IC (inOperDate := '25.11.2021', inSession:= '3')
