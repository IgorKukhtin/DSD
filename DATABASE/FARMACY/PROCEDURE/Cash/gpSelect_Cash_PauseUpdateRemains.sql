-- Function: gpSelect_Cash_PauseUpdateRemains()

DROP FUNCTION IF EXISTS gpSelect_Cash_PauseUpdateRemains (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Cash_PauseUpdateRemains(
   OUT outisPause      Boolean,    -- �����
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS BOOLEAN AS
$BODY$
BEGIN

    IF COALESCE((SELECT count(*) as CountProc
                 FROM pg_stat_activity
                 WHERE state = 'active'
                   AND (query ilike '%gpSelect_CashRemains_ver2%'
                    OR  query ilike '%gpSelect_CashRemains_Diff_ver2%'
                    OR  query ilike '%gpSelect_CashGoodsToExpirationDate%'
                    OR  query ilike '%gpSelect_CashGoods%')), 0) > 7
    THEN
      outisPause := True;
    ELSE
      outisPause := False;
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Cash_PauseUpdateRemains (TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 10.12.20                                                       *
*/

-- ����
--
SELECT * FROM gpSelect_Cash_PauseUpdateRemains ('3')