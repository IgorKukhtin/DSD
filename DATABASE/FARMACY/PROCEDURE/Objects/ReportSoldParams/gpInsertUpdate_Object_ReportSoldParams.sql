DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReportSoldParams (Integer, Integer, TDateTime, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReportSoldParams(
 INOUT ioId             Integer,    -- �� �����
    IN inUnitId         Integer,   -- �� �������������
 INOUT ioPlanDate       TDateTime, -- ����� �����
    IN inPlanAmount     TFloat,    -- ����� �����
    IN inSession        TVarChar   -- ������
)
AS
$BODY$
    DECLARE vbPlanAmount TFloat;
    DECLARE vbUserId Integer;
BEGIN
    -- ���������� ������������
    vbUserId := inSession;
    -- �������� ���� � ������ ������
    ioPlanDate := date_trunc('month', ioPlanDate);
    -- ���� ����� ������ ���� - ������� � ����� ����.-����
    SELECT
        Id, 
        PlanAmount
    INTO 
        ioId, 
        vbPlanAmount
    FROM 
        Object_ReportSoldParams_View
    WHERE
        UnitId = inUnitId
        AND
        PlanDate = ioPlanDate;
    IF COALESCE(ioId,0)=0
    THEN
        -- ���������/�������� <������> �� ��
        ioId := lpInsertUpdate_Object (ioId, zc_Object_ReportSoldParams(), 0, '');

        -- ��������� ����� � <�������������>
        PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ReportSoldParams_Unit(), ioId, inUnitId);
        
        --��������� ����� �����
        PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_ReportSoldParams_PlanDate(), ioId, ioPlanDate);
    END IF;
  
    IF (vbPlanAmount is null or vbPlanAmount <> inPlanAmount)
    THEN
        -- ��������� ��-�� < ����� ����� >
        PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_ReportSoldParams_PlanAmount(), ioId, inPlanAmount);

        -- ��������� ��������
        PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ReportSoldParams (Integer, Integer, TDateTime, TFloat, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 27.09.15                                                                      *
 */