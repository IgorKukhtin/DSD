-- Function: gpGet_Movement_CheckState()

DROP FUNCTION IF EXISTS gpGet_Movement_CheckState (Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpGet_Movement_CheckState (Integer, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpGet_Movement_CheckState (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_CheckState(
    IN inMovementId        Integer  , -- ���� ���������
   OUT outState            Integer  , -- ��������� ���������
    in userSession	   TVarChar , -- ������ ������������ (��������� ��������)
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS Integer
AS
$BODY$
BEGIN
    if coalesce(userSession, '') <> '' then 
     inSession := userSession;
    end if;

    SELECT
        Object.ObjectCode
    INTO
        outState
    FROM Movement
        Inner Join Object ON Movement.StatusId = Object.ID
    WHERE Movement.Id =  inMovementId;

    IF outState is null THEN
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_Check (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 23.05.15                         *                 
*/

-- ����
-- SELECT * FROM gpGet_Movement_Check (inMovementId:= 1, inSession:= '9818')