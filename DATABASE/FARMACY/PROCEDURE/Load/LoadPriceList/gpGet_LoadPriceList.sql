-- Function: gpGet_LoadPriceList()

DROP FUNCTION IF EXISTS gpGet_LoadPriceList (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_LoadPriceList(
   OUT outId           Integer ,   -- 
    IN inJuridicalId   Integer ,   -- 
    IN inContractId    Integer ,   -- 
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

 outId:= COALESCE ((SELECT Id
                    FROM LoadPriceList
                    WHERE JuridicalId = inJuridicalId AND OperDate = CURRENT_DATE AND (COALESCE (ContractId, 0) = inContractId OR inContractId = 0)
                      -- AND Date_Insert > CURRENT_DATE
                    LIMIT 1
                   ), 0);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 12.03.16                                        *

*/

-- ����
-- SELECT * FROM gpGet_LoadPriceList (59610, 183275, '3')
