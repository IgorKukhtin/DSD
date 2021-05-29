-- Function: lfGet_Object_Partner_PriceList_record (Integer, Integer, TDateTime)

DROP FUNCTION IF EXISTS lfGet_Object_Partner_PriceList_record (Integer, Integer, TDateTime);

CREATE OR REPLACE FUNCTION lfGet_Object_Partner_PriceList_record(
    IN inContractId Integer, 
    IN inPartnerId Integer,
    IN inOperDate TDateTime)
RETURNS Integer
AS
$BODY$
  DECLARE vbPriceListId Integer;
BEGIN
      SELECT PriceListId
             INTO vbPriceListId
      FROM lfGet_Object_Partner_PriceList (inContractId:= inContractId, inPartnerId:= inPartnerId, inOperDate:= inOperDate);

      RETURN vbPriceListId;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.01.15                                        *
*/

-- ����
-- SELECT * FROM lfGet_Object_Partner_PriceList_record (inContractId:= 1, inPartnerId:= 79134, inOperDate:= '20.11.2014')
