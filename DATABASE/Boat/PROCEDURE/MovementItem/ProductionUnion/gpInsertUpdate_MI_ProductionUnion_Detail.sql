-- Function: gpInsertUpdate_MI_ProductionUnion_Detail()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Detail(Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Detail(Integer, Integer, Integer, Integer, TVarChar, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionUnion_Detail(
 INOUT ioId                     Integer   , -- ���� ������� <������� ���������>  
    IN inParentId               Integer   , -- 
    IN inMovementId             Integer   , -- ���� ������� <��������>
    --IN inReceiptServiceId       Integer   , -- ������
    IN inPersonalId             Integer   , -- ���������
    IN inReceiptServiceName     TVarChar  ,
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
   DECLARE vbReceiptServiceId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_ProductionUnion());
     vbUserId := lpGetUserBySession (inSession);
     
     -- ��������
     IF COALESCE (inReceiptServiceName,'') = ''
     THEN
         RETURN;
     END IF;

     --������� ������, ���� ����� ���, ����� ���������
     vbReceiptServiceId := (SELECT Object.Id FROM Object WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inReceiptServiceName)) AND Object.DescId = zc_Object_ReceiptService()); 
     IF COALESCE (vbReceiptServiceId,0) = 0
     THEN
         --�������
         SELECT tmp.ioId
        INTO vbReceiptServiceId
         FROM gpInsertUpdate_Object_ReceiptService(ioId        := 0                           ::  Integer       -- ���� ������� < >
                                                 , ioCode      := 0                           ::  Integer       -- ��� ������� < >
                                                 , inName      := TRIM (inReceiptServiceName) ::  TVarChar      -- �������� ������� <>
                                                 , inArticle   := NULL                        ::  TVarChar      -- 
                                                 , inComment   := NULL                        ::  TVarChar      -- ������� ��������
                                                 , inTaxKindId := zc_Enum_TaxKind_Basis()     ::  Integer       -- ���
                                                 , inEKPrice   := 0                           ::  TFloat        -- ��. ���� ��� ���
                                                 , inSalePrice := ioOperPrice                 ::  TFloat        -- ���� ������� ��� ���
                                                 , inSession   := inSession
                                                  ) AS tmp    
         ;
     END IF;

     -- ����� ������ �����, ���� ���������� zc_ObjectLink_ReceiptService_Partner, EKPrice ������ �������� � zc_MIFloat_Summ ����� ������ �������� � zc_MIFloat_OperPrice
     IF EXISTS (SELECT 1
                FROM MovementItem AS tmp
                     INNER JOIN ObjectLink AS ObjectLink_Partner
                                           ON ObjectLink_Partner.ObjectId = tmp.ObjectId
                                          AND ObjectLink_Partner.DescId = zc_ObjectLink_ReceiptService_Partner()
                WHERE tmp.Id = ioId
                )
     THEN 
         vb ObjectFloat AS ObjectFloat_EKPrice
                                  ON ObjectFloat_EKPrice.ObjectId = Object_ReceiptService.Id
                                 AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_ReceiptService_EKPrice()
     END IF;
     
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
     FROM lpInsertUpdate_MI_ProductionUnion_Detail (ioId
                                                , inParentId
                                                , inMovementId
                                                , vbReceiptServiceId
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
 04.01.23         *
*/

-- ����
--