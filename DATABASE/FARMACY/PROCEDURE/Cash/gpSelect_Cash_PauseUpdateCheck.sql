-- Function: gpSelect_Cash_PauseUpdateCheck()

DROP FUNCTION IF EXISTS gpSelect_Cash_PauseUpdateCheck (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Cash_PauseUpdateCheck(
   OUT outisPause      Boolean,    -- �����
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS BOOLEAN AS
$BODY$
BEGIN

    IF COALESCE((SELECT count(*) as CountProc
                 FROM pg_stat_activity
                 WHERE state = 'active'
                   AND (query ilike '%gpInsertUpdate_Movement_Check%'
                    OR  query ilike '%gpInsertUpdate_MovementItem_Check%'
                    OR  query ilike '%gpComplete_Movement_Check_ver2_NoDiff%')), 0) > 7
    THEN
      outisPause := True;
    ELSE
      outisPause := False;
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Cash_PauseUpdateCheck (TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 10.12.20                                                       *
*/

-- ����
--
SELECT * FROM gpSelect_Cash_PauseUpdateCheck ('3')