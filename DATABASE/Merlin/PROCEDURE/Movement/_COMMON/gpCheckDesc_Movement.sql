-- Function: gpCheckDesc_Movement()

DROP FUNCTION IF EXISTS gpCheckDesc_Movement (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpCheckDesc_Movement(
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
 10.06.22         *
*/

--select * from gpCheckDesc_Movement(inDescId := 25 , inDescCode_open := 'zc_Movement_TransportService()' ,  inSession := '5');

