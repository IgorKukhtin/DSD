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
                    WHERE JuridicalId = inJuridicalId AND OperDate = Current_Date AND COALESCE (ContractId, 0) = inContractId
                      AND Date_Insert > Current_Date
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
-- SELECT * FROM gpGet_LoadPriceList (183293, 30, '3')
