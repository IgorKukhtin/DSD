-- Function: gpInsertUpdate_Movement_WagesVIP_CalculationAllDay()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WagesVIP_CalculationAllDay (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_WagesVIP_CalculationAllDay(
    IN inMovementId            Integer    , -- ���� ������� <�������� �������>
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId      Integer;
   DECLARE vbOperDate    TDateTime;
   DECLARE vbStatusId    Integer;
   DECLARE vbTotalSummPhone   TFloat;
   DECLARE vbTotalSummSale    TFloat;
   DECLARE vbTotalSummSaleNP  TFloat;
   DECLARE vbHoursWork        TFloat;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_WagesVIP());

    -- ��������� ������� �� ���������
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION '�������� �� ��������';
    END IF;

      -- �������� ������
    SELECT Movement.OperDate, Movement.StatusId
    INTO vbOperDate, vbStatusId
    FROM Movement
    WHERE Movement.Id = inMovementId;

    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION '������. ��������� ��������� � <%> � ������� <%> �� ��������.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
    END IF;
    
    IF EXISTS(SELECT 1
              FROM  MovementItem
                   
                    INNER JOIN MovementItemBoolean AS MIBoolean_isIssuedBy
                                                   ON MIBoolean_isIssuedBy.MovementItemId = MovementItem.Id
                                                  AND MIBoolean_isIssuedBy.DescId = zc_MIBoolean_isIssuedBy()
                                                  AND MIBoolean_isIssuedBy.ValueData = TRUE

                                                    
              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.DescId = zc_MI_Master())
    THEN
        RAISE EXCEPTION '������. �������� ������ ���������� ������� ���������.';
    END IF;
        
    -- ����������� ����
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpCalcMonthUserSum'))
    THEN
      DROP TABLE tmpCalcMonthUserSum;
    END IF;

    CREATE TEMP TABLE tmpCalcMonthUserSum ON COMMIT DROP AS
    (select * from gpReport_Movement_WagesVIP_CalcMonthUser(inOperDate := vbOperDate,  inSession := inSession));

    vbTotalSummPhone := 0;
    vbTotalSummSale := 0;
    vbTotalSummSaleNP := 0;
    vbHoursWork := 0;
    
    SELECT COALESCE(Movement.TotalSummPhone, 0)::TFloat   AS SummPhone
         , COALESCE(Movement.TotalSummSale, 0)::TFloat    AS SummSale
         , COALESCE(Movement.TotalSummNP, 0)::TFloat      AS SummSaleNP
    INTO vbTotalSummPhone, vbTotalSummSale, vbTotalSummSaleNP
    FROM tmpCalcMonthUserSum AS Movement
    LIMIT 1;
    
    SELECT SUM(tmpCalcMonthUserSum.HoursWork)::TFloat AS HoursWork
    INTO vbHoursWork
    FROM tmpCalcMonthUserSum;
                           
    -- ��������� ������� <����� ���������� ������� �������� �� ��������>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPhone(), inMovementId, vbTotalSummPhone);
    -- ��������� ������� <����� ���������� �������>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummSale(), inMovementId, vbTotalSummSale);
    -- ��������� ������� <����� ���������� �������>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummSaleNP(), inMovementId, vbTotalSummSaleNP);
    -- ��������� ������� <���������� ����� ����� ������������>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_HoursWork(), inMovementId, vbHoursWork);
    
          
    PERFORM lpInsertUpdate_MovementItem_WagesVIP_Calc (ioId                 := COALESCE(tmpMI.Id, 0)
                                                     , inMovementId         := inMovementId
                                                     , inUserWagesId        := COALESCE(tmpCalc.UserID, tmpMI.UserID)
                                                     , inAmountAccrued      := COALESCE(tmpCalc.AmountAccrued, 0)
                                                     , inApplicationAward   := COALESCE(tmpCalc.ApplicationAward, 0)
                                                     , inHoursWork          := COALESCE(tmpCalc.HoursWork, 0)
                                                     , inUserId             := vbUserId)
    FROM (SELECT tmpCalculation.UserId
               , SUM(tmpCalculation.AmountAccrued)                    AS AmountAccrued
               , SUM(tmpCalculation.HoursWork)::TFloat                AS HoursWork
               , MAX(tmpCalculation.ApplicationAward)::TFloat         AS ApplicationAward
          FROM tmpCalcMonthUserSum AS tmpCalculation
          GROUP BY tmpCalculation.UserId) AS tmpCalc
    
         FULL JOIN (SELECT MovementItem.Id                    AS Id
                         , MovementItem.ObjectId              AS UserID
                         , MovementItem.Amount                AS AmountAccrued
                         , MIFloat_HoursWork.ValueData        AS HoursWork
                    FROM  MovementItem
                   
                          LEFT JOIN MovementItemFloat AS MIFloat_HoursWork
                                                      ON MIFloat_HoursWork.MovementItemId = MovementItem.Id
                                                     AND MIFloat_HoursWork.DescId = zc_MovementFloat_HoursWork()
                                                    
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.DescId = zc_MI_Master()) AS tmpMI ON tmpMI.UserID = tmpCalc.UserID
         
    WHERE COALESCE(tmpMI.AmountAccrued, 0) <> COALESCE(tmpCalc.AmountAccrued, 0)
       OR COALESCE(tmpMI.HoursWork, 0) <> COALESCE(tmpCalc.HoursWork, 0);
               
    
    -- ��������� �������� <���� �������>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Calculation(), inMovementId, CURRENT_TIMESTAMP);    

      -- ����������� �������� �����
--    PERFORM lpInsertUpdate_Movement_WagesVIP_TotalSumm (inMovementId);

 --  RAISE EXCEPTION '------> % % %  - %', vbTotalSummPhone, vbTotalSummSale, vbTotalSummSaleNP, vbHoursWork;      

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.08.19                                                        *
*/

-- select * from gpInsertUpdate_Movement_WagesVIP_CalculationAllDay(inMovementId := 30560885 ,  inSession := '3');