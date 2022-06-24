-- Function: gpUpdate_Movement_Check_ClearFiscal()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_ClearFiscal (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_ClearFiscal(
    IN inId                Integer   , -- ���� ������� <�������� ���>
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbCashRegisterId Integer;
   DECLARE vbZReport Integer;
   DECLARE vbFiscalCheckNumber TVarChar;
   DECLARE vbJackdawsChecksId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpGetUserBySession (inSession);

    IF vbUserId NOT IN (3, 375661, 4183126, 8001630, 9560329, 9383066)
    THEN
      RAISE EXCEPTION '���������� �������� ��� ���������.';
    END IF;

    IF COALESCE(inId,0) = 0
    THEN
        RAISE EXCEPTION '�������� �� �������.';
    END IF;

    SELECT
      StatusId,
      COALESCE(MovementLinkObject_CashRegister.ObjectId, 0),
      COALESCE(MovementFloat_ZReport.ValueData, 0),
      COALESCE(MovementString_FiscalCheckNumber.ValueData, ''),
      COALESCE(MovementLinkObject_JackdawsChecks.ObjectId, 0)
    INTO
      vbStatusId,
      vbCashRegisterId,
      vbZReport,
      vbFiscalCheckNumber,
      vbJackdawsChecksId
    FROM Movement

         LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                      ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                     AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
         LEFT JOIN MovementFloat AS MovementFloat_ZReport
                                 ON MovementFloat_ZReport.MovementId =  Movement.Id
                                AND MovementFloat_ZReport.DescId = zc_MovementFloat_ZReport()
         LEFT JOIN MovementString AS MovementString_FiscalCheckNumber
                                  ON MovementString_FiscalCheckNumber.MovementId = Movement.Id
                                 AND MovementString_FiscalCheckNumber.DescId = zc_MovementString_FiscalCheckNumber()
        LEFT JOIN MovementLinkObject AS MovementLinkObject_JackdawsChecks
                                     ON MovementLinkObject_JackdawsChecks.MovementId = Movement.Id
                                    AND MovementLinkObject_JackdawsChecks.DescId = zc_MovementLinkObject_JackdawsChecks()
    WHERE Id = inId;
    
    IF vbCashRegisterId <> 0 OR
      vbZReport <> 0 OR
      vbFiscalCheckNumber <> '' OR
      vbJackdawsChecksId <> 0
    THEN
    
        -- ��������� ����� � �������� ���������
      IF vbCashRegisterId <> 0
      THEN
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CashRegister(), inId, 0);
      END IF;

        -- ��������� <����� Z ������>
      IF vbZReport <> 0
      THEN
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ZReport(), inId, Null);
      END IF;

        -- ��������� ����� ���� � �������� ��������
      IF vbFiscalCheckNumber <> ''
      THEN
        PERFORM lpInsertUpdate_MovementString(zc_MovementString_FiscalCheckNumber(), inId, '');
      END IF;

        -- ��������� ����� � �������� ���������
      IF vbJackdawsChecksId <> 0
      THEN
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_JackdawsChecks(), inId, 0);
      END IF;

      -- ��������� ��������
      PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 13.09.21                                                                                    *
*/
-- ����
-- 
select * from gpUpdate_Movement_Check_ClearFiscal(inId := 28050651 ,  inSession := '3');