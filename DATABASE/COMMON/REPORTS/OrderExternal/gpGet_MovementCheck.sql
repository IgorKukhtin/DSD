-- Function: gpGet_MovementCheck()

DROP FUNCTION IF EXISTS gpGet_MovementCheck (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MovementCheck(
    IN inMovementId         Integer   , 
    IN inSession            TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer; 
BEGIN

     -- ��������
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�������� �� ���������.';
     END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.06.22         *
*/

-- ����
--