-- Function: gpInsertUpdate_MovementItem_KPU()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_KPU (Integer, Integer, TFloat, Integer, Integer, Integer, TVarChar, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_KPU(
 INOUT ioId                    Integer    , -- ���� ������� <�������>
   OUT outKPU                  TFloat     , -- ���
    IN inMarkRatio             Integer    , -- ����������� ���������� ����� �� ����������
    IN inAverageCheckRatio     TFloat     , -- ����������� �� ������� ���
    IN inLateTimeRatio         Integer,
    IN inIT_ExamRatio          Integer,

    IN inComplaintsRatio       Integer,
    IN inComplaintsNote        TVarChar,

    IN inDirectorRatio         Integer,
    IN inDirectorNote          TVarChar,

    IN inSession               TVarChar     -- ������ ������������
)
RETURNS Record AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_UnnamedEnterprises());
  vbUserId := inSession;

  IF (COALESCE (ioId, 0) = 0) OR NOT EXISTS(SELECT ID FROM MovementItem WHERE MovementItem.ID = ioId)
  THEN
    RAISE EXCEPTION '������. ����� ����������� ��������� ������ ���� �������� ��� ���������� �� �������.';
  END IF;

  if (inMarkRatio > 1) OR (inMarkRatio < -1)
  THEN
    RAISE EXCEPTION '������. �������� ������������ ������ ���� � �������� �� -1 �� 1.';
  END IF;

  PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MarkRatio(), ioId, inMarkRatio);

  PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AverageCheckRatio(), ioId, inAverageCheckRatio);

  PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_LateTimeRatio(), ioId, inLateTimeRatio);

  PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_IT_ExamRatio(), ioId, inIT_ExamRatio);

  PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ComplaintsRatio(), ioId, inComplaintsRatio);

  PERFORM lpInsertUpdate_MovementItemString (zc_MIString_ComplaintsNote(), ioId, inComplaintsNote);

  PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_DirectorRatio(), ioId, inDirectorRatio);

  PERFORM lpInsertUpdate_MovementItemString (zc_MIString_DirectorNote(), ioId, inDirectorNote);

  PERFORM lpUpdate_MovementItem_KPU (ioId);

  SELECT
    Amount
  INTO
    outKPU
  FROM MovementItem
  WHERE MovementItem.ID = ioId;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������ �.�.
 05.10.18         *
*/