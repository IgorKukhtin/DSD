DROP FUNCTION IF EXISTS lpComplete_Movement_Invoice (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Invoice(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbObjectId Integer;
BEGIN

     -- �������� �� ���������
     vbObjectId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Object());

     -- ������������� VATPercent
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), inMovementId, COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0))
     FROM ObjectLink AS ObjectLink_TaxKind
          LEFT JOIN Object ON Object.Id = ObjectLink_TaxKind.ObjectId
          LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_TaxKind.ChildObjectId 
                               AND ObjectFloat_TaxKind_Value.DescId   = zc_ObjectFloat_TaxKind_Value()   
     WHERE ObjectLink_TaxKind.ObjectId = vbObjectId
       AND ObjectLink_TaxKind.DescId   = CASE WHEN Object.Id = zc_Objec_Partner() THEN zc_ObjectLink_Partner_TaxKind() ELSE zc_ObjectLink_Client_TaxKind() END
    ;

    -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_Invoice()
                               , inUserId     := inUserId
                                );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.02.21         *
*/