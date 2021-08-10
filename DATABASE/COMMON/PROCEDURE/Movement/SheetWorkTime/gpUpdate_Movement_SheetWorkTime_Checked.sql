-- Function: gpUpdate_Movement_SheetWorkTime_Checked()

DROP FUNCTION IF EXISTS gpUpdate_Movement_SheetWorkTime_Checked(TDateTime, Integer, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_SheetWorkTime_Checked(
    IN inOperDate        TDateTime , -- ����
    IN inUnitId          Integer   , -- �������������
    IN inisChecked       Boolean   , -- ��������� �������������
   OUT outisChecked      Boolean   , -- ��������� �������������
   OUT OutChecked_date   TDateTime ,
   OUT OutCheckedName    TVarChar  , 
    IN inDesc            TVarChar  ,
    IN inSession         TVarChar    -- ������ ������������
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbEndDate    TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);

    -- ������ ����� ������
    inOperDate := DATE_TRUNC ('MONTH', inOperDate);
    -- ��������� ����� ������
    vbEndDate := DATE_TRUNC ('MONTH', inOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY';

    --
    outisChecked := NOT inisChecked;
    OutChecked_date := CURRENT_TIMESTAMP;
    OutCheckedName := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbUserId);
   
    IF inDesc = 'zc_MovementBoolean_CheckedHead'
    THEN
        -- ��������� ��������
        PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_CheckedHead(), Movement_SheetWorkTime.Id, outisChecked)
              , lpInsertUpdate_MovementDate (zc_MovementDate_CheckedHead(), Movement_SheetWorkTime.Id, OutChecked_date)
              , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CheckedHead(), Movement_SheetWorkTime.Id, vbUserId)
              , lpInsert_MovementProtocol (Movement_SheetWorkTime.Id, vbUserId, FALSE)                                        -- ��������� ��������
        FROM Movement AS Movement_SheetWorkTime                                                         -- ��� ��������� �� ����� �� UnitId
             JOIN MovementLinkObject AS MovementLinkObject_Unit
                                     ON MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                    AND MovementLinkObject_Unit.MovementId = Movement_SheetWorkTime.Id  
                                    AND MovementLinkObject_Unit.ObjectId = inUnitId
        WHERE Movement_SheetWorkTime.DescId = zc_Movement_SheetWorkTime()
          AND Movement_SheetWorkTime.OperDate BETWEEN inOperDate AND vbEndDate
          AND Movement_SheetWorkTime.StatusId <> zc_Enum_Status_Erased()
        ;
    END IF;

    IF inDesc = 'zc_MovementBoolean_CheckedPersonal'
    THEN
        -- ��������� ��������
        PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_CheckedPersonal(), Movement_SheetWorkTime.Id, outisChecked)
              , lpInsertUpdate_MovementDate (zc_MovementDate_CheckedPersonal(), Movement_SheetWorkTime.Id, OutChecked_date)
              , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CheckedPersonal(), Movement_SheetWorkTime.Id, vbUserId)
              , lpInsert_MovementProtocol (Movement_SheetWorkTime.Id, vbUserId, FALSE)                                        -- ��������� ��������
        FROM Movement AS Movement_SheetWorkTime                                                         -- ��� ��������� �� ����� �� UnitId
             JOIN MovementLinkObject AS MovementLinkObject_Unit 
                                     ON MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                    AND MovementLinkObject_Unit.MovementId = Movement_SheetWorkTime.Id  
                                    AND MovementLinkObject_Unit.ObjectId = inUnitId
        WHERE Movement_SheetWorkTime.DescId = zc_Movement_SheetWorkTime()
          AND Movement_SheetWorkTime.OperDate BETWEEN inOperDate AND vbEndDate
          AND Movement_SheetWorkTime.StatusId <> zc_Enum_Status_Erased()
        ;
    END IF;
    
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.08.21         *
*/

-- ����
--