-- Function: gpInsertUpdate_MovementItem_EmployeeScheduleNew()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_EmployeeScheduleNew(INTEGER, INTEGER, INTEGER, TVarChar, TVarChar, TVarChar, INTEGER, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_EmployeeScheduleNew(
 INOUT ioId                  Integer   , -- ���� ������� <������� ��������� ������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inUserId              Integer   , -- ���������
 INOUT ioValue               TVarChar  , -- ��� ���
 INOUT ioValueStart          TVarChar  , -- ����� �������
 INOUT ioValueEnd            TVarChar  , -- ����� �����
 INOUT ioTypeId              Integer   , -- ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitID Integer;
   DECLARE vbParentId Integer;

   DECLARE vbDate TDateTime;
   DECLARE vbDateStart TDateTime;
   DECLARE vbDateEnd TDateTime;
   DECLARE vbPayrollType Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);

/*     IF inSession <> '3'
     THEN
        RAISE EXCEPTION '������. � ����������';
     END IF;
*/
    -- �������� ���� ������������ �� ����� ���������
    IF vbUserId NOT IN (3, 758920, 4183126, 9383066)
    THEN
      RAISE EXCEPTION '��������� <������ ������ �����������> ��� ���������.';
    END IF;

    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION '������. ������ �� ��������.';
    ELSE
      SELECT date_trunc('MONTH', Movement.OperDate)
      INTO vbDate
      FROM Movement
      WHERE Movement.Id = inMovementId;
    END IF;
    
    IF EXISTS(SELECT COALESCE (ObjectLink_Member_Unit.ChildObjectId, 0)
              FROM ObjectLink AS ObjectLink_User_Member

                   INNER JOIN ObjectLink AS ObjectLink_Member_Unit
                                        ON ObjectLink_Member_Unit.ObjectId = ObjectLink_User_Member.ChildObjectId
                                       AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit()

              WHERE ObjectLink_User_Member.ObjectId = inUserId
                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member())
    THEN
       SELECT COALESCE (ObjectLink_Member_Unit.ChildObjectId, 0)
       INTO vbUnitID
       FROM ObjectLink AS ObjectLink_User_Member

            INNER JOIN ObjectLink AS ObjectLink_Member_Unit
                                 ON ObjectLink_Member_Unit.ObjectId = ObjectLink_User_Member.ChildObjectId
                                AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit()

       WHERE ObjectLink_User_Member.ObjectId = inUserId
         AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member();
    ELSE
       vbUnitID := 0;
    END IF;

    IF COALESCE(ioId, 0) = 0 AND vbUnitID = 0
    THEN
        RAISE EXCEPTION '������. � ���. ���� �� ��������� �������������.';
    END IF;    

    IF ioValueStart <> ''
    THEN
       vbDateStart := date_trunc('DAY', vbDate) + ((ioTypeId - 1)::TVarChar||' DAY')::interval + ioValueStart::Time;

      IF date_part('minute',  vbDateStart) not in (0, 30) 
      THEN
        RAISE EXCEPTION '������. ���� ������� � ����� ������ ���� ������ 30 ���.';
      END IF;
    END IF;

    IF ioValueEnd <> ''
    THEN
       vbDateEnd := date_trunc('DAY', vbDate) + ((ioTypeId - 1)::TVarChar||' DAY')::interval + ioValueEnd::Time;

      IF date_part('minute',  vbDateEnd) not in (0, 30)
      THEN
        RAISE EXCEPTION '������. ���� ������� � ����� ������ ���� ������ 30 ���.';
      END IF;
    END IF;
      
    IF ioValueStart <> '' and ioValueEnd <> '' and vbDateStart > vbDateEnd
    THEN
      vbDateEnd := vbDateEnd + interval '1 day';
    END IF;
    
    -- ��������� ������ ���� ����
    IF COALESCE(ioId, 0) = 0 
    THEN
      ioId := lpInsertUpdate_MovementItem_EmployeeSchedule (ioId                  := ioId                  -- ���� ������� <������� �������>
                                                          , inMovementId          := inMovementId          -- ���� ���������
                                                          , inPersonId            := inUserId              -- ���������
                                                          , inComingValueDay      := ''                    -- ������� �� ������ �� ����
                                                          , inComingValueDayUser  := ''                    -- ������� �� ������ �� ����
                                                          , inUserId              := vbUserId              -- ������������
                                                            );
    ELSEIF vbUnitID <> 0 AND
           COALESCE((SELECT COALESCE (MovementItemLinkObject.ObjectId, 0) 
                     FROM MovementItemLinkObject 
                     WHERE MovementItemLinkObject.MovementItemId = ioId
                       AND MovementItemLinkObject.DescId = zc_MILinkObject_Unit())) = 0
    THEN
       -- ��������� ����� � <��������������>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, vbUnitID);    
    END IF;
    
    IF EXISTS(SELECT ID
              FROM MovementItem
              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.ParentID = ioId
                AND MovementItem.Amount = ioTypeId
                AND MovementItem.DescId = zc_MI_Child())
    THEN
       SELECT ID
       INTO vbParentId
       FROM MovementItem
       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.ParentID = ioId
         AND MovementItem.Amount = ioTypeId
         AND MovementItem.DescId = zc_MI_Child();
    END IF;

    IF COALESCE(vbParentId, 0) <> 0 AND COALESCE ((SELECT ObjectId FROM MovementItem WHERE ID = vbParentId), 0) <> 0
    THEN
       SELECT ObjectId 
       INTO vbUnitID
       FROM MovementItem WHERE ID = vbParentId;
    END IF;    
    
    IF ioValue <> '' AND 
       EXISTS(SELECT ValueData FROM ObjectString AS PayrollType_ShortName
              WHERE PayrollType_ShortName.ValueData = ioValue
                AND PayrollType_ShortName.DescId = zc_ObjectString_PayrollType_ShortName())
    THEN
      SELECT ObjectId 
      INTO vbPayrollType
      FROM ObjectString AS PayrollType_ShortName
      WHERE PayrollType_ShortName.ValueData = ioValue
        AND PayrollType_ShortName.DescId = zc_ObjectString_PayrollType_ShortName();
    ELSE
      vbPayrollType := 0;
    END IF;
    
    --RAISE EXCEPTION '������. � ���������� % % % % % %', vbParentId, vbUnitID, ioTypeId, vbPayrollType, vbDateStart, vbDateEnd;
        
    -- ���������
    vbParentId := lpInsertUpdate_MovementItem_EmployeeSchedule_Child (ioId                  := vbParentId            -- ���� ������� <������� ���������>
                                                                    , inMovementId          := inMovementId          -- ���� ���������
                                                                    , inParentId            := ioId                  -- ������� ������
                                                                    , inUnitID              := vbUnitID              -- �������������
                                                                    , inAmount              := ioTypeId              -- ����
                                                                    , inPayrollTypeID       := vbPayrollType         -- ��� ���
                                                                    , inDateStart           := vbDateStart           -- ������� �� ������ �� ����
                                                                    , inDateEnd             := vbDateEnd             -- ������� �� ������ �� ����
                                                                    , inUserId              := vbUserId              -- ������������
                                                                     );

    --
    IF ioTypeId > 0
    THEN
       SELECT PayrollType_ShortName.ValueData                                              AS PThortName
            , TO_CHAR(MIDate_Start.ValueData, 'HH24:mi')                                   AS TimeStart
            , TO_CHAR(MIDate_End.ValueData, 'HH24:mi')                                     AS TimeEnd
       INTO ioValue, ioValueStart, ioValueEnd 

       FROM  MovementItem AS MIChild

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PayrollType
                                             ON MILinkObject_PayrollType.MovementItemId = MIChild.Id
                                            AND MILinkObject_PayrollType.DescId = zc_MILinkObject_PayrollType()

            LEFT JOIN ObjectString AS PayrollType_ShortName
                                   ON PayrollType_ShortName.ObjectId = MILinkObject_PayrollType.ObjectId
                                  AND PayrollType_ShortName.DescId = zc_ObjectString_PayrollType_ShortName()

            LEFT JOIN MovementItemDate AS MIDate_Start
                                       ON MIDate_Start.MovementItemId = MIChild.Id
                                      AND MIDate_Start.DescId = zc_MIDate_Start()

            LEFT JOIN MovementItemDate AS MIDate_End
                                       ON MIDate_End.MovementItemId = MIChild.Id
                                      AND MIDate_End.DescId = zc_MIDate_End()

       WHERE MIChild.ID = vbParentId;
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
22.05.19                                                        *
13.03.19                                                        *
11.12.18                                                        *
09.12.18                                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_EmployeeScheduleNew (, inSession:= '2')

