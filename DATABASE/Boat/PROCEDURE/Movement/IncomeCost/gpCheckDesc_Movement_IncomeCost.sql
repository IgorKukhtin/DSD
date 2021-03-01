-- Function: gpCheckDesc_Movement_IncomeCost()

DROP FUNCTION IF EXISTS gpCheckDesc_Movement_IncomeCost (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpCheckDesc_Movement_IncomeCost (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpCheckDesc_Movement_IncomeCost(
    IN inDescId           Integer,
    IN inDescCode_open    TVarChar,
    IN inSession          TVarChar     -- ������ ������������
)
RETURNS VOID

AS
$BODY$
BEGIN

    
    -- �������� ���� ��������� ������ ��������������� ������ �������� ��������� 
    IF inDescId <> (select Id from MovementDesc where Code = inDescCode_open)
    THEN
        RAISE EXCEPTION '������.�������� ��� ���������.';
    END IF;   

END;
$BODY$
LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.01.19         *
*/

--select * from gpCheckDesc_Movement_IncomeCost(inDescId := 25 , inDescCode_open := 'zc_Movement_TransportService()' ,  inSession := '5');

