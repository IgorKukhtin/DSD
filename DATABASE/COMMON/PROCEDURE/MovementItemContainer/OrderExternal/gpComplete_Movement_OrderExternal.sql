-- Function: gpComplete_Movement_OrderExternal()

DROP FUNCTION IF EXISTS gpComplete_Movement_OrderExternal (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_OrderExternal(
    IN inMovementId        Integer              , -- ���� ���������
   OUT outPrinted          Boolean              ,
   OUT outMessageText      Text                 ,
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_OrderExternal());


     -- ������ ������ ��������� + ��������� ��������
     SELECT tmp.outPrinted, tmp.outMessageText
            INTO outPrinted, outMessageText
     FROM lpComplete_Movement_OrderExternal (inMovementId:= inMovementId
                                           , inUserId    := vbUserId
                                            ) AS tmp;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.04.17                                        *
 25.08.14                                        *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 579, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_OrderExternal (inMovementId:= 579, inSession:= '2')
