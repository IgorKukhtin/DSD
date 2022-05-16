-- Function: gpCheckDesc_Object_Goods()


DROP FUNCTION IF EXISTS gpCheckDesc_Object_Goods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpCheckDesc_Object_Goods(
    IN inId               Integer,
    IN inSession          TVarChar     -- ������ ������������
)
RETURNS VOID

AS
$BODY$
BEGIN

    
    -- �������� ���� ��������� ������ ��������������� ������ �������� ��������� 
    IF (select DescId from Object where Id = inId) <> zc_Object_Goods()
    THEN
        RAISE EXCEPTION '������.�������� ��� ��������.';
    END IF;   

END;
$BODY$
LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.05.22         *
*/

-- SELECT * from gpCheckDesc_Object_Goods (214633,'5')