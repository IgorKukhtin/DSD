-- Function: gpInsertUpdateMobile_MovementItem_Task()

DROP FUNCTION IF EXISTS gpInsertUpdateMobile_MovementItem_Task (Integer, Integer, Boolean, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdateMobile_MovementItem_Task(
    IN inId         Integer   , -- ���������� ������������� ����������� � ������� ��, � ������������ ��� �������������
    IN inMovementId Integer   , -- ���������� ������������� ���������
    IN inClosed     Boolean   , -- ��������� (��/���)
    IN inComment    TVarChar  , -- ����������. ��������� ��������, ����� ����������/�� ���������� �������
    IN inUpdateDate TDateTime , -- ����/����� ����� �������� ������� ����������/�� ���������� �������
    IN inSession    TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      -- testm
      IF vbUserId = 1123966 -- testm
      THEN
          RAISE EXCEPTION '������.��� ����.';
      END IF;


      -- ��������� ������������� �������
      SELECT MI_Task.Id
      INTO vbId
      FROM Movement AS Movement_Task
           JOIN MovementItem AS MI_Task
                             ON MI_Task.MovementId = Movement_Task.Id
                            AND MI_Task.DescId = zc_MI_Master()
                            AND MI_Task.Id = inId
      WHERE Movement_Task.DescId = zc_Movement_Task()
        AND Movement_Task.Id = inMovementId;

      IF COALESCE (vbId, 0) = 0
      THEN
           RAISE EXCEPTION '������. ������� �� ��������.';
      END IF;

      -- ��������� �������� <��������� (��/���)>
      PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Close(), vbId, inClosed);

      -- ��������� �������� <����������>
      PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), vbId, inComment);

      -- ��������� �������� <����/����� ���������� �������>
      PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_UpdateMobile(), vbId, inUpdateDate);

      -- ��������� �������� < ����/����� ����� ����������� �������� � ��� ���� >
      PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), vbId, CURRENT_TIMESTAMP);


      RETURN vbId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 03.04.17                                                         *
*/

-- ����
-- SELECT * FROM gpInsertUpdateMobile_MovementItem_Task (inId:= 71885005, inMovementId:= 5285630, inClosed:= true, inComment:= '� ������, �� ������', inUpdateDate:= CURRENT_TIMESTAMP, inSession:= zfCalc_UserAdmin())
