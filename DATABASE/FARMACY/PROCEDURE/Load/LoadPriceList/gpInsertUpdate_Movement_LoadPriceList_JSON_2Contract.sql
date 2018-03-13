-- Function: gpInsertUpdate_Movement_LoadPriceList_JSON_2Contract()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_LoadPriceList_JSON_2Contract (Integer, Integer, Integer, Integer, Boolean, Text, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_LoadPriceList_JSON_2Contract(
    IN inJuridicalId         Integer   , -- ����������� ����
    IN inContractId1         Integer   , -- �������
    IN inContractId2         Integer   , -- �������
    IN inAreaId              Integer   , -- ������
    IN inNDSinPrice          Boolean   , -- ���� � ���
    IN inJSON                Text      , -- json 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
    vbUserId:= lpGetUserBySession (inSession);
  
    -- �������� 
    IF COALESCE (inJuridicalId, 0) = 0 THEN 
        RAISE EXCEPTION '�� ����������� �������� ��������� ����������� ���� (JuridicalId)';
    END IF;
    -- �������� ��� �������� ���� �� ���� � �� �������
    IF (SELECT DescId FROM Object WHERE Id = inJuridicalId) <> zc_Object_Juridical() THEN
        RAISE EXCEPTION '�� ��������� ���������� �������� ��������� ����������� ���� (JuridicalId)';
    END IF;
    -- �������� ��� �������� ���� ������� � �� �� ���� - ����� � lp
  

    -- !!!��������!!! ���������� ������ - ��������
    DELETE FROM LoadPriceListItem WHERE LoadPriceListId IN
      (SELECT Id FROM LoadPriceList WHERE JuridicalId = inJuridicalId
                                      AND COALESCE (ContractId, 0) IN (inContractId1, inContractId2)
                                      AND OperDate < CURRENT_DATE
                                      AND COALESCE (AreaId, 0)  = COALESCE (inAreaId, 0)
      );
     -- !!!��������!!! ���������� ������ - �����
    DELETE FROM LoadPriceList WHERE Id IN
      (SELECT Id FROM LoadPriceList WHERE JuridicalId = inJuridicalId
                                      AND COALESCE (ContractId, 0) IN (inContractId1, inContractId2)
                                      AND OperDate < CURRENT_DATE
                                      AND COALESCE (AreaId, 0)  = COALESCE (inAreaId, 0)
      );
  
    -- !!!��������-2!!! ���������� ������ - ��������
    DELETE FROM LoadPriceListItem WHERE LoadPriceListId IN
      (SELECT Id FROM LoadPriceList WHERE JuridicalId = inJuridicalId
                                      AND COALESCE (ContractId, 0) IN (inContractId1, inContractId2)
                                      AND OperDate < CURRENT_DATE
                                      AND COALESCE (AreaId, 0)  = 0
                                      AND inAreaId > 0
      );
     -- !!!��������-2!!! ���������� ������ - �����
    DELETE FROM LoadPriceList WHERE Id IN
      (SELECT Id FROM LoadPriceList WHERE JuridicalId = inJuridicalId
                                      AND COALESCE (ContractId, 0) IN (inContractId1, inContractId2)
                                      AND OperDate < CURRENT_DATE
                                      AND COALESCE (AreaId, 0)  = 0
                                      AND inAreaId > 0
      );

    -- ��������� 1 ��������
    PERFORM lpInsertUpdate_Movement_LoadPriceList_JSON (inJuridicalId       := inJuridicalId
                                                          , inContractId    := inContractId1
                                                          , inAreaId        := inAreaId
                                                          , inPriceNum      := 1
                                                          , inNDSinPrice    := inNDSinPrice
                                                          , inJSON          := inJSON
                                                          , inUserId        := vbUserId
                                                           );
                                                           
    -- ��������� 2 ��������
    PERFORM lpInsertUpdate_Movement_LoadPriceList_JSON (inJuridicalId       := inJuridicalId
                                                          , inContractId    := inContractId2
                                                          , inAreaId        := inAreaId
                                                          , inPriceNum      := 2
                                                          , inNDSinPrice    := inNDSinPrice
                                                          , inJSON          := inJSON
                                                          , inUserId        := vbUserId
                                                           );

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.  ������������ �.�.
 19.02.18                                                                                     * �������� �� JSON               
 11.12.17         * inCodeUKTZED
 10.12.2016                                      *
 14.03.2016                                      * all
 07.10.2015                                                                    *�������� ����� � 2 ������
 17.02.15                        *   ����� ����� �� ������. 
 11.11.14                        *   
 28.10.14                        *   
 22.10.14                        *   ������� ����������� ������
 18.09.14                        *  
*/
