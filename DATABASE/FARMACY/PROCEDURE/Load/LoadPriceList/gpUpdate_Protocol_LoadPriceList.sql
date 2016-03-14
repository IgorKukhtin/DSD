
DROP FUNCTION IF EXISTS gpUpdate_Protocol_LoadPriceList (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Protocol_LoadPriceList(
    IN inImportSettingsId    Integer   , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
 
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);
	
 
  IF EXISTS (SELECT OL_ImportType.ChildObjectId 
             FROM ObjectLink AS OL_ImportType
             WHERE OL_ImportType.DescId = zc_ObjectLink_ImportSettings_ImportType()
               AND OL_ImportType.ChildObjectId in (134886, 977296)                       -- "�������� �������", "�������� ������� �� 2-� ����������"
               AND OL_ImportType.ObjectId = inImportSettingsId)
  THEN

        UPDATE LoadPriceList SET UserId_Insert = vbUserId
                               , Date_Insert = CURRENT_TIMESTAMP
        WHERE Id in (SELECT LoadPriceList.Id
                     FROM Object_ImportSettings_View
                        INNER JOIN LoadPriceList ON OperDate = CURRENT_DATE
                                                AND LoadPriceList.JuridicalId = Object_ImportSettings_View.JuridicalId
                                                AND LoadPriceList.ContractId  = Object_ImportSettings_View.ContractId
                     WHERE Object_ImportSettings_View.id = inImportSettingsId) ;
  END IF;


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.03.15         *
*/


--select * from gpUpdate_Protocol_LoadPriceList(inImportSettingsId := 400994 ,  inSession := '3');