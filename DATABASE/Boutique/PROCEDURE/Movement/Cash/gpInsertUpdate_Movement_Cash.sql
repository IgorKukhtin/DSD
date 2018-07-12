-- Function: gpInsertUpdate_Movement_Cash()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Cash (Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TFloat
                                                     ,Integer, Integer, Integer, Integer, TVarChar, TVarChar);


DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Cash (Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat, TFloat
                                                     ,Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Cash(
 INOUT ioId                   Integer   , -- ���� ������� <��������>
 INOUT ioInvNumber            TVarChar  , -- ����� ���������
    IN inOperDate             TDateTime , -- ���� ���������
    IN inCurrencyPartnerValue TFloat    ,
    IN inParPartnerValue      TFloat    ,

    IN inAmountIn             TFloat    , -- ����� �������
    IN inAmountOut            TFloat    , -- ����� �������
    
    IN inCashId               Integer   , --
    IN inCurrencyId           Integer   , --
    IN inMoneyPlaceId         Integer   , --
    IN inInfoMoneyId          Integer   ,
    IN inUnitId               Integer   ,
    IN inComment              TVarChar  , -- ����������
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbAmountIn TFloat;
   DECLARE vbAmountOut TFloat;
   DECLARE vbAmountCurrency TFloat;
   DECLARE vbCurrencyValue TFloat;
   DECLARE vbParValue TFloat;   
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Cash());


     -- ������������ ���������� � ���.
     IF vbUserId = zc_User_Sybase() THEN
        -- ioInvNumber:= ioInvNumber;
        UPDATE Movement SET InvNumber = ioInvNumber WHERE Movement.Id = ioId;
        -- ���� ����� ������� �� ��� ������
        IF NOT FOUND THEN
           -- ������
           RAISE EXCEPTION '������. NOT FOUND Movement <%>', ioId;
        END IF;

        -- !!!�����!!!
        RETURN;

     ELSEIF COALESCE (ioId, 0) = 0 THEN
        ioInvNumber:= CAST (NEXTVAL ('movement_cash_seq') AS TVarChar);
     ELSEIF vbUserId = zc_User_Sybase() THEN
        ioInvNumber:= (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = ioId);
     END IF;

/*
     -- !!!����� ������ ������!!!
     IF inAmountIn <> 0 THEN
        IF inCurrencyId <> zc_Enum_Currency_Basis()
        THEN
             -- ������� �������� - ����� � ������
             vbAmountCurrency := inAmountIn;
             -- ����� � ��� - ��������� - ����� ������
             vbAmount         := CASE WHEN inAmount > 0 THEN inAmount ELSE CAST (inAmountIn * outCurrencyValue / outParValue AS NUMERIC (16, 2)) END;
             -- ��� �������� � ��� - ��������
             vbAmountIn       := vbAmount;

        ELSE -- ��� � ���
             vbAmount         := inAmountIn;
             vbAmountIn       := inAmountIn;
        END IF;

     ELSE
        IF inCurrencyId <> zc_Enum_Currency_Basis()
        THEN
             -- ������� �������� - ����� � ������
             vbAmountCurrency := -1 * inAmountOut;
             -- ����� � ��� - ��������� - ����� ������
             vbAmount         := -1 * CASE WHEN inAmount > 0 THEN inAmount ELSE CAST (inAmountOut * outCurrencyValue / outParValue AS NUMERIC (16, 2)) END;
             -- ��� �������� � ��� - ��������
             vbAmountOut      := ABS (vbAmount);
             
             -- !!!������������ ��� ��������!!!
             vbCurrencyValue      := inCurrencyPartnerValue;
             vbParValue           := inParPartnerValue;
          
        ELSE -- ��� � ���
             vbAmount         := -1 * inAmountOut;
             vbAmountOut      := inAmountOut;

             -- !!!������������ ��� ��������!!!
             vbCurrencyValue      := 0;
             vbParValue           := 0;
        END IF;
     END IF;

     -- ��������
     IF COALESCE (vbAmount, 0) = 0 AND inCurrencyId <> 0
     THEN
        RAISE EXCEPTION '������.����� ��������� �� ������ <%> � ������ <%> �� ������ ���� = 0.', lfGet_Object_ValueData (inCurrencyId), lfGet_Object_ValueData (zc_Enum_Currency_Basis());
     END IF;
*/
     
     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_Cash (ioId                    := ioId
                                         , inInvNumber             := ioInvNumber
                                         , inOperDate              := inOperDate
                                         , inCurrencyPartnerValue  := inCurrencyPartnerValue
                                         , inParPartnerValue       := inParPartnerValue  
            
                                         , inAmountIn              := inAmountIn
                                         , inAmountOut             := inAmountOut
                                         , inCurrencyValue         := vbCurrencyValue
                                         , inParValue              := vbParValue 
                                         
                                         , inCashId                := inCashId   
                                         , inCurrencyId            := inCurrencyId           
                                         , inMoneyPlaceId          := inMoneyPlaceId        
                                         , inInfoMoneyId           := inInfoMoneyId         
                                         , inUnitId                := inUnitId              
                                         , inComment               := inComment             
                                         , inUserId                := vbUserId
                                          );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 05.07.18         *
 */

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Cash (ioId:= 22, ioInvNumber:= '3', inOperDate:= '04.02.2018', inFromId:= 229, inToId:= 311, inCurrencyDocumentId:= zc_Currency_USD(), inComment:= 'vbn', inSession:= zfCalc_UserAdmin()));
