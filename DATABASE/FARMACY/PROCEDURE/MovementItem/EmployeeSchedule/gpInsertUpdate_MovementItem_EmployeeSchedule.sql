-- Function: gpInsertUpdate_MovementItem_EmployeeSchedule()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_EmployeeSchedule(INTEGER, INTEGER, INTEGER, TVarChar, INTEGER, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_EmployeeSchedule(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inUserId              Integer   , -- ���������
 INOUT ioValue               TVarChar  , -- ����
 INOUT ioTypeId              Integer   ,
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbComingValueDay TVarChar;

   DECLARE vbValue INTEGER;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);

    -- �������� ���� ������������ �� ����� ���������
    IF 758920 <> inSession::Integer AND 4183126 <> inSession::Integer AND 9383066  <> inSession::Integer
    THEN
      RAISE EXCEPTION '��������� <������ ������ �����������> ��� ���������.';
    END IF;

    IF COALESCE (ioId, 0) <> 0
    THEN
      SELECT MovementItemString.ValueData
      INTO vbComingValueDay
      FROM MovementItemString
      WHERE MovementItemString.DescId = zc_MIString_ComingValueDay()
        AND MovementItemString.MovementItemId = ioId;
    ELSE
      vbComingValueDay := '0000000000000000000000000000000';
    END IF;

    IF COALESCE (vbComingValueDay, '') = ''
    THEN
      vbComingValueDay := '0000000000000000000000000000000';
    END IF;
    
    IF ioTypeId > 0
    THEN
      vbValue := CASE ioValue WHEN '8:00' THEN 1
                              WHEN '9:00' THEN 2
                              WHEN '10:00' THEN 3
                              WHEN '7:00' THEN 4
                              WHEN '21:00' THEN 7
                              WHEN '�' THEN 9
                              ELSE 0 END;

      vbComingValueDay := SUBSTRING(vbComingValueDay, 1, ioTypeId - 1) || vbValue::TVarChar || SUBSTRING(vbComingValueDay, ioTypeId + 1, 31);
    END IF;

    -- ���������
    ioId := lpInsertUpdate_MovementItem_EmployeeSchedule (ioId                  := ioId              -- ���� ������� <������� ���������>
                                                        , inMovementId          := inMovementId      -- ���� ���������
                                                        , inPersonId            := inUserId          -- ���������
                                                        , inComingValueDay      := vbComingValueDay  -- ������� �� ������ �� ����
                                                        , inUserId              := vbUserId          -- ������������
                                                         );

    --
    IF ioTypeId > 0
    THEN
      ioValue := lpDecodeValueDay(ioTypeId, vbComingValueDay);
    END IF;

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
11.12.18                                                        *
09.12.18                                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_EmployeeSchedule (, inSession:= '2')


