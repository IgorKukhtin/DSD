-- Function: gpInsertUpdate_Movement_LoadPriceList()

-- DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_LoadPriceList  (Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TDateTime, TVarChar, TVarChar,  Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_LoadPriceList  (Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TDateTime, TVarChar, TVarChar,  Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_LoadPriceList  (Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TDateTime, TVarChar, TVarChar,  Boolean, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_LoadPriceList(
    IN inJuridicalId         Integer   , -- ����������� ����
    IN inContractId          Integer   , -- �������
    IN inAreaId              Integer   , -- ������
    IN inCommonCode          Integer   , 
    IN inBarCode             TVarChar  , 
    IN inGoodsCode           TVarChar  , 
    IN inGoodsName           TVarChar  , 
    IN inGoodsNDS            TVarChar  , 
    IN inPrice               TFloat    ,  
    IN inRemains             TFloat    ,  
    IN inExpirationDate      TDateTime , -- ���� ��������
    IN inPackCount           TVarChar  ,  
    IN inProducerName        TVarChar  , 
    IN inNDSinPrice          Boolean   ,
    IN inCodeUKTZED          TVarChar  ,
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
   IF COALESCE (inPrice, 0) = 0 THEN 
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
                                     AND COALESCE (ContractId, 0) = inContractId
                                     AND OperDate < CURRENT_DATE
                                     AND COALESCE (AreaId, 0)  = COALESCE (inAreaId, 0)
     );
   -- !!!��������!!! ���������� ������ - �����
   DELETE FROM LoadPriceList WHERE Id IN
     (SELECT Id FROM LoadPriceList WHERE JuridicalId = inJuridicalId
                                     AND COALESCE (ContractId, 0) = inContractId
                                     AND OperDate < CURRENT_DATE
                                     AND COALESCE (AreaId, 0)  = COALESCE (inAreaId, 0)
     );


   -- !!!��������-2!!! ���������� ������ - ��������
   DELETE FROM LoadPriceListItem WHERE LoadPriceListId IN
     (SELECT Id FROM LoadPriceList WHERE JuridicalId = inJuridicalId
                                     AND COALESCE (ContractId, 0) = inContractId
                                     AND OperDate < CURRENT_DATE
                                     AND COALESCE (AreaId, 0)  = 0
                                     AND inAreaId > 0
     );
   -- !!!��������-2!!! ���������� ������ - �����
   DELETE FROM LoadPriceList WHERE Id IN
     (SELECT Id FROM LoadPriceList WHERE JuridicalId = inJuridicalId
                                     AND COALESCE (ContractId, 0) = inContractId
                                     AND OperDate < CURRENT_DATE
                                     AND COALESCE (AreaId, 0)  = 0
                                     AND inAreaId > 0
     );
   
    -- ��������� - inContractId and inPrice
    PERFORM lpInsertUpdate_Movement_LoadPriceList_Contract (inJuridicalId   := inJuridicalId
                                                          , inContractId    := inContractId
                                                          , inAreaId        := inAreaId
                                                          , inCommonCode    := inCommonCode
                                                          , inBarCode       := inBarCode
                                                          , inCodeUKTZED    := inCodeUKTZED
                                                          , inGoodsCode     := inGoodsCode
                                                          , inGoodsName     := inGoodsName
                                                          , inGoodsNDS      := inGoodsNDS
                                                          , inPrice         := inPrice
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
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 11.12.17         * add inCodeUKTZED
 10.12.2016                                      *
 14.03.2016                                      * all
 17.02.15                        *   ����� ����� �� ������. 
 11.11.14                        *   
 28.10.14                        *   
 22.10.14                        *   ������� ����������� ������
 18.09.14                        *  
*/
