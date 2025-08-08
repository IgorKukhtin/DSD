-- Function: gpInsert_Movement_Sale_FileName()

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

      -- ��������� �������� <>
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_FileName()
                                           , inMovementId
                                           , inFileName ::TVarChar 
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