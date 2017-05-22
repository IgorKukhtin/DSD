-- Function: gpInsertUpdate_MI_ReturnIn_Child_Sybase()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ReturnIn_Child_Sybase (Integer, Integer, Integer, TFloat, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ReturnIn_Child_Sybase(
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inParentId              Integer   , -- ����
    IN inKassaId               Integer   , -- ���� ����� 
    IN inAmount                TFloat    , -- ����� ������
    IN inAmountDiscount        TFloat    , -- ����� ������
    IN inSession               TVarChar    -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbCurrencyId Integer;
   DECLARE vbisPayGRN   Boolean;
   DECLARE vbisPayUSD   Boolean;
   DECLARE vbisPayEUR   Boolean;
   DECLARE vbisPayCard  Boolean;
   DECLARE vbisDiscount Boolean;

   DECLARE vbAmountGRN      TFloat;
   DECLARE vbAmountUSD      TFloat;
   DECLARE vbAmountEUR      TFloat;
   DECLARE vbAmountCard     TFloat;



BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale());

       SELECT
             Object_Currency.Id           AS CurrencyId
       INTO vbCurrencyId     
       FROM Object AS Object_Cash
            LEFT JOIN ObjectLink AS ObjectLink_Cash_Currency
                                 ON ObjectLink_Cash_Currency.ObjectId = Object_Cash.Id
                                AND ObjectLink_Cash_Currency.DescId = zc_ObjectLink_Cash_Currency()
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = ObjectLink_Cash_Currency.ChildObjectId

       WHERE Object_Cash.Id = inKassaId;

     IF Coalesce(vbCurrencyId,0) = zc_Currency_GRN()  then 
       vbisPayGRN  = TRUE;
       vbAmountGRN = inAmount; 
     END IF;  
     IF Coalesce(vbCurrencyId,0) = zc_Currency_USD()  then 
       vbisPayUSD  = TRUE;
       vbAmountUSD = inAmount; 
     END IF;  
     IF Coalesce(vbCurrencyId,0) = zc_Currency_EUR()  then 
       vbisPayEUR  = TRUE;
       vbAmountEUR = inAmount; 
     END IF;  


     PERFORM gpInsertUpdate_MI_ReturnIn_Child(
                                             inMovementId     :=  inMovementId       ,
                                             inParentId       :=  inParentId         ,
                                             inisPayTotal     :=  FALSE              ,
                                             inisPayGRN       :=  vbisPayGRN         ,
                                             inisPayUSD       :=  vbisPayUSD         ,
                                             inisPayEUR       :=  vbisPayEUR         ,
                                             inisPayCard      :=  vbisPayCard        ,
                                             inisDiscount     :=  vbisDiscount       ,
                                             inAmountGRN      :=  vbAmountGRN        ,
                                             inAmountUSD      :=  vbAmountUSD        ,
                                             inAmountEUR      :=  vbAmountEUR        ,
                                             inAmountCard     :=  vbAmountCard       ,
                                             inAmountDiscount :=  inAmountDiscount   ,
                                             inSession        :=  inSession           
                                             );


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 22.05.17                                                         *
*/

-- ����
-- select * from gpInsertUpdate_MI_ReturnIn_Child_Sybase()