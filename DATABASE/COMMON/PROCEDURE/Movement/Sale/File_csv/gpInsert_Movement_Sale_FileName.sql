-- Function: gpInsert_Movement_Sale_FileName()

DROP FUNCTION IF EXISTS gpInsert_Movement_Sale_FileName (TDateTime, TDateTime, Integer, TVarChar);
--   gpInsert_Movement_FileName
DROP FUNCTION IF EXISTS gpInsert_Movement_Sale_FileName (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Sale_FileName(
    IN inMovementId         Integer   , -- Id ���������
    IN inFileName           TVarChar  ,
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
                                           , inFileName
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