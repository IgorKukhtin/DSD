-- Function: lpSetErased_Movement (Integer, Integer)

DROP FUNCTION IF EXISTS lpSetErased_Movement (Integer, Integer);

CREATE OR REPLACE FUNCTION lpSetErased_Movement(
    IN inMovementId        Integer  , -- ���� ������� <��������>
    IN inUserId            Integer    -- ������������
)                              
  RETURNS VOID
AS
$BODY$
  DECLARE vbStatusId_old Integer;
  DECLARE vbOperDate     TDateTime;
  DECLARE vbDescId       Integer;
  DECLARE vbAccessKeyId  Integer;
BEGIN

  -- 0. ��������
  IF COALESCE (inMovementId, 0) = 0
  THEN
      RAISE EXCEPTION '������.�������� �� ��������.';
  END IF;

  -- 1.0.
  vbStatusId_old:= (SELECT StatusId FROM Movement WHERE Id = inMovementId);

  -- 1.1. �������� �� "�������������" / "��������"
  --IF vbStatusId_old = zc_Enum_Status_Complete() THEN PERFORM lpCheck_Movement_Status (inMovementId, inUserId); END IF;

  -- 1.2. ����������� ������ ������ ���������
  UPDATE Movement SET StatusId = zc_Enum_Status_Erased() WHERE Id = inMovementId
  RETURNING OperDate, DescId, AccessKeyId INTO vbOperDate, vbDescId, vbAccessKeyId;


  -- 1.3. �������� - �������� ������ + �������� ������������
  IF vbStatusId_old = zc_Enum_Status_Complete() --AND inMovementId <> 309030
  THEN 
      IF (inUserId > 0 OR (vbOperDate < '01.02.2022' AND vbDescId NOT IN (zc_Movement_Service(), zc_Movement_ServiceItemAdd())))
     AND (inUserId > 0 OR vbDescId <> zc_Movement_Cash())
      THEN
          PERFORM lpCheckPeriodClose (inOperDate      := vbOperDate
                                    , inMovementId    := inMovementId
                                    , inMovementDescId:= vbDescId
                                    , inAccessKeyId   := vbAccessKeyId
                                    , inUserId        := inUserId
                                     );
      END IF;
  END IF;


  -- 3.1. ������� ��� ��������
  PERFORM lpDelete_MovementItemContainer (inMovementId);


  -- 4. ��������� ��������
  PERFORM lpInsert_MovementProtocol (inMovementId, ABS (inUserId), FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.11.14                                        * add vbAccessKeyId
 05.09.14                                        * add lpCheck_Movement_Status
 25.05.14                                        * add �������� ���� ��� <�������� �������>
 10.05.14                                        * add �������� <���������������>
 10.05.14                                        * add lpInsert_MovementProtocol
 06.10.13                                        * add inUserId
 01.09.13                                        * add lpDelete_MovementItemReport
*/

-- ����
-- SELECT * FROM lpSetErased_Movement (inMovementId:= 55, inSession:= '2')
