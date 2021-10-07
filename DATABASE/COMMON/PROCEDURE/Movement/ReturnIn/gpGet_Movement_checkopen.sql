-- Function: gpGet_Movement_checkopen()

DROP FUNCTION IF EXISTS gpGet_Movement_checkopen (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_checkopen(
    IN inMovementId        Integer  , -- ���� ���������
   OUT outFormName         TVarChar , --
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ReturnIn());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN
        outFormName := '';
        RAISE EXCEPTION '������.��� ��������� ��� ��������.';
     ELSE
        outFormName := (SELECT CASE WHEN Movement.DescId = zc_Movement_Sale() THEN 'TSaleForm'
                                    WHEN Movement.DescId = zc_Movement_Tax() THEN 'TTaxForm'
                               END
                        FROM Movement
                        WHERE Movement.Id = inMovementId);
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.10.21         *
*/

-- ����
--