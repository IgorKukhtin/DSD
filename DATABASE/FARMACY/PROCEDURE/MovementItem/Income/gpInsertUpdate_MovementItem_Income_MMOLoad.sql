/*DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Income_MMOLoad 
          (Integer, TVarChar, TDateTime,
           Integer, TVarChar, TVarChar, TVarChar, 
           TFloat, TFloat,
           TDateTime, 
           TVarChar,
           TDateTime, 
           Boolean,
           TVarChar,
           TVarChar,
           Boolean,
           TVarChar); */

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Income_MMOLoad(
    IN inOKPOFrom            TVarChar  , -- ����������� ����
    IN inOKPOTo              TVarChar  , -- ����������� ����

    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inInvTaxNumber        TVarChar  , -- ����� ���������
    IN inPaymentDate         TDateTime , -- ���� ������
    IN inPriceWithVAT        Boolean   , -- �������: ���� �������� ��� ��� �� ���.���
    IN inSyncCode            Integer   , -- ��� ������ �������������

    IN inRemark              TVarChar  , -- �����������
    
    IN inGoodsCode           TVarChar  , -- ID ������
    IN inGoodsName           TVarChar  , -- ������������ ������
    IN inMakerCode           TVarChar  , -- ID �������������
    IN inMakerName           TVarChar  , -- ������������ �������������
    IN inCommonCode          Integer   , -- ID ������� (�������� ������)
    IN inVAT                 Integer   , -- ������� ���
    IN inPartitionGoods      TVarChar  , -- ����� ����� 
    IN inExpirationDate      TDateTime , -- ���� ��������
    IN inAmount              TFloat    , -- ���������� 
    IN inPrice               TFloat    , -- ���� ��������� (��� ������ ��� ����������)
    IN inFEA                 TVarChar  , -- �� ���
    IN inMeasure             TVarChar  , -- ��. ���������
    IN inSertificatNumber    TVarChar  , -- ����� �����������
    IN inSertificatStart     TDateTime , -- ���� ������ �����������
    IN inSertificatEnd       TDateTime , -- ���� ��������� �����������
    
    IN inisLastRecord        Boolean   ,
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbJuridicalId Integer;
BEGIN

     SELECT JuridicalId INTO vbJuridicalId FROM ObjectHistory_JuridicalDetails_View
            WHERE OKPO = inOKPOFrom;
  
     -- ���� �� �����, �� ����� ��������. 
     IF COALESCE(vbJuridicalId, 0) = 0 THEN
        RAISE EXCEPTION '�� ���������� ����������� ���� � ���� <%>', inOKPOFrom;
     END IF;

	
    PERFORM gpInsertUpdate_MovementItem_Income_Load(inJuridicalId := vbJuridicalId, -- ����������� ����
                                                    inInvNumber := inInvNumber  , 
                                                    inOperDate := inOperDate    , -- ���� ���������
                                                    inCommonCode := inCommonCode, 
                                                    inBarCode := ''             , 
                                                    inGoodsCode := inGoodsCode  , 
                                                    inGoodsName := inGoodsName  , 
                                                    inAmount    := inAmount     ,  
                                                    inPrice     := inPrice      ,  
                                                    inExpirationDate := inExpirationDate , -- ���� ��������
                                                    inPartitionGoods := inPartitionGoods ,   
                                                    inPaymentDate    := inPaymentDate    , -- ���� ������
                                                    inPriceWithVAT   := inPriceWithVAT   ,
                                                    inVAT            := inVAT            ,
                                                    inUnitName       := inRemark         ,
                                                    inMakerName      := inMakerName      ,
                                                    inFEA            := inFEA            , -- �� ���
                                                    inMeasure        := inMeasure        , -- ��. ���������
                                                    inSertificatNumber := inSertificatNumber, -- ����� �����������
                                                    inSertificatStart  := inSertificatStart , -- ���� ������ �����������
                                                    inSertificatEnd    := inSertificatEnd   , -- ���� ��������� �����������

                                                    inisLastRecord   := inisLastRecord  ,
                                                    inSession        := inSession);


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 01.10.15                                                                      * inSertificatNumber, inSertificatStart, inSertificatEnd
 06.03.15                        *   
 05.01.15                        *   
*/
