-- Function: gpInsert_Movement_Sale_FileName()

DROP FUNCTION IF EXISTS gpInsert_Movement_Sale_FileName (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_FileName(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inMovementId         Integer,    -- Id ���������
    IN inSession            TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId   Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
      vbUserId:= lpGetUserBySession (inSession);

      gpGet_Movement_VNscv_FileName
      -- ��������� �������� <>
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_FileName()
                                           , inMovementId
                                           , gpGet_Movement_VN_scv_FileName (inStartDate, inEndDate, inMovementId, inSession)
                                            ||' '
                                            ||(SELECT zfConvert_FIO(ValueData, 2, TRUE) FROM Object WHERE Id = vbUserId) ::TVarChar 
                                           );

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.08.25         *
*/

-- ����
--