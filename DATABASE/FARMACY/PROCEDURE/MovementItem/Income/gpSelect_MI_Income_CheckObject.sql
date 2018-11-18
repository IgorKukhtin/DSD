DROP FUNCTION IF EXISTS gpSelect_MI_Income_CheckObject (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_Income_CheckObject(
    IN inMovementId          Integer   , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
BEGIN
     
     -- ��������� ��� �� ������ �����������. 
     IF EXISTS (SELECT * FROM MovementItem WHERE MovementId = inMovementId AND ObjectId IS NULL) THEN
        RAISE EXCEPTION '� ��������� ������� �� ��� ������ �����������';
     END IF;

     -- ����� ����� ��� ���� ����� ����� ���������
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.11.18         *
*/
-- select * from gpSelect_MI_Income_CheckObject (inMovementId := 11459485  ,  inSession := '3');  