-- Function: gpInsertUpdate_MI_OrderInternal_Detail()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_OrderInternal_Detail(Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_OrderInternal_Detail(
 INOUT ioId                     Integer   , -- ���� ������� <������� ���������>  
    IN inParentId               Integer   , -- 
    IN inMovementId             Integer   , -- ���� ������� <��������>
    IN inReceiptServiceId       Integer   , -- ������
    IN inPersonalId             Integer   , -- ���������
 INOUT ioAmount                 TFloat    , -- 
 INOUT ioOperPrice              TFloat    , -- 
    IN inHours                  TFloat    , -- 
    IN inSumm                   TFloat    , -- 
    IN inComment                TVarChar  , --
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_OrderInternal());
     vbUserId := lpGetUserBySession (inSession);

     --���� ������� �����, ����� ��� � ���������� �������� � ����� (������), � OperPrice - ��������� ����� ������� = ����*���� ���� ��� ����� (����)
     IF COALESCE (inSumm,0) <> 0  
     THEN
         ioAmount := inSumm;
         ioOperPrice := CASE WHEN COALESCE (inHours,0)<>0 THEN inSumm / inHours ELSE 0 END; 
     ELSE
         ioAmount := inHours * ioOperPrice;
     END IF;
     
     -- ��������� <������� ���������>
     SELECT tmp.ioId
            INTO ioId
     FROM lpInsertUpdate_MI_OrderInternal_Detail (ioId
                                                , inParentId
                                                , inMovementId
                                                , inReceiptServiceId
                                                , inPersonalId
                                                , ioAmount 
                                                , ioOperPrice
                                                , inHours
                                                , inSumm
                                                , inComment
                                                , vbUserId
                                                ) AS tmp;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.01.23         *
*/

-- ����
--