-- Function: gpUnComplete_Movement_ContractGoods (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_ContractGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_ContractGoods(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbStatusId Integer;
  DECLARE vbMovementId_last Integer;
  DECLARE vbContractId Integer;
  DECLARE vbOperDate_next TDateTime;
  DECLARE vbOperDate TDateTime;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_ContractGoods());
      vbUserId:= lpGetUserBySession (inSession);

      --���������� ���������. ����
      SELECT Movement.StatusId, Movement.OperDate
           , MovementLinkObject_Contract.ObjectId AS ContractId
    INTO vbStatusId, vbOperDate, vbContractId
      FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
      WHERE Movement.Id = inMovementId;
      
      -- ����������� ��������
      PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                   , inUserId     := vbUserId
                                    );

     --���� �������� �� ����� ��� ������� �� �������� , �� ����� � ��������� �� �����  �������� ���� ��������� , � � ������� ���� ������������ ���� ���������
     IF vbStatusId = zc_Enum_Status_Erased()
     THEN
         --������� ���������� ��������,��� ������������� ���� ��������� EndBeginDate  = inOperDate-1 ����
         vbMovementId_last:= (SELECT tmp.Id
                              FROM (SELECT Movement.Id
                                         , Movement.OperDate
                                         , MAX (Movement.OperDate) OVER () AS OperDate_last
                                    FROM Movement
                                        INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                      ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                                     AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                                     AND MovementLinkObject_Contract.ObjectId = vbContractId
                                    WHERE Movement.DescId = zc_Movement_ContractGoods()
                                       AND Movement.OperDate < vbOperDate
                                       AND Movement.StatusId <> zc_Enum_Status_Erased()  --zc_Enum_Status_Complete()
                                       AND Movement.Id <> inMovementId
                                    ) AS tmp
                              WHERE tmp.OperDate = tmp.OperDate_last
                              );
         IF COALESCE (vbMovementId_last,0) <> 0
         THEN
             -- ��������� �������� <���� ���������> ����������� ���������
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndBegin(), vbMovementId_last, (vbOperDate - interval '1 day')::TDateTime);
         END IF;

         --������� ����� ��������� ���. � �� ���� ���������� ���� ��������� �������� ��������� 
         SELECT tmp.OperDate
       INTO vbOperDate_next
         FROM (SELECT Movement.Id
                    , Movement.OperDate
                    , MIN (Movement.OperDate) OVER () AS OperDate_last
               FROM Movement
                   INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                 ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                AND MovementLinkObject_Contract.ObjectId = vbContractId
               WHERE Movement.DescId = zc_Movement_ContractGoods()
                  AND Movement.OperDate > vbOperDate
                  AND Movement.StatusId <> zc_Enum_Status_Erased()--zc_Enum_Status_Complete()
                  AND Movement.Id <> inMovementId
               ) AS tmp
         WHERE tmp.OperDate = tmp.OperDate_last;
    
         --
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndBegin(), inMovementId, CASE WHEN vbOperDate_next IS NOT NULL THEN (vbOperDate_next- interval '1 day') ELSE zc_DateEnd() END ::TDateTime);
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.06.21         *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_ContractGoods (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
