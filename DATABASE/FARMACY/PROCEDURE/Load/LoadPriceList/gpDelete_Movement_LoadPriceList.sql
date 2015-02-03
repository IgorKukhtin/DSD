
DROP FUNCTION IF EXISTS gpDelete_Movement_LoadPriceList 
          (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_Movement_LoadPriceList(
    IN inPriceListId         Integer   , 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
BEGIN
	
  DELETE FROM LoadPriceListItem WHERE LoadPriceListId = inPriceListId;

  DELETE FROM LoadPriceList WHERE Id = inPriceListId;
   
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 03.02.15                        *   
*/
