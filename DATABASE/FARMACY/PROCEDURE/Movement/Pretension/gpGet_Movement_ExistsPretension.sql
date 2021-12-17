-- Function: gpGet_Movement_ExistsPretension()

DROP FUNCTION IF EXISTS gpGet_Movement_ExistsPretension (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_ExistsPretension(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Pretension());
   vbUserId := inSession;

   IF COALESCE (inMovementId, 0) = 0
   THEN
     RAISE EXCEPTION '������. ��������� �� ������� ��� ������.';
   END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_ExistsPretension (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.12.21                                                       *
*/

-- ����
-- 
select * from gpGet_Movement_ExistsPretension(inMovementId := 0 ,  inSession := '3');

