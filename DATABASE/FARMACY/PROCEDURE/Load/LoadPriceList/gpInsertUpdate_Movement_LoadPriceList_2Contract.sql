-- Function: gpInsertUpdate_Movement_LoadPriceList_2Contract()

-- DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_LoadPriceList_2Contract (Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, TDateTime, TVarChar, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_LoadPriceList_2Contract (Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, TDateTime, TVarChar, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_LoadPriceList_2Contract(
    IN inJuridicalId         Integer   , -- ����������� ����
    IN inContractId1         Integer   , -- �������
    IN inContractId2         Integer   , -- �������
    IN inAreaId              Integer   , -- ������
    IN inCommonCode          Integer   , 
    IN inBarCode             TVarChar  , 
    IN inGoodsCode           TVarChar  , 
    IN inGoodsName           TVarChar  , 
    IN inGoodsNDS            TVarChar  , 
    IN inPrice1              TFloat    ,  
    IN inPrice2              TFloat    ,  
    IN inRemains             TFloat    ,  
    IN inExpirationDate      TDateTime , -- ���� ��������
    IN inPackCount           TVarChar  ,  
    IN inProducerName        TVarChar  , 
    IN inNDSinPrice          Boolean   ,
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

	
    -- ����� �� ���������
    IF COALESCE (inPrice1, 0) = 0 AND COALESCE (inPrice2, 0) = 0 THEN 
        RETURN;
    END IF;
  
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
  

    -- ��������� - inContractId1 and inPrice1
    PERFORM lpInsertUpdate_Movement_LoadPriceList_Contract (inJuridicalId   := inJuridicalId
                                                          , inContractId    := inContractId1
                                                          , inAreaId        := inAreaId
                                                          , inCommonCode    := inCommonCode
                                                          , inBarCode       := inBarCode
                                                          , inGoodsCode     := inGoodsCode
                                                          , inGoodsName     := inGoodsName
                                                          , inGoodsNDS      := inGoodsNDS
                                                          , inPrice         := inPrice1
                                                          , inRemains       := inRemains
                                                          , inExpirationDate:= inExpirationDate
                                                          , inPackCount     := inPackCount
                                                          , inProducerName  := inProducerName
                                                          , inNDSinPrice    := inNDSinPrice
                                                          , inUserId        := vbUserId
                                                           );
  

    -- ��������� - inContractId2 and inPrice2
    PERFORM lpInsertUpdate_Movement_LoadPriceList_Contract (inJuridicalId   := inJuridicalId
                                                          , inContractId    := inContractId2
                                                          , inAreaId        := inAreaId
                                                          , inCommonCode    := inCommonCode
                                                          , inBarCode       := inBarCode
                                                          , inGoodsCode     := inGoodsCode
                                                          , inGoodsName     := inGoodsName
                                                          , inGoodsNDS      := inGoodsNDS
                                                          , inPrice         := inPrice2
                                                          , inRemains       := inRemains
                                                          , inExpirationDate:= inExpirationDate
                                                          , inPackCount     := inPackCount
                                                          , inProducerName  := inProducerName
                                                          , inNDSinPrice    := inNDSinPrice
                                                          , inUserId        := vbUserId
                                                           );

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 10.12.2016                                      *
 14.03.2016                                      * all
 07.10.2015                                                                    *�������� ����� � 2 ������
 17.02.15                        *   ����� ����� �� ������. 
 11.11.14                        *   
 28.10.14                        *   
 22.10.14                        *   ������� ����������� ������
 18.09.14                        *  
*/
