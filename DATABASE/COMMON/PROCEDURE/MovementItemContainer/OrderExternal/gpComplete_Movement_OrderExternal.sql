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
  DECLARE vbDescId_From Integer;
BEGIN
     --�� ����� ��������� �������� ��� ��������� <�� ����>
     vbDescId_From := (SELECT Object.DescId
                       FROM MovementLinkObject AS MLO
                           LEFT JOIN Object ON Object.Id = MLO.ObjectId
                       WHERE MLO.MovementId = inMovementId 
                         AND MLO.DescId = zc_MovementLinkObject_From());

     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, CASE WHEN vbDescId_From = zc_Object_Unit() THEN zc_Enum_Process_Complete_OrderExternalUnit() ELSE zc_Enum_Process_Complete_OrderExternal() END);

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
 27.09.21         *
 21.04.17                                        *
 25.08.14                                        *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 579, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_OrderExternal (inMovementId:= 579, inSession:= '2')
