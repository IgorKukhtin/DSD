-- Function: gpSetErased_Movement_ContractGoods (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_ContractGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_ContractGoods(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_ContractGoods());

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);
     
     --������ ���� ��������� � �����������
     --������� ���������� ��������,��� ������������� ���� ��������� EndBeginDate  = inOperDate-1 ����
     vbMovementId_last:= (SELECT tmp.Id
                          FROM (SELECT Movement.Id
                                     , Movement.OperDate
                                     , MAX (Movement.OperDate) OVER () AS OperDate_last
                                FROM Movement
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                  ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                                                 AND MovementLinkObject_Contract.ObjectId = inContractId
                                WHERE Movement.DescId = zc_Movement_ContractGoods()
                                   AND Movement.OperDate < inOperDate
                                   AND Movement.StatusId <> zc_Enum_Status_Erased()  --zc_Enum_Status_Complete()
                                   AND Movement.Id <> inMovementId
                                ) AS tmp
                          WHERE tmp.OperDate = tmp.OperDate_last
                          );
     
     --������� ����� ��������� ���.
     SELECT tmp.Id
          , tmp.OperDate
   INTO vbMovementId_next, vbOperDate_next
     FROM (SELECT Movement.Id
                , Movement.OperDate
                , MIN (Movement.OperDate) OVER () AS OperDate_last
           FROM Movement
               INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                             ON MovementLinkObject_Contract.MovementId = Movement.Id
                                            AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                            AND MovementLinkObject_Contract.ObjectId = inContractId
           WHERE Movement.DescId = zc_Movement_ContractGoods()
              AND Movement.OperDate > inOperDate
              AND Movement.StatusId <> zc_Enum_Status_Erased()--zc_Enum_Status_Complete()
              AND Movement.Id <> inMovementId
           ) AS tmp
     WHERE tmp.OperDate = tmp.OperDate_last;
     
     --
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndBegin(), vbMovementId_last, CASE WHEN COALESCCE (vbMovementId_next,0) <> 0 THEN (vbOperDate_next- interval '1 day') ELSE zc_DateEnd() END ::TDateTime);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.06.21         *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_ContractGoods (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
